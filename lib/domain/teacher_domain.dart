import 'package:sekolahku/domain/domain.dart';
import 'package:sekolahku/util/capitalize.dart';

class Teacher extends Domain {
  static const genders = ['pria', 'wanita'];
  static const lessonList = ["matematika", "fisika", "kimia"];

  late int idTeacher;
  late String firstName;
  late String lastName;
  late String mobilePhone;
  late String gender;
  late List<String> lessons;
  late String address;
  late String birthDate;
  late String createdAt;
  late String updatedAt;

  String get fullName => '${capitalize(firstName)} ${capitalize(lastName)}';

  Map<String, dynamic> toMap({String createdData = ''}) {
    var map = <String, dynamic>{
      'first_name': firstName,
      'last_name': lastName,
      'mobile_phone': mobilePhone,
      'gender': gender,
      'lessons': lessons.join(', '),
      'address': address,
      'birth_date': birthDate,
      'created_at':
          createdData != '' ? createdData : DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };

    return map;
  }

  void fromMap(Map<String, dynamic> value) {
    print(value);
    idTeacher = value['id'];
    firstName = value['firstName'];
    lastName = value['lastName'];
    mobilePhone = value['mobilePhone'];
    gender = value['gender'];
    address = value['address'];
    lessons = value['lessons'] is String ? value['lessons'].split(', ') : [];
    birthDate = value['birthDate'];
    createdAt = value['createdAt'];
    updatedAt = value['updatedAt'];
  }
}
