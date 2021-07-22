import 'package:sekolahku/model/model_provider.dart';
import 'package:sekolahku/repository/student_repository.dart';
import 'package:sekolahku/repository/teacher_repository.dart';
import 'package:sekolahku/repository/user_repository.dart';
import 'package:sekolahku/service/student_service.dart';
import 'package:sekolahku/service/teacher_service.dart';
import 'package:sekolahku/service/user_service.dart';
import 'package:sqflite/sqflite.dart';

final StudentRepository _studentRepository =
    StudentRepository(ModelProvider.getInstance());
final TeacherRepository _teacherRepository =
    TeacherRepository(ModelProvider.getInstance());
final UserRepository _userRepository =
    UserRepository(ModelProvider.getInstance());

StudentService _studentService = StudentService(_studentRepository);
TeacherService _teacherService = TeacherService(_teacherRepository);
UserService _userService = UserService(_userRepository);

class AppService {
  static StudentService get studentService => _studentService;
  static TeacherService get teacherService => _teacherService;
  static UserService get userService => _userService;

  static Future<Database?> open() {
    return ModelProvider.getInstance()!.open();
  }

  static Future<void> close() {
    return ModelProvider.getInstance()!.close();
  }
}
