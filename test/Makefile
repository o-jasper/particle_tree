
default: test

test_nongui: test_bijection

test: test_bijection

test_all: test_bijection test_gnuplot_out test_gl_draw

test_bijection:
	echo Testing bijection;\
	julia bijection.j > result/bijection;
	cd result;\
	echo $(USER)" `git status |wc -l` `git log |head -n 1` time `date +%s` `wc -l bijection`" > /tmp/sdl_bad_utils_test_tmp;\
	cat run_list >> /tmp/sdl_bad_utils_test_tmp;\
	mv /tmp/sdl_bad_utils_test_tmp run_list

test_gnuplot_out:
	echo Testing gnuplot output \(sideview\);\
	julia gnuplot_out.j > result/gnuplot_out.dat;\
	cd result;\
	gnuplot -p -e 'plot "gnuplot_out.dat" using 5:6';\
	echo $(USER)" `git status |wc -l` `git log |head -n 1` time `date +%s`currently no error file for gnuplot_out" > /tmp/sdl_bad_utils_test_tmp;\
	cat run_list >> /tmp/sdl_bad_utils_test_tmp;\
	mv /tmp/sdl_bad_utils_test_tmp run_list

test_gl_draw:
	echo Testing gl drawing;\
	julia gl_draw.j > result/gl_draw; \
	cd result; \
	echo $(USER)" `git status |wc -l` `git log |head -n 1` time `date +%s` `wc -l gl_draw`" > /tmp/sdl_bad_utils_test_tmp;\
	cat run_list >> /tmp/sdl_bad_utils_test_tmp;\
	mv /tmp/sdl_bad_utils_test_tmp run_list
