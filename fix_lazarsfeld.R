text <- readLines("manuscript.tex")
full_text <- paste(text, collapse = "\n")
full_text <- gsub("\\(Lazarsfeld and Merton 1954;\nMcPherson et al. 2001\\)", "\\\\citep{lazarsfeld1954, mcpherson2001}", full_text)
writeLines(full_text, "manuscript.tex")
