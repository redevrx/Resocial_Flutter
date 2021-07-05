import 'dart:io';

class FileModel {
  final File file;
  final FileType type;

  FileModel({this.file, this.type});

  ///getTypeFile
  ///return true is video file
  ///return false is image file
  bool getTypeFile() {
    final sp = this.file.path.split(".");

    if (sp[sp.length - 1].toLowerCase().contains("mp4") ||
        sp[sp.length - 1].toLowerCase().contains("mkv") ||
        sp[sp.length - 1].toLowerCase().contains("mpeg") ||
        sp[sp.length - 1].toLowerCase().contains("asf") ||
        sp[sp.length - 1].toLowerCase().contains("mov") ||
        sp[sp.length - 1].toLowerCase().contains("aiv")) {
      return true;
    } else {
      return false;
    }
  }

  File getFile() => File(this.file.path);
}

enum FileType { FILE_IMAGE, FILE_VIDEO }

extension FileTypeExtension on FileType {
  String get getType {
    switch (this) {
      case FileType.FILE_IMAGE:
        return "image";
      case FileType.FILE_VIDEO:
        return "video";
      default:
        return "";
    }
  }
}
