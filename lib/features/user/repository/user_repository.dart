import 'package:pessoas/features/user/model/user_model.dart';
import 'package:pessoas/features/user/model/user_persistence_model.dart';
import 'package:pessoas/features/user/repository/datasource/user_api_data_source.dart';
import 'package:pessoas/features/user/repository/datasource/user_local_data_source.dart';

abstract class UserRepository {
  Future<User> getNewUserFromApi();
  Future<List<User>> getPersistedUsers();
  Future<void> saveUser(User user);
  Future<void> deleteUser(User user);
  Future<bool> isUserPersisted(String uuid);
}

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl({
    required UserApiDataSource apiDataSource,
    required UserLocalDataSource localDataSource,
  })  : _apiDataSource = apiDataSource,
        _localDataSource = localDataSource;

  final UserApiDataSource _apiDataSource;
  final UserLocalDataSource _localDataSource;

  @override
  Future<User> getNewUserFromApi() {
    return _apiDataSource.getNewUser();
  }

  @override
  Future<List<User>> getPersistedUsers() async {
    final persistedUsers = await _localDataSource.getAllUsers();
    return persistedUsers.map((user) => user.toDomain()).toList();
  }

  @override
  Future<void> saveUser(User user) {
    final persistenceModel = UserPersistenceModel.fromUser(user);
    return _localDataSource.saveUser(persistenceModel);
  }

  @override
  Future<void> deleteUser(User user) {
    return _localDataSource.deleteUser(user.login.uuid);
  }

  @override
  Future<bool> isUserPersisted(String uuid) {
    return _localDataSource.exists(uuid);
  }
}
