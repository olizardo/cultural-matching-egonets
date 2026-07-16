import re

with open("analysis.qmd", "r") as f:
    content = f.read()

# Replace main modelsummary
content = re.sub(
    r'title = "Odds Ratios for Tie Persistence \(Main Effects Models\)",',
    r'title = "Odds Ratios for Tie Persistence (Main Effects Models)\\\\label{tbl-models}",\n  escape = FALSE,',
    content
)

# Replace robustness modelsummary
# Find `output = here::here("Tabs", "robustness_models.tex"),`
content = re.sub(
    r'output = here::here\("Tabs", "robustness_models\.tex"\),',
    r'title = "Robustness Models (Ego Fixed-Effects)\\\\label{tbl-robustness-models}",\n  escape = FALSE,\n  output = here::here("Tabs", "robustness_models.tex"),',
    content
)

# Replace desc_cont
content = re.sub(
    r'output = here::here\("Tabs", "desc_cont\.tex"\)',
    r'title = "Descriptive Statistics (Continuous Variables)\\\\label{tbl-descriptives-cont}",\n  escape = FALSE,\n  output = here::here("Tabs", "desc_cont.tex")',
    content
)

# Replace desc_cat
content = re.sub(
    r'output = here::here\("Tabs", "desc_cat\.tex"\)',
    r'title = "Descriptive Statistics (Categorical Variables)\\\\label{tbl-descriptives-cat}",\n  escape = FALSE,\n  output = here::here("Tabs", "desc_cat.tex")',
    content
)

with open("analysis.qmd", "w") as f:
    f.write(content)
print("done")
