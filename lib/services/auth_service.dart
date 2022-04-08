import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:instagramclon/services/get_storage.dart';
import '../pages/sign_in_page.dart';
import '../pages/sign_up_page.dart';

class AuthService{
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  
  static Future<Map<String,User?>> signUpUser(String name,String email,String password)async{
    Map<String,User?> map = {};
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      map = {"SUCCESS":user};
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        map = {'weak-password':null};
      } else if (e.code == 'email-already-in-use') {
        map = {'email-already-in-use':null};
      }
    } catch (e) {
      map = {"ERROR":null};
      print(e);
    }
    return map;
  }

  static Future<Map<String,User?>> signInUser(String email,String password)async{
    Map<String,User?> map = {};
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      map = {"SUCCESS":user};
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        map = {'weak-password':null};
      } else if (e.code == 'email-already-in-use') {
        map = {'email-already-in-use':null};
      }
    } catch (e) {
      map = {"ERROR":null};
    }
    return map;
  }

  static Future<void> delete(BuildContext context)async{
    try {
      await _auth.currentUser!.delete();
      Navigator.of(context).pushReplacementNamed(SignUpPage.id);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        print('The user must reauthenticate before this operation can be executed.');
      }
    }
  }

  static void signOutUser(BuildContext context)async{
    await _auth.signOut();
    GetStorageDB.remove(StorageKeys.UID).then((value) {
      Navigator.of(context).pushReplacementNamed(SignInPage.id);
    });
  }
}