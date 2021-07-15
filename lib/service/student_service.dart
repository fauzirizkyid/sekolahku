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
    return repository.findOne(id);
  }

  void deleteStudentBy({required int index}) {
    return repository.delete(index);
  }
}
