import 'package:sekolahku/domain/domain.dart';
import 'package:sekolahku/util/capitalize.dart';

class User extends Domain {
  static const genders = ['pria', 'wanita'];

  late int idUser;
  late String firstName;
  late String lastName;
  late String mobilePhone;
  late String gender;
  late String address;
  late String username;
  late String password;
  late String createdAt;
  late String updatedAt;

  String get fullName => '${capitalize(firstName)} ${capitalize(lastName)}';

  Map<String, dynamic> toMap({String createdData = ''}) {
    var map = <String, dynamic>{
      'first_name': firstName,
      'last_name': lastName,
      'mobile_phone': mobilePhone,
      'gender': gender,
      'address': address,
      'username': username,
      'password': password,
      'created_at':
          createdData != '' ? createdData : DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };

    return map;
  }

  void fromMap(Map<String, dynamic> value) {
    print(value);
    idUser = value['id'];
    firstName = value['firstName'];
    lastName = value['lastName'];
    mobilePhone = value['mobilePhone'];
    gender = value['gender'];
    address = value['address'];
    username = value['username'];
    password = value['password'];
    createdAt = value['createdAt'];
    updatedAt = value['updatedAt'];
  }
}
