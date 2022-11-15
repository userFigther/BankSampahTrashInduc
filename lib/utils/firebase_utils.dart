import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseUtils {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static GoogleSignIn googleSignIn = GoogleSignIn();
  static User? currentUser = auth.currentUser;
  static FirebaseStorage storage = FirebaseStorage.instance;

  static Future setupUser(
    String email,
    String password,
    String name,
  ) async {
    UserCredential userCred = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    DocumentReference userRef =
        FirebaseFirestore.instance.collection('users').doc(userCred.user!.uid);

    await userRef.set({
      'id': userCred.user!.uid,
      'name': name,
      'email': email,
      'phone': '',
      'address': '',
      'exp': 0,
      'balance': 0,
      'role': 'user',
      'membership': 'bronze',
      'photoUrl': '',
      'postalCode': '',
    });
    return;
  }

  static Future setupUserForGoogle() async {
    String uid = currentUser!.uid.toString();

    DocumentReference userRef =
        FirebaseFirestore.instance.collection('users').doc(uid);

    await userRef.set({
      'id': currentUser!.uid,
      'name': currentUser!.displayName,
      'email': currentUser!.email,
      'phone': '',
      'address': '',
      'exp': 0,
      'balance': 0,
      'role': 'user',
      'membership': 'bronze',
      'photoUrl': '',
      'postalCode': '',
    });
    return;
  }

  static Future signOut() async {
    // check what login method
    var loginProvider = currentUser!.providerData[0].providerId;

    if (loginProvider == 'password') {
      await auth.signOut();
    } else if (loginProvider == 'google.com') {
      await googleSignIn.signOut();
      await auth.signOut();
    }
  }

  static Stream<User?> get userStream => auth.authStateChanges();
}
