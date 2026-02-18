import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/scene_model.dart';

/// 场景列表Provider
final scenesProvider = Provider<List<Scene>>((ref) {
  return _sampleScenes;
});

/// 当前场景
class CurrentSceneNotifier extends Notifier<Scene?> {
  @override
  Scene? build() => null;

  void set(Scene? scene) {
    state = scene;
  }
}

final currentSceneProvider = NotifierProvider<CurrentSceneNotifier, Scene?>(
  CurrentSceneNotifier.new,
);

/// 场景进度
class SceneProgressNotifier extends Notifier<Map<String, double>> {
  @override
  Map<String, double> build() => {};

  void update(String sceneId, double progress) {
    state = {...state, sceneId: progress};
  }
}

final sceneProgressProvider = NotifierProvider<SceneProgressNotifier, Map<String, double>>(
  SceneProgressNotifier.new,
);

/// 示例场景数据
final _sampleScenes = [
  Scene(id: 'scene1', name: '咖啡店', icon: '☕', description: '学习咖啡店点单相关词汇和对话', tags: ['日常', '饮食', '口语'], wordCount: 15, dialogueCount: 3, progress: 0.3),
  Scene(id: 'scene2', name: '机场', icon: '✈️', description: '掌握机场值机、行李托运等场景', tags: ['旅行', '交通', '实用'], wordCount: 20, dialogueCount: 2, progress: 0),
  Scene(id: 'scene3', name: '酒店', icon: '🏨', description: '酒店入住、退房等场景用语', tags: ['旅行', '住宿', '实用'], wordCount: 18, dialogueCount: 2, progress: 0),
  Scene(id: 'scene4', name: '餐厅', icon: '🍽️', description: '餐厅点餐、用餐礼仪', tags: ['日常', '饮食', '口语'], wordCount: 16, dialogueCount: 3, progress: 0),
  Scene(id: 'scene5', name: '外企面试', icon: '💼', description: '面试常见问题及回答技巧', tags: ['职场', '面试', '专业'], wordCount: 25, dialogueCount: 4, progress: 0),
  Scene(id: 'scene6', name: '商场购物', icon: '🛍️', description: '购物、砍价、结账场景', tags: ['日常', '购物', '实用'], wordCount: 15, dialogueCount: 2, progress: 0),
];

/// 场景内容Provider
final sceneContentProvider = FutureProvider.family<SceneContent, String>((ref, sceneId) async {
  return _getSceneContent(sceneId);
});

SceneContent _getSceneContent(String sceneId) {
  switch (sceneId) {
    case 'scene1':
      return SceneContent(sceneId: sceneId, words: [
        SceneWord(id: 'w1', word: 'cappuccino', meaning: '卡布奇诺', phonetic: '/ˌkæpəˈtʃiːnəʊ/', examples: ['I would like a cappuccino.']),
        SceneWord(id: 'w2', word: 'espresso', meaning: '浓缩咖啡', phonetic: '/eˈspresəʊ/', examples: ['Double espresso, please.']),
        SceneWord(id: 'w3', word: 'latte', meaning: '拿铁', phonetic: '/ˈlɑːteɪ/', examples: ['A vanilla latte, please.']),
      ], dialogues: []);
    default:
      return SceneContent(sceneId: sceneId, words: [], dialogues: []);
  }
}
