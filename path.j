
#TODO hmm want to know the parent i think.
#TODO the soft photon has momentum, energy too. Only the latter is
# 'counted in', but regardless, i'd rather have a record of it for consistency
# checks.
type Path 
  kind::ParticleKind 

  pos::Vector{Float64}
  momentum::Vector{Float64}
  children::Array{Path,1} 
end

#Makes array for you, converts number types.
Path(kind::ParticleKind, pos, momentum) =
    Path(kind, float64(pos),float64(momentum), Array(Path,0))

#Provide number for momentum instead of vector.
Path(kind::ParticleKind, pos, momentum::Number) =
    Path(kind, pos, [0,0,momentum])
#Don't provide position, put that just at zero.
Path(kind::ParticleKind, momentum) = 
     Path(kind, [0,0,0], momentum)

# Mass of particle.
particle_mass(path::Path)   = particle_mass(path.kind)

# Momentum and energy of path.
momentum(path::Path) = path.momentum
energy_sqr(thing)    = particle_mass(thing)^2 + norm(momentum(thing))^2
energy(thing)        = sqrt(energy_sqr(thing))

direction(path::Path) = path.momentum/norm(path.momentum)

function energy{T}(list::Array{T,1}) 
  sum = float64(0)
  for el = list
    sum += energy(el)
  end
  return sum
end

function momentum{T}(list::Array{T,1}) 
  sum = float64([0,0,0])
  for el = list
    sum += momentum(el)
  end
  return sum
end

function checknum(x::Number,y::Number, eps::Number, name, more)
  if abs(x-y)>=eps
    throw({name, x,y, eps, abs(x-y), more})
  end
end

#Checks that the sum of the energies, momentum of the children matches
# that of the parent. 
function check_kinematic_consistency(path::Path, epsilon::Number, 
                                     recurse_depth::Integer)
  if isempty(path.children) #Branch wasnt simulated further.(nothing to check)
    return
  end
  p = momentum(path.children)
  E = energy(path.children)
  for i = 1:length(p) #TODO throw stuff?
    checknum(p[i], path.momentum[i], epsilon, :momentum_wrong, path.kind)
  end
  checknum(E^2, energy_sqr(path), epsilon, :energy_wrong, path.kind)
  if recurse_depth>0
    for c in p.children
      check_kinematic_consistency(p, epsilon, recurse_depth-1)
    end
  end
end
check_kinematic_consistency(p::Path, epsilon::Number) =
    check_kinematic_consistency(p, epsilon, typemax(Int32))
check_kinematic_consistency(p::Path) =
    check_kinematic_consistency(p, 1e-3, typemax(Int32))
