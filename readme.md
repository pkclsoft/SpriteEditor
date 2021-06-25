# Sprite Editor (for GSInvaders)

This is a legacy project I wrote back in 1989 when I wrote my GS Invaders game.
I wrote GS Invaders game all in assembly from the ground up, writing my own sprite display routines, and so on.  I needed a simpler way to create my sprites, and this project contains the (now compiling and working) code for that editor.
It allows you to draw a sprite of up to 50x50 pixels using the default colour pallete and save them to a text file that can then be incorporated into your assembler source code.
It's very simple, a bit ugly to look at, but it works.
You might think this was a subset of the other sprite editor I've recently added to GitHub but its not.  This one was originally written in TML Pascal.  As part of making it available now, I've ported it to ORCA/Pascal and made sure it all works as it used to.
I still (fortunately) had a binary from 1989 that ran, so I was able to verify the functionality is all still there in the newly build executable.
As with the other sprite editor, it's probably not a lot of use, but it's a start of preserving some of my old code.  I also felt it was important that if I'm making GS Invaders open source, the tools I used to create it should be the same.
## Line Endings
The text and source files in this repository originally used CR line endings, as usual for Apple II text files, but they have been converted to use LF line endings because that is the format expected by Git. If you wish to move them to a real or emulated Apple II and build them there, you will need to convert them back to CR line endings.
If you wish, you can configure Git to perform line ending conversions as files are checked in and out of the Git repository. With this configuration, the files in your local working copy will contain CR line endings suitable for use on an Apple II. To set this up, perform the following steps in your local copy of the Git repository (these should be done when your working copy has no uncommitted changes):
1. Add the following lines at the end of the `.git/config` file:
```
[filter "crtext"]
	clean = LC_CTYPE=C tr \\\\r \\\\n
	smudge = LC_CTYPE=C tr \\\\n \\\\r
```
2. Add the following line to the `.git/info/attributes` file, creating it if necessary:
```
* filter=crtext
```
3. Run the following commands to convert the existing files in your working copy:
```
rm .git/index
git checkout HEAD -- .
```
Alternatively, you can keep the LF line endings in your working copy of the Git repository, but convert them when you copy the files to an Apple II. There are various tools to do this.  One option is `udl`, which is [available][udl] both as a IIGS shell utility and as C code that can be built and used on modern systems.
Another option, if you are using the [GSPlus emulator](https://apple2.gs/plus/) is to host your local repository in a directory that is visible on both your host computer, and the emulator via the excellent [Host FST](https://github.com/ksherlock/host-fst).
[udl]: http://ftp.gno.org/pub/apple2/gs.specific/gno/file.convert/udl.114.shk

## File Types
In addition to converting the line endings, you will also have to set the files to the appropriate file types before building on a IIGS.

So, once you have the files from the repository on your IIGS (or emulator), within the ORCA/M shell, execute the following command on each `build` scripts:

    filetype build src 6
    
## Building
To build the sprite editor, make sure you have the repo present in the same folder on your GS.
You will need the ORCA/M environment present, with ORCA/Pascal installed.
To build it, just execute the "build" script. 

    build
    
## Executing
Just run the generated "spriteeditor" file.  The GS Invaders project has a whole bunch of sample sprites under the "sprites" folder.

![Sprite Editor Screenshot](https://github.com/pkclsoft/SpriteEditor/blob/25586ed4f2c61f86088d91a53379984bdd8fe1bf/screenshot.png)
