import 'package:flutter/material.dart';
import 'package:sekolahku/domain/student_domain.dart';
import 'package:sekolahku/service/app_service.dart';
import 'package:sekolahku/util/capitalize.dart';
import 'package:sekolahku/util/components.dart';

class StudentForm extends StatefulWidget {
  final String title;
  final bool isEdit;
  final Student? studentDomain;

  const StudentForm(
      {required this.title, required this.isEdit, this.studentDomain});

  @override
  _StudentFormState createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  final _formAddStudent = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  String? _gender;
  String? _grade;
  List<String> _hobbies = <String>[];
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
        key: _formAddStudent,
        child: ListView(
          padding: LayoutStyled.paddingAllSide,
          children: [
            ListView.builder(
                itemCount: _formData.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  if (_formData[index]['title'] == 'Jenis Kelamin') {
                    // _gender = Student.genders[0];
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
                            children: Student.genders
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
                  } else if (_formData[index]['title'] == 'Kelas') {
                    print(Student.grades);
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
                        DropdownButton<String>(
                          items: Student.grades
                              .map((valueGrade) => DropdownMenuItem(
                                  child: Text(valueGrade.toUpperCase()),
                                  value: valueGrade))
                              .toList(),
                          value: _grade,
                          onChanged: (value) {
                            setState(() {
                              _grade = value!;
                            });
                          },
                          isExpanded: true,
                          hint: Text("Pilih Kelas"),
                        ),
                      ],
                    );
                  } else if (_formData[index]['title'] == 'Hobi') {
                    print(Student.grades);
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
                          children: Student.hobbiesList
                              .map((valueHobby) => Container(
                                    child: Components.customCheckbox(
                                      text: capitalize(valueHobby),
                                      value: _hobbies.contains(valueHobby),
                                      onChanged: (value) {
                                        setState(() {
                                          if (_hobbies.contains(valueHobby)) {
                                            _hobbies.remove(valueHobby);
                                          } else {
                                            _hobbies.add(valueHobby);
                                          }
                                        });
                                      },
                                    ),
                                  ))
                              .toList(),
                        ),
                      ],
                    );
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
                if (_formAddStudent.currentState!.validate()) {
                  Student studentDomain = Student();
                  studentDomain.address = _addressController.text.trim();
                  studentDomain.hobbies = _hobbies;
                  studentDomain.grade = _grade!;
                  studentDomain.gender = _gender!;
                  studentDomain.mobilePhone = _phoneController.text.trim();
                  studentDomain.firstName = _firstNameController.text.trim();
                  studentDomain.lastName = _lastNameController.text.trim();

                  if (widget.isEdit) {
                    print(widget.studentDomain!.createdAt);
                    AppService.studentService
                        .updateStudent(
                            id: widget.studentDomain!.idStudent,
                            studentDomain: studentDomain,
                            createdAt: widget.studentDomain!.createdAt)
                        .then((value) {
                      Navigator.pop(context);
                    }).catchError((error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(error.toString())));
                    });
                  } else {
                    AppService.studentService
                        .createStudent(studentDomain)
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
      _firstNameController.text = widget.studentDomain!.firstName;
      _lastNameController.text = widget.studentDomain!.lastName;
      _phoneController.text = widget.studentDomain!.mobilePhone;
      _addressController.text = widget.studentDomain!.address;

      // for (var i = 0; i < Student.genders.length; i++) {
      //   if (widget.studentDomain!.gender == Student.genders[i]) {
      //     _gender = Student.genders[i];
      //     break;
      //   }
      // }

      // for (var i = 0; i < Student.grades.length; i++) {
      //   if (widget.studentDomain!.grade == Student.grades[i]) {
      //     _grade = Student.grades[i];
      //     break;
      //   }
      // }
      _gender = widget.studentDomain!.gender;
      _grade = widget.studentDomain!.grade;

      for (var i = 0; i < Student.hobbiesList.length; i++) {
        for (var x = 0; x < widget.studentDomain!.hobbies.length; x++) {
          if (widget.studentDomain!.hobbies[x] == Student.hobbiesList[i]) {
            _hobbies.add(Student.hobbiesList[i]);
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
        'title': 'Kelas',
        'typeForm': 'dropdown',
        'mandatory': true,
      },
      {
        'controller': _addressController,
        'title': 'Alamat',
        'typeForm': 'text',
        'textInputType': TextInputType.phone,
        'mandatory': true,
        'maxLines': 3
      },
      {
        'title': 'Hobi',
        'typeForm': 'checkbox',
        'mandatory': true,
      },
    ];
  }
}
