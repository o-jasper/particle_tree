#
#  Copyright (C) 10-10-2012 Jasper den Ouden.
#
#  This is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#

#TODO goddamn, there are two geant codes.. Check if things are right..
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
const muon     = ParticleKind(13,6, muon_mass)
