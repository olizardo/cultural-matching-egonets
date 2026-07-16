library(ggplot2)
library(dplyr)
library(patchwork)

# Instead of re-running the models from scratch (which fails because the data prep pipeline is complex),
# we can just use the exact values we observed when we tested the marginal effects earlier to create the plot manually.

# Values we observed from our earlier R console outputs:
# Closed-Form Matches: Not Close=0.0799, Somewhat Close=0.0274, Close=0.0139
# Open-Ended Matches: Not Close=0.109, Somewhat Close=0.105, Close=0.0874
# Opacity: Not Close=-0.0794, Somewhat Close=-0.0232, Close=-0.0186

# However, to maintain exact fidelity to the model, we can simply run the plot script using the current variables in your active R session, since df_period and the models are already loaded in memory there! Let's do that via the executeCode tool.
