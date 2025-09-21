import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../models/lesson.dart';
import '../models/module.dart';
import '../services/data_service.dart';
import '../services/admob_service.dart';
import '../utils/app_theme.dart';
import '../widgets/navigation_drawer.dart';
import 'quiz_screen.dart';

class LessonScreen extends StatefulWidget {
  final String moduleId;
  final String lessonId;

  const LessonScreen({
    super.key,
    required this.moduleId,
    required this.lessonId,
  });

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  final DataService _dataService = DataService();
  final AdMobService _adMobService = AdMobService();
  
  Lesson? _currentLesson;
  Module? _module;
  List<Lesson> _moduleLessons = [];
  int _currentLessonIndex = 0;
  BannerAd? _bannerAd;
  bool _isBannerAdReady = false;

  @override
  void initState() {
    super.initState();
    _loadLessonData();
    _loadBannerAd();
  }

  void _loadLessonData() {
    _module = _dataService.getModuleById(widget.moduleId);
    _moduleLessons = _dataService.getLessonsByModuleId(widget.moduleId);
    _currentLessonIndex = _moduleLessons.indexWhere(
      (lesson) => lesson.id == widget.lessonId,
    );
    
    if (_currentLessonIndex >= 0 && _currentLessonIndex < _moduleLessons.length) {
      _currentLesson = _moduleLessons[_currentLessonIndex];
    }
    
    setState(() {});
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          print('Banner ad failed to load: $error');
          ad.dispose();
        },
      ),
    );
    _bannerAd!.load();
  }

  void _goToNextLesson() {
    if (_currentLessonIndex < _moduleLessons.length - 1) {
      setState(() {
        _currentLessonIndex++;
        _currentLesson = _moduleLessons[_currentLessonIndex];
      });
    } else {
      // Go to quiz if available
      if (_module?.quizzes.isNotEmpty == true) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => QuizScreen(
              quizId: _module!.quizzes.first,
            ),
          ),
        );
      } else {
        Navigator.of(context).pop();
      }
    }
  }

  void _goToPreviousLesson() {
    if (_currentLessonIndex > 0) {
      setState(() {
        _currentLessonIndex--;
        _currentLesson = _moduleLessons[_currentLessonIndex];
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  void _copyCode(String code) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Code copied to clipboard'),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentLesson == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Lesson'),
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(_currentLesson!.title),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
            tooltip: 'Open Menu',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _goToPreviousLesson,
            tooltip: 'Previous Lesson',
          ),
          Text(
            '${_currentLessonIndex + 1}/${_moduleLessons.length}',
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      drawer: const CustomNavigationDrawer(),
      body: Column(
        children: [
          // Lesson Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Definition Card
                  if (_currentLesson!.definition.isNotEmpty)
                    _buildInfoCard(
                      'Definition',
                      _currentLesson!.definition,
                      Icons.help_outline,
                      AppTheme.infoColor,
                    ),
                  
                  // Content
                  if (_currentLesson!.content.isNotEmpty)
                    _buildContentCard(
                      'Overview',
                      _currentLesson!.content,
                    ),
                  
                  // Explanation
                  if (_currentLesson!.explanation.isNotEmpty)
                    _buildContentCard(
                      'Explanation',
                      _currentLesson!.explanation,
                    ),
                  
                  // Syntax
                  if (_currentLesson!.syntax.isNotEmpty)
                    _buildCodeCard(
                      'Syntax',
                      _currentLesson!.syntax,
                    ),
                  
                  // Example
                  if (_currentLesson!.example.isNotEmpty)
                    _buildCodeCard(
                      'Example',
                      _currentLesson!.example,
                    ),
                  
                  // Key Points
                  if (_currentLesson!.keyPoints.isNotEmpty)
                    _buildKeyPointsCard(),
                  
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          
          // Banner Ad
          if (_isBannerAdReady && _bannerAd != null)
            Container(
              width: double.infinity,
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),
          
          // Navigation Buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                if (_currentLessonIndex > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _goToPreviousLesson,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppTheme.primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Previous'),
                    ),
                  ),
                if (_currentLessonIndex > 0) const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _goToNextLesson,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      _currentLessonIndex < _moduleLessons.length - 1
                          ? 'Next Lesson'
                          : _module?.quizzes.isNotEmpty == true
                              ? 'Take Quiz'
                              : 'Finish',
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

  Widget _buildInfoCard(String title, String content, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: AppTheme.heading3.copyWith(color: color),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: AppTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentCard(String title, String content) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTheme.heading3,
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: AppTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeCard(String title, String code) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  title,
                  style: AppTheme.heading3,
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () => _copyCode(code),
                  tooltip: 'Copy code',
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.codeBackgroundColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: SelectableText(
              code,
              style: GoogleFonts.robotoMono(
                fontSize: 14,
                color: AppTheme.codeTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyPointsCard() {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.key, color: AppTheme.warningColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Key Points',
                  style: AppTheme.heading3.copyWith(color: AppTheme.warningColor),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ..._currentLesson!.keyPoints.map((point) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(top: 6, right: 12),
                    decoration: const BoxDecoration(
                      color: AppTheme.warningColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      point,
                      style: AppTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
