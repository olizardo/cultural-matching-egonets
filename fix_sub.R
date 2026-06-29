text <- readLines("manuscript.tex")
text <- gsub("\\\\subusubsection", "\\\\subsubsection", text)
writeLines(text, "manuscript.tex")
