// import 'package:flutter/material.dart';

// class AllReportsScreen extends StatelessWidget {
//   const AllReportsScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blue,
//         foregroundColor: Colors.white,
//         title: const Text('All Reports'),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//       ),
//       body: Stack(
//         children: [
//           // Main loading content
//           const Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 CircularProgressIndicator(
//                   valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
//                 ),
//                 SizedBox(height: 16),
//                 Text(
//                   'Loading reports...',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ],
//             ),
//           ),
          
//           // Compass in top-left corner
//           Positioned(
//             top: 20,
//             left: 20,
//             child: Container(
//               width: 60,
//               height: 60,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 shape: BoxShape.circle,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.2),
//                     blurRadius: 4,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: const Icon(
//                 Icons.navigation,
//                 size: 30,
//                 color: Colors.brown,
//               ),
//             ),
//           ),
          
//           // Control buttons on the right side
//           Positioned(
//             right: 15,
//             top: 100,
//             child: Column(
//               children: [
//                 // Zoom in button
//                 _mapControlButton(
//                   icon: Icons.add,
//                   onPressed: () {
//                     // Zoom in functionality (disabled during loading)
//                   },
//                 ),
//                 const SizedBox(height: 10),
                
//                 // Zoom out button
//                 _mapControlButton(
//                   icon: Icons.remove,
//                   onPressed: () {
//                     // Zoom out functionality (disabled during loading)
//                   },
//                 ),
//                 const SizedBox(height: 10),
                
//                 // Map layers button
//                 _mapControlButton(
//                   icon: Icons.layers,
//                   onPressed: () {
//                     // Map layers functionality (disabled during loading)
//                   },
//                 ),
//                 const SizedBox(height: 10),
                
//                 // Bookmark/Save button
//                 _mapControlButton(
//                   icon: Icons.bookmark_border,
//                   onPressed: () {
//                     // Bookmark functionality (disabled during loading)
//                   },
//                 ),
//                 const SizedBox(height: 10),
                
//                 // Home button
//                 _mapControlButton(
//                   icon: Icons.home,
//                   onPressed: () {
//                     // Home functionality (disabled during loading)
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
  
//   Widget _mapControlButton({
//     required IconData icon,
//     required VoidCallback onPressed,
//   }) {
//     return Container(
//       width: 50,
//       height: 50,
//       decoration: BoxDecoration(
//         color: Colors.blue,
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.2),
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: IconButton(
//         icon: Icon(icon, color: Colors.white),
//         onPressed: onPressed,
//       ),
//     );
//   }
// }