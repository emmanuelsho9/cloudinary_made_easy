import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p; // Better cross-platform basename

/// A simple service for uploading images/files to Cloudinary using unsigned uploads.
class CloudinaryService {
  final dio.Dio _dio = dio.Dio();

  final String cloudName;
  final String uploadPreset;

  CloudinaryService({
    required this.cloudName,
    required this.uploadPreset,
  });

  /// Helper to get filename from path (cross-platform safe)
  String _basename(String path) {
    return p.basename(path);
  }

  /// Pick image from gallery and upload directly
  Future<String?> pickAndUploadImage({
    Function(double progress)? onProgress,
    int imageQuality = 80,
  }) async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: imageQuality,
    );

    if (pickedFile == null) return null;

    return await uploadFile(pickedFile, onProgress: onProgress);
  }

  /// Upload any XFile to Cloudinary (core method)
  Future<String?> uploadFile(
    XFile file, {
    Function(double progress)? onProgress,
    String? folder, // Optional: organize uploads
  }) async {
    final endpoint = "https://api.cloudinary.com/v1_1/$cloudName/image/upload";

    try {
      final bytes = await file.readAsBytes();
      final fileName = file.name.isNotEmpty ? file.name : _basename(file.path);

      final formData = dio.FormData.fromMap({
        'file': dio.MultipartFile.fromBytes(
          bytes,
          filename: fileName,
        ),
        'upload_preset': uploadPreset,
        if (folder != null && folder.isNotEmpty) 'folder': folder,
      });

      final response = await _dio.post(
        endpoint,
        data: formData,
        onSendProgress: (sent, total) {
          if (onProgress != null && total > 0) {
            onProgress(sent / total);
          }
        },
      );

      if (response.statusCode == 200) {
        final String? secureUrl = response.data?['secure_url'];
        if (secureUrl != null && secureUrl.isNotEmpty) {
          debugPrint("✅ Cloudinary upload successful: $secureUrl");
          return secureUrl;
        }
      }

      debugPrint("❌ Cloudinary failed with status: ${response.statusCode}");
      return null;
    } on dio.DioException catch (e) {
      final errorMsg = e.response?.data ?? e.message ?? 'Unknown error';
      debugPrint("❌ Cloudinary Dio Error: $errorMsg");
      return null;
    } catch (e) {
      debugPrint("❌ Unexpected Cloudinary Error: $e");
      return null;
    }
  }

  /// Optional: Get transformed image URL
  String getTransformedUrl(
    String publicId, {
    String? transformation,
  }) {
    final base = 'https://res.cloudinary.com/$cloudName/image/upload';
    return transformation != null
        ? '$base/$transformation/$publicId'
        : '$base/$publicId';
  }

  // Delete is tricky with unsigned uploads → left as placeholder
  Future<bool> deleteFile({required String publicId}) async {
    debugPrint("Delete not supported with unsigned uploads (requires signed API).");
    return false;
  }
}