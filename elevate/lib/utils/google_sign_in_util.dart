import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/models/customer.dart';

// Sign in with Google and write the user info to the firestore database
Future<UserCredential> signInWithGoogle() async {
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

  UserCredential userCredential = await FirebaseAuth.instance
      .signInWithCredential(credential);

  // Write the user info to the firestore database
  await FirebaseFirestore.instance
      .collection('customer')
      .doc(userCredential.user?.uid)
      .set({
        'email': userCredential.user?.email,
        'firstName': userCredential.user?.displayName?.split(' ').first,
        'id': userCredential.user?.uid,
        'imageURL': userCredential.user?.photoURL,
        'lastName': userCredential.user?.displayName
            ?.split(' ')
            .skip(1)
            .join(' '),
        'loyaltyPoints': 0,
        'password': "",
        'phoneNumber': userCredential.user?.phoneNumber ?? "",
        'username': userCredential.user?.email?.split('@').first,
      });

  // Once signed in, return the UserCredential
  return userCredential;
}

// Sign out of Google
Future<void> signOutGoogle() async {
  await GoogleSignIn().signOut();
  await FirebaseAuth.instance.signOut();
}

// Set the customer object with the user info
void setCustomerInfo(UserCredential userCredential, Customer customer) {
  customer.email = userCredential.user?.email;
  customer.firstName = userCredential.user?.displayName?.split(' ').first;
  customer.lastName = userCredential.user?.displayName
      ?.split(' ')
      .skip(1)
      .join(' ');
  customer.password = "";
  customer.phoneNumber = userCredential.user?.phoneNumber ?? "";
  customer.username = userCredential.user?.email?.split('@').first;
}
