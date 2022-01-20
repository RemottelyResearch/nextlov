import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:nextlov/helpers/firebase_errors.dart';
import 'package:nextlov/models/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserManager extends ChangeNotifier {
  UserManager() {
    _loadCurrentUser();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  final Firestore firestore = Firestore.instance;

  UserModel userModel;

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FacebookLogin facebookSignIn = FacebookLogin();

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  bool _loadingFace = false;
  bool get loadingFace => _loadingFace;
  set loadingFace(bool value) {
    _loadingFace = value;
    notifyListeners();
  }

  bool _loadingGoogle = false;
  bool get loadingGoogle => _loadingGoogle;
  set loadingGoogle(bool value) {
    _loadingGoogle = value;
    notifyListeners();
  }

  bool get isLoggedIn => userModel != null;

  Future<bool> signIn(
      {UserModel user,
      Function onFail,
      Function onEmailNotVerified,
      Function onSuccess}) async {
    loading = true;
    try {
      final AuthResult result = await auth.signInWithEmailAndPassword(
          email: user.email, password: user.password);

      final FirebaseUser currentUser =
          await _loadCurrentUser(firebaseUser: result.user);

      if (currentUser.isEmailVerified) {
        onSuccess();
      } else {
        onEmailNotVerified(currentUser);
      }
    } on PlatformException catch (e) {
      onFail(getErrorString(e.code));
    }
    loading = false;
  }

  Future<void> facebookLogin({Function onFail, Function onSuccess}) async {
    loadingFace = true;

    final result = await facebookSignIn.logIn(['email', 'public_profile']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final credential = FacebookAuthProvider.getCredential(
            accessToken: result.accessToken.token);

        final authResult = await auth.signInWithCredential(credential);

        if (authResult.user != null) {
          final firebaseUser = authResult.user;

          userModel = UserModel(
            id: firebaseUser.uid,
            name: firebaseUser.displayName,
            email: firebaseUser.email,
          );

          await userModel.saveData();

          await userModel.saveToken();

          await _loadCurrentUser(firebaseUser: authResult.user);

          onSuccess();
        }
        break;
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        onFail(result.errorMessage);
        break;
    }

    loadingFace = false;
  }

  String getRandomString(int length) {
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    final Random _rnd = Random();

    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => _chars.codeUnitAt(
          _rnd.nextInt(_chars.length),
        ),
      ),
    );
  }

  Future<void> googleLogin({Function onFail, Function onSuccess}) async {
    final googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      onFail();
      return;
    } else {
      loadingGoogle = true;
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final AuthResult result =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (result.additionalUserInfo.isNewUser) {
        // UserModel userModel = new UserModel();
        userModel.id = result.user.uid;
        // this.userModel = userModel;

        userModel.name = result.user.displayName;
        userModel.email = result.user.email;
        userModel.code = getRandomString(28);
        // userModel.password = '';
        // userModel.cpf = '';
        userModel.imageProfile = result.user.photoUrl;

        await userModel.saveData();

        await userModel.saveToken();
      } else {
        await _loadCurrentUser(firebaseUser: result.user);
      }
      loadingGoogle = false;
      onSuccess();
      return;
    }
  }

  Future<void> signUp(
      {UserModel user, Function onFail, Function onSuccess}) async {
    loading = true;
    try {
      final AuthResult result = await auth.createUserWithEmailAndPassword(
          email: user.email, password: user.password);

      user.id = result.user.uid;
      // this.user = user;
      user.code = getRandomString(28);

      await user.saveData();

      // await user.saveToken();

      onSuccess(result.user);
    } on PlatformException catch (e) {
      onFail(getErrorString(e.code));
    }
    loading = false;
  }

  Future<void> signOut() async {
    await userModel.deleteToken();
    if (await googleSignIn.isSignedIn()) {
      googleSignIn.disconnect();
    } else if (await facebookSignIn.isLoggedIn) {
      facebookSignIn.logOut();
    }
    auth.signOut();
    userModel = null;
    notifyListeners();
  }

  Future<FirebaseUser> _loadCurrentUser({FirebaseUser firebaseUser}) async {
    final FirebaseUser currentUser = firebaseUser ?? await auth.currentUser();
    if (currentUser != null) {
      if (currentUser.isEmailVerified) {
        final DocumentSnapshot docUser =
            await firestore.collection('users').document(currentUser.uid).get();
        userModel = UserModel.fromDocument(docUser);

        await userModel.saveToken();

        final docAdmin =
            await firestore.collection('admins').document(userModel.id).get();
        if (docAdmin.exists) {
          userModel.admin = true;
        }

        notifyListeners();
      }
    }
    return currentUser;
  }

  bool get adminEnabled => userModel != null && userModel.admin;
}
