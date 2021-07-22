import 'package:flutter/material.dart';
import 'package:sekolahku/domain/teacher_domain.dart';
import 'package:sekolahku/service/app_service.dart';
import 'package:sekolahku/util/capitalize.dart';
import 'package:sekolahku/widgets/components.dart';

class TeacherForm extends StatefulWidget {
  final String title;
  final bool isEdit;
  final Teacher? teacherDomain;

  const TeacherForm(
      {required this.title, required this.isEdit, this.teacherDomain});

  @override
  _TeacherFormState createState() => _TeacherFormState();
}

class _TeacherFormState extends State<TeacherForm> {
  final _formAddTeacher = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  String? _gender;
  DateTime? _inputBirthDate;
  List<String> _lessons = <String>[];
  List<Map<String, dynamic>> _formData = [];

  @override
  void initState() {
    _initFormData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
          ),
        ),
        body: _listView());
  }

  Widget _listView() => Form(
        key: _formAddTeacher,
        child: ListView(
          padding: LayoutStyled.paddingAllSide,
          children: [
            ListView.builder(
                itemCount: _formData.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  if (_formData[index]['title'] == 'Jenis Kelamin') {
                    // _gender = Teacher.genders[0];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: _formData[index]['title'],
                            style: TextStyled.bodyBold,
                            children: <TextSpan>[
                              TextSpan(text: ' *', style: TextStyled.redBody)
                            ],
                          ),
                        ),
                        Row(
                            children: Teacher.genders
                                .map((valueGender) => Container(
                                      child: Components.labeledRadio(
                                          value: valueGender,
                                          groupValue: _gender,
                                          onChanged: (value) {
                                            setState(() {
                                              _gender = value;
                                            });
                                          },
                                          label: capitalize(valueGender)),
                                    ))
                                .toList()),
                      ],
                    );
                  } else if (_formData[index]['title'] == 'Mata Pelajaran') {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: _formData[index]['title'],
                            style: TextStyled.bodyBold,
                            children: <TextSpan>[
                              TextSpan(text: ' *', style: TextStyled.redBody)
                            ],
                          ),
                        ),
                        Column(
                          children: Teacher.lessonList
                              .map((valueLesson) => Container(
                                    child: Components.customCheckbox(
                                      text: capitalize(valueLesson),
                                      value: _lessons.contains(valueLesson),
                                      onChanged: (value) {
                                        setState(() {
                                          if (_lessons.contains(valueLesson)) {
                                            _lessons.remove(valueLesson);
                                          } else {
                                            _lessons.add(valueLesson);
                                          }
                                          print(_lessons);
                                        });
                                      },
                                    ),
                                  ))
                              .toList(),
                        ),
                      ],
                    );
                  } else if (_formData[index]['title'] == 'Tanggal Lahir') {
                    return Components.dateTimePicker(
                        context: context,
                        title: "Tanggal Lahir",
                        hint: "Masukkan tanggal lahir",
                        todayIsLastDate: true,
                        dateOnly: true,
                        mandatory: true,
                        initDateTime: _inputBirthDate,
                        onDateTimeChanged: (newDateTime) {
                          setState(() {
                            _inputBirthDate = newDateTime;
                          });
                        });
                  } else {
                    return Components.textForm(
                        inputController: _formData[index]['controller'],
                        title: _formData[index]['title'],
                        hint: 'Masukkan ' + _formData[index]['title'],
                        inputType: _formData[index]['textInputType'],
                        mandatory: _formData[index]['mandatory'],
                        maxLines: _formData[index]['maxLines']);
                  }
                }),
            ElevatedButton(
              onPressed: () {
                if (_formAddTeacher.currentState!.validate()) {
                  Teacher teacherDomain = Teacher();
                  teacherDomain.address = _addressController.text.trim();
                  teacherDomain.lessons = _lessons;
                  teacherDomain.birthDate = _inputBirthDate.toString();
                  teacherDomain.gender = _gender!;
                  teacherDomain.mobilePhone = _phoneController.text.trim();
                  teacherDomain.firstName = _firstNameController.text.trim();
                  teacherDomain.lastName = _lastNameController.text.trim();

                  if (widget.isEdit) {
                    print(teacherDomain.lessons);
                    AppService.teacherService
                        .updateTeacher(
                            id: widget.teacherDomain!.idTeacher,
                            teacherDomain: teacherDomain,
                            createdAt: widget.teacherDomain!.createdAt)
                        .then((value) {
                      Navigator.pop(context);
                    }).catchError((error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(error.toString())));
                    });
                  } else {
                    AppService.teacherService
                        .createTeacher(teacherDomain)
                        .then((value) {
                      Navigator.pop(context);
                    }).catchError((error) {
                      print(error);
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(error.toString())));
                    });
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text('Silahkan isi semua data'),
                    duration: const Duration(seconds: 1),
                  ));
                }
              },
              child: Text(widget.title),
            )
          ],
        ),
      );

  void _initFormData() {
    if (widget.isEdit) {
      _firstNameController.text = widget.teacherDomain!.firstName;
      _lastNameController.text = widget.teacherDomain!.lastName;
      _phoneController.text = widget.teacherDomain!.mobilePhone;
      _addressController.text = widget.teacherDomain!.address;

      // for (var i = 0; i < Teacher.genders.length; i++) {
      //   if (widget.teacherDomain!.gender == Teacher.genders[i]) {
      //     _gender = Teacher.genders[i];
      //     break;
      //   }
      // }

      // for (var i = 0; i < Teacher.grades.length; i++) {
      //   if (widget.teacherDomain!.grade == Teacher.grades[i]) {
      //     _birthDate = Teacher.grades[i];
      //     break;
      //   }
      // }
      _gender = widget.teacherDomain!.gender;
      _inputBirthDate = DateTime.parse(widget.teacherDomain!.birthDate);

      for (var i = 0; i < Teacher.lessonList.length; i++) {
        for (var x = 0; x < widget.teacherDomain!.lessons.length; x++) {
          if (widget.teacherDomain!.lessons[x] == Teacher.lessonList[i]) {
            _lessons.add(Teacher.lessonList[i]);
            break;
          }
        }
      }
    }

    _formData = [
      {
        'controller': _firstNameController,
        'title': 'Nama Depan',
        'typeForm': 'text',
        'textInputType': TextInputType.text,
        'mandatory': true,
        'maxLines': 1
      },
      {
        'controller': _lastNameController,
        'title': 'Nama Belakang',
        'typeForm': 'text',
        'textInputType': TextInputType.text,
        'mandatory': true,
        'maxLines': 1
      },
      {
        'controller': _phoneController,
        'title': 'Nomor HP',
        'typeForm': 'text',
        'textInputType': TextInputType.phone,
        'mandatory': true,
        'maxLines': 1
      },
      {
        'title': 'Jenis Kelamin',
        'typeForm': 'radio',
        'mandatory': true,
      },
      {
        'title': 'Tanggal Lahir',
        'typeForm': 'date',
        'mandatory': true,
      },
      {
        'controller': _addressController,
        'title': 'Alamat',
        'typeForm': 'text',
        'textInputType': TextInputType.text,
        'mandatory': true,
        'maxLines': 3
      },
      {
        'title': 'Mata Pelajaran',
        'typeForm': 'checkbox',
        'mandatory': true,
      },
    ];
  }
}
