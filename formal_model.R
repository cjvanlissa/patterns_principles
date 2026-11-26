# Set random seed
set.seed(809806931)
# Set simulation parameters
n <- 100
# Simulate exogenous nodes
external_event <- rnorm(n = n)
needs <- rnorm(n = n)
# Simulate endogenous nodes
intrinsic_motivation <- -(0.19 * external_event + 0.38 * needs) + rnorm(n = n)
wellbeing <- 0.08 * intrinsic_motivation + 0.55 * needs + rnorm(n = n)
df <- data.frame(
external_event = external_event,
intrinsic_motivation = intrinsic_motivation,
needs = needs,
wellbeing = wellbeing
)
