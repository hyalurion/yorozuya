// Emergency language phrases page
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/language_phrases.dart';

enum VoiceType { male, female }

class EmergencyLanguagePage extends StatefulWidget {
  const EmergencyLanguagePage({super.key});

  @override
  State<EmergencyLanguagePage> createState() => _EmergencyLanguagePageState();
}

class _EmergencyLanguagePageState extends State<EmergencyLanguagePage> {
  VoiceType _voiceType = VoiceType.male;
  final Set<int> _selectedScenes = {};
  final Set<int> _selectedPhrases = {};
  List<LanguagePhrase> _generatedPhrases = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('生活用语急救箱'),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Language selector
              _buildSectionTitle(context, '选择语言'),
              const SizedBox(height: 12),
              _buildLanguageSelector(),
              const SizedBox(height: 24),

              // Voice type selector
              _buildSectionTitle(context, '选择发音'),
              const SizedBox(height: 12),
              _buildVoiceTypeSelector(),
              const SizedBox(height: 24),

              // Scene selector
              _buildSectionTitle(context, '选择场景'),
              const SizedBox(height: 12),
              _buildSceneSelector(),
              const SizedBox(height: 24),

              // Phrase selector (if scenes selected)
              if (_selectedScenes.isNotEmpty) ...[
                _buildSectionTitle(context, '选择表达'),
                const SizedBox(height: 12),
                _buildPhraseSelector(),
                const SizedBox(height: 24),
              ],

              // Generate button
              if (_selectedPhrases.isNotEmpty)
                _buildGenerateButton(context),

              // Generated phrases
              if (_generatedPhrases.isNotEmpty) ...[
                const SizedBox(height: 24),
                _buildGeneratedResult(context),
              ],

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Text('🇹🇭', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          const Text(
            '泰语',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Thai',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoiceTypeSelector() {
    return Row(
      children: [
        Expanded(
          child: _buildVoiceOption(
            VoiceType.male,
            '🧑',
            '男声',
            'ผู้ชาย',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildVoiceOption(
            VoiceType.female,
            '👩',
            '女声',
            'ผู้หญิง',
          ),
        ),
      ],
    );
  }

  Widget _buildVoiceOption(VoiceType type, String emoji, String label, String thaiLabel) {
    final isSelected = _voiceType == type;
    return GestureDetector(
      onTap: () => setState(() => _voiceType = type),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : null,
              ),
            ),
            Text(
              thaiLabel,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSceneSelector() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: thaiScenes.map((scene) {
        final isSelected = _selectedScenes.contains(thaiScenes.indexOf(scene));
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedScenes.remove(thaiScenes.indexOf(scene));
                _selectedPhrases.removeWhere((idx) {
                  // Remove phrases from this scene
                  int phraseIdx = idx;
                  int sceneIdx = 0;
                  int count = 0;
                  for (int i = 0; i < thaiScenes.length; i++) {
                    if (phraseIdx < thaiScenes[i].phrases.length) {
                      sceneIdx = i;
                      count = phraseIdx;
                      break;
                    }
                    phraseIdx -= thaiScenes[i].phrases.length;
                  }
                  return sceneIdx == thaiScenes.indexOf(scene);
                });
              } else {
                _selectedScenes.add(thaiScenes.indexOf(scene));
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(scene.icon, style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 6),
                Text(
                  scene.name,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPhraseSelector() {
    List<Widget> phraseWidgets = [];
    for (int sceneIdx in _selectedScenes) {
      final scene = thaiScenes[sceneIdx];
      for (int phraseIdx = 0; phraseIdx < scene.phrases.length; phraseIdx++) {
        final globalIdx = _getGlobalPhraseIndex(sceneIdx, phraseIdx);
        final phrase = scene.phrases[phraseIdx];
        final isSelected = _selectedPhrases.contains(globalIdx);

        phraseWidgets.add(
          GestureDetector(
            onTap: () {
              setState(() {
                if (isSelected) {
                  _selectedPhrases.remove(globalIdx);
                } else {
                  _selectedPhrases.add(globalIdx);
                }
              });
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5)
                    : Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isSelected ? Icons.check_circle : Icons.circle_outlined,
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outline,
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          phrase.chinese,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          phrase.thai,
                          style: TextStyle(
                            fontSize: 13,
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }
    return Column(children: phraseWidgets);
  }

  int _getGlobalPhraseIndex(int sceneIdx, int phraseIdx) {
    int globalIdx = 0;
    for (int i = 0; i < sceneIdx; i++) {
      globalIdx += thaiScenes[i].phrases.length;
    }
    return globalIdx + phraseIdx;
  }

  (int, int)? _getSceneAndPhraseIndex(int globalIdx) {
    int remaining = globalIdx;
    for (int sceneIdx = 0; sceneIdx < thaiScenes.length; sceneIdx++) {
      if (remaining < thaiScenes[sceneIdx].phrases.length) {
        return (sceneIdx, remaining);
      }
      remaining -= thaiScenes[sceneIdx].phrases.length;
    }
    return null;
  }

  Widget _buildGenerateButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _generatePhrases,
        icon: const Icon(Icons.auto_awesome),
        label: Text('生成表达 (${_selectedPhrases.length}句)'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  void _generatePhrases() {
    setState(() {
      _generatedPhrases = [];
      for (int globalIdx in _selectedPhrases) {
        final indices = _getSceneAndPhraseIndex(globalIdx);
        if (indices != null) {
          _generatedPhrases.add(thaiScenes[indices.$1].phrases[indices.$2]);
        }
      }
    });
  }

  Widget _buildGeneratedResult(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, '生成的表达'),
        const SizedBox(height: 12),
        ..._generatedPhrases.map((phrase) => _buildPhraseCard(context, phrase)),
      ],
    );
  }

  Widget _buildPhraseCard(BuildContext context, LanguagePhrase phrase) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.4),
            Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chinese
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  '中文',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  phrase.chinese,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Thai
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  '泰语',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  phrase.thai,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _copyToClipboard(phrase.thai),
                icon: const Icon(Icons.copy, size: 20),
                tooltip: '复制泰语',
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Romanization
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    '发音',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    phrase.romanization,
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => _copyToClipboard(phrase.romanization),
                  icon: const Icon(Icons.copy, size: 20),
                  tooltip: '复制发音',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('已复制: $text'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
