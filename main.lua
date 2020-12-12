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

function dbg_print()
   -- NOTE: # and count() return the length of the SEQUENCE in the table
   --       so, it won't tell you if your table is actually empty
   local out = {
      id = "N/A",
      size = "N/A",
      anim_timer = "N/A"
   }
   for id, val in pairs(components.is_string) do
      out.id = id
      out.size = count(components.is_string)
   end

   if out.id != "N/A" then
      out.anim_timer = components.anim_sprite[out.id].timer
   end

   local out_str = "STRING ID: "..out.id.."\nSIZE: "..out.size.."\nATIMER: "..out.anim_timer
   print(out_str)
end

function _draw()
   cls(5)
   anim_spr_draw_system()
   dbg_print()
end

function _update()
   local b = get_buttons()
   death_timer_system()
   control_player_system(b)
   move_entities_system()
   update_string_toy_position_system()
   anim_spr_update_system()
end

