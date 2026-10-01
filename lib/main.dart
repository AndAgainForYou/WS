import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ws_test/app.dart';
import 'package:ws_test/core/di/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SemanticsBinding.instance.ensureSemantics();
  await configureDependencies();
  runApp(PathFinderApp());
}
