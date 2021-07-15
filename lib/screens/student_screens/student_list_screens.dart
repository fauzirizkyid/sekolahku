import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sekolahku/domain/student_domain.dart';
import 'package:sekolahku/screens/student_screens/student_detail_screens.dart';
import 'package:sekolahku/screens/student_screens/student_form_screens.dart';
import 'package:sekolahku/service/app_service.dart';
import 'package:sekolahku/util/capitalize.dart';

class StudentList extends StatefulWidget {
  @override
  _StudentListState createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  List<Student> _students = [];

  @override
  void initState() {
    super.initState();

    _students = AppService.studentService.findAllStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SekolahKu'),
      ),
      body: ListView.separated(
        itemCount: _students.length,
        separatorBuilder: (BuildContext context, int i) => Divider(
          color: Colors.grey[400],
        ),
        itemBuilder: (BuildContext context, int i) {
          final Student student = _students[i];
          return ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StudentDetail(
                            studentSelectedIndex: i,
                          )));
            },
            leading: Icon(FontAwesomeIcons.user),
            title: Text(student.fullName),
            subtitle: Text(capitalize(student.gender)),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(student.grade.toUpperCase()),
                Text(student.mobilePhone)
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(FontAwesomeIcons.plus),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => StudentForm()));
        },
      ),
    );
  }
}
