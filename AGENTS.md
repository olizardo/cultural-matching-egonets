# Cultural Matching Egonets Project

## Overview
This project examines how cultural matching (shared tastes in music, movies, books, sports, games, outdoor activities) predicts the persistence of social ties over time using longitudinal egocentric network data (NetSense).

## Data Sources
The project uses two main data sources from the NetSense study, originally provided as Stata `.dta` files.
*Note: The raw files were deleted from the local workspace. They can be found in the global path:* `/home/omarlizardo/ACADEMIC AND COURSE MATERIALS/NetSense`
1. **Ego Data**: `demographics_longitudinal_clean.dta` (or `demsurveyMergedCodedDisID.dta`) - Contains ego demographics (including race) and cultural taste items. Located in `/home/omarlizardo/ACADEMIC AND COURSE MATERIALS/NetSense/Surveys/`
2. **Alter/Network Data**: `network_surveys_longitudinal_clean.dta` (or `netsurveysMergedWideCodedFDAC-with-DatesPosition.dta`) - Contains alter attributes (including alter race), tie characteristics, and alter cultural taste items across multiple waves in a wide format. Located in `/home/omarlizardo/ACADEMIC AND COURSE MATERIALS/NetSense/Data/`

## Analytical Approach
*   **Previous Approach**: Stata-based workflow analyzing tie persistence across adjacent waves (Wave 1-2, 2-3, 2-5, 5-6) using random-effects logistic regression (`xtlogit`).
*   **Modern R Approach**: 
    *   **Data Wrangling**: `tidyverse` replacing Stata's `reshape` and `egen`.
    *   **Modeling**: Discrete-Time Survival Analysis (event history modeling) using `lme4::glmer()` to model the hazard of tie dissolution across all waves simultaneously.
    *   **Refined Measures**: Disaggregating the simple `num_match` sum to test domain-specific cultural matches and exploring the role of "Don't Know" responses (network opacity).
    *   **Reporting**: Fully reproducible, unified Quarto architecture (`manuscript.qmd`) where models are fit natively and results (`modelsummary` tables, `marginaleffects` plots) are generated dynamically upon rendering.

## Project Structure
*   `data/`: R datasets ready for modeling.
*   `analysis.qmd`: The reproducible Quarto notebook containing data prep, modeling, and output generation (saving to `Plots/` and `Tabs/`).
*   `manuscript.tex`: The main LaTeX manuscript file that inputs the generated plots and tables.
*   `manuscript_citations.bib`: BibTeX citations for bibliography generation.

## Current Status and Progress (June 2026)
*   **Unified Reproducible Architecture**: Ported all external R scripts (data prep, baseline models, domain models, opacity models, and model comparison) directly into `analysis.qmd` as executable R chunks. Enabled caching for faster re-renders. Deleted all obsolete external asset folders (`R/`, `reports/`, `Tabs/`, `Plots/`).
*   **Data Prep Fixes**: Fixed ego gender (`female` set to `gender == "Female"`) and reconstructed the `campustie` variable across waves. This resolved a missing data bug, rescuing thousands of observations and allowing the full estimation of $N = 5,336$ dyad-periods across all waves.
*   **Tie-Level Controls and Race Homophily**:
    *   Removed network structure controls (`meanclose`, `friendnet`, `kinnet`) and added a `same_dorm` tie-level indicator.
    *   Constructed a `race_homophily` indicator by extracting raw ego ethnicity from `demographics_longitudinal_clean.csv` and raw alter race from `network_surveys_longitudinal_clean.csv` using the open-source `.csv` versions in the global NetSense folder. Built mapping files (`ego_race.rds` and `alter_race.rds`) in `data/processed/` that link `sender` -> `egoid` and `receiver` -> `alterid`. Added this control to all models in `analysis.qmd`.
*   **Model Estimates**:
    *   *Baseline Model*: Robust positive effect of aggregate cultural matches on tie persistence.
    *   *Opacity Models*: Network opacity (unknown preference domains) significantly increases the hazard of tie dissolution. Formal statistical tests of second differences in average marginal effects demonstrate that the interaction between network opacity and cultural matching is null.
    *   *Model Comparison*: Added a comprehensive model comparison showing that the Opacity Main Effects model has the best fit (lowest AIC/BIC), with a simplified table summarizing only GOF stats.
*   **Literature and Theory Integration**: Successfully extracted rich theoretical background and classical citations (such as Bourdieu, Burt, Mark, McPherson, Lazarsfeld, and Holt) from old Word drafts using Quarto's pandoc utility. Integrated these concepts to write a comprehensive `Introduction` and `Theoretical Framework`, complete with a `.bib` bibliography.
*   **Recent Updates (July 2026)**:
    *   **Citation Formatting**: Switched citation style from `plainnat` to `apalike` in `manuscript.tex`. Cleaned up `manuscript_citations.bib` by systematically removing all `url` fields to maintain cleaner bibliography rendering.
    *   **Manuscript Structural Edits**: Reorganized `manuscript.tex` to improve logic and flow. Moved the "Strength-Mediated Matching Hypothesis" from the Opacity subsection to its own dedicated subsection. Added a clearer "Roadmap" paragraph at the end of the Introduction. Added a dedicated "Summary of Hypotheses" section at the end of the Theoretical Framework. Created explicit signposting at the beginning of the Results section. Expanded the concluding discussion to include practical/real-world implications of cultural matching for university administrators and community building.