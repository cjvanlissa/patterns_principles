# Set random seed
set.seed(2037265312)
# Set simulation parameters
n <- 100
# Simulate exogenous nodes
external_event <- rnorm(n = n)
needs <- rnorm(n = n)
# Simulate endogenous nodes
intrinsic_motivation <- 0.4 * external_event - 0.16 * needs + rnorm(n = n)
wellbeing <- -(0.12 * intrinsic_motivation + 0.53 * needs) + rnorm(n = n)
df <- data.frame(
external_event = external_event,
intrinsic_motivation = intrinsic_motivation,
needs = needs,
wellbeing = wellbeing
)
