import 'dart:convert';
import 'dart:typed_data';

/// Service for handling image operations: compression, encoding, and decoding
class ImageService {
  /// Maximum image dimension (width or height) after compression
  static const int maxImageDimension = 300;
  
  /// Maximum image file size in bytes (~500KB)
  static const int maxImageSizeBytes = 500 * 1024;

  /// Converts image bytes to Base64 string
  /// 
  /// Returns the Base64 encoded string of the image data
  static String imageBytesToBase64(Uint8List imageBytes) {
    return base64Encode(imageBytes);
  }

  /// Converts Base64 string to image bytes
  /// 
  /// Returns the decoded image bytes
  static Uint8List base64ToImageBytes(String base64String) {
    return base64Decode(base64String);
  }

  /// Checks if image size is within acceptable limits
  /// 
  /// Returns true if image is under the size limit
  static bool isImageSizeAcceptable(Uint8List imageBytes) {
    return imageBytes.lengthInBytes <= maxImageSizeBytes;
  }

  /// Calculates the Base64 string size after encoding
  /// 
  /// Returns size in bytes
  static int calculateBase64Size(Uint8List imageBytes) {
    return imageBytesToBase64(imageBytes).length;
  }

  /// Formats image size for display
  /// 
  /// Returns formatted string like "250 KB" or "1.5 MB"
  static String formatImageSize(int sizeInBytes) {
    if (sizeInBytes < 1024) {
      return '$sizeInBytes B';
    } else if (sizeInBytes < 1024 * 1024) {
      return '${(sizeInBytes / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(sizeInBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }

  /// Validates image format based on MIME type
  /// 
  /// Accepted formats: JPEG, PNG, GIF, WebP
  /// Returns true if valid image format
  static bool isValidImageFormat(String mimeType) {
    const validFormats = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'];
    return validFormats.contains(mimeType.toLowerCase());
  }

  /// Extracts MIME type from Base64 string header
  /// 
  /// Returns the MIME type string
  static String extractMimeTypeFromBase64(String base64String) {
    // If Base64 has a data URI prefix, extract it
    if (base64String.contains('data:') && base64String.contains(';base64,')) {
      final mimeType = base64String.split('data:')[1].split(';')[0];
      return mimeType;
    }
    return 'image/jpeg'; // Default fallback
  }

  /// Generates a thumbnail size indicator string
  /// 
  /// Returns string like "300x300"
  static String getThumbnailSizeIndicator() {
    return '${maxImageDimension}x${maxImageDimension}';
  }
}
