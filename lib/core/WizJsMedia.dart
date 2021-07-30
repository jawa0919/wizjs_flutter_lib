/*
 * @FilePath     : /wizjs_flutter_lib/lib/core/WizJsMedia.dart
 * @Date         : 2021-07-22 10:41:34
 * @Author       : wangjia <jawa0919@163.com>
 * @Description  : 媒体
 */

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_compress/video_compress.dart';

class WizJsMedia {
  /// 保存图片到系统相册
  static Future saveImageToPhotosAlbum(Map<String, dynamic> req) async {
    String filePath = req["filePath"] ?? "";
    if (filePath.isEmpty) return Future.error("filePath isEmpty");
    final result = await ImageGallerySaver.saveFile(filePath);
    return Uri.decodeComponent(result);
  }

  /// TODO 2021-07-30 16:20:37 获取图片信息
  static Future getImageInfo(Map<String, dynamic> req) async {
    String src = req["src"] ?? "";
    if (src.isEmpty) return Future.error("src isEmpty");
    return "todo";
  }

  /// 压缩图片接口，可选压缩质量
  static Future compressImage(Map<String, dynamic> req) async {
    String src = req["src"] ?? "";
    int quality = req['quality'] ?? 80;
    if (src.isEmpty) return Future.error("src isEmpty");
    if (quality > 100 || quality < 10)
      return Future.error("quality must 10~100");

    final fielName = src.split("/").last;
    String targetPath = src.replaceFirst(fielName, 'c_$fielName');

    final file = await FlutterImageCompress.compressAndGetFile(src, targetPath,
        quality: quality);
    return file?.path;
  }

  /// 从本地相册选择图片或使用相机拍照。
  static Future chooseImage(Map<String, dynamic> req) async {
    int count = req['count'] ?? 9;
    List<String> sizeType =
        req['sizeType'].cast<String>() ?? ["compressed", "original"];
    List<String> sourceType =
        req['sourceType'].cast<String>() ?? ["album", "camera"];
    final pickFile = await ImagePicker().pickMultiImage();
    if (pickFile == null) return Future.error("no picker");

    final res = await Future.wait(pickFile.map((e) async {
      String path = e.path;
      String type = path.split(".").last;
      int size = await e.length();
      return {"path": path, "type": type, "size": size};
    }));

    return res;
  }

  /// 保存视频到系统相册
  static Future saveVideoToPhotosAlbum(Map<String, dynamic> req) async {
    String filePath = req["filePath"] ?? "";
    if (filePath.isEmpty) return Future.error("filePath isEmpty");
    final result = await ImageGallerySaver.saveFile(filePath);
    return Uri.decodeComponent(result);
  }

  /// TODO 2021-07-30 16:20:37 获取视频详细信息
  static Future getVideoInfo(Map<String, dynamic> req) async {
    String src = req["src"] ?? "";
    if (src.isEmpty) return Future.error("src isEmpty");
    return "todo";
  }

  /// 压缩视频接口
  static Future compressVideo(Map<String, dynamic> req) async {
    String src = req["src"] ?? "";
    String quality = req['quality'] ?? "medium";
    if (src.isEmpty) return Future.error("src isEmpty");
    final qualityEnum = VideoQuality.values
        .firstWhere((e) => "$e".toLowerCase().contains(quality));

    final videoInfo = await VideoCompress.compressVideo(src,
        quality: qualityEnum, includeAudio: true);

    return videoInfo?.path;
  }

  /// 拍摄视频或从手机相册中选视频
  static Future chooseVideo(Map<String, dynamic> req) async {
    List<String> sourceType =
        req['sourceType'].cast<String>() ?? ["album", "camera"];

    // TODO 2021-07-30 17:11:22 压缩
    bool compressed = req['compressed'] ?? true;
    Duration maxDuration = Duration(seconds: req['maxDuration'] ?? 60);

    final source = sourceType.length == 1 && sourceType.contains("camera")
        ? ImageSource.camera
        : ImageSource.gallery;

    final pickFile =
        await ImagePicker().pickVideo(source: source, maxDuration: maxDuration);
    if (pickFile == null) return Future.error("no picker");

    String path = pickFile.path;
    String type = path.split(".").last;
    int size = await pickFile.length();
    return {"path": path, "type": type, "size": size};
  }
}
