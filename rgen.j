#
#  Copyright (C) 10-10-2012 Jasper den Ouden.
#
#  This is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#

#Probability distribution sample regeneration.

#Exponential distribution. (Turns out Julia already had one.)
#rand_exp(at_prob::Float64) = -log(1-at_prob)
#rand_exp()                 = rand_exp(rand())

#1/w distribution (for the soft photon spectrum)
rand_one_over_x(min::Number,max::Number, at_prob::Float64) =
    min*(max/min)^at_prob
rand_one_over_x(min::Number,max::Number) = rand_one_over_x(min,max,rand())

#Random cosine. 
rand_3d_cos (at_prob::Float64) = 2*at_prob - 1
rand_3d_cos  () = rand_3d_cos(rand())

#Random direction.
function rand_3d_direction (p1::Float64, p2::Float64) 
  cos_theta = rand_3d_cos(p1)
  sin_theta = sqrt(1-cos_theta^2)
  phi = 2*pi*p2
  return [sin_theta*cos(phi), sin_theta*sin(phi), cos_theta]
end

rand_3d_direction() = rand_3d_direction(rand(),rand())