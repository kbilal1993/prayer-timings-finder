# prayer-timings-finder
I didn't like most of the Islamic prayer times apps on Android, so I decided to improvise. I run this in Termux on my Android phone, but it will work in pretty much any terminal.

## Requirements
The code is written in Racket. In Termux, "pkg install racket" should do the trick.

## Configuration
The *options* associative list at the start holds all the configuration required. For more information on methods, look up the API's documentation here: https://aladhan.com/prayer-times-api

## Commentary
This was originally written on a mobile phone, with a touchscreen keyboard! I started writing it out of boredom, and it became a small project that grew over time. Once I got it running I switched to DrRacket on a computer to neaten it up.
Because this was made on a phone, the options are part of the code. This started as a way to not have to juggle multiple files in a terminal with a touchscreen. The final version still does this, because now everything is self-contained. A perfect solution for code written for one person, but not scalable for large projects.
