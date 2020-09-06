import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:windson/widgets/auth_form.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  bool _isloading = false;
  void _submitAuthForm(String email, String username, String password,
      bool isLogged, BuildContext context) async {
    AuthResult _authResult;
    try {
      setState(() {
        _isloading = true;
      });
      if (isLogged) {
        _authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        _authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        Firestore.instance
            .collection('Users')
            .document(_authResult.user.uid)
            .setData({
          'username': username,
          'email': email,
        });
      }
    } on PlatformException catch (err) {
      var message = 'An error occured , check credentials';
      if (err != null) {
        message = err.message;
      }
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(color: Theme.of(context).errorColor),
          ),
          backgroundColor: Theme.of(context).backgroundColor,
        ),
      );
      setState(() {
        _isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: AuthForm(_submitAuthForm, _isloading));
  }
}
