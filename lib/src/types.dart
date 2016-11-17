
class MMLComment {
  String text;

  MMLComment(this.text);
}

/*  BEGIN MMLMetadata */

class MMLMetadata {
  String key;
  String value;

  MMLMetadata(this.key, this.value);
}

class MMLTitle extends MMLMetadata {
  String name;

  MMLTitle(String key, String value)
      : name = value,
        super(key, value);
}

class MMLCopyright extends MMLMetadata {
  String copyrightNotice;

  MMLCopyright(String key, String value)
      : copyrightNotice = value,
        super(key, value);
}


/* END MMLMetadata */

/* BEGIN Syntax */

class MMLNote {
  String noteName;
  num volume;
  num length;
  num octave;
  bool isSharp;
  bool isFlat;

  MMLNote(this.noteName, this.volume, this.length, this.octave);
}


class MMLVolume {
  num volume;

  MMLVolume(this.volume);
}

class MMLOctave {
  num octave;

  MMLOctave(this.octave);
}
/* END Syntax */

/* BEGIN Track Objects */

class MMLTrack {
  List<dynamic> notes;
}