import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sekolahku/domain/student_domain.dart';
import 'package:sekolahku/service/app_service.dart';
import 'package:sekolahku/util/capitalize.dart';
import 'package:sekolahku/widgets/components.dart';

class StudentDetail extends StatefulWidget {
  final int studentSelectedIndex;

  StudentDetail({required this.studentSelectedIndex});

  @override
  _StudentDetailState createState() => _StudentDetailState();
}

class _StudentDetailState extends State<StudentDetail> {
  Student _studentDetail = Student();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Murid'),
        actions: [
          IconButton(
            icon: Icon(
              FontAwesomeIcons.pencilAlt,
              color: Colors.white,
            ),
            onPressed: () {
              // do something
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
                      _studentDetail.fullName, continueAction: () {
                AppService.studentService
                    .deleteStudentBy(index: widget.studentSelectedIndex);
                Navigator.pop(context, true);
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<Student>(
          future: AppService.studentService
              .findStudentBy(id: widget.studentSelectedIndex),
          builder: (context, snapshot) {
            print(
                'snapshot ${snapshot.connectionState} data: ${snapshot.data!.firstName}');
            if (snapshot.connectionState == ConnectionState.none &&
                !snapshot.hasData) {
              return LinearProgressIndicator();
            }
            _studentDetail = snapshot.data!;

            return Container(
              color: Colors.white,
              child: ListView(children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Image.asset(
                    _studentDetail.gender == 'Pria'
                        ? 'assets/icons/male-icon.png'
                        : 'assets/icons/female-icon.png',
                    width: 150.0,
                    height: 150.0,
                  ),
                ),
                ListTile(
                  leading: Icon(FontAwesomeIcons.user),
                  title: Text(_studentDetail.fullName),
                ),
                ListTile(
                  leading: Icon(FontAwesomeIcons.phone),
                  title: Text(_studentDetail.mobilePhone),
                ),
                ListTile(
                  leading: Icon(FontAwesomeIcons.tag),
                  title: Text(capitalize(_studentDetail.gender)),
                ),
                ListTile(
                  leading: Icon(FontAwesomeIcons.book),
                  title: Text(_studentDetail.grade.toUpperCase()),
                ),
                ListTile(
                  leading: Icon(FontAwesomeIcons.mapPin),
                  title: Text(_studentDetail.address),
                ),
                ListTile(
                  leading: Icon(FontAwesomeIcons.heart),
                  title: Text(_studentDetail.hobbies
                      .map((val) => capitalize(val))
                      .join(', ')),
                ),
              ]),
            );
          }),
    );
  }
}
