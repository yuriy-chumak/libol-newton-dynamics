Otus Lisp newton-dynamics (a realistic, cross-platform physics simulation) library support
==========================================================================================

Please check the original [newton-dynamics code](https://github.com/MADEAPPS/newton-dynamics).


LICENSE
-------

[MIT License](LICENSE).


BUILD
=====

BUILD REQUIREMENTS
------------------

You should have GCC 3.2+ (with gcc-multilib) or CLANG 3.5+ installed.
Windows support requires MinGW installed (with GCC).
MacOS users should have xcode-tools installed.


Manual Way
----------

```bash
make; make install
```
* use *gmake* for unix clients


Using Package Manager
---------------------

If you have not installed KISS package manager with ol-pckages repository do the next steps:
  * Download and install (copy to the /usr/bin folder) [KISS](https://raw.githubusercontent.com/kisslinux/kiss/master/kiss) executable file.
  * Clone repository (git clone https://github.com/yuriy-chumak/ol-packages $USER/.kiss/ol-packages).
  * Add ol-packages directory to the global KISS_PATH variable (export KISS_PATH=$USER/.kiss/ol-packages).

Install newton-dynamics package with two steps
  * `kiss b libol-ann`
  * `kiss i libol-ann`
