import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/theme.dart';
import 'core/router/app_router.dart';
import 'core/utils/logger.dart';
import 'data/services/storage_service.dart';
import 'data/services/database_service.dart';
import 'ui/providers/user_provider.dart';

/// 应用入口函数
/// 初始化Flutter框架、本地存储和数据库
Future<void> main() async {
  // 记录应用启动
  AppLogger.logAppStart();
  
  // 确保Flutter框架已初始化
  WidgetsFlutterBinding.ensureInitialized();
  AppLogger.debug('Flutter框架已初始化');
  
  // 设置系统状态栏样式
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  AppLogger.debug('系统状态栏样式已设置');

  // 初始化本地存储服务
  AppLogger.info('正在初始化本地存储服务...');
  final storage = await StorageService.getInstance();
  AppLogger.info('本地存储服务初始化完成');
  
  // 初始化本地数据库服务
  AppLogger.info('正在初始化本地数据库...');
  await DatabaseService.getInstance();
  AppLogger.info('本地数据库初始化完成');

  // 运行应用，注入ProviderScope和依赖
  AppLogger.info('正在启动应用...');
  runApp(
    ProviderScope(
      overrides: [
        // 注入存储服务Provider
        storageServiceProvider.overrideWithValue(storage),
      ],
      child: const KaiKouYiApp(),
    ),
  );
}

/// 应用根组件
/// 配置路由、主题等全局设置
class KaiKouYiApp extends ConsumerWidget {
  const KaiKouYiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppLogger.debug('KaiKouYiApp build方法被调用');
    
    // 获取路由配置
    final router = ref.watch(routerProvider);
    AppLogger.debug('路由配置已加载');

    return MaterialApp.router(
      title: '开口易',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
