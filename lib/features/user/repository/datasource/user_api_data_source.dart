import 'package:dio/dio.dart';
import 'package:pessoas/features/user/model/user_model.dart';

abstract class UserApiDataSource {
  Future<User> getNewUser();
}

class UserApiDataSourceImpl implements UserApiDataSource {
  UserApiDataSourceImpl(Dio dio)
      : _dio = dio
          ..options.baseUrl = _baseUrl;

  final Dio _dio;
  static const String _baseUrl = 'https://randomuser.me/api/';
  static const String _apiVersion = '1.4/';

  @override
  Future<User> getNewUser() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        _apiVersion,
        queryParameters: const {'noinfo': ''},
      );

      final statusCode = response.statusCode ?? 500;
      final data = response.data;
      if (statusCode == 200 && data != null) {
        final results = data['results'];
        if (results is List && results.isNotEmpty) {
          final userData = results.first as Map<String, dynamic>;
          return User.fromJson(userData);
        }
        throw const FormatException('API returned an unexpected payload');
      }
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'Unexpected status code $statusCode',
        type: DioExceptionType.badResponse,
      );
    } on DioException catch (e) {
      if (e.response?.data is Map && (e.response!.data as Map)['error'] != null) {
        final errorMessage = (e.response!.data as Map)['error'];
        throw Exception('API Error: $errorMessage');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unknown error: $e');
    }
  }
}
