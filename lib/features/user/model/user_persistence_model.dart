import 'package:pessoas/features/user/model/user_model.dart';

class UserPersistenceModel {
  final Map<String, dynamic> _data;

  const UserPersistenceModel._(this._data);

  factory UserPersistenceModel.fromMap(Map<String, dynamic> map) {
    return UserPersistenceModel._({
      ...map,
    });
  }

  factory UserPersistenceModel.fromUser(User user) {
    return UserPersistenceModel._(user.toPersistenceMap());
  }

  Map<String, dynamic> toMap() {
    return {..._data};
  }

  String get uuid => _data['login_uuid'] as String? ?? '';

  User toDomain() {
    return User.fromPersistenceMap(_data);
  }
}
