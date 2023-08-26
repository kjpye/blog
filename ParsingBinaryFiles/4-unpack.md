Parsing Binary Files
====================

Part IV—Using unpack to read the data
-------------------------------------

The standard Perl method of interpreting data as higher level objects is the use of `unpack`. Raku can potentially use `unpack` as well, although there are a couple of differences and niggles.

There is a built-in [unpack](https://docs.raku.org/routine/unpack) in Raku, although this is still experimental, and requires the use of

    use experimental :pack;

before you can use it. As this implies, this usage is experimental and is subject to change or dropping in future versions of Raku. This currently handles some of the features of the Perl version, but is by no means complete.

There is also a module [P5pack](https://raku.land/zef:lizmat/P5pack) which is a Raku module designed to mimic the Perl `pack` and `unpack` functions. It is not complete either, but does implement a few more features than the built-in `pack` and `unpack`.

### Using the built-in `unpack`

We can parse the Midi header, assuming we have already read it in to a variable `$bytes`, with

    use experimental :pack;
    ($type, $length, $format, $ntrks, $division) = $bytes.unpack("A4Nnnn");

which is less verbose than having to read each byte individually and then reassemble them in the format we need.

Note that in general you will need to use `subbuf` to extract the part of the data that you need to convert. There is no easy way to skip over an arbitrary part at the beginning of the buffer.

Unfortunately you will still need to handle some data structures byte-by-byte where there is no corresponding unpack template letter to perform the conversion. This will be needed for example by the variable-length integers used for delta-time, and for the 24-bit integers in Midi files.

### Using the `P5pack` module

The same code as above will work with the `P5pack` module:

    use P5pack;
    ($type, $length, $format, $ntrks, $division) = $bytes.unpack("A4Nnnn");

One advantage of the `P5pack` module is that it also implements the 'w' template letter, which unpacks BER-compressed integers, which just happen to be the same as the variable-length values used for delta-time.

You will still need to handle 24-bit integers manually.

