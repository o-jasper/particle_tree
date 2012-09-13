
#Histograms a lot of things about particle vertices.
type HistogramParticleVertices
  z_r::Histogram2dExpanding
  x_y::Histogram2dExpanding # Of course, expect rotational symmetry.
  pz_pr::Histogram2dExpanding
  E_z::Histogram2dExpanding
  E_r::Histogram2dExpanding
  pzf_z::Histogram2dExpanding
end

function HistogramParticleVertices(dE::Number,dp::Number,
                                   dt::Number,dx::Number, df::Number)
  xx_hist() = Histogram2dExpanding((0,0),(dx,dx))
  pp_hist() = Histogram2dExpanding((0,0),(dp,dp))
  Ex_hist() = Histogram2dExpanding((0,0),(dE,dx))
  fx_hist() = Histogram2dExpanding((0,0),(df,dx))
  return HistogramParticleVertices(xx_hist(),xx_hist(), pp_hist(),
                                   Ex_hist(),Ex_hist(), fx_hist())
end

#To be consistent with the other stuff, and using these, there is flexibility
# to change the implementation underneath.
z_r(h::Histogram2dExpanding)   = h.zr
x_y(h::Histogram2dExpanding)   = h.x_y
pz_pr(h::Histogram2dExpanding) = h.pz_pr
E_z(h::Histogram2dExpanding)   = h.E_z
E_r(h::Histogram2dExpanding)   = h.E_r
pzf_z(h::Histogram2dExpanding) = h.pzf_z

# 1d histograms from the 2d ones.
x(h::HistogramParticleVertices)   = hist_x(x_y(h))
y(h::HistogramParticleVertices)   = hist_y(x_y(h))
z(h::HistogramParticleVertices)   = hist_x(z_r(h))
wr(h::HistogramParticleVertices)  = hist_y(z_r(h))
pz(h::HistogramParticleVertices)  = hist_x(pz_pr(h))
pr(h::HistogramParticleVertices)  = hist_y(pz_pr(h))
E(h::HistogramParticleVertices)   = hist_x(E_z(h))
pzf(h::HistogramParticleVertices) = hist_x(pzf_z(h))

#Incorporate a single particle vertex.
function incorporate(path::ParticleVertex, h::HistogramParticleVertices)
  x,y,z = path.pos[1],path.pos[2],path.pos[3]
  r = sqrt(x^2 + y^2)
  pz,pr = path.momentum[2], sqrt(path.momentum[1]^2 + path.momentum[2]^2)
  E = energy(path)
  incorporate(h.z_r,     (z,r))
  incorporate(h.x_y,     (x,y))
  incorporate(h.pz_pr,   (pz,pr))
  incorporate(h.E_z,     (E,z))
  incorporate(h.pzf_z,   pz/sqrt(pr^2 + pz^2))
end

function incorporate_recursively(path::ParticleVertex, 
                                 h::HistogramParticleVertices)
  incorporate(path,h)
  for c in path.children
    incorporate_recursively(c,h)
  end
end

function gnuplot_write(h::HistogramParticleVertices, prepend_file::String)
  gnuplot_write(z_r(h),  "$(prepend_file)z_r")
  gnuplot_write(x_y(h),  "$(prepend_file)x_y")
  gnuplot_write(pz_pr(h),"$(prepend_file)pz_pr")
  gnuplot_write(E_z(h),  "$(prepend_file)E_z")
  gnuplot_write(E_r(h),  "$(prepend_file)E_r")
  gnuplot_write(pzf_z(h),"$(prepend_file)pzf_z")
  
  gnuplot_write(x(h),  "$(prepend_file)x")
  gnuplot_write(y(h),  "$(prepend_file)y")
  gnuplot_write(z(h),  "$(prepend_file)z")
  gnuplot_write(wr(h), "$(prepend_file)wr")
  gnuplot_write(pz(h), "$(prepend_file)pz")
  gnuplot_write(pr(h), "$(prepend_file)pr")
  gnuplot_write(E(h),  "$(prepend_file)E")
  gnuplot_write(pzf(h),"$(prepend_file)pzf")
end
