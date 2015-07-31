
\version "2.18.2"
% automatically converted by musicxml2ly from helloworld.xml

\header {
    }

\layout {
    \context { \Score
        autoBeaming = ##f
        }
    }
PartPOneVoiceNone =  \relative c' {
    \clef "treble" \key c \major \numericTimeSignature\time 4/4 c1 }


% The score definition
\score {
    <<
        \new Staff <<
            \set Staff.instrumentName = "Music"
            \context Staff << 
                \context Voice = "PartPOneVoiceNone" { \PartPOneVoiceNone }
                >>
            >>
        
        >>
    \layout {}
    % To create MIDI output, uncomment the following line:
    %  \midi {}
    }

