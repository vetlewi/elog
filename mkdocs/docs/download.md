# ELOG download page  

---

ELOG is distributed both as source code and as precompiled binaries for
various platforms. In addition to major versions, minor releases are
made containing bug fixes or some new and not yet completely debugged
code. This is usually the case if some user asks for some new features,
which are then implemented and sent to the user for testing. The minor
releases are named **`x.y.z-r`** where **`r`** is the release number. A
[web access](https://bitbucket.org/ritt/elog) to the source code
contains the complete development history of ELOG, plus the newest fixes
and features which might yet be in a release. To check out the GIT
repository, use:

`git clone https://bitbucket.org/ritt/elog --recursive`

No tags are used, so it is recommended to always use the newest release
from the \"master\" branch.

Building elogd requires the CMake system and is done in the traditional
way:

``` text
$ cd elog
$ mkdir build
$ cd build
$ cmake ..
$ make
```

This will put the executables **`elogd`** and **`elog`** into the build
directory, from where they can be moved to a system directory like
**`/usr/local/sbin/elogd`**

News for each version can be seen in the
[changelog](http://elog.psi.ch/elog/download/ChangeLog)

## Windows Binaries

The windows binaries are distributed with an automatic
[installer](http://elog.psi.ch/elog/download/windows/elog-latest.exe).
Execute the installer to install ELOG and to register the elogd server
as a windows service. Previous windows versions can be found
[here](http://elog.psi.ch/elog/download/windows/).

Note that the windows binaries are very much outdated and will be
updated once the develop gets access again to a Windows PC.
