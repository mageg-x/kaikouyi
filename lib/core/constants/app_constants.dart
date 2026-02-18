/// 应用常量配置
/// 存储应用中使用的固定数值和配置
class AppConstants {
  // 应用基本信息
  static const String appName = '开口易';
  static const String appVersion = '1.0.0';
  
  // SharedPreferences 键名
  static const String prefOnboardingComplete = 'onboarding_complete';
  static const String prefUserLevel = 'user_level';
  static const String prefUserName = 'user_name';
  static const String prefLastStudyDate = 'last_study_date';
  static const String prefTotalStudyDays = 'total_study_days';
  static const String prefCurrentStreak = 'current_streak';
  
  // 测试题目数量
  static const int vocabularyTestQuestions = 15; // 词汇测试题数
  static const int listeningTestQuestions = 10;  // 听力测试题数
  static const int speakingTestQuestions = 5;   // 口语测试题数
  
  // 每日学习任务数量
  static const int dailyNewWords = 5;    // 每日新词数
  static const int dailyReviewWords = 12; // 每日复习词数
  
  // 音频播放速度
  static const double slowSpeed = 0.75;   // 慢速
  static const double normalSpeed = 1.0;  // 常速
  static const double fastSpeed = 1.25;   // 快速
  
  // 测试时间限制（秒）
  static const int testTimeLimit = 30;
  
  // 数据库配置
  static const String dbName = 'kai_kou_yi.db';
  static const int dbVersion = 1;
}

/// 用户等级定义
class UserLevel {
  // 等级标识
  static const String beginner = 'A1';
  static const String elementary = 'A2';
  static const String intermediate = 'B1';
  static const String upperIntermediate = 'B2';
  static const String advanced = 'C1';
  static const String proficient = 'C2';
  
  /// 获取等级名称
  static String getLevelName(String level) {
    switch (level) {
      case beginner:
        return '入门';
      case elementary:
        return '初级';
      case intermediate:
        return '中级';
      case upperIntermediate:
        return '中高级';
      case advanced:
        return '高级';
      case proficient:
        return '精通';
      default:
        return '未知';
    }
  }
  
  /// 获取等级描述
  static String getLevelDescription(String level) {
    switch (level) {
      case beginner:
        return '能理解和使用日常用语';
      case elementary:
        return '能进行简单的日常对话';
      case intermediate:
        return '能理解工作、学校等常见话题';
      case upperIntermediate:
        return '能流畅交流各种话题';
      case advanced:
        return '能准确表达复杂观点';
      case proficient:
        return '接近母语水平';
      default:
        return '';
    }
  }
}
