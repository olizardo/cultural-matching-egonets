text <- readLines("manuscript.tex")
text <- gsub("\\\\subsubsection\\{([^\\}]+)\\} \\\\\\\\", "\\\\subsubsection{\\1}", text)
writeLines(text, "manuscript.tex")
