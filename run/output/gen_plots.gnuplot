
load "load_fun.gnuplot"

set term png

# 1d plots.
set output "plots/pr.png"
plot"pr" using (ss_pr_x($0)):(log10($1))

set output "plots/pz.png"
plot"pz" using (ss_pz_x($0)):(log10($1))

#set output "plots/pzf.png"
#plot"pzf" using (ss_pzf_x($0)):(log10($1))

set output "plots/r.png"
plot"r" using (ss_r_x($0)):(log10($1))

set output "plots/x.png"
plot"x" using (ss_x_x($0)):(log10($1))

set output "plots/y.png"
plot"y" using (ss_y_x($0)):(log10($1))

set output "plots/z.png"
plot"z" using (ss_z_x($0)):(log10($1))

set output "plots/E.png"
plot"E" using (ss_E_x($0)):(log10($1))

# 2d plots.
set pm3d map

set output "plots/E_r.png"
splot "E_r" matrix using (ss_E_r_x($1)):(ss_E_r_y($2)):(log10($3))

set output "plots/E_z.png"
splot "E_z" matrix using (ss_E_z_x($1)):(ss_E_z_y($2)):(log10($3))

#set output "plots/pzf_z.png"
#splot "pzf_z" matrix using (ss_pzf_z_x($1)):(ss_pzf_z_y($2)):(log10($3))

set output "plots/pz_pr.png"
splot "pz_pr" matrix using (ss_pz_pr_x($1)):(ss_pz_pr_y($2)):(log10($3))

set output "plots/x_y.png"
splot "x_y" matrix using (ss_x_y_x($1)):(ss_x_y_y($2)):(log10($3))

set output "plots/z_r.png"
splot "z_r" matrix using (ss_z_r_x($1)):(ss_z_r_y($2)):(log10($3))
