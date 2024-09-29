Hi,

How to generate compile_commands.json for the kernel sources and our kernel=
 code.

  1.  Put all the scripts that are attached into your kernel nvmesh directo=
ry.
  2.  Rename gen_compile_commands.pyy to gen_compile_commands.py and make s=
ure it is executable.
  3.  Compile a kernel source tree that also includes the INBOX driver usin=
g clang in your home directory.
  4.  I have a script called build_lr.sh (for build local/remote).  Th scri=
pt takes either -l for local build or -r for remote build.
  5.  My local machine was n224.
  6.  I always used ./local_lr.sh -l
  7.  Then look at build_sh_conf.local and follow the way I set the kernel =
source directory =96 the one that I compiled with clang.
  8.  Look at the MAKE_OPTS which I provide to the build.sh which allow the=
 nvmesh source code to compile against my local kernel source code.
  9.  Run ./build_lr.sh -l.
  10. At the end of build_lr.sh you will have a single compile_commands.jso=
n that includes all kernel and nvmesh compile instructions.
  11. Good luck

Ofer

