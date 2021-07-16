import 'dart:async';
import 'package:sekolahku/domain/teacher_domain.dart';
import 'package:sekolahku/repository/teacher_repository.dart';

class TeacherService {
  final TeacherRepository repository;

  const TeacherService(this.repository);

  Future<int> createTeacher(Teacher domain) {
    return repository.create(domain);
  }

  Future<List<Teacher>> findAllTeachers() {
    return repository.findAll();
  }

  Future<Teacher> findTeacherBy({required int id}) {
    print("findTeacherBy: "+id.toString());
    return repository.findOne(id);
  }

  Future<void> deleteTeacherBy({required int index}) {
    return repository.delete(index);
  }

  Future<int> updateTeacher({int? id, required Teacher teacherDomain, required String createdAt}) {
    print(createdAt);
    return repository.updateTeacher(id, teacherDomain, createdAt);
  }
}
