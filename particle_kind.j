
type ParticleKind
  pdg::Int16
  geant_code::Int16
  mass::Float64
end

ParticleKind(pdg::Integer,geant::Integer, mass::Number) =
    ParticleKind(int16(pdg),int16(geant),float64(mass))

particle_mass(pk::ParticleKind) = pk.mass

const electron_mass = 510998.928
const positron = ParticleKind(-11,2,electron_mass)
const electron = ParticleKind(+11,3,electron_mass)
const photon   = ParticleKind(22,1,0)
const muon_mass = 105.658369e6
const muon     = ParticleKind(6,30, muon_mass)
