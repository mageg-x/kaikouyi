import 'package:flutter/material.dart';

/// 应用颜色配置
/// 统一管理应用中使用的所有颜色
class AppColors {
  // 主色调 - 蓝色系
  static const Color primary = Color(0xFF4A90E2);       // 主色
  static const Color primaryLight = Color(0xFF7AB3F0); // 浅主色
  static const Color primaryDark = Color(0xFF2D6BB0);  // 深主色
  
  // 辅色调 - 绿色系
  static const Color secondary = Color(0xFF7ED321);    // 辅色
  static const Color secondaryLight = Color(0xFFA5E66B);
  static const Color secondaryDark = Color(0xFF5BA118);
  
  // 强调色 - 橙色系
  static const Color accent = Color(0xFFF5A623);        // 强调色
  static const Color accentLight = Color(0xFFFFC870);
  static const Color accentDark = Color(0xFFD6870F);
  
  // 背景色
  static const Color background = Color(0xFFF8F9FA);   // 页面背景
  static const Color surface = Color(0xFFFFFFFF);       // 卡片/表面背景
  static const Color card = Color(0xFFFFFFFF);         // 卡片颜色
  
  // 文字颜色
  static const Color textPrimary = Color(0xFF2C3E50);   // 主要文字
  static const Color textSecondary = Color(0xFF7F8C8D); // 次要文字
  static const Color textHint = Color(0xFFBDC3C7);      // 提示文字
  
  // 状态颜色
  static const Color error = Color(0xFFE74C3C);         // 错误/红色
  static const Color success = Color(0xFF27AE60);       // 成功/绿色
  static const Color warning = Color(0xFFF39C12);       // 警告/黄色
  static const Color info = Color(0xFF3498DB);          // 信息/蓝色
  
  // 单词状态颜色
  static const Color wordKnown = Color(0xFF27AE60);      // 认识
  static const Color wordFuzzy = Color(0xFFF39C12);     // 模糊
  static const Color wordUnknown = Color(0xFFE74C3C);   // 忘记
  
  // 听力训练层级颜色
  static const Color listeningL1 = Color(0xFF27AE60);   // L1字幕全开
  static const Color listeningL2 = Color(0xFFF39C12);    // L2关键词
  static const Color listeningL3 = Color(0xFFE74C3C);   // L3无字幕
  
  // 口语评分颜色
  static const Color speakingGood = Color(0xFF27AE60);   // 优秀
  static const Color speakingMedium = Color(0xFFF39C12); // 中等
  static const Color speakingPoor = Color(0xFFE74C3C);  // 较差
}

/// 应用文字样式配置
/// 统一管理应用中使用的所有文字样式
class AppTextStyles {
  // 标题样式
  static const TextStyle headline1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );
  
  static const TextStyle headline2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
  );
  
  static const TextStyle headline3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  
  // 副标题样式
  static const TextStyle subtitle1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle subtitle2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );
  
  // 正文样式
  static const TextStyle body1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );
  
  static const TextStyle body2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.5,
  );
  
  // 辅助文字样式
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textHint,
  );
  
  // 按钮文字样式
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );
  
  // 单词显示样式
  static const TextStyle word = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: 1.0,
  );
  
  // 音标样式
  static const TextStyle phonetic = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    fontStyle: FontStyle.italic,
  );
}

/// 应用间距配置
/// 统一管理应用中使用的间距大小
class AppSpacing {
  static const double xs = 4.0;   // 超小间距
  static const double sm = 8.0;  // 小间距
  static const double md = 16.0; // 中等间距
  static const double lg = 24.0; // 大间距
  static const double xl = 32.0;  // 特大间距
  static const double xxl = 48.0; // 超大间距
}

/// 应用圆角配置
/// 统一管理应用中使用的圆角大小
class AppRadius {
  static const double sm = 4.0;      // 小圆角
  static const double md = 8.0;     // 中圆角
  static const double lg = 12.0;    // 大圆角
  static const double xl = 16.0;    // 特大圆角
  static const double xxl = 24.0;   // 超大圆角
  static const double circular = 100.0; // 圆形
}
