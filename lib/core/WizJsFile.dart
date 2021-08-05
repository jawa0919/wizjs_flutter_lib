/*
 * @FilePath     : /wizjs_flutter_lib/lib/core/WizJsFile.dart
 * @Date         : 2021-08-05 15:16:23
 * @Author       : jawa0919 <jawa0919@163.com>
 * @Description  : 文件
 */

import 'dart:io';

import 'package:flutter_archive/flutter_archive.dart';
import 'package:open_file/open_file.dart';
import 'package:crypto/crypto.dart';

class WizJsFile {
  /// 删除本地缓存文件
  static Future removeSavedFile(Map<String, dynamic> req) async {
    String filePath = req["filePath"] ?? "";
    if (filePath.isEmpty) return Future.error("filePath isEmpty");
    final file = File(filePath);
    await file.delete();
    return;
  }

  /// 新开页面打开文档
  static Future openDocument(Map<String, dynamic> req) async {
    String filePath = req["filePath"] ?? "";
    if (filePath.isEmpty) return Future.error("filePath isEmpty");
    await OpenFile.open(filePath);
    return;
  }

  /// 获取文件信息
  static Future getFileInfo(Map<String, dynamic> req) async {
    String filePath = req["filePath"] ?? "";
    String digestAlgorithm = req["digestAlgorithm"] ?? "md5";
    if (filePath.isEmpty) return Future.error("filePath isEmpty");
    final file = File(filePath);

    final size = await file.length();
    String digest = "";

    final byte = await file.readAsBytes();
    if (digestAlgorithm == "md5") {
      digest = md5.convert(byte).toString();
    }
    if (digestAlgorithm == "sha1") {
      digest = sha1.convert(byte).toString();
    }
    return;
  }

  /// 解压文件
  static Future unzip(Map<String, dynamic> req) async {
    String zipFilePath = req["zipFilePath"] ?? "";
    String targetPath = req["targetPath"] ?? "";
    if (zipFilePath.isEmpty) return Future.error("zipFilePath isEmpty");
    if (targetPath.isEmpty) return Future.error("targetPath isEmpty");
    File zipFile = File(zipFilePath);
    Directory target = Directory(targetPath);
    await ZipFile.extractToDirectory(zipFile: zipFile, destinationDir: target);
    return;
  }
}
