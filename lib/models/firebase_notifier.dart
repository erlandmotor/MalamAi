import 'dart:async';

import 'package:chat_playground/define/global_define.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ntp/ntp.dart';

class FirebaseNotifier extends ChangeNotifier {
  bool loggedIn = false;
  FirebaseState state = FirebaseState.loading;
  bool isLoggingIn = false;
  bool isSignOuting = false;

  late User? user;
  late DateTime? ctime;
  late DateTime? lasttime;
  late DateTime startDate;

  FirebaseNotifier() {
    load();
  }

  late final Completer<bool> _isInitialized = Completer();

  FirebaseFunctions? _functions;

  Future<FirebaseFunctions> get functions async {
    var isInitialized = await _isInitialized.future;
    if (!isInitialized) {
      throw Exception('Firebase is not initialized');
    }
    return _functions!;
  }

  Future<FirebaseFirestore> get firestore async {
    var isInitialized = await _isInitialized.future;
    if (!isInitialized) {
      throw Exception('Firebase is not initialized');
    }
    return FirebaseFirestore.instance;
  }

  Future<void> load() async {
    try {
      await Firebase.initializeApp();
      _functions = FirebaseFunctions.instanceFor(region: cloudRegion);

      user = FirebaseAuth.instance.currentUser;
      loggedIn = user != null;

      if (loggedIn) {
        ctime = user?.metadata.creationTime;
        lasttime = user?.metadata.lastSignInTime;
        startDate = await NTP.now();
      }

      state = FirebaseState.available;
      _isInitialized.complete(true);
      notifyListeners();
    } catch (e) {
      state = FirebaseState.notAvailable;
      _isInitialized.complete(false);
      notifyListeners();
    }
  }

  Future<void> login() async {
    isLoggingIn = true;
    notifyListeners();
    // Trigger the authentication flow
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        isLoggingIn = false;
        notifyListeners();
        return;
      }

      // Obtain the auth details from the request
      final googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      UserCredential fbdata =
          await FirebaseAuth.instance.signInWithCredential(credential);

      user = fbdata.user;
      ctime = fbdata.user?.metadata.creationTime;
      lasttime = fbdata.user?.metadata.lastSignInTime;
      startDate = await NTP.now();
      //print('NTP DateTime: ${startDate}');
      //DateTime.now();

      loggedIn = true;
      isLoggingIn = false;
      notifyListeners();
    } catch (e) {
      isLoggingIn = false;
      notifyListeners();
      return;
    }
  }

  Future<void> logout() async {
    isSignOuting = true;
    notifyListeners();

    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();

    loggedIn = false;
    isLoggingIn = false;
    isSignOuting = true;
    notifyListeners();
  }
}
