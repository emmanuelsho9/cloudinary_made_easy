
# Cloudinary Made Easy - API Documentation

## Overview

`cloudinary_made_easy` provides a simple `CloudinaryService` class to upload images and files to Cloudinary using **unsigned upload presets**.

---

## CloudinaryService

### Constructor

```dart
CloudinaryService({
  required String cloudName,
  required String uploadPreset,
});
```

**Parameters:**

| Parameter       | Type   | Required | Description                                      |
|-----------------|--------|----------|--------------------------------------------------|
| `cloudName`     | String | Yes      | Your Cloudinary cloud name (e.g. `dxtmxu00h`)   |
| `uploadPreset`  | String | Yes      | Your unsigned upload preset name                 |

---

### Methods

### 1. `pickAndUploadImage()`

Convenient method to pick an image from the gallery and upload it directly.

```dart
Future<String?> pickAndUploadImage({
  Function(double progress)? onProgress,
  int imageQuality = 80,
});
```

**Parameters:**

| Parameter       | Type                  | Default | Description                                      |
|-----------------|-----------------------|---------|--------------------------------------------------|
| `onProgress`    | `Function(double)`    | null    | Callback for upload progress (0.0 → 1.0)         |
| `imageQuality`  | `int`                 | 80      | Image quality (0–100) for compression            |

**Returns:** `Future<String?>` – Secure URL of uploaded image or `null` if failed/cancelled.

---

### 2. `uploadFile()`

Core method to upload any `XFile` (image, video, document, etc.).

```dart
Future<String?> uploadFile(
  XFile file, {
  Function(double progress)? onProgress,
  String? folder,
});
```

**Parameters:**

| Parameter     | Type                    | Required | Description                                      |
|---------------|-------------------------|----------|--------------------------------------------------|
| `file`        | `XFile`                 | Yes      | File to upload                                   |
| `onProgress`  | `Function(double)`      | No       | Progress callback (0.0 to 1.0)                   |
| `folder`      | `String?`               | No       | Cloudinary folder to organize uploads            |

**Returns:** `Future<String?>` – Secure URL or `null`

---

### 3. `getTransformedUrl()`

Generate a Cloudinary URL with transformations (resize, crop, effects, etc.).

```dart
String getTransformedUrl(
  String publicId, {
  String? transformation,
});
```

**Parameters:**

| Parameter        | Type     | Required | Description                                      |
|------------------|----------|----------|--------------------------------------------------|
| `publicId`       | String   | Yes      | Public ID of the uploaded asset                  |
| `transformation` | String?  | No       | Cloudinary transformation string (e.g. `w_500,h_300,c_fill`) |

**Example:**
```dart
String url = cloudinary.getTransformedUrl(
  'user_profile_123',
  transformation: 'w_400,h_400,c_fill,g_face,r_max',
);
```

---

### 4. `deleteFile()`

```dart
Future<bool> deleteFile({required String publicId});
```

**Note:** Currently returns `false` with a warning.  
Unsigned uploads do not support easy deletion via API. Use the Cloudinary dashboard or switch to signed uploads for deletion support.

---

## Usage Examples

### Basic Usage

```dart
final cloudinary = CloudinaryService(
  cloudName: 'dxtmxu00h',
  uploadPreset: 'cloudinary_made_easy',
);

final url = await cloudinary.pickAndUploadImage(
  onProgress: (progress) => print('${(progress * 100).toInt()}%'),
);
```

### With Folder Organization

```dart
await cloudinary.uploadFile(
  file,
  folder: 'users/avatars',
  onProgress: (p) => print('Progress: $p'),
);
```

---

## Error Handling

The package catches `DioException` and general errors internally and returns `null` on failure.  
Check the console for debug messages starting with `❌ Cloudinary`.

For production apps, consider wrapping calls and showing user-friendly messages.

---

## Limitations

- Only supports **unsigned uploads**
- No direct delete support via API
- Currently focused on images (video support coming soon)
