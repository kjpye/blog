Parsing Binary Files
====================

Part I—Introduction
-------------------

This is the start of a series of articles about how to parse the contents of a binary file into a Raku data structure.

The following parts have been written:

The following parts are available in draft form:

1. [Introduction](https://github.com/kjpye/blog/blob/main/ParsingBinaryFiles/1-intro.md)

2. [Accessing your data](https://github.com/kjpye/blog/blob/main/ParsingBinaryFiles/2-access.md)

3. [Manually reading the bytes](https://github.com/kjpye/blog/blob/main/ParsingBinaryFiles/3-manual.md)

7. [Regular expressions](https://github.com/kjpye/blog/blob/main/ParsingBinaryFiles/7-regex.md)

The following parts are yet to be written:

4. [Unpacking your data (using unpack)](https://github.com/kjpye/blog/blob/main/ParsingBinaryFiles/4-unpack.md)

5. [Reading data from Blobs](https://github.com/kjpye/blog/blob/main/ParsingBinaryFiles/5-blob.md)

6. [Binary::Structured](https://github.com/kjpye/blog/blob/main/ParsingBinaryFiles/6-structure.md)

8. [Reading data from CArrays](https://github.com/kjpye/blog/blob/main/ParsingBinaryFiles/8-carray.md)

9. [Binary regular expressions](https://github.com/kjpye/blog/blob/main/ParsingBinaryFiles/9-binregex.md)

Note that the last two sections cannot be completed until Raku has the necessary facilities.

### Binary file types

Binary files tend to fall into a couple of different categories, and the techniques used to read them can depend on the type.

#### Linear stream

Some binary files, like the MIDI file we are using as an example, are streams of data. You start reading from the beginning, and read through to the end. In fact they must be read in that way, because they often contain no other way of finding the sections within the file. In the MIDI file you can step forward through the chunks by reading the chunk header, and then skipping over the data for that chunk.

Files of this type are sometimes optimised for space, and numbers often appear in a compressed form. The MIDI format for example contains 16, 24 and 32 bit integers, as well as a variable length integer format which uses a single byte for integers less than 128, and up to four bytes for integers up to 2²⁹.

#### Structures and pointers

Some binary files contain data structures which look ver y much like in-memory structures including pointers to other structures and so on. (Early versions of Microsoft Word looked like this.) Reading files like this can involve jumping around a lot within the file, and in this case accessing the file using `mmap` (see Part II) might be simplest and quickest.

#### Block structured

Some file structures, often database storage formats (including the JET database formats used by Microsoft access) are split into blocks, perhaps 4kBytes or something similar. There will typically be a specific block, often the first, containing general database information and block numbers for other information. There might be a block for each database table which contains block numbers for the blocks containing the rows. Each row must be contained within a block, although a block might contain multiple rows. There might also be other block types, such as those containing index information.

### Examples

To give concrete examples, a simple MIDI file is used. The actual file is available as [https://github.com/kjpye/blog/ParsingBinaryFiles/thestar.midi](https://github.com/kjpye/blog/ParsingBinaryFiles/thestar.midi). This is a version of *Twinkle, Twinkle Little Star*. It was generated using [Lilypond](https://lilypond.org). The lilypond source (as well as a generated pdf score) is available from the same place as the midi file.

The format of a midi file is defined by the MIDI Association, and is available from [midi.org](https://www.midi.org/specifications/file-format-specifications/standard-midi-files), although you will need a free account to download the file.

A standard midi file consists of a number of `chunks`, each of which consists of a 4-byte chunk type, a 4-byte chunk length, followed by a number of bytes given by the length. The supplied midi file begins with the following chunk:

    000000 4d 54 68 64 00 00 00 06 00 01 00 04 01 80        >MThd..........<

Note that

1. The chunk type is 4 ASCII characters, here 'MThd'.

2. The length (like all such fields in a midi file) is in big-endian order, here indicating that there are 6 bytes of following information.

3. The length given in the length field does not include the chunk type and header length information. Thus the length is given as 6, whereas the header is actually 14 bytes long.

A MIDI track is stored in a chunk, with each event in the track (often a not-on or note-off event, but there are other types) preceded by a variable-length integer indicating the delta time since the previous event.

Luis Uceta has recently [blogged](https://dev.to/uzluisf/dbase-parsing-a-binary-file-format-with-raku-2fm6) about using Raku to parse a dBase III file. Like a MIDI file, this is a streaming type file format.

