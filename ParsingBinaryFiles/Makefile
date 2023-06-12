all: 1-intro.md 2-access.md 3-manual.md 4-unpack.md 5-blob.md 6-structure.md 7-regex.md 8-carray.md 9-binregex.md thestar.midi thestar.pdf

%.md: %.rakudoc
	raku --doc=Markdown $< >$*.md

%.midi %.pdf: %.ly
	lilypond $<
