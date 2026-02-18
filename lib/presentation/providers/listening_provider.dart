import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/listening_model.dart';

/// 听力材料列表Provider
final listeningMaterialsProvider = Provider<List<ListeningMaterial>>((ref) {
  return _sampleMaterials;
});

/// 当前听力材料
class CurrentListeningMaterialNotifier extends Notifier<ListeningMaterial?> {
  @override
  ListeningMaterial? build() => null;

  void set(ListeningMaterial? material) {
    state = material;
  }
}

final currentListeningMaterialProvider = NotifierProvider<CurrentListeningMaterialNotifier, ListeningMaterial?>(
  CurrentListeningMaterialNotifier.new,
);

/// 当前听力层级
class CurrentListeningLevelNotifier extends Notifier<ListeningLevel> {
  @override
  ListeningLevel build() => ListeningLevel.l1;

  void set(ListeningLevel level) {
    state = level;
  }
}

final currentListeningLevelProvider = NotifierProvider<CurrentListeningLevelNotifier, ListeningLevel>(
  CurrentListeningLevelNotifier.new,
);

/// 听力进度
class ListeningProgressNotifier extends Notifier<Map<String, ListeningProgress>> {
  @override
  Map<String, ListeningProgress> build() => {};

  void update(String materialId, ListeningProgress progress) {
    state = {...state, materialId: progress};
  }
}

final listeningProgressProvider = NotifierProvider<ListeningProgressNotifier, Map<String, ListeningProgress>>(
  ListeningProgressNotifier.new,
);

/// 听力训练进度Notifier
class ListeningNotifier extends Notifier<ListeningProgress?> {
  @override
  ListeningProgress? build() {
    return null;
  }

  void startPractice(String materialId, int totalSentences) {
    state = ListeningProgress(
      materialId: materialId,
      currentLevel: ListeningLevel.l1,
      completedSentences: 0,
      totalSentences: totalSentences,
      lastPracticeTime: DateTime.now(),
    );
  }

  void updateProgress(int completedSentences, ListeningLevel level) {
    if (state != null) {
      state = ListeningProgress(
        materialId: state!.materialId,
        currentLevel: level,
        completedSentences: completedSentences,
        totalSentences: state!.totalSentences,
        lastPracticeTime: DateTime.now(),
      );
    }
  }

  void complete() {
    state = null;
  }
}

final currentPracticeProvider = NotifierProvider<ListeningNotifier, ListeningProgress?>(ListeningNotifier.new);

/// 示例听力材料数据
final _sampleMaterials = [
  ListeningMaterial(
    id: 'lm1',
    title: '日常对话',
    subtitle: 'Coffee Shop Conversation',
    audioUrl: 'https://example.com/audio1.mp3',
    difficulty: '简单',
    duration: 120,
    level: ListeningLevel.l1,
    sentences: [
      ListeningSentence(
        id: 's1',
        text: 'Good morning! What can I get for you?',
        translation: '早上好！您想要点什么？',
        startTime: 0.0,
        endTime: 3.5,
        keywords: ['Good morning', 'get'],
      ),
      ListeningSentence(
        id: 's2',
        text: "I'd like a cup of coffee, please.",
        translation: '请给我一杯咖啡。',
        startTime: 3.5,
        endTime: 6.0,
        keywords: ['cup of coffee'],
      ),
      ListeningSentence(
        id: 's3',
        text: 'Would you like that for here or to go?',
        translation: '您想在这里喝还是外带？',
        startTime: 6.0,
        endTime: 9.0,
        keywords: ['here', 'to go'],
      ),
      ListeningSentence(
        id: 's4',
        text: "For here, please. How much is that?",
        translation: '在这里喝。多少钱？',
        startTime: 9.0,
        endTime: 12.0,
        keywords: ['how much'],
      ),
      ListeningSentence(
        id: 's5',
        text: "That's three fifty. Have a nice day!",
        translation: '三美元五十美分。祝您愉快！',
        startTime: 12.0,
        endTime: 15.0,
        keywords: ['three fifty', 'nice day'],
      ),
    ],
  ),
  ListeningMaterial(
    id: 'lm2',
    title: '机场值机',
    subtitle: 'Airport Check-in',
    audioUrl: 'https://example.com/audio2.mp3',
    difficulty: '中等',
    duration: 180,
    level: ListeningLevel.l2,
    sentences: [
      ListeningSentence(
        id: 's1',
        text: 'Good afternoon. May I have your passport please?',
        translation: '下午好。请给我您的护照好吗？',
        startTime: 0.0,
        endTime: 4.0,
        keywords: ['passport'],
      ),
      ListeningSentence(
        id: 's2',
        text: 'Here you go. I have a connecting flight to Paris.',
        translation: '给您。我需要转机去巴黎。',
        startTime: 4.0,
        endTime: 8.0,
        keywords: ['connecting flight', 'Paris'],
      ),
      ListeningSentence(
        id: 's3',
        text: 'Do you have any luggage to check in?',
        translation: '您有行李要托运吗？',
        startTime: 8.0,
        endTime: 11.0,
        keywords: ['luggage', 'check in'],
      ),
      ListeningSentence(
        id: 's4',
        text: 'Yes, just this one suitcase.',
        translation: '是的，就这一个行李箱。',
        startTime: 11.0,
        endTime: 14.0,
        keywords: ['suitcase'],
      ),
    ],
  ),
  ListeningMaterial(
    id: 'lm3',
    title: '餐厅点餐',
    subtitle: 'Restaurant Ordering',
    audioUrl: 'https://example.com/audio3.mp3',
    difficulty: '简单',
    duration: 150,
    level: ListeningLevel.l3,
    sentences: [
      ListeningSentence(
        id: 's1',
        text: "Welcome to Mario's. Table for two?",
        translation: '欢迎来到马里奥餐厅。两位吗？',
        startTime: 0.0,
        endTime: 3.5,
        keywords: ['table for two'],
      ),
      ListeningSentence(
        id: 's2',
        text: "Yes, we'd like a window seat please.",
        translation: '是的，我们想要靠窗的座位。',
        startTime: 3.5,
        endTime: 7.0,
        keywords: ['window seat'],
      ),
      ListeningSentence(
        id: 's3',
        text: "Of course. Here's the menu. Our specials today are...",
        translation: '当然可以。这是菜单。今天的特色菜是...',
        startTime: 7.0,
        endTime: 11.0,
        keywords: ['menu', 'specials'],
      ),
    ],
  ),
];
