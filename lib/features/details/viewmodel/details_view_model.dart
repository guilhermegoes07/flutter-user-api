import 'package:flutter/foundation.dart';
import 'package:pessoas/features/user/model/user_model.dart';
import 'package:pessoas/features/user/repository/user_repository.dart';

class DetailsViewModel extends ChangeNotifier {
  DetailsViewModel(this._repository);

  final UserRepository _repository;

  User? _selectedUser;
  bool _isPersisted = false;
  bool _isProcessing = false;
  String? _errorMessage;

  User get selectedUser => _selectedUser!;
  bool get isPersisted => _isPersisted;
  bool get isProcessing => _isProcessing;
  String? get errorMessage => _errorMessage;

  Future<void> loadUser(User user) async {
    _selectedUser = user;
    _errorMessage = null;
    _isProcessing = true;
    notifyListeners();
    try {
      _isPersisted = await _repository.isUserPersisted(user.login.uuid);
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  Future<void> togglePersistence() async {
    final user = _selectedUser;
    if (user == null || _isProcessing) {
      return;
    }

    _isProcessing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_isPersisted) {
        await _repository.deleteUser(user);
        _isPersisted = false;
      } else {
        await _repository.saveUser(user);
        _isPersisted = true;
      }
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }
}
