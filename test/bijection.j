
# Tests if inverses are actually inverses.

tuple_vec2d(vec::Vector) = (vec[1],vec[2])

function test_lorentz_transform(times, eps::Number)
  for n = 1:times
    angle = rand()*pi*2
    beta= rand()*[cos(angle),sin(angle)]
    t = rand()
    x = [rand(),rand()]
    t2,x2 = lorentz_transform(t,x, beta)
    t3,x3 = lorentz_transform(t2,x2, -beta)
    assert(abs(t-t3)<eps, 
           "t unequal; $t !~= $t3 (@beta= $(tuple_vec2d(beta)), n=$n)")
    assert(abs(x[1]-x3[1])<eps && abs(x[2]-x3[2])<eps, 
           "x unequal; $(tuple_vec2d(x)) !~= $(x3[1],x3[2])
           (@beta= $(tuple_vec2d(beta)), n=$n)")
  end
end
test_lorentz_transform() = test_lorentz_transform(1000,0.0001)