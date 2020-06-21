LATEX=latexmk -pdf -xelatex

LYXS=$(wildcard includes/*.lyx)
LYXINCLUDES=$(patsubst %.lyx,%.bare_tex,$(LYXS))

formulary.pdf: formulary.tex includes.tex

includes.tex: $(LYXINCLUDES) includes/30-marco.tex
	ls includes/*.bare_tex | sed 's/\(.*\)/\\input{\1}/' > $@

%.pdf: %.tex
	$(LATEX) $< -jobname=$(basename $@ .pdf)

includes/%.tex: includes/%.lyx
	lyx --export latex $< || lyx --export xetex $<

# remove newlines so sed can work multiline, cut everyting until
# \begin{document}, add newlines back and remove the outside document env. Now
# its suitable for \input-ing from another file.
includes/%.bare_tex: includes/%.tex
	cat $< |\
		tr '\n' '\r' |\
		sed 's/^.*\\begin{document}//' |\
		tr '\r' '\n' | sed 's/\\end{document}//' > $@


# it is what it is
clean:
	rm -f ./**/*/.aux ./**/*/.auxlock ./**/*/.fdb_latexmk ./**/*/.fls ./**/*/.xdv ./**/*/.bbl ./**/*/.brf ./**/*/.blg ./**/*/.log ./**/*/.out ./**/*/.synctex.gz ./**/*/.fmt ./**/*/.atfi ./**/*/.dvi ./**/*/.md5 ./**/*/.dpth ./**/*/.auxlock ./**/*/.cot ./**/*/.tex.map ./**/*/.idx ./**/*/.ilg ./**/*/.toc ./**/*/.ind includes/./x_tex ./**/*/.bare_tex formulary.pdf
