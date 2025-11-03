import 'dart:io';
import 'package:gal/gal.dart';

/// Service to save images to device gallery
class ImageGalleryService {
  static final ImageGalleryService _instance = ImageGalleryService._internal();
  factory ImageGalleryService() => _instance;
  ImageGalleryService._internal();

  /// Save image file to device gallery
  /// Returns true if successful, false otherwise
  Future<bool> saveImageToGallery(File imageFile, {String? fileName}) async {
    try {
      // Request permission using gal package (it handles platform-specific permissions)
      if (!await Gal.hasAccess()) {
        final granted = await Gal.requestAccess();
        if (!granted) {
          print('ImageGalleryService: Permission denied');
          return false;
        }
      }

      // Save to gallery using gal package
      try {
        await Gal.putImage(imageFile.path, album: 'Bhooskhalann');
        print('ImageGalleryService: Image saved successfully to gallery');
        return true;
      } catch (e) {
        print('ImageGalleryService: Failed to save image - $e');
        return false;
      }
    } catch (e) {
      print('ImageGalleryService: Error saving image to gallery - $e');
      return false;
    }
  }

  /// Save image to gallery silently (no user notification)
  /// Used when capturing images from camera
  Future<void> saveImageToGallerySilently(File imageFile) async {
    try {
      await saveImageToGallery(imageFile);
      // Silently save - no user notification needed
    } catch (e) {
      print('ImageGalleryService: Silent save failed - $e');
      // Don't show error to user for silent saves
    }
  }
}
