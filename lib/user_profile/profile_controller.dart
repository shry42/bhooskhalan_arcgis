import 'package:bhooskhalann/screens/login_register_pages/login_register_screen.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../services/api_service.dart';

class ProfileController extends GetxController {
  var isLoading = true.obs;
  var userData = {}.obs;
  var username = "test user".obs; // Default value
  
  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }
  
Future<void> fetchUserProfile() async {
  isLoading(true);
  try {
    // Get mobile number from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final mobile = prefs.getString('mobile') ?? prefs.getString('rememberMobile');
    
    if (mobile!.isEmpty) {
      print('Mobile number not found in SharedPreferences');
      Get.snackbar("Error", "User data not found. Please login again.");
      // Optionally redirect to login screen
      // Get.offAll(() => LoginScreen());
      return;
    }
    
    var response = await ApiService.get('/Register/get?mobile=$mobile');
    
    if (response != null && response['status'] == "Success") {
      userData.value = response['result'][0];
      username.value = userData.value['username'] ?? "User";
      // Store user data in SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  
  // Store username
  await prefs.setString('username', userData.value['username'] ?? "");
  
  // Store email
  await prefs.setString('email', userData.value['email'] ?? "");
  
  // // Store usertype
  // await prefs.setString('usertype', userData.value['usertype'] ?? "");

    } else {
      print('Failed to fetch user profile: ${response?['message'] ?? "Unknown error"}');
    }
  } catch (e) {
    print('Error fetching user profile: $e');
    // Get.snackbar("Error", "Failed to load profile data");
  } finally {
    isLoading(false);
  }
}

// LOG OUT

Future<void> logout() async {
    try {
      isLoading(true);
      
      // Get mobile number from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final mobile = prefs.getString('mobile') ?? "";
      
      if (mobile.isEmpty) {
        print('Mobile number not found in SharedPreferences');
        _clearLocalData();
        Get.offAllNamed('/login'); // Redirect to login screen
        return;
      }
      
      // Make logout API call
      var response = await ApiService.put('/Login/logout?mobile=$mobile');
      
      if (response != null && response['status'] == "Success") {
        Get.snackbar("Success", "Logged out successfully");
      } else {
        print('Failed to logout: ${response?['message'] ?? "Unknown error"}');
        // Even if the API call fails, we'll still log out locally
      }
      
      // Clear all local data regardless of API response
      _clearLocalData();
      
      // Navigate to login screen
             Get.offAll(LoginRegisterScreen()); // Replace with your actual login route
      
    } catch (e) {
      print('Error during logout: $e');
      // Even if there's an error, still clear local data and redirect
      _clearLocalData();
      Get.snackbar("Notice", "You've been logged out");
      Get.offAll(LoginRegisterScreen());
     
    } finally {
      isLoading(false);
    }
  }
  
  // Helper method to clear all SharedPreferences data
  Future<void> _clearLocalData() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Clear specific keys
    await prefs.remove('token');
    await prefs.remove('mobile');
    await prefs.remove('username');
    await prefs.remove('email');
    await prefs.remove('usertype');
    
    // Alternatively, clear all SharedPreferences data
    // await prefs.clear();
    
    // Reset controller values
    userData.value = {};
    username.value = "test user";
  }
}

