import 'package:permission_handler/permission_handler.dart';

Future<bool> storagePermissionManager() async {
  final permissionStatus = await Permission.photos.request();
  if (permissionStatus.isDenied) {
    await Permission.storage.request();
    if (permissionStatus.isDenied) {
      await openAppSettings();
    }
  } else if (permissionStatus.isPermanentlyDenied) {
    await openAppSettings();
  } else {
    return true;
  }
  return false;
}