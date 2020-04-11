%.pdf: %.md template.latex gantt.tex ganttExt.tex
	pandoc $< \
		-f markdown+citations+example_lists \
		--bibliography=bibliography.bib \
		--template=template.latex \
		--pdf-engine-opt="-shell-escape" \
		-V links-as-notes=true \
		-N \
		-o $@
