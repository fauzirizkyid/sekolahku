import 'package:sekolahku/model/model_provider.dart';
import 'package:sekolahku/repository/student_repository.dart';
import 'package:sekolahku/service/student_service.dart';
import 'package:sqflite/sqflite.dart';

final StudentRepository _studentRepository =
    StudentRepository(ModelProvider.getInstance());
StudentService _studentService = StudentService(_studentRepository);

class AppService {
  static StudentService get studentService => _studentService;

  static Future<Database?> open() {
    return ModelProvider.getInstance()!.open();
  }

  static Future<void> close() {
    return ModelProvider.getInstance()!.close();
  }
}
