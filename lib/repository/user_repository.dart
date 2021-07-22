// lib/repository/student_repository.dart
import 'dart:core';
import 'dart:async';
import 'package:sekolahku/domain/user_domain.dart';
import 'package:sekolahku/model/model_provider.dart';

class UserRepository {
  static const String tableName = 'User';
  final ModelProvider? modelProvider;

  UserRepository(this.modelProvider);

  Future<int> create(User domain) {
    final siswa = domain.toMap();
    print('[db] is creating $siswa');
    return modelProvider!
        .getDatabase()
        .then((database) => database!.insert(tableName, siswa));
  }

  Future<List<User>> findAll() {
    var sql = '''
    SELECT
        id_user AS id,
        first_name AS firstName,
        last_name AS lastName,
        mobile_phone AS mobilePhone,
        gender,
        address,
        username,
        password,
        created_at AS createdAt,
        updated_at AS updatedAt
      FROM
        $tableName
      ORDER BY created_at DESC;
    ''';
    return modelProvider!
        .getDatabase()
        .then((database) => database!.rawQuery(sql))
        .then((data) {
      print('[db] success retrieve $data');
      print('[db] success retrieve ' + data.length.toString());
      if (data.length == 0) {
        return [];
      } else {
        List<User> users = [];
        print(users);
        for (var i = 0; i < data.length; i++) {
          User user = User();
          user.fromMap(data[i]);
          users.add(user);
          print("masuk sini>");
        }

        print("users:" + users.length.toString());

        return users;
      }
    });
  }

  Future<bool> findUsernamePassword(
      {required String username, required String password}) async {
    final sql =
        "SELECT * FROM $tableName WHERE username = '$username' AND password = '$password'";
    print(sql);
    return modelProvider!
        .getDatabase()
        .then((value) => value!.rawQuery(sql))
        .then((data) {
      print(data.length);
      if (data.length == 1) {
        return true;
      }

      return false;
    });

    // return users[index];
  }

  Future<bool> checkCredential({required String username}) async {
    final sql = "SELECT * FROM $tableName WHERE username = '$username'";
    print(sql);
    return modelProvider!
        .getDatabase()
        .then((value) => value!.rawQuery(sql))
        .then((data) {
      print(data.length);
      if (data.length == 0) {
        return true;
      }

      return false;
    });

    // return users[index];
  }

  Future<void> delete(int idUser) {
    return modelProvider!
        .getDatabase()
        .then((value) => value!.delete('user', where: 'id_user = $idUser'));
  }

  Future<int> updateUser(int? idUser, User user, String createdAt) {
    return modelProvider!.getDatabase().then((value) {
      return value!.update('user', user.toMap(createdData: createdAt),
          where: 'id_user = $idUser');
    });
  }
}
