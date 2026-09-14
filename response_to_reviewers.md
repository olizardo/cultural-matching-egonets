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

* **Status:** `[Pending]`
* **Location in Manuscript:** Section 3 (Data and Methods), Appendix / Online Supplement
* **Response / Actions Taken:**
  - *[Draft response and present empirical stability metrics (test-retest correlations / Jaccard similarity across waves) verifying taste durability across the panel period]*

---

### 4. Time Horizon and Post-Collegiate Tie Decay
> **Reviewer Comment (Point 3):**  
> *Time horizon: The authors clearly state generalizability as one of the limitations of the study (i.e., students in university). I raise a slightly different limitation to consider – tie decay/persistence of these students beyond college. Assuming that people develop new cultural tastes over time, one question is whether cultural matching is still important. If these students no longer share the school context after graduation, can cultural matching continue to protect the strong ties for years and decades? Alternatively, could a strong tie in college with little cultural matching persist in the long term with higher probability than a similarly strong tie with high cultural matching in the absence of shared social context (i.e., university life)?*

* **Status:** `[Addressed]`
* **Location in Manuscript:** Section 5.3 (Limitations and Future Research)
* **Response / Actions Taken:**
  - We thank the reviewer for raising this thoughtful point regarding the long-term temporal horizon of cultural matching across life-course transitions.
  - In Section 5.3 of the revised manuscript (`manuscript-R1.tex`), we have expanded the discussion on the boundaries of cultural matching across post-collegiate life transitions. We explicitly discuss how the removal of shared institutional scaffolding (such as college life, dorms, and campus routines) presents an empirical boundary condition:
    > *"Second, an important question concerns the temporal horizon of cultural matching beyond the collegiate context. Our panel follows students through their undergraduate trajectory, capturing the critical period when campus ties are actively formed and pruned. However, a compelling open question is whether cultural matching continues to sustain social ties across major post-collegiate life transitions---such as graduation, geographic dispersal, labor market entry, and family formation. When individuals no longer share the daily scaffolding of an institutional campus environment, does deep cultural alignment provide the necessary conversational and ritual currency to keep distant ties alive across decades? Alternatively, do enduring collegiate ties persist primarily through accumulated relational history and institutional memory, rendering cultural matching less decisive once physical co-presence ends? Future long-term multi-decade panel studies will be vital for determining the life-course boundaries of cultural matching."*

---

### 5. Measurement of Tie Decay, Sequences, and Rekindling
> **Reviewer Comment (Point 4):**  
> *Measurement of tie decay: Each dyad can exhibit 256 possible sequences presence and absence of ties across the 8 waves (2^8=256). This means that a tie that forms in wave 1 decays in wave 2, but rekindles in wave 3, and so on. How are these different possibilities accounted for? Does rekindling count as persistence? The paper needs to give these details of how the dependent variable is constructed.*

* **Status:** `[Pending]`
* **Location in Manuscript:** Section 3.2 (Variables and Operationalization), Section 3.3 (Analytical Strategy)
* **Response / Actions Taken:**
  - *[Draft response formalizing the discrete-time event history setup, definition of the risk set, handling of first dissolution / spells, and empirical distribution of tie histories]*

---

### 6. Measurement of Cultural Matching: Positive Homophily vs. Shared Dislikes/Disinterest
> **Reviewer Comment (Point 5):**  
> *Measurement of cultural matching: If A and B are both “not at all interested” in music, is that treated as cultural matching, just as when both are “very interested” in music? Does cultural taste rest on what one likes or on what one both likes and does not like? If the latter, then shouldn’t the agreement on dislikes and disinterest also factor into measuring cultural matching?*

* **Status:** `[Pending]`
* **Location in Manuscript:** Section 3.2 (Independent Variables), Section 4 (Robustness Checks)
* **Response / Actions Taken:**
  - *[Draft response explaining scoring rules and reporting sensitivity tests decomposing positive shared interest vs. shared disinterest/indifference]*

---

### 7. Multilevel Modeling: Alters Who Are Also Egos (Two-Way Dyadic Clustering)
> **Reviewer Comment (Point 6):**  
> *Ego-specific random intercept models are less problematic when alters are unlikely to be egos. In this college cohort, however, if the sample constitutes a sizable portion of the cohort, then some alters will also be egos. This violates the random intercept model assumption. In this multilevel modeling setup, an alter or ego-alter tie is the level-1 unit and the ego is the level-2 unit, just like students (level-1) nested in classes (level-2). If alter of student A is also an ego in the sample, then this is akin to a class being treated as a student. How do the authors address this potential issue?*

* **Status:** `[Pending]`
* **Location in Manuscript:** Section 3.3 (Analytical Strategy), Section 4 (Robustness Checks)
* **Response / Actions Taken:**
  - *[Draft response providing cross-classified random effects models `(1 | egoid) + (1 | alterid)` and multi-way clustered standard errors]*

---

### 8. Node Persistence, Sample Retention, and Survivorship Bias
> **Reviewer Comment (Point 7):**  
> *Node persistence: The paper focuses on tie persistence, but the reliability of the results heavily rests on node persistence – sample retention. There needs to be robustness checks to guard against survivorship (selection) bias.*

* **Status:** `[Pending]`
* **Location in Manuscript:** Section 3.1 (Sample and Data), Section 4 (Robustness Checks)
* **Response / Actions Taken:**
  - *[Draft response detailing attrition analysis, sensitivity checks restricted to high-retention egos, and inverse probability weighting / selection checks]*

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
  - Specifically, rather than claiming invariant universal laws governing all human networks across every life stage, we explicitly ground our arguments and findings within the ecological and developmental dynamics of **emerging adulthood and collegiate transitions**—an institutional setting characterized by high baseline churn, geographic concentration, and active identity/network renegotiation.
  - In the Introduction, we now situate cultural matching as a micro-interactional selection and retention mechanism that operates during critical life transitions amidst high baseline turnover.
  - In the Discussion and Section 5.3 (Limitations and Future Research), we clearly delineate the boundary conditions of the study, pointing out how cultural matching operates within high-flux transition ecologies and highlighting the need for future studies in older adult, workplace, and post-collegiate settings.

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
