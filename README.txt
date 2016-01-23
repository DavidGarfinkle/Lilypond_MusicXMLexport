LILYPOND->MUSICXML GSOC 2015 PROJECT
Written by David Garfinkle

HOWTO:
Run lilypond scheme-sandbox
Load lily-env.scm from gsoc/ directory
Call (music->xml mus) from gsoc/ directory on a music expression mus
Currently limited to single-voice SequentialMusic contexts of notes, chords, articulations (not all are supported, such as early-music or instrument-specific examples), key signatures, time signatures, and clefs

INCLUDED EXAMPLES:
samples/lilysamples.scm has lazy examples of music expressions. 
3 good examples are "hw" , "chords" , "articulations" ; here is how to run them:

lilypond scheme-sandbox
(load "lily-env.scm")
(define hello-world (force hw))
(music->xml hello-world)
Result will be stored in musicxml.xml


WHAT'S GOING ON UNDER THE HOOD
1. (run-translator) 			; lily/lily-time.scm ; pre-procecesses music expression mus, inserting measure information as a guile object 
2. (music->sxml)					; lily/make-sxml.scm ; transforms music expression mus into its SXML equivalent. It's modelled after music->make-music in lily function \displayMusic
3. The output from (music->sxml) is written to sxml-transfer.scm so it can be transfered into a guile2.0 script
4. (lily-sxml->music-sxml)  ; guile2.0/sxml_conversion/sxml-conversion.scm ; takes the lily-sxml written in sxml-transfer.scm and translates it to a music-SXML representation
5. (sxml->xml)						; uses (sxml simple) guile module to convert the music-SXML to an XML equivalent


TODO LIST

guile2.0/sxml_conversion/data-types.scm: 
--the way measures are stored is a huge mess. i should make it explicit tree structures or a-lists
--insert measures according to increasing order, so as to keep the list of measures sorted

guile2.0/sxml_conversion/sxml-conversion.scm: lily-sxml->music-sxml
--edit the matching functions so that they match list permutations (not sure if this is possible) or at least find an alternative to listing each list permutation as a new match. ex: [(list (val ,val) (symbol ,symbol)) (action-expression)] but also requires [(list (symbol ,symbol) (val ,val)) (action-expression)] since the music expressions aren't consistent one way or another

lily/make-sxml.scm: (make-sxml.scm)
--Remove the unncessary list containers, then edit sxml-conversion.scm so it doesn't have to match lists of lists 
--format the output so it's indented and looks pretty for better testing

lily/lily-time.scm: (run-translator)
Include moment information so that we can process SimultaneousMusic. The problem is trying to read the moment information back into Guile2.0... #<Mom 0> throws an error?!

lily-env.scm: (music->xml))
--Provide a switch to choose output file-name, or to define a new object with the xml rather than output
--delete sxml_transfer.scm when you're done with it?
--somehow pass the scheme object from the lily script to the guile2.0 script without having to write a new file?

guile2.0/sxml-to-xml.guile
--remove the backslash in \" , and remove \n and \t when printing the XML header, also remove the wrapping quotes in the XML header. 
