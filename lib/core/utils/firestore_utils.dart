import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreUtils{
  static final firestoreInstance = FirebaseFirestore.instance;
  static final firestoreUserCollection = firestoreInstance.collection('/users');
  static final firestoreChatlistsCollection = firestoreInstance.collection('/lists');
}