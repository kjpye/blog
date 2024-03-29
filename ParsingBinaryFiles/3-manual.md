Parsing Binary Files
====================

Part III—Manually reading the data
----------------------------------

The most obvious, although not necessarily the easiest, way to read values from a binary file is to read each byte, and reassemble multi-byte values by hand. While there are easier ways when standard values like 32-bit integers are involved, in a streaming file there are often values which don't correspond to standard storage. In our MIDI file example, there are 24-bit unsigned integers, and variable length integers. There is no way to process these values without handling the bytes individually.

### Reading the chunk header

Let us look firstly at the start of the MIDI file:

    000000 4d 54 68 64 00 00 00 06 00 01 00 04 01 80        >MThd..........<

(which is the header we saw in Part I).

We might start with code like

    my $file = 'thestar.midi'.IO.open(:r, :bin);
    my $chunk-header = $file.read(8);

which will read the first eight bytes of the file, containing the chunk type, and the length of the chunk data. (Note that I'm omitting all error handling code.)

We can then read the bytes into appropriate variables:

    my $chunktype   = $chunk-header[0].chr ~
                      $chunk-header[1].chr ~
                      $chunk-header[2].chr ~
                      $chunk-header[3].chr;
    my $chunklength = ($chunk-header[4] +< 24) +|
                      ($chunk-header[5] +< 16) +|
                      ($chunk-header[6] +<  8) +|
                       $chunk-header[7];

### Reading the header data

Now that we have the length of the data, we can read it:

    my $chunkdata = $file.read($chunklength);

We can then handle the data within the chunk. In this case we know it's going to be a header:

    my $format;
    my $ntrks;
    my $division;
    if $chunktype eq 'MThd' {
      $format   = ($chunktype[0] +< 8) +|
                   $chunktype[1];
      $ntrks    = ($chunktype[2] +< 8) +|
                   $chunktype[3];
      $division = ($chunktype[4] +< 8) +|
                   $chunktype[5];
    }

This gives us the information we need to be able to correctly interpret the remainder of the file.

Note that, in practice, we would define functions to get the values of the variables, perhaps like this:

    # MIDI strings are ASCII only
    sub get-string(Blob $buffer, Int $offset, Int $length -> String) {
      my $s = '';
      for ^$length --> $i {
        $s ~= $buffer[$offset + $i].chr;
      }
      $s;
    }

    sub get-uint16(Blob $buffer, Int $offset -> Int) {
    (
      $buffer[$offset] +< 8) +| $buffer[$offset + 1];
    }

    sub get-uint32(Blob $buffer, Int $offset -> Int) {
      (get-uint16[$buffer, $offset) +< 16) + get-uint16($buffer, $offset + 2);
    }

and our code so far becomes a little more understandable:

    my $chunktype   = get-string($chunk-header, 0, 4);
    my $chunklength = get-uint32($chunk-header, 4)

and

    $format   = get-uint16($chunk-data, 0);
    $ntrks    = get-uint16($chunk-data, 2);
    $division = get-uint16($chunk-data, 4);

As an aside, the format field can contain only the values 0, 1, and 2. Our example file is format 1, but it makes little difference to how we process the file.

`ntrks` is the number of tracks in the file. We can either read that many tracks, or just keep reading until we reach the end of the file.

`division` relates how times within the tracks are interpreted. When the most-significant bit is clear (as in our example file) then the field specifies the number of midi-ticks (the units used within the track) per quarter note. When combines with tempo information within the tracks this will give the actual times when notes should be played. When the most-significant bit is set the times within the tracks are in a form of absolute time related to the frame-rate. This would be used for MIDI files associated with video sources.

### Reading the tracks

We can continue by reading the tracks. We start by reading the chunk header, as we did before:

    $chunk-header = $file.read(8);

Note that we don't need to seek anywhere in the file; the track data immediately follow on from the header information.

    $chunktype   = get-string($chunk-header, 0);
    $chunklength = get-uint32($chunk-header, 4);
    $chunkdata   = $file.read($chunklength);

    if $chunktype eq 'MTrk' {
      # process the track
    }

The first track of our example file looks like this:

    000000                                           4d 54  >              MT<
    000010 72 6b 00 00 00 6f 00 ff 03 1d 54 77 69 6e 6b 6c  >rk...o....Twinkl<
    000020 65 2c 20 54 77 69 6e 6b 6c 65 2c 20 4c 69 74 74  >e, Twinkle, Litt<
    000030 6c 65 20 53 74 61 72 00 ff 01 09 63 72 65 61 74  >le Star....creat<
    000040 6f 72 3a 20 00 ff 01 1e 4c 69 6c 79 50 6f 6e 64  >or: ....LilyPond<
    000050 20 32 2e 32 35 2e 35 20 20 20 20 20 20 20 20 20  > 2.25.5         <
    000060 20 20 20 20 20 20 00 ff 58 04 02 02 18 08 00 ff  >      ..X.......<
    000070 51 03 09 27 c0 81 90 00 ff 58 04 02 02 18 08 81  >Q..'.....X......<
    000080 90 00 ff 2f 00                                   >.../.           <

The format of the track, after the 8 bytes of the standard chunk header, is a number of commands, each preceded by a variable-length integer representing the time delay (the "delta-time") from the previous command.

A variable-length integer consists of zero to three bytes with the most-significant bit set, followed by one byte with the most-significant bit clear. The integer is formed by taking the least-significant 7 bits of each byte; the first byte is the most significant. The resultant number is a maximum of 28 bits (unsigned).

Let us define a function which can read variable-length integers:

    sub read-varint($buffer, $offset is rw -> Int) {
      my $val = 0;
      do {
        $val +<= 7;
        $val +|= $buffer[$offset] +& 0x7f;
      } until $buffer[$offset++] +& 0x80 == 0;
    }

Here we have assumed that the MIDI file is well-formed, and don't bother to check that there are no more than four bytes. Because this function reads a variable number of bytes we need some way to indicate how many bytes have been read so that we know where to start reading the next information; in this case we have directly updated the offset into the chunk.

#### Text events

The first byte of the track is `00`, representing a delta-time of 0. Thus the event occurs right at the beginning of the track. This is followed by `ff`, representing a meta-event. The following byte (`03`) specifies the meta event as a sequence or track name, and is followed by a counted ASCII string. Thus the full event is

    000010                   00 ff 03 1d 54 77 69 6e 6b 6c  >      ....Twinkl<
    000020 65 2c 20 54 77 69 6e 6b 6c 65 2c 20 4c 69 74 74  >e, Twinkle, Litt<
    000030 6c 65 20 53 74 61 72                             >le Star         <

Using functions we have already defined, the following code might be used to parse this event:

    sub get-cstring($buffer, $offset is rw -> Str) {
      my $length = $buffer[$offset++];
      my $s = '';
      for ^$length {
        $s ~= $buffer[$offset++].chr;
      }
      $s;
    }

    my $delta-time;
    my $offset = 0;
    $delta-time = get-varint($buffer, $offset);
    my $event = $buffer[$offset++];
    given $event {
      when 0xff {
        my $meta-type = $buffer[$offset++];
        given $meta-type {
          when 0x01 {
            my $name = get-cstring($buffer, $offset);
            say '+{$delta-time} Sequence/track name: ' ~ $name;
          }
        }
      }
    }

Other similar meta events are `01` ("text event"), `02` ("copyright notice"), `04` ("instrument name"), and `05` ("lyric"). Not all of these are used in the example file.

#### Other meta-events

Skipping over further text meta-events, we are left with the remainder of the track:

    000060                   00 ff 58 04 02 02 18 08 00 ff  >      ..X.......<
    000070 51 03 09 27 c0 81 90 00 ff 58 04 02 02 18 08 81  >Q..'.....X......<
    000080 90 00 ff 2f 00                                   >.../.           <

The first event here is `00 ff 58 04 02 02 18 08`. Again, the `00` is a delta time of 0 (we are still at the beginning of the track). `ff` is another meta-event, and `58` specifies the meta-event is a time-signature. As with all events, the next byte is a length field (here `04`) and then the four bytes of data (`02 02 18 08`).

The four bytes of data representing the time signature are (1) the numerator of the signature, (2) the base-2 logarithm of the denominator, (3) the number of midi clocks in a metronome click, and (4) the number of notated 32nd notes in what midi thinks of as a quarter note. (This description directly from the midi standard.) We are going to ignore the last two arguments.

In the example the time signature is 2/4; the first argument is 2, and the second is also 2 representing the index in 2².

We can add the following code into the meta-event switch in the above example:

    given $meta-type {
      when 0x03 {
        #...
      }
      when 0x58 {
        my $length = $buffer[$offset++];
        my $numerator = $buffer[$offset];
        my $denominator = 2 ** $buffer[$offset+1];
        $offset += $length;
        say "+{$delta-time} time signature: {$numerator}/{$denominator}";
      }
    }

We use the contents of the length field to advance the offset, rather than just adding four, because an update to the standard might extend the number of arguments. This way will not break under these circumstances.

The next event is `00 ff 51 03 09 27 c0`. Again, this is a delta time of 0, and event type of `ff`, but a meta-event type of `51`. This corresponds to a metap-event specifying the tempo. After the length field, the argument is a single 24-bit integer specifying the length of a quarter-note in microseconds.

We add the following code:

    given $meta-type {
      when 0x03 { ... }
      when 0x58 { ... }
      when 0x51 {
        my $length = $buffer[$offset++];
        my $tempo = get-int24($buffer, $offset);
        $offset += $length;
        say "+{$delta-time} Tempo: {$tempo}μs/♩";
      }
    }

The next event is a familiar one: `81 90 00 ff 58 04 02 02 18 08`. This is a tempo meta-event, exactly the same as the first, except that this time the delta-time is `81 90 00` which is a delta-time of 18,432. If we divide this by the `divisions` value from the midi header (384) we get 48, which is the number of quarter notes until the time this tempo change applies. In this case, the length of each verse. This tempo event arises because the lilypond source specifies a repeat, and the tempo mark is inside the repeat. It could be omitted without having any effect on the output from a midi device. (The delta time of the next event would need to be increased to compensate.)

This leaves only `81 90 00 ff 2f 00` in this track. This is an event with a delta-time of 18432 again, a meta-event (`ff`) a meta-event type of C`2f`, and a length field of 0.

We thus add the code:

    given $meta-type {
      when 0x03 { ... }
      when 0x58 { ... }
      when 0x51 { ... }
      when 0x27 {
        my $length = $buffer[$offset++];
        $offset += $length;
        say "+{$delta-time} end of track";
      }
    }

And we have now handled the entire first track.

On the other hand, we still don't know how to handle those trivial events in a midi stream known as notes. It is not unusual for the first track of a format 1 midi file to have nothing but meta information, and sometimes lyrics. We need to look at the next track for that. Unfortunately we won't learn all that much about Raku and reading binary files, but we will learn a fair bit about midi files.

### A track with note events

Immediately following the first track, is the second! We won't examine every byte—it's too long. However the first few events will suffice. This track starts:

    000080                4d 54 72 6b 00 00 05 7e 00 ff 03  >     MTrk...~...<
    000090 16 70 69 61 6e 6f 72 68 3a 75 6e 69 71 75 65 43  >.pianorh:uniqueC<
    0000a0 6f 6e 74 65 78 74 31 00 ff 59 02 ff 00 00 90 41  >ontext1..Y.....A<
    0000b0 5a 83 00 90 41 00 00 90 41 5a 83 00 90 41 00 00  >Z...A...AZ...A..<
    0000c0 90 41 5a 00 90 48 5a 83 00 90 41 00 00 90 48 00  >.AZ..HZ...A...H.<
    0000d0 00 90 41 5a 00 90 48 5a 83 00 90 41 00 00 90 48  >..AZ..HZ...A...H<
    0000e0 00 00 90 41 5a 00 90 4a 5a 83 00 90 41 00 00 90  >...AZ..JZ...A...<
    0000f0 4a 00 00 90 41 5a 00 90 4a 5a 83 00 90 41 00 00  >J...AZ..JZ...A..<
    000100 90 4a 00 00 90 41 5a 00 90 48 5a 86 00 90 41 00  >.J...AZ..HZ...A.<
    000110 00 90 48 00 00 90 40 5a 00 90 46 5a 83 00 90 40  >..H...@Z..FZ...@<
    000120 00 00 90 46 00 00 90 40 5a 00 90 46 5a 83 00 90  >...F...@Z..FZ...<
    000130 40 00 00 90 46 00 00 90 41 5a 00 90 45 5a 83 00  >@...F...AZ..EZ..<
    000140 90 41 00 00 90 45 00 00 90 41 5a 00 90 45 5a 83  >.A...E...AZ..EZ.<
    000150 00 90 41 00 00 90 45 00 00 90 3e 5a 00 90 43 5a  >..A...E...>Z..CZ<
    000160 83 00 90 3e 00 00 90 43 00 00 90 40 5a 00 90 43  >...>...C...@Z..C<
           ...

We already have code to read in the chunk, noting that this time there is 0x57e (1406) bytes of track data. This is followed by another sequence/track name meta event, and then another meta-event we haven't seen before:

    00 ff 59 02 ff 00

This is a meta-event type `59` — a key signature. There are two arguments; the first is a signed byte (the first signed argument we've seen) and the second a boolean flag. The signed byte represents the number of sharps (flats if negative) in the key signature, and the second argument is true (1) if it is a minor key.

So we need a litle more code:

    given $meta-type {
      when 0x03 { ... }
      when 0x58 { ... }
      when 0x51 { ... }
      when 0x27 { ... }
      when 0x59 {
        my $length = $buffer[$offset++];
        my $sharps = $buffer[$offset];
        $sharps   -= 256 if $sharps +&0x80; # negative if msb set
        my $minor  = $buffer[$offset+1];
        my $key = '';
        if ! $minor { # major key
          $key = <C♭ G♭ D♭ A♭ E♭ B♭ F C G D A E B F♯ C♯>[$sharps+7] ~ ' major';
        } else { # minor key
          $key = <A♭ E♭ B♭ F C G D A E B G♭ D♭ A♭ D>[$sharps+7] ~ ' minor';
        }
        $offset += $length;
        say "+{$delta-time} Key: {$key}";
      }
    }

This leads us to the next event, which is a bit different: `00 90 41 5a`.

Up to this point, every event has had a command byte of `ff`. There are other meta events with values `f0` to `fe`, and then there are commands which have codes `80` to `ef`. Notice that all commands have the most significant bit set. Also, in every case we have looked at so far, and in those we haven't seen yet, the following byte, which is a type of subcommand, has the most significant bit clear.

If the byte following the delta-time has the most significant bit clear, then it is not a new command. When this occurs, the previous command in the range `80` to `ef` is implied. This is known as running status, and allows a long sequence of, for example, note on commands to be specified while saving a byte for each note.

Midi can handle 16 different channels. They might be used, for example, for separate instruments. The commands we haven't seen yet combine the command and a channel number into a single byte. There are seven commands (`8` to `E`) and sixteen channels (`0` to `f`). The first nybble of the command byte is the command, and the second nybble is the channel.

The seven commands are `8`—note off, `9`—note on, `A`—poly key pressure, `B`—control change. `C`—program change, `D`—channel pressure, `E`—pitch bend. Most of them aren't used in the example file.

So, getting back to our latest event, we have a delta-time of 0, and a command byte of `90`, which we now recognise as a note on command on channel 0. A note on command has two arguments; a note number (0-127) and a velocity. Note number 60 is middle-C, and each succesive note is a semi-tone higher than the previous number. The velocity, also in the range 0-127, indicates how hard the key was hit on a piano for example, and will have a direct effect on the loudness of the sound. A velocity of 0 is equivalent to a note off command. (Using a velocity of 0 on a note on command allows a long sequence of note on and note off commands without any command bytes if using running status.)

We can eventually see that our current command (`00 90 41 5a`) has a delta time of 0 (so the note will be played immediately the midi file is started), a note on on channel 0, playing note 0x41 (65—the F above middle-C) with a velocity of 0x5a—probably fairly loud; its certainly more than half way up the volume scale.

Let's try to put that all into code. We need to modify some of our overall structure:

    my $status = 0; # running status
    my $delta-time;
    my $offset = 0;
    $delta-time = get-varint($buffer, $offset);
    my $event = $buffer[$offset++];
    if $event ≥ 0xf0 {
      given $event {
        when 0xff {
          my $meta-type = $buffer[$offset++];
          given $meta-type {
            when 0x01 { ... }
            when 0x03 { ... }
            when 0x05 { ... }
            when 0x51 { ... }
            when 0x58 { ... }
            when 0x59 { ... }
            }
          }
        }
        default { ... }
      }
    } else {
      if $event ≥ 0x80 {
        $status = $event; # new status overrides previous value
        $arg1 = $buffer[$offset++];
      } else {
        $arg1 = $event;
      }
      # now we have a "status" byte and can process the command
      my $command = $status +> 4;    # we probably should cache these
      my $channel = $status +& 0x0f;
      given $command {
        when 0x09 {
          my $note     = $arg1
          my $velocity = $buffer[$offset++];
          say "+{$delta-time} Note on: {$note} with velocity {$velocity}";
        }
        default { ... }
      }
    }

