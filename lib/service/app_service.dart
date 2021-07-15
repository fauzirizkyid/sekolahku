import 'package:sekolahku/repository/student_repository.dart';
import 'package:sekolahku/service/student_service.dart';

StudentRepository _studentRepository = StudentRepository();
StudentService _studentService = StudentService(_studentRepository);

class AppService {
  static StudentService get studentService => _studentService;
}