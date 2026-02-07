import 'package:flutter/material.dart';

import '../../di/injection.dart';
import '../../models/exam.dart';
import '../../models/question.dart';
import '../../viewmodels/quiz_viewmodel.dart';
import 'quiz_constants.dart';

class QuizScreen extends StatefulWidget {
  final String? examId; // null = default quiz

  const QuizScreen({super.key, this.examId});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen>
    with SingleTickerProviderStateMixin {
  late final QuizViewModel _viewModel;
  late final PageController _pageController;
  late final AnimationController _animationController;
  bool _animationStarted = false;
  List<int?> _userAnswers = [];

  @override
  void initState() {
    super.initState();
    _viewModel = getIt<QuizViewModel>();
    _pageController = PageController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        _goToNext();
      }
    });

    _viewModel.addListener(_onViewModelChanged);
    _viewModel.loadQuestions();
  }

  void _onViewModelChanged() {
    if (!mounted) return;
    // Initialize user answers list once questions are loaded
    if (!_viewModel.isLoading &&
        _viewModel.hasQuestions &&
        _userAnswers.length != _viewModel.questions.length) {
      _userAnswers = List<int?>.filled(_viewModel.questions.length, null);
    }
    if (!_viewModel.isLoading &&
        _viewModel.hasQuestions &&
        !_animationStarted &&
        _viewModel.questionNumber == 1) {
      _animationStarted = true;
      _animationController.forward();
    }
    setState(() {});
  }

  void _goToNext() {
    // If we are on the last question, finish the quiz and
    // return to the previous screen (Assignments or Dashboard).
    if (_viewModel.questions.isNotEmpty &&
        _viewModel.questionNumber >= _viewModel.questions.length) {
      // Build question-wise answers so Assignments can show them later.
      final answers = List<ExamAnswer>.generate(
        _viewModel.questions.length,
        (index) {
          final q = _viewModel.questions[index];
          final selected = index < _userAnswers.length && _userAnswers[index] != null
              ? _userAnswers[index]!
              : -1;
          return ExamAnswer(
            question: q.question,
            options: q.options,
            correctAnsIndex: q.correctAnsIndex,
            userSelectedIndex: selected,
          );
        },
      );

      // Return answers so caller can mark exam as completed with results.
      Navigator.of(context).pop(answers);
      return;
    }

    _viewModel.nextQuestion();
    _animationController.reset();
    _animationController.forward();
    _pageController.nextPage(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  void _checkAns(Question question, int selectedIndex) {
    if (_viewModel.isAnswered) return;
    // Store user's selected answer for the current question index
    final qIndex = _viewModel.questionNumber - 1;
    if (qIndex >= 0 && qIndex < _userAnswers.length) {
      _userAnswers[qIndex] = selectedIndex;
    }
    _viewModel.checkAns(question, selectedIndex);
    _animationController.stop();
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) _goToNext();
    });
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton(
            onPressed: _viewModel.isAnswered || !_viewModel.hasQuestions
                ? null
                : _goToNext,
            child: const Text('Skip', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_viewModel.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 16),
            Text(
              'Loading quiz...',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      );
    }

    if (_viewModel.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.white70),
              const SizedBox(height: 16),
              Text(
                _viewModel.errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => _viewModel.loadQuestions(),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (!_viewModel.hasQuestions) {
      return const Center(
        child: Text(
          'No questions available',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      );
    }

    return QuizBody(
      questions: _viewModel.questions,
      questionNumber: _viewModel.questionNumber,
      pageController: _pageController,
      animation: _animationController,
      isAnswered: _viewModel.isAnswered,
      selectedAns: _viewModel.selectedAns,
      correctAns: _viewModel.correctAns,
      onPageChanged: _viewModel.updateQuestionNumber,
      onCheckAns: _checkAns,
    );
  }
}

class QuizBody extends StatelessWidget {
  final List<Question> questions;
  final int questionNumber;
  final PageController pageController;
  final Animation<double> animation;
  final bool isAnswered;
  final int? selectedAns;
  final int? correctAns;
  final ValueChanged<int> onPageChanged;
  final void Function(Question question, int index) onCheckAns;

  const QuizBody({
    super.key,
    required this.questions,
    required this.questionNumber,
    required this.pageController,
    required this.animation,
    required this.isAnswered,
    required this.selectedAns,
    required this.correctAns,
    required this.onPageChanged,
    required this.onCheckAns,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF08306D), Color(0xFF0D47A1)],
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: QuizProgressBar(animation: animation),
            ),
            const SizedBox(height: kDefaultPadding),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: Text.rich(
                TextSpan(
                  text: 'Question $questionNumber',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: kSecondaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                  children: [
                    TextSpan(
                      text: '/${questions.length}',
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(color: kSecondaryColor),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(thickness: 1.5, color: Colors.white24),
            const SizedBox(height: kDefaultPadding),
            Expanded(
              child: PageView.builder(
                physics: const NeverScrollableScrollPhysics(),
                controller: pageController,
                onPageChanged: onPageChanged,
                itemCount: questions.length,
                itemBuilder: (context, index) => QuizQuestionCard(
                  question: questions[index],
                  isAnswered: isAnswered,
                  selectedAns: selectedAns,
                  correctAns: correctAns,
                  onCheckAns: onCheckAns,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuizProgressBar extends StatelessWidget {
  final Animation<double> animation;

  const QuizProgressBar({super.key, required this.animation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          height: 35,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF3F4768), width: 3),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Stack(
            children: [
              LayoutBuilder(
                builder: (context, constraints) => Container(
                  width: constraints.maxWidth * animation.value,
                  decoration: BoxDecoration(
                    gradient: kPrimaryGradient,
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kDefaultPadding / 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${(animation.value * 60).round()} sec',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Icon(
                        Icons.timer_outlined,
                        color: Colors.white,
                        size: 22,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class QuizQuestionCard extends StatelessWidget {
  final Question question;
  final bool isAnswered;
  final int? selectedAns;
  final int? correctAns;
  final void Function(Question question, int index) onCheckAns;

  const QuizQuestionCard({
    super.key,
    required this.question,
    required this.isAnswered,
    required this.selectedAns,
    required this.correctAns,
    required this.onCheckAns,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      padding: const EdgeInsets.all(kDefaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question.question,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: kBlackColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: kDefaultPadding / 2),
          ...List.generate(
            question.options.length,
            (index) => QuizOption(
              index: index,
              text: question.options[index],
              isAnswered: isAnswered,
              selectedAns: selectedAns,
              correctAns: correctAns,
              onPress: () => onCheckAns(question, index),
            ),
          ),
        ],
      ),
    );
  }
}

class QuizOption extends StatelessWidget {
  final int index;
  final String text;
  final bool isAnswered;
  final int? selectedAns;
  final int? correctAns;
  final VoidCallback onPress;

  const QuizOption({
    super.key,
    required this.index,
    required this.text,
    required this.isAnswered,
    required this.selectedAns,
    required this.correctAns,
    required this.onPress,
  });

  Color _getTheRightColor() {
    if (isAnswered) {
      if (index == correctAns) return kGreenColor;
      if (index == selectedAns && selectedAns != correctAns) return kRedColor;
    }
    return kGrayColor;
  }

  IconData _getTheRightIcon() {
    return _getTheRightColor() == kRedColor ? Icons.close : Icons.done;
  }

  @override
  Widget build(BuildContext context) {
    final color = _getTheRightColor();
    return InkWell(
      onTap: isAnswered ? null : onPress,
      child: Container(
        margin: const EdgeInsets.only(top: kDefaultPadding),
        padding: const EdgeInsets.all(kDefaultPadding),
        decoration: BoxDecoration(
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${index + 1}. $text',
              style: TextStyle(color: color, fontSize: 16),
            ),
            Container(
              height: 26,
              width: 26,
              decoration: BoxDecoration(
                color: color == kGrayColor ? Colors.transparent : color,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: color),
              ),
              child: color == kGrayColor
                  ? null
                  : Icon(_getTheRightIcon(), size: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
