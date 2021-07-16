// lib/repository/student_repository.dart
import 'dart:core';
import 'dart:async';
import 'package:sekolahku/domain/teacher_domain.dart';
import 'package:sekolahku/model/model_provider.dart';

class TeacherRepository {
  static const String tableName = 'Guru';
  final ModelProvider? modelProvider;

  TeacherRepository(this.modelProvider);

  Future<int> create(Teacher domain) {
    final siswa = domain.toMap();
    print('[db] is creating $siswa');
    return modelProvider!
        .getDatabase()
        .then((database) => database!.insert(tableName, siswa));
  }

  Future<List<Teacher>> findAll() {
    var sql = '''
    SELECT
        id_guru AS id,
        first_name AS firstName,
        last_name AS lastName,
        mobile_phone AS mobilePhone,
        gender,
        address,
        lessons,
        birth_date AS birthDate,
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
        List<Teacher> teachers = [];
        print(teachers);
        for (var i = 0; i < data.length; i++) {
          Teacher teacher = Teacher();
          teacher.fromMap(data[i]);
          teachers.add(teacher);
          print("masuk sini>");
        }

        print("teachers:" + teachers.length.toString());

        return teachers;
      }
    });
  }

  Future<Teacher> findOne(int id) {
    print("Masuk fungsi findOne dengan id: " + id.toString());
    final sql = '''
      SELECT
        id_guru AS id,
        first_name AS firstName,
        last_name AS lastName,
        gender,
        mobile_phone AS mobilePhone,
        address,
        lessons,
        birth_date AS birthDate,
        created_at AS createdAt,
        updated_at AS updatedAt
      FROM
        $tableName
      WHERE id_guru = $id;
    ''';
    return modelProvider!
        .getDatabase()
        .then((database) => database!.rawQuery(sql))
        .then((data) async {
      print('[db] success retrieve $data by id = $id');
      final Teacher teacher = Teacher();
      if (data.length == 1) {
        teacher.fromMap(data[0]);

        return teacher;
      }

      return teacher;
    });
    // return teachers[index];
  }

  Future<void> delete(int idTeacher) {
    return modelProvider!
        .getDatabase()
        .then((value) => value!.delete('guru', where: 'id_guru = $idTeacher'));
  }

  Future<int> updateTeacher(int? idTeacher, Teacher teacher, String createdAt) {
    print(teacher.lessons);
    return modelProvider!.getDatabase().then((value) {
      return value!
          .update('guru', teacher.toMap(createdData: createdAt), where: 'id_guru = $idTeacher');
    });
  }
}
