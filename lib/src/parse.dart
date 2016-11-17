import 'types.dart';


MMLMetadata parseMetadata(List<String> input) {
  // Take the current line
  var currentLine = input[0];
  var rval;

  // Remove misc shit
  currentLine = currentLine
    ..replaceAll(new RegExp(":|\s|\="), ":")
    ..replaceAll(new RegExp("#"), "");

  // Split by seperator
  var metaPairs = currentLine.split(new RegExp("\:"));
  String key = metaPairs[0];
  String value = metaPairs[1];

  switch(key) {
    case "title":
      rval = new MMLTitle(value);
      break;
    case "copyright":
      rval = new MMLCopyright(value);
      break;
    default:
      rval = new MMLMetadata(key, value);
      break;
  }

  return rval;
}