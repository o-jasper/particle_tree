
type ParticleKind
  pdg_code::Int16
  geant_code::Int16
  mass::Float64
end

particle_mass(pk::ParticleKind) = pk.mass

const electron_mass = 1 #TODO less lazy
const positron = ParticleKind(-11,2,electron_mass)
const electron = ParticleKind(+11,3,electron_mass)
const photon   = ParticleKind(22,1,0)
