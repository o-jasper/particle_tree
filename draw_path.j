
function path_colorb{K}(kind::K) 
  r,g,b,a = path_color(kind)
  return (int8(r*127), int8(g*127), int8(b*127), int8(a*127))
end

function path_color(kind::ParticleKind)
  @case kind.pdg begin
    -11 : (0.7,0.7,1,1)
    11  : (0.7,0.7,1,1)
    22  : (0.4,  0.4,  0,0.1)
    6   : (1,  0,  1,1)
  end
end

#If name has `vertex`, `glbegin` the primitive yourself. 
# (Likely using @with_primitive)

#Enter the vertex with color of itself.
function vertex_self_path(parent_pos::Vector{Float64}, p::ParticleVertex)
  if p.kind.pdg!=22
    glcolorb(path_colorb(p.kind))
    glvertex(parent_pos)
    glvertex(p.pos)
  end
end
vertex_self_path(parent::ParticleVertex, p::ParticleVertex) = 
    vertex_self_path(parent.pos, p) #!

#Enter lining-vertices of children upto given depth.
function vertex_paths(p::ParticleVertex, max_depth::Integer)
  for child in p.children
    vertex_self_path(p, child)
    if max_depth>0
      vertex_paths(child, max_depth - 1)
    end
  end
end
#Defaults to everything.
vertex_paths(p::ParticleVertex) = vertex_paths(p, typemax(Int64))

#Does what the `vertex_path` does, but actually draws it.
draw_paths(p::ParticleVertex, max_depth::Integer) = #!
    @with_primitive GL_LINES vertex_paths(p, max_depth)

draw_paths(p::ParticleVertex) = #!
    @with_primitive GL_LINES vertex_paths(p)

#Enter vertices of each position.(not in shape of lines)
function vertex_self_pos(p::ParticleVertex)
  glcolorb(path_colorb(p.kind))
  glvertex(p.pos)
end
#Enter vertices of children upto given depth.
function vertex_pos(p::ParticleVertex, max_depth::Integer)
  for child in p.children
    vertex_self_pos(p, child)
    if max_depth>0
      vertex_pos(child, max_depth - 1)
    end
  end
end
#Defaults to everything.
vertex_pos(p::ParticleVertex) = vertex_pos(p, typemax(Int64))
