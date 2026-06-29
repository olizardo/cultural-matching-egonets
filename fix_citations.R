text <- readLines("manuscript.tex")

# Fix citations
replacements <- list(
  "\\(Lazarsfeld and Merton 1954; McPherson et al. 2001\\)" = "\\\\citep{lazarsfeld1954, mcpherson2001}",
  "\\(Mark 1998b, 2003\\)" = "\\\\citep{mark1998b, mark2003}",
  "\\(Burt 2000, 2002; Wellman et al. 1997\\)" = "\\\\citep{burt2000, burt2002, wellman1997}",
  "\\(Bourdieu 1984; Holt 1998\\)" = "\\\\citep{bourdieu1984, holt1998}",
  "\\(Erickson 1988, 1996; Mark 1998a, 2003\\)" = "\\\\citep{erickson1988, erickson1996, mark1998a, mark2003}",
  "\\(Borgatti 2005; Carley 1991\\)" = "\\\\citep{borgatti2005, carley1991}",
  "\\(Mark 2003\\)" = "\\\\citep{mark2003}",
  "\\(Morgan et al. 1997; Suitor\net al. 1997\\)" = "\\\\citep{morgan1997, suitor1997}",
  "\\(Morgan et al. 1997; Suitor et al. 1997\\)" = "\\\\citep{morgan1997, suitor1997}",
  "\\(Bourdieu 1984, 1990; Holt 1997, 1998\\)" = "\\\\citep{bourdieu1984, bourdieu1990, holt1997, holt1998}",
  "\\(Bourdieu 2000; Lizardo\n2006\\)" = "\\\\citep{bourdieu2000, lizardo2006}",
  "\\(Bourdieu 2000; Lizardo 2006\\)" = "\\\\citep{bourdieu2000, lizardo2006}",
  "\\(Lizardo\n2006\\)" = "\\\\citep{lizardo2006}",
  "\\(Lizardo 2006\\)" = "\\\\citep{lizardo2006}",
  "\\(Lazarsfeld and Merton 1954; Werner and Parmelee 1979\\)" = "\\\\citep{lazarsfeld1954, werner1979}",
  "\\(Carley 1991; DiMaggio 1987\\)" = "\\\\citep{carley1991, dimaggio1987}",
  "\\(Burt 2000\\)" = "\\\\citep{burt2000}",
  "\\(Stinchcombe 1965\\)" = "\\\\citep{stinchcombe1965}",
  "\\(Collins 2004; DiMaggio 1987\\)" = "\\\\citep{collins2004, dimaggio1987}",
  "\\(Burt 2002;\nWellman et al. 1997\\)" = "\\\\citep{burt2002, wellman1997}",
  "\\(Burt 2002; Wellman et al. 1997\\)" = "\\\\citep{burt2002, wellman1997}"
)

# Since some patterns span newlines, let's collapse, replace, and split back.
full_text <- paste(text, collapse = "\n")

for (pat in names(replacements)) {
  full_text <- gsub(pat, replacements[[pat]], full_text)
}

# Add packages to preamble
full_text <- sub(
  "\\\\usepackage\\{bookmark\\}",
  "\\\\usepackage{bookmark}\n\\\\usepackage[round]{natbib}\n\\\\usepackage{microtype}\n\\\\usepackage{xurl}",
  full_text
)

# Add bibliography at the end
full_text <- sub(
  "\\\\end\\{document\\}",
  "\\\\bibliographystyle{plainnat}\n\\\\bibliography{manuscript_citations}\n\n\\\\end{document}",
  full_text
)

writeLines(full_text, "manuscript.tex")
