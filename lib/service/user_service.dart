import 'dart:async';
import 'package:sekolahku/domain/user_domain.dart';
import 'package:sekolahku/repository/user_repository.dart';

class UserService {
  final UserRepository repository;

  const UserService(this.repository);

  Future<int> createUser(User domain) {
    return repository.create(domain);
  }

  Future<List<User>> findAllUsers() {
    return repository.findAll();
  }

  Future<bool> findUsernamePassword(
      {required String username, required String password}) {
    print("findUserBy: " + username.toString());
    return repository.findUsernamePassword(
        username: username, password: password);
  }

  Future<bool> checkCredential({required String username}) {
    return repository.checkCredential(username: username);
  }

  Future<void> deleteUserBy({required int index}) {
    return repository.delete(index);
  }

  Future<int> updateUser(
      {int? id, required User userDomain, required String createdAt}) {
    print(createdAt);
    return repository.updateUser(id, userDomain, createdAt);
  }
}
