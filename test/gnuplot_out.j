#
#  Copyright (C) 10-10-2012 Jasper den Ouden.
#
#  This is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#

load("simple_sim/load.j")

#Outputs tabbed: pdg code, energy, E. x,y,z, px,py,pz
# so for tree `gnuplot "file.dat" using 4:5` gets a x,y projection.
function run_this()

  vol = Volume(1e3,1e6, 82,207.2,1)
  
  for n = 1:1
    p = ParticleVertex(muon, 1e9)
    recursive_transport!(p,vol, 1e6, 100)
    print_gnuplottable(p, stdout_stream)
  end
end

run_this()