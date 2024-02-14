import 'package:firebase_auth/firebase_auth.dart';

class UserUtils{
  static final user = FirebaseAuth.instance.currentUser!;
  static final userId = user.uid;
}