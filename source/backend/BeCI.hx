package backend;

class BeCI {
    public static function round(beats:Float):Float {
        return (60 / PlayState.SONG.bpm) * beats;
    }

    public static function bpm(beats:Float, bpm:Int):Float {
        return (60 / bpm) * beats;
    }
}
