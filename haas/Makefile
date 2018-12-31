all: main

main:
	pdflatex main.tex
	bibtex main
	pdflatex main.tex
	pdflatex main.tex

.PHONY: clean
clean:
	rm *.aux *.log *.blg *.bbl *.out
