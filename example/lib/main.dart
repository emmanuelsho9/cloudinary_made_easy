import 'package:cloudinary_made_easy/cloudinary_made_easy.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cloudinary Made Easy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CloudinaryExampleScreen(),
    );
  }
}

class CloudinaryExampleScreen extends StatefulWidget {
  const CloudinaryExampleScreen({super.key});

  @override
  State<CloudinaryExampleScreen> createState() =>
      _CloudinaryExampleScreenState();
}

class _CloudinaryExampleScreenState extends State<CloudinaryExampleScreen> {
  final CloudinaryService _cloudinary = CloudinaryService(
    cloudName: 'dxtmxu00h', // ← Change to your Cloudinary cloud name
    uploadPreset: 'cloudinary_made_easy', // ← Change to your upload preset
  );

  String? _uploadedImageUrl;
  double _uploadProgress = 0.0;
  bool _isUploading = false;

  Future<void> _pickAndUploadImage() async {
    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
    });

    try {
      final String? url = await _cloudinary.pickAndUploadImage(
        onProgress: (progress) {
          setState(() {
            _uploadProgress = progress;
          });
        },
        imageQuality: 85,
      );

      if (!mounted) return;

      if (url != null) {
        setState(() {
          _uploadedImageUrl = url;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('✅ Upload Successful!')));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('❌ Upload Failed')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
          _uploadProgress = 0.0;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cloudinary Made Easy'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),

            // Upload Button
            ElevatedButton.icon(
              onPressed: _isUploading ? null : _pickAndUploadImage,
              icon: const Icon(Icons.cloud_upload),
              label: Text(
                _isUploading ? 'Uploading...' : 'Pick Image & Upload',
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),

            const SizedBox(height: 20),

            // Progress Indicator
            if (_isUploading) ...[
              LinearProgressIndicator(value: _uploadProgress, minHeight: 8),
              const SizedBox(height: 8),
              Text(
                'Uploading: ${(_uploadProgress * 100).toStringAsFixed(0)}%',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],

            const SizedBox(height: 30),

            // Uploaded Image Preview
            if (_uploadedImageUrl != null) ...[
              const Text(
                'Uploaded Image:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  _uploadedImageUrl!,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(child: Text('Failed to load image'));
                  },
                ),
              ),
              const SizedBox(height: 10),
              SelectableText(
                _uploadedImageUrl!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ] else if (!_isUploading)
              const Expanded(
                child: Center(
                  child: Text(
                    'No image uploaded yet.\nTap the button above to start.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
