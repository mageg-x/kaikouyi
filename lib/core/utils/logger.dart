import 'package:flutter/foundation.dart';

/// 日志级别
enum LogLevel {
  debug,
  info,
  warning,
  error,
}

/// 应用日志工具类
/// 提供统一的日志输出功能，支持不同级别的日志记录
class AppLogger {
  static const String _tag = '开口易';
  
  /// Debug级别日志 - 用于调试信息
  static void debug(String message, {String? tag}) {
    _log(LogLevel.debug, message, tag: tag);
  }
  
  /// Info级别日志 - 用于普通信息
  static void info(String message, {String? tag}) {
    _log(LogLevel.info, message, tag: tag);
  }
  
  /// Warning级别日志 - 用于警告信息
  static void warning(String message, {String? tag}) {
    _log(LogLevel.warning, message, tag: tag);
  }
  
  /// Error级别日志 - 用于错误信息
  static void error(String message, {Object? error, StackTrace? stackTrace, String? tag}) {
    _log(LogLevel.error, message, tag: tag);
    if (error != null) {
      _log(LogLevel.error, 'Error: $error', tag: tag);
    }
    if (stackTrace != null) {
      _log(LogLevel.error, 'StackTrace: $stackTrace', tag: tag);
    }
  }
  
  /// 内部日志输出方法
  static void _log(LogLevel level, String message, {String? tag}) {
    final effectiveTag = tag ?? _tag;
    final timestamp = DateTime.now().toIso8601String();
    final levelStr = _getLevelString(level);
    
    // 在调试模式下输出日志
    if (kDebugMode) {
      final coloredMessage = '[$timestamp] [$levelStr] [$effectiveTag] $message';
      switch (level) {
        case LogLevel.debug:
          debugPrint(coloredMessage);
          break;
        case LogLevel.info:
          debugPrint(coloredMessage);
          break;
        case LogLevel.warning:
          debugPrint('\x1B[33m$coloredMessage\x1B[0m'); // 黄色
          break;
        case LogLevel.error:
          debugPrint('\x1B[31m$coloredMessage\x1B[0m'); // 红色
          break;
      }
    }
  }
  
  /// 获取日志级别字符串
  static String _getLevelString(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return 'DEBUG';
      case LogLevel.info:
        return 'INFO';
      case LogLevel.warning:
        return 'WARN';
      case LogLevel.error:
        return 'ERROR';
    }
  }
  
  /// 记录应用启动
  static void logAppStart() {
    info('========================================');
    info('应用启动 - 开口易');
    info('版本: 1.0.0');
    info('========================================');
  }
  
  /// 记录应用生命周期
  static void logAppLifecycleState(String state) {
    info('应用状态变更: $state');
  }
  
  /// 记录路由变化
  static void logRouteChange(String routeName, {Map<String, dynamic>? params}) {
    if (params != null && params.isNotEmpty) {
      info('路由跳转: $routeName, 参数: $params');
    } else {
      info('路由跳转: $routeName');
    }
  }
  
  /// 记录用户操作
  static void logUserAction(String action, {Map<String, dynamic>? data}) {
    if (data != null && data.isNotEmpty) {
      info('用户操作: $action, 数据: $data');
    } else {
      info('用户操作: $action');
    }
  }
  
  /// 记录网络请求
  static void logNetworkRequest(String url, String method, {Map<String, dynamic>? headers, Object? body}) {
    info('网络请求: $method $url');
    if (body != null) {
      debugPrint('请求体: $body');
    }
  }
  
  /// 记录网络响应
  static void logNetworkResponse(String url, int statusCode, {Object? body, int? durationMs}) {
    final duration = durationMs != null ? '${durationMs}ms' : '';
    info('网络响应: $url, 状态码: $statusCode, 耗时: $duration');
  }
  
  /// 记录数据库操作
  static void logDatabaseOperation(String operation, String table, {Map<String, dynamic>? data}) {
    debugPrint('数据库操作: $operation, 表: $table, 数据: $data');
  }
  
  /// 记录错误
  static void logError(String context, Object error, {StackTrace? stackTrace}) {
    _log(LogLevel.error, '[$context] $error');
    if (stackTrace != null) {
      _log(LogLevel.error, 'StackTrace: $stackTrace');
    }
  }
  
  /// 记录性能指标
  static void logPerformance(String operation, int durationMs) {
    if (durationMs > 1000) {
      warning('性能警告: $operation 耗时 ${durationMs}ms');
    } else {
      debugPrint('性能: $operation 耗时 ${durationMs}ms');
    }
  }
}
