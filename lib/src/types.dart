
class MMLComment {
  String text;

  MMLComment(this.text);
}

/*  BEGIN MMLMetadata */

/// Base class for all MML Metadata
class MMLMetadata {
  String key;
  String value;

  MMLMetadata(this.key, this.value);
}

/// Represents the `#title` metadata in MML
class MMLTitle extends MMLMetadata {
  String name;

  MMLTitle(String key, String value)
      : name = value,
        super(key, value);
}

/// Represents the `#copyright` metadata in MML
class MMLCopyright extends MMLMetadata {
  String copyrightNotice;

  MMLCopyright(String key, String value)
      : copyrightNotice = value,
        super(key, value);
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

  MMLNote(this.noteName, this.volume, this.length, this.octave);
}

/// An MML `v` volume change event
class MMLVolume {
  num volume;

  MMLVolume(this.volume);
}

/// An MML `o` octave change event
class MMLOctave {
  num octave;

  MMLOctave(this.octave);
}

/// An MML `l` length change event
class MMLLength {
  num length;

  MMLLength(this.length);
}

/* END Syntax */

/* BEGIN Track Objects */

/// A collection of events and notes
///
/// Each track contains all the events and notes corresponding to it
class MMLTrack {
  List<dynamic> notes;
}