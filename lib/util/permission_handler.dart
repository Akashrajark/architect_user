import 'package:permission_handler/permission_handler.dart';

Future<void> requestStoragePermission() async {
  var status = await Permission.storage.status;

  if (status.isGranted) {
    print("Storage Permission Already Granted");
  } else if (status.isDenied) {
    // Request permission again
    if (await Permission.storage.request().isGranted) {
      print("Storage Permission Granted");
    } else {
      print("Storage Permission Denied");
    }
  } else if (status.isPermanentlyDenied) {
    // Open app settings if permission is permanently denied
    print("Storage Permission Permanently Denied. Open App Settings.");
    openAppSettings();
  }
}
