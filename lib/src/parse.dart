import 'types.dart';
import 'enums.dart';
import 'constants.dart';


class MMLParser {
  num currentOctave;
  int currentTempo;
  int currentNoteLength;
  articulationTypes currentArticulation;
  int currentVolume;
  String author;
  String copyright;
  String title;
  List<MMLNote> notes;
  List<dynamic> mmlEvents;

  // Constructor
  MMLParser() {
    this.currentOctave = defaultOctave;
    this.currentArticulation = articulationTypes.N;
    this.currentNoteLength = 4;
    this.currentTempo = 120;
    this.currentVolume = 12;
    this.author = "Unkown";
    this.copyright = null;
    this.title = "Untitled";
    this.notes = new List<MMLNote>();
    this.mmlEvents = new List<dynamic>();
  }

  /// Parses MML metadata
  ///
  /// [input] is expected to be a string
  /// [rval] is the parsed MMLMetadata child class that corresponds to the metadata given
  bool parseMetadata(String input) {
    // Take the current line
    var currentLine = input;
    var rval;
    if (!currentLine.startsWith(new RegExp("^\#"))) {
      return false;
    }

    // Remove misc shit
    currentLine = currentLine.replaceFirst(new RegExp("[\ |\=|\:]"), ":");
    currentLine = currentLine.replaceAll(new RegExp("#"), "");

    // Split by seperator
    var metaPairs = currentLine.split(new RegExp("\:"));
    String key = metaPairs[0];
    String value = metaPairs[1];

    switch (key) {
      case "title":
        rval = new MMLTitle(key, value);
        this.title = rval.name;
        return true;
      case "copyright":
        rval = new MMLCopyright(key, value);
        this.copyright = rval.copyrightNotice;
        return true;
      default:
        rval = new MMLMetadata(key, value);
        return true;
    }
  }

  parseNote(String input) {
    String note = input[0];
    Iterable<Match> dots = input.allMatches(".");
    RegExp semitoneRaisesRegExp = new RegExp("[-|+|#]");
    Match semitoneRaises = semitoneRaisesRegExp.firstMatch(input);
    RegExp lengthRegExp = new RegExp("(\d+)");
    Match lengthMatches = lengthRegExp.firstMatch(input);
    int finalLength = this.currentNoteLength;
    if (lengthRegExp.hasMatch(input)) {
      finalLength = int.parse(lengthMatches.group(0));
    }
    // The more dots, the higher the factor
    int dotFactor = dots.length;
    // Handle different accidentals
    String tempSemitones = "";
    if (semitoneRaisesRegExp.hasMatch(input)) {
      tempSemitones = semitoneRaises.group(0);
    }
    print(tempSemitones);
    bool isFlat = false;
    bool isSharp = false;
    switch (tempSemitones) {
      case "+":
        isSharp = true;
        isFlat = false;
        break;
      case "#":
        isSharp = true;
        isFlat = false;
        break;
      case "-":
        isSharp = false;
        isFlat = true;
        break;
    }
    // Write the length value

    // Build new MMLNote
    var temp = new MMLNote(
        note, this.currentVolume, finalLength,  this.currentOctave, dotFactor, isFlat, isSharp);;
    print(temp);
    print(temp.isSharp);
  }
}