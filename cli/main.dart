import 'package:mml_dart/mml_dart.dart';
import 'dart:io';

main() async {
  var file = new File("/Users/ennis/Projects/MML_Dart/cli/example.mml");
  var contents = await file.readAsLines();
  var kk = new MMLParser();
  contents = new List.from(contents);
  kk.parseMetadata(contents[0]);
  kk.parseMetadata(contents[1]);
  kk.parseMetadata(contents[2]);
  print(kk.title);
  print(kk.author);
  print(kk.copyright);
  var gg = kk.parseNote("a#..");
}