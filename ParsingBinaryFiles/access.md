Parsing Binary Files
====================

Part II—Accessing your data
---------------------------

To be able to parse your data you first need to read it in. The standard file I/O won't work, because it assumes the file being read is UTF-8 unicode strings, and the string will not contain the original bytes, which is what you need to parse the binary data.

Therefore we need a different way of accessing the data.

### read

The standard raku method `read` can be used to read binary data into a Blob.

For example, given a file name in `$file`:

    my $fh = $file.IO.open(:bin);
    my $data = $file.read(512);

will read the first 512 bytes of the file into `$data`, and ordinary `Blob` methods can be used to access the data.

This is particularly useful when the file can be read sequentially, such as the MIDI example being used here. Some binary file formats howeer require random access to the file. You will then need to intersperse the `read` calls with calls to `seek`. It also needs advance knowledge of the size of structures. Alternatively you will need to add an extra layer to read blocks, and then split them into the desired structures. You will often get away with reading a few bytes containing length information and then readi9ng the rest of the structure.

### mmap

On Unix-like systems including Linux, the `mmap` system call can be used to map the contents of a file directly into the memory space of your program. While `mmap` is not a standard part of Raku, t can easily be used using the NativeCall interface as follows (given a file name in `$file`):

    use NativeCall;

    sub mmap(Pointer $addr,
             int32 $length,
             int32 $prot,
             int32 $flags,
             int32 $fd,
             int32 $offset)
        returns CArray[uint8]
        is native {*}

    my $inputfh = $file.IO.open(:bin) or fail "Could not open $file\n";
    my $file-length = $file.IO.s;

    my $data = mmap(Pointer,                    # null pointer
                    $file-length,               # file length
                    1,                          # protection (read-only)
                    1,                          # flags (private)
                    $inputfh.native-descriptor, # file descriptor
                    0                           # offset into file
                   );

`$data` now contains a `CArray` of `uint8` bytes which you can access using normal array notation such as `$data[1234]`.

Using `mmap` has the advantage that you can access the data randomly without using any special logic. The work is all pushed out to the operating system.

The main disadvantage is that `CArray`s are very basic objects. None of the useful `Raku` methods are going to work on them. It will thus be necessary to read the data byte by byte, and combine those bytes into useful structures.

The [NativeHelpers::Array](https://raku.land/zef:jonathanstowe/NativeHelpers::Array) module may be of help in converting parts of the `CArray` into `Blob`s, for which many more useful methods are available. Unfortunately the current version of this module will only convert the beginning of a `CArray` into a Buf, and so is less useful than otherwise might be the case,

It might be easier to write your own simple routine to convert parts of a `CArray` to a `Buf`. Code like

    sub carray-to-buf(CArray $carray, Int $start, Int $length --> Buf) {
      my $buf = Buf.new;
      $buf.push: $carray[$start + $_] for ^$length;
      $buf;
    }

should do the job.

