# ScratchLabels

## What's this for?

This app prints address labels.  It takes a list of addresses as input and prints one address per label.  This app is for my personal use and has flaws I personally don't mind.

There are two things I wanted that motivated me to write this app:

- **I wanted to print address labels.**  It's September 2020 and I've been writing get-out-the-vote postcards.  One of the  groups I'm writing for, the [Georgia Postcard Project](https://www.gapostcard.org/) allows machine-printed address labels.
- **I wanted to write some Cocoa code.**  It's been a while since I did any coding, and I wanted a small, low-stakes project to get my head back into development.

There are existing options that would have gotten the labels printed much, much faster.  For example, I could dig up my MS Word license and use the mail-merge template that has already been created for this campaign.  Or I could figure out how to do mail-merge with Pages -- apparently there's some hackery that can be done with AppleScript.  But like I said, I wanted to write some code, so here we are.


## How to use the app

- Open the Excel file from the Georgia Postcard Project.  It should contain a single table containing mailing addresses.  This app assumes there are seven columns in this order: VANID, name, street, city, state, ZIP (aka ZIP5), and ZIP add-on (aka ZIP4).
- Do a Select All, then a Copy.  If the file contains anything else but the table, select only the table contents.  It's okay to include the title row in the selection; it will be ignored by the app.
- Go to this app.
- Do a Paste in the text area on the left.  The pane on the right will show a preview of what the labels will look like when they are printed.
	- Rectangles are drawn indicating the edges of the labels.  This lets you do a quick visual check that the addresses look right and that they all fit within the labels.
	- If you edit the text in the text area, the preview automatically updates.  You might want to do this to shorten a long address line, though it's unlikely you'll have to -- I've printed some pretty long names, and they fit comfortably within the label.
- Hit Print (or do ⌘P) to get a standard print panel.
	- It is expected that you're using Avery 5260 address labels.
	- In the print panel's preview pane, the label edges are not drawn.
	- You are not able to change the number of copies; it's assumed you want exactly one copy.  You can select the page range, though, in case you have to redo a particular section of addresses.


