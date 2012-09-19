
load "load_fun.gnuplot"

set term png

# 1d plots.
set output "plots/pr.png"
plot"pr" using (pr_x($0)):(log10($1))

set output "plots/pz.png"
plot"pz" using (pz_x($0)):(log10($1))

#set output "plots/pzf.png"
#plot"pzf" using (pzf_x($0)):(log10($1))

set output "plots/r.png"
plot"r" using (r_x($0)):(log10($1))

set output "plots/x.png"
plot"x" using (x_x($0)):(log10($1))

set output "plots/y.png"
plot"y" using (y_x($0)):(log10($1))

set output "plots/z.png"
plot"z" using (z_x($0)):(log10($1))

set output "plots/E.png"
plot"E" using (E_x($0)):(log10($1))

# 2d plots.
set pm3d map

set output "plots/E_r.png"
splot "E_r" matrix using (E_r_x($1)):(E_r_y($2)):(log10($3))

set output "plots/E_z.png"
splot "E_z" matrix using (E_z_x($1)):(E_z_y($2)):(log10($3))

#set output "plots/pzf_z.png"
#splot "pzf_z" matrix using (pzf_z_x($1)):(pzf_z_y($2)):(log10($3))

set output "plots/pz_pr.png"
splot "pz_pr" matrix using (pz_pr_x($1)):(pz_pr_y($2)):(log10($3))

set output "plots/x_y.png"
splot "x_y" matrix using (x_y_x($1)):(x_y_y($2)):(log10($3))

set output "plots/z_r.png"
splot "z_r" matrix using (z_r_x($1)):(z_r_y($2)):(log10($3))
