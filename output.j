#
#  Copyright (C) 10-10-2012 Jasper den Ouden.
#
#  This is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#

tuple_vec3d(vec::Vector) = (vec[1],vec[2],vec[3])

function print_gnuplottable(root::ParticleVertex, stream, what::Function)
  x,y,z = tuple_vec3d(root.pos)
  px,py,pz = tuple_vec3d(root.momentum)
  E = energy(root)
#Writes kind and 
  continue_after,write_it = what(root)
  if write_it
    write(stream, "$(root.kind.pdg)\t$E\t$x\t$y\t$z\t$px\t$py\t$pz\n")
  end
  if continue_after
    for p = root.children
      print_gnuplottable(p, stream,what)
    end
  end
end

#TODO with_open
function print_gnuplottable(root::ParticleVertex,file::String, what::Function)
  stream = open(file, false, true,true,false,false)
  print_gnuplottable(root,file,what)
  close(file)  
end

print_gnuplottable(p::ParticleVertex,stream) = 
    print_gnuplottable(p,stream, (x)->(true,true))