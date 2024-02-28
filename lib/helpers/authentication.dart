// // ignore_for_file: avoid_print

// import 'package:admin_panel/constants/constants.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:get/get.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// // import 'package:shared_preferences/shared_preferences.dart';

// import '../controllers/logged_user_controller.dart';
// import '../models/logged_user.dart';

// final FirebaseAuth auth = FirebaseAuth.instance;

// final GoogleSignIn googleSignIn = GoogleSignIn();

// String? uid;
// String? userEmail;

// String? name;
// String? imageUrl;

// Future<String> registerWithEmailPassword(String email, String password) async {
//   await Firebase.initializeApp();
//   User? user;
//   try {
//     UserCredential userCredential = await auth.createUserWithEmailAndPassword(
//         email: email, password: password);
//     user = userCredential.user;
//     if (user != null) {
//       uid = user.uid;
//       userEmail = user.email;
//     }
//   } on FirebaseAuthException catch (e) {
//     if (e.code == 'weak-password') {
//       return 'The password provided is too weak.';
//     } else if (e.code == 'email-already-in-use') {
//       return 'The account already exists for that email.';
//     }
//   } catch (e) {
//     return 'Something went wrong';
//   }
//   return Constants.registerOk;
// }

// Future<String> signInWithEmailPassword(String email, String password) async {
//   await Firebase.initializeApp();
//   User? user;
//   try {
//     UserCredential userCredential =
//         await auth.signInWithEmailAndPassword(email: email, password: password);
//     user = userCredential.user;
//     if (user != null) {
//       uid = user.uid;
//       userEmail = user.email;
//     }
//   } on FirebaseAuthException catch (e) {
//     if (e.code == 'user-not-found') {
//       return 'No user found for that email.';
//     } else if (e.code == 'wrong-password') {
//       return 'Wrong password provided for that user.';
//     }
//   }
//   return Constants.loginOk;
// }
