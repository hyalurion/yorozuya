// Emergency language phrases page
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../data/language_phrases.dart';

enum VoiceType { male, female }

class EmergencyLanguagePage extends StatefulWidget {
  const EmergencyLanguagePage({super.key});

  @override
  State<EmergencyLanguagePage> createState() => _EmergencyLanguagePageState();
}

class _PhraseEntry {
  final int sceneIdx;
  final int phraseIdx;

  const _PhraseEntry(this.sceneIdx, this.phraseIdx);
}

class _EmergencyLanguagePageState extends State<EmergencyLanguagePage> {
  VoiceType _voiceType = VoiceType.male;
  final Set<int> _selectedScenes = {};
  final Set<int> _selectedPhrases = {};
  String _searchQuery = '';
  final FlutterTts _flutterTts = FlutterTts();
  bool _isTtsInitialized = false;

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  Future<void> _initTts() async {
    try {
      // 设置回调
      _flutterTts.setCompletionHandler(() {
        print('TTS Completed');
      });

      _flutterTts.setErrorHandler((msg) {
        print('TTS Error: $msg');
      });

      _flutterTts.setCancelHandler(() {
        print('TTS Cancelled');
      });

      // 先获取所有引擎
      final engines = await _flutterTts.getEngines;
      print('Available engines: $engines');

      // 尝试使用 Google 引擎
      bool engineSet = false;
      for (final engine in engines) {
        if (engine['name'].toString().contains('google')) {
          await _flutterTts.setEngine(engine['name']);
          print('Set engine: ${engine['name']}');
          engineSet = true;
          break;
        }
      }

      // 获取可用语言
      final languages = await _flutterTts.getLanguages;
      print('Available languages: $languages');

      // 尝试多种泰语代码
      bool languageSet = false;
      final possibleLanguages = ['th-TH', 'th', 'th_TH', 'th-th'];

      for (final lang in possibleLanguages) {
        try {
          final isAvailable = await _flutterTts.isLanguageAvailable(lang);
          if (isAvailable) {
            final result = await _flutterTts.setLanguage(lang);
            print('Set language $lang result: $result');
            languageSet = true;
            break;
          }
        } catch (e) {
          print('Error trying language $lang: $e');
        }
      }

      if (!languageSet) {
        print('Could not set Thai language, using default');
      }

      // 设置默认参数
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);

      setState(() => _isTtsInitialized = true);
      print('TTS initialized successfully');
    } catch (e) {
      print('Error initializing TTS: $e');
      setState(() => _isTtsInitialized = false);
    }
  }

  Future<void> _speak(String text) async {
    if (!_isTtsInitialized) {
      await _initTts();
    }

    if (!_isTtsInitialized) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('TTS 未初始化，请重试'),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }

    try {
      // 停止之前的播放
      await _flutterTts.stop();

      // 调整语音参数，男/女声
      if (_voiceType == VoiceType.male) {
        await _flutterTts.setPitch(0.8);
      } else {
        await _flutterTts.setPitch(1.2);
      }

      await _flutterTts.setVolume(1.0);
      await _flutterTts.setSpeechRate(0.5);

      print('About to speak: $text');
      final result = await _flutterTts.speak(text);
      print('Speak returned: $result');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('正在播放...'),
            duration: Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      print('Error speaking: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('播放失败: $e'),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _showFullScreenPhrase(LanguagePhrase phrase) {
    final thai = phrase.thaiWithHonorific(isMale: _voiceType == VoiceType.male);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FullScreenPhraseDisplay(
          phrase: phrase,
          thaiText: thai,
          onSpeak: () => _speak(thai),
        ),
      ),
    );
  }

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

              // Search input
              _buildSectionTitle(context, '搜索表达'),
              const SizedBox(height: 12),
              _buildSearchBar(),
              const SizedBox(height: 24),

              // Scene selector
              _buildSectionTitle(context, '选择场景'),
              const SizedBox(height: 12),
              _buildSceneSelector(),
              const SizedBox(height: 24),

              // Phrase selector (if scenes selected or search active)
              if (_selectedScenes.isNotEmpty || _searchQuery.isNotEmpty) ...[
                _buildSectionTitle(context, '表达列表'),
                const SizedBox(height: 12),
                _buildPhraseSelector(),
                const SizedBox(height: 24),
              ],

              // Selected phrases display
              if (_selectedPhrases.isNotEmpty) ...[
                const SizedBox(height: 24),
                _buildSelectedPhrasesSection(context),
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

  Widget _buildSearchBar() {
    return TextField(
      onChanged: (value) => setState(() => _searchQuery = value),
      decoration: InputDecoration(
        hintText: '输入中文、泰文或关键词搜索',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        filled: true,
      ),
    );
  }

  Widget _buildSceneSelector() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: thaiScenes.map((scene) {
        final sceneIdx = thaiScenes.indexOf(scene);
        final isSelected = _selectedScenes.contains(sceneIdx);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedScenes.remove(sceneIdx);
                _selectedPhrases.removeWhere((idx) {
                  final indices = _getSceneAndPhraseIndex(idx);
                  return indices?.$1 == sceneIdx;
                });
              } else {
                _selectedScenes.add(sceneIdx);
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
    final visiblePhrases = _getVisiblePhraseEntries();

    if (visiblePhrases.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          '没有找到匹配的表达。请尝试更换关键词或选择其他场景。',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      );
    }

    return Column(
      children: visiblePhrases.map((entry) {
        final scene = thaiScenes[entry.sceneIdx];
        final phrase = scene.phrases[entry.phraseIdx];
        final globalIdx = _getGlobalPhraseIndex(entry.sceneIdx, entry.phraseIdx);
        final isSelected = _selectedPhrases.contains(globalIdx);
        final thai = phrase.thaiWithHonorific(isMale: _voiceType == VoiceType.male);

        return GestureDetector(
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
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.45)
                  : Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                width: isSelected ? 1.8 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        phrase.chinese,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Icon(
                      isSelected ? Icons.check_circle : Icons.circle_outlined,
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.outline,
                      size: 22,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  thai,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.78),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  phrase.romanization,
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                if (phrase.note.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      phrase.note,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.75),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Text(
                  '场景：${scene.name}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
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

  List<_PhraseEntry> _getVisiblePhraseEntries() {
    final query = _searchQuery.trim().toLowerCase();
    final sceneIndices = _selectedScenes.isNotEmpty
        ? _selectedScenes.toList()
        : List<int>.generate(thaiScenes.length, (index) => index);

    final visible = <_PhraseEntry>[];
    for (final sceneIdx in sceneIndices) {
      final scene = thaiScenes[sceneIdx];
      final sceneMatch = query.isNotEmpty &&
          (scene.name.toLowerCase().contains(query) || scene.description.toLowerCase().contains(query));
      for (int phraseIdx = 0; phraseIdx < scene.phrases.length; phraseIdx++) {
        final phrase = scene.phrases[phraseIdx];
        final phraseMatch = query.isEmpty ||
            phrase.chinese.toLowerCase().contains(query) ||
            phrase.thai.toLowerCase().contains(query) ||
            phrase.romanization.toLowerCase().contains(query) ||
            phrase.note.toLowerCase().contains(query);
        if (query.isEmpty || sceneMatch || phraseMatch) {
          visible.add(_PhraseEntry(sceneIdx, phraseIdx));
        }
      }
    }
    return visible;
  }

  Widget _buildSelectedPhrasesSection(BuildContext context) {
    final selectedPhrases = _selectedPhrases
        .map((globalIdx) {
          final indices = _getSceneAndPhraseIndex(globalIdx);
          return indices == null ? null : thaiScenes[indices.$1].phrases[indices.$2];
        })
        .whereType<LanguagePhrase>()
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, '已选择表达'),
        const SizedBox(height: 12),
        ...selectedPhrases.map((phrase) => _buildPhraseCard(context, phrase)),
      ],
    );
  }

  Widget _buildPhraseCard(BuildContext context, LanguagePhrase phrase) {
    final thai = phrase.thaiWithHonorific(isMale: _voiceType == VoiceType.male);
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
                  thai,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _speak(thai),
                icon: const Icon(Icons.volume_up, size: 20),
                tooltip: '播放发音',
              ),
              IconButton(
                onPressed: () => _copyToClipboard(thai),
                icon: const Icon(Icons.copy, size: 20),
                tooltip: '复制泰语',
              ),
              IconButton(
                onPressed: () => _showFullScreenPhrase(phrase),
                icon: const Icon(Icons.fullscreen, size: 20),
                tooltip: '全屏展示',
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
          if (phrase.note.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                phrase.note,
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                ),
              ),
            ),
          ],
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

class FullScreenPhraseDisplay extends StatefulWidget {
  final LanguagePhrase phrase;
  final String thaiText;
  final VoidCallback onSpeak;

  const FullScreenPhraseDisplay({
    super.key,
    required this.phrase,
    required this.thaiText,
    required this.onSpeak,
  });

  @override
  State<FullScreenPhraseDisplay> createState() => _FullScreenPhraseDisplayState();
}

class _FullScreenPhraseDisplayState extends State<FullScreenPhraseDisplay> {
  @override
  void initState() {
    super.initState();
    // 进入时自动设置为横屏
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    // 离开时恢复为竖屏
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: GestureDetector(
          onTap: widget.onSpeak,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 中文
                Text(
                  widget.phrase.chinese,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                // 泰语（大号字体）
                Text(
                  widget.thaiText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                // 罗马拼音
                Text(
                  widget.phrase.romanization,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 28,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (widget.phrase.note.isNotEmpty) ...[
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.phrase.note,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
                const SizedBox(height: 60),
                // 操作按钮
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: widget.onSpeak,
                      icon: const Icon(Icons.volume_up, size: 32),
                      label: const Text('播放', style: TextStyle(fontSize: 20)),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, size: 32),
                      label: const Text('关闭', style: TextStyle(fontSize: 20)),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        backgroundColor: Colors.grey[700],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
