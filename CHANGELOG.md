# Changelog

## [0.1.0] - 2026-04-06

### Added
- Initial release of `cloudinary_made_easy`
- `CloudinaryService` class with unsigned upload support
- `pickAndUploadImage()` – convenient method with ImagePicker integration
- `uploadFile()` – core method for uploading any `XFile`
- Real-time upload progress callback (`onProgress`)
- Support for custom upload folders
- `getTransformedUrl()` helper for Cloudinary transformations
- Full working example with progress bar and image preview
- Comprehensive README.md and documentation

### Dependencies
- `dio: ^5.7.0`
- `image_picker: ^1.1.0`
- `path: ^1.9.0`

### Notes
- Uses unsigned uploads (simple & easy, no backend signature needed)
- Delete functionality is placeholder only (unsigned limitation)

---

## [Unreleased]

- Support for video uploads
- Multiple file upload
- Better error handling & response parsing
- Riverpod / Provider example