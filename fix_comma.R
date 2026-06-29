txt <- readLines("analysis.qmd")
txt <- gsub(',\\s*\\n\\s*\\)', '\n  )', txt)
writeLines(txt, "analysis.qmd")
