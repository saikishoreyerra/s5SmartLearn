import 'dart:ui';

import 'package:flutter/material.dart';

import '../models/exam.dart';
import 'quiz/quiz_constants.dart';

/// Result overview for a completed exam: summary stats + question-by-question breakdown.
/// Shown when user taps "View Answers" on a completed exam (Assignments → Completed).
class ExamAnswersPage extends StatelessWidget {
  final Exam exam;

  const ExamAnswersPage({super.key, required this.exam});

  /// Computes correct / wrong / unanswered counts and total score from [answers].
  static ExamResultSummary computeSummary(List<ExamAnswer> answers) {
    int correct = 0;
    int wrong = 0;
    int unanswered = 0;
    for (final a in answers) {
      if (a.userSelectedIndex < 0) {
        unanswered++;
      } else if (a.userSelectedIndex == a.correctAnsIndex) {
        correct++;
      } else {
        wrong++;
      }
    }
    final total = answers.length;
    final scorePercent = total > 0 ? (correct / total * 100).round() : 0;
    return ExamResultSummary(
      correctCount: correct,
      wrongCount: wrong,
      unansweredCount: unanswered,
      totalQuestions: total,
      scorePercent: scorePercent,
    );
  }

  /// Derives a short subject label from exam (e.g. "Math", "Science").
  static String subjectLabel(Exam exam) {
    final t = exam.title.toLowerCase();
    if (t.contains('math') || t.contains('maths')) return 'Math';
    if (t.contains('science')) return 'Science';
    if (t.contains('english')) return 'English';
    if (t.contains('history')) return 'History';
    return exam.typeTag.isNotEmpty ? exam.typeTag : 'Exam';
  }

  @override
  Widget build(BuildContext context) {
    final answers = exam.answers!;
    final summary = computeSummary(answers);
    final subject = subjectLabel(exam);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF08306D),
              Color(0xFF0D47A1),
              Color(0xFF1565C0),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildAppBar(context),
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: _buildHeader(subject)),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: _SummaryCard(
                          exam: exam,
                          subject: subject,
                          summary: summary,
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _ResultQuestionCard(
                              questionNumber: index + 1,
                              answer: answers[index],
                            ),
                          ),
                          childCount: answers.length,
                        ),
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

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 22),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
          ),
          const Expanded(
            child: Text(
              'S5 SmartLearn AI',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none, color: Colors.white, size: 24),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.person_outline, color: Colors.white, size: 24),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String subject) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Answer Sheet',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w800,
              shadows: [
                Shadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 2)),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Subject: $subject',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Summary stats for the result overview.
class ExamResultSummary {
  final int correctCount;
  final int wrongCount;
  final int unansweredCount;
  final int totalQuestions;
  final int scorePercent;

  const ExamResultSummary({
    required this.correctCount,
    required this.wrongCount,
    required this.unansweredCount,
    required this.totalQuestions,
    required this.scorePercent,
  });
}

class _SummaryCard extends StatelessWidget {
  final Exam exam;
  final String subject;
  final ExamResultSummary summary;

  const _SummaryCard({
    required this.exam,
    required this.subject,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Exam: ${exam.title}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: kBlackColor,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                'Subject: $subject',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StatChip(
                    label: '${summary.correctCount} Correct',
                    color: kGreenColor,
                  ),
                  _StatChip(
                    label: '${summary.wrongCount} Wrong',
                    color: kRedColor,
                  ),
                  _StatChip(
                    label: '${summary.unansweredCount} Unanswered',
                    color: kGrayColor,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Center(
                child: SizedBox(
                  width: 120,
                  height: 120,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: CircularProgressIndicator(
                          value: summary.totalQuestions > 0
                              ? summary.scorePercent / 100
                              : 0,
                          strokeWidth: 10,
                          backgroundColor: kGrayColor.withValues(alpha: 0.3),
                          valueColor: const AlwaysStoppedAnimation<Color>(kGreenColor),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${summary.scorePercent}%',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: kBlackColor,
                            ),
                          ),
                          const Text(
                            'Total Score',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: kGrayColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _TimeRow(
                    label: 'Time Spent',
                    value: '—',
                    icon: Icons.timer_outlined,
                  ),
                  _TimeRow(
                    label: 'Avg Time: Q',
                    value: '—',
                    icon: Icons.schedule,
                  ),
                ],
              ),
              if (exam.marks != null && exam.marks!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Marks: ${exam.marks}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: kSecondaryColor,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final Color color;

  const _StatChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: color,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _TimeRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _TimeRow({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: kGreenColor),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: kBlackColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ResultQuestionCard extends StatelessWidget {
  final int questionNumber;
  final ExamAnswer answer;

  const _ResultQuestionCard({
    required this.questionNumber,
    required this.answer,
  });

  bool get _isCorrect =>
      answer.userSelectedIndex >= 0 && answer.userSelectedIndex == answer.correctAnsIndex;
  bool get _isWrong =>
      answer.userSelectedIndex >= 0 && answer.userSelectedIndex != answer.correctAnsIndex;
  bool get _isUnanswered => answer.userSelectedIndex < 0;

  String get _userAnswerText {
    if (answer.userSelectedIndex < 0 || answer.userSelectedIndex >= answer.options.length) {
      return 'Unanswered';
    }
    return answer.options[answer.userSelectedIndex];
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = _isCorrect
        ? kGreenColor
        : _isWrong
            ? kRedColor
            : kGrayColor;
    final icon = _isCorrect
        ? Icons.check_circle
        : _isWrong
            ? Icons.cancel
            : Icons.help_outline;
    final iconColor = borderColor;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: borderColor.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: borderColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  '$questionNumber',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: borderColor,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  answer.question,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: kBlackColor,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(icon, color: iconColor, size: 24),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: borderColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: borderColor.withValues(alpha: 0.5)),
            ),
            child: Row(
              children: [
                Text(
                  _isUnanswered ? 'Skipped' : 'Your answer: ',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Expanded(
                  child: Text(
                    _userAnswerText,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: borderColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          if (_isWrong && answer.correctAnsIndex < answer.options.length) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: kGreenColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: kGreenColor.withValues(alpha: 0.5)),
              ),
              child: Row(
                children: [
                  const Text(
                    'Correct answer: ',
                    style: TextStyle(
                      fontSize: 13,
                      color: kGrayColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      answer.options[answer.correctAnsIndex],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: kGreenColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
