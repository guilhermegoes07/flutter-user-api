import 'package:flutter/foundation.dart';
import 'package:pessoas/features/user/model/user_model.dart';
import 'package:pessoas/features/user/repository/user_repository.dart';

class PersistedViewModel extends ChangeNotifier {
  PersistedViewModel(this._repository);

  final UserRepository _repository;

  final List<User> _persistedUsers = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<User> get persistedUserList => List.unmodifiable(_persistedUsers);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchPersistedUsers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _repository.getPersistedUsers();
      _persistedUsers
        ..clear()
        ..addAll(result);
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> removeUser(User user) async {
    _errorMessage = null;
    try {
      await _repository.deleteUser(user);
      _persistedUsers.removeWhere((element) => element.login.uuid == user.login.uuid);
      notifyListeners();
    } catch (error) {
      _errorMessage = error.toString();
      notifyListeners();
    }
  }
}
