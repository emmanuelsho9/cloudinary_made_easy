import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p; // Better cross-platform basename

/// Cloudinary upload resource type.
///
/// - [image] — photos, GIFs, etc.
/// - [video] — video and **audio** (Cloudinary stores audio as video resources)
/// - [raw] — PDF, Office docs, zip, txt, and other non-image/non-video files
/// - [auto] — pick [image], [video], or [raw] from the file extension
enum CloudinaryResourceType { image, video, raw, auto }

/// A simple service for uploading images/files to Cloudinary using unsigned uploads.
class CloudinaryService {
  final dio.Dio _dio = dio.Dio();

  final String cloudName;
  final String uploadPreset;

  CloudinaryService({required this.cloudName, required this.uploadPreset});

  /// Helper to get filename from path (cross-platform safe)
  String _basename(String path) {
    return p.basename(path);
  }

  static const _imageExtensions = {
    'jpg',
    'jpeg',
    'png',
    'gif',
    'webp',
    'bmp',
    'svg',
    'heic',
    'heif',
    'tiff',
    'tif',
  };

  static const _videoExtensions = {
    'mp4',
    'mov',
    'avi',
    'webm',
    'mkv',
    'flv',
    'wmv',
    'm4v',
    '3gp',
  };

  /// Audio is uploaded via the video endpoint on Cloudinary.
  static const _audioExtensions = {
    'mp3',
    'wav',
    'm4a',
    'aac',
    'ogg',
    'flac',
    'wma',
    'opus',
  };

  CloudinaryResourceType _resourceTypeFromFileName(String fileName) {
    final ext = p.extension(fileName).replaceFirst('.', '').toLowerCase();
    if (_imageExtensions.contains(ext)) return CloudinaryResourceType.image;
    if (_videoExtensions.contains(ext) || _audioExtensions.contains(ext)) {
      return CloudinaryResourceType.video;
    }
    return CloudinaryResourceType.raw;
  }

  String _uploadEndpoint(CloudinaryResourceType type) {
    final segment = switch (type) {
      CloudinaryResourceType.image => 'image',
      CloudinaryResourceType.video => 'video',
      CloudinaryResourceType.raw => 'raw',
      CloudinaryResourceType.auto => throw ArgumentError(
        'auto must be resolved before upload',
      ),
    };
    return 'https://api.cloudinary.com/v1_1/$cloudName/$segment/upload';
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

    return await uploadFile(
      pickedFile,
      onProgress: onProgress,
      resourceType: CloudinaryResourceType.image,
    );
  }

  /// Upload any [XFile] to Cloudinary (images, audio, video, PDF, docs, etc.).
  ///
  /// Use [resourceType] to force the Cloudinary endpoint, or [CloudinaryResourceType.auto]
  /// (default) to choose from the file extension.
  Future<String?> uploadFile(
    XFile file, {
    Function(double progress)? onProgress,
    String? folder, // Optional: organize uploads
    CloudinaryResourceType resourceType = CloudinaryResourceType.auto,
  }) async {
    try {
      final bytes = await file.readAsBytes();
      final fileName = file.name.isNotEmpty ? file.name : _basename(file.path);
      final resolvedType = resourceType == CloudinaryResourceType.auto
          ? _resourceTypeFromFileName(fileName)
          : resourceType;
      final endpoint = _uploadEndpoint(resolvedType);

      final formData = dio.FormData.fromMap({
        'file': dio.MultipartFile.fromBytes(bytes, filename: fileName),
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
  String getTransformedUrl(String publicId, {String? transformation}) {
    final base = 'https://res.cloudinary.com/$cloudName/image/upload';
    return transformation != null
        ? '$base/$transformation/$publicId'
        : '$base/$publicId';
  }

  // Delete is tricky with unsigned uploads → left as placeholder
  Future<bool> deleteFile({required String publicId}) async {
    debugPrint(
      "Delete not supported with unsigned uploads (requires signed API).",
    );
    return false;
  }
}
