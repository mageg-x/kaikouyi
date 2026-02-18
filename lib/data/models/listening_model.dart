/// 听力材料数据模型
/// 表示一段用于听力训练的音频材料
class ListeningMaterial {
  final String id;              // 材料唯一标识
  final String title;        // 材料标题
  final String subtitle;      // 材料副标题
  final String audioUrl;     // 音频URL
  final String? videoUrl;    // 视频URL（可选）
  final String? imageUrl;    // 图片URL（可选）
  final String difficulty;   // 难度级别
  final int duration;        // 时长（秒）
  final List<ListeningSentence> sentences; // 句子列表
  final ListeningLevel level; // 听力层级

  ListeningMaterial({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.audioUrl,
    this.videoUrl,
    this.imageUrl,
    required this.difficulty,
    required this.duration,
    required this.sentences,
    required this.level,
  });
}

/// 听力句子数据模型
/// 表示听力材料中的一个句子
class ListeningSentence {
  final String id;                  // 句子唯一标识
  final String text;              // 英文原文
  final String translation;       // 中文翻译
  final double startTime;        // 开始时间（秒）
  final double endTime;          // 结束时间（秒）
  final List<String> keywords;   // 关键词列表
  final String? pronunciation;   // 发音提示（可选）

  ListeningSentence({
    required this.id,
    required this.text,
    required this.translation,
    required this.startTime,
    required this.endTime,
    this.keywords = const [],
    this.pronunciation,
  });
}

/// 听力训练层级枚举
enum ListeningLevel {
  l1,  // L1: 字幕全开（安全感）
  l2,  // L2: 关键词保留（抓重点）
  l3,  // L3: 无字幕挑战（纯听）
}

/// ListeningLevel的扩展方法
extension ListeningLevelExtension on ListeningLevel {
  /// 获取层级名称
  String get name {
    switch (this) {
      case ListeningLevel.l1:
        return '字幕全开';
      case ListeningLevel.l2:
        return '关键词保留';
      case ListeningLevel.l3:
        return '无字幕挑战';
    }
  }

  /// 获取层级描述
  String get description {
    switch (this) {
      case ListeningLevel.l1:
        return '安全感 - 看着字幕听';
      case ListeningLevel.l2:
        return '抓重点 - 只保留关键词';
      case ListeningLevel.l3:
        return '纯听力 - 无字幕挑战';
    }
  }
}

/// 听力训练进度
class ListeningProgress {
  final String materialId;            // 材料ID
  final ListeningLevel currentLevel; // 当前层级
  final int completedSentences;      // 已完成句子数
  final int totalSentences;         // 总句子数
  final DateTime lastPracticeTime;  // 最后练习时间

  ListeningProgress({
    required this.materialId,
    required this.currentLevel,
    required this.completedSentences,
    required this.totalSentences,
    required this.lastPracticeTime,
  });

  /// 计算进度百分比
  double get progress => totalSentences > 0 ? completedSentences / totalSentences : 0;
}
