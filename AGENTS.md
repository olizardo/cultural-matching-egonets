# Cultural Matching Egonets Project

## Overview
This project examines how cultural matching (shared tastes in music, movies, books, sports, games, outdoor activities) predicts the persistence of social ties over time using longitudinal egocentric network data (NetSense).

## Journal Submission & Review Status (September 2026)
* **Journal**: *Social Networks* (Manuscript **SON-D-26-00511**)
* **Title**: *Cultural Matching and the Persistence of Social Ties*
* **Co-Editor**: Ulrik Brandes
* **Decision**: **Major Revision** (Received September 14, 2026; Resubmission Deadline: **November 20, 2026**)
* **Revision Tracking Documents**:
  * [`REVISION_PLAN_SOCIAL_NETWORKS.md`](REVISION_PLAN_SOCIAL_NETWORKS.md): Complete prioritized revision strategy across Tier 1 (Methodology/Modeling), Tier 2 (Theoretical Reframing), and Tier 3 (Scope/Limitations).
  * [`response_to_reviewers.md`](response_to_reviewers.md): Live point-by-point response document tracking status, manuscript section changes, and draft responses.
  * [`manuscript-R1.tex`](manuscript-R1.tex): Working revision LaTeX manuscript.

---

## Data Sources
The project uses two main data sources from the NetSense study, originally provided as Stata `.dta` files.
*Note: The raw files were deleted from the local workspace. They can be found in the global path:* `/home/omarlizardo/ACADEMIC AND COURSE MATERIALS/NetSense`
1. **Ego Data**: `demographics_longitudinal_clean.dta` (or `demsurveyMergedCodedDisID.dta`) - Contains ego demographics (including race) and cultural taste items. Located in `/home/omarlizardo/ACADEMIC AND COURSE MATERIALS/NetSense/Surveys/`
2. **Alter/Network Data**: `network_surveys_longitudinal_clean.dta` (or `netsurveysMergedWideCodedFDAC-with-DatesPosition.dta`) - Contains alter attributes (including alter race), tie characteristics, and alter cultural taste items across multiple waves in a wide format. Located in `/home/omarlizardo/ACADEMIC AND COURSE MATERIALS/NetSense/Data/`

---

## Analytical Approach
* **Discrete-Time Survival Analysis**: Event history modeling using `lme4::glmer()` to model the hazard of tie dissolution across all waves simultaneously.
* **Core Measures**:
  * Closed-form cultural matching (broad domain count, 0–6).
  * Open-ended activity matching (favorite leisure activities count, 0–5).
  * Cultural network opacity (unknown preference count / "Don't Know", 0–6).
  * Subjective closeness (Tie strength: Close, Somewhat Close, Not Close).
  * Controls: `same_dorm`, `is_friend`, `race_homophily`, `freq_daily`, ego/alter gender, tie duration (linear and squared), and period fixed effects.
* **Reporting & Reproducibility**: Unified Quarto architecture (`analysis.qmd`) exporting generated tables (`Tabs/`) and plots (`Plots/`) to LaTeX (`manuscript-R1.tex`).

---

## Project Structure
* `data/`: R datasets ready for modeling (`data/processed/adjacent_waves.rds`, `ego_race.rds`, `alter_race.rds`).
* `analysis.qmd`: Reproducible Quarto notebook containing data wrangling, model estimation, and output generation.
* `manuscript-R1.tex`: Revision 1 manuscript LaTeX source.
* `manuscript.tex`: Original submission LaTeX source.
* `manuscript_citations.bib`: BibTeX citations for bibliography generation.
* `Tabs/`: Generated LaTeX table inputs (`desc_cont.tex`, `desc_cat.tex`, `main_models.tex`, `robustness_models.tex`, `dislike_models.tex`).
* `Plots/`: Generated figure outputs (`main_effects.png`, `interaction_closeness.png`).
* `response_to_reviewers.md`: Point-by-point response to editor and reviewers.
* `REVISION_PLAN_SOCIAL_NETWORKS.md`: Detailed prioritized revision roadmap.

---

## Revision Progress & Tasks

### Completed Tasks
1. **Revision Setup**:
   - Created `manuscript-R1.tex` as the dedicated working file for the revision.
   - Created `REVISION_PLAN_SOCIAL_NETWORKS.md` and `response_to_reviewers.md`.
2. **Tier 3 (Discussion & Scope Revisions)**:
   - **Time Horizon & Post-Collegiate Tie Dynamics (R1 #3)**: Expanded Section 5.3 to discuss the decay/persistence of ties after college graduation when institutional scaffolding is removed.
   - **Directionality, Perceptions, and Status Asymmetry (R1 #8)**: Added explicit discussion in Section 5.3 clarifying egocentric cognitive network boundaries, unreciprocated nominations, and status differences.
3. **Tier 2.10 (Calibrating Claims / Avoiding Over-Generalization)**:
   - Calibrated theoretical language in the Abstract, Introduction, and Section 5.1–5.3 to ground conclusions in emerging adulthood and collegiate transitions rather than invariant universal laws (R2 #1).
4. **Tier 1.7 (Descriptive Statistics Table)**:
   - Embedded Table 1 (`Tabs/desc_cont.tex`) and Table 2 (`Tabs/desc_cat.tex`) directly into Section 3.2 (*Measures and Descriptive Statistics*) in `manuscript-R1.tex` with thorough descriptive narrative (R1 #4, R2). Removed the duplicate appendix.
5. **Tier 1.1 (Structural Embeddedness Controls - R1 #1, #5)**:
   - Extracted perceived alter-to-alter contacts from `alter_alter_ties_longitudinal.rds` and computed dyadic common neighbors / triadic closure counts ($0\text{--}19$) and normalized triadic closure ratios ($0\text{--}1$).
   - Integrated structural embeddedness into `Code/prep_all_waves.R`, `data/processed/adjacent_waves.rds`, and estimated Model 4 in `analysis.qmd`.
   - Structural embeddedness strongly predicts persistence ($\text{OR} = 1.122, p = 0.0106$); open-ended matches ($\text{OR} = 1.071, p = 0.0286$) and closed-form matches ($\text{OR} = 1.067, p = 0.0574$) remain positive and robust.
   - Updated Table 1 (`desc_cont.tex`), Table 3 (`main_models.tex`), Table 4 (`robustness_models.tex`), Section 3.2, 4.1, 5.1–5.2 in `manuscript-R1.tex`, compiled to PDF, and drafted response in `response_to_reviewers.md`. Connected Overleaf remote repository.

---

### Remaining Revision Tasks

#### High Priority (Tier 1: Methodological & Modeling Tasks in `analysis.qmd`)
- [x] **Tier 1.1: Structural Embeddedness Controls (R1 #1, #5)**: Compute triadic closure / shared neighbors / embeddedness metrics in NetSense; add to models in `analysis.qmd` and report in main tables. (Completed)
- [ ] **Tier 1.2: Tie Rekindling & Discrete-Time Event History Formalization (R1 #4)**: Formally document the discrete-time risk set, absorbing first dissolution vs. repeated spell handling, and tie sequence distribution across 8 waves in Section 3.
- [ ] **Tier 1.3: Empirical Stability of Cultural Tastes (R1 #2)**: Compute test-retest reliability / correlation / Jaccard similarity of taste items across waves to empirically validate the durability assumption.
- [ ] **Tier 1.4: Alters as Egos / Two-Way Dyadic Clustering (R1 #6)**: Estimate cross-classified random effects models (`(1 | egoid) + (1 | alterid)`) or dyadic clustered SEs; present robustness results.
- [ ] **Tier 1.5: Cultural Matching Operationalization Sensitivity (R1 #5)**: Disaggregate matches into positive interest alignment vs. shared disinterest/dislikes; run sensitivity models.
- [ ] **Tier 1.6: Node Persistence & Survivorship/Attrition Bias (R1 #7)**: Perform ego retention analysis and sensitivity models for high-retention egos.

#### Medium Priority (Tier 2: Theoretical Reframing in `manuscript-R1.tex`)
- [ ] **Tier 2.7: De-escalate "Culture vs. Structure" Confrontational Framing (R1 Intro)**: Reframe the Introduction and Theoretical Framework from a zero-sum contest to an integrative co-evolutionary and complementary mechanism framework.
- [ ] **Tier 2.8: Positional Differences & Campus Social Structure (R2 #2)**: Expand discussion and modeling of structural positions, residential arrangements, and exogenous identity criteria.
- [ ] **Tier 2.9: Conversion of Cultural Capital across Social Locations (R2 #3)**: Elaborate on how cultural capital conversion to social capital differs across campus structural strata.
