import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../models/user.dart';
import 'attendance_page.dart';
import 'profile_page.dart';

class DashboardPage extends StatelessWidget {
  final User user;

  const DashboardPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF08306D),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context),
            const SizedBox(height: 24),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x1A000000),
                      blurRadius: 8,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: MasonryGridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  itemCount: _dashboardItems.length,
                  itemBuilder: (context, index) {
                    final item = _dashboardItems[index];
                    final isLarge = index < 2;
                    VoidCallback? onTap;
                    if (index == 0) {
                      onTap = () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => AttendancePage(initialTab: 0),
                            ),
                          );
                    } else if (index == 4) {
                      onTap = () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => AttendancePage(initialTab: 1),
                            ),
                          );
                    }
                    return _DashboardCard(
                      imagePath: item.imagePath,
                      title: item.title,
                      isLarge: isLarge,
                      subtitle: isLarge ? item.subtitle : null,
                      onTap: onTap,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi ${user.fnm}',
                  style: const TextStyle(
                    fontFamily: 'Source Sans 3',
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  user.insName,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Student ID: ${user.stuId}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ProfilePage(user: user),
                ),
              );
            },
            customBorder: const CircleBorder(),
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const CircleAvatar(
                radius: 32,
                backgroundColor: Colors.white24,
                child: Icon(Icons.person, size: 40, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardItem {
  final String imagePath;
  final String title;
  final String? subtitle;

  const _DashboardItem({
    required this.imagePath,
    required this.title,
    this.subtitle,
  });
}

const List<_DashboardItem> _dashboardItems = [
  _DashboardItem(
    imagePath: 'assets/images/ic_attendance.svg',
    title: '80.39%',
    subtitle: 'Attendance',
  ),
  _DashboardItem(
    imagePath: 'assets/images/ic_fees_due.svg',
    title: '₹ 10,000',
    subtitle: 'Fees Due',
  ),
  _DashboardItem(
    imagePath: 'assets/images/ic_quiz.svg',
    title: 'Play Quiz',
  ),
  _DashboardItem(
    imagePath: 'assets/images/ic_assignment.svg',
    title: 'Assignment',
  ),
  _DashboardItem(
    imagePath: 'assets/images/ic_holiday.svg',
    title: 'School Holiday',
  ),
  _DashboardItem(
    imagePath: 'assets/images/ic_calendra.svg',
    title: 'Time Table',
  ),
  _DashboardItem(
    imagePath: 'assets/images/ic_results.svg',
    title: 'Result',
  ),
  _DashboardItem(
    imagePath: 'assets/images/ic_date_sheet.svg',
    title: 'Date Sheet',
  ),
  _DashboardItem(
    imagePath: 'assets/images/ic_doubts.svg',
    title: 'Ask Doubts',
  ),
  _DashboardItem(
    imagePath: 'assets/images/ic_gallery.svg',
    title: 'School Gallery',
  ),
  _DashboardItem(
    imagePath: 'assets/images/ic_leave.svg',
    title: 'Leave Application',
  ),
  _DashboardItem(
    imagePath: 'assets/images/ic_password.svg',
    title: 'Change Password',
  ),
  _DashboardItem(
    imagePath: 'assets/images/ic_event.svg',
    title: 'Events',
  ),
  _DashboardItem(
    imagePath: 'assets/images/ic_logout.svg',
    title: 'Logout',
  ),
];

class _DashboardCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final bool isLarge;
  final String? subtitle;
  final VoidCallback? onTap;

  const _DashboardCard({
    required this.imagePath,
    required this.title,
    this.isLarge = false,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = Card(
      color: const Color(0xFFF5F7FB),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 26, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset(
              imagePath,
              width: 72,
              height: 72,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: isLarge ? 'Bebas Neue' : 'Source Sans 3',
                    fontSize: isLarge ? 40 : 18,
                    fontWeight: isLarge ? FontWeight.w400 : FontWeight.w600,
                  ),
                ),
                if (isLarge && subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      fontFamily: 'Source Sans 3',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: card,
      );
    }
    return card;
  }
}
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

// import '../models/user.dart';
// import 'profile_page.dart';

// class DashboardPage extends StatelessWidget {
//   final User user;

//   const DashboardPage({super.key, required this.user});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF08306D),
//       body: SafeArea(
//         child: Column(
//           children: [
//             _buildHeader(context),

//             const SizedBox(height: 16),

//             /// WHITE CONTAINER
//             Expanded(
//               child: Container(
//                 decoration: const BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(24),
//                     topRight: Radius.circular(24),
//                   ),
//                 ),
//                 child: CustomScrollView(
//                   physics: const BouncingScrollPhysics(),

//                   slivers: [
//                     /// 🔒 STICKY TOP CARDS
//                     SliverPersistentHeader(
//                       pinned: true,
//                       delegate: _StickyStatsDelegate(),
//                     ),

//                     /// GRID CONTENT
//                     SliverPadding(
//                       padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
//                       sliver: SliverMasonryGrid.count(
//                         crossAxisCount: 2,
//                         mainAxisSpacing: 12,
//                         crossAxisSpacing: 12,
//                         childCount: _dashboardItems.length - 2,
//                         itemBuilder: (context, index) {
//                           final item = _dashboardItems[index + 2];
//                           return _DashboardCard(
//                             imagePath: item.imagePath,
//                             title: item.title,
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
//       child: Row(
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Hi ${user.fnm}',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 28,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   user.insName,
//                   style: const TextStyle(
//                     color: Colors.white70,
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   'Student ID: ${user.stuId}',
//                   style: const TextStyle(
//                     color: Colors.white70,
//                     fontSize: 14,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           InkWell(
//             onTap: () {
//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (_) => ProfilePage(user: user),
//                 ),
//               );
//             },
//             customBorder: const CircleBorder(),
//             child: Container(
//               padding: const EdgeInsets.all(3),
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(color: Colors.white, width: 2),
//               ),
//               child: const CircleAvatar(
//                 radius: 32,
//                 backgroundColor: Colors.white24,
//                 child: Icon(Icons.person, size: 40, color: Colors.white),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// /// 🔒 STICKY HEADER DELEGATE
// class _StickyStatsDelegate extends SliverPersistentHeaderDelegate {
//   @override
//   double get minExtent => 140;

//   @override
//   double get maxExtent => 140;

//   @override
//   Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
//     final attendance = _dashboardItems[0];
//     final fees = _dashboardItems[1];

//     return Container(
//       color: Colors.white,
//       padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
//       child: Row(
//         children: [
//           Expanded(
//             child: _DashboardCard(
//               imagePath: attendance.imagePath,
//               title: attendance.title,
//               subtitle: attendance.subtitle,
//               isLarge: true,
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: _DashboardCard(
//               imagePath: fees.imagePath,
//               title: fees.title,
//               subtitle: fees.subtitle,
//               isLarge: true,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
//     return false;
//   }
// }

// /// DATA MODELS — UNCHANGED
// class _DashboardItem {
//   final String imagePath;
//   final String title;
//   final String? subtitle;

//   const _DashboardItem({
//     required this.imagePath,
//     required this.title,
//     this.subtitle,
//   });
// }

// const List<_DashboardItem> _dashboardItems = [
//   _DashboardItem(
//     imagePath: 'assets/images/ic_attendance.svg',
//     title: '80.39%',
//     subtitle: 'Attendance',
//   ),
//   _DashboardItem(
//     imagePath: 'assets/images/ic_fees_due.svg',
//     title: '₹ 10,000',
//     subtitle: 'Fees Due',
//   ),
//   _DashboardItem(imagePath: 'assets/images/ic_quiz.svg', title: 'Play Quiz'),
//   _DashboardItem(imagePath: 'assets/images/ic_assignment.svg', title: 'Assignment'),
//   _DashboardItem(imagePath: 'assets/images/ic_holiday.svg', title: 'School Holiday'),
//   _DashboardItem(imagePath: 'assets/images/ic_calendra.svg', title: 'Time Table'),
//   _DashboardItem(imagePath: 'assets/images/ic_results.svg', title: 'Result'),
//   _DashboardItem(imagePath: 'assets/images/ic_date_sheet.svg', title: 'Date Sheet'),
//   _DashboardItem(imagePath: 'assets/images/ic_doubts.svg', title: 'Ask Doubts'),
//   _DashboardItem(imagePath: 'assets/images/ic_gallery.svg', title: 'School Gallery'),
//   _DashboardItem(imagePath: 'assets/images/ic_leave.svg', title: 'Leave Application'),
//   _DashboardItem(imagePath: 'assets/images/ic_password.svg', title: 'Change Password'),
//   _DashboardItem(imagePath: 'assets/images/ic_event.svg', title: 'Events'),
//   _DashboardItem(imagePath: 'assets/images/ic_logout.svg', title: 'Logout'),
// ];

// /// CARD — UNCHANGED
// class _DashboardCard extends StatelessWidget {
//   final String imagePath;
//   final String title;
//   final bool isLarge;
//   final String? subtitle;

//   const _DashboardCard({
//     required this.imagePath,
//     required this.title,
//     this.isLarge = false,
//     this.subtitle,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: const Color(0xFFF5F7FB),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//       elevation: 0,
//       child: Padding(
//         padding: const EdgeInsets.fromLTRB(20, 26, 20, 20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SvgPicture.asset(imagePath, width: 72, height: 72),
//             const Spacer(),
//             Text(
//               title,
//               style: TextStyle(
//                 fontFamily: isLarge ? 'Bebas Neue' : 'Source Sans 3',
//                 fontSize: isLarge ? 40 : 18,
//                 fontWeight: isLarge ? FontWeight.w400 : FontWeight.w600,
//               ),
//             ),
//             if (isLarge && subtitle != null) ...[
//               const SizedBox(height: 4),
//               Text(
//                 subtitle!,
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }

