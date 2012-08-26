
tuple_vec3d(vec::Vector) = (vec[1],vec[2],vec[3])

function print_gnuplottable(root::Path, stream, what::Function)
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
function print_gnuplottable(root::Path,file::String, what::Function)
  stream = open(file, false, true,true,false,false)
  print_gnuplottable(root,file,what)
  close(file)  
end

print_gnuplottable(p::Path,stream) = 
    print_gnuplottable(p,stream, (x)->(true,true))