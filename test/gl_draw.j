#
#  Copyright (C) 22-08-2012 Jasper den Ouden.
#
#  This is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#

load("simple_sim/load.j")

load("load_so.j")
load("get_c.j")
load("sdl_bad_utils/init_stuff.j")

load("autoffi/gl.j")
load("gl_util.j")

load("sdl_bad_utils/sdl_event.j")

load("simple_sim/draw_path.j")

function run_this ()
  screen_width = 640
  screen_height = 640
  init_stuff()

  mx(i) = -1 + 2*i/screen_width
  my(j) = +1 - 2*j/screen_height
  mx()  = mx(mouse_x())
  my()  = my(mouse_y())

  wait_t = 0.1
  next_t = time() + wait_t
  tree_cnt = 0

  vol = Volume(1e3,1e6, 82,207.2,1)

  function transport_path()
#    path = Path(muon, [0,1e9,0])
    path = Path(electron, [0,1e8,0])
    recursive_transport!(path,vol, 1e6, 100)
    return path
  end
  cur_path = transport_path()
    
  glenable(GL_BLEND)
  list = {} 
  glpointsize(4)
  while true
    @with_pushed_matrix begin
      gltranslate(0,-1)
      glscale(1/500)
      glcolor(1,1,1)
      draw_paths(cur_path, 1024)
    end
    
    @with_primitive GL_TRIANGLES begin
      glcolor(1.0,0.0,0.0)
      glvertex(mx(),my())
      glvertex(mx()+0.1,my())
      glvertex(mx(),my()+0.1)
    end
    finalize_draw()
    flush_events()

    if next_t < time()
      cur_path = transport_path()
      tree_cnt += 1
      next_t = time() + wait_t
    end
  end
end

run_this()
