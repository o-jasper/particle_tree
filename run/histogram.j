
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
  
  record = HistogramParticleVertices(5e4,5e4, 1,0.1,1)
  println("Started")
  for k = 1:n
    p = ParticleVertex(electron, float64([0,0,1e7]))
    recursive_transport(p,vol, 1e5, 100, record)
    if k%10 == 1
      println(k)
    end
  end  
  #TODO WARNING absolute directory!
  gnuplot_write(record, "/home/jasper/uni-proj/focal/simple_sim/run/output/")
end

run_this(100)
