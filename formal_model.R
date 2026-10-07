# Set random seed
set.seed(96355564)
# Set simulation parameters
n <- 100
# Simulate exogenous nodes
external_event <- rnorm(n = n)
needs <- rnorm(n = n)
# Simulate endogenous nodes
intrinsic_motivation <- -(0.31 * needs + 0.57 * external_event) + rnorm(n = n)
wellbeing <- -(0.2 * intrinsic_motivation + 0.32 * needs) + rnorm(n = n)
df <- data.frame(
external_event = external_event,
intrinsic_motivation = intrinsic_motivation,
needs = needs,
wellbeing = wellbeing
)
