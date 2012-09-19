
#TODO hmm want to know the parent i think.
#TODO the soft photon has momentum, energy too. Only the latter is
# 'counted in', but regardless, i'd rather have a record of it for consistency
# checks.
type ParticleVertex 
  kind::ParticleKind 
  
  pos::Vector{Float64}
  momentum::Vector{Float64}

  process::Any #Process by which it produced children.(nothing not considered)
  children::Array{ParticleVertex,1} 
end

#Makes array for you, converts number types.
ParticleVertex(kind::ParticleKind, pos, momentum) =
    ParticleVertex(kind,float64(pos),float64(momentum), 
                   nothing, Array(ParticleVertex,0))

#Provide number for momentum instead of vector.
ParticleVertex(kind::ParticleKind, pos, momentum::Number) =
    ParticleVertex(kind, pos, [0,0,momentum])
#Don't provide position, put that just at zero.
ParticleVertex(kind::ParticleKind, momentum) = 
     ParticleVertex(kind,[0,0,0], momentum)

copy(p::ParticleVertex) = 
    ParticleVertex(p.kind, p.pos,p.momentum,p.process,p.children)

# Mass of particle.
particle_mass(path::ParticleVertex)   = particle_mass(path.kind)

# Momentum and energy of path.
momentum(path::ParticleVertex) = path.momentum
energy_sqr(thing)    = particle_mass(thing)^2 + norm(momentum(thing))^2
energy(thing)        = sqrt(energy_sqr(thing))
# Of 'nothing', for instance if process not filled in.
momentum(n::Nothing) = float64([0,0,0])
energy(n::Nothing)   = float64(0)

direction(path::ParticleVertex) = path.momentum/norm(path.momentum)

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

eps_eql(a,b, eps) = ( abs(2*(a-b)/(a+b)) < eps )

function checknum(x::Number,y::Number, eps::Number, name, more)
  if !eps_eql(x,y, eps)
    println("$name wrong before, $x after $y (eps $eps)")
    println(more)
  end
end

#Checks that the sum of the energies, momentum of the children matches
# that of the parent. 
function check_kinematic_consistency(path::ParticleVertex, epsilon::Number, 
                                     recurse_depth::Integer)
  if isempty(path.children) #Branch wasnt simulated further.(nothing to check)
    return
  end
  p = momentum(path.children) #Check momentum.
  before_p = momentum(path) + momentum(path.process)
  for i = 1:length(p) #TODO throw stuff?
    checknum(before_p[i],p[i], epsilon, :momentum, 
             momentum(path.process))
      #path.kind)
  end
#TODO the energy accounting doesn't quite add up..
# rounding errors can't be that big with float64.
  E = energy(path.children) #Check energy. 
  before_E = energy(path) + energy(path.process)
  checknum(before_E,E, epsilon, :energy, path.process)
  if recurse_depth>0
    for c in path.children
      check_kinematic_consistency(c, epsilon, recurse_depth-1)
    end
  end
end
check_kinematic_consistency(p::ParticleVertex, epsilon::Number) =
    check_kinematic_consistency(p, epsilon, typemax(Int32))
check_kinematic_consistency(p::ParticleVertex) =
    check_kinematic_consistency(p, 1e-6, typemax(Int32))
