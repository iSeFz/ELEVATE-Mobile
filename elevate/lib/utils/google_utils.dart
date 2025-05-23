import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants/app_constants.dart';

// Helper to get UserCredential from Google
Future<UserCredential?> _getGoogleUserCredential() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  // Create a new credential
  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Save the user info to Firebase and return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential)
      as UserCredential?;
}

// Handles Google Sign-Up process
Future<UserCredential?> signUpWithGoogle() async {
  UserCredential? userCredential = await _getGoogleUserCredential();
  if (userCredential == null || userCredential.user == null) {
    return null;
  }

  final user = userCredential.user!;
  final isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;

  if (isNewUser) {
    // Call the dedicated API for new user registration via third-party
    await http.post(
      Uri.parse('$apiBaseURL/v1/customers/third-party-signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String?>{'uid': user.uid, 'email': user.email}),
    );
  }
  return userCredential;
}

// Sign out of Google
Future<void> signOutGoogle() async {
  await GoogleSignIn().signOut();
  // await FirebaseAuth.instance.signOut();
}
