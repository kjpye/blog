Parsing Binary Files
====================

Part I— Introduction
--------------------

This is the start of a series of articles about how to parse the contents of a binary file into a Raku data structure.

The following parts have been written:

The following parts are available in draft form:

1. Introduction

2. Accessing your data

The following parts are yet to be written:

3. Manually reading the bytes

4. Unpacking your data (using unpack)

5. Reading data from Blobs

6. Binary::Structured

7. Reading data from CArrays

8. Binary regular expressions

Note that the last two sections cannot be completed until Raku has the necessary facilities.

### Examples

To give concrete examples, a simple MIDI file is used. The actual file is aailable as [https://github.com/kjpye/blog/ParsingBinaryFiles/thestar.midi](https://github.com/kjpye/blog/ParsingBinaryFiles/thestar.midi). This is a version of *Twinkle, Twinkle Little Star*. It was generated using [Lilypond](https://lilypond.org). The lilypond source (as well as a generated pdf score) is available from the same place as the midi file.

The format of a midi file is defined by the MIDI Association, and is available from [midi.org](https://www.midi.org/specifications/file-format-specifications/standard-midi-files), although you will need a free account to download the file.

A standard midi file consists of a number of `chunks`, each of which consists of a 4-byte chunk type, a 4-byte chunk length, followed by a number of bytes given by the length. The supplied midi file begins with the following chunk:

    000000 4d 54 68 64 00 00 00 06 00 01 00 04 01 80        >MThd..........<

Note that

1. The chunk type is 4 ASCII characters, here 'MThd'.

2. The length (like all such fields in a midi file) is in big-endian order, here indicating that there are 6 bytes of following information.

3. The length given in the length field does not include the chunk type and header length information. Thus the length is given as 6, whereas the header is actually 14 bytes long.

