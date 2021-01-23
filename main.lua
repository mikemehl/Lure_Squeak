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
   mk_sqk()
   mk_toots()
   mk_door()
   mk_bed()
end


function _draw()
   cls(5)
   anim_spr_draw_system()
   dbg:print()
end

function _update()
   local b = get_buttons()
   death_timer_system()
   control_player_system(b)
   squeak_ai_system()
   tootsie_ai_system()
   move_entities_system()
   update_string_toy_position_system()
   update_crutch_position_system()
   anim_spr_update_system()
end

