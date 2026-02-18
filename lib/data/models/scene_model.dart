/// 场景数据模型
/// 表示一个学习场景（如咖啡店、机场等）
class Scene {
  final String id;              // 场景唯一标识
  final String name;          // 场景名称
  final String icon;          // 场景图标（emoji）
  final String description;   // 场景描述
  final List<String> tags;    // 场景标签
  final int wordCount;        // 单词数量
  final int dialogueCount;    // 对话数量
  final bool isLocked;       // 是否锁定
  final double progress;      // 学习进度 (0.0-1.0)

  Scene({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
    required this.tags,
    required this.wordCount,
    required this.dialogueCount,
    this.isLocked = false,
    this.progress = 0,
  });
}

/// 场景内容数据模型
/// 包含场景的单词和对话内容
class SceneContent {
  final String sceneId;           // 场景ID
  final List<SceneWord> words;  // 单词列表
  final List<SceneDialogue> dialogues; // 对话列表

  SceneContent({
    required this.sceneId,
    required this.words,
    required this.dialogues,
  });
}

/// 场景单词数据模型
class SceneWord {
  final String id;              // 单词ID
  final String word;          // 英文单词
  final String meaning;       // 中文释义
  final String phonetic;      // 音标
  final List<String> examples; // 例句列表

  SceneWord({
    required this.id,
    required this.word,
    required this.meaning,
    required this.phonetic,
    required this.examples,
  });
}

/// 场景对话数据模型
class SceneDialogue {
  final String id;                    // 对话ID
  final List<DialogueUtterance> utterances; // 台词列表

  SceneDialogue({
    required this.id,
    required this.utterances,
  });
}

/// 对话台词数据模型
class DialogueUtterance {
  final String speaker;           // 说话者
  final String text;            // 台词内容
  final String translation;     // 翻译
  final String? audioUrl;      // 音频URL
  final double? startTime;    // 开始时间
  final double? endTime;      // 结束时间

  DialogueUtterance({
    required this.speaker,
    required this.text,
    required this.translation,
    this.audioUrl,
    this.startTime,
    this.endTime,
  });
}
