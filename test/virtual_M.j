#
#  Copyright (C) 10-10-2012 Jasper den Ouden.
#
#  This is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#

load("simple_sim/phys_math.j")
load("simple_sim/test/funs.j")

#virtual_M
function test_virtual_M(omega, m,p,E,cos_angle, eps)
  M = virtual_M(omega, m,p, E,cos_angle)
  #Now determine the energy in the lab frame and check it.
  p_lab_sqr = p^2 + omega^2 + 2*p*omega*cos_angle
  E_lab = sqrt(M^2 + p_lab_sqr)
  if !eps_eql(E_lab, E + omega, eps)
    println("virtual_M: energy conservation failed: 
$E_lab != $E + $omega = $(E+omega) (fraction epsilon $eps)")
  end
end
test_virtual_M(omega, m,p,cos_angle, eps) = 
    test_virtual_M(omega, m,p,sqrt(m^2+p^2), cos_angle, eps) 

function test_virtual_M(cnt::Integer, eps)
  for n = 1:cnt
    m,p = rand(),10.0^(20*rand()) #Big numbers likely.
    test_virtual_M(rand(), m,p, -1+2*rand(), eps)
  end
end

test_virtual_M(1000, 1e-15)
