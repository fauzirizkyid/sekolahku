import 'package:sekolahku/util/capitalize.dart';

class Student {
  static const genders = ['pria', 'wanita'];
  static const grades = ['tk', 'sd', 'smp', 'sma'];
  static const hobbiesList = ['membaca', 'menulis', 'menggambar'];

  String firstName = '';
  String lastName = '';
  String mobilePhone = '';
  String gender = '';
  String grade = '';
  List<String> hobbies = [];
  String address = '';

  String get fullName => '${capitalize(firstName)} ${capitalize(lastName)}';
}