\version "2.25.0"

% Twinkle, Twinkle, Little Star, a traditional children's song.

% This version is from "The Child's Own Music Book",
% edited by Albert Ernest Wier:
% https://en.wikisource.org/wiki/The_Child%27s_Own_Music_Book/Twinkle,_Twinkle,_Little_Star

\header {
  title = "Twinkle, Twinkle, Little Star"
  subtitle = \markup {from \italic "The Child's Own Music Book"}
  composer = "Trad. French"
  arranger = "Arr. Albert Ernest Wier"
  poet = "Jane & Ann Taylor"
}

global = {
  \key f \major
  \time 2/4
  \tempo Allegretto 4=100
}

rh = \relative {
  \global
  f'4 f | <f c'> q | <f d'> q | <f c'>2 | <e bes'>4 q | <f a> q | <d g> <e g> | f2 | \break
  <f c'>4 q | <e bes'> q | <c a'> q | <c g'>2 | <f c'>4 q | <e bes'> q | <c a'> q | <c g'>2 | \break
  f4 f | <f c'> q | <f d'> q | <f c'>2 | <e bes'>4 q | <f a> q <d g> <e g> <a, c f>2 |
}

lh = \relative {
  <f a>4 q | a a | bes bes | a2 | g4 c, | f d | bes c | <f a>2 |
  a4 a | g g | f f | e2 | a4 a | g g | f f | e(c) |
  <f a>4 q | a a | bes bes | a2 | g4 c, | f d | bes c | f,2 |
}

verseOne = \lyricmode {
  Twin -- kle, twin -- kle, lit -- tle star;
  How I won -- der what you are,
  Up a -- bove the world so high,
  Like a dia -- mond in the sky!
}

verseTwo = \lyricmode {
  When the blaz -- ing sun is gone,
  When he no -- thing shines up -- on,
  Then you show your lit -- tle light,
  Twin -- kle, twin -- kle, all the night.
}

chorus = \lyricmode {
  Twin -- kle, twin -- kle, lit -- tle star;
  How I won -- der what you are,
}

wordsMidi = \lyricmode {
  "Twin" "kle, " twin "kle, " lit "tle " "star; "
  "\nHow " "I " won "der " "what " "you " "are, "
  "\nUp " a "bove " "the " "world " "so " "high, "
  "\nLike " "a " dia "mond " "in " "the " "sky! "
  "\nTwin" "kle, " twin "kle, " lit "tle " "star; "
  "\nHow " "I " won "der " "what " "you " "are,\n"

  "\nWhen " "the " blaz "ing " "sun " "is " "gone, "
  "\nWhen " "he " no "thing " "shines " up "on, "
  "\nThen " "you " "show " "your " lit "tle " "light, "
  "\nTwin" "kle, " twin "kle, " "all " "the " "night. "
  "\nTwin" "kle, " twin "kle, " lit "tle " "star; "
  "\nHow " "I " won "der " "what " "you " "are, "
}

dynamics = {
  \override DynamicTextSpanner.style = #'none
  s2\mf | s2\< | s | s\! | s4 s\> | s2 | s | s\! |
  s2 | s | s | s | s | s | s | s\> |
  s2\mf | s4 s\cresc | s2 | s | s | s\dim | s | s4. s8\omit\mf |
}

\score {
  \new PianoStaff <<
    \new Staff = pianorh <<
      \new Dynamics \with {alignAboveContext = pianorh} \dynamics
      \new Voice \rh
%      \new NullVoice = \rh
      \addlyrics { \verseOne \chorus }
      \addlyrics \verseTwo
    >>
    \new Staff = pianolh <<
      \clef bass
      \new Voice \lh
    >>
  >>
  \layout {}
}

\score {
  \new PianoStaff <<
    \new Staff = pianorh {
      \new Voice { \rh \rh }
      \addlyrics \wordsMidi
    }
    \new Staff = pianolh {
      \new Voice { \lh \lh }
    }
  >>
  \midi {
    \context {
      \Staff
      \consists "Dynamic_performer"
    }
    \context {
      \Voice
      \remove "Dynamic_performer"
    }
  }
}


