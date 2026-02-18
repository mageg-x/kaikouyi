/// 单词数据模型
/// 表示一个英语单词及其学习状态
class Word {
  final String id;                    // 单词唯一标识
  final String word;                 // 英文单词
  final String phonetic;             // 音标
  final String meaning;               // 中文释义
  final String? memoryTip;           // 记忆技巧
  final List<String> examples;       // 双语例句列表
  final List<String> translations;    // 例句翻译列表
  final WordStatus status;          // 学习状态
  final DateTime? nextReviewTime;   // 下次复习时间
  final int reviewCount;            // 复习次数
  final int correctCount;           // 正确次数

  Word({
    required this.id,
    required this.word,
    required this.phonetic,
    required this.meaning,
    this.memoryTip,
    this.examples = const [],
    this.translations = const [],
    this.status = WordStatus.newWord,
    this.nextReviewTime,
    this.reviewCount = 0,
    this.correctCount = 0,
  });

  /// 复制Word对象
  Word copyWith({
    String? id,
    String? word,
    String? phonetic,
    String? meaning,
    String? memoryTip,
    List<String>? examples,
    List<String>? translations,
    WordStatus? status,
    DateTime? nextReviewTime,
    int? reviewCount,
    int? correctCount,
  }) {
    return Word(
      id: id ?? this.id,
      word: word ?? this.word,
      phonetic: phonetic ?? this.phonetic,
      meaning: meaning ?? this.meaning,
      memoryTip: memoryTip ?? this.memoryTip,
      examples: examples ?? this.examples,
      translations: translations ?? this.translations,
      status: status ?? this.status,
      nextReviewTime: nextReviewTime ?? this.nextReviewTime,
      reviewCount: reviewCount ?? this.reviewCount,
      correctCount: correctCount ?? this.correctCount,
    );
  }

  /// 转换为Map格式用于数据库存储
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'word': word,
      'phonetic': phonetic,
      'meaning': meaning,
      'memoryTip': memoryTip,
      'examples': examples.join('|'),        // 用|分隔多个例句
      'translations': translations.join('|'), // 用|分隔多个翻译
      'status': status.index,                // 存储枚举的索引
      'nextReviewTime': nextReviewTime?.millisecondsSinceEpoch,
      'reviewCount': reviewCount,
      'correctCount': correctCount,
    };
  }

  /// 从Map格式恢复数据
  factory Word.fromMap(Map<String, dynamic> map) {
    return Word(
      id: map['id'],
      word: map['word'],
      phonetic: map['phonetic'],
      meaning: map['meaning'],
      memoryTip: map['memoryTip'],
      examples: (map['examples'] as String?)?.split('|') ?? [],
      translations: (map['translations'] as String?)?.split('|') ?? [],
      status: WordStatus.values[map['status'] ?? 0],
      nextReviewTime: map['nextReviewTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['nextReviewTime'])
          : null,
      reviewCount: map['reviewCount'] ?? 0,
      correctCount: map['correctCount'] ?? 0,
    );
  }
}

/// 单词学习状态枚举
enum WordStatus {
  newWord,     // 新词（未学习）
  known,       // 认识
  fuzzy,       // 模糊
  forgotten,   // 忘记
}

/// 词书数据模型
/// 表示一本词汇书及其学习进度
class WordBook {
  final String id;                // 词书唯一标识
  final String name;            // 词书名称
  final String description;     // 词书描述
  final int totalWords;        // 总单词数
  final int learnedWords;      // 已学单词数
  final int reviewedWords;     // 已复习单词数
  final bool isMain;           // 是否为主词书
  final bool isCompleted;      // 是否已完成

  WordBook({
    required this.id,
    required this.name,
    required this.description,
    required this.totalWords,
    this.learnedWords = 0,
    this.reviewedWords = 0,
    this.isMain = false,
    this.isCompleted = false,
  });

  /// 计算学习进度 (0.0 - 1.0)
  double get progress => totalWords > 0 ? learnedWords / totalWords : 0;
}
