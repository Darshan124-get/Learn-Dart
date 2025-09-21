import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../models/quiz.dart';
import '../services/data_service.dart';
import '../services/admob_service.dart';
import '../utils/app_theme.dart';
import '../widgets/navigation_drawer.dart';

class QuizScreen extends StatefulWidget {
  final String quizId;

  const QuizScreen({
    super.key,
    required this.quizId,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final DataService _dataService = DataService();
  final AdMobService _adMobService = AdMobService();
  
  Quiz? _quiz;
  int _currentQuestionIndex = 0;
  int _score = 0;
  int? _selectedAnswer;
  bool _showResult = false;
  bool _quizCompleted = false;
  BannerAd? _bannerAd;
  bool _isBannerAdReady = false;

  @override
  void initState() {
    super.initState();
    _loadQuiz();
    _loadBannerAd();
  }

  void _loadQuiz() {
    _quiz = _dataService.getQuizById(widget.quizId);
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

  void _selectAnswer(int answerIndex) {
    if (_showResult) return;
    
    setState(() {
      _selectedAnswer = answerIndex;
      _showResult = true;
      
      if (answerIndex == _quiz!.questions[_currentQuestionIndex].correctAnswer) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _quiz!.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = null;
        _showResult = false;
      });
    } else {
      setState(() {
        _quizCompleted = true;
      });
    }
  }

  void _restartQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _score = 0;
      _selectedAnswer = null;
      _showResult = false;
      _quizCompleted = false;
    });
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_quiz == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Quiz'),
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_quizCompleted) {
      return _buildQuizCompletedScreen();
    }

    final currentQuestion = _quiz!.questions[_currentQuestionIndex];

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(_quiz!.title),
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
            onPressed: () => Navigator.of(context).pop(),
            tooltip: 'Go Back',
          ),
          Text(
            '${_currentQuestionIndex + 1}/${_quiz!.questions.length}',
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
          // Progress Bar
          Container(
            padding: const EdgeInsets.all(16),
            child: LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / _quiz!.questions.length,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
            ),
          ),
          
          // Score Cards
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _buildScoreCard('Current Score', '$_score/${_quiz!.questions.length}'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildScoreCard('Best Score', '0/${_quiz!.questions.length}'), // TODO: Implement best score storage
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Question
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Question ${_currentQuestionIndex + 1}',
                            style: AppTheme.bodySmall.copyWith(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            currentQuestion.question,
                            style: AppTheme.heading3,
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Answer Options
                  ...currentQuestion.options.asMap().entries.map((entry) {
                    int index = entry.key;
                    String option = entry.value;
                    bool isCorrect = index == currentQuestion.correctAnswer;
                    bool isSelected = _selectedAnswer == index;
                    
                    Color cardColor = Colors.white;
                    Color borderColor = Colors.grey[300]!;
                    Color textColor = AppTheme.textPrimaryColor;
                    
                    if (_showResult) {
                      if (isCorrect) {
                        cardColor = AppTheme.successBackgroundColor;
                        borderColor = AppTheme.successColor;
                        textColor = AppTheme.successColor;
                      } else if (isSelected && !isCorrect) {
                        cardColor = AppTheme.errorBackgroundColor;
                        borderColor = AppTheme.errorColor;
                        textColor = AppTheme.errorColor;
                      }
                    } else if (isSelected) {
                      cardColor = AppTheme.primaryColor.withOpacity(0.1);
                      borderColor = AppTheme.primaryColor;
                      textColor = AppTheme.primaryColor;
                    }
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: () => _selectAnswer(index),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: borderColor, width: 2),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: _showResult && isCorrect
                                        ? AppTheme.successColor
                                        : isSelected
                                            ? AppTheme.primaryColor
                                            : Colors.grey[400]!,
                                    width: 2,
                                  ),
                                  color: _showResult && isCorrect
                                      ? AppTheme.successColor
                                      : isSelected
                                          ? AppTheme.primaryColor
                                          : Colors.transparent,
                                ),
                                child: _showResult && isCorrect
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 16,
                                      )
                                    : isSelected
                                        ? const Icon(
                                            Icons.circle,
                                            color: Colors.white,
                                            size: 16,
                                          )
                                        : null,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  option,
                                  style: AppTheme.bodyLarge.copyWith(
                                    color: textColor,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  
                  // Explanation
                  if (_showResult && currentQuestion.explanation.isNotEmpty)
                    Card(
                      color: AppTheme.infoBackgroundColor,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.lightbulb_outline,
                                  color: AppTheme.infoColor,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Explanation',
                                  style: AppTheme.heading3.copyWith(
                                    color: AppTheme.infoColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              currentQuestion.explanation,
                              style: AppTheme.bodyLarge.copyWith(
                                color: AppTheme.infoColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
          
          // Next Button
          if (_showResult)
            Container(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _nextQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    _currentQuestionIndex < _quiz!.questions.length - 1
                        ? 'Next Question'
                        : 'Finish Quiz',
                    style: AppTheme.buttonText.copyWith(fontSize: 16),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildScoreCard(String title, String score) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              title,
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                score,
                style: AppTheme.heading3.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizCompletedScreen() {
    final percentage = (_score / _quiz!.questions.length * 100).round();
    String message;
    Color messageColor;
    
    if (percentage >= 80) {
      message = 'Excellent! You did great!';
      messageColor = AppTheme.successColor;
    } else if (percentage >= 60) {
      message = 'Good job! Keep practicing!';
      messageColor = AppTheme.warningColor;
    } else {
      message = 'Keep studying! You can do better!';
      messageColor = AppTheme.errorColor;
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Quiz Completed'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Score Circle
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: messageColor.withOpacity(0.1),
                      border: Border.all(color: messageColor, width: 4),
                    ),
                    child: Center(
                      child: Text(
                        '$percentage%',
                        style: GoogleFonts.roboto(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: messageColor,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Message
                  Text(
                    message,
                    style: AppTheme.heading2.copyWith(color: messageColor),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Score Details
                  Text(
                    'You scored $_score out of ${_quiz!.questions.length} questions',
                    style: AppTheme.bodyLarge.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _restartQuiz,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppTheme.primaryColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Retake Quiz'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Back to Home'),
                        ),
                      ),
                    ],
                  ),
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
        ],
      ),
    );
  }
}
