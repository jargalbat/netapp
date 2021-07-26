import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class FacebookLoginScreen extends StatefulWidget {
  FacebookLoginScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _FacebookLoginScreenState createState() => _FacebookLoginScreenState();
}

class _FacebookLoginScreenState extends State<FacebookLoginScreen> {
  FacebookLogin _facebookLogin;
  bool _isLoggedIn = false;
  String _profileName = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Facebook Login"),
        ),
        body: Container(
          padding: EdgeInsets.only(top: 20.0),
          child: Column(
            children: <Widget>[
              Text(_isLoggedIn ? "Logged In as $_profileName" : ''),
              RaisedButton(
                child: Text(_isLoggedIn ? "Logout" : "Login"),
                onPressed: () => _isLoggedIn ? _logout() : _login(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _login() async {
    var facebookLoginResult = await (_facebookLogin ?? FacebookLogin()).logIn(['public_profile']);
    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        print("Error");
        onLoginStatusChanged(false, '');
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("CancelledByUser");
        onLoginStatusChanged(false, '');
        break;
      case FacebookLoginStatus.loggedIn:
        var graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${facebookLoginResult.accessToken.token}');

        var profile = json.decode(graphResponse.body);
        print(profile.toString());

        onLoginStatusChanged(true, profile["name"]);
        break;
    }
  }

  void _logout() async {
    await (_facebookLogin ?? FacebookLogin()).logOut();
    print("LoggedOut");
    onLoginStatusChanged(false, '');
  }

  void onLoginStatusChanged(bool isLoggedIn, String profileName) {
    setState(() {
      this._isLoggedIn = isLoggedIn;
      this._profileName = profileName;
    });
  }
}