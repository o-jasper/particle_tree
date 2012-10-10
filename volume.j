#
#  Copyright (C) 10-10-2012 Jasper den Ouden.
#
#  This is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#

type Volume
  min_soft_photon::Float64
  max_soft_photon::Float64
  
  Z::Float64  #Z,A are integers, but this can humor you.
  A::Float64
  
  density::Float64 #Note: can probably make a good guess, but..

#Calculated defaultly:
  brehm_radiation_length::Float64
end

Volume(min_soft::Number,max_soft::Number, Z::Number,A::Number, 
       density::Number) =
    Volume(float64(min_soft),float64(max_soft), float64(Z),float64(A),
           float64(density), brehm_radiation_length(Z,A))

#Radiation distance, (as opposed to length) in length units.
# NOTE: currently only HE
radiation_distance(volume::Volume, kind::ParticleKind) =
    (kind.pdg==22 ? 7/9 : 1)*
    volume.brehm_radiation_length/volume.density
#Generates energy of soft photon
rand_soft_photon_energy(volume::Volume) =
    rand_one_over_x(volume.min_soft_photon, volume.max_soft_photon)
