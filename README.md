![](logo.png)

## About ##

`gmailjitsu` is a command line utility that checks a Gmail account via it's [atom XML feed](https://mail.google.com/mail/feed/atom) feed and displays unread inbox items (mostly a way to look cool and hackerish while still doing something productive). Anyone who lives by the prompt may also find it useful as a non-obtrusive, [GTD](http://en.wikipedia.org/wiki/Getting_Things_Done)-compliant way to quickly scan your email inbox.

Here's the tao of gmailjitsu: you can pass in a search term directly after calling the script and it will display only the unread inbox items with subject or from fields that match your search.



### Why? ###

First and foremost it's a productivity hack - you can check for a specific email without getting distracted by any other nonsense in your inbox or browser, witout leaving the terminal. Second, doing things from the command line looks cool.


## Installation ##

1. Download it
2. Put the `gmailjitsu` executable somewhere in your [`$PATH`](http://en.wikipedia.org/wiki/PATH_(variable)) and `chomod +x` it
3. Open a shell and type `gmailjitsu ?`. Read...


## Customisation ##

Some cool ways to customise `gmailjitsu` may or may not include:
* [`alias` it](https://wiki.archlinux.org/index.php/bash#Aliases) - maybe something like 'gj', or 'heeeyawh!', or "gMaIlJiTsU". 
* run `gmailjitsu --settings` to save your Google account user name and/or password (if ye dareth).


## TO-DO's ##

**Pressing items:**

* case insensitive `$QUERY`
* check for `~/.jitsurc`
* error message for invalid credentials with try again loop

**Nice to haves:**

* Option to harvest Mac OS keychain for login [http://brettterpstra.com/2013/02/15/gmail-in-the-shell/](http://brettterpstra.com/2013/02/15/gmail-in-the-shell/).
* More `$QUERY` aliases to open various views of gmail.

**Bad-assery:**

* Communicate with the Bash/ZSH prompt somehow. Maybe even an semi-permanent variable that can be set on the fly and cause `gmailjitsu` to report back to the `$PROMPT` if she sees land (or matching emails).
* Parse email through a work detection algorithm and complete any work that needs to be done as a background process, except for fun work.

**Superfluous features:**

* Reformat output to a markdown table.
* Random Zen quote at search step
* Optional `--say` argument to make gmailjitsu verbally inform you of the results.
* Develop a revolutionary new interpreted programming language "jitsu" that does the same things every other language does, but with a new syntax to learn and dependencies to install. File extension could be ".jit".
* Plugin management engine written in Jit.


## Thanks Giving ##

* [tlrobinson](https://github.com/tlrobinson) for the original XML parsing gist.
* [Pixelmator Templates](http://www.pixelmatortemplates.com/pixelmator-tip-7-create-and-share-your-own-customs-shapes/) for the ninja in the logo
