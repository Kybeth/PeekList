import 'package:flutter_driver/driver_extension.dart';
import 'package:peeklist/main.dart' as app;

void main() {
  enableFlutterDriverExtension();

  // Call the `main()` of your app or call `runApp` with whatever widget
  // you are interested in testing.
  app.main();
}