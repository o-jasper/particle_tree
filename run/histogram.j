
load("load.j")

load("util/util.j")
load("util/dlmwrite_iter.j")

load("util/ExpandingArray.j")
load("julia-glplot/Field.j")
load("julia-glplot/Field2d.j")
load("julia-glplot/Histogram2d.j")

load("record.j")

#Idea is to histogram a lot of stuff.

function run_this(n::Integer)

  vol = Volume(1e3,1e6, 82,207.2,1)
  
  record = HistogramParticleVertices(5e4,5e4, 1,1,1)
  for k = 1:n
    if k%10 == 0
      println(k)
    end
    p = ParticleVertex(electron, float64([0,0,1e8]))
    p = recursive_transport(p,vol, 1e6, 100)
    incorporate_recursively(record, p)
  end  
  #TODO WARNING absolute directory!
  gnuplot_write(record, "/home/jasper/uni-proj/focal/simple_sim/run/output/")
end

run_this(200)
