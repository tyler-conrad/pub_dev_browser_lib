import 'package:flutter/widgets.dart';

import 'package:pub_dev_browser_lib/pub_dev_browser_lib.dart' as pdbl;

void main() async {
  await pdbl.init();
  runApp(const pdbl.Browser());
}
