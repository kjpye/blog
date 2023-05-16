#Parsing Binary Files
## 2. Accessing your data
To be able to parse your data you first need to read it in.
The standard file I/O won't work, because it assumes the file
being read is UTF-8 unicode strings, and the string will not
contain the original bytes, which is what you need to parse
the binary data.

Therefore we need a different way of accessing the data.

### sysread

### mmap
On Unix-like systems including Linux, the mmap system call can be used to map the contents of a file directly into the memory space of your program. While mmap is not a standard part of Raku, t can easily be used using the NativeCall interface as follows:
```
use NativeCall;

sub mmap() is native();
```
