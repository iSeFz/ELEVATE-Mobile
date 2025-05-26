import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Helper to get UserCredential from Google
Future<UserCredential?> getGoogleUserCredential() async {
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

// Sign out of Google
Future<void> signOutGoogle() async {
  await GoogleSignIn().signOut();
  // await FirebaseAuth.instance.signOut();
}
