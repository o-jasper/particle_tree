
virtual_M(omega, m,p,E,cos_angle) = sqrt(m^2 + 2*omega*(E - p*cos_angle))
virtual_M(omega, m,p,cos_angle) = virtual_M(omega, m,p,sqrt(m^2+p^2),cos_angle)

#Pair production impossible in best case.
no_pair_production_p(volume::Volume, m,p, m_e) =
    (virtual_M(volume.max_soft_photon, m,p,sqrt(m^2+p^2),-1) < 2*m_e)

# Monte-carlo the transport of single path.
# (returning children, not setting them)
function transport(path::Path, volume::Volume)
#Soft photon encountered.
  omega = rand_soft_photon_energy(volume) 
#Cosine of angle of that photon with the current path.
  cos_angle = rand_3d_cos()
#Some current particle infos.
  m = particle_mass(path)
  p = norm(momentum(path))
#Rest mass of product. 
  M = virtual_M(omega, m,p,cos_angle)

  pdg = path.kind.pdg #Get pdg code to see what it does.
#When we go from CM - back to lab-frame, this is the speed to transform.
# Note: the soft photon momentum is ignored.
  beta  = momentum(path)/sqrt(p^2 + M^2) #WARNING _NOT_ energy(path)!
  bgamma = beta_gamma(beta)
#Distance travelled.
  dist   = radiation_distance(volume, path.kind)*randexp()
  end_pos = path.pos + momentum(path)*dist/p
  function lab_frame_particle(kind, E_cm::Number,p_cm)
    Path(kind, end_pos, lorentz_transform_x(E_cm,p_cm, -beta, bgamma))
  end
#Take out photons that are doomed.
  m_e = particle_mass(electron) 
  if pdg==22 && no_pair_production_p(volume::Volume, m,p, m_e)
    return Array(Path,0)
  end
#Particle production _cm means centre-of mass quantities.
  if pdg == 22 #Photon => pair production
    E_cm = M/2 #Just split energy equally
 #TODO i don't think this is a nice way of cutting off.
    if E_cm <= m_e # Nothing happened. (apparently too low energies now.)
      return [Path(path.kind, end_pos, path.momentum)] 
    end
    p_cm = sqrt(E_cm^2 -m_e^2)*rand_3d_direction()
    return [lab_frame_particle(electron, E_cm, +p_cm), #Opposite (anti)electron
            lab_frame_particle(positron, E_cm, -p_cm)]
  else #Else basically assume it is something that just brehmstrahlungs
    norm_p_cm = (M - m^2/M)/2
    p_cm   = norm_p_cm*rand_3d_direction()
    new_m = particle_mass(path.kind)
    return [lab_frame_particle(path.kind, sqrt(new_m^2 + norm_p_cm^2), +p_cm),
            lab_frame_particle(photon,    norm_p_cm,                   -p_cm)]
  end
end
# Destructive version of the previous.
function transport!(path::Path, volume::Volume)
  path.children = transport(path,volume)
end

# Recursively transport a path. (children, grandchildren, etcetera.)
function recursive_transport!(path::Path, volume::Volume, 
                              min_energy::Number, max_depth::Number)
  if max_depth > 0 && energy(path) > min_energy
    transport!(path,volume)
    for p = path.children #Transport children.
      recursive_transport!(p,volume, min_energy, max_depth-1)
    end
  end
end
#Arbitrary function deciding if to continue.
function recursive_transport!(path::Path, volume::Volume, 
                              predicate::Function,data)
  #This is so the function can operate recursively aswel.
  new_data = predicate(path,data)
  if new_data!=nothing
    transport!(path,volume)
    for p = path.children #Transport children
      recursive_transport!(p,volume, predicate,new_data)
    end
  end
end
