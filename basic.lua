-- basic components and such
function new_position(eid)
   local new_pos = 
   { 
      x = 0, 
      y = 0 
   }
   return ecs:add_component(eid, "position", new_pos) 
end

function new_anim_sprite(eid)
   -- frames is an array of sprite indexes
   local anim = 
   { 
      frames = {}, 
      timer = 0, 
      curr_frame = 1, 
      timer_reset_val = 0, 
      flip_x = false, 
      flip_y = false,
      on_motion = false, 
      loop = true
   }
   return ecs:add_component(eid, "anim_sprite", anim)
end

function new_direction(eid)
   local new_dir = 
   { 
      x = 0, 
      y = 0
   }
  return ecs:add_component(eid, "direction", new_dir)
end

function new_speed(eid)
   -- how fast, and is it actively moving
   local new_speed = 
   { 
      val = 0, 
      active = false 
   }
   return ecs:add_component(eid, "speed", new_speed)
end

function new_death_timer(eid)
   local new_dt = 
   {
      timer = 0,
      step = 1
   }
   return ecs:add_component(eid, "death_timer", new_dt)
end

-- basic systems for these components
function anim_spr_draw_system()
   local f = function(eid)
      local pos = ecs.components.position[eid]
      local as = ecs.components.anim_sprite[eid]
      spr(as.frames[val.curr_frame], pos.x, pos.y, 1, 1, as.flip_x, as.flip_y)
   end
   return ecs:system({"anim_sprite", "position"}, f)
end

function anim_spr_update_system()
   for eid, val in pairs(ecs.components.anim_sprite) do
      if val.on_motion then
         local s = ecs.components.speed[eid]
         if s and s.active == false then 
            goto continue 
         end
      end
      val.timer = val.timer - 1
      if val.timer <= 0 then
        val.curr_frame = val.curr_frame + 1 
        if val.curr_frame > #val.frames and val.loop then
           val.curr_frame = 1
        end
        val.timer = val.timer_reset_val
      end
      local d = ecs.components.direction[eid]
      if d then
         if d.x < 0 then val.flip_x = true end
         if d.x > 0 then val.flip_x = false end
      end
      ::continue::
   end
end

function move_entities_system()
   for eid, val in pairs(ecs.components.speed) do
      if val.active and ecs.components.position[eid] and ecs.components.direction[eid] then
         ecs.components.position[eid].x = ecs.components.position[eid].x + ecs.components.direction[eid].x * val.val
         ecs.components.position[eid].y = ecs.components.position[eid].y + ecs.components.direction[eid].y * val.val
         if ecs.components.position[eid].x < 0 then ecs.components.position[eid].x = 0 end
         if ecs.components.position[eid].x > 120 then ecs.components.position[eid].x = 120 end
         if ecs.components.position[eid].y < 0 then ecs.components.position[eid].y = 0 end
         if ecs.components.position[eid].y > 120 then ecs.components.position[eid].y = 120 end
      end
   end
end

function death_timer_system()
   for eid, val in pairs(ecs.components.death_timer) do
      if val.timer == 0 then
         ecs:remove_entity(eid)
      else
         val.timer = val.timer - val.step
      end
   end
end
