// import 'package:flutter/material.dart';

// class RecentReportsPage extends StatelessWidget {
//   const RecentReportsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 3,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Recent Reports'),
//           leading: const BackButton(),
//           backgroundColor: Colors.blue,
//           bottom: const TabBar(
//             indicator: UnderlineTabIndicator(
//               borderSide: BorderSide(width: 3.0, color: Colors.white),
//               insets: EdgeInsets.symmetric(horizontal: 30.0),
//             ),
//             labelStyle: TextStyle(fontWeight: FontWeight.bold),
//             tabs: [
//               Tab(text: 'DRAFT'),
//               Tab(text: 'TO BE SYNCED'),
//               Tab(text: 'SYNCED'),
//             ],
//           ),
//         ),
//         body: const TabBarView(
//           children: [
//             EmptyReportTab(),
//             EmptyReportTab(),
//             EmptyReportTab(),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class EmptyReportTab extends StatelessWidget {
//   const EmptyReportTab({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.insert_drive_file_rounded, size: 60, color: Colors.grey.shade400),
//           const SizedBox(height: 12),
//           Text(
//             'No reports found',
//             style: TextStyle(
//               color: Colors.grey.shade500,
//               fontSize: 16,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
