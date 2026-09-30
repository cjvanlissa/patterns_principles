# Set random seed
set.seed(1346928931)
# Set simulation parameters
n <- 100
# Simulate exogenous nodes
external_event <- rnorm(n = n)
needs <- rnorm(n = n)
# Simulate endogenous nodes
intrinsic_motivation <- 0.1 * needs - 0.27 * external_event + rnorm(n = n)
wellbeing <- 0.33 * needs - 0.09 * intrinsic_motivation + rnorm(n = n)
df <- data.frame(
external_event = external_event,
intrinsic_motivation = intrinsic_motivation,
needs = needs,
wellbeing = wellbeing
)
