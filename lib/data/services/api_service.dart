import 'package:dio/dio.dart';

class ApiService {
  static const String baseUrl = 'http://110.42.45.16:8080/api';

  static late final Dio _dio;
  static String? _token;

  static void init() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ));
  }

  static void setToken(String? token) {
    _token = token;
  }

  static String? getToken() {
    return _token;
  }

  static Map<String, String> get _headers {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  static Future<Map<String, dynamic>> register(
    String username,
    String password,
    String nickname,
  ) async {
    try {
      final response = await _dio.post(
        '/auth/register',
        data: {
          'username': username,
          'password': password,
          'nickname': nickname,
        },
      );

      if (response.statusCode == 201) {
        final data = response.data;
        if (data['token'] != null) {
          setToken(data['token']);
        }
        return data;
      } else {
        throw Exception(response.data['error'] ?? '注册失败');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? '注册失败');
    }
  }

  static Future<Map<String, dynamic>> login(
    String username,
    String password,
  ) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['token'] != null) {
          setToken(data['token']);
        }
        return data;
      } else {
        throw Exception(response.data['error'] ?? '登录失败');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? '登录失败');
    }
  }

  static Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await _dio.get(
        '/user/profile',
        options: Options(headers: _headers),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('获取用户信息失败');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? '获取用户信息失败');
    }
  }

  static Future<Map<String, dynamic>> updateProfile({
    String? nickname,
    String? avatar,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (nickname != null) data['nickname'] = nickname;
      if (avatar != null) data['avatar'] = avatar;

      final response = await _dio.put(
        '/user/profile',
        data: data,
        options: Options(headers: _headers),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('更新用户信息失败');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? '更新用户信息失败');
    }
  }

  static Future<Map<String, dynamic>> updateLevel(
      Map<String, dynamic> level) async {
    try {
      final response = await _dio.put(
        '/user/level',
        data: level,
        options: Options(headers: _headers),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('更新等级失败');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? '更新等级失败');
    }
  }

  static Future<Map<String, dynamic>> updateStats(
      Map<String, dynamic> stats) async {
    try {
      final response = await _dio.put(
        '/user/stats',
        data: stats,
        options: Options(headers: _headers),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('更新统计数据失败');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? '更新统计数据失败');
    }
  }

  static Future<void> logout() async {
    setToken(null);
  }
}
