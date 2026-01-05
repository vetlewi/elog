# ELOG FAQ  

**Frequently Asked Questions about usage and configuration**

Please check also the [ELOG Forum](http://elog.psi.ch/elogs/Forum).

------------------------------------------------------------------------

## How does one configure elog to display the last message by default

One can use the **`Start page`** option for that. The entry:

` Start page = 0?cmd=last `

shows the last message entry by default. To have the described behaviour
for all logbooks, the above statements can be placed in the
**`[global]`** section.

## Are there any plans to implement a MySQL back end?

No. The idea behind **ELOG** is that it is a *simple to use, simple to
install* application. Many people use **ELOG** under Windows, and they
even don't know what MySQL means. Other people like the flat file
database format, because it's simple, easily accessible from other
programs, and it's easy to backup certain days or months of the
database (since the filenames contain the date). Since **ELOG** should
be independent of any other package, some "switchable" backend between
native **ELOG** format and MySQL would be needed, which is lots of work
and not planned right now.

However, there are several contributions from other people who wrote
scripts to put ELOG entries into a MySQL database. One is available at
<http://elog.psi.ch/elogs/Forum/387>.

## Can I run the ELOG daemon from inside Apache or any other Web server?

No. The **ELOG** daemon was designed as a standalone server and it will
stay like that in the future. The reason for that is that **`elogd`**
should not rely on any other software. This is for example important for
many people running **`elogd`** under Windows, and they have no clue how
to install Apache for Windows. The installation and maintenance for
**`elogd`** therefore becomes much simpler. To run **`elogd`** in
parallel to an Apache server on port 80, use Apache as a proxy,
following the instruction on the installation page ("Running elogd
under Apache").

## I can access my logbook without any password, isn't that a security problem?

By default, no password is used in **ELOG**. This can be useful for
public directories etc. that anybody should be able to read. To add
password security, read the documentation under [Access
control](config.md#access-control). The recommended setup is password file
security with guest access.

Note that passwords are transferred over the network in plain text and
therefore not secure. If this is a problem, a
[secure](adminguide.md#secure-connections-howto) network connection should be used.

## I want a bookmark pointing to the last page where an attribute has a certain value

Use the URL:

`http://<your.host>/<logbook>/?cmd=Last&<attribute>=<value>`

This executes the "*Last*" command using a filter with
**`<attribute>=<value>`**. The following command displays the same page,
but also locks the attribute (checks the box next to `<attribute>`) so
that browsing (next, previous, first, last) only shows pages with that
attribute value.

`http://<your.host>/<logbook>/?cmd=Last&<attribute>=<value>&l<attribute>=1`

Note the `"l"` before the second attribute, as in `"*lAuthor=1*"`.

## I want a logbook with public read access (no password), but restricted write access

In an old version of the FAQ it has been stated here that one has to use
two logbooks pointing to the same data directory. From Version 2.0.6 on,
this can be accomplished much easier by the usage of the **"Guest menu
command"**. Use a logbook with user level access (password file), and
add menu lists like in the following example to the configuration file:

``` text
Menu commands = New, Edit, Reply, Find, Last 10, Change password, Logout, Help
Guest menu commands = Find, Last 10, Login, Help
```

If users access the logbook without supplying a user name, they are
treated like "guests" and see the "Guest menu commands", with which
one cannot submit or edit logbook entries. If one hits the "login"
button, a user can login with a user name/password and sees the normal
menu commands, with which one can submit new logbook entries.

An optional self registration is possible by specifying

` Self register = 1 `

in the configuration file. New users can then create their own accounts.

## I have many loogbooks with password files, so if I add a user or want to change a password I have to do this for all logbooks which is painful.

You can have several logbooks point to the same password file. So if you
change a user or password in that file, it becomes automatically
available in all logbooks which use that file.

## How can I configure ELOG such that it displays something else than the message list by default?

There is a simple trick. You use the **"*Start page*"** option in the
**`elogd`** file to redirect the start page to something else. Here are
some examples:

``` text
?npp=5                                  for the last 5 messages
?last=7                                 show last 7 days (week)
?cmd=New                                show the new message entry form
?cmd=Find                               Show the "find" page
?cmd=Search&<attrib>=<value>            for a search with <attrib>=<value>
```

The various URLs can be copied from the browser's address bar when
doint various things there.

## I want to have additional commands specific to my lookbook

New commands can be added for example with the
**`"Bottom text = bottom.html"`** option. To display all messages from
last week and month of with "category = info", one can put following
HTML code in bottom.html:

```
<center>
<a href="?last=7&Category=Info">Info from last week</a> |
<a href="?last=31&Category=Info">Info from last month</a> |
</center>
```

Note that the parameters **`"last=7&Category=Info"`** applies a filter on
the display. You can learn how to make these filters by looking at the
URL in your browser when you submit a find command with certain
options.

## How does one configure elog to disable editing of existing messages? I want a logbook where one can enter messages but not change them afterwards.

This works with the option **`Menu commands`**. By default, the menu
commands **` Back, New, Edit, Delete, Reply, Find, Config, Help`** are
dispalyed and allowed. To avoid editing (and deleting) of existing
messages, one removes the two commands and puts following statement into
**`elogd.cfg`:**

`Menu commands = Back, New, Reply, Find, Config, Help`

This prohibits the execution of the commands "Edit" and "Delete".

## How can I track various revisions of a message using the "edit" command?

There are two ways:

- Add an attribute which keeps the revision dates and names as follows:

``` text
Attributes = Author, ..., Revisions
Locked attributes = Revisions
Subst on Edit Revisions = $Revisions<br>$date by $long_name
```

  The "Revisions" attribute cannot be modified manually (since it's
  locked). On each edit, the date and the current author is appedned to
  the previous revisions. The "\<br\>" puts a line break between the
  entries.

- Create a thread for each entry. In addition of having the date and
  author of different revisions, the message content is kept. To revise
  and entry, one hits "Reply" instead of "Edit" (one can disable the
  "Edit" command for example). If one puts following option into the
  configuration file:


      `Reply string = ""`

  then the reply contains the original message without the usual "\> "
  at the beginning of each line. One can then edit the message and
  submit it. In the threaded message list display, one sees then the
  different revisions as a message thread.

## How can I enter a date which is different from current one?

Usually, the current date/time is recorded when you add a new entry. It
might be, however, that one wants to enter "old" entries, or some
entries with a date in the future (like a to-do list with a due date).
To do that, on can add a new attribute (let's call it *Record date*, to
be different from the pre-defined *Date*:

``` text
Attributes = Author, ..., Record date
Type Record date = date
Preset Record date = $date
Date format = %Y %m %d
List Display = Record date, Author, ...
Start page = ?rsort=Record date
```

The *Preset Record date* statement sets the record date to the current
date, but this can then of course edited during the message entry. The
*List Display* and *Start page* statements show the record date as the
first column in the summary display and also sort by that. Note the
*Date format* showing first year, then month and day. This is necessary
since sorting is done only lexically. Please note that the *List
Display* was renamed recently. Prior to version 2.3.10, it was called
*Display Search*.

## I cannot pass the login page, it's always redisplayed even if I put in the right password?

This can happen if you change the login policy, for example move the
**`Password file =`** entry in the configuration file from a logbook
section to the \[global\] section or back. In that case some old cookies
could be stored in your browser, which confuse the system. Please delete
your cookies in the browser to resolve this problem. Read your browser
documentation on how to do that.

## How can I change an attribute for an entire thread? We have an attribute "open problem/fixed" which should be changed for the whole thread if that problem has been fixed.

This is a typical request of a bug-tracking set-up. Someone enters a
request, opening a new thread. The expert(s) reply to the the request,
and after a while, the request gets satisfied or the problem gets fixed.
If an attribute like "status", having the options "open" and
"fixed" could get changed for the whole thread, on could very easily
search for all "open" problems.

Since this functionality is not implemented, an alternative strategy is
recommended: Implement two (or more) logbooks. The first logbook has
open issues, the second one has fixed ones. When an entry changes state,
it simply has to be copied to the second logbook. This can be done by
defining the menu command "move" in the config file, like:

`Menu commands = Back, New, Edit, Delete, Reply, Find, Move to, Config, Help`

Note the additional ***Move to***. This solution is even more elegant
than having attributes changed in whole threads, since one has two
separate logbooks, and can treat the second one more like an archive,
make separate back-ups, or deleting some entries after some time, while
keeping the open issues untouched.

## Can I use RSS feeds with password protected logbooks?

RSS feeds normally only work for logbooks which have at least public
read access (via the guest menu commands). There is however a way to
allow only restricted read access and still use RSS feeds. This is done
by adding an additional read password via the
**`elogd -r <pwd> -l <logbook>`** command. This password (username may
be any) can then be used in an RSS reader for restricted access. One
reader which has been successfully used with this kind of authentication
is [RSSReader](http://www.rssreader.com).

## How can I make a whole thread open or closed?

Sometime people want to mark a whole thread in a way. An example is a
to-do list, where they want a special icon on high priority things, and
have this icon disappear one the task is finished. This can be easily
done with icons. The configuration could look like this:

``` text
Attributes = Author, Status, Subject
IOptions Status = icon1.gif, icon2.gif, icon4.gif
Preset Status = icon4.gif
Preset on reply status = icon2.gif
Icon comment icon1.gif = Closed entry
Icon comment icon4.gif = Open entry
Thread display = $Author $Subject
Thread icon = Status
```

New entries get an exclamation mark icon for example ("Preset status =
..."). Replies to this entry get a reply icon. Once the thread should
be closed, one simple edits the top entry in that thread and changes the
icon. The icon1.gif from the distribution is maybe not ideally suited
for that, but one could make a green check mark icon for example for
that. The "Thread display" and "Thread icon" make this icon appear
at the left side of the threaded display.

An alternative approach would be to use two logbooks. The first one
receive all new entries ("open items"). Once an entry (with its
replies) gets closed, it must be moved manually to the second logbook
("closed items"). This can be done with the "Move To" command (see
"menu commands" in config file). This way one nicely separates open
and closed items in two separate logbooks. One can still search both
logbooks at the same time if one checks "Search all logbooks" in the
find page.

Starting from elog version 2.7.7, there now even a third way to do this.
With an additional line in the configuration file: Collapse tn last = 1
(in fact the default, but to be explicit), then when the thread is ready
to be marked as closed, select the "closed entry" icon when writing
the last entry. When the entries are viewed in "threaded" mode, then
the closed entry icon appears on the last entry; and when in "threaded,
collapsed" mode, then the closed entry icon appears in the one line
that represents that whole thread.

## Does elog have a spell checker?

No, but you can use any spell checker which works with your browser.
Examples are [IESpell](http://www.iespellc.com) for Internet Explorer
and [SpellBound](http://spellbound.sourceforge.net) for Mozilla-based
browsers.

## Why are entries with large attachments submitted so slowly?

If email notifications are used, the ELOG program has to pass these
attachments to the email server, which might take quite some time. Some
email servers even don't allow to forward attachments if they are
larger than a few mega bytes. In that one can simply turn off the
forwarding of email attachments with

`Email format = 111`

this causes only the attachment names being forwarded, not the
attachments themselves.

## The elgod daemon crashes from time to time, what can I do?

Bugs are constantly fixed inside elogd so a upgrade to the current
version is recommended as a first measrue. If that does not help, the
key will be the reproducibility of the crash. I only can fix problems if
I can reproduce them. Sometimes it's related to strange logbook entries
which cause elogd to crash when they are edited. So if there is a way to
reproducible trigger the problem, I need the files and confiration
related with it. If I can reproduce it in my local installation, I can
fix it pretty soon.

If that is not possible, an alternative is to run elgod under a
debugger, and do a stack trace if the program dies. Under linux, this
can be done using the gdb debugger, which might look like this:

``` text
[~/elog]$ gdb ./elogd
GNU gdb Red Hat Linux (6.5-25.el5rh)
...

(gdb) run
Starting program: /afs/psi.ch/user/r/ritt/elog/elogd
elogd 2.7.5 built Dec  2 2008, 10:47:09 revision 2147
ImageMagick detected
Indexing logbooks ... test

Program received signal SIGSEGV, Segmentation fault.
0x08054beb in el_index_logbooks () at src/elogd.c:3892
3892       *p = (char)1;
(gdb) where
#0  0x08054beb in el_index_logbooks () at src/elogd.c:3892
#1  0x080b8774 in server_loop () at src/elogd.c:27565
#2  0x080bbdd5 in main (argc=1, argv=0xbfee5b54) at src/elogd.c:28923
(gdb)
```

So the basic command is to make a stack trace with "where" after a
segmentation fault. This tells me where in the code something wrong
happened (in this case it was inside the function el_index_logbooks() at
line 3892. Please send me this information and I will try then to figure
out what was wrong.

## How can I create an ELOG entry automatically from a script?

The [User's
Guide](userguide.md#elog-command-line-client) describes the standalone "elog"
utility, which can be used from a script or from another program to
submit an automatic email entry. This works locally or remotely, with
optional attachments. Enter "elog -h" for a full list of options. The
elog utility is part of the distribution and resides in the same
directory as the elogd daemon.

## I want to notify different people for different things, how do I set up this?

Assume you want to send an email notification to person A for a problem
report, to person B for problem fix and so on. The simplest way is to
use the `Email <attribute> <value> = <email address>` syntax. So you
could set-up following configuration:

``` text
Attributes = Author, Type
Options Type = Problem Report, Problem Fix
Email Type Problem Report = person.a@elog.com
Email Type Problem Fix = person.b@elog.com
```

If you want to select email addresses directly from a list, you can do
the set-up as following: Attributes = Author, Notify MOptions Notify =
Person A, Person B Email Notify Person A = person.a@elog.com Email
Notify Person B = person.b@elog.com This way you can for each entry
select one or more people to be notified from the pre-defined list.
