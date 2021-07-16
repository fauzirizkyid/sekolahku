// lib/repository/student_repository.dart
import 'dart:core';
import 'dart:async';
import 'package:sekolahku/domain/student_domain.dart';
import 'package:sekolahku/model/model_provider.dart';
import 'package:sekolahku/seed/student_seed.dart';

class StudentRepository {
  static const String tableName = 'Siswa';
  List<Student> students = generateStudents();
  final ModelProvider? modelProvider;

  StudentRepository(this.modelProvider);

  Future<int> create(Student domain) {
    final siswa = domain.toMap();
    print('[db] is creating $siswa');
    return modelProvider!
        .getDatabase()
        .then((database) => database!.insert(tableName, siswa));
  }

  Future<List<Student>> findAll() {
    var sql = '''
    SELECT
        id_siswa AS id,
        first_name AS firstName,
        last_name AS lastName,
        mobile_phone AS mobilePhone,
        gender,
        grade,
        hobbies,
        address,
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
        List<Student> students = [];
        print(students);
        for (var i = 0; i < data.length; i++) {
          Student student = Student();
          student.fromMap(data[i]);
          students.add(student);
          print("masuk sini>");
        }

        print("students:" + students.length.toString());

        return students;
      }
    });
  }

  Future<Student> findOne(int id) {
    print("Masuk fungsi findOne dengan id: " + id.toString());
    final sql = '''
      SELECT
        id_siswa AS id,
        first_name AS firstName,
        last_name AS lastName,
        mobile_phone AS mobilePhone,
        gender,
        grade,
        hobbies,
        address,
        created_at AS createdAt,
        updated_at AS updatedAt
      FROM
        $tableName
      WHERE id_siswa = $id;
    ''';
    return modelProvider!
        .getDatabase()
        .then((database) => database!.rawQuery(sql))
        .then((data) async {
      print('[db] success retrieve $data by id = $id');
      final Student student = Student();
      if (data.length == 1) {
        student.fromMap(data[0]);

        return student;
      }

      return student;
    });
    // return students[index];
  }

  Future<void> delete(int idSiswa) {
    return modelProvider!
        .getDatabase()
        .then((value) => value!.delete('siswa', where: 'id_siswa = $idSiswa'));
  }

  Future<int> updateStudent(int? idStudent, Student student, String createdAt) {
    print("student.createdAt1");
    print("student.createdAt");
    print(createdAt);
    return modelProvider!.getDatabase().then((value) {
      return value!
          .update('siswa', student.toMap(createdData: createdAt), where: 'id_siswa = $idStudent');
    });
  }
}
