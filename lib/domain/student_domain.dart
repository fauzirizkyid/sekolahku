import 'package:sekolahku/domain/domain.dart';
import 'package:sekolahku/util/capitalize.dart';

class Student extends Domain {
  static const genders = ['pria', 'wanita'];
  static const grades = ['tk', 'sd', 'smp', 'sma'];
  static const hobbiesList = ['membaca', 'menulis', 'menggambar'];

  late int idStudent;
  late String firstName;
  late String lastName;
  late String mobilePhone;
  late String gender;
  late String grade;
  late List<String> hobbies;
  late String address;
  late String createdAt;
  late String updatedAt;

  String get fullName => '${capitalize(firstName)} ${capitalize(lastName)}';

  Map<String, dynamic> toMap({String createdData = ''}) {
    var map = <String, dynamic>{
      'first_name': firstName,
      'last_name': lastName,
      'mobile_phone': mobilePhone,
      'gender': gender,
      'grade': grade,
      'hobbies': hobbies.join(', '),
      'address': address,
      'created_at':
          createdData != '' ? createdData : DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };

    return map;
  }

  void fromMap(Map<String, dynamic> value) {
    print(value);
    idStudent = value['id'];
    firstName = value['firstName'];
    lastName = value['lastName'];
    mobilePhone = value['mobilePhone'];
    gender = value['gender'];
    grade = value['grade'];
    address = value['address'];
    hobbies = value['hobbies'] is String ? value['hobbies'].split(', ') : [];
    createdAt = value['createdAt'];
    updatedAt = value['updatedAt'];
  }
}
