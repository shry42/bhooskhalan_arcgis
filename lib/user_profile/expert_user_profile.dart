// Main Profile Screen
import 'dart:io';
import 'dart:ui';

import 'package:bhooskhalann/user_profile/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';

class ExpertProfileScreen extends StatelessWidget {
  final ProfileController profileController = Get.put(ProfileController());

  ExpertProfileScreen({super.key});

  // Function to launch email client with predefined email address
  void _launchHelpdeskEmail() async {
    // Simple string format for the email URI
    final String email = 'helpdesk.nlfc@gsi.gov.in';
    final String subject = 'help_request'.tr;
    final String body = 'dear_helpdesk_team'.tr;
    
    // Try different URI creation approaches
    try {
      // First approach: direct string
      String emailUri = 'mailto:$email?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}';
      Uri uri = Uri.parse(emailUri);
      
      // Print for debugging
      print('Attempting to launch: $emailUri');
      
      // Use launchUrl with mode that forces external application
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        // Fallback to simpler URI
        Uri simpleUri = Uri.parse('mailto:$email');
        if (await canLaunchUrl(simpleUri)) {
          await launchUrl(simpleUri, mode: LaunchMode.externalApplication);
        } else {
          // _showErrorMessage('Could not open email client');
        }
      }
    } catch (e) {
      print('Error launching email: $e');
      // _showErrorMessage('Error: $e');
    }
  }

  // Function to open PDF file from assets
  Future<void> _openPDF(BuildContext context) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      // Get temporary directory to store the PDF
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/faqs.pdf';
      final file = File(filePath);
      
      // Check if file already exists
      if (!file.existsSync()) {
        // Copy the asset to the file system
        final byteData = await rootBundle.load('assets/pdfs/faqs.pdf');
        final buffer = byteData.buffer;
        await file.writeAsBytes(
          buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes)
        );
      }
      
      // Close loading dialog
      Navigator.pop(context);
      
      // Navigate to PDF viewer
      Get.to(() => PDFViewerScreen(filePath: filePath));
    } catch (e) {
      // Close loading dialog if open
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      
      // Show error dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('error'.tr),
            content: Text('${'could_not_open_pdf'.tr}: $e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('ok'.tr),
              ),
            ],
          );
        },
      );
      
      print('Error opening PDF: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF2196F3),
        elevation: 0,
        title: Text(
          'profile'.tr,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button press
            Get.back();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              profileController.logout();
              // Handle logout button press
              // Add your logout logic here
            },
          ),
        ],
      ),
      body: Obx(() => 
        profileController.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Profile Image
                  Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF2196F3).withOpacity(0.3),
                          width: 4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        backgroundColor: const Color(0xFF2196F3).withOpacity(0.2),
                        radius: 48,
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: const Color(0xFF2196F3).withOpacity(0.7),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Welcome Text with dynamic username
                  Obx(() => Text(
                    '${'welcome'.tr}, ${profileController.username.value}!',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFE57373),
                    ),
                  )),
                  const SizedBox(height: 25),
                  
                  // Menu Items
                  _buildMenuItem(
                    icon: Icons.person,
                    title: 'my_profile'.tr,
                    onTap: () => Get.to(() => MyProfileScreen()),
                  ),
                  _buildDivider(),
                  
                  _buildMenuItem(
                    icon: Icons.help_center_rounded,
                    title: 'helpdesk'.tr,
                    onTap: () {
                      // Navigate to Helpdesk screen
                      _launchHelpdeskEmail();
                    },
                  ),
                  _buildDivider(),
                  
                  _buildMenuItem(
                    icon: Icons.question_answer_rounded,
                    title: 'faqs'.tr,
                    onTap: () => _openPDF(context),
                  ),
                  _buildDivider(),
                  
                  _buildMenuItem(
                    icon: Icons.chat_bubble_outline_rounded,
                    title: 'feedback'.tr,
                    onTap: () => Get.to(() => FeedbackScreen()),
                  ),
                  _buildDivider(),
                  
                  const SizedBox(height: 40),
                  
                  // Delete Account Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.delete_outline_rounded),
                        label: Text(
                          'delete_account'.tr,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onPressed: () {
                          // Show confirmation dialog
                          _showDeleteConfirmationDialog(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFCDD2),
                          foregroundColor: const Color(0xFFE53935),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
      ),
    );
  }

  // Added confirmation dialog for delete account
  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('delete_account'.tr),
          content: Text('delete_account_confirmation'.tr),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('cancel'.tr),
            ),
            TextButton(
              onPressed: () {
                // Handle delete account logic here
                Navigator.pop(context);
                // You would call your API service here
              },
              child: Text('delete'.tr, style: const TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF2196F3).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF2196F3),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.chevron_right,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Divider(
        color: Colors.grey.withOpacity(0.3),
        thickness: 1,
      ),
    );
  }
}

// PDF Viewer Screen
class PDFViewerScreen extends StatelessWidget {
  final String filePath;
  
  const PDFViewerScreen({Key? key, required this.filePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2196F3),
        title: Text('faqs'.tr),
        centerTitle: true,
      ),
      body: PDFView(
        filePath: filePath,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: true,
        pageSnap: true,
        pageFling: true,
        onRender: (_pages) {
          // PDF rendered successfully
        },
        onError: (error) {
          print('Error rendering PDF: $error');
        },
        onPageError: (page, error) {
          print('Error rendering page $page: $error');
        },
        onViewCreated: (PDFViewController pdfViewController) {
          // PDF view created successfully
        },
      ),
    );
  }
}

// My Profile Screen
class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  // Variables to store user data
  String username = '';
  String email = '';
  String mobile = '';
  String usertype = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Load user data when screen initializes
    loadUserData();
  }

  // Load user data from SharedPreferences
  Future<void> loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      setState(() {
        username = prefs.getString('username') ?? 'not_available'.tr;
        email = prefs.getString('email') ?? 'not_available'.tr;
        mobile = prefs.getString('mobile') ?? 'not_available'.tr;
        usertype = prefs.getString('userType') ?? 'not_available'.tr;
        isLoading = false;
      });
    } catch (e) {
      _showErrorMessage('failed_to_load_profile'.tr);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF2196F3),
        elevation: 0,
        title: Text(
          'my_profile'.tr,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: isLoading 
      ? const Center(child: CircularProgressIndicator()) 
      : SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 25),
            
            // Profile Picture
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF2196F3).withOpacity(0.3),
                    width: 4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  backgroundColor: const Color(0xFF2196F3).withOpacity(0.2),
                  radius: 58,
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: const Color(0xFF2196F3).withOpacity(0.7),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            
            // Profile Form
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileField(
                    label: 'username'.tr,
                    icon: Icons.person,
                    value: username,
                  ),
                  const SizedBox(height: 20),
                  
                  _buildProfileField(
                    label: 'email_id'.tr,
                    icon: Icons.email,
                    value: email,
                  ),
                  const SizedBox(height: 20),
                  
                  _buildProfileField(
                    label: 'mobile_number'.tr,
                    icon: Icons.phone,
                    value: mobile,
                  ),
                  const SizedBox(height: 20),
                  
                  _buildProfileField(
                    label: 'usertype'.tr,
                    icon: Icons.verified_user,
                    value: usertype,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileField({
    required String label,
    required IconData icon,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF2196F3),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: const Color(0xFF2196F3),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
 
  void _showErrorMessage(String message) {
    Get.snackbar(
      'error'.tr,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }
}

// Feedback Screen
class FeedbackScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  
  FeedbackScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2196F3),
        title: Text(
          'feedback'.tr,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFormLabel('first_name'.tr, true),
                _buildFormField(),
                const SizedBox(height: 16),
                
                _buildFormLabel('last_name'.tr, true),
                _buildFormField(),
                const SizedBox(height: 16),
                
                _buildFormLabel('email_id'.tr, true),
                _buildEmailField(),
                const SizedBox(height: 16),
                
                _buildFormLabel('subject'.tr, true),
                _buildFormField(),
                const SizedBox(height: 16),
                
                _buildFormLabel('feedback_details'.tr, true),
                _buildFormField(maxLines: 4),
                const SizedBox(height: 16),
                
                _buildFormLabel('enter_otp_sent_to_email'.tr, true),
                _buildFormField(),
                const SizedBox(height: 30),
                
                Center(
                  child: SizedBox(
                    width: 200,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          // Submit feedback
                          Get.snackbar(
                            'success'.tr,
                            'feedback_submitted_successfully'.tr,
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2196F3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        'submit_feedback'.tr.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormLabel(String label, bool isRequired) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF2196F3),
              fontWeight: FontWeight.w500,
            ),
          ),
          if (isRequired)
            const Text(
              ' *',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFormField({int maxLines = 1}) {
    return SizedBox(
      width: double.infinity,
      child: TextFormField(
        maxLines: maxLines,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFEEEEEE),
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: Color(0xFF2196F3), width: 1),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'this_field_is_required'.tr;
          }
          return null;
        },
      ),
    );
  }

  Widget _buildEmailField() {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          child: TextFormField(
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFEEEEEE),
              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Color(0xFF2196F3), width: 1),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'email_required'.tr;
              }
              if (!GetUtils.isEmail(value)) {
                return 'enter_valid_email'.tr;
              }
              return null;
            },
          ),
        ),
        Positioned(
          right: 5,
          top: 5,
          child: TextButton(
            onPressed: () {
              // Send OTP logic
              Get.snackbar(
                'otp_sent'.tr,
                'otp_sent_to_email'.tr,
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            style: TextButton.styleFrom(
              minimumSize: const Size(80, 30),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'send_otp'.tr,
              style: const TextStyle(
                color: Color(0xFF2196F3),
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Enhanced Feedback Screen with better styling
// class EnhancedFeedbackScreen extends StatelessWidget {
//   final formKey = GlobalKey<FormState>();
  
//   EnhancedFeedbackScreen({super.key});
  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF2196F3),
//         elevation: 0,
//         title: Text(
//           'feedback'.tr,
//           style: const TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Get.back();
//           },
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Form(
//             key: formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildInputField(
//                   label: 'first_name'.tr,
//                   icon: Icons.person_outline,
//                   required: true,
//                 ),
//                 const SizedBox(height: 20),
                
//                 _buildInputField(
//                   label: 'last_name'.tr,
//                   icon: Icons.person_outline,
//                   required: true,
//                 ),
//                 const SizedBox(height: 20),
                
//                 _buildEmailField(),
//                 const SizedBox(height: 20),
                
//                 _buildInputField(
//                   label: 'subject'.tr,
//                   icon: Icons.subject,
//                   required: true,
//                 ),
//                 const SizedBox(height: 20),
                
//                 _buildTextArea(
//                   label: 'feedback_details'.tr,
//                   required: true,
//                 ),
//                 const SizedBox(height: 20),
                
//                 _buildOtpField(),
//                 const SizedBox(height: 30),
                
//                 SizedBox(
//                   width: double.infinity,
//                   height: 50,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       if (formKey.currentState!.validate()) {
//                         // Submit feedback
//                         Get.snackbar(
//                           'success'.tr,
//                           'feedback_submitted_successfully'.tr,
//                           snackPosition: SnackPosition.BOTTOM,
//                           backgroundColor: Colors.green,
//                           colorText: Colors.white,
//                         );
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF2196F3),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: Text(
//                       'submit_feedback'.tr.toUpperCase(),
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                         letterSpacing: 1,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildInputField({
//     required String label,
//     required IconData icon,
//     required bool required,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Text(
//               label,
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//                 color: Color(0xFF2196F3),
//               ),
//             ),
//             if (required)
//               const Text(
//                 ' *',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.red,
//                 ),
//               ),
//           ],
//         ),
//         const SizedBox(height: 8),
//         TextFormField(
//           decoration: InputDecoration(
//             hintText: '${'enter'.tr} $label',
//             prefixIcon: Icon(icon, color: const Color(0xFF2196F3)),
//             filled: true,
//             fillColor: Colors.grey[200],
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8.0),
//               borderSide: BorderSide.none,
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8.0),
//               borderSide: BorderSide.none,
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8.0),
//               borderSide: const BorderSide(color: Color(0xFF2196F3), width: 1),
//             ),
//             contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//           ),
//           validator: required
//               ? (value) {
//                   if (value == null || value.isEmpty) {
//                     return '$label ${'is_required'.tr}';
//                   }
//                   return null;
//                 }
//               : null,
//         ),
//       ],
//     );
//   }

//   Widget _buildEmailField() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Text(
//               'email_id'.tr,
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//                 color: Color(0xFF2196F3),
//               ),
//             ),
//             const Text(
//               ' *',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.red,
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 8),
//         TextFormField(
//           decoration: InputDecoration(
//             hintText: '${'enter'.tr} ${'email_id'.tr}',
//             prefixIcon: const Icon(Icons.email, color: Color(0xFF2196F3)),
//             suffixIcon: Container(
//               margin: const EdgeInsets.all(8),
//               child: ElevatedButton(
//                 onPressed: () {
//                   // Send OTP logic
//                   Get.snackbar(
//                     'otp_sent'.tr,
//                     'otp_sent_to_email'.tr,
//                     snackPosition: SnackPosition.BOTTOM,
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF2196F3),
//                   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
//                   minimumSize: const Size(80, 30),
//                 ),
//                 child: Text(
//                   'send_otp'.tr,
//                   style: const TextStyle(fontSize: 12, color: Colors.white),
//                 ),
//               ),
//             ),
//             filled: true,
//             fillColor: Colors.grey[200],
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8.0),
//               borderSide: BorderSide.none,
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8.0),
//               borderSide: BorderSide.none,
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8.0),
//               borderSide: const BorderSide(color: Color(0xFF2196F3), width: 1),
//             ),
//             contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//           ),
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'email_required'.tr;
//             }
//             if (!GetUtils.isEmail(value)) {
//               return 'enter_valid_email'.tr;
//             }
//             return null;
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildTextArea({
//     required String label,
//     required bool required,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Text(
//               label,
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//                 color: Color(0xFF2196F3),
//               ),
//             ),
//             if (required)
//               const Text(
//                 ' *',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.red,
//                 ),
//               ),
//           ],
//         ),
//         const SizedBox(height: 8),
//         TextFormField(
//           maxLines: 4,
//           decoration: InputDecoration(
//             hintText: '${'enter'.tr} $label',
//             filled: true,
//             fillColor: Colors.grey[200],
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8.0),
//               borderSide: BorderSide.none,
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8.0),
//               borderSide: BorderSide.none,
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8.0),
//               borderSide: const BorderSide(color: Color(0xFF2196F3), width: 1),
//             ),
//             contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//           ),
//           validator: required
//               ? (value) {
//                   if (value == null || value.isEmpty) {
//                     return '$label ${'is_required'.tr}';
//                   }
//                   return null;
//                 }
//               : null,
//         ),
//       ],
//     );
//   }

//   Widget _buildOtpField() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Text(
//               'enter_otp_sent_to_email'.tr,
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//                 color: Color(0xFF2196F3),
//               ),
//             ),
//             const Text(
//               ' *',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.red,
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 8),
//         TextFormField(
//           decoration: InputDecoration(
//             hintText: 'enter_otp'.tr,
//             prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF2196F3)),
//             filled: true,
//             fillColor: Colors.grey[200],
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8.0),
//               borderSide: BorderSide.none,
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8.0),
//               borderSide: BorderSide.none,
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8.0),
//               borderSide: const BorderSide(color: Color(0xFF2196F3), width: 1),
//             ),
//             contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//           ),
//           keyboardType: TextInputType.number,
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'otp_required'.tr;
//             }
//             if (value.length < 4) {
//               return 'enter_valid_otp'.tr;
//             }
//             return null;
//           },
//         ),
//       ],
//     );
//   }
// }