# ScratchLabels

## What's it for

There are two things I wanted that motivated me to write this app:

- **I wanted to print address labels.**  It's September 2020 and I've been writing get-out-the-vote postcards.  One of the campaigns I'm postcarding for allows machine-printed address labels (not all postcard campaigns allow them).
- **I wanted to write some Cocoa code.**  It's been a while since I did any coding, and I want a small, low-stakes project to get my head back into development.

There are existing options that would get the labels printed much, much faster.  I could dig up my MS Word license and use the mail-merge template that has already been created for this campaign.  Or I could figure out how to do mail-merge with Pages -- apparently there's some hackery that can be done with AppleScript.  But I wanted to write some code, and I had a few days before I would receive the addresses I needed to print, so here we are.


## How to use

- Open the PDF file sent by the Georgia Postcard Project.  It should contain a single table containing mailing addresses.
- Do a Select All, then a Copy.  If the file contains anything else but the table, select only the table contents.
- Launch this app.
- Do a Paste in the text area on the left.  You should immediately get a preview of what the labels will look like with the addresses printed on them.
- Hit Print (or do ⌘P) to print.  It is expected that you're using Avery 5260 address labels.

