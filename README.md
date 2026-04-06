
# Cloudinary Made Easy

A lightweight and easy-to-use Flutter package for uploading images and files to **Cloudinary** using **unsigned upload presets**.

Perfect for developers who want a simple, clean API with **progress tracking**, direct image picking, and no complex setup.

---

## ✨ Features

- Simple unsigned uploads to Cloudinary
- Built-in `ImagePicker` integration (`pickAndUploadImage`)
- Real-time upload progress callback
- Support for custom folders
- Helper method to generate transformed image URLs
- Clean and well-documented API
- Lightweight dependencies

---

## 📦 Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  cloudinary_made_easy: ^0.1.0
```

Then run:

```bash
flutter pub get
```

---

## 🚀 Usage

### 1. Initialize the Service

```dart
final cloudinary = CloudinaryService(
  cloudName: 'your_cloud_name',        // e.g., 'dxtmxu00h'
  uploadPreset: 'your_upload_preset',  // e.g., 'cloudinary_made_easy'
);
```

### 2. Pick and Upload Image (Recommended)

```dart
final String? url = await cloudinary.pickAndUploadImage(
  onProgress: (progress) {
    print('Uploading: ${(progress * 100).toStringAsFixed(0)}%');
  },
  imageQuality: 85,
);

if (url != null) {
  print('Upload successful: $url');
}
```

### 3. Upload Any File (Advanced)

```dart
// For example, from camera or any XFile
final XFile file = ...;

final String? url = await cloudinary.uploadFile(
  file,
  folder: 'profile_pictures',   // optional
  onProgress: (progress) => print('Progress: $progress'),
);
```

### 4. Get Transformed Image URL

```dart
String url = cloudinary.getTransformedUrl(
  'sample-public-id',
  transformation: 'w_500,h_500,c_fill', // Cloudinary transformation string
);
```

---

## 📱 Full Example

Check the [`example/`](example/) folder for a complete working demo with:

- Upload button
- Real-time progress bar
- Image preview after upload
- Clean UI with loading states

---

## ⚙️ How to Setup Cloudinary (One-time)

1. Go to [Cloudinary Dashboard](https://console.cloudinary.com/)
2. Create or select your cloud
3. Go to **Settings → Upload**
4. Create an **Unsigned Upload Preset**
   - Give it a name (e.g. `cloudinary_made_easy`)
   - Set **Signing Mode** to `Unsigned`
   - Save it
5. Copy your **Cloud Name** and **Upload Preset Name**

---

## 📋 API Reference

### `CloudinaryService`

| Method                        | Description                                      |
|------------------------------|--------------------------------------------------|
| `pickAndUploadImage()`       | Pick from gallery and upload                     |
| `uploadFile()`               | Upload any `XFile`                               |
| `getTransformedUrl()`        | Generate URL with transformations                |

---

## 🔧 Parameters

- **`cloudName`** (required): Your Cloudinary cloud name
- **`uploadPreset`** (required): Your unsigned upload preset name
- **`onProgress`** (optional): Callback `(double progress)` → 0.0 to 1.0
- **`folder`** (optional): Organize uploads into folders
- **`imageQuality`** (optional): Default `80`

---

## ⚠️ Important Notes

- This package uses **unsigned uploads** → easy to use but limited (no delete via API easily).
- For advanced features (signed uploads, delete, etc.), consider using official Cloudinary SDKs.
- Make sure your upload preset allows the file types you need (images, videos, etc.).

---

## 📄 License

This project is licensed under the MIT License.

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!

Feel free to open a pull request or issue on GitHub.

---

**Made with ❤️ for Flutter developers**

