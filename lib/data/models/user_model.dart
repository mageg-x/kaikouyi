/// 用户数据模型
/// 存储用户的基本信息、学习等级和成就等数据
class User {
  final String id;                // 用户唯一标识
  final String name;             // 用户名称
  final UserLevelInfo level;     // 用户等级信息
  final StudyStats stats;        // 学习统计数据
  final List<Achievement> achievements; // 用户成就列表
  final DateTime createdAt;      // 账户创建时间

  User({
    required this.id,
    required this.name,
    required this.level,
    required this.stats,
    this.achievements = const [],
    required this.createdAt,
  });

  /// 复制User对象，可选择性更新某些字段
  User copyWith({
    String? id,
    String? name,
    UserLevelInfo? level,
    StudyStats? stats,
    List<Achievement>? achievements,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      level: level ?? this.level,
      stats: stats ?? this.stats,
      achievements: achievements ?? this.achievements,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// 用户等级信息
/// 包含词汇、听力、口语三个维度的等级和分数
class UserLevelInfo {
  final String vocabularyLevel;   // 词汇等级 (A1-C2)
  final int vocabularyScore;     // 词汇分数 (0-100)
  final String listeningLevel;   // 听力等级
  final int listeningScore;     // 听力分数
  final String speakingLevel;    // 口语等级
  final int speakingScore;      // 口语分数
  final String overallLevel;    // 综合等级

  UserLevelInfo({
    required this.vocabularyLevel,
    required this.vocabularyScore,
    required this.listeningLevel,
    required this.listeningScore,
    required this.speakingLevel,
    required this.speakingScore,
    required this.overallLevel,
  });

  /// 创建初始等级信息
  factory UserLevelInfo.initial() {
    return UserLevelInfo(
      vocabularyLevel: 'A1',
      vocabularyScore: 0,
      listeningLevel: 'A1',
      listeningScore: 0,
      speakingLevel: 'A1',
      speakingScore: 0,
      overallLevel: 'A1',
    );
  }

  /// 转换为Map格式用于存储
  Map<String, dynamic> toMap() {
    return {
      'vocabularyLevel': vocabularyLevel,
      'vocabularyScore': vocabularyScore,
      'listeningLevel': listeningLevel,
      'listeningScore': listeningScore,
      'speakingLevel': speakingLevel,
      'speakingScore': speakingScore,
      'overallLevel': overallLevel,
    };
  }

  /// 从Map格式恢复数据
  factory UserLevelInfo.fromMap(Map<String, dynamic> map) {
    return UserLevelInfo(
      vocabularyLevel: map['vocabularyLevel'] ?? 'A1',
      vocabularyScore: map['vocabularyScore'] ?? 0,
      listeningLevel: map['listeningLevel'] ?? 'A1',
      listeningScore: map['listeningScore'] ?? 0,
      speakingLevel: map['speakingLevel'] ?? 'A1',
      speakingScore: map['speakingScore'] ?? 0,
      overallLevel: map['overallLevel'] ?? 'A1',
    );
  }

  /// 复制UserLevelInfo对象
  UserLevelInfo copyWith({
    String? vocabularyLevel,
    int? vocabularyScore,
    String? listeningLevel,
    int? listeningScore,
    String? speakingLevel,
    int? speakingScore,
    String? overallLevel,
  }) {
    return UserLevelInfo(
      vocabularyLevel: vocabularyLevel ?? this.vocabularyLevel,
      vocabularyScore: vocabularyScore ?? this.vocabularyScore,
      listeningLevel: listeningLevel ?? this.listeningLevel,
      listeningScore: listeningScore ?? this.listeningScore,
      speakingLevel: speakingLevel ?? this.speakingLevel,
      speakingScore: speakingScore ?? this.speakingScore,
      overallLevel: overallLevel ?? this.overallLevel,
    );
  }
}

/// 学习统计数据
/// 记录用户的学习天数、连续学习天数等
class StudyStats {
  final int totalStudyDays;           // 累计学习天数
  final int currentStreak;            // 当前连续学习天数
  final int totalWordsLearned;        // 已学单词总数
  final int totalListeningMinutes;    // 累计听力练习分钟数
  final int totalSpeakingMinutes;     // 累计口语练习分钟数
  final int totalExercises;           // 完成练习总数
  final DateTime? lastStudyDate;     // 上次学习日期

  StudyStats({
    this.totalStudyDays = 0,
    this.currentStreak = 0,
    this.totalWordsLearned = 0,
    this.totalListeningMinutes = 0,
    this.totalSpeakingMinutes = 0,
    this.totalExercises = 0,
    this.lastStudyDate,
  });

  /// 复制StudyStats对象
  StudyStats copyWith({
    int? totalStudyDays,
    int? currentStreak,
    int? totalWordsLearned,
    int? totalListeningMinutes,
    int? totalSpeakingMinutes,
    int? totalExercises,
    DateTime? lastStudyDate,
  }) {
    return StudyStats(
      totalStudyDays: totalStudyDays ?? this.totalStudyDays,
      currentStreak: currentStreak ?? this.currentStreak,
      totalWordsLearned: totalWordsLearned ?? this.totalWordsLearned,
      totalListeningMinutes: totalListeningMinutes ?? this.totalListeningMinutes,
      totalSpeakingMinutes: totalSpeakingMinutes ?? this.totalSpeakingMinutes,
      totalExercises: totalExercises ?? this.totalExercises,
      lastStudyDate: lastStudyDate ?? this.lastStudyDate,
    );
  }

  /// 转换为Map格式用于存储
  Map<String, dynamic> toMap() {
    return {
      'totalStudyDays': totalStudyDays,
      'currentStreak': currentStreak,
      'totalWordsLearned': totalWordsLearned,
      'totalListeningMinutes': totalListeningMinutes,
      'totalSpeakingMinutes': totalSpeakingMinutes,
      'totalExercises': totalExercises,
      'lastStudyDate': lastStudyDate?.millisecondsSinceEpoch,
    };
  }

  /// 从Map格式恢复数据
  factory StudyStats.fromMap(Map<String, dynamic> map) {
    return StudyStats(
      totalStudyDays: map['totalStudyDays'] ?? 0,
      currentStreak: map['currentStreak'] ?? 0,
      totalWordsLearned: map['totalWordsLearned'] ?? 0,
      totalListeningMinutes: map['totalListeningMinutes'] ?? 0,
      totalSpeakingMinutes: map['totalSpeakingMinutes'] ?? 0,
      totalExercises: map['totalExercises'] ?? 0,
      lastStudyDate: map['lastStudyDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['lastStudyDate'])
          : null,
    );
  }
}

/// 用户成就
/// 记录用户解锁的成就信息
class Achievement {
  final String id;            // 成就唯一标识
  final String title;        // 成就标题
  final String description;  // 成就描述
  final String icon;         // 成就图标
  final bool isUnlocked;     // 是否已解锁
  final DateTime? unlockedAt; // 解锁时间

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    this.isUnlocked = false,
    this.unlockedAt,
  });
}
