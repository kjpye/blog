#!/usr/bin/env raku

grammar Midi {
    my token byte   { (.) { make $0.encode('latin1')[0]; } }
    my token uint16 { <byte>**2 { make ($<byte>[0].made +< 8) +| ($<byte>[1].made) } }
    my token int16  { <uint16> { $<uint16> +& 0x8000 ?? make $<uint16>.made - 2¹⁵
                                                  !! make $<uint16>.made; } }
    my token uint32 { <uint16> <uint16> { make $<uint16>[0].made +< 16 +| $<uint16>[1].made } }
    my token int32  { <uint32> { $<uint32> +& 0x8000 ?? make $<uint32>.made - 2³²
                                 !! make $<uint32>.made; } }
    my token uint24 { <byte>**3 { make ($<byte>[0].made +< 16) +| ($<byte>[1].made +< 8) +| $<byte>[2].made; } }
    my token byte00 { \x00                                           { make 0x00; } }
    my token byte01 { \x01                                           { make 0x01; } }
    my token byte02 { \x02                                           { make 0x02; } }
    my token byte03 { \x03                                           { make 0x03; } }
    my token byte04 { \x04                                           { make 0x04; } }
    my token byte05 { \x05                                           { make 0x05; } }
    my token byte06 { \x06                                           { make 0x06; } }
    my token byte07 { \x07                                           { make 0x07; } }
    my token byte08 { \x08                                           { make 0x08; } }
    my token byte09 { \x09                                           { make 0x09; } }
    my token byte0A { \x0A                                           { make 0x0A; } }
    my token byte0B { \x0B                                           { make 0x0B; } }
    my token byte0C { \x0C                                           { make 0x0C; } }
    my token byte0D { \x0D                                           { make 0x0D; } }
    my token byte0E { \x0E                                           { make 0x0E; } }
    my token byte0F { \x0F                                           { make 0x0F; } }
    my token byte10 { \x10                                           { make 0x10; } }
    my token byte11 { \x11                                           { make 0x11; } }
    my token byte12 { \x12                                           { make 0x12; } }
    my token byte13 { \x13                                           { make 0x13; } }
    my token byte14 { \x14                                           { make 0x14; } }
    my token byte15 { \x15                                           { make 0x15; } }
    my token byte16 { \x16                                           { make 0x16; } }
    my token byte17 { \x17                                           { make 0x17; } }
    my token byte18 { \x18                                           { make 0x18; } }
    my token byte19 { \x19                                           { make 0x19; } }
    my token byte1A { \x1A                                           { make 0x1A; } }
    my token byte1B { \x1B                                           { make 0x1B; } }
    my token byte1C { \x1C                                           { make 0x1C; } }
    my token byte1D { \x1D                                           { make 0x1D; } }
    my token byte1E { \x1E                                           { make 0x1E; } }
    my token byte1F { \x1F                                           { make 0x1F; } }
    my token byte20 { \c[SPACE]                                      { make 0x20; } }
    my token byte21 { \c[EXCLAMATION MARK]                           { make 0x21; } }
    my token byte22 { \c[QUOTATION MARK]                             { make 0x22; } }
    my token byte23 { \c[NUMBER SIGN]                                { make 0x23; } }
    my token byte24 { \c[DOLLAR SIGN]                                { make 0x24; } }
    my token byte25 { \c[PERCENT SIGN]                               { make 0x25; } }
    my token byte26 { \c[AMPERSAND]                                  { make 0x26; } }
    my token byte27 { \c[APOSTROPHE]                                 { make 0x27; } }
    my token byte28 { \c[LEFT PARENTHESIS]                           { make 0x28; } }
    my token byte29 { \c[RIGHT PARENTHESIS]                          { make 0x29; } }
    my token byte2A { \c[ASTERISK]                                   { make 0x2A; } }
    my token byte2B { \c[PLUS SIGN]                                  { make 0x2B; } }
    my token byte2C { \c[COMMA]                                      { make 0x2C; } }
    my token byte2D { \c[HYPHEN-MINUS]                               { make 0x2D; } }
    my token byte2E { \c[FULL STOP]                                  { make 0x2E; } }
    my token byte2F { \c[SOLIDUS]                                    { make 0x2F; } }
    my token byte30 { \c[DIGIT ZERO]                                 { make 0x30; } }
    my token byte31 { \c[DIGIT ONE]                                  { make 0x31; } }
    my token byte32 { \c[DIGIT TWO]                                  { make 0x32; } }
    my token byte33 { \c[DIGIT THREE]                                { make 0x33; } }
    my token byte34 { \c[DIGIT FOUR]                                 { make 0x34; } }
    my token byte35 { \c[DIGIT FIVE]                                 { make 0x35; } }
    my token byte36 { \c[DIGIT SIX]                                  { make 0x36; } }
    my token byte37 { \c[DIGIT SEVEN]                                { make 0x37; } }
    my token byte38 { \c[DIGIT EIGHT]                                { make 0x38; } }
    my token byte39 { \c[DIGIT NINE]                                 { make 0x39; } }
    my token byte3A { \c[COLON]                                      { make 0x3A; } }
    my token byte3B { \c[SEMICOLON]                                  { make 0x3B; } }
    my token byte3C { \c[LESS-THAN SIGN]                             { make 0x3C; } }
    my token byte3D { \c[EQUALS SIGN]                                { make 0x3D; } }
    my token byte3E { \c[GREATER-THAN SIGN]                          { make 0x3E; } }
    my token byte3F { \c[QUESTION MARK]                              { make 0x3F; } }
    my token byte40 { \c[COMMERCIAL AT]                              { make 0x40; } }
    my token byte41 { \c[LATIN CAPITAL LETTER A]                     { make 0x41; } }
    my token byte42 { \c[LATIN CAPITAL LETTER B]                     { make 0x42; } }
    my token byte43 { \c[LATIN CAPITAL LETTER C]                     { make 0x43; } }
    my token byte44 { \c[LATIN CAPITAL LETTER D]                     { make 0x44; } }
    my token byte45 { \c[LATIN CAPITAL LETTER E]                     { make 0x45; } }
    my token byte46 { \c[LATIN CAPITAL LETTER F]                     { make 0x46; } }
    my token byte47 { \c[LATIN CAPITAL LETTER G]                     { make 0x47; } }
    my token byte48 { \c[LATIN CAPITAL LETTER H]                     { make 0x48; } }
    my token byte49 { \c[LATIN CAPITAL LETTER I]                     { make 0x49; } }
    my token byte4A { \c[LATIN CAPITAL LETTER J]                     { make 0x4A; } }
    my token byte4B { \c[LATIN CAPITAL LETTER K]                     { make 0x4B; } }
    my token byte4C { \c[LATIN CAPITAL LETTER L]                     { make 0x4C; } }
    my token byte4D { \c[LATIN CAPITAL LETTER M]                     { make 0x4D; } }
    my token byte4E { \c[LATIN CAPITAL LETTER N]                     { make 0x4E; } }
    my token byte4F { \c[LATIN CAPITAL LETTER O]                     { make 0x4F; } }
    my token byte50 { \c[LATIN CAPITAL LETTER P]                     { make 0x50; } }
    my token byte51 { \c[LATIN CAPITAL LETTER Q]                     { make 0x51; } }
    my token byte52 { \c[LATIN CAPITAL LETTER R]                     { make 0x52; } }
    my token byte53 { \c[LATIN CAPITAL LETTER S]                     { make 0x53; } }
    my token byte54 { \c[LATIN CAPITAL LETTER T]                     { make 0x54; } }
    my token byte55 { \c[LATIN CAPITAL LETTER U]                     { make 0x55; } }
    my token byte56 { \c[LATIN CAPITAL LETTER V]                     { make 0x56; } }
    my token byte57 { \c[LATIN CAPITAL LETTER W]                     { make 0x57; } }
    my token byte58 { \c[LATIN CAPITAL LETTER X]                     { make 0x58; } }
    my token byte59 { \c[LATIN CAPITAL LETTER Y]                     { make 0x59; } }
    my token byte5A { \c[LATIN CAPITAL LETTER Z]                     { make 0x5A; } }
    my token byte5B { \c[LEFT SQUARE BRACKET]                        { make 0x5B; } }
    my token byte5C { \c[REVERSE SOLIDUS]                            { make 0x5C; } }
    my token byte5D { \c[RIGHT SQUARE BRACKET]                       { make 0x5D; } }
    my token byte5E { \c[CIRCUMFLEX ACCENT]                          { make 0x5E; } }
    my token byte5F { \c[LOW LINE]                                   { make 0x5F; } }
    my token byte60 { \c[GRAVE ACCENT]                               { make 0x60; } }
    my token byte61 { \c[LATIN SMALL LETTER A]                       { make 0x61; } }
    my token byte62 { \c[LATIN SMALL LETTER B]                       { make 0x62; } }
    my token byte63 { \c[LATIN SMALL LETTER C]                       { make 0x63; } }
    my token byte64 { \c[LATIN SMALL LETTER D]                       { make 0x64; } }
    my token byte65 { \c[LATIN SMALL LETTER E]                       { make 0x65; } }
    my token byte66 { \c[LATIN SMALL LETTER F]                       { make 0x66; } }
    my token byte67 { \c[LATIN SMALL LETTER G]                       { make 0x67; } }
    my token byte68 { \c[LATIN SMALL LETTER H]                       { make 0x68; } }
    my token byte69 { \c[LATIN SMALL LETTER I]                       { make 0x69; } }
    my token byte6A { \c[LATIN SMALL LETTER J]                       { make 0x6A; } }
    my token byte6B { \c[LATIN SMALL LETTER K]                       { make 0x6B; } }
    my token byte6C { \c[LATIN SMALL LETTER L]                       { make 0x6C; } }
    my token byte6D { \c[LATIN SMALL LETTER M]                       { make 0x6D; } }
    my token byte6E { \c[LATIN SMALL LETTER N]                       { make 0x6E; } }
    my token byte6F { \c[LATIN SMALL LETTER O]                       { make 0x6F; } }
    my token byte70 { \c[LATIN SMALL LETTER P]                       { make 0x70; } }
    my token byte71 { \c[LATIN SMALL LETTER Q]                       { make 0x71; } }
    my token byte72 { \c[LATIN SMALL LETTER R]                       { make 0x72; } }
    my token byte73 { \c[LATIN SMALL LETTER S]                       { make 0x73; } }
    my token byte74 { \c[LATIN SMALL LETTER T]                       { make 0x74; } }
    my token byte75 { \c[LATIN SMALL LETTER U]                       { make 0x75; } }
    my token byte76 { \c[LATIN SMALL LETTER V]                       { make 0x76; } }
    my token byte77 { \c[LATIN SMALL LETTER W]                       { make 0x77; } }
    my token byte78 { \c[LATIN SMALL LETTER X]                       { make 0x78; } }
    my token byte79 { \c[LATIN SMALL LETTER Y]                       { make 0x79; } }
    my token byte7A { \c[LATIN SMALL LETTER Z]                       { make 0x7A; } }
    my token byte7B { \c[LEFT CURLY BRACKET]                         { make 0x7B; } }
    my token byte7C { \c[VERTICAL LINE]                              { make 0x7C; } }
    my token byte7D { \c[RIGHT CURLY BRACKET]                        { make 0x7D; } }
    my token byte7E { \c[TILDE]                                      { make 0x7E; } }
    my token byte7F { \x7F                                           { make 0x7F; } }
    my token byte80 { \x80                                           { make 0x80; } }
    my token byte81 { \x81                                           { make 0x81; } }
    my token byte82 { \x82                                           { make 0x82; } }
    my token byte83 { \x83                                           { make 0x83; } }
    my token byte84 { \x84                                           { make 0x84; } }
    my token byte85 { \x85                                           { make 0x85; } }
    my token byte86 { \x86                                           { make 0x86; } }
    my token byte87 { \x87                                           { make 0x87; } }
    my token byte88 { \x88                                           { make 0x88; } }
    my token byte89 { \x89                                           { make 0x89; } }
    my token byte8A { \x8A                                           { make 0x8A; } }
    my token byte8B { \x8B                                           { make 0x8B; } }
    my token byte8C { \x8C                                           { make 0x8C; } }
    my token byte8D { \x8D                                           { make 0x8D; } }
    my token byte8E { \x8E                                           { make 0x8E; } }
    my token byte8F { \x8F                                           { make 0x8F; } }
    my token byte90 { \x90                                           { make 0x90; } }
    my token byte91 { \x91                                           { make 0x91; } }
    my token byte92 { \x92                                           { make 0x92; } }
    my token byte93 { \x93                                           { make 0x93; } }
    my token byte94 { \x94                                           { make 0x94; } }
    my token byte95 { \x95                                           { make 0x95; } }
    my token byte96 { \x96                                           { make 0x96; } }
    my token byte97 { \x97                                           { make 0x97; } }
    my token byte98 { \x98                                           { make 0x98; } }
    my token byte99 { \x99                                           { make 0x99; } }
    my token byte9A { \x9A                                           { make 0x9A; } }
    my token byte9B { \x9B                                           { make 0x9B; } }
    my token byte9C { \x9C                                           { make 0x9C; } }
    my token byte9D { \x9D                                           { make 0x9D; } }
    my token byte9E { \x9E                                           { make 0x9E; } }
    my token byte9F { \x9F                                           { make 0x9F; } }
    my token byteA0 { \c[NO-BREAK SPACE]                             { make 0xA0; } }
    my token byteA1 { \c[INVERTED EXCLAMATION MARK]                  { make 0xA1; } }
    my token byteA2 { \c[CENT SIGN]                                  { make 0xA2; } }
    my token byteA3 { \c[POUND SIGN]                                 { make 0xA3; } }
    my token byteA4 { \c[CURRENCY SIGN]                              { make 0xA4; } }
    my token byteA5 { \c[YEN SIGN]                                   { make 0xA5; } }
    my token byteA6 { \c[BROKEN BAR]                                 { make 0xA6; } }
    my token byteA7 { \c[SECTION SIGN]                               { make 0xA7; } }
    my token byteA8 { \c[DIAERESIS]                                  { make 0xA8; } }
    my token byteA9 { \c[COPYRIGHT SIGN]                             { make 0xA9; } }
    my token byteAA { \c[FEMININE ORDINAL INDICATOR]                 { make 0xAA; } }
    my token byteAB { \c[LEFT-POINTING DOUBLE ANGLE QUOTATION MARK]  { make 0xAB; } }
    my token byteAC { \c[NOT SIGN]                                   { make 0xAC; } }
    my token byteAD { \c[SOFT HYPHEN]                                { make 0xAD; } }
    my token byteAE { \c[REGISTERED SIGN]                            { make 0xAE; } }
    my token byteAF { \c[MACRON]                                     { make 0xAF; } }
    my token byteB0 { \c[DEGREE SIGN]                                { make 0xB0; } }
    my token byteB1 { \c[PLUS-MINUS SIGN]                            { make 0xB1; } }
    my token byteB2 { \c[SUPERSCRIPT TWO]                            { make 0xB2; } }
    my token byteB3 { \c[SUPERSCRIPT THREE]                          { make 0xB3; } }
    my token byteB4 { \c[ACUTE ACCENT]                               { make 0xB4; } }
    my token byteB5 { \c[MICRO SIGN]                                 { make 0xB5; } }
    my token byteB6 { \c[PILCROW SIGN]                               { make 0xB6; } }
    my token byteB7 { \c[MIDDLE DOT]                                 { make 0xB7; } }
    my token byteB8 { \c[CEDILLA]                                    { make 0xB8; } }
    my token byteB9 { \c[SUPERSCRIPT ONE]                            { make 0xB9; } }
    my token byteBA { \c[MASCULINE ORDINAL INDICATOR]                { make 0xBA; } }
    my token byteBB { \c[RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK] { make 0xBB; } }
    my token byteBC { \c[VULGAR FRACTION ONE QUARTER]                { make 0xBC; } }
    my token byteBD { \c[VULGAR FRACTION ONE HALF]                   { make 0xBD; } }
    my token byteBE { \c[VULGAR FRACTION THREE QUARTERS]             { make 0xBE; } }
    my token byteBF { \c[INVERTED QUESTION MARK]                     { make 0xBF; } }
    my token byteC0 { \c[LATIN CAPITAL LETTER A WITH GRAVE]          { make 0xC0; } }
    my token byteC1 { \c[LATIN CAPITAL LETTER A WITH ACUTE]          { make 0xC1; } }
    my token byteC2 { \c[LATIN CAPITAL LETTER A WITH CIRCUMFLEX]     { make 0xC2; } }
    my token byteC3 { \c[LATIN CAPITAL LETTER A WITH TILDE]          { make 0xC3; } }
    my token byteC4 { \c[LATIN CAPITAL LETTER A WITH DIAERESIS]      { make 0xC4; } }
    my token byteC5 { \c[LATIN CAPITAL LETTER A WITH RING ABOVE]     { make 0xC5; } }
    my token byteC6 { \c[LATIN CAPITAL LETTER AE]                    { make 0xC6; } }
    my token byteC7 { \c[LATIN CAPITAL LETTER C WITH CEDILLA]        { make 0xC7; } }
    my token byteC8 { \c[LATIN CAPITAL LETTER E WITH GRAVE]          { make 0xC8; } }
    my token byteC9 { \c[LATIN CAPITAL LETTER E WITH ACUTE]          { make 0xC9; } }
    my token byteCA { \c[LATIN CAPITAL LETTER E WITH CIRCUMFLEX]     { make 0xCA; } }
    my token byteCB { \c[LATIN CAPITAL LETTER E WITH DIAERESIS]      { make 0xCB; } }
    my token byteCC { \c[LATIN CAPITAL LETTER I WITH GRAVE]          { make 0xCC; } }
    my token byteCD { \c[LATIN CAPITAL LETTER I WITH ACUTE]          { make 0xCD; } }
    my token byteCE { \c[LATIN CAPITAL LETTER I WITH CIRCUMFLEX]     { make 0xCE; } }
    my token byteCF { \c[LATIN CAPITAL LETTER I WITH DIAERESIS]      { make 0xCF; } }
    my token byteD0 { \c[LATIN CAPITAL LETTER ETH]                   { make 0xD0; } }
    my token byteD1 { \c[LATIN CAPITAL LETTER N WITH TILDE]          { make 0xD1; } }
    my token byteD2 { \c[LATIN CAPITAL LETTER O WITH GRAVE]          { make 0xD2; } }
    my token byteD3 { \c[LATIN CAPITAL LETTER O WITH ACUTE]          { make 0xD3; } }
    my token byteD4 { \c[LATIN CAPITAL LETTER O WITH CIRCUMFLEX]     { make 0xD4; } }
    my token byteD5 { \c[LATIN CAPITAL LETTER O WITH TILDE]          { make 0xD5; } }
    my token byteD6 { \c[LATIN CAPITAL LETTER O WITH DIAERESIS]      { make 0xD6; } }
    my token byteD7 { \c[MULTIPLICATION SIGN]                        { make 0xD7; } }
    my token byteD8 { \c[LATIN CAPITAL LETTER O WITH STROKE]         { make 0xD8; } }
    my token byteD9 { \c[LATIN CAPITAL LETTER U WITH GRAVE]          { make 0xD9; } }
    my token byteDA { \c[LATIN CAPITAL LETTER U WITH ACUTE]          { make 0xDA; } }
    my token byteDB { \c[LATIN CAPITAL LETTER U WITH CIRCUMFLEX]     { make 0xDB; } }
    my token byteDC { \c[LATIN CAPITAL LETTER U WITH DIAERESIS]      { make 0xDC; } }
    my token byteDD { \c[LATIN CAPITAL LETTER Y WITH ACUTE]          { make 0xDD; } }
    my token byteDE { \c[LATIN CAPITAL LETTER THORN]                 { make 0xDE; } }
    my token byteDF { \c[LATIN SMALL LETTER SHARP S]                 { make 0xDF; } }
    my token byteE0 { \c[LATIN SMALL LETTER A WITH GRAVE]            { make 0xE0; } }
    my token byteE1 { \c[LATIN SMALL LETTER A WITH ACUTE]            { make 0xE1; } }
    my token byteE2 { \c[LATIN SMALL LETTER A WITH CIRCUMFLEX]       { make 0xE2; } }
    my token byteE3 { \c[LATIN SMALL LETTER A WITH TILDE]            { make 0xE3; } }
    my token byteE4 { \c[LATIN SMALL LETTER A WITH DIAERESIS]        { make 0xE4; } }
    my token byteE5 { \c[LATIN SMALL LETTER A WITH RING ABOVE]       { make 0xE5; } }
    my token byteE6 { \c[LATIN SMALL LETTER AE]                      { make 0xE6; } }
    my token byteE7 { \c[LATIN SMALL LETTER C WITH CEDILLA]          { make 0xE7; } }
    my token byteE8 { \c[LATIN SMALL LETTER E WITH GRAVE]            { make 0xE8; } }
    my token byteE9 { \c[LATIN SMALL LETTER E WITH ACUTE]            { make 0xE9; } }
    my token byteEA { \c[LATIN SMALL LETTER E WITH CIRCUMFLEX]       { make 0xEA; } }
    my token byteEB { \c[LATIN SMALL LETTER E WITH DIAERESIS]        { make 0xEB; } }
    my token byteEC { \c[LATIN SMALL LETTER I WITH GRAVE]            { make 0xEC; } }
    my token byteED { \c[LATIN SMALL LETTER I WITH ACUTE]            { make 0xED; } }
    my token byteEE { \c[LATIN SMALL LETTER I WITH CIRCUMFLEX]       { make 0xEE; } }
    my token byteEF { \c[LATIN SMALL LETTER I WITH DIAERESIS]        { make 0xEF; } }
    my token byteF0 { \c[LATIN SMALL LETTER ETH]                     { make 0xF0; } }
    my token byteF1 { \c[LATIN SMALL LETTER N WITH TILDE]            { make 0xF1; } }
    my token byteF2 { \c[LATIN SMALL LETTER O WITH GRAVE]            { make 0xF2; } }
    my token byteF3 { \c[LATIN SMALL LETTER O WITH ACUTE]            { make 0xF3; } }
    my token byteF4 { \c[LATIN SMALL LETTER O WITH CIRCUMFLEX]       { make 0xF4; } }
    my token byteF5 { \c[LATIN SMALL LETTER O WITH TILDE]            { make 0xF5; } }
    my token byteF6 { \c[LATIN SMALL LETTER O WITH DIAERESIS]        { make 0xF6; } }
    my token byteF7 { \c[DIVISION SIGN]                              { make 0xF7; } }
    my token byteF8 { \c[LATIN SMALL LETTER O WITH STROKE]           { make 0xF8; } }
    my token byteF9 { \c[LATIN SMALL LETTER U WITH GRAVE]            { make 0xF9; } }
    my token byteFA { \c[LATIN SMALL LETTER U WITH ACUTE]            { make 0xFA; } }
    my token byteFB { \c[LATIN SMALL LETTER U WITH CIRCUMFLEX]       { make 0xFB; } }
    my token byteFC { \c[LATIN SMALL LETTER U WITH DIAERESIS]        { make 0xFC; } }
    my token byteFD { \c[LATIN SMALL LETTER Y WITH ACUTE]            { make 0xFD; } }
    my token byteFE { \c[LATIN SMALL LETTER THORN]                   { make 0xFE; } }
    my token byteFF { \c[LATIN SMALL LETTER Y WITH DIAERESIS]        { make 0xFF; } }
    my token hbyte               { <byte> <?{$<byte>.made +& 0x80}> { make $<byte>.made; } }
    my token lbyte               { <byte> <!?{$<byte>.made +& 0x80}> { make $<byte>.made; } }
    my token noteoffbyte         { <byte> <?{0x80 ≤ $<byte>.made ≤ 0x8f}> { make $<byte>.made +& 0x0F; } }
    my token noteonbyte          { <byte> <?{0x90 ≤ $<byte>.made ≤ 0x9f}> { make $<byte>.made +& 0x0F; } }
    my token keypressurebyte     { <byte> <?{0xa0 ≤ $<byte>.made ≤ 0xaf}> { make $<byte>.made +& 0x0F; } }
    my token controlchangebyte   { <byte> <?{0xb0 ≤ $<byte>.made ≤ 0xbf}> { make $<byte>.made +& 0x0F; } }
    my token programchangebyte   { <byte> <?{0xc0 ≤ $<byte>.made ≤ 0xcf}> { make $<byte>.made +& 0x0F; } }
    my token channelpressurebyte { <byte> <?{0xd0 ≤ $<byte>.made ≤ 0xdf}> { make $<byte>.made +& 0x0F; } }
    my token pitchbendbyte       { <byte> <?{0xe0 ≤ $<byte>.made ≤ 0xef}> { make $<byte>.made +& 0x0F; } }
    my token varint { <hbyte>* <lbyte> { my $val = 0;
                                      for $<hbyte> -> $v {
                                          $val +<= 7;
                                          $val +|= ($v.made) +& 0x7f;
                                      }
                                      $val +<= 7;
                                      $val +|= $<lbyte>.made +& 0x7f;
                                      make $val;
                                    }
                 }
    my token delta-time { <varint> { print "+{$<varint>.made}\t"; make $<varint>.made; } }
    my token string { $<count> = <byte> $<str> = .**{$<count>.made} { make $<str>; } }
    my token event {
        | $<channel>=<noteoffbyte>         $<key>=<lbyte> $<velocity>=<lbyte> { say sprintf "note off(%d): %d %d", $<channel>.made, $<key>.made, $<velocity>.made; }
        | $<channel>=<noteonbyte>          $<key>=<lbyte> $<velocity>=<lbyte> { say sprintf "note on(%d): %d %d", $<channel>.made, $<key>.made, $<velocity>.made; }
        | $<channel>=<keypressurebyte>     $<key>=<lbyte> $<velocity>=<lbyte> { say sprintf "key pressure(%d): %d %d", $<channel>.made, $<key>.made, $<velocity>.made; }
        | $<channel>=<controlchangebyte>   $<key>=<lbyte> $<velocity>=<lbyte> { say sprintf "control change(%d): %d %d", $<channel>.made, $<key>.made, $<velocity>.made; }
        | $<channel>=<programchangebyte>   $<key>=<lbyte> $<velocity>=<lbyte> { say sprintf "program change(%md): %d %d", $<channel>.made, $<key>.made, $<velocity>.made; }
        | $<channel>=<channelpressurebyte> $<key>=<lbyte> $<velocity>=<lbyte> { say sprintf "channel pressure(%md): %d %d", $<channel>.made, $<key>.made, $<velocity>.made; }
        | $<channel>=<pitchbendbyte>       $<key>=<lbyte> $<velocity>=<lbyte> { say sprintf "pitch bend: %d %d", $<key>.made, $<velocity>.made; }
        |                       $<key>=<lbyte> $<velocity>=<lbyte> { say sprintf "same: %d %d", $<key>.made, $<velocity>.made; }
        | <byteF0>          $<count>=<byte> .**{$<count>.made} { say "F0    {$<count>.made} bytes"; }
        | <byteF7>          $<count>=<byte> .**{$<count>.made} { say "F7    {$<count>.made} bytes"; }
        | <byteFF> <byte00> $<count>=<byte> .**{$<count>.made} { say "FF 00 {$<count>.made} bytes"; }
        | <byteFF> <byte01> <string> { say "text event: " ~ $<string>.made; }
        | <byteFF> <byte02> <string> { say "copyright notice: " ~ $<string>.made; }
        | <byteFF> <byte03> <string> { say "sequence/track name: " ~ $<string>.made; }
        | <byteFF> <byte04> <string> { say "instrument name: " ~ $<string>.made; }
        | <byteFF> <byte05> <string> { say "lyric: " ~ $<string>.made; }
        | <byteFF> <byte06> <string> { say "marker: " ~ $<string>.made; }
        | <byteFF> <byte07> <string> { say "cue point: " ~ $<string>.made; }
        | <byteFF> <byte2F> <byte00> { say "track end"; }
        | <byteFF> <byte51> $<count>=<byte> $<bytes> = .**{$<count>.made} { Midi.parse(~$<bytes>, :rule('tempo')); } # ?????
        | <byteFF> <byte58> $<count>=<byte> $<bytes>=.**{$<count>.made} { Midi.parse(~$<bytes>, :rule('timesignature')); }
        | <byteFF> <byte59> $<count>=<byte> $<bytes>=.**{$<count>.made} { Midi.parse(~$<bytes>, :rule('keysignature')); }
        | <byteFF> <byte> { say sprintf "Unknown system event %02X", $<byte>.made; }
    }
    token keysignature { $<sf>=<byte> $<mi>=<byte>
                         {
                             my @keys = <C♭ G♮ D♭ A♭ E♭ B♭ F C G D A E B F♯ C♯>;
                             my $index = $<sf>.made;
                             $index -= 256 if $index ≥ 128;
                             $index += 7;
                             my $key = @keys[$index] ~ ' ';
                             $key ~= $<mi>.made ?? 'minor' !! 'major';
                             say "Key: $key";
                         }
                       }
    token tempo { <uint24> { say sprintf "tempo: %d μs/♩", $<uint24>.made; } }
    token timesignature { $<num>=<byte> $<den>=<byte> $<click>=<byte> $<not>=<byte> { say sprintf "Time signature: %d/%d (%d, %d)", $<num>.made, 2 ** $<den>.made, $<click>.made, $<not>.made} }
    token track { { say "parsing track"; } ^ [<delta-time> <event>]* $ }
    my rule header-chunk { 'MThd' <uint32> <uint16> <uint16> <uint16> }
    my rule track-chunk  { 'MTrk' $<length>=<uint32> $<track> = .**{$<length>.made} { Midi.parse(~$<track>, :rule('track')); } }
    rule TOP { <header-chunk> <track-chunk>* }
}

my $midi-file = 'thestar.midi'.IO.open(:bin).read(10000000).decode('latin1');
my $match = Midi.parse($midi-file);


