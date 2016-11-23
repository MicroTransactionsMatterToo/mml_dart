import 'types.dart';
import 'enums.dart';
import 'constants.dart';
import 'errors.dart';


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
    this.author = "Unknown";
    this.copyright = "";
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

  /// Parses the given string, assuming it to be a valid MML note
  ///
  /// Valid MMLNotes will match this RegExp `[abcdefg]{1}[+|-]{0,1}\d*[.]*`
  parseNote(String input) {
    String note = input[0];
    Iterable<Match> dots = input.allMatches(".");
    RegExp semitoneRaisesRegExp = new RegExp("[-|+|#]");
    Match semitoneRaises = semitoneRaisesRegExp.firstMatch(input);
    RegExp lengthRegExp = new RegExp("([0-9]+)");
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
        note,
        this.currentVolume,
        finalLength,
        this.currentOctave,
        dotFactor,
        isFlat,
        isSharp);
    this.add(temp);
  }

  parseRest(String input) {
    Iterable<Match> dots = input.allMatches(".");
    RegExp lengthRegExp = new RegExp("[0-9]+");
    int finalLength = this.currentNoteLength;
    if (lengthRegExp.hasMatch(input)) {
      finalLength = int.parse(lengthRegExp.firstMatch(input).group(0));
    }
    var temp = new MMLRest(finalLength, dots.length);
    this.add(temp);
  }

  parseEvent(String input) {
    dynamic appendValue;
    // First item will always be the event type
    String eventType = input[0];
    num eventValue;
    RegExp eventRegexp = new RegExp("[0-9]+");
    if (eventRegexp.hasMatch(input)) {
      print(eventRegexp.firstMatch(input).group(0));
      eventValue = num.parse(eventRegexp.firstMatch(input).group(0));
    } else {
      eventValue = 0;
    }
    switch (eventType) {
      case "t":
        appendValue = new MMLTempo(
            eventValue
        );
        this.currentTempo = eventValue;
        this.add(appendValue);
        break;
      case "v":
        appendValue = new MMLVolume(
            eventValue
        );
        this.currentVolume = eventValue;
        this.add(appendValue);
        break;
      case "l":
        appendValue = new MMLLength(
            eventValue
        );
        this.currentNoteLength = eventValue;
        this.add(appendValue);
        break;
      case "o":
        if (eventValue > 8 || eventValue < 1) {
          throw new OctaveError("Octave ${eventValue} is not valid");
        }
        appendValue = new MMLOctave(
            eventValue
        );
        this.currentOctave = eventValue;
        this.add(appendValue);
        break;
      case ">":
        if (this.currentOctave + 1 > 8) {
          throw new OctaveError(
              "Octave ${this.currentOctave + 1} is not valid");
        }
        appendValue = new MMLOctave(
            this.currentOctave + 1
        );
        this.currentOctave += 1;
        this.add(appendValue);
        break;
      case "<":
        if (this.currentOctave - 1 < 1) {
          throw new OctaveError(
              "Octave ${this.currentOctave - 1} is not valid");
        }
        appendValue = new MMLOctave(
            this.currentOctave - 1
        );
        this.currentOctave -= 1;
        this.add(appendValue);
        break;
    }
  }

  parseRaw(String input) {
    RegExp mmlRegExp = new RegExp(
        r"([abcdefg]{1}[+|-]?[0-9]*[.]*)|([ovt][0-9]+)|([<>])|(r[0-9]*[.]*)|(#.*$)",
        multiLine: true);
    Iterable<Match> matches = mmlRegExp.allMatches(input);
    print(matches.length);
    for (dynamic match in matches) {
      List<String> groups = match.groups([1, 2, 3, 4, 5]);
      print(groups);
      if (groups[0] != null) {
        print("note");
        this.parseNote(groups[0]);
      }
      else if (groups[1] != null) {
        this.parseEvent(groups[1]);
      }
      else if (groups[2] != null) {
        this.parseEvent(groups[2]);
      }
      else if (groups[3] != null) {
        this.parseRest(groups[3]);
      }
      else if (groups[4] != null) {
        this.parseMetadata(groups[4]);
      }
    }
  }

  add(dynamic item) {
    if (item is MMLNote) {
      this.notes.add(item);
      this.mmlEvents.add(item);
    } else {
      this.mmlEvents.add(item);
    }
  }

  // Array methods
  dynamic elementAt(int index) {
    if (index is! int) throw new ArgumentError.notNull("index");
    RangeError.checkNotNegative(index, "index");
    int elementIndex = 0;
    for (dynamic element in this.mmlEvents) {
      if (index == elementIndex) return element;
      elementIndex++;
    }
    throw new RangeError.index(
        index, this.mmlEvents, "index", null, elementIndex);
  }

  // Built-ins
  String toString() {
    String returnValue = "${this.title} by ${this.author}, ${this.copyright}";
    return returnValue;
  }

  List<dynamic> toList({bool growable: true}) {
    return new List.from(this.mmlEvents, growable: growable);
  }

  Set<dynamic> toSet() {
    return new Set.from(this.mmlEvents);
  }
}