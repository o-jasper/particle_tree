
## Some constants
alpha = 1/137 #TODO this is better-known
N_A   = 6.022e23

## Special relativity.
gamma(beta) = 1/sqrt(1-beta^2)

# Lorentz transform of time.
lorentz_transform_t(t::Number,x::Vector{Number},beta::Number,gamma::Number) =
    gamma*(t - dot(beta,x))
lorentz_transform_t (t::Number,x::Vector{Number}, beta::Number) = 
    lorentz_transform_t(t,x::Vector{Number}, beta,gamma(beta))

# Lorentz transform of position.
lorentz_transform_x(t::Number,x::Vector{Number},beta::Number,gamma::Number) =
    gamma*(x - beta*t)
lorentz_transform_x (t::Number,x::Vector{Number}, beta::Number) = 
    lorentz_transform_x(t,x::Vector{Number}, beta,gamma(beta))

# Lorentz transform of both time and position.
lorentz_transform(t::Number,x::Vector{Number}, beta::Number, gamma::Number)
    (lorentz_transform_t(t,x::Vector{Number}, beta,gamma), 
     lorentz_transform_x(t,x::Vector{Number}, beta,gamma))

lorentz_transform(t::Number,x::Vector{Number}, beta::Number) =
    lorentz_transform(t,x, beta,gamma(beta))

## Bhremstrahlung and pair production.
brehm_radiation_length (Z,A,r_e) = 
    A/(4*alpha*N_A*Z*(Z+1)*r_e^2*log(183*Z^(-1/3)))

electron_radius = 2.818e-13

brehm_radiation_length (Z,A) = 
    brehm_radiation_length (Z,A,electron_radius)

pair_production_radiation_length (Z,A,r_e) = 
    7/9*brehm_radiation_length (Z,A,r_e)

pair_production_radiation_length (Z,A) = 
    pair_production_radiation_length (Z,A,electron_radius)
    