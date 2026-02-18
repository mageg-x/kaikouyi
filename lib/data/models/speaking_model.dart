/// 口语材料数据模型
/// 表示一段用于影子跟读的影视素材
class SpeakingMaterial {
  final String id;              // 材料唯一标识
  final String title;        // 材料标题（如台词）
  final String source;        // 来源（如电影名）
  final String imageUrl;     // 图片URL
  final List<SpeakingSentence> sentences; // 句子列表
  final int duration;        // 时长（秒）
  final String difficulty;   // 难度级别

  SpeakingMaterial({
    required this.id,
    required this.title,
    required this.source,
    required this.imageUrl,
    required this.sentences,
    required this.duration,
    required this.difficulty,
  });
}

/// 口语练习句子数据模型
class SpeakingSentence {
  final String id;                // 句子唯一标识
  final String text;            // 英文原文
  final String translation;     // 中文翻译
  final String audioUrl;       // 音频URL
  final double startTime;    // 开始时间
  final double endTime;      // 结束时间
  final String? pronunciation; // 发音提示
  final List<String>? keyPoints; // 要点提示

  SpeakingSentence({
    required this.id,
    required this.text,
    required this.translation,
    required this.audioUrl,
    required this.startTime,
    required this.endTime,
    this.pronunciation,
    this.keyPoints,
  });
}

/// 口语评分数据模型
/// 包含发音、流利度、语调等评分
class SpeakingScore {
  final double pronunciation; // 发音准确度 (0-100)
  final double fluency;      // 流利度 (0-100)
  final double intonation;  // 语调自然度 (0-100)
  final double overall;     // 综合评分 (0-100)
  final List<String> feedback; // 改进建议列表

  SpeakingScore({
    required this.pronunciation,
    required this.fluency,
    required this.intonation,
    required this.overall,
    this.feedback = const [],
  });

  /// 创建空评分
  factory SpeakingScore.empty() {
    return SpeakingScore(
      pronunciation: 0,
      fluency: 0,
      intonation: 0,
      overall: 0,
    );
  }

  /// 获取评分等级
  String get grade {
    if (overall >= 90) return 'A+';
    if (overall >= 80) return 'A';
    if (overall >= 70) return 'B+';
    if (overall >= 60) return 'B';
    if (overall >= 50) return 'C';
    return 'D';
  }
}

/// 对话场景数据模型
/// 用于AI角色扮演练习
class DialogueScenario {
  final String id;              // 场景唯一标识
  final String title;          // 场景标题
  final String description;    // 场景描述
  final String role;         // 用户扮演的角色
  final List<DialogueLine> lines; // 对话内容列表
  final String difficulty;     // 难度级别

  DialogueScenario({
    required this.id,
    required this.title,
    required this.description,
    required this.role,
    required this.lines,
    required this.difficulty,
  });
}

/// 对话台词数据模型
class DialogueLine {
  final String speaker;       // 说话者
  final String text;         // 台词内容
  final String translation;  // 翻译
  final String? audioUrl;   // 音频URL（可选）
  final bool isUser;        // 是否是用户说的

  DialogueLine({
    required this.speaker,
    required this.text,
    required this.translation,
    this.audioUrl,
    this.isUser = false,
  });
}
