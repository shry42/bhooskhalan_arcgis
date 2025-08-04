import 'dart:convert';
import 'dart:io';
import 'package:bhooskhalann/screens/login_register_pages/login_register_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http_certificate_pinning/http_certificate_pinning.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String _baseUrl = 'https://bhusanket.gsi.gov.in/webapi';
  static late SecureHttpClient _client;
  static bool _initialized = false;

  // Initialize with SSL pinning
  static void initialize() {
    if (_initialized) return;
    
    // Your certificate fingerprint
    List<String> certificateSHA256Fingerprints = [
      '75:B6:CB:85:62:92:01:3A:68:3C:11:3D:07:FE:69:7D:C8:80:F5:FA:61:57:16:BD:B4:A1:C9:15:75:47:2C:E1'
    ];
    
    _client = SecureHttpClient.build(certificateSHA256Fingerprints);
    _initialized = true;
    print('✅ Secure API Service initialized with SSL pinning');
  }

  static void _ensureInitialized() {
    if (!_initialized) {
      throw Exception('ApiService not initialized. Call ApiService.initialize() in main.dart first!');
    }
  }

  /// Generic GET request with SSL Pinning
  static Future<dynamic> get(String endpoint) async {
    _ensureInitialized();
    final url = Uri.parse('$_baseUrl$endpoint');

    try {
      final response = await _client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Referer': 'https://bhusanket.gsi.gov.in/',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw HttpException('GET $endpoint failed with status: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('Certificate verification failed')) {
        Get.snackbar(
          "Security Alert",
          "SSL Certificate validation failed - possible security threat",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.shade700,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
        throw Exception('SSL Certificate validation failed - possible MITM attack');
      }
      print('ApiService GET error: $e');
      rethrow;
    }
  }

  /// Generic POST request with SSL Pinning
  static Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    _ensureInitialized();
    final url = Uri.parse('$_baseUrl$endpoint');

    try {
      final response = await _client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Referer': 'https://bhusanket.gsi.gov.in/',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw HttpException('POST $endpoint failed with status: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('Certificate verification failed')) {
        Get.snackbar(
          "Security Alert",
          "SSL Certificate validation failed - possible security threat",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.shade700,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
        throw Exception('SSL Certificate validation failed - possible MITM attack');
      }
      print('ApiService POST error: $e');
      rethrow;
    }
  }

  /// POST request for Landslide with Authentication and SSL Pinning
  static Future<dynamic> postLandslide(String endpoint, List<Map<String, dynamic>> body) async {
    _ensureInitialized();
    final url = Uri.parse('$_baseUrl$endpoint');
    final token = await _getStoredToken();

    try {
      final response = await _client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Referer': 'https://bhusanket.gsi.gov.in/',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        await _handleUnauthorized();
        return null;
      } else {
        // Debug: Print the response body for non-200 status codes
        print('🔍 DEBUG: Server response for status ${response.statusCode}:');
        print('Response body: ${response.body}');
        throw HttpException('POST $endpoint failed with status: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('Certificate verification failed')) {
        Get.snackbar(
          "Security Alert",
          "SSL Certificate validation failed - possible security threat",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.shade700,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
        throw Exception('SSL Certificate validation failed - possible MITM attack');
      }
      print('ApiService POST Landslide error: $e');
      rethrow;
    }
  }

  /// Generic PUT request with SSL Pinning
  static Future<dynamic> put(String endpoint) async {
    _ensureInitialized();
    final url = Uri.parse('$_baseUrl$endpoint');

    try {
      final response = await _client.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Referer': 'https://bhusanket.gsi.gov.in/',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw HttpException('PUT $endpoint failed with status: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('Certificate verification failed')) {
        Get.snackbar(
          "Security Alert",
          "SSL Certificate validation failed - possible security threat",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.shade700,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
        throw Exception('SSL Certificate validation failed - possible MITM attack');
      }
      print('ApiService PUT error: $e');
      rethrow;
    }
  }

  // Helper methods (same as your original)
  static Future<String?> _getStoredToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> _handleUnauthorized() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Clear specific keys
    await prefs.remove('token');
    await prefs.remove('mobile');
    await prefs.remove('username');
    await prefs.remove('email');
    await prefs.remove('usertype');

    Get.snackbar(
      "Error",
      "Unauthorized token expired",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );

    // Navigate to login screen
    Get.offAll(LoginRegisterScreen());
  }
}