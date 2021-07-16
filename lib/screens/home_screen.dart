import 'package:flutter/material.dart';
import 'package:sekolahku/screens/student_screens/student_list_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
          ),
          body: TabBarView(
            children: [
              StudentList(),
              StudentList(),
            ],
          ),
        ),
      ),
    );
  }
}
