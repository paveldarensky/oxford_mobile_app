import 'package:flutter/material.dart';
import 'package:oxford/app.dart';
import 'package:oxford/widgets/icons/asset_icon.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await IconCatalog.load();
  runApp(const OxfordApp());
}
