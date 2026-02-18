import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/speaking_model.dart';

/// 口语材料列表Provider
final speakingMaterialsProvider = Provider<List<SpeakingMaterial>>((ref) {
  return _sampleSpeakingMaterials;
});

/// 当前口语材料
class CurrentSpeakingMaterialNotifier extends Notifier<SpeakingMaterial?> {
  @override
  SpeakingMaterial? build() => null;

  void set(SpeakingMaterial? material) {
    state = material;
  }
}

final currentSpeakingMaterialProvider = NotifierProvider<CurrentSpeakingMaterialNotifier, SpeakingMaterial?>(
  CurrentSpeakingMaterialNotifier.new,
);

/// 当前句子索引
class CurrentSentenceIndexNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void set(int index) {
    state = index;
  }
}

final currentSentenceIndexProvider = NotifierProvider<CurrentSentenceIndexNotifier, int>(
  CurrentSentenceIndexNotifier.new,
);

/// 口语评分
class SpeakingScoreNotifier extends Notifier<SpeakingScore> {
  @override
  SpeakingScore build() => SpeakingScore.empty();

  void set(SpeakingScore score) {
    state = score;
  }
}

final speakingScoreProvider = NotifierProvider<SpeakingScoreNotifier, SpeakingScore>(
  SpeakingScoreNotifier.new,
);

/// 录音状态
class IsRecordingNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void set(bool recording) {
    state = recording;
  }
}

final isRecordingProvider = NotifierProvider<IsRecordingNotifier, bool>(
  IsRecordingNotifier.new,
);

/// 对话场景列表
final dialogueScenariosProvider = Provider<List<DialogueScenario>>((ref) {
  return _sampleDialogues;
});

/// 当前对话
class CurrentDialogueNotifier extends Notifier<DialogueScenario?> {
  @override
  DialogueScenario? build() => null;

  void set(DialogueScenario? dialogue) {
    state = dialogue;
  }
}

final currentDialogueProvider = NotifierProvider<CurrentDialogueNotifier, DialogueScenario?>(
  CurrentDialogueNotifier.new,
);

/// 示例口语材料
final _sampleSpeakingMaterials = [
  SpeakingMaterial(id: 'sp1', title: 'How you doin?', source: '老友记', imageUrl: 'assets/images/friends.jpg', duration: 30, difficulty: '简单', sentences: [
    SpeakingSentence(id: 'ss1', text: 'How you doin?', translation: '你好吗？', audioUrl: 'assets/audio/how_you_doin.mp3', startTime: 0.0, endTime: 1.5),
    SpeakingSentence(id: 'ss2', text: "I'm doing great, thanks for asking.", translation: '我很好，谢谢你问。', audioUrl: 'assets/audio/im_doing_great.mp3', startTime: 1.5, endTime: 4.0),
  ]),
  SpeakingMaterial(id: 'sp2', title: "Here's looking at you", source: '卡萨布兰卡', imageUrl: 'assets/images/casablanca.jpg', duration: 45, difficulty: '中等', sentences: [
    SpeakingSentence(id: 'ss1', text: "Here's looking at you, kid.", translation: '看着你，孩子。', audioUrl: 'assets/audio/looking_at_you.mp3', startTime: 0.0, endTime: 3.0),
  ]),
];

/// 示例对话场景
final _sampleDialogues = [
  DialogueScenario(id: 'd1', title: '咖啡店点单', description: '在咖啡店点单', role: '顾客', difficulty: '简单', lines: [
    DialogueLine(speaker: '店员', text: 'What can I get you?', translation: '您想要什么？', isUser: false),
    DialogueLine(speaker: '你', text: 'A large cappuccino, please.', translation: '请给我一大杯卡布奇诺。', isUser: true),
  ]),
];
