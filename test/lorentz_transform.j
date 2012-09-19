load("simple_sim/phys_math.j")
load("simple_sim/test/funs.j")

#lorentz_transform
function test_lorentz_transform(times, eps)
  for n = 1:times
    angle = rand()*pi*2
    beta= rand()*[cos(angle),sin(angle)]
    t = rand()
    x = [rand(),rand()]
    t2,x2 = lorentz_transform(t,x, beta)
    t3,x3 = lorentz_transform(t2,x2, -beta)

    say_beta = "beta $beta |beta| $(norm(beta)))"
    assert(eps_eql(t,t3, eps), 
           "t unequal; $t !~= $t3 ($say_beta), n=$n)")
    assert(eps_eql(x[1],x3[1],eps) && eps_eql(x[2], x3[2], eps),
           "x unequal; $(tuple_vec2d(x)) !~= $(tuple_vec2d(x3))
           ($say_beta), n=$n)")
    m_sqr  = norm(x)^2 - t^2
    m2_sqr = norm(x2)^2 - t2^2
    assert(eps_eql(m_sqr, m2_sqr, eps), 
           "\"mass\"(squared) not equal after lorentz transform. 
$m_sqr vs $m2_sqr ($say_beta)")
  end
end

#NOTE i think 1e-10 is high..
test_lorentz_transform(1000,1e-10) #TODO ultrarelativistic rounding error ?