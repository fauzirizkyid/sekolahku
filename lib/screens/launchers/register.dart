import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sekolahku/domain/user_domain.dart';
import 'package:sekolahku/service/app_service.dart';
import 'package:sekolahku/util/capitalize.dart';
import 'package:sekolahku/widgets/components.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formAddUser = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _gender;
  bool _obsecureText = true;
  IconData _iconDataPassword = FontAwesomeIcons.eyeSlash;
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
          title: Text('Registrasi'),
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
        key: _formAddUser,
        child: ListView(
          padding: LayoutStyled.paddingAllSide,
          children: [
            ListView.builder(
                itemCount: _formData.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  if (_formData[index]['title'] == 'Jenis Kelamin') {
                    // _gender = User.genders[0];
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
                            children: User.genders
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
                  }
                  if (_formData[index]['title'] == 'Password') {
                    return Components.textForm(
                        inputController: _formData[index]['controller'],
                        title: _formData[index]['title'],
                        hint: 'Masukkan ' + _formData[index]['title'],
                        inputType: _formData[index]['textInputType'],
                        mandatory: _formData[index]['mandatory'],
                        maxLines: _formData[index]['maxLines'],
                        obsecureText: _obsecureText,
                        icon: _iconDataPassword,
                        iconTap: _toggle);
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
                if (_formAddUser.currentState!.validate()) {
                  User userDomain = User();
                  userDomain.address = _addressController.text.trim();
                  userDomain.username =
                      _usernameController.text.trim().toLowerCase();
                  userDomain.password = _passwordController.text.trim();
                  userDomain.gender = _gender!;
                  userDomain.mobilePhone = _phoneController.text.trim();
                  userDomain.firstName = _firstNameController.text.trim();
                  userDomain.lastName = _lastNameController.text.trim();

                  AppService.userService
                      .checkCredential(username: userDomain.username)
                      .then((value) {
                    print(value);
                    if (value) {
                      AppService.userService
                          .createUser(userDomain)
                          .then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Profil anda berhasil didaftarkan'
                                .toString())));
                        Navigator.pop(context);
                      }).catchError((error) {
                        print(error);
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(error.toString())));
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                              Text('Username sudah terdaftar'.toString())));
                    }
                  }).catchError((error) {
                    print(error);
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(error.toString())));
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text('Silahkan isi semua data'),
                    duration: const Duration(seconds: 1),
                  ));
                }
              },
              child: Text('Registrasi'),
            )
          ],
        ),
      );

  void _toggle() {
    setState(() {
      _obsecureText = !_obsecureText;

      _iconDataPassword =
          _obsecureText ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye;
    });
  }

  void _initFormData() {
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
        'controller': _addressController,
        'title': 'Alamat',
        'typeForm': 'text',
        'textInputType': TextInputType.text,
        'mandatory': true,
        'maxLines': 3
      },
      {
        'controller': _usernameController,
        'title': 'Username',
        'typeForm': 'text',
        'textInputType': TextInputType.text,
        'mandatory': true,
        'maxLines': 1
      },
      {
        'controller': _passwordController,
        'title': 'Password',
        'typeForm': 'text',
        'textInputType': TextInputType.visiblePassword,
        'mandatory': true,
        'maxLines': 1
      },
    ];
  }
}
