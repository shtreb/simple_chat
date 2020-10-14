import 'package:chat_mobile/data/cases/services/auth-service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:chat_models/chat_models.dart';
import 'package:chat_api_client/chat_api_client.dart';

import 'package:chat_mobile/data/cases/api_client.dart';
import 'package:chat_mobile/flavors/globals.dart' as globals;

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginData {
  String login = '';
  String password = '';
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  _LoginData _loginData = new _LoginData();
  final TextEditingController _loginController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();

  String _validateLogin(String value) {
    if (value.length < 2) {
      // check login rules here
      return 'The Login must be at least 2 characters.';
    }
    return null;
  }

  String _validatePassword(String value) {
    if (value.length < 2) {
      // check password rules here
      return 'The Password must be at least 2 characters.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Builder(
          builder: (BuildContext scaffoldContext) => SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color> [
                        Theme.of(context).primaryColorDark,
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColorDark
                      ],
                      stops: [.32, .80, 1]
                  )
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: TextSpan(
                            text: 'Welcome\n',
                            style: Theme.of(context).appBarTheme.textTheme.headline3,
                            children: <TextSpan> [
                              TextSpan(
                                  text: 'to the app',
                                  style: Theme.of(context).appBarTheme.textTheme.headline2
                              )
                            ]
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Form(
                      key: this._formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _createTextFormField(
                              hintText: 'Login',
                              labelText: 'Enter your login',
                              ctrl: _loginController,
                              validator: this._validateLogin,
                              onSaved: (String value) =>  this._loginData.login = value,
                          ),
                          _createTextFormField(
                            hintText: 'Password',
                            labelText: 'Enter your password',
                            ctrl: _passwordController,
                            validator: this._validatePassword,
                            obfuscate: true,
                            onSaved: (String value) => this._loginData.password = value,
                          ),
                          const Padding(padding: EdgeInsets.only(top: 20)),
                          Column(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: RaisedButton(
                                    child: Text("Login"),
                                    onPressed: () => _login(scaffoldContext)),
                              ),
                              CupertinoButton(
                                child: Text("Sign up", style: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.white),),
                                onPressed: () => _signUp(scaffoldContext),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
    );
  }

  TextFormField _createTextFormField({
      String hintText = '',
      String labelText = '',
      TextEditingController ctrl,
      FormFieldValidator<String> validator,
      FormFieldSetter<String> onSaved,
      bool obfuscate = false
  }) => TextFormField(
    controller: ctrl ?? TextEditingController(),
    validator: validator,
    onSaved: onSaved ?? (_){},
    cursorColor: Colors.white.withOpacity(.8),
    style: TextStyle(color: Colors.white),
    obscureText: obfuscate,
    decoration: InputDecoration(
      hintText: hintText,
      labelText: labelText,
      hintStyle: TextStyle(color: Colors.white.withOpacity(.8)),
      helperStyle: TextStyle(color:Colors.white.withOpacity(.8)),
      labelStyle: TextStyle(color:Colors.white.withOpacity(.8)),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
            color: Colors.white.withOpacity(.4),
            width: 1.0,
            style: BorderStyle.solid
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
            color: Colors.white.withOpacity(.8),
            width: 1.0,
            style: BorderStyle.solid
        ),
      ),
    ),
  );

  _signUp(BuildContext context) {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();
      _showDialog(_loginData.login).then((resultValue) {
        if (resultValue != null && resultValue is bool && resultValue) {
          UsersClient usersClient = UsersClient(MobileApiClient());
          usersClient
              .create(User(
                name: _loginData.login,
                password: _loginData.password
              ))
              .then((createdUser) {
            _clearUi();
            final snackBar =
                SnackBar(content: Text('User \'${createdUser.name}\' created'));
            Scaffold.of(context).showSnackBar(snackBar);
          }).catchError((signUpError) {
            final snackBar = SnackBar(
                content: Text('Sign up failed: ${signUpError.message}'));
            Scaffold.of(context).showSnackBar(snackBar);
            print('Sign up failed');
            print(signUpError);
          });
        }
      });
    }
  }

  _login(BuildContext context) async {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();

      try {
        UsersClient usersClient = UsersClient(MobileApiClient());
        var user = await usersClient.login(_loginData.login, _loginData.password);
        globals.currentUser = user;
        authService.saveCredential(_loginData.login, _loginData.password);
        Navigator.pushNamedAndRemoveUntil(context, '/tabs', (route) => false).then((_) {
          globals.currentUser = null;
        });
        _clearUi();
      } on Exception catch (e) {
        final snackBar = SnackBar(content: Text('Login failed'));
        Scaffold.of(context).showSnackBar(snackBar);
        print('Login failed');
        print(e);
      }
    }
  }

  Future<bool> _showDialog(String username) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: new Text("Do you want to create user '$username' ?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  void _clearUi() {
    _loginController.clear();
    _passwordController.clear();
  }
}
