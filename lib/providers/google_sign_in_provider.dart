import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;
  bool isGoogleSignedIn = false;

  Future<UserCredential> loginWithGoogle() async {
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return Future.value();
    _user = googleUser;

    final _googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: _googleAuth.accessToken, idToken: _googleAuth.idToken);
    isGoogleSignedIn = await googleSignIn.isSignedIn();

    notifyListeners();
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }


  Future logout() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
}
