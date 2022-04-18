import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:zartek_test/main.dart';
import 'package:zartek_test/src/services/shared_preference_helper.dart';
import 'package:zartek_test/src/utility/status_enum.dart';
import 'package:zartek_test/src/utility/collection_name.dart';
import 'package:zartek_test/src/view/user_home_screen/user_home_screen.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  LoginStatus loginStatus = LoginStatus.idle;
  PhoneNumberLoginStatus phoneLogStatus = PhoneNumberLoginStatus.idle;

  // Phone Login Part
  String verificatioId = "";
  int counter = 60;
  Timer? _timer;

  // phone authentication
  Future<void> phoneAuthentication(String? phone, BuildContext context) async {
    phoneLogStatus = PhoneNumberLoginStatus.loading;
    notifyListeners();
    try {
      _auth.verifyPhoneNumber(
          phoneNumber: phone!,
          timeout: const Duration(seconds: 60),
          verificationCompleted: (AuthCredential credntial) async {
          },
          verificationFailed: (FirebaseAuthException exception) {
            debugPrint(exception.toString());
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
                  Text("Failed to Login ${exception.message} ! Retry Again"),
            ));
            if (_timer != null) _timer!.cancel();
            phoneLogStatus = PhoneNumberLoginStatus.idle;
            notifyListeners();
          },
          codeSent: (
            String verificationId,
            int? resendToken,
          ) {
            verificatioId = verificationId;
            counter = 60;
            _timer = Timer.periodic(const Duration(seconds: 1), (tiner) {
              if (counter > 0) {
                counter--;
              } else if (counter == 0) {
                phoneLogStatus = PhoneNumberLoginStatus.error;
                notifyListeners();
              }
              notifyListeners();
            });
            phoneLogStatus = PhoneNumberLoginStatus.inputOTP;
            notifyListeners();
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            if (_timer != null) _timer!.cancel();
            verificationId = verificationId;
            debugPrint(verificationId);
            debugPrint("Timout");
            phoneLogStatus = PhoneNumberLoginStatus.error;
            notifyListeners();
          });
    } catch (e) {
      debugPrint("======$e");
    }
  }

  void verifyOTP(String smsCode, BuildContext context) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificatioId, smsCode: smsCode);
      await _auth.signInWithCredential(credential);
      User? user = _auth.currentUser;
      bool checkUser = await checkUserIsRegistered(_auth.currentUser!.uid);

      if (checkUser) {
        Navigator.pushReplacementNamed(context, UserHomeScreen.route);
      } else {
        //uer is not registered
        await registerUser(
            uid: user?.uid, email: user?.email, phone: user?.phoneNumber);
        Navigator.pushReplacementNamed(context, UserHomeScreen.route);
      }
      saveLogin();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Successfully Logged In"),
      ));
      if (_timer != null) _timer!.cancel();
      phoneLogStatus = PhoneNumberLoginStatus.idle;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Invalid OTP Entered"),
      ));
      debugPrint('$e');
    }
  }

  void signInWithGoogle(BuildContext context) async {
    loginStatus = LoginStatus.loading;
    notifyListeners();
    try {
      _googleSignIn.disconnect();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final authData = await _auth.signInWithCredential(credential);
      User? user = authData.user;
      var result = await checkUserIsRegistered(authData.user!.uid);
      if (result) {
        Navigator.pushReplacementNamed(context, UserHomeScreen.route);
      } else {
        //uer is not registered
        await registerUser(
          uid: user?.uid,
          email: user?.email,
          phone: user?.phoneNumber,
        );
        Navigator.pushReplacementNamed(context, UserHomeScreen.route);
      }
      saveLogin();
      loginStatus = LoginStatus.loggedIn;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Successfully Logged In"),
      ));
    } catch (e) {
      loginStatus = LoginStatus.error;
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to Login due to $e ! Retry Again"),
      ));
      debugPrint('Google Login Error : ${e.toString()}');
    }
  }

  Future<UserCredential> signInWithgle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  // on error show retry button
  void onRetryPress() {
    loginStatus = LoginStatus.idle;
    notifyListeners();
  }

  void logout() {
    SharedPreferenceHelper.sharedPreferences!.clear();
    _auth.signOut();
  }

  // this used for change otp enter and phone number entering widget
  void changePhoneInputStatus(PhoneNumberLoginStatus status) {
    phoneLogStatus = status;
    notifyListeners();
  }

  //Check user previously registered
  Future<bool> checkUserIsRegistered(String uid) async {
    var doc =
        await firestore.collection(Collections.userCollection).doc(uid).get();
    if (doc.exists) {
      return true;
    } else {
      return false;
    }
  }

  // register user if not registered
  Future<void> registerUser(
      {@required String? uid, String? email = '', String? phone = ''}) async {
    QuerySnapshot snapshot =
        await firestore.collection(Collections.userCollection).get();
    await firestore.collection(Collections.userCollection).doc(uid).set({
      'uid': uid ?? "",
      'email': email,
      'phone': phone,
      "userID": 1000 + snapshot.docs.length + 1
    });
  }

  // check is user alredy logged in
  bool checkLogedIn() {
    var loginStatus = SharedPreferenceHelper.sharedPreferences!
            .getBool(SharedPreferenceHelper.loginCheck) ??
        false;
    return loginStatus;
  }

  // save user logged in shared preferences
  void saveLogin() {
    SharedPreferenceHelper.sharedPreferences!
        .setBool(SharedPreferenceHelper.loginCheck, true);
  }
}
