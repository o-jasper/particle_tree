
# Monte-carlo the transport of single path.
# (returning children, not setting them)
function transport(path::Path, volume::Volume)
#Soft photon encountered.
  omega = rand_soft_photon_energy(volume) 
#Cosine of angle of that photon with the current path.
  cos_angle = rand_3d_cos()
#Some particle infos.
  m = particle_mass(path)
  p = norm(momentum(path))
  E = sqrt(m^2 + p^2)
#Rest mass of product. 
  M = sqrt(m^2 + 2*omega*(E - p*cos_angle))

  pdg_code = path.kind.pdg_code #Get pdg code to see what it does.
#When we go from CM - back to lab-frame, this is the speed to transform.
# Note: the soft photon momentum is ignored.
  beta  = momentum(path)/energy(path)
  gamma = gamma(beta)
#Distance travelled.
  dist   = radiation_distance(volume, path.kind)*rand_exp()
  end_pos = path.start_pos + direction(momentum(path))*dist
  function lab_frame_particle(kind, p_cm,E_cm)
    Path(kind, end_pos, lorentz_transform_x(p_cm,E_cm, beta, gamma))
  end
#Particle production _cm means centre-of mass quantities.
  if pdg_code == 22 #Photon => pair production
    E_cm = M/2 #Just spit energy equally
    p_cm = sqrt(E_cm^2 - m^2)*rand_3d_direction()
    return [lab_frame_particle(electron, +p_cm,E_cm), #Opposite (anti)electron
            lab_frame_particle(electron, -p_cm,E_cm)]
  else #Else basically assume it is something that just brehmstrahlungs
    norm_p_cm = (M - m^2/M)/2
    p_cm   = norm_p_cm*rand_3d_direction()
    return [lab_frame_particle(path.kind, +p_cm,sqrt(m^2 + norm_p_cm^2)),
            lab_frame_particle(photon,    -p_cm,p_cm)]
  end
end
# Destructive version of the previous.
transport!(path::Path, volume::Volume) = #!
     (path.children = transport(path,volume))

# Recursively transport a path. (children, grandchildren, etcetera.)
function recursive_transport!(path::Path, volume::Volume, 
                              min_energy::Number, max_depth::Number)
  if max_depth > 0 && energy(path) > min_energy
    transport!(path,volume)
    for p = path.children #Transport children.
      recursive_transport!(path,volume, min_energy, max_depth-1)
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
      recursive_transport!(path,volume, predicate,new_data)
    end
  end
end
