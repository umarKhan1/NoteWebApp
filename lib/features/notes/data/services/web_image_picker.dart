import 'dart:convert';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

/// Service for picking images on web platforms
class WebImagePickerService {
  static const int _maxFileSizeBytes = 5 * 1024 * 1024; // 5 MB

  /// Pick a single image from the device and return as Base64
  ///
  /// Returns a tuple of (base64String, fileName) or null if cancelled
  static Future<(String, String)?> pickImageAsBase64() async {
    try {
      final picker = ImagePicker();

      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85, // Compress to 85% quality
      );

      if (pickedFile == null) {
        return null; // User cancelled
      }

      // Read the file as bytes
      final bytes = await pickedFile.readAsBytes();

      // Check file size
      if (bytes.length > _maxFileSizeBytes) {
        throw Exception('Image file size exceeds 5 MB limit');
      }

      // Convert to Base64
      final base64String = base64Encode(bytes);

      // Return tuple of (base64, filename)
      return (base64String, pickedFile.name);
    } catch (e) {
      rethrow;
    }
  }

  /// Validate Base64 image data
  static bool isValidBase64Image(String base64String) {
    try {
      // Remove data URI prefix if present
      String cleanBase64 = base64String;
      if (base64String.contains(',')) {
        cleanBase64 = base64String.split(',').last;
      }

      // Try to decode
      base64Decode(cleanBase64);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get MIME type from Base64 data
  static String? getMimeTypeFromBase64(String base64String) {
    try {
      // Remove data URI prefix if present
      String cleanBase64 = base64String;
      if (base64String.contains(',')) {
        final parts = base64String.split(',');
        cleanBase64 = parts.last;

        // Extract MIME type from data URI prefix if available
        if (parts.first.contains('data:')) {
          final mimeMatch = RegExp(r'data:([a-z/+]+);').firstMatch(parts.first);
          if (mimeMatch != null) {
            return mimeMatch.group(1);
          }
        }
      }

      // Try to detect from magic bytes
      final bytes = base64Decode(cleanBase64);
      return _detectMimeType(bytes);
    } catch (e) {
      return null;
    }
  }

  /// Detect MIME type from file magic bytes
  static String _detectMimeType(Uint8List bytes) {
    if (bytes.length < 4) {
      return 'image/unknown';
    }

    // PNG: 89 50 4E 47
    if (bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47) {
      return 'image/png';
    }

    // JPEG: FF D8 FF
    if (bytes[0] == 0xFF && bytes[1] == 0xD8 && bytes[2] == 0xFF) {
      return 'image/jpeg';
    }

    // GIF: 47 49 46
    if (bytes[0] == 0x47 && bytes[1] == 0x49 && bytes[2] == 0x46) {
      return 'image/gif';
    }

    // WebP: RIFF ... WEBP
    if (bytes[0] == 0x52 &&
        bytes[1] == 0x49 &&
        bytes[2] == 0x46 &&
        bytes[3] == 0x46) {
      if (bytes.length >= 12 &&
          bytes[8] == 0x57 &&
          bytes[9] == 0x45 &&
          bytes[10] == 0x42 &&
          bytes[11] == 0x50) {
        return 'image/webp';
      }
    }

    return 'image/unknown';
  }
}
