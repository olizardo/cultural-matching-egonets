txt <- readLines("analysis.qmd")

# Remove Intercept and adjust gof_map
txt <- gsub('"\\(Intercept\\)" = "Intercept"', '', txt)
txt <- gsub('gof_map = c\\("nobs", "r.squared", "aic", "bic", "rmse"\\)', 'gof_map = c("nobs", "aic", "bic")', txt)

# Ensure no empty commas in coef_map due to removing the last element
txt <- gsub(',\\s*\\n\\s*\\)', '\n  )', txt)

writeLines(txt, "analysis.qmd")
