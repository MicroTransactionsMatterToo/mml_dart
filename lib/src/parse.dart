import 'types.dart';

/// Parses MML metadata
///
/// [input] is expected to be an array of strings, split by `\n` or `\r\n`
/// [rval] is the parse MMLMetadata child class that corresponds to the metadata given
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

  switch (key) {
    case "title":
      rval = new MMLTitle(key, value);
      break;
    case "copyright":
      rval = new MMLCopyright(key, value);
      break;
    default:
      rval = new MMLMetadata(key, value);
      break;
  }

  return rval;
}