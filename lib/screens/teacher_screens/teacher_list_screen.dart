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
  bool _startSearch = false;
  List<Teacher> teachers = [];

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
                icon: FontAwesomeIcons.search),
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

                  return ListView.separated(
                    itemCount: teachers.length,
                    separatorBuilder: (BuildContext context, int i) => Divider(
                      color: Colors.grey[400],
                    ),
                    itemBuilder: (BuildContext context, int i) {
                      final Teacher teacher = teachers[i];
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
                            Text(teacher.birthDate.toUpperCase().substring(0,10)),
                            Text(teacher.mobilePhone)
                          ],
                        ),
                      );
                    },
                  );
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
}
