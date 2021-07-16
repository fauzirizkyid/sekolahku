import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sekolahku/domain/teacher_domain.dart';
import 'package:sekolahku/screens/teacher_screens/teacher_form_screen.dart';
import 'package:sekolahku/service/app_service.dart';
import 'package:sekolahku/util/capitalize.dart';
import 'package:sekolahku/widgets/components_alerts.dart';

class TeacherDetail extends StatefulWidget {
  final int teacherSelectedIndex;

  TeacherDetail({required this.teacherSelectedIndex});

  @override
  _TeacherDetailState createState() => _TeacherDetailState();
}

class _TeacherDetailState extends State<TeacherDetail> {
  Teacher _teacherDetail = Teacher();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Guru'),
        actions: [
          IconButton(
            icon: Icon(
              FontAwesomeIcons.pencilAlt,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TeacherForm(
                            title: 'Edit Guru',
                            isEdit: true,
                            teacherDomain: _teacherDetail,
                          ))).then((value) {
                setState(() {});
              });
            },
          ),
          IconButton(
            icon: Icon(
              FontAwesomeIcons.trashAlt,
              color: Colors.white,
            ),
            onPressed: () {
              showAlertDialog(context,
                  content: 'Apa anda yakin akan menghapus data ' +
                      _teacherDetail.fullName, continueAction: () {
                Navigator.of(context, rootNavigator: true).pop();
                AppService.teacherService
                    .deleteTeacherBy(index: widget.teacherSelectedIndex)
                    .then((value) => {Navigator.pop(context, true)});
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<Teacher>(
          future: AppService.teacherService
              .findTeacherBy(id: widget.teacherSelectedIndex),
          builder: (context, snapshot) {
            if ((snapshot.connectionState == ConnectionState.none &&
                    !snapshot.hasData) ||
                snapshot.connectionState == ConnectionState.waiting) {
              return LinearProgressIndicator();
            }
            _teacherDetail = snapshot.data!;

            return Container(
              color: Colors.white,
              child: ListView(children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Image.asset(
                    _teacherDetail.gender.toUpperCase() == 'PRIA'
                        ? 'assets/icons/male-icon.png'
                        : 'assets/icons/female-icon.png',
                    width: 150.0,
                    height: 150.0,
                  ),
                ),
                ListTile(
                  leading: Icon(FontAwesomeIcons.user),
                  title: Text(_teacherDetail.fullName),
                ),
                ListTile(
                  leading: Icon(FontAwesomeIcons.phone),
                  title: Text(_teacherDetail.mobilePhone),
                ),
                ListTile(
                  leading: Icon(FontAwesomeIcons.tag),
                  title: Text(capitalize(_teacherDetail.gender)),
                ),
                ListTile(
                  leading: Icon(FontAwesomeIcons.birthdayCake),
                  title: Text(_teacherDetail.birthDate.toUpperCase().substring(0,10)),
                ),
                ListTile(
                  leading: Icon(FontAwesomeIcons.mapPin),
                  title: Text(_teacherDetail.address),
                ),
                ListTile(
                  leading: Icon(FontAwesomeIcons.book),
                  title: Text(_teacherDetail.lessons
                      .map((val) => capitalize(val))
                      .join(', ')),
                ),
              ]),
            );
          }),
    );
  }
}
