all: intro.md access.md thestar.midi thestar.pdf

%.md: %.rakudoc
	raku --doc=Markdown $< >$*.md

%.midi %.pdf: %.ly
	lilypond $<
