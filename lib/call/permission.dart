import 'package:permission_handler/permission_handler.dart';

class Permissions {
  static Future<bool> checkVideoAndMicroPhonegrant() async {
    Map<Permission, PermissionStatus> status =
        await [Permission.camera, Permission.microphone].request();

    //case user grant permission
    if (status[Permission.camera].isGranted &&
        status[Permission.microphone].isGranted) {
      return true;
    }

    if (status[Permission.camera].isUndetermined ||
        status[Permission.microphone].isUndetermined) {
      return false;
    }
  }
}
