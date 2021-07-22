import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sekolahku/screens/student_screens/student_list_screen.dart';
import 'package:sekolahku/screens/teacher_screens/teacher_list_screen.dart';
import 'package:sekolahku/widgets/components_alerts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'launchers/login.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: MaterialApp(
          home: DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                bottom: TabBar(
                  tabs: [
                    Tab(text: 'Murid'),
                    Tab(text: 'Guru'),
                  ],
                ),
                title: Text('Sekolahku'),
                actions: [
                  IconButton(
                      tooltip: "Logout",
                      onPressed: () {
                        return showAlertDialog(context,
                            content: 'Apakah anda yakin akan melakukan logout?',
                            continueAction: () {
                          _saveLogoutnfo();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        });
                      },
                      icon: Icon(FontAwesomeIcons.signOutAlt))
                ],
              ),
              body: TabBarView(
                children: [
                  StudentList(),
                  TeacherList(),
                ],
              ),
            ),
          ),
        ),
        onWillPop: () {
          return showAlertDialog(context,
              content:
                  'Peringatan Penutupan Aplikasi\nApakah anda yakin akan keluar?',
              continueAction: () {
            exit(0);
          });
        });
  }

  Future<void> _saveLogoutnfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setBool('isLoggedIn', false);
    await prefs.setString('loggedInDate', '');
  }
}
