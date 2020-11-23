entities = {}
components = 
{
  position = {},
  anim_sprite = {},
  direction = {},
  speed = {},
  is_player = {}
}

function add_component(eid, name, vals)
  if components[name] then
    components[name][eid] = vals   
    return true
  end
  return false
end

function remove_componenet(eid, name)
  if components[name] then
    components[name][eid] = nil
    return true
  end
  return false
end

curr_eid = 0

function get_eid()
   local ret_val = curr_eid
   curr_eid = curr_eid + 1
   return ret_val
end

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

function anim_spr_draw_system()
   for eid, val in pairs(components.anim_sprite) do
      if components.position[eid] then
         local pos = components.position[eid]
         spr(val.frames[val.curr_frame], pos.x, pos.y)
      else
         assert(false)
      end
   end
end

function _draw()
   cls()
   anim_spr_draw_system()
end

function anim_spr_update_system()
   for eid, val in pairs(components.anim_sprite) do
      val.timer = val.timer - 1
      if val.timer <= 0 then
        val.curr_frame = val.curr_frame + 1 
        if val.curr_frame > #val.frames then
           val.curr_frame = 1
        end
        val.timer = val.timer_reset_val
      end
   end
end

-- todo: make a system to update the player based on input (maybe have a global for button state...globals bad, but it's easiest to fit in with this, plust it's just a lil pico 8 game, chill

function move_player_system(b_struct)
   for eid, val in pairs(components.is_player) do
      if b_struct.up then
         components.speed[eid].active = true
         components.speed[eid].val = 1
         components.direction[eid].y = -1
         components.direction[eid].x = 0
      elseif b_struct.down then
         components.speed[eid].active = true
         components.speed[eid].val = 1
         components.direction[eid].y = 1
         components.direction[eid].x = 0
      elseif b_struct.right then
         components.speed[eid].active = true
         components.speed[eid].val = 1
         components.direction[eid].y = 0
         components.direction[eid].x = 1
      elseif b_struct.left then
         components.speed[eid].active = true
         components.speed[eid].val = 1
         components.direction[eid].y = 0
         components.direction[eid].x = -1 
   print(b)
      else
         components.speed[eid].active = false
      end
   end 
end

function move_entities_system()
   for eid, val in pairs(components.speed) do
      if val.active and components.position[eid] and components.direction[eid] then
         components.position[eid].x = components.position[eid].x + components.direction[eid].x * val.val
         components.position[eid].y = components.position[eid].y + components.direction[eid].y * val.val
         if components.position[eid].x < 0 then components.position[eid].x = 0 end
         if components.position[eid].x > 128 then components.position[eid].x = 128 end
         if components.position[eid].y < 0 then components.position[eid].y = 0 end
         if components.position[eid].y > 128 then components.position[eid].y = 128 end
      end
   end
end

-- todo: move stuff into separate files, organize better
function _update()
   local b = get_buttons()
   move_player_system(b)
   move_entities_system()
   anim_spr_update_system()
end
