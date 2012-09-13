
#Tests if things that should conserve things actually do.

load("simple_sim/phys_math.j")

eps_eql(a,b, eps) = ( abs(2*(a-b)/(a+b)) < eps )

function test_virtual_M(omega, m,p,E,cos_angle, eps)
  M = virtual_M(omega, m,p, E,cos_angle)
  #Now determine the energy in the lab frame and check it.
  E_lab = sqrt(M^2 + p^2 + omega^2 + 2*p*omega*cos_angle)
  if !eps_eql(E_lab, E + omega, eps)
    println("virtual_M: energy conservation failed: 
$E_lab != $E + $omega = $(E+omega) (fraction epsilon $eps)")
  end
end

function test_virtual_M(cnt::Integer, eps)
  for n = 1:cnt
    m,p = rand(),rand()
    test_virtual_M(rand(), m,p,sqrt(m^2+p^2), -1+2*rand(), eps)
  end
end

test_virtual_M(1000, 1e-14)
