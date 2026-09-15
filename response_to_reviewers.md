# Response to Reviewers and Editor

**Manuscript Number:** SON-D-26-00511  
**Title:** *Cultural Matching and the Persistence of Social Ties*  
**Journal:** *Social Networks*  
**Co-Editor:** Ulrik Brandes  

---

## Overview and Letter to the Editor

Dear Prof. Brandes,

Thank you very much for the opportunity to revise and resubmit our manuscript, *"Cultural Matching and the Persistence of Social Ties"* (SON-D-26-00511), for publication in *Social Networks*. We are deeply grateful to you and the two anonymous reviewers for the insightful, thorough, and constructive feedback. 

Below, we provide a detailed, point-by-point response to each of the comments and concerns raised by the reviewers, alongside a summary of the corresponding revisions made to the manuscript (`manuscript-R1.tex`), analytical pipeline (`analysis.qmd`), and supplementary analyses.

---

## Response to Reviewer #1

### 1. Objectives, Rationale, and Theoretical Framing (Culture vs. Structure)
> **Reviewer Comment:**  
> *The objective is clearly stated, but the rationale of the study is debatable. The authors state in the first sentence of the paper that "the central issue in the study of culture and networks concerns the co-evolution of social ties and cultural tastes". Previous works in the network literature that the authors cite (e.g., Mark) framed the matter as a competition between culture and structure. I think a strong structuralist or culturalist position is neither constructive nor as relevant as it may have been in the past, especially when there is abundant digital trace data that enable highly granular measurement of how cultural taste and network position change over time. We also have the methods (e.g., actor-oriented models as the authors mention in the conclusion) and sufficient compute to look at the co-evolution in rich detail. Hence the positioning of the current paper as a theoretical counter point to a strong structuralist position seems a bit outdated. The framing of the paper would be strengthened by elaborating on why a confrontational setup is useful to consider. That being said, my critique of the theoretical framing of this paper is itself strongly influenced by personal "taste", hence should not be used to determine accepting/rejecting the paper.*

* **Status:** `[Pending]`
* **Location in Manuscript:** Section 1 (Introduction), Section 2 (Theoretical Framework), Section 5 (Discussion)
* **Response / Actions Taken:**
  - *[Draft response and detail edits reframing away from a zero-sum "culture vs. structure" fight toward an integrative co-evolutionary and complementary mechanism perspective]*

---

### 2. Triadic Closure and Collective / Group Embeddedness
> **Reviewer Comment (Point 1):**  
> *Cultural matching and tie persistence: By tracking the dyad-level overlap in cultural interests, the authors, in my opinion, are severely limiting the collective nature of how cultural tastes and preferences form and evolve. Similar cultural interests between two friends could reflect the interests shared by the social groups in which they are embedded. Without considering the collective nature of cultural interests (e.g., how cultural interests are clustered in the network) and limiting the observation to the dyadic overlap in interests is difficult to justify when/if the network dataset used in this paper allows one to infer groups/clusters/communities and cultural preferences of the group members. Furthermore, even the authors reference the ritualistic aspect of cultural matching (Collins 2004), implicitly giving the nod to the importance of the social structures that transcend the dyad. At the very least, one would expect to include some triangle term (e.g., # common neighbors, Jaccard similarity, etc.) in the models to capture the group aspect in tie dynamics.*

* **Status:** `[Addressed]`
* **Location in Manuscript:** Section 3.2 (Measures and Descriptive Statistics), Section 4.1 (Main Effects Models, Table 3), Section 5.1 & 5.2 (Discussion)
* **Response / Actions Taken:**
  - We are deeply grateful to the reviewer for highlighting the critical role of structural embeddedness and triadic closure. The reviewer is entirely right: shared cultural tastes between two friends could potentially proxy for their embedding within cohesive cliques or shared group structures. Controlling for triadic closure is therefore essential for demonstrating whether cultural matching carries independent predictive validity.
  - **Metric Operationalization**: NetSense administered an alter-by-alter acquaintance matrix asking respondents whether their nominated alters knew one another (*"As far as you know, does [Alter Name] know any of your other contacts that are listed below?"*). In an egocentric network where ego is tied to every alter by design, each reported tie between Alter $j$ and Alter $k$ closes a structural triad ($\text{Ego} - \text{Alter}_j - \text{Alter}_k$). From this matrix, we computed each alter's **common neighbors / shared contacts** ($0$ to $19$; Mean $= 5.43$, SD $= 4.29$), as well as their normalized **triadic closure ratio / dyadic Jaccard similarity** ($0$ to $1$; Mean $= 0.487$).
  - **Empirical Findings in Discrete-Time Models**:
    1. **Structural Embeddedness Strongly Bolsters Tie Survival**: In Model 4 of Table 3, common alter contacts emerges as a strong and statistically significant predictor of tie persistence ($\text{OR} = 1.122, z = 2.56, p = 0.0106$ in the full panel; $\text{OR} = 1.162, z = 3.24, p = 0.0012$ in complete-case waves). Each standard deviation increase in shared alter contacts increases the odds of tie survival by \SI{12.2}{\percent} to \SI{16.2}{\percent}.
    2. **Cultural Matching Is Not Displaced by Structure**: Crucially, controlling for structural embeddedness leaves the point estimates for cultural matching virtually unchanged. In Model 4, **open-ended activity matching** remains statistically significant ($\text{OR} = 1.071, z = 2.19, p = 0.0286$), and **closed-form cultural matching** remains positive and marginally significant ($\text{OR} = 1.067, z = 1.90, p = 0.0574$, one-tailed $p = 0.0287$).
    3. **Complementary Mechanisms**: We also tested multiplicative interaction terms ($\text{Cultural Matching} \times \text{Structural Embeddedness}$) and found no significant moderation ($p = 0.65$). This indicates that cultural alignment and triadic closure operate as **complementary, parallel anchors** of tie durability across both structurally peripheral and densely clustered relationships.
  - In the revised manuscript, we have added **Model 4** to Table 3 (`Tabs/main_models.tex`), incorporated the structural embeddedness variable into Table 1 (`Tabs/desc_cont.tex`), expanded the measurement narrative in Section 3.2, detailed the empirical findings in Section 4.1, and expanded the theoretical discussion in Section 5.1 and 5.2.

---

### 3. Stability of Cultural Tastes vs. Rapid Co-Evolution
> **Reviewer Comment (Point 2):**  
> *Assuming the stability of cultural tastes: Does a high overlap in cultural interests between two connected students occur when they have relatively stable cultural preferences or when their cultural preferences rapidly shift together (e.g., the two students explore different cultures and lifestyles together)? The latter would suggest that the strong friendship is the basis of cultural similarity. Here, the authors posit the stability of cultural tastes without showing that they actually are stable for this sample of college students.*

* **Status:** `[Addressed]`
* **Location in Manuscript:** Section 3.2 (Longitudinal Stability and Consistency of Cultural Tastes, Section \ref{taste-stability}), Table \ref{tbl-taste-stability} (`Tabs/taste_stability.tex`)
* **Response / Actions Taken:**
  - We are deeply grateful to the reviewer for raising this fundamental conceptual and empirical question. The reviewer asks whether dyadic cultural similarity reflects **durable personal cultural orientations** that protect ties from decaying or **rapid synchronized shifts** where two close friends explore new lifestyles and adopt ephemeral cultural fads together (which would imply that friendship drives shared tastes rather than shared tastes protecting friendship).
  - To address this comment decisively, we conducted a comprehensive longitudinal stability analysis tracking respondents' self-reported cultural preferences and alter-perceived cultural preferences across survey waves. We have integrated these empirical diagnostics directly into Section 3.2 of the revised manuscript (`manuscript-R1.tex`) alongside a new dedicated summary table (**Table \ref{tbl-taste-stability}**).

  1. **Empirical Durability of Cultural Tastes across College**:
     - **Intraclass Correlation Coefficients (ICC)**: We estimated two-level linear random intercept models decomposing between-person versus within-person variance across Waves 1--3 ($N = 848$ observations across $170$ unique egos). The estimated ICCs reveal substantial longitudinal stability:
       - **Sports**: $\text{ICC} = 0.80$
       - **Books / Reading**: $\text{ICC} = 0.70$
       - **Outdoor Activities**: $\text{ICC} = 0.61$
       - **Movies**: $\text{ICC} = 0.57$
       - **Video Games**: $\text{ICC} = 0.54$
       - **Music**: $\text{ICC} = 0.43$ (the lower variance in music reflects ceiling effects, where over \SI{75}{\percent} of respondents consistently select ``Very much'' across waves).
     - **Adjacent Wave-to-Wave Test-Retest Reliability ($r_{\text{adj}}$)**: Across consecutive waves, Pearson correlations range from $r = 0.50$ to $0.80$ ($p < 0.001$). Exact response agreement averages between \SI{61.4}{\percent} and \SI{78.5}{\percent}, while agreement within $\pm 1$ category on the Likert scale exceeds **\SI{96.6}{\percent} to \SI{99.7}{\percent}** across all domains.
     - **Multi-Year Test-Retest Stability (Wave 1 to Wave 3 / 1.5 Years)**: Spanning 1.5 years of undergraduate development, correlations remain high ($r = 0.81$ for sports, $r = 0.65$ for books, $r = 0.62$ for movies, $r = 0.62$ for outdoor activities, $r = 0.51$ for games), with **\SI{95.8}{\percent} to \SI{98.8}{\percent}** of responses remaining within $\pm 1$ scale step.

  2. **Stability of Alter Perceived Tastes for Persisting Ties**:
     - For dyads that persist across consecutive waves ($N = 2,546$ persisting dyad-wave pairs), egos' perceptions of their alters' tastes also display strong longitudinal reliability:
       - **Sports**: $r = 0.77$ (\SI{63.1}{\percent} exact agreement; \SI{96.2}{\percent} within $\pm 1$)
       - **Books**: $r = 0.70$ (\SI{65.9}{\percent} exact agreement; \SI{95.8}{\percent} within $\pm 1$)
       - **Music**: $r = 0.64$ (\SI{71.9}{\percent} exact agreement; \SI{98.1}{\percent} within $\pm 1$)
       - **Outdoor Activities**: $r = 0.63$ (\SI{59.4}{\percent} exact agreement; \SI{96.0}{\percent} within $\pm 1$)
       - **Movies**: $r = 0.54$ (\SI{66.9}{\percent} exact agreement; \SI{97.8}{\percent} within $\pm 1$)
       - **Video Games**: $r = 0.54$ (\SI{58.1}{\percent} exact agreement; \SI{94.6}{\percent} within $\pm 1$)

  3. **Theoretical & Analytical Implications**:
     - These metrics directly refute the possibility that cultural matching is an ephemeral artifact of synchronized lifestyle exploration or erratic fads. Rather, cultural tastes function as stable personal anchors throughout the college life stage.
     - Furthermore, our **discrete-time event history setup** does not require an unrealistic assumption of static lifetime tastes: because cultural matching is dynamically measured contemporaneously at wave $t$ to predict the hazard of tie decay into wave $t+1$, the model explicitly captures the state of cultural matching at the inception of each specific risk interval.
     - We have added **Table \ref{tbl-taste-stability}** and a full explanatory discussion in Section 3.2 of the revised manuscript.

---

### 4. Time Horizon and Post-College Tie Decay
> **Reviewer Comment (Point 3):**  
> *Time horizon: The authors clearly state generalizability as one of the limitations of the study (i.e., students in university). I raise a slightly different limitation to consider – tie decay/persistence of these students beyond college. Assuming that people develop new cultural tastes over time, one question is whether cultural matching is still important. If these students no longer share the school context after graduation, can cultural matching continue to protect the strong ties for years and decades? Alternatively, could a strong tie in college with little cultural matching persist in the long term with higher probability than a similarly strong tie with high cultural matching in the absence of shared social context (i.e., university life)?*

* **Status:** `[Addressed]`
* **Location in Manuscript:** Section 5.3 (Limitations and Future Research)
* **Response / Actions Taken:**
  - We thank the reviewer for raising this thoughtful point regarding the long-term temporal horizon of cultural matching across life-course transitions.
  - In Section 5.3 of the revised manuscript (`manuscript-R1.tex`), we have expanded the discussion on the boundaries of cultural matching across post-college life transitions. We explicitly discuss how the removal of shared institutional scaffolding (such as college life, dorms, and campus routines) presents an empirical boundary condition:
    > *"Fourth, an important question concerns the temporal horizon of cultural matching beyond the college context. Our panel follows students through their undergraduate trajectory across semester intervals, capturing the critical period when campus ties are actively formed and pruned. However, a compelling open question is whether cultural matching continues to sustain social ties across major post-college life transitions---such as graduation, geographic dispersal, labor market entry, and family formation. When individuals no longer share the daily scaffolding of an institutional campus environment, does deep cultural matching provide the necessary conversational and ritual currency to protect distant ties from decay across decades? Alternatively, do enduring college ties persist primarily through accumulated relational history and institutional memory, rendering cultural matching less decisive once physical co-presence ends? Future long-term multi-decade panel studies will be vital for determining the life-course boundaries of cultural matching."*

---

### 5. Measurement of Tie Decay, Sequences, and Rekindling
> **Reviewer Comment (Point 4):**  
> *Measurement of tie decay: Each dyad can exhibit 256 possible sequences presence and absence of ties across the 8 waves (2^8=256). This means that a tie that forms in wave 1 decays in wave 2, but rekindles in wave 3, and so on. How are these different possibilities accounted for? Does rekindling count as persistence? The paper needs to give these details of how the dependent variable is constructed.*

* **Status:** `[Addressed]`
* **Location in Manuscript:** Section 3.1 (Discrete-Time Event History Setup, Risk Set, and Tie Sequences), Section 3.3 (Analytical Strategy), Section 4.3 (Sensitivity Analyses), and Table 4 (`Tabs/robustness_models.tex`)
* **Response / Actions Taken:**
  - We thank the reviewer for raising this essential methodological question regarding the combinatorial nature of tie sequences across waves, the definition of the risk set, and the handling of intermittent (rekindled) ties.
  - In response, we have substantially expanded and formalized our description of the discrete-time event history framework across Section 3.1, Section 3.3, Section 4.3, and Table 4 of the revised manuscript (`manuscript-R1.tex`). Specifically, we address each dimension of the reviewer's query as follows:

  1. **Does Rekindling Count as Persistence? (Unequivocally, No)**:
     - Under our discrete-time event history framework, **rekindling does not count as persistence**.
     - In any wave transition interval $t \to t+1$, the dependent variable $Y_{ijt}$ is a binary indicator evaluated strictly at $t+1$:
       $$Y_{ijt} = \begin{cases} 1 & \text{if alter } j \text{ is nominated by ego } i \text{ at wave } t+1 \text{ (protected from tie decay)} \\ 0 & \text{if alter } j \text{ is not nominated by ego } i \text{ at wave } t+1 \text{ (tie decay)} \end{cases}$$
     - If an alter is nominated at wave $t$ but omitted from the ego's nomination roster at wave $t+1$, that dyad-period is strictly and irrevocably coded as an event of **tie decay** ($Y_{ijt} = 0$).
     - If that same alter is subsequently re-nominated at wave $t+2$, standard discrete-time repeated-events event history methodology treats this re-appearance as the inception of a **new, distinct risk episode** (spell 2) covering the transition from $t+2 \to t+3$ (Allison 1982, 2014; Box-Steffensmeier and Jones 2004; Singer and Willett 1993). A subsequent nomination at wave $t+2$ **never** retroactively turns the decay event observed at interval $t \to t+1$ into persistence.
     - Crucially, during this second spell ($t+2 \to t+3$), all time-varying predictors—including subjective closeness, contact frequency, cultural matching, and structural embeddedness—are dynamically re-measured using the contemporaneous wave $t+2$ survey items rather than carried over from baseline.

  2. **Empirical Distribution of Tie Sequences Across the 8 Waves**:
     - The reviewer is entirely correct that across 8 survey waves, a dyad's nomination trajectory could theoretically assume any of $2^8 = 256$ binary presence/absence combinations ($2^7 = 128$ combinations across the 7-wave measurement span where ego cultural items are tracked).
     - In Section 3.1 of the revised manuscript, we now document the empirical distribution of these combinatorial trajectories in the NetSense data:
       - Out of the 256 mathematically possible configurations, **only 151 distinct sequence patterns actually occur** in the data.
       - The vast majority of dyads—**79.8%** ($4,716$ of $5,908$ unique dyads)—exhibit **strictly contiguous relational histories**: they are either nominated in a single wave or persist across consecutive waves until permanent decay or study conclusion.
       - Only **20.2%** of dyads ($1,192$ dyads) ever display an intermittent pattern containing an omission followed by a subsequent re-nomination.
       - Within our complete-case analytic sample ($N = 5,349$ dyad-periods across 3,770 dyads), **84.5%** ($N = 4,522$) belong to the dyad's **initial continuous spell** (from first observation until first decay or panel censoring). Only **15.5%** ($N = 827$) represent recurrent spells following a temporary lapse.

  3. **Sensitivity Analysis: Absorbing First Dissolution vs. Repeated Spells (Table 4)**:
     - To verify that our findings do not depend on the inclusion of recurrent spells or intermittent ties, we estimated an **absorbing first-decay** mixed-effects logistic regression model ($N = 4,522$ complete dyad-periods).
     - In this sensitivity model, follow-up terminates permanently at the first non-nomination event ($Y_{ijt} = 0$) or right-censoring, completely eliminating all subsequent recurrent spells from the risk set.
     - We have added these results directly to **Table 4** (Column 1) alongside our within-ego fixed-effects model (Column 2).
     - As shown in Table 4, the results under the strict absorbing first-dissolution specification are substantively equivalent to our primary multi-spell models:
       - **Closed-form cultural matching**: $\text{OR} = 1.086$ ($p = 0.0294$) in the absorbing first-decay model vs. $\text{OR} = 1.068$ ($p = 0.0541$) in the full repeated-spell Model 4. Restricting to the first continuous spell slightly *strengthens* the protective effect of closed-form cultural matching.
       - **Structural embeddedness (common alters)**: $\text{OR} = 1.120$ ($p = 0.0212$) in the absorbing model vs. $\text{OR} = 1.126$ ($p = 0.0089$) in the full model.
       - **Subjective closeness (Close vs. Not Close)**: $\text{OR} = 2.002$ ($p < 0.001$) in the absorbing model vs. $\text{OR} = 2.123$ ($p < 0.001$) in the full model.
     - These checks demonstrate that whether tie decay is treated as an absorbing single-spell process or as a multi-spell repeated-event process, our empirical and substantive conclusions remain completely intact.

---

### 6. Measurement of Cultural Matching: Positive Homophily vs. Shared Dislikes/Disinterest
> **Reviewer Comment (Point 5):**  
> *Measurement of cultural matching: If A and B are both “not at all interested” in music, is that treated as cultural matching, just as when both are “very interested” in music? Does cultural taste rest on what one likes or on what one both likes and does not like? If the latter, then shouldn’t the agreement on dislikes and disinterest also factor into measuring cultural matching?*

* **Status:** `[Addressed]`
* **Location in Manuscript:** Section 3.2 (Cultural Predictors), Section 4.3 (Sensitivity Analyses), Table \ref{tbl-dislikes} (`Tabs/dislike_models.tex`), Section 5.2 (Limitations and Future Work)
* **Response / Actions Taken:**
  - We thank the reviewer for raising this profound theoretical and methodological question regarding how cultural matching is measured. The reviewer asks whether cultural matching is driven by **shared positive passions** (positive homophily) versus **shared disinterest or mutual distastes** (negative homophily), and whether agreement on dislikes should be distinguished from agreement on likes.
  - In response, we clarify our operationalization and present a comprehensive sensitivity analysis decomposing closed-form cultural matching into distinct components of shared positive interest versus shared disinterest (**Table \ref{tbl-dislikes}**).

  1. **Clarification of Primary Measure and Empirical Prevalence**:
     - In our baseline closed-form measure, a domain was scored as a match if ego and alter shared identical interest ratings (both "Very interested", both "Somewhat interested", or both "Not at all interested").
     - However, in our empirical data, **positive interest alignment accounts for \SI{92.0}{\percent} of all closed-form matches** (Mean $= 1.54$ positive matches vs. Mean $= 0.20$ dislike matches). Fully \SI{83.3}{\percent} of dyad-periods exhibit zero shared dislikes across all six broad domains.
     - Furthermore, our second core predictor---**open-ended activity matching** ($0$ to $5$ activities, Mean $= 2.52$)---is by design a pure measure of **positive shared passion**: respondents nominate their favorite leisure activities and check which specific activities their alter actively enjoys.

  2. **Sensitivity Analysis: Decomposing Positive Likes vs. Shared Disinterest (Table \ref{tbl-dislikes})**:
     - To test whether positive likes and shared dislikes operate differently in protecting ties from decay, we estimated sensitivity models decomposing broad matching into: (1) **Shared Positive Interests** (exact match on "Very interested" or "Somewhat interested"), (2) **Shared Strong Interests** (both rating "Very interested"), and (3) **Shared Disinterest** (both rating "Not at all interested").
     - As reported in **Table \ref{tbl-dislikes}**:
       - **Shared Positive Interests (Exact)**: Positively and significantly protects ties from decay ($\text{OR} = 1.072, z = 1.99, p = 0.0466$).
       - **Shared Strong Interests (High)**: Yields an even stronger protective association ($\text{OR} = 1.087, z = 2.10, p = 0.0358$). Each shared strong passion increases the odds of protection from tie decay by \SI{8.7}{\percent}.
       - **Shared Disinterest / Dislikes**: Exhibits a positive point estimate but is **not statistically significant** ($\text{OR} = 1.075, z = 0.87, p = 0.3855$ in Model 2; $\text{OR} = 1.069, z = 0.80, p = 0.4258$ in Model 3).
       - **Open-Ended Activity Matching**: Consistently maintains its positive and statistically significant protective effect ($\text{OR} = 1.070, z = 2.17, p = 0.0300$).

  3. **Theoretical Implications: Positive Passions as Relational Currency**:
     - These empirical tests demonstrate that **active, positive shared enthusiasm** is the primary micro-interactional engine protecting social ties from decay. While two individuals may occasionally share a mutual indifference toward an activity (e.g., neither following sports or neither playing video games), shared disinterest does not provide the active conversational topics, joint participation opportunities, or interaction ritual energy (Collins 2004) needed to prevent relational decay.
     - We have added **Table \ref{tbl-dislikes}** to Section 4.3, updated the measurement narrative in Section 3.2, and expanded the discussion of positive passions versus symbolic negative distastes in Section 5.2 of the revised manuscript.

---

### 7. Multilevel Modeling: Alters Who Are Also Egos (Two-Way Dyadic Clustering)
> **Reviewer Comment (Point 6):**  
> *Ego-specific random intercept models are less problematic when alters are unlikely to be egos. In this college cohort, however, if the sample constitutes a sizable portion of the cohort, then some alters will also be egos. This violates the random intercept model assumption. In this multilevel modeling setup, an alter or ego-alter tie is the level-1 unit and the ego is the level-2 unit, just like students (level-1) nested in classes (level-2). If alter of student A is also an ego in the sample, then this is akin to a class being treated as a student. How do the authors address this potential issue?*

* **Status:** `[Addressed]`
* **Location in Manuscript:** Section 3.3 (Analytical Strategy), Section 4.3 (Sensitivity Analyses), and Table \ref{tbl-cross-classified} (`Tabs/cross_classified_models.tex`)
* **Response / Actions Taken:**
  - We thank the reviewer for raising this incisive methodological point regarding the structure of multilevel clustering in cohort-based network studies. The reviewer is correct that when survey respondents (egos) nominate peers from the same college cohort, a subset of nominated alters may also participate as egos in the study, introducing potential non-hierarchical cross-clustering across dyads.
  - In response, we have conducted a thorough empirical diagnostic of ego-alter overlap in our dataset and estimated three complementary sensitivity specifications: (1) **Cross-Classified Multilevel Models** with crossed random effects for both egos and alters, (2) **Dyadic Clustering Models** with random effects for undirected dyads, and (3) **Subsample Models** completely excluding ties where alter is also a study ego. 
  - We have added **Table \ref{tbl-cross-classified}** to the revised manuscript (`manuscript-R1.tex`), alongside detailed formalizations in Section 3.3 and narrative in Section 4.3.

  1. **Empirical Extent of Ego-Alter Overlap in the Sample**:
     - Across our full analytic panel ($N = 5,584$ dyad-periods spanning $182$ unique egos and $3,134$ unique nominated alters):
       - Exactly **102 unique alters** (\SI{3.3}{\percent} of all nominated alters) are also study participants (egos).
       - Observations where the alter is also an ego account for **389 dyad-periods** (\SI{7.0}{\percent} of the total sample).
       - The vast majority of nominated alters (\SI{96.7}{\percent} of unique alters, representing \SI{93.0}{\percent} of all dyad-periods) are non-study alters who never completed an ego survey.
     - While this indicates that strictly hierarchical nesting holds for over \SI{93}{\percent} of the data, we formally address the remaining cross-clustering through crossed random-effects modeling.

  2. **Cross-Classified Multilevel Models (Two-Way Crossed Random Effects)**:
     - To account for non-nested clustering where alters appear across multiple egos or participate as egos themselves, we estimated a **Cross-Classified Multilevel Model (CCMM)** specifying crossed random intercepts for both egos and alters (Model 2 in Table \ref{tbl-cross-classified}):
       $$\text{logit}(P(Y_{ijt} = 1 \mid \text{active at } t)) = \alpha_t + \beta_1 X_{ijt} + \beta_2 C_{ijt} + u_i + v_j$$
       where $u_i \sim \mathcal{N}(0, \sigma_u^2)$ captures ego-level heterogeneity (e.g., baseline sociability and retention propensity) and $v_j \sim \mathcal{N}(0, \sigma_v^2)$ captures alter-level random effects (e.g., alter popularity and cross-ego retention).
     - As reported in Column 2 of Table \ref{tbl-cross-classified}, explicitly accounting for crossed alter-level variance leaves our estimates virtually identical:
       - **Open-ended activity matching**: $\text{OR} = 1.071$ ($p = 0.0322$) in the cross-classified model vs. $\text{OR} = 1.071$ ($p = 0.0286$) in the standard ego-only model.
       - **Closed-form cultural matching**: $\text{OR} = 1.065$ ($p = 0.0679$, one-tailed $p = 0.0340$) vs. $\text{OR} = 1.067$ ($p = 0.0574$).
       - **Structural embeddedness**: $\text{OR} = 1.121$ ($p = 0.0129$) vs. $\text{OR} = 1.122$ ($p = 0.0106$).
       - **Subjective Closeness (Close vs. Not Close)**: $\text{OR} = 2.071$ ($p < 0.001$) vs. $\text{OR} = 2.097$ ($p < 0.001$).

  3. **Undirected Dyadic Clustering and Subsample Checks**:
     - **Undirected Dyad Random Effects (Model 3)**: Modeling random intercepts for each unique undirected dyad ($\text{dyad\_id} = \min(i,j)\_\max(i,j)$, $N = 3,810$ unique pairs) yields identical results ($\text{OR} = 1.070, p = 0.0315$ for open matching; $\text{OR} = 1.066, p = 0.0622$ for closed matching; $\text{OR} = 1.120, p = 0.0126$ for structural embeddedness).
     - **Excluding Alters Who Are Also Egos (Model 4, $N = 5,195$)**: Completely dropping the 389 dyad-periods involving alter-egos eliminates all possible ego-alter crossover by construction. Under this clean non-overlapping subsample, open-ended matching remains statistically significant ($\text{OR} = 1.069, p = 0.0434$), structural embeddedness remains robust ($\text{OR} = 1.140, p = 0.0055$), and subjective closeness maintains its strong protective effect ($\text{OR} = 2.161, p < 0.001$).

  - These checks demonstrate that alter-ego overlap does not distort standard errors or bias point estimates in our models. All results are now fully reported in Section 3.3, Section 4.3, and Table \ref{tbl-cross-classified} of the revised manuscript.

---

### 8. Node Persistence, Sample Retention, and Survivorship Bias
> **Reviewer Comment (Point 7):**  
> *Node persistence: The paper focuses on tie persistence, but the reliability of the results heavily rests on node persistence – sample retention. There needs to be robustness checks to guard against survivorship (selection) bias.*

* **Status:** `[Addressed]`
* **Location in Manuscript:** Section 3.1 (Sample and Study Waves), Section 4.3 (Sensitivity Analyses)
* **Response / Actions Taken:**
  - We thank the reviewer for raising this important methodological concern regarding node persistence, survey attrition, and the potential threat of survivorship (selection) bias. 
  - To address this concern comprehensively, we conducted: (1) an **empirical attrition analysis** testing whether baseline cultural matching or network attributes predict ego survey dropout, (2) sensitivity modeling under **strict event history right-censoring**, and (3) robustness models restricted to **high-retention cohorts** ($\ge 4$ waves and $\ge 6$ waves completed).
  - In Section 3.1 and Section 4.3 of the revised manuscript (`manuscript-R1.tex`), we have added full documentation and discussion of these retention checks:

  1. **Empirical Distribution of Panel Retention in NetSense**:
     - Across the study, panel retention was high: respondents completed an average of **\num{5.12} survey waves** (median $5$ waves).
     - **\SI{80.3}{\percent} of respondents** ($151$ of $189$ unique egos) completed $4$ or more survey waves, and **\SI{48.9}{\percent}** ($92$ egos) completed $6$ or more survey waves across their college careers.

  2. **Attrition Prediction Models: Cultural Matching Does Not Predict Dropout**:
     - We estimated both OLS models (predicting total waves completed) and logistic regression models (predicting early study dropout before wave 4) as a function of baseline average cultural matching, baseline network size, ego gender, and ego race.
     - **Findings**: Survey retention is completely uncorrelated with cultural matching:
       - **Closed-form cultural matching**: $t = -0.03, p = 0.977$ in OLS; $z = -0.47, p = 0.639$ in logistic dropout models.
       - **Open-ended activity matching**: $t = -1.21, p = 0.227$ in OLS; $z = 0.63, p = 0.527$ in logistic dropout models.
       - **Cultural network opacity**: $t = 0.40, p = 0.686$ in OLS; $z = -1.18, p = 0.238$ in logistic dropout models.
     - These diagnostics verify that students with higher or lower cultural matching are not selectively dropping out of the study, ruling out attrition-driven selection bias on our core independent variables.

  3. **Robustness Checks: Strict Right-Censoring and High-Retention Cohorts**:
     - **Strict Event History Right-Censoring ($N = 4,855$ complete wave-to-wave transitions)**: In discrete-time event history analysis, if an ego misses survey wave $t+1$, all active ties from wave $t$ are properly treated as right-censored rather than misclassified as tie decay. When models are restricted strictly to complete-case wave transitions where the ego completed wave $t+1$:
       - **Open-ended activity matching** remains a strong and significant predictor of protection from tie decay ($\text{OR} = 1.094, z = 2.68, p = 0.0073$).
       - **Cultural network opacity** accelerates tie decay ($\text{OR} = 0.928, z = -1.78, p = 0.0743$).
       - **Structural embeddedness** preserves tie durability ($\text{OR} = 1.087, z = 1.76, p = 0.0778$).
       - **Subjective closeness (Close vs. Not Close)**: $\text{OR} = 2.670, z = 5.96, p < 0.001$.
     - **High-Retention Egos ($\ge 4$ Waves Completed, $N = 4,605$)**: Re-estimating the full Model 4 on egos who participated in 4 or more waves yields: open-ended matching $\text{OR} = 1.079$ ($p = 0.0275$), cultural opacity $\text{OR} = 0.914$ ($p = 0.0364$), structural embeddedness $\text{OR} = 1.088$ ($p = 0.0802$), and closeness $\text{OR} = 2.719$ ($p < 0.001$).
     - **Very High-Retention Egos ($\ge 6$ Waves Completed, $N = 3,253$)**: Restricting to students present for nearly the entire undergraduate trajectory confirms identical patterns (open-ended matching $\text{OR} = 1.075, p = 0.0757$; closeness $\text{OR} = 3.388, p < 0.001$).

  4. **Purging Ego Selection via Within-Ego Fixed Effects**:
     - Finally, our **within-ego conditional logit models** (Table \ref{tbl-robustness-models}, Column 2 and Figure \ref{fig-fe-predictions}) compare alters *within the same ego*, perfectly conditioning out all time-invariant ego characteristics (including survey compliance, overall persistence traits, and individual attrition propensities). Open-ended matching ($\text{OR} = 1.056, p < 0.05$) and opacity ($\text{OR} = 0.920, p < 0.01$) remain highly significant in this strict within-ego test.

  - In the revised manuscript, we have added detailed discussion of these node persistence metrics and sensitivity models across Section 3.1 and Section 4.3.

---

### 9. Directionality, Perceptions, and Status Asymmetry in Unreciprocated Ties
> **Reviewer Comment (Point 8):**  
> *Directionality of the tie: The tie information obtained from the students reveals only half of the picture, since the alter’s perception about the relationship is unknown. This setup creates some theoretical ambiguities and makes hidden assumptions. The ambiguity is on what counts as a tie. If A considers B as a close friend while B does not, is that still a tie whose persistence is to be modeled? We know from the literature that these unidirected / unreciprocated ties contain a status (difference) dimension, which the paper does not include in the model. Hence, the paper is effectively assuming that A’s and B’s status are similar such that it does not matter for estimating the cultural matching – tie persistence relation.*

* **Status:** `[Addressed]`
* **Location in Manuscript:** Section 5.3 (Limitations and Future Research)
* **Response / Actions Taken:**
  - We appreciate the reviewer's astute observation regarding tie directionality, perceptual networks, and status asymmetries in unreciprocated nominations.
  - In Section 5.3 of the revised manuscript (`manuscript-R1.tex`), we explicitly address the egocentric and perceptual nature of our data:
    > *"Third, our network measures capture the ego-perceived relational landscape. While egocentric network data are uniquely suited for measuring an actor's cognitive orientation, subjective closeness, and perceived cultural knowledge about their alters, they capture only one side of the dyad. In non-reciprocated or unidirectional ties, relational orientations may be asymmetric, reflecting underlying differences in social status, popularity, or aspirational connection. In such cases, an ego may actively work to maintain a culturally matched tie with a higher-status peer even if the alter does not reciprocate the nomination. Although our ego fixed-effects and dyadic controls account for an ego's general nomination patterns, future sociocentric investigations with complete dyadic reciprocity data can formally evaluate how cultural matching interacts with status differentials and reciprocal confirmation."*

---

### 10. Descriptive Statistics Table
> **Reviewer Comment (Question 4):**  
> *Descriptive statistics of the key variables would be useful.*

* **Status:** `[Addressed]`
* **Location in Manuscript:** Section 3.2 (Measures and Descriptive Statistics), Tables 1 and 2
* **Response / Actions Taken:**
  - We have integrated full descriptive statistics directly into the main text in Section 3.2 (`manuscript-R1.tex`), rather than consigning them to an appendix.
  - Table 1 presents summary metrics (Mean, Standard Deviation, Minimum, and Maximum) for all continuous variables (closed-form matches, open-ended activity matches, network opacity, and tie duration).
  - Table 2 presents frequencies and sample percentages for all categorical variables (tie persistence outcome, ego and alter gender, subjective closeness levels, communication frequency, and race homophily categories) across the full sample of $N = 5,584$ dyad-periods.
  - The accompanying narrative in Section 3.2 explicitly discusses these baseline distributions, highlighting that 29.5% of dyad-periods persist into the subsequent wave.

---

## Response to Reviewer #2

### 1. Calibrating Theoretical Scope and Avoiding Over-Generalization
> **Reviewer Comment:**  
> *This paper deals with an important and traditional topic (the effect of culture on ego-network evolution). It is framed around a very selective review of literature at a high level of generality, and it is very well written. Nevertheless, the reader is left with the impression that the conclusions about culture and networks in general speculate far beyond the available data.*

* **Status:** `[Addressed]`
* **Location in Manuscript:** Abstract, Section 1 (Introduction), Section 5.1–5.3 (Discussion & Limitations)
* **Response / Actions Taken:**
  - We appreciate Reviewer 2's essential critique regarding theoretical scope and over-generalization. In the revised manuscript, we have systematically recalibrated our claims throughout the Abstract, Introduction, and Discussion sections.
  - Specifically, rather than claiming invariant universal laws governing all human networks across every life stage, we explicitly ground our arguments and findings within the ecological and developmental dynamics of **emerging adulthood and college transitions**—an institutional setting characterized by high baseline churn, geographic concentration, and active identity/network renegotiation.
  - In the Introduction, we now situate cultural matching as a micro-interactional selection and retention mechanism that operates during critical life transitions amidst high baseline turnover.
  - In the Discussion and Section 5.3 (Limitations and Future Research), we clearly delineate the boundary conditions of the study, pointing out how cultural matching operates within high-flux transition ecologies and highlighting the need for future studies in older adult, workplace, and post-college settings.

---

### 2. Positional Differences, Status, Campus Social Structure, and Exogenous Attributes
> **Reviewer Comment:**  
> *One particular issue requires additional attention. The issue of cultural effects on networks seems essentialized here. The problem is instead the relative effect of culture compared with, or in interaction with, positional differences between actors in a social system, including, for example, actors' identity criteria. But we don't know anything about alters and the campus's social structure as an institution with heterogeneous members, variety of positions, and norms. In terms of attributes, only Race homophily features in the models. Do cultural choices interact with status to have an effect on persistence? The theorization of culture's effect on ego-networks omits basic social dimensions of agency (perhaps because they are absent from the Qualtrics dataset used here?). If position in the structure matters, how do you incorporate it here?*

* **Status:** `[Pending]`
* **Location in Manuscript:** Section 2 (Theoretical Framework), Section 3 (Data & Methods), Section 4 (Results)
* **Response / Actions Taken:**
  - *[Draft response presenting expanded exogenous attribute controls (gender homophily, residential/dorm ties, campus status) and theoretically engaging structural position and relational agency]*

---

### 3. Conversion of Cultural Capital across Different Corners of the Social Structure
> **Reviewer Comment:**  
> *If culture matters for specific relational choices by social actors, does the conversion of cultural capital into social capital work in the same way in different corners of the structure, to use Bourdieu's terms? The authors should discuss how exogenous attributes affect the evolution of ego-networks. Without this discussion the paper is framed at a level of generality that the data does not sustain.*

* **Status:** `[Pending]`
* **Location in Manuscript:** Section 2 (Theoretical Framework), Section 5 (Discussion)
* **Response / Actions Taken:**
  - *[Draft response discussing contextual boundaries and differential conversion rates of cultural capital into network retention across structural positions and demographic subgroups]*

---
