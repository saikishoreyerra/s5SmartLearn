import 'package:flutter/material.dart';

import '../di/injection.dart';
import '../models/exam.dart';
import '../viewmodels/assignments_viewmodel.dart';
import 'exam_answers_page.dart';
import 'quiz/quiz_constants.dart';
import 'quiz/quiz_screen.dart';

class AssignmentsPage extends StatefulWidget {
  const AssignmentsPage({super.key});

  @override
  State<AssignmentsPage> createState() => _AssignmentsPageState();
}

class _AssignmentsPageState extends State<AssignmentsPage> {
  late final AssignmentsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = getIt<AssignmentsViewModel>();
    _viewModel.addListener(_onViewModelChanged);
    _viewModel.loadAssignments();
  }

  void _onViewModelChanged() => setState(() {});

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          'Assignments',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
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
            CircularProgressIndicator(color: kPrimaryColor),
            SizedBox(height: 16),
            Text(
              'Loading assignments...',
              style: TextStyle(fontSize: 16, color: kGrayColor),
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
              const Icon(Icons.error_outline, size: 48, color: kGrayColor),
              const SizedBox(height: 16),
              Text(
                _viewModel.errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: kGrayColor),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => _viewModel.loadAssignments(),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTabBar(context),
        Expanded(
          child: _viewModel.filteredExams.isEmpty
              ? _buildEmptyState(context)
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  itemCount: _viewModel.filteredExams.length,
                  itemBuilder: (context, index) => _ExamCard(
                    exam: _viewModel.filteredExams[index],
                    onGoToExam: _goToExam,
                    onViewAnswers: _viewAnswers,
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildTabBar(BuildContext context) {
    const tabs = [
      'Active Exams',
      'Completed Exams',
      'Unattended Exams',
      'All Exams',
    ];
    return Container(
      color: kPrimaryColor,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(tabs.length, (i) {
            final isSelected = _viewModel.selectedTab == i;
            return Padding(
              padding: EdgeInsets.only(right: i < tabs.length - 1 ? 10 : 0),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _viewModel.setSelectedTab(i),
                  borderRadius: BorderRadius.circular(24),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : kSurfaceLight,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Text(
                      tabs[i],
                      style: TextStyle(
                        fontFamily: 'Source Sans 3',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? kPrimaryColor : kGrayColor,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Text(
        'No exams in this category',
        style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
      ),
    );
  }

  Future<void> _goToExam(Exam exam) async {
    final result = await Navigator.of(context).push<List<ExamAnswer>>(
      MaterialPageRoute(builder: (_) => QuizScreen(examId: exam.id)),
    );

    if (result != null && result.isNotEmpty) {
      _viewModel.markExamCompleted(exam.id, answers: result);
    }
  }

  void _viewAnswers(Exam exam) {
    if (!exam.hasViewableAnswers) return;
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => ExamAnswersPage(exam: exam)));
  }
}

class _ExamCard extends StatelessWidget {
  final Exam exam;
  final ValueChanged<Exam> onGoToExam;
  final ValueChanged<Exam>? onViewAnswers;

  const _ExamCard({
    required this.exam,
    required this.onGoToExam,
    this.onViewAnswers,
  });

  static String _formatEndDate(DateTime d) {
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    final y = d.year;
    final hour12 = d.hour == 0 ? 12 : (d.hour > 12 ? d.hour - 12 : d.hour);
    final min = d.minute.toString().padLeft(2, '0');
    final period = d.hour < 12 ? 'am' : 'pm';
    return '$m/$day/$y $hour12:$min $period';
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = exam.isActive
        ? kSecondaryColor
        : exam.isCompleted
        ? kGreenColor
        : kRedColor;

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exam.title,
                        style: const TextStyle(
                          fontFamily: 'Source Sans 3',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: kBlackColor,
                        ),
                      ),
                      if (exam.subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          exam.subtitle!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Text(
                            'Status : ',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          Text(
                            exam.statusLabel,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: statusColor,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'Marks: ${exam.marks ?? "--"}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'End : ${_formatEndDate(exam.endDate)}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            'Review Type: ',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              exam.reviewType,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: kPrimaryColor,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: kSecondaryColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          exam.typeTag,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: kSecondaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (exam.isActive)
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Material(
                      color: kAccentColor,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap: () => onGoToExam(exam),
                        borderRadius: BorderRadius.circular(10),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 14,
                          ),
                          child: Text(
                            'Go to Exam',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                else if (exam.hasViewableAnswers && onViewAnswers != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Material(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap: () => onViewAnswers!(exam),
                        borderRadius: BorderRadius.circular(10),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 14,
                          ),
                          child: Text(
                            'View',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
