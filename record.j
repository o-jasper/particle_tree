
#Histograms a lot of things about particle vertices.
type HistogramParticleVertices
  z_r::Field2d{ExpandingArray2d{Int64}}
  x_y::Field2d{ExpandingArray2d{Int64}}
  pz_pr::Field2d{ExpandingArray2d{Int64}}
  E_z::Field2d{ExpandingArray2d{Int64}}
  E_r::Field2d{ExpandingArray2d{Int64}}
  pzf_z::Field2d{ExpandingArray2d{Int64}}
end

function HistogramParticleVertices(dE::Number,dp::Number,
                                   dt::Number,dx::Number, df::Number)
  mk_field(dx,dy) = Field2d(0,0, dx,dy, ExpandingArray2d(Int64))
  xx_hist() = mk_field(dx,dx)
  pp_hist() = mk_field(dp,dp)
  Ex_hist() = mk_field(dE,dx)
  fx_hist() = mk_field(df,dx)
  return HistogramParticleVertices(xx_hist(),xx_hist(), pp_hist(),
                                   Ex_hist(),Ex_hist(), fx_hist())
end

#To be consistent with the other stuff, and using these, there is flexibility
# to change the implementation underneath.
z_r(h::HistogramParticleVertices)   = h.z_r
x_y(h::HistogramParticleVertices)   = h.x_y
pz_pr(h::HistogramParticleVertices) = h.pz_pr
E_z(h::HistogramParticleVertices)   = h.E_z
E_r(h::HistogramParticleVertices)   = h.E_r
pzf_z(h::HistogramParticleVertices) = h.pzf_z

# 1d histograms from the 2d ones.
x(h::HistogramParticleVertices)   = hist_x(x_y(h))
y(h::HistogramParticleVertices)   = hist_y(x_y(h))
z(h::HistogramParticleVertices)   = hist_x(z_r(h))
r(h::HistogramParticleVertices)   = hist_y(z_r(h))
pz(h::HistogramParticleVertices)  = hist_x(pz_pr(h))
pr(h::HistogramParticleVertices)  = hist_y(pz_pr(h))
E(h::HistogramParticleVertices)   = hist_x(E_z(h))
pzf(h::HistogramParticleVertices) = hist_x(pzf_z(h))

#Incorporate a single particle vertex.
function incorporate(h::HistogramParticleVertices, path::ParticleVertex)
  x,y,z = path.pos[1],path.pos[2],path.pos[3]
  r = sqrt(x^2 + y^2)
  pz,pr = path.momentum[3], sqrt(path.momentum[1]^2 + path.momentum[2]^2)
  E = energy(path)
  incorporate(h.z_r,     z,r)
  incorporate(h.x_y,     x,y)
  incorporate(h.pz_pr,   pz,pr)
  incorporate(h.E_z,     E,z)
  incorporate(h.E_r,     E,r)
#  incorporate(h.pzf_z,   pz/sqrt(pr^2 + pz^2), z) #range?
end

record(h::HistogramParticleVertices, path::ParticleVertex, 
       children::Vector{ParticleVertex}) =
    incorporate(h, path)

incorporate_recursively(h::HistogramParticleVertices,
                        path::ParticleVertex) =
    record_recursively(h,path)

function gnuplot_write(h::HistogramParticleVertices, prepend_file::String)
  prep_file(name) = "$prepend_file/$name"

  dlmwrite_any(prep_file("z_r"),   z_r(h))
  dlmwrite_any(prep_file("x_y"),   x_y(h))
  dlmwrite_any(prep_file("pz_pr"), pz_pr(h))
  dlmwrite_any(prep_file("E_z"),   E_z(h))
  dlmwrite_any(prep_file("E_r"),   E_r(h))
  dlmwrite_any(prep_file("pzf_z"), pzf_z(h))
  
  dlmwrite_any(prep_file("x"),  indexless_iter(x(h).arr))
  dlmwrite_any(prep_file("y"),  indexless_iter(y(h).arr))
  dlmwrite_any(prep_file("z"),  indexless_iter(z(h).arr))
  dlmwrite_any(prep_file("r"),  indexless_iter(r(h).arr))
  dlmwrite_any(prep_file("pz"), indexless_iter(pz(h).arr))
  dlmwrite_any(prep_file("pr"), indexless_iter(pr(h).arr))
  dlmwrite_any(prep_file("E"),  indexless_iter(E(h).arr))
  dlmwrite_any(prep_file("pzf"),indexless_iter(pzf(h).arr))

  gnuplot_gen_funs(h, "$prepend_file/load_fun.gnuplot");
end
#Generates gnuplot functions for getting positions of stuff in the histograms.
function gnuplot_gen_funs(h::HistogramParticleVertices, s::IOStream)
  function pfun1(name,hist)
    fi = min_i(hist.arr)
    write(s, "$(name)_x(i) = $(hist.s) + $(hist.d)*(i + $fi)\n\n")
  end
  function pfun2(name,hist)
    fi,fj = min_i(hist.arr),min_j(hist.arr)
    write(s, "$(name)_x(i) = $(hist.sx) + $(hist.dx)*(i + $fi)\n")
    write(s, "$(name)_y(j) = $(hist.sy) + $(hist.dy)*(j + $fj)\n\n")
  end
  #TODO this can be done better.
  pfun2("z_r",   z_r(h))
  pfun2("x_y",   x_y(h))
  pfun2("pz_pr", pz_pr(h))
  pfun2("E_z",   E_z(h))
  pfun2("E_r",   E_r(h))
  pfun2("pzf_z", pzf_z(h))
  
  pfun1("x",  x(h))
  pfun1("y",  y(h))
  pfun1("z",  z(h))
  pfun1("r",  r(h))
  pfun1("pz", pz(h))
  pfun1("pr", pr(h))
  pfun1("E",  E(h))
  pfun1("pzf",pzf(h))
end

gnuplot_gen_funs(h::HistogramParticleVertices, file::String) =
    @with_open_file s file "w" gnuplot_gen_funs(h,s)
  