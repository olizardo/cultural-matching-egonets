# Cultural Matching and the Persistence of Social Ties

This repository contains the complete replication materials—data, code, and manuscript—for the paper **"Cultural Matching and the Persistence of Social Ties"** by Omar Lizardo.

This project examines how cultural matching (shared tastes in music, movies, books, sports, games, outdoor activities) predicts the persistence of social ties over time using longitudinal egocentric network data from the NetSense study. We introduce a discrete-time survival analysis framework to evaluate the main effects of cultural matching and cultural network opacity, alongside interactions with subjective tie closeness.

---

## 📂 Repository Structure

The project directory is structured as follows:

```text
├── analysis.qmd                    # Main reproducible Quarto notebook for data prep, modeling, and output generation (primary entry point)
├── data/                           # Processed R datasets ready for modeling
├── Plots/                          # Directory where analysis plots and marginal effects graphs are saved
├── Tabs/                           # Directory where all reproduced regression tables and descriptive stats are saved
├── manuscript.tex                  # Main LaTeX manuscript
├── manuscript_citations.bib        # BibTeX citations file
├── renv.lock                       # renv lockfile for exact package versions
└── AGENTS.md                       # Project history and meta-documentation
```

---

## 🛠️ Prerequisites & Installation

To run the reproducibility workflow, you will need **R** and the **Quarto** CLI (pre-installed in Positron and RStudio).

### 1. Required R Packages
Ensure you have the required R packages installed. You can restore the exact package versions used in this project using `renv` by running the following command in your R console:

```R
renv::restore()
```

The primary dependencies include `tidyverse`, `lme4`, `marginaleffects`, `modelsummary`, `broom.mixed`, and `here`.

---

## 🚀 How to Reproduce the Findings

1. **Clone the Repository**: Clone this repository to your local machine using git or download it as a ZIP file.
2. **Open the Project**: Open the `.Rproj` (if created) or the working directory in your editor (e.g., Positron or RStudio). This ensures paths are resolved correctly relative to the project root via the `here` package.
3. **Install Dependencies**: Run `renv::restore()` to install the required packages.
4. **Run the Computational Pipeline**:
   * **Using the Command Line (Quarto CLI)**:
     ```bash
     quarto render analysis.qmd
     ```
   * **Using R**:
     ```R
     quarto::quarto_render("analysis.qmd")
     ```
   * *Note: The computational pipeline fits mixed-effects survival models and outputs tables and figures directly to the `Tabs/` and `Plots/` directories, which are then integrated into the final LaTeX manuscript.*
5. **Compile the Manuscript**:
   Compile the main LaTeX file using `latexmk` or your preferred LaTeX engine:
   ```bash
   pdflatex manuscript.tex
   bibtex manuscript.aux
   pdflatex manuscript.tex
   pdflatex manuscript.tex
   ```

---

## 📝 License & Citation

If you use the materials or code in this repository, please cite the forthcoming paper or project repository appropriately.
