import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:qr_login/common.dart';
import 'package:qr_login/ui/root/root_page.dart';

void main() async {
  await initMenu();
  setUrlStrategy(PathUrlStrategy());
  runApp(const RootPage());
}
