import 'package:flutter/material.dart';

import '../models/exam.dart';
import 'quiz/quiz_constants.dart';

/// Shows user's answers vs correct answers for a completed exam.
class ExamAnswersPage extends StatelessWidget {
  final Exam exam;

  const ExamAnswersPage({super.key, required this.exam});

  @override
  Widget build(BuildContext context) {
    final answers = exam.answers!;
    return Scaffold(
      backgroundColor: kBackgroundLight,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 22),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
        ),
        title: const Text(
          'Answers',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              exam.title,
              style: const TextStyle(
                fontFamily: 'Source Sans 3',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: kBlackColor,
              ),
            ),
          ),
          if (exam.marks != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Text(
                'Marks: ${exam.marks}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: kSecondaryColor,
                ),
              ),
            ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              itemCount: answers.length,
              itemBuilder: (context, index) {
                return _AnswerCard(index: index + 1, answer: answers[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AnswerCard extends StatelessWidget {
  final int index;
  final ExamAnswer answer;

  const _AnswerCard({required this.index, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
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
                    color: kPrimaryColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$index',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: kPrimaryColor,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    answer.question,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: kBlackColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...List.generate(
              answer.options.length,
              (i) => _OptionRow(
                optionText: answer.options[i],
                isUserSelected: i == answer.userSelectedIndex,
                isCorrectAnswer: i == answer.correctAnsIndex,
                isCorrect: answer.isCorrect,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionRow extends StatelessWidget {
  final String optionText;
  final bool isUserSelected;
  final bool isCorrectAnswer;

  /// True if user's choice matched correct answer.
  final bool isCorrect;

  const _OptionRow({
    required this.optionText,
    required this.isUserSelected,
    required this.isCorrectAnswer,
    required this.isCorrect,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor = kGrayColor;
    Color? backgroundColor;
    List<Widget> badges = [];

    if (isCorrectAnswer && isUserSelected) {
      borderColor = kGreenColor;
      backgroundColor = kGreenColor.withValues(alpha: 0.08);
      badges.add(const _Badge(label: 'Your answer', isCorrect: true));
      badges.add(const _Badge(label: 'Correct', isCorrect: true));
    } else if (isCorrectAnswer) {
      borderColor = kGreenColor;
      backgroundColor = kGreenColor.withValues(alpha: 0.08);
      badges.add(const _Badge(label: 'Correct answer', isCorrect: true));
    } else if (isUserSelected) {
      borderColor = kRedColor;
      backgroundColor = kRedColor.withValues(alpha: 0.08);
      badges.add(const _Badge(label: 'Your answer', isCorrect: false));
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              optionText,
              style: TextStyle(
                fontSize: 14,
                color: borderColor == kGrayColor ? kBlackColor : borderColor,
                fontWeight: (isUserSelected || isCorrectAnswer)
                    ? FontWeight.w600
                    : null,
              ),
            ),
          ),
          if (badges.isNotEmpty) ...[
            const SizedBox(width: 8),
            Wrap(spacing: 6, runSpacing: 4, children: badges),
          ],
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final bool isCorrect;

  const _Badge({required this.label, required this.isCorrect});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isCorrect
            ? kGreenColor.withValues(alpha: 0.2)
            : kRedColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isCorrect ? kGreenColor : kRedColor,
        ),
      ),
    );
  }
}
