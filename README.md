# PROMETHEE_Julia
 
This repository includes the implementation of a function that generates the PROMETHEE I and PROMETHEE II flows (positive, negative, and net flows) using Julia Language.

- The function named Flows_fn is organized in the PROMETHEE_mod module in the PROMETHEE.jl file and an example is provided.
- The main.jl file can be used to prepare the inputs and call PROMETHEE_fn.

Inputs:
1. Decision_Matrix - array of size=(m,n) with the performances of $m$ alternatives regarding $n$ criteria.
2. q_thresholds - a n-dimensional vector receiving indifference thresholds for the criteria
3. p_thresholds - a n-dimensional vector receiving preference thresholds for the criteria
4. scurve_thresholds- a n-dimensional vector receiving the scurve thresholds to be used in case the Gaussian function is chosen
5. weights: a n-dimensional vector receiving weights for the criteria
6. pref_function: a n-dimensional vector receiving as input values between 1 and 5 indicating the preference function for each criterion 
7. alternative_names - vector with the name of the alternatives

Output:
flows - DataFrame including the positive flows, negative flows, and net flows for each alternative.
