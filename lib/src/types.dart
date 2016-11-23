import 'enums.dart';

class MMLComment {
  String text;

  MMLComment(this.text);

  String toString() => text;
}

/*  BEGIN MMLMetadata */

/// Base class for all MML Metadata
class MMLMetadata {
  String key;
  String value;

  MMLMetadata(this.key, this.value);

  toString() {
    return "${this.key} : ${this.value}";
  }
}

/// Represents the `#title` metadata in MML
class MMLTitle extends MMLMetadata {
  String name;

  MMLTitle(String key, String value)
      : name = value,
        super(key, value);

  toString() {
    return "Title : ${this.name}";
  }
}

/// Represents the `#copyright` metadata in MML
class MMLCopyright extends MMLMetadata {
  String copyrightNotice;

  MMLCopyright(String key, String value)
      : copyrightNotice = value,
        super(key, value);

  toString() {
    return "Copyright: ${this.copyrightNotice}";
  }
}


/* END MMLMetadata */

/* BEGIN Syntax */

/// Represents a single note in MML
class MMLNote {
  String noteName;
  num volume;
  num length;
  num octave;
  bool isSharp;
  bool isFlat;
  int dottedFactor;

  MMLNote(this.noteName, this.volume, this.length, this.octave,
      this.dottedFactor, this.isFlat, this.isSharp);

  String toString() {
    String accidental;
    if (this.isSharp) {
      accidental = "♯";
    }
    if (this.isFlat) {
      accidental = "♭";
    }
    String outString = "Note: ${noteName
        .toUpperCase()}${octave}${accidental != null ? accidental : ""}, Length: ${length}";
    return outString;
  }
}

class MMLRest {
  num length;
  int dottedFactor;

  MMLRest(this.length, this.dottedFactor);
}

/// An MML `v` volume change event
class MMLVolume {
  num volume;

  MMLVolume(this.volume);

  String toString() => "Volume change to ${volume}";
}

/// An MML `o` octave change event
class MMLOctave {
  num octave;

  MMLOctave(this.octave);

  String toString() => "Octave change to ${octave}";
}

/// An MML `l` length change event
class MMLLength {
  num length;

  MMLLength(this.length);
}

class MMLTempo {
  num tempo;

  MMLTempo(this.tempo);

  String toString() => "Tempo change to ${tempo}";
}

/// An articulation type change
class MMLArticulation {
  articulationTypes type;

  /// Generates a new [MMLArticulation] from a string
  MMLArticulation.fromString(String value) {
    switch (value) {
      case 'n':
        this.type = articulationTypes.N;
        break;
      case 's':
        this.type = articulationTypes.S;
        break;
      case 'l':
        this.type = articulationTypes.L;
        break;
      default:
        break;
    }
  }
}

class MMLPlayNote {
  int noteNumber;

  MMLPlayNote(this.noteNumber);
}

/* END Syntax */

/* BEGIN Track Objects */

/// A collection of events and notes
///
/// Each track contains all the events and notes corresponding to it
class MMLTrack {
  List<dynamic> notes;
}