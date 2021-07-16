import 'dart:async';
import 'package:sekolahku/domain/student_domain.dart';
import 'package:sekolahku/repository/student_repository.dart';

class StudentService {
  final StudentRepository repository;

  const StudentService(this.repository);

  Future<int> createStudent(Student domain) {
    return repository.create(domain);
  }

  Future<List<Student>> findAllStudents() {
    return repository.findAll();
  }

  Future<Student> findStudentBy({required int id}) {
    print("findStudentBy: "+id.toString());
    return repository.findOne(id);
  }

  Future<void> deleteStudentBy({required int index}) {
    return repository.delete(index);
  }

  Future<int> updateStudent({int? id, required Student studentDomain, required String createdAt}) {
    print(createdAt);
    return repository.updateStudent(id, studentDomain, createdAt);
  }
}
