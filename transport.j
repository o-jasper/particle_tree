
#Pair production impossible in best case.
no_pair_production_p(volume::Volume, m,p, m_e) =
    (virtual_M(volume.max_soft_photon, m,p,sqrt(m^2+p^2),-1) < 2*m_e)

#Indicates a soft particle from the material is the process in question.
type ProcessSoftly
  soft_particle::ParticleKind #Currently always photons.
  energy::Float64 #Energy and momentum of particle.
  momentum::Array{Float64,1} #Note if length 0, ignored_momentum_p==true
  cos_angle::Float64 #(Exact direction doesn't matter much)
  
  ignored_momentum_p::Bool
  ignored_energy_p::Bool #If the energy, momentum where assumed neglible.
  
  flattened_momentum_p::Bool
end

momentum(process::ProcessSoftly) = 
    process.ignored_momentum_p ? float64([0,0,0]) : process.momentum
energy(process::ProcessSoftly) =
    process.ignored_energy_p ? float64(0) : process.energy

#For energies too low to actually do the process.
type ProcessSoftlyDropout
end
momentum(process::ProcessSoftlyDropout) = float64([0,0,0])
energy(process::ProcessSoftlyDropout)   = float64(0)

# Monte-carlo the transport of single path.
# (returning children, not setting them)
function transport(path::ParticleVertex, volume::Volume)
  #Cosine of angle of that photon with the current path.
  cos_angle = rand_3d_cos()
#Soft photon encountered. #TODO constrain min_soft_photon with minimum energy
# needed (dependent on cos_angle ithink)
  omega = rand_soft_photon_energy(volume) 

#Some current particle infos.
  m = particle_mass(path)
  p = norm(momentum(path))
  #Register the soft photon as being the process involved.
  flat_momentum = momentum(path)*omega*cos_angle/p
  path.process = ProcessSoftly(photon, omega,flat_momentum, cos_angle,
                               false,false, true)
#Rest mass of product. 
  M = virtual_M(omega, m,p,cos_angle)

  pdg = path.kind.pdg #Get pdg code to see what it does.
#When we go from CM - back to lab-frame, this is the speed to transform.
# Note: the soft photon momentum is ignored.
  #WARNING _NOT_ energy(path)!
  final_p = momentum(path) + flat_momentum
  final_E = sqrt(M^2 + norm(final_p)^2)
#  assert(final_E == omega + energy(path), #Presumed problem.
#         "$final_E != $(omega + energy(path))")
  beta,bgamma  = final_p/final_E, final_E/M
#Distance travelled.
  dist   = radiation_distance(volume, path.kind)*randexp()
  end_pos = path.pos + momentum(path)*dist/p
  #Creates a particle in the lab frome 
  function lab_frame_particle(kind, E_cm::Number,p_cm)
    ParticleVertex(kind, end_pos, 
                   lorentz_transform_x(E_cm,p_cm, -beta, bgamma))
  end
#Take out photons that can no longer pair-produce.
  m_e = particle_mass(electron) 
  if pdg==22 && no_pair_production_p(volume, m,p, m_e)
    return Array(ParticleVertex,0)
  end
#Particle production _cm means centre-of mass quantities.
  if pdg == 22 #Photon => pair production
    E_cm = M/2 #Just split energy equally
 #TODO i don't think this is a nice way of cutting off.
    if E_cm <= m_e # Nothing happened. (apparently too low energies now.)
      path.process = ProcessSoftlyDropout()
      return [ParticleVertex(path.kind, end_pos, path.momentum)] 
    end
    p_cm = sqrt(E_cm^2 -m_e^2)*rand_3d_direction()
    return [lab_frame_particle(electron, E_cm, +p_cm),#Opposite (anti)electron
            lab_frame_particle(positron, E_cm, -p_cm)]
  else #Else basically assume it is something that just brehmstrahlungs
    norm_p_cm = (M - m^2/M)/2
    p_cm   = norm_p_cm*rand_3d_direction()
    new_m = particle_mass(path.kind)
    return [lab_frame_particle(path.kind, sqrt(new_m^2 + norm_p_cm^2), +p_cm),
            lab_frame_particle(photon,    norm_p_cm,                   -p_cm)]
  end
end
#For multiple recordings at the same time, just list them.
function record(arr::Vector{Any}, path::ParticleVertex, 
                children::Vector{ParticleVertex})
  for r in arr
    record(r, path,children)
  end
end
type RecordEntireTree #Indicates to record the entire tree and return that.
end
record(entire::RecordEntireTree, path::ParticleVertex, 
       children::Vector{ParticleVertex}) = #!
    (path.children = children)

#If tree is recorded, other recorders can be send afterwards.(of course)
function record_recursively{R}(recorder::R, path::ParticleVertex)
  record(recorder, path, path.children)
  for c in path.children
    record_recursively(recorder, c)
  end
end

# Recursively transport a path. (children, grandchildren, etcetera.)
function recursive_transport{R}(path::ParticleVertex, volume::Volume, 
                                min_energy::Number, max_depth::Number,
                                recorder::R)
  if max_depth > 0 && energy(path) > min_energy
    children = transport(path,volume)
    record(recorder, path, children) #Allows you to record stuff.
    for p = children #Transport children.
      recursive_transport(p,volume, min_energy, max_depth-1, recorder)
    end
  end
  return path
end
#Arbitrary function deciding if to continue.
function recursive_transport{R}(path::ParticleVertex, volume::Volume, 
                                predicate::Function,data, recorder::R)
  #This is so the function can operate recursively aswel.
  new_data = predicate(path,data)
  if new_data!=nothing
    children = transport(path,volume)
    record(recorder, path, children)
    for p = children #Transport children
      recursive_transport(p,volume, predicate,new_data, recorder)
    end
  end
  return path
end
