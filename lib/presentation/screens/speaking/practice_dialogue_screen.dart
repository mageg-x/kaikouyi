import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/speaking_model.dart';
import '../../providers/speaking_provider.dart';

class PracticeDialogueScreen extends ConsumerStatefulWidget {
  const PracticeDialogueScreen({super.key});

  @override
  ConsumerState<PracticeDialogueScreen> createState() => _PracticeDialogueScreenState();
}

class _PracticeDialogueScreenState extends ConsumerState<PracticeDialogueScreen> {
  int _currentIndex = 0;
  bool _isRecording = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scenarios = ref.watch(dialogueScenariosProvider);
    final currentDialogue = ref.watch(currentDialogueProvider);

    if (currentDialogue == null) {
      return _ScenarioSelectionScreen(
        scenarios: scenarios,
        onSelect: (scenario) {
          ref.read(currentDialogueProvider.notifier).set(scenario);
        },
      );
    }

    return _DialoguePracticeScreen(
      dialogue: currentDialogue,
      currentIndex: _currentIndex,
      isRecording: _isRecording,
      onRecordToggle: () {
        setState(() => _isRecording = !_isRecording);
      },
      onNext: () {
        if (_currentIndex < currentDialogue.lines.length - 1) {
          setState(() => _currentIndex++);
          _scrollToBottom();
        }
      },
      onPrev: _currentIndex > 0 ? () => setState(() => _currentIndex--) : null,
      scrollController: _scrollController,
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}

class _ScenarioSelectionScreen extends StatelessWidget {
  final List<DialogueScenario> scenarios;
  final Function(DialogueScenario) onSelect;

  const _ScenarioSelectionScreen({
    required this.scenarios,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('实战对话'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text('选择场景', style: AppTextStyles.subtitle1),
          const SizedBox(height: AppSpacing.md),
          ...scenarios.map((scenario) => _ScenarioCard(
            scenario: scenario,
            onTap: () => onSelect(scenario),
          )),
        ],
      ),
    );
  }
}

class _ScenarioCard extends StatelessWidget {
  final DialogueScenario scenario;
  final VoidCallback onTap;

  const _ScenarioCard({required this.scenario, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: const Icon(Icons.chat_bubble, color: AppColors.accent, size: 30),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(scenario.title, style: AppTextStyles.subtitle1),
                  Text(scenario.description, style: AppTextStyles.caption),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      _Tag(label: scenario.difficulty),
                      const SizedBox(width: AppSpacing.xs),
                      _Tag(label: '角色: ${scenario.role}'),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;

  const _Tag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.textHint.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(label, style: AppTextStyles.caption),
    );
  }
}

class _DialoguePracticeScreen extends StatelessWidget {
  final DialogueScenario dialogue;
  final int currentIndex;
  final bool isRecording;
  final VoidCallback onRecordToggle;
  final VoidCallback onNext;
  final VoidCallback? onPrev;
  final ScrollController scrollController;

  const _DialoguePracticeScreen({
    required this.dialogue,
    required this.currentIndex,
    required this.isRecording,
    required this.onRecordToggle,
    required this.onNext,
    required this.onPrev,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final currentLine = dialogue.lines[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(dialogue.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.lightbulb_outline),
            onPressed: () => _showHint(context),
          ),
        ],
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: (currentIndex + 1) / dialogue.lines.length,
            backgroundColor: AppColors.accent.withValues(alpha: 0.2),
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
          ),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: currentIndex + 1,
              itemBuilder: (context, index) {
                final line = dialogue.lines[index];
                return _DialogueBubble(
                  line: line,
                  isCurrentLine: index == currentIndex,
                );
              },
            ),
          ),
          if (currentLine.isUser)
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  Text(
                    currentLine.text,
                    style: AppTextStyles.headline3,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  GestureDetector(
                    onTap: onRecordToggle,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: isRecording ? AppColors.error : AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isRecording ? Icons.stop : Icons.mic,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    isRecording ? '松开结束录音' : '按住录音',
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onPrev,
                      child: const Text('上一句'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onNext,
                      child: Text(
                        currentIndex < dialogue.lines.length - 1 ? '下一句' : '完成',
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _showHint(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('提示'),
        content: Text(dialogue.lines[currentIndex].translation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }
}

class _DialogueBubble extends StatelessWidget {
  final DialogueLine line;
  final bool isCurrentLine;

  const _DialogueBubble({
    required this.line,
    required this.isCurrentLine,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = line.isUser;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.md),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isUser ? AppColors.primary : AppColors.card,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(AppRadius.lg),
            topRight: const Radius.circular(AppRadius.lg),
            bottomLeft: Radius.circular(isUser ? AppRadius.lg : 0),
            bottomRight: Radius.circular(isUser ? 0 : AppRadius.lg),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              line.speaker,
              style: AppTextStyles.caption.copyWith(
                color: isUser ? Colors.white70 : AppColors.textHint,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              line.text,
              style: AppTextStyles.body1.copyWith(
                color: isUser ? Colors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              line.translation,
              style: AppTextStyles.caption.copyWith(
                color: isUser ? Colors.white60 : AppColors.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
