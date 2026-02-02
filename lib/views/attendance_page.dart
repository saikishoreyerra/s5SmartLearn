import 'package:flutter/material.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';

/// Assignment / Completed tabs and calendar. Navigated from Dashboard.
class AttendancePage extends StatefulWidget {
  final int initialTab;

  const AttendancePage({super.key, this.initialTab = 0});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  static const int _tabAssignment = 0;
  static const int _tabCompleted = 1;
  late int _selectedTab;

  late List<NeatCleanCalendarEvent> _assignmentEvents;
  late List<NeatCleanCalendarEvent> _completedEvents;

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTab == _tabCompleted ? _tabCompleted : _tabAssignment;
    _assignmentEvents = _buildAssignmentEvents();
    _completedEvents = _buildCompletedEvents();
  }

  List<NeatCleanCalendarEvent> _buildAssignmentEvents() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return [
      NeatCleanCalendarEvent(
        'Present',
        description: 'Present',
        startTime: today,
        endTime: today.add(const Duration(hours: 8)),
        color: const Color(0xFF4CAF50),
        isAllDay: true,
      ),
      NeatCleanCalendarEvent(
        'Present',
        description: 'Present',
        startTime: today.subtract(const Duration(days: 1)),
        endTime: today.subtract(const Duration(days: 1)).add(const Duration(hours: 8)),
        color: const Color(0xFF4CAF50),
        isAllDay: true,
      ),
      NeatCleanCalendarEvent(
        'Absent',
        description: 'Absent',
        startTime: today.subtract(const Duration(days: 5)),
        endTime: today.subtract(const Duration(days: 5)),
        color: Colors.red.shade400,
        isAllDay: true,
      ),
    ];
  }

  List<NeatCleanCalendarEvent> _buildCompletedEvents() {
    final now = DateTime.now();
    return [
      NeatCleanCalendarEvent(
        'Republic Day',
        description: 'National holiday',
        startTime: DateTime(now.year, 1, 26),
        endTime: DateTime(now.year, 1, 26),
        color: const Color(0xFF08306D),
        isAllDay: true,
      ),
      NeatCleanCalendarEvent(
        'Holi',
        description: 'School holiday',
        startTime: DateTime(now.year, 3, 25),
        endTime: DateTime(now.year, 3, 26),
        color: Colors.deepOrange,
        isAllDay: true,
        isMultiDay: true,
      ),
      NeatCleanCalendarEvent(
        'Independence Day',
        description: 'National holiday',
        startTime: DateTime(now.year, 8, 15),
        endTime: DateTime(now.year, 8, 15),
        color: const Color(0xFF08306D),
        isAllDay: true,
      ),
    ];
  }

  List<NeatCleanCalendarEvent> get _currentEvents =>
      _selectedTab == _tabAssignment ? _assignmentEvents : _completedEvents;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF526E98), Color(0xFF08306D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(context),
              Expanded(child: _buildCalendarSection(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 12, 16, 16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 22),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          ),
          const SizedBox(width: 12),
          Expanded(child: _buildTabBar(context)),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildTab('Assignment', _tabAssignment),
          _buildTab('Completed', _tabCompleted),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 6, offset: const Offset(0, 2))]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Source Sans 3',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isSelected ? const Color(0xFF08306D) : Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Calendar(
        locale: 'en_US',
        startOnMonday: true,
        weekDays: const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
        eventsList: _currentEvents,
        isExpandable: true,
        isExpanded: true,
        eventDoneColor: Colors.grey.shade400,
        selectedColor: const Color(0xFF08306D),
        selectedTodayColor: const Color(0xFF526E98),
        todayColor: const Color(0xFF526E98),
        defaultDayColor: Colors.black87,
        defaultOutOfMonthDayColor: Colors.grey.shade400,
        todayButtonText: 'Today',
        allDayEventText: 'All day',
        multiDayEndText: 'End',
        expandableDateFormat: 'EEEE, dd MMMM yyyy',
        dayOfWeekStyle: const TextStyle(
          fontFamily: 'Source Sans 3',
          color: Color(0xFF08306D),
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        displayMonthTextStyle: const TextStyle(
          fontFamily: 'Source Sans 3',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        topRowIconColor: const Color(0xFF08306D),
        bottomBarColor: Colors.grey.shade100,
        bottomBarArrowColor: const Color(0xFF08306D),
        bottomBarTextStyle: const TextStyle(
          fontFamily: 'Source Sans 3',
          fontSize: 14,
          color: Colors.black87,
        ),
        showEvents: true,
        showEventListViewIcon: true,
        hideArrows: false,
        hideTodayIcon: false,
        datePickerType: DatePickerType.date,
        onDateSelected: (_) {},
        onEventSelected: (_) {},
      ),
    );
  }
}
