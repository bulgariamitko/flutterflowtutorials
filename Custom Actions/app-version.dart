// code provided by - Andrew Schox

import 'package:package_info_plus/package_info_plus.dart';

Future<String> appVersion() async {
  // Add your function code here!
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  String version = packageInfo.version;
  String build = packageInfo.buildNumber;

  return version + " (" + build + ")";
}