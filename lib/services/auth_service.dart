import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

ValueNotifier<AuthService> authService = ValueNotifier(AuthService());

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  // Student
  User? get currentUser => firebaseAuth.currentUser;

  // -- Students collection -- //
  CollectionReference get studentsCollection =>
      FirebaseFirestore.instance.collection('students');
  DocumentReference get studentsDoc =>
      studentsCollection.doc(currentUser!.uid);

  // Student data read
  Future<String?> get school async {
    final snapshot = await studentsDoc.get();
    return snapshot.get('school') as String?;
  }

  Future<String?> get grade async {
    final snapshot = await studentsDoc.get();
    return snapshot.get('grade') as String?;
  }
  
  // Student data write
  Future<void> setSchool({
    required String school,
  }) async {
    final docRef = studentsDoc;

    try {
      await docRef.update({'school': school});
    } catch (e) {
      throw Exception('An error occurred!');
    }
  }

  //
  //
  // --  Homework collection
  //
  //
  CollectionReference get homeworkCollection =>
      studentsDoc.collection('homework');

  Future<int> getHomeworkCount() async {
    final snapshot = await homeworkCollection.get();
    return snapshot.size;
  }

  Stream<QuerySnapshot> get allHomeworkStream {
    return homeworkCollection.orderBy('dueDate').snapshots();
  }

  Future<void> addHomework({
    required String title,
    required DateTime dueDate,
  }) async {
    await homeworkCollection.add({
      'title': title,
      'dueDate': dueDate,
      'done': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }



  // -- Operations -- //



  Future<UserCredential> signIn({
    required String email,
    required String password
  }) async {
    return await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> signUp({
    required String email,
    required String password
  }) async {
    return await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  Future<void> updateUsername({
    required String username
  }) async {
    await currentUser!.updateDisplayName(username);
    authService.value = authService.value;

  }

  Future<void> deleteAccount({
    required String email,
    required String password
  }) async {
    AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);

    await currentUser!.reauthenticateWithCredential(credential);
    await currentUser!.delete();
    await firebaseAuth.signOut();
  }
}