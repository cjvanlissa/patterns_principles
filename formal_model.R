# Set random seed
set.seed(640140104)
# Set simulation parameters
n <- 100
# Simulate exogenous nodes
external_event <- rnorm(n = n)
needs <- rnorm(n = n)
# Simulate endogenous nodes
intrinsic_motivation <- -(0.03 * external_event + 0.12 * needs) + rnorm(n = n)
wellbeing <- 0.09 * needs - 0.37 * intrinsic_motivation + rnorm(n = n)
df <- data.frame(
external_event = external_event,
intrinsic_motivation = intrinsic_motivation,
needs = needs,
wellbeing = wellbeing
)
