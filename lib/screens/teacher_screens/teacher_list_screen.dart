import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sekolahku/domain/teacher_domain.dart';
import 'package:sekolahku/screens/teacher_screens/teacher_detail_screen.dart';
import 'package:sekolahku/screens/teacher_screens/teacher_form_screen.dart';
import 'package:sekolahku/service/app_service.dart';
import 'package:sekolahku/util/capitalize.dart';
import 'package:sekolahku/widgets/components.dart';

class TeacherList extends StatefulWidget {
  @override
  _TeacherListState createState() => _TeacherListState();
}

class _TeacherListState extends State<TeacherList> {
  final _searchForm = TextEditingController();
  List<Teacher> teachers = [];
  List<Teacher> searchTeachers = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
            child: FutureBuilder<List<Teacher>>(
                future: AppService.teacherService.findAllTeachers(),
                builder: (context, snapshot) {
                  // print('snapshot.data.length ${snapshot.data![0].firstName}');
                  if ((snapshot.connectionState == ConnectionState.none &&
                          !snapshot.hasData) ||
                      snapshot.connectionState == ConnectionState.waiting) {
                    print('project snapshot data is: ${snapshot.data}');
                    return LinearProgressIndicator();
                  } else if (snapshot.hasData && snapshot.data!.length > 0) {
                    teachers = snapshot.data!;
                  } else {
                    print("ke container");
                    return Container();
                  }

                  print("teachers: " + teachers.length.toString());

                  return searchTeachers.length != 0 || _searchForm.text != ''
                      ? _teacherListData(searchTeachers)
                      : _teacherListData(teachers);
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
                          TeacherForm(title: 'Tambah Guru', isEdit: false)))
              .then((value) {
            setState(() {});
          });
        },
      ),
    );
  }

  Widget _teacherListData(List<Teacher> teacherData) => ListView.separated(
        itemCount: teacherData.length,
        separatorBuilder: (BuildContext context, int i) => Divider(
          color: Colors.grey[400],
        ),
        itemBuilder: (BuildContext context, int i) {
          final Teacher teacher = teacherData[i];
          return ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TeacherDetail(
                            teacherSelectedIndex: teacher.idTeacher,
                          ))).then((value) {
                setState(() {});
              });
            },
            leading: Icon(FontAwesomeIcons.chalkboardTeacher),
            title: Text(teacher.fullName),
            subtitle: Text(capitalize(teacher.gender)),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(teacher.birthDate.toUpperCase().substring(0, 10)),
                Text(teacher.mobilePhone)
              ],
            ),
          );
        },
      );

  _onSearchTextChanged(String text) async {
    text = text.toLowerCase();
    searchTeachers.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    teachers.forEach((teacher) {
      if (teacher.address.toLowerCase().contains(text) ||
          teacher.birthDate.toLowerCase().contains(text) ||
          teacher.firstName.toLowerCase().contains(text) ||
          teacher.lastName.toLowerCase().contains(text) ||
          teacher.gender.toLowerCase().replaceAll("_", " ").contains(text) ||
          teacher.mobilePhone.toLowerCase().contains(text))
        searchTeachers.add(teacher);
    });

    setState(() {});
  }
}
