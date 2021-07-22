import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sekolahku/screens/home_screen.dart';
import 'package:sekolahku/screens/launchers/register.dart';
import 'package:sekolahku/service/app_service.dart';
import 'package:sekolahku/util/utils.dart';
import 'package:sekolahku/widgets/components.dart';
import 'package:sekolahku/widgets/components_alerts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formUserLogin = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obsecureText = true;
  bool _onLoad = true;
  IconData _iconDataPassword = FontAwesomeIcons.eyeSlash;

  @override
  void initState() {
    _checkLoginInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: _onLoad
            ? Center(
                child: CircularProgressIndicator(),
              )
            : WillPopScope(
                onWillPop: () {
                  return showAlertDialog(context,
                      content:
                          'Peringatan Penutupan Aplikasi\nApakah anda yakin akan keluar?',
                      continueAction: () {
                    exit(0);
                  });
                },
                child: Form(
                  key: _formUserLogin,
                  child: Center(
                    child: ListView(
                      padding: LayoutStyled.paddingAllSide,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 15,
                        ),
                        Icon(
                          FontAwesomeIcons.school,
                          size: MediaQuery.of(context).size.width / 2,
                          color: Colors.blue,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Sekolahku',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 42,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Components.textForm(
                            title: 'Username',
                            hint: 'Masukkan username anda',
                            mandatory: true,
                            inputController: _usernameController),
                        Components.textForm(
                            title: 'Password',
                            hint: 'Masukkan password anda',
                            mandatory: true,
                            inputController: _passwordController,
                            obsecureText: _obsecureText,
                            icon: _iconDataPassword,
                            iconTap: _toggle),
                        ElevatedButton(
                            onPressed: () {
                              if (_formUserLogin.currentState!.validate()) {
                                AppService.userService
                                    .findUsernamePassword(
                                        username: _usernameController.text
                                            .toLowerCase(),
                                        password: _passwordController.text)
                                    .then((value) {
                                  if (value) {
                                    _saveLoginInfo();
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                HomeScreen()));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Username dan Password salah'
                                                    .toString())));
                                  }
                                }).catchError((error) {
                                  print(error);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(error.toString())));
                                });
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: const Text(
                                      'Silahkan isi username & password dengan benar'),
                                  duration: const Duration(seconds: 1),
                                ));
                              }
                            },
                            child: Text('Login')),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Register()))
                                  .then((value) {
                                setState(() {});
                              });
                            },
                            child: Text('Registrasi'))
                      ],
                    ),
                  ),
                ),
              ));
  }

  Future<void> _saveLoginInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('loggedInDate', Utils.getPeriod('now', true));
  }

  Future<void> _checkLoginInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getBool('isLoggedIn'));
    print(prefs.getString('loggedInDate'));
    bool? isLoggedInCheck = prefs.getBool('isLoggedIn') != null
        ? prefs.getBool('isLoggedIn')
        : false;

    print(isLoggedInCheck);

    if (isLoggedInCheck != null) {
      if (isLoggedInCheck &&
          prefs.getString('loggedInDate') == Utils.getPeriod('now', true)) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));
      }
    }
    _onLoad = false;
    setState(() {});
  }

  void _toggle() {
    setState(() {
      _obsecureText = !_obsecureText;

      _iconDataPassword =
          _obsecureText ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye;
    });
  }
}
