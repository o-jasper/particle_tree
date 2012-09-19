
## Some constants
alpha = 1/137 #TODO this is better-known

## Special relativity.
beta_gamma(beta::Number) = 1/sqrt(1-beta^2)
beta_gamma(beta) = 1/sqrt(1-norm(beta)^2)

# Lorentz transform of time.
lorentz_transform_t(t::Number,x,beta,beta_gamma::Number) =
    beta_gamma*(t - dot(beta,x))
lorentz_transform_t (t::Number,x, beta) = 
    lorentz_transform_t(t,x, beta,beta_gamma(beta))

# Lorentz transform of position. #TODO currently incorrect
lorentz_transform_x(t::Number,x,beta::Number,beta_gamma::Number) =
    beta_gamma*(x - beta*t)
function lorentz_transform_x(t::Number,x,beta::Vector,beta_gamma::Number)
  dir = beta/norm(beta)
  x_parallel = dot(dir,x)
  return x-dir*x_parallel + beta_gamma*(x_parallel*dir - beta*t)
end
lorentz_transform_x (t::Number,x, beta) = 
    lorentz_transform_x(t,x, beta,beta_gamma(beta))

# Lorentz transform of both time and position.
lorentz_transform(t::Number,x, beta, beta_gamma::Number) =
    (lorentz_transform_t(t,x, beta,beta_gamma), 
     lorentz_transform_x(t,x, beta,beta_gamma))

lorentz_transform(t::Number,x, beta) =
    lorentz_transform(t,x, beta,beta_gamma(beta))

#TODO it is wrong, but all this doesn't matter much, for now,
# just a factor on all distances
N_A   = 6.022e23
electron_radius = 2.818e-13

## Bhremstrahlung and pair production.
brehm_radiation_length (Z,A,r_e) = 
    A/(4*alpha*N_A*Z*(Z+1)*r_e^2*log(183*Z^(-1/3)))

brehm_radiation_length (Z,A) = 
    brehm_radiation_length (Z,A,electron_radius)

pair_production_radiation_length (Z,A,r_e) = 
    7/9*brehm_radiation_length (Z,A,r_e)

pair_production_radiation_length (Z,A) = 
    pair_production_radiation_length (Z,A,electron_radius)

# Mass of the virtual particle in a soft interaction. TODO better naming.
virtual_M(omega, m,p,E,cos_angle) = sqrt(m^2 + 2*omega*(E - p*cos_angle))
virtual_M(omega, m,p,cos_angle) = 
    virtual_M(omega, m,p,sqrt(m^2+p^2),cos_angle)
