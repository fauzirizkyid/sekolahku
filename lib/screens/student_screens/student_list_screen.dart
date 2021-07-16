import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sekolahku/domain/student_domain.dart';
import 'package:sekolahku/screens/student_screens/student_detail_screen.dart';
import 'package:sekolahku/screens/student_screens/student_form_screen.dart';
import 'package:sekolahku/service/app_service.dart';
import 'package:sekolahku/util/capitalize.dart';
import 'package:sekolahku/widgets/components.dart';

class StudentList extends StatefulWidget {
  @override
  _StudentListState createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  final _searchForm = TextEditingController();
  List<Student> _students = [];
  List<Student> _searchStudents = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: LayoutStyled.paddingAllSide,
            child: Components.textForm(
                inputController: _searchForm,
                hint: 'Cari berdasarkan',
                icon: FontAwesomeIcons.search,
                onChanged: _onSearchTextChanged),
          ),
          Expanded(
            child: FutureBuilder<List<Student>>(
                future: AppService.studentService.findAllStudents(),
                builder: (context, snapshot) {
                  // print('snapshot.data.length ${snapshot.data![0].firstName}');
                  if ((snapshot.connectionState == ConnectionState.none &&
                          !snapshot.hasData) ||
                      snapshot.connectionState == ConnectionState.waiting) {
                    print('project snapshot data is: ${snapshot.data}');
                    return LinearProgressIndicator();
                  } else if (snapshot.hasData && snapshot.data!.length > 0) {
                    _students = snapshot.data!;
                  } else {
                    print("ke container");
                    return Container();
                  }

                  print("_students: " + _students.length.toString());

                  return _searchStudents.length != 0 || _searchForm.text != ''
                      ? _studentListData(_searchStudents)
                      : _studentListData(_students);
                }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(FontAwesomeIcons.plus),
        onPressed: () {
          Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          StudentForm(title: 'Tambah Murid', isEdit: false)))
              .then((value) {
            setState(() {});
          });
        },
      ),
    );
  }

  Widget _studentListData(List<Student> studentData) => ListView.separated(
        itemCount: studentData.length,
        separatorBuilder: (BuildContext context, int i) => Divider(
          color: Colors.grey[400],
        ),
        itemBuilder: (BuildContext context, int i) {
          final Student student = studentData[i];
          return ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StudentDetail(
                            studentSelectedIndex: student.idStudent,
                          ))).then((value) {
                setState(() {});
              });
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
      );

  _onSearchTextChanged(String text) async {
    text = text.toLowerCase();
    _searchStudents.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _students.forEach((student) {
      if (student.address.toLowerCase().contains(text) ||
          student.grade.toLowerCase().contains(text) ||
          student.firstName.toLowerCase().contains(text) ||
          student.lastName.toLowerCase().contains(text) ||
          student.gender.toLowerCase().replaceAll("_", " ").contains(text) ||
          student.mobilePhone.toLowerCase().contains(text))
        _searchStudents.add(student);
    });

    setState(() {});
  }
}
