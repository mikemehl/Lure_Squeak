function get_buttons()
   local b = btn()
   local buttons = {
      left  = b & 0x0001 > 0,
      right = b & 0x0002 > 0,
      up    = b & 0x0004 > 0,
      down  = b & 0x0008 > 0,
      o     = b & 0x0010 > 0,
      x     = b & 0x0020 > 0
   }
   return buttons
end


function _init()
   mk_player()
end


function _draw()
   cls()
   anim_spr_draw_system()
end

function _update()
   local b = get_buttons()
   move_player_system(b)
   move_entities_system()
   anim_spr_update_system()
end
