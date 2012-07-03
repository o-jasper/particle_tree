
type Path
  kind::ParticleKind

  start_pos::Vector{Float64}
  momentum::Vector{Float64}
  children::Array{Path,1} 
end

#Makes array for you, converts number types.
Path(kind::ParticleKind, start_pos, momentum) =
    Path(kind, float64(start_pos),float64(momentum), Array(Path,0))

#Provide number for momentum instead of vector.
Path(kind::ParticleKind, start_pos, momentum::Number) =
    Path(kind, start_pos, [0,0,momentum])
#Don't provide position, put that just at zero.
Path(kind::ParticleKind, momentum) = 
     Path(kind, [0,0,0], momentum)

# Mass of particle.
particle_mass(path::Path)   = particle_mass(path.kind)

# Momentum and energy of path.
momentum(path::Path) = path.momentum
energy_sqr(thing)    = particle_mass(thing) + norm(momentum(thing))^2
energy(thing)        = sqrt(energy_sqr(thing))

direction(path::Path) = path.momentum/norm(path.momentum)

function energy(list::Vector) 
  sum = float64(0)
  for el = list
    sum += energy(el)
  end
  return sum
end

function momentum(list::Vector) 
  sum = float64([0,0,0])
  for el = list
    sum += momentum(el)
  end
  return sum
end
