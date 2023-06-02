#Parsing Binary Files
## 2. Accessing your data
To be able to parse your data you first need to read it in.
The standard file I/O won't work, because it assumes the file
being read is UTF-8 unicode strings, and the string will not
contain the original bytes, which is what you need to parse
the binary data.

Therefore we need a different way of accessing the data.

### read
The standard raku method `read` can be used to read binary data
into a Blob.

For example, given a file name in `$file`:
```
my $fh = $file.IO.open(:bin);
my $data = $file.read(512);
```
will read the first 512 bytes of the file into `$data`, and ordinary Blob 
methods can be used to access the data.

### mmap
On Unix-like systems including Linux, the mmap system call can
be used to map the contents of a file directly into the memory
space of your program. While mmap is not a standard part of
Raku, t can easily be used using the NativeCall interface as
follows (given a file name in `$file`):
```
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
                1,                          # protecion (read-only)
                1,                          # flags (private)
                $inputfh.native-descriptor, # file descriptor
                0                           # offset into file
               );
```
`$data` now contains a CArray of `uint8` bytes which you can access
using normal array notation such as `$data[1234]`.
