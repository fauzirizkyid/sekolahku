import 'package:faker/faker.dart';
import 'package:sekolahku/domain/student_domain.dart';
import 'package:sekolahku/util/random.dart';

seedStudent() {
  var faker = new Faker();
  var student = new Student();
  student.firstName = faker.person.firstName();
  student.lastName = faker.person.lastName();
  student.mobilePhone = "+62 " + faker.phoneNumber.random.integer(999999999).toString();
  student.gender = Student.genders[getRandom(2)];
  student.grade = Student.grades[getRandom(4)];
  student.address = faker.address.streetAddress();
  student.hobbies = Student.hobbiesList;

  return student;
}

generateStudents([int max = 5]) {
  List<Student> students = [];
  for (var i = 0; i < max; i++) {
    students.add(seedStudent());
  }

  return students;
}