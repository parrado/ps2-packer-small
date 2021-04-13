# ps2-packer-small 

This modded packer doesn't create a packed ELF. Instead, it creates a raw binary file with lzma packed section only. This way, it can be embedded into any ELF (including lzma stub) with arbitrary load adddress. 

Based on Nicolas "Pixel" Noble work.


# Modules

Compilation will generate ps2-packer-lite, so only lzma module is supported.



# Source code and legal stuff

  This code is covered by GPL. 


# How it works
```
  Usage: ps2-packer [-v]  <in_elf> <out_binary>
  
  Options description:
    -v             verbose mode.
    
```




# Examples

Packing of wLE. 

```
./ps2-packer-lite -v BOOT-UNC.ELF payload.bin 
PS2-Packer v1.1.0 (C) 2004-2005 Nicolas "Pixel" Noble
This is free software with ABSOLUTELY NO WARRANTY.

Compressing BOOT-UNC.ELF...
Packing.
ELF PC = 002000D8
Removing 5 zeroes to section...
Loaded section: 001256E0 bytes (with 00192EA5 zeroes) based at 00200000
Section packed, from 1201883 to 363113 bytes, ratio = 69.79%
Removing 4 zeroes to section...
Loaded section: 00000004 bytes (with 00000004 zeroes) based at 004B8580
Section packed, from 0 to 15 bytes, ratio =  -inf%
All data written.
Done!
File compressed, from 1218204 to 363172 bytes, ratio = 70.19%

```


# How to compile

Current compilation options requires `libz.a` and `libucl.a` to reside at
`/usr/lib/libz.a` and `/usr/lib/libucl.a` (I do that only to statically link
the `zlib` and `ucl` with the final software, so it will run everywhere) So, if it
doesn't match your system, change that line into the `Makefile`. Afterward, a
simple `make` should do the trick in order to compile everything, provided you
have the `full ps2 toolchain`, with the `PS2SDK` variable pointing to your `ps2sdk`
directory, and `ee-gcc` under your path.

Don't look at the `dist` target in the `Makefile`, it's only for me to build
the various packages.


# Author
  Nicolas "Pixel" Noble <pixel@nobis-crew.org> - http://www.nobis-crew.org and modifications by alexparrado

# Original readme file

https://github.com/ps2dev/ps2-packer/blob/master/README.md

