# ELOG Administrator's Guide  

*How to set up and run your very own ELOG server*

---

## Installing and running on Linux  


### Installation from the RPM file

Since version 2.0, ELOG contains a RPM file which eases the
installation. Get the file
**`elog-x.x.x-x.i386.rpm`** from the `[download](http://elog.psi.ch/elog/download/RPMS/)` section and execute as root **`"rpm -i elog-x.x.x-x.i386.rpm"`**. This will install the `**elogd**` daemon in **`/usr/local/sbin`** and the **`elog`** and **`elconv`** programs in **`/usr/local/bin`**. The sample configuration file **`elogd.cfg`** together with the sample logbook will be installed under **`/usr/local/elog`** and the documentation goes to **`/usr/share/doc`**. The elogd startup script will be installed at **`/etc/rc.d/init.d/elogd`**. To start the daemon, enter `

- `/etc/rc.d/init.d/elogd start`

It will listen under the port specified in
**`/usr/local/elog/elogd.cfg`** which is 8080 by default. So one can
connect using any browser with the URL:

- `http://localhost:8080`

To start the daemon automatically, enter:

- `chkconfig --add elogd`
  `chkconfig --level 345 elogd on`

which will start the daemon on run levels 3,4 and 5 after the next
reboot.

Note that the RPM installation creates a user and group **`elog`**,
under which the daemon runs.

To start the daemon on non-RedHat systems, like SuSE or Solaris, a more
generic startup scrips has been provided by Steve Jones in the
[Contributions](http://elog.psi.ch/elogs/Contributions/9) section.

### Installation from the tarball

[Download](http://elog.psi.ch/elog/download/) the latest
**`elog-x.x.x.tar.gz`** package.`

Make sure you have the **libssl-dev** package installed. Consult your
distribution for details.

Expand the compressed TAR file with
**`tar -xzvf elog-x.x.x.tar.gz`**. This creates a subdirectory **`elog-x.x.x`** where x.x.x is the version number. In that directory execute **`make`**, which creates the executables **`elogd`**, **`elog`** and **`elconv`**. On some systems like OpenBSD you have to execut **`gmake`**. These executables can then be copied to a convenient place like **`/usr/local/bin`** or **`~/bin`**. Alternatively, a **`"make install"`** will copy the daemon **`elogd`** to **`SDESTDIR`** (by default **`/usr/local/sbin`**) and the other files to **`DESTDIR`** (by default **`/usr/local/bin`**). These directories can be changed in the Makefile. The **`elogd`** executable can be started manually for testing with : `

`elogd -p 8080`

where the **-p** flag specifies the port. Without the **-p** flag, the
server uses the standard WWW port 80. Note that ports below 1024 can
only be used if **`elogd`** is started under root, or the "*sticky
bit*" is set on the executable.

When **`elogd`** is started under root, it attaches to the specified
port and tries to fall-back to a non-root account. This is necessary to
avoid security problems. It looks in the configuration file for the
statements **`Usr`** and **`Grp.`**. If found, **`elogd`** uses that
user and goupe name to run under. The names must of course be present on
the system (usually **`/etc/passwd` and **`/etc/group`). If the
statements **`Usr`** and **`Grp.`** are not present, **`elogd`** tries
user and group **`elog`**, then the default user and group (normally
**`nogroup`** and **`nobody`**). Care has to be taken that **`elogd`**,
when running under the specific user and group account, has read and
write access to the configuration file and logbook directories. Note
that the RPM installation automatically creates a user and group
**`elog`**.

If the program complains with something like "*cannot bind to
port*...", it could be that the network is not started on the Linux
box. This can be checked with the **`/sbin/ifconfig`** program, which
must show that **`eth0`** is up and running.

The distribution contains a sample configuration file **`elogd.cfg`**
and a demo logbook in the *demo* subdirectory. If the **`elogd`** server
is started in the *elogd-x.x.x* directory, the demo logbook can be
directly accessed with a browser by specifying the URL
**http://localhost:8080** (or whatever port you started the elog daemon
on). If the **`elogd`** server is started in some other directory, you
must specify the full path of the **`elogd`** file with the **"-c"**
flag and change the **Data dir =** option in the configuration file to a
full path like **/usr/local/elog**.

Once testing is complete, **`elogd`** will typically be started with the
**`-D`** flag to run as a *daemon* in the background, like this :

`elogd -p 8080 -c /usr/local/elog/elogd.cfg -D`

*Note that it is mandatory to specify the full path for the **`elogd`**
file when started as a daemon.*

To test the daemon, connect to your host via :

`http://your.host:8080/`

If port 80 is used, the port can be omitted in the URL. If several
logbooks are defined on a host, they can be specified in the URL :

`http://your.host/<logbook>`

where `<logbook>` is the name of the logbook.

The contents of the all-important configuration file **`elogd.cfg`** are
described in [Config](config.md).

## Notes for various platforms

This section contains notes for installing and running elog under various operating systems.

### Mac OS X

Under Mac OSX, **ELOG** must be compiled from the source code. The OSX
command line tools (compiler & Co) must be available, which can be done
thought he free Xcode package which can be obtained though the App
Store. Once Xcode is installed, you can do a `xcode-select --install` to
install the command line tools. After that, a simple `make` in in the
elog directory does the job of compiling ELOG. If SSL support is needed
(access via https://\...), you have to install OpenSSL and turn on SSL
support in the Makefile by setting `USE_SSL = 1`. You can install
OpenSSL for example through the [MacPorts](https://www.macports.org)
project. After having installed MacPorts, you do a
`sudo port install openssl`.

After successful compilation, you do a `sudo make install` to install
all required files under the installation directory, which is by default
`/usr/local/`. A subdirectory `/usr/local/elog` is created which
contains a simple example logbook. The ELOG server can now be started
either manually with

`/usr/local/sbin/elogd`

or through the daemon servics with

``` text
sudo launchctl enable system/ch.psi.elogd
sudo launchctl bootstrap system /Library/LaunchDaemons/ch.psi.elogd.plist
```

To stop the service, use

``` text
sudo launchctl bootout system /Library/LauchDaemons/ch.psi.elogd.plist
sudo launchctl disable system/ch.psi.elogd
```

### Debian

A Debian package is available under <https://tracker.debian.org/pkg/elog>.

### Solaris

[Martin Huber](mailto:huber@secaron.de) reports that under Solaris 7 the
following command line is needed to compile elog:

`gcc -L/usr/lib/ -ldl -lresolv -lm -ldl -lnsl -lsocket elogd.c -o elogd`

With some combinations of Solaris servers and client-side browsers there
have also been problems with **ELOG**'s *keep-alive* feature. In such a
case you need to add the "**-k**" flag to the **`elogd`** command line
to turn keep-alives off.

### FreeBSD

[David Otto](mailto:ottodavid@gmx.net) maintains the [ELOG port for
FreeBSD](http://www.freshports.org/www/elog). To install ELOG on a
FreeBSD system, you can simply type

``` text
cd /usr/ports/www/elog
make install clean
```

## Running elogd under Apache  

For cases where **`elogd`** should run under port 80 in parallel to an
Apache server, Apache can be configured to run Elog in a subdirectory of
Apache. Start **`elogd`** normally under port 8080 (or similarly) as
noted above and make sure it's working there. Then put following
redirection into the Apache configuration file:

``` text
Redirect permanent /elog http://your.host.domain/elog/
ProxyPass /elog/ http://your.host.domain:8080/
```

Make sure that the Apache modules mod_proxy.c and mod_alias.c are
activated. Justin Dieters \<enderak@yahoo.com\> reports that
mod_proxy_http.c is also required. The *Redirect* statement is necessary
to automatically append a "/" to a request like
**`http://your.host.domain/elog`**. Apache then works as a proxy and forwards all requests staring with **`/elog`** to the elogd daemon.

**Note**: Do not put `"ProxyRequests On"` into your configuration file.
This option is not necessary and can be misused for spamming and proxy
forwarding of otherwise blocked sites.

Because **`elogd`** uses links to itself (for example in the email
notification and the redirection after a submit), it has to know under
which URL it is running. If you run it under a proxy, you have to add
the line:

`URL = http://your.proxy.host/subdir/`

into elogd.cfg.

## Using apache authentication

It is also possible to login via an apache-auth module.
In elogd.cfg you should use the keyword "Webserver" for
Authentication:

`Authentication = Webserver`

This triggers elogd to use the environment variable "X-Forwarded-User"
as the logged in user.
A simple example of a apache configuration (including the proxy) is :


``` text
# this required to pass on the generated env-variable X-Forwarded-User to the proxy 
ProxyPassInterpolateEnv On

ProxyPass /elog/ http://your.host.domain:8080/

<Location  "/elog">
	Order allow,deny
	Allow from all     
	AuthType Basic
	AuthName "elog-server"
	AuthUserFile "/opt/elog/htpasswd"
	require valid-user
	RequestHeader unset Authorization
	RequestHeader add X-Forwarded-User %{REMOTE_USER}s
	# elog doesn't like the '@', so we need to cut it
	RequestHeader edit X-Forwarded-User "@(.*)$" ""
</Location>
```


## Installing ImageMagick  

When images are attached to ELOG entries, thumbnails can be created for
quick preview. This works also for PDF and PostScript files. ELOG
forwards any image operation to the ImageMagic and GhostScript packages,
which must be installed for this to work. While these packages are
installed on most Linux systems, windows users have to download and
install these pagages manually. ImageMagick can be obtained from
[www.imagemagick.org](http://www.imagemagick.org/) and GhostScript can
be obtained from <http://pages.cs.wisc.edu/~ghost/>. After the
installation, it has to be made sure that both packages are in the path.
This can be checked to open a command prompt and typing
**`identify -version`**. This command should return someting like:

``` text
C:\>identify -version
Version: ImageMagick 6.3.8 01/25/08 Q16 http://www.imagemagick.org
Copyright: Copyright (C) 1999-2008 ImageMagick Studio LLC
```

When ELOG is started interactively, it checks for the ImageMagick
installation and shows a note if it is found:

``` text
C:\Program Files\ELOG>elogd
elogd 2.7.2 built Feb 21 2008, 20:00:42 revision 2051
ImageMagick detected
Indexing logbooks ... done
Server listening on port 8080 ...
```

If ImageMagick is not installed, the thumbnail functions are simply
disabled, but ELOG can otherwise run normally.

## Installing and running in Windows  

**ELOG** is distributed in binary (executable) form for Windows
platforms. It will run happily in *console mode* (or "*DOS box*")
under Windows 9x and ME. Under Windows NT and 2000 it is also possible
to run it as a *service* (the Windows equivalent of a UNIX *daemon*).

[Download](http://elog.psi.ch/elog/download/windows) the latest
**`elogxxx.exe`** file and execute it. The installer puts the **ELOG**
system into a directory you specify and adds some menu shortcuts. With
these shortcuts, the daemon `elogd.exe` can be started directly and the
demo logbook can be accessed with the browser. Alternatively, the
`elogd.exe` daemon can be registered as a service under Windows
NT/2000/XP, so it gets started automatically when windows boots. This
can be selected during installation or be done manually with the start
menu shortcuts.

While the pre-2.5.3 methods of installing elogd.exe as a daemon (namely
FireDaemon and srvany.exe) are still possible, they are not recommended
any more.

Under Windows, the ports below 1024 can be used without restriction. So
if no web server is running on the same PC the **ELOG** daemon can be
started under the standard Web port 80. This is achieved by changing the
**`port=8080`** option in `elogd.cfg` to
**`port=80`**` and restarting elogd.`

## Server Configuration  

[The **ELOG** daemon **`elogd`** can be executed with the following
options :]{#config}

``` text
elogd [-p port] [-n hostname/IP] [-C] [-m] [-M] [-D] [-c file] [-s dir] [-d dir] [-v] [-k] [-f file] [-x]

with :

`-p <port>`  TCP port number to use for the http server (if other than 80)
`-n <hostname or IP address>` in the case of a "multihomed" server, host name or IP address of the interface ELOG should run on
`-C <url>`  clone remote elogd configuration 
`-m`  synchronize logbook(s) with remote server
`-M`  synchronize with removing deleted entries
`-l <logbook>`  optionally specify logbook for -m and -M commands
`-D`   become a daemon (Unix only)
`-c <file>`  specify the configuration file (full path mandatory if -D is used)
`-s <dir>` specify resource directory (themes, icons, \...)
`-d <dir>` specify logbook root directory
`-v  ` verbose output for debugging
`-k  ` do not use TCP keep-alive
`-f <file>` specify PID file where elogd process ID is written when server is started
`-x  `enables execution of shell commands
```

The appearance, functionality and behaviour of the various logbooks on
an **ELOG** server are determined by the single **`elogd.cfg`** file in
the **ELOG** installation directory.

This file may be edited directly from the file system, or from a form in
the **ELOG** Web interface (when the *Config* menu item is available).
In this case, changes are applied dynamically without having to restart
the server. Instead of restarting the server, under Unix one can send a
HUP signal like **`"killall -HUP elogd"`** to tell the server to re-read
its configuration.

The many options of this unique but very important file are documented
on the separate **[elogd.cfg syntax page](config.md)**.

To better control appearance and layout of the logbooks, **`elogd.cfg`**
may optionally specify the use of additional files containing HTML code,
and/or custom "*themes*" configurations. These need to be edited
directly from the file system right now.

The meaning of the directory flags **`-s` and **`-d` is explained in the
section covering the configuration options **`Resource dir` and
**` Logbook dir` in the **[elogd.cfg
description](config.md)**.********

## Secure Connections HOWTO  

### Using elogd itself

Starting from version 2.7.3 on, the **`elogd`** program supports secure
connections over the Secure Socker Layer (SSL) directly. **It is
recommented to run elog only through secure HTTPS connections if
passwords are used. Otherwise the passwords are send over the network in
clear text and exposed to sniffing attacks**. To use SSL, put
**`SSL = 1`** into the config file. If the **`URL =`** directive is
used, make sure to use
**`https://...`** instead of **`http://...`** there. The ELOG distribution contains a simple self-signed certificate in the `**ssl**` subdirectory. One can replace this certificate and key with a real ceritficate to avoid browser pop-up windows warning about the self-signed certificate. `

### Using Apache

Another possibility is to use the [Apache](http://httpd.apache.org) web
server as a proxy server allowing secure connections. To do so, Apache
has to be configured accordingly and a certificate has to be generated.
See some [instructions](http://slacksite.com/apache/certificate.html) on
how to create a certificate, and see *Running elogd under Apache* before
on this page on how to run elogd under Apache. Once configured
correctly, elogd can be accessed via *http://your.host* and via
*https://your.host* simultaneously.

The redirection statement has to be changed to

``` text
Redirect permanent /elog https://your.host.domain/elog/
ProxyPass /elog/ http://your.host.domain:8080/
```

and following has to be added to the section *"VirtualHOst \...:443* in
/etc/httpd/conf.d/ssl.conf:

``` text
# Proxy setup for Elog
<Proxy *>
Order deny,allow
Allow from all
</Proxy>
ProxyPass /elog/ http://host.where.elogd.is.running:8080/
ProxyPassReverse /elog/ http://host.where.elogd.is.running:8080/
```

Then, following URL statement has to be written to elogd.cfg:

`URL = https://your.host.domain/elog`

There is a more detailed step-by-step instructions at the [contributions
section](http://elog.psi.ch/elogs/contributions/11).

### Using ssh

**`elogd`** can be accessed through a a SSH tunnel. To do so, open an
SSH tunnel like:

`ssh -L 1234:your.server.name:8080 your.server.name`

This opens a secure tunnel from your local host, port 1234, to the
server host where the **`elogd`** daemon is running on port 8080. Now
you can access **`http://localhost:1234`** from your browser and reach
**`elogd`** in a secure way.

## How It All Works  

For the technically curious:

The concept of **ELOG** is very simple. The logbook functionality is
implemented by a single daemon program, **`elogd`**, which is written in
C. It contains an integrated Web server, which does not serve files like
standard Web servers, but reads logbook entries from its database and
formats them into HTML. Since only forms and tables are used, no Java or
Javascript is necessary, which makes the logbook display very fast. The
system does not use any images on purpose to reduce the amount of data
to be transferred. Since the **ELOG** daemon contains its own *http*
server, no additional server like Apache is required.

The "*database*" in which **ELOG** saves its entries is in plain ASCII
format. One file is created for each day in the form **`YYMMDDa.log`**
(where YY is the year, MM the month and DD the day). For ELOG versions
1.x.x, the format was **`YYMMDD.log`**. Messages are separated
internally by the string **`$@MID@$`**. If this string is entered in a
message (main body text or attribute), it gets converted automatically
in order not to invalidate the database structure.

If attachments are submitted, they are saved as separate files named
**`YYMMDD_HHMMSS_name`** - where in addition to the date the time is
specified and **`name`** is the original file name of the attachment. To
copy the database to another computer, only the \*.log files and the
attachment files need to be copied. To copy for example all files from
March 2001, just select them with **`0103??a.log`** and **`0103??_*`**.
