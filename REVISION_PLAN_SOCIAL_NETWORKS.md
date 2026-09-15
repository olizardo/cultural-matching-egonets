# Revision Strategy and Action Plan: *Social Networks* (SON-D-26-00511)
**Manuscript Title:** *Cultural Matching and the Persistence of Social Ties*  
**Editor:** Ulrik Brandes  
**Decision:** Major Revision (Resubmission Deadline: November 20, 2026)  

---

## Executive Summary

The decision from *Social Networks* offers a constructive pathway to publication via a **Major Revision**. Both reviewers found the paper well-written, engaging, and substantively important. However, both reviewers raised critical concerns that must be addressed:

1. **Reviewer 1** focused heavily on **methodological rigor, structural controls, and operational definitions**:
   - Lack of structural embeddedness controls (e.g., shared neighbors, triadic closure).
   - Ambiguity around dependent variable construction (handling tie rekindling across 8 waves).
   - Definition of cultural matching (positive taste alignment vs. shared disinterest/dislikes).
   - Assumption of cultural taste stability over time.
   - Multilevel model assumptions (egos who are also alters).
   - Panel attrition / survivorship bias.
   - Lack of a descriptive statistics table.
   - Confrontational "culture vs. structure" theoretical framing.

2. **Reviewer 2** focused on **theoretical scope, structural position, and over-generalization**:
   - Over-generalizing findings from a sample of college students to universal claims about culture and networks.
   - "Essentializing" culture without accounting for structural position, social status, and campus institutional positions.
   - Limited inclusion of exogenous alter/tie attributes (only race homophily currently).
   - How cultural capital conversion operates across different positions in the campus social hierarchy.

---

## Prioritized Revision Plan

The revision points are organized below in descending order of priority, grouped into three tiers:
- **Tier 1: Critical Methodological, Analytical & Modeling Revisions** (Must-resolve empirical additions)
- **Tier 2: Key Theoretical Reframing & Structural Positioning Revisions** (Substantive conceptual shifts)
- **Tier 3: Scope, Limitations & Expositional Revisions** (Clarifications, descriptive tables, and contextualization)

---

### Tier 1: Critical Methodological & Analytical Revisions

#### 1. Incorporate Structural Embeddedness / Triadic Controls into Models `[COMPLETED]`
* **Reviewer Concern (R1 #1, R1 #5):** If the manuscript is framed around the interplay between cultural matching and social structure, omitting structural embeddedness (e.g., shared neighbors, triadic closure, Jaccard similarity) is the most critical omission. Dyadic taste overlap may simply proxy for embedding in cohesive cliques or shared groups.
* **Actions Completed:**
  1. Extracted alter-to-alter ties from `Data/alter_alter_ties_longitudinal.rds` ($N = 29,473$ ties) and calculated the common neighbors / shared contacts of each alter within ego's nominated network ($0$ to $19$, Mean $= 5.43$, SD $= 4.29$), as well as normalized triadic closure ratio / Jaccard similarity ($0$ to $1$, Mean $= 0.487$).
  2. Incorporated standardized structural embeddedness into `Code/prep_all_waves.R`, `analysis.qmd`, and re-estimated all discrete-time survival models (`lme4::glmer`).
  3. Added **Model 4** to Table 3 (`Tabs/main_models.tex`), Table 1 (`Tabs/desc_cont.tex`), and Table 4 (`Tabs/robustness_models.tex`).
  4. Findings: Structural embeddedness strongly predicts tie survival ($\text{OR} = 1.122, p = 0.0106$). Net of embeddedness, open-ended activity matching remains statistically significant ($\text{OR} = 1.071, p = 0.0286$) and closed-form matching remains positive and marginally significant ($\text{OR} = 1.067, p = 0.0574$). Moderation tests showed no interaction ($p = 0.65$), confirming culture and structure are complementary parallel anchors.
  5. Updated narrative in Section 3.2 (Measures), Section 4.1 (Main Models), Section 5.1–5.2 (Discussion) of `manuscript-R1.tex`, compiled to PDF, and drafted detailed response in `response_to_reviewers.md`.

#### 2. Clarify & Justify the Dependent Variable Construction (Tie Dissolution & Rekindling) `[COMPLETED]`
* **Reviewer Concern (R1 #4):** Across 8 panel waves, dyads can theoretically exhibit up to $2^8 = 256$ presence/absence sequences. How does the model treat intermittent ties (ties that disappear and rekindle)? Does rekindling count as persistence?
* **Actions Completed:**
  1. Provided a rigorous mathematical and conceptual formalization of the discrete-time event history framework in Section 3.1 and Section 3.3 of `manuscript-R1.tex`, defining the conditional hazard of tie decay $h_{ijt} = P(Y_{ijt} = 0 \mid \text{active at } t)$ and protection from tie decay $1 - h_{ijt} = P(Y_{ijt} = 1 \mid \text{active at } t)$.
  2. Analyzed and documented the empirical sequence distribution: across 8 waves, only 151 of the 256 theoretical sequences appear. 79.8% of unique dyads (4,716 of 5,908) have strictly contiguous relational histories; only 20.2% (1,192 dyads) ever exhibit intermittent rekindling. In our complete-case analytic sample ($N = 5,349$), 84.5% ($N = 4,522$) belong to the first continuous spell, and 15.5% ($N = 827$) belong to recurrent spells.
  3. Explicitly clarified that **rekindling does NOT count as persistence**: if an alter is omitted at wave $t+1$, it is strictly coded as tie decay ($Y = 0$). Any subsequent re-nomination at $t+2$ begins a distinct new risk episode ($t+2 \to t+3$) with contemporaneous time-varying covariates.
  4. Estimated an **absorbing first-dissolution** sensitivity model in `Code/generate_deliverables.R` that terminates observation upon first decay ($N = 4,522$).
  5. Added the absorbing first-decay model alongside the Ego FE model in Table 4 (`Tabs/robustness_models.tex`) and discussed in Section 4.3: closed-form matching ($\text{OR} = 1.086, p = 0.0294$), structural embeddedness ($\text{OR} = 1.120, p = 0.0212$), and closeness ($\text{OR} = 2.002, p < 0.001$) remain completely consistent and robust.
  6. Drafted detailed point-by-point response in `response_to_reviewers.md` (Point 5).

#### 3. Empirically Test and Document the Stability of Cultural Tastes
* **Reviewer Concern (R1 #2):** The manuscript posits pre-existing, durable cultural dispositions as the engine of tie persistence, but does not provide empirical evidence that college students' tastes are actually stable over the panel period. Rapidly co-evolving tastes would imply ties driving taste rather than taste driving ties.
* **Actionable Steps:**
  1. Calculate test-retest reliability, rank-order stability, or intra-individual transition matrices for cultural taste items across waves.
  2. Report stability metrics (e.g., Pearson/Spearman correlations, Jaccard similarity across survey waves) in the Methods or an Appendix.
  3. Discuss the empirical bounds of taste stability versus co-evolution in the context of emerging adulthood.

#### 4. Address Ego-Alter Overlap in Multilevel Modeling (Dyadic / Cross-Classified Random Effects)
* **Reviewer Concern (R1 #6):** In a bounded college cohort, some alters are also egos in the sample. A simple ego random-intercept model (`glmer(..., (1 | egoid))`) violates standard multilevel independence assumptions because an alter nominated by Ego A may be Ego B in another dyad.
* **Actionable Steps:**
  1. Identify the proportion of alters who are in-sample egos in the NetSense data.
  2. Estimate cross-classified random effects models (incorporating random intercepts for both `egoid` and `alterid`: `(1 | egoid) + (1 | alterid)`) or estimate dyadic clustered standard errors (multi-way clustering).
  3. Report these as robustness models to demonstrate that findings are not artifactual to unmodeled alter-level random variation.

#### 5. Operationalize Matching Dimensions: Positive Agreement vs. Shared Dislikes/Disinterest
* **Reviewer Concern (R1 #5):** Does matching reflect shared positive tastes (both liking music/sports), or does it also count shared disinterest (both "not at all interested")? 
* **Actionable Steps:**
  1. Clarify the exact scoring rules used to construct `num_match` and domain-specific indicators in the Methods section.
  2. Test and report a sensitivity analysis decomposing matches into:
     - Shared high interest (positive homophily).
     - Shared disinterest / negative homophily.
     - Asymmetric mismatch (one interested, one not).
  3. Discuss whether shared positive passions vs. shared indifference operate differently as social glue.

#### 6. Perform Robustness Checks for Panel Attrition and Selection Bias
* **Reviewer Concern (R1 #7):** Tie survival relies heavily on node persistence (whether an ego continues participating in the survey). Attrition could induce survivorship bias.
* **Actionable Steps:**
  1. Conduct an attrition analysis checking if ego dropout is correlated with initial cultural matching, network size, or demographic attributes.
  2. Run sensitivity models restricted to egos with high survey retention (e.g., egos present for $\ge 4$ waves) or apply inverse probability weighting (IPW).
  3. Report findings in an online supplement/appendix.

---

### Tier 2: Key Theoretical Reframing & Structural Positioning Revisions

#### 7. De-escalate the "Culture vs. Structure" Confrontational Framing
* **Reviewer Concern (R1 Introduction, R2):** Framing the study as a zero-sum contest or theoretical counterpoint to a "strong structuralist position" (e.g., Mark 1998, 2003) is outdated given contemporary co-evolutionary perspectives, stochastic actor-oriented models (SAOMs), and rich digital trace data.
* **Actionable Steps:**
  1. Reframe the Introduction from a confrontational "culture versus structure" stance to an **integrative co-evolutionary and complementary mechanism framework**.
  2. Situate cultural matching as a micro-interactional mechanism that operates *in tandem with* and *conditional upon* structural opportunities (foci, triadic closure, institutional constraints).
  3. Acknowledge the advancements of SAOMs and dynamic network modeling in the literature review and discussion.

#### 8. Incorporate Positional Heterogeneity, Status Differences, and Exogenous Attributes
* **Reviewer Concern (R2):** The manuscript "essentializes" cultural matching, ignoring how cultural capital conversion depends on actors' structural and institutional positions. Furthermore, only race homophily is included; what about status asymmetries, dorm/living arrangements, major/academic affiliations, and gender homophily?
* **Actionable Steps:**
  1. Expand the set of dyadic and structural controls where feasible:
     - Gender homophily (same gender dyad).
     - Spatial/residential proximity (`same_dorm`).
     - Campus affiliation / tie context (`campustie`).
     - Race homophily.
  2. Introduce theoretical discussion on **status asymmetry and directionality**: acknowledge that ego-perceived ties capture subjective relational orientation, which may reflect status aspiration or asymmetric closeness.
  3. Discuss how the conversion of cultural capital into tie persistence may vary across social strata, majority vs. minority students, and campus niches.

#### 9. Calibrate Claims to Avoid Over-Generalization Beyond the Empirical Data
* **Reviewer Concern (R2):** The conclusions generalize far beyond the data (a panel study of college students at a single university) to universal claims about human networks and cultural capital.
* **Actionable Steps:**
  1. Tone down universal declarations about "culture's ultimate role in network evolution" throughout the Abstract, Introduction, and Discussion.
  2. Ground arguments specifically in institutional, developmental, and relational contexts characteristic of emerging adulthood and high-churn campus ecologies.
  3. Frame the findings as evidence of micro-level interactional affordances during formative transition periods rather than invariant social laws.

---

### Tier 3: Scope, Limitations & Expositional Revisions

#### 10. Add a Comprehensive Descriptive Statistics Table
* **Reviewer Concern (R1 #4, R2):** The manuscript lacks a basic table of descriptive statistics for key dependent, independent, and control variables.
* **Actionable Steps:**
  1. Create a clear descriptive statistics table (Mean, SD, Min, Max, $N$) for all ego attributes, alter attributes, tie-level variables (tie persistence, strength, opacity, match count, same dorm, race homophily, gender homophily), and domain-specific matches.
  2. Insert this table at the beginning of the Data & Methods section.

#### 11. Expand the Limitations & Future Directions Section
* **Reviewer Concern (R1 #3, R1 #8, R2):** Address specific boundary conditions:
  - **Long-term time horizon:** What happens to ties after graduation when the shared campus institutional context vanishes? Does cultural matching sustain post-college ties, or do institutional departures overwhelm cultural affinity?
  - **Directionality & Perceptions:** Discuss unreciprocated ties, ego-perceived networks, and the inability to measure alter's internal cultural tastes directly.
* **Actionable Steps:**
  1. Add a dedicated subsection in the Discussion on "Institutional Context, Life Transitions, and Long-Term Tie Decay".
  2. Explicitly outline the methodological implications of ego-centric perceptual data versus full sociocentric reciprocity data.

---

## Response Matrix & Task Checklist

| # | Reviewer & Comment | Priority | Task / Output Required |
|---|---|---|---|
| 1 | **R1:** Triadic closure & structural embeddedness | **High** | `[COMPLETED]` Add common neighbors / embeddedness controls; report in main tables. |
| 2 | **R1:** Tie decay sequences & rekindling (256 paths) | **High** | `[COMPLETED]` Formalize discrete-time event history setup in Methods; clarify risk set and episode handling; add absorbing first-decay model to Table 4. |
| 3 | **R1:** Empirical stability of cultural tastes | **High** | `[COMPLETED]` Compute taste consistency across waves; report correlation/stability table in Appendix/text. |
| 4 | **R1:** Alters as egos / multilevel assumption | **High** | `[COMPLETED]` Test cross-classified `(1|egoid) + (1|alterid)` and dyadic models; report Table 5 in manuscript and methods text. |
| 5 | **R1:** Matching metric (positive vs. shared disinterest) | **High** | Clarify scoring rule; run sensitivity check isolating positive interest matches vs. disinterest. |
| 6 | **R1:** Node attrition & selection bias | **High** | `[COMPLETED]` Run retention sensitivity models; document attrition patterns in response and manuscript text. |
| 7 | **R1 & R2:** Descriptive statistics table | **High** | Generate and insert comprehensive descriptive statistics table into manuscript. |
| 8 | **R1:** Tone down "culture vs. structure" fight | **Medium** | Rewrite Intro/Discussion to frame as co-evolutionary and complementary structural-cultural mechanisms. |
| 9 | **R2:** Positional differences & status asymmetry | **Medium** | Incorporate controls (gender homophily, same dorm, campus tie); discuss status & capital conversion. |
| 10 | **R2:** Over-generalization / scope calibration | **Medium** | Qualify claims to college/emerging adulthood transition; remove hyperbolic generalizations. |
| 11 | **R1:** Post-college tie persistence & horizon | **Low** | Expand Discussion on institutional departure, boundary conditions, and life course transitions. |
| 12 | **R1:** Directionality & unreciprocated ties | **Low** | Discuss perceptual ego-network bounds, status asymmetry, and unmeasured alter perceptions. |

---

## Timeline to November 20, 2026 Deadline

```
Phase 1 (Weeks 1–3): Data Re-analysis & Additional Modeling (Triads, Cross-Classified, Stability, Sensitivity)
Phase 2 (Weeks 4–5): Manuscript Revisions (Descriptives, Methods formalization, Framing, Limitations)
Phase 3 (Weeks 6–7): Point-by-Point Response Letter & Appendix Compilation
Phase 4 (Week 8): Final Review & Submission to Social Networks
```
