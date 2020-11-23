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

-- todo: move stuff into separate files, organize better
function _update()
   anim_spr_update_system()
end
