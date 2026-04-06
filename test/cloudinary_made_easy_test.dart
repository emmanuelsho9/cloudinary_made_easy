// import 'package:flutter_test/flutter_test.dart';
// import 'package:cloudinary_made_easy/cloudinary_made_easy.dart';
// import 'package:cloudinary_made_easy/cloudinary_made_easy_platform_interface.dart';
// import 'package:cloudinary_made_easy/cloudinary_made_easy_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// class MockCloudinaryMadeEasyPlatform
//     with MockPlatformInterfaceMixin
//     implements CloudinaryMadeEasyPlatform {
//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }

// void main() {
//   final CloudinaryMadeEasyPlatform initialPlatform = CloudinaryMadeEasyPlatform.instance;

//   test('$MethodChannelCloudinaryMadeEasy is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelCloudinaryMadeEasy>());
//   });

//   test('getPlatformVersion', () async {
//     CloudinaryMadeEasy cloudinaryMadeEasyPlugin = CloudinaryMadeEasy();
//     MockCloudinaryMadeEasyPlatform fakePlatform = MockCloudinaryMadeEasyPlatform();
//     CloudinaryMadeEasyPlatform.instance = fakePlatform;

//     expect(await cloudinaryMadeEasyPlugin.getPlatformVersion(), '42');
//   });
// }
