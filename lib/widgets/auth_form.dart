import 'package:flutter/material.dart';
import 'package:windson/screens/home_page.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this._submitAuthForm, this._isLoading);

  final bool _isLoading;
  final void Function(String email, String username, String password,
      bool isLogged, BuildContext context) _submitAuthForm;
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  bool _isLogged = false;
  String _email = '';
  String _username = '';
  String _password = '';

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState.save();
      widget._submitAuthForm(_email, _username, _password, _isLogged, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.all(20),
        child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    '=> WIND <=',
                    style: TextStyle(
                        fontSize: 20, color: Theme.of(context).primaryColor),
                  ),
                  TextFormField(
                      key: ValueKey('email'),
                      validator: (value) {
                        if (value.isEmpty || !value.contains('@')) {
                          return "Please enter a valid email!";
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _email = newValue;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: 'email',
                          labelStyle:
                              TextStyle(color: Theme.of(context).accentColor)),
                      style: Theme.of(context).textTheme.bodyText2),
                  if (!_isLogged)
                    TextFormField(
                      key: ValueKey('username'),
                      validator: (value) {
                        if (value.isEmpty || value.length < 5) {
                          return 'Please enter atleast 5 chars !';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _username = newValue;
                      },
                      decoration: InputDecoration(
                          labelText: 'username',
                          labelStyle:
                              TextStyle(color: Theme.of(context).accentColor)),
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    validator: (value) {
                      if (value.isEmpty || value.length < 7) {
                        return 'Please enter atleast 7 chars !';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _password = newValue;
                    },
                    decoration: InputDecoration(
                        labelText: 'password',
                        labelStyle:
                            TextStyle(color: Theme.of(context).accentColor)),
                    style: Theme.of(context).textTheme.bodyText2,
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  if (widget._isLoading)
                    CircularProgressIndicator(
                      backgroundColor: Theme.of(context).accentColor,
                    ),
                  if (!widget._isLoading)
                    FlatButton(
                      onPressed: _trySubmit,
                      child: _isLogged
                          ? Text(
                              '=>  log in ',
                              style: Theme.of(context).textTheme.bodyText2,
                            )
                          : Text(
                              '=>  sign up ',
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                    ),
                  SizedBox(height: 5),
                  if (!widget._isLoading)
                    FlatButton(
                        onPressed: () => setState(() {
                              _isLogged = !_isLogged;
                            }),
                        child: _isLogged
                            ? Text(
                                '=> create new user',
                                style: Theme.of(context).textTheme.bodyText1,
                              )
                            : Text(
                                '=>  already a user?',
                                style: Theme.of(context).textTheme.bodyText1,
                              )),
                ],
              ),
            )),
      ),
    );
  }
}
