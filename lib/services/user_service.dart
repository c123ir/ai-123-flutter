import '../models/user.dart';

class UserService {
  // فقط برای تست - بعداً با API جایگزین می‌شود
  static final List<User> _users = [
    User(
      id: 1,
      name: 'مدیر سیستم',
      email: 'admin@example.com',
      phone: '09123456789',
      password: '123456',
      role: 'admin',
      createdAt: DateTime.now(),
    ),
  ];

  static Future<List<User>> getAllUsers() async {
    // شبیه‌سازی تأخیر شبکه
    await Future.delayed(const Duration(milliseconds: 500));
    return _users;
  }

  static Future<User?> getUserById(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _users.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }

  static Future<User?> loginUser(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 800));
    try {
      return _users.firstWhere(
        (user) => user.email == email && user.password == password,
      );
    } catch (e) {
      return null;
    }
  }

  static Future<User> createUser(User user) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final newUser = user.copyWith(
      id: _users.length + 1,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _users.add(newUser);
    return newUser;
  }

  static Future<User?> updateUser(int id, User user) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _users.indexWhere((u) => u.id == id);
    if (index != -1) {
      final updatedUser = user.copyWith(id: id, updatedAt: DateTime.now());
      _users[index] = updatedUser;
      return updatedUser;
    }
    return null;
  }

  static Future<bool> deleteUser(int id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _users.indexWhere((user) => user.id == id);
    if (index != -1) {
      _users.removeAt(index);
      return true;
    }
    return false;
  }

  static Future<List<User>> getUsersByRole(String role) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _users.where((user) => user.role == role).toList();
  }
}
