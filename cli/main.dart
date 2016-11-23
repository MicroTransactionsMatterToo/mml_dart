import 'package:mml_dart/mml_dart.dart';
import 'dart:io';

main() async {
  var file = new File("/Users/ennis/Projects/MML_Dart/cli/example.mml");
  var contents = await file.readAsString();
  var kk = new MMLParser();
  kk.parseRaw(contents);
  print(kk.mmlEvents);
}