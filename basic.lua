-- basic components and such
function new_position(eid)
   local new_pos = { x = 0, y = 0 }
   return add_component(eid, "position", new_pos) 
end

function new_anim_sprite(eid)
   -- frames is an array of sprite indexes
   local anim = { frames = {}, timer = 0, curr_frame = 0, timer_reset_val = 0, flip_x = false, flip_y = false, on_motion = false, loop = true}
   return add_component(eid, "anim_sprite", anim)
end

function new_direction(eid)
   local new_dir = { x = 0, y = 0}
  return add_component(eid, "direction", new_dir)
end

function new_speed(eid)
   -- how fast, and is it actively moving
   local new_speed = { val = 0, active = false }
   return add_component(eid, "speed", new_speed)
end

function mk_player()
   local new_eid = get_eid()
   add(entities, new_eid)

   if new_position(new_eid) then
      components.position[new_eid].x = 64
      components.position[new_eid].y = 64
   end

   if new_anim_sprite(new_eid) then
      components.anim_sprite[new_eid].frames = {1, 2}
      components.anim_sprite[new_eid].timer = 5
      components.anim_sprite[new_eid].curr_frame = 1
      components.anim_sprite[new_eid].timer_reset_val = 5
      components.anim_sprite[new_eid].on_motion = true
   end

   if new_direction(new_eid) then
      components.direction[new_eid].x = 1
      components.direction[new_eid].y = 0
   end

   if new_speed(new_eid) then
      components.speed[new_eid].val = 0
      components.speed[new_eid].active = false
   end

   return add_component(new_eid, "is_player", true) 
end

function anim_spr_draw_system()
   for eid, val in pairs(components.anim_sprite) do
      if components.position[eid] then
         local pos = components.position[eid]
         spr(val.frames[val.curr_frame], pos.x, pos.y, 1, 1, val.flip_x, val.flip_y)
      else
         assert(false)
      end
   end
end

function move_player_system(b_struct)
   for eid, val in pairs(components.is_player) do
      if b_struct.up then
         components.speed[eid].active = true
         components.speed[eid].val = 2
         components.direction[eid].y = -1
         components.direction[eid].x = 0
      elseif b_struct.down then
         components.speed[eid].active = true
         components.speed[eid].val = 2
         components.direction[eid].y = 1
         components.direction[eid].x = 0
      elseif b_struct.right then
         components.speed[eid].active = true
         components.speed[eid].val = 2
         components.direction[eid].y = 0
         components.direction[eid].x = 1
      elseif b_struct.left then
         components.speed[eid].active = true
         components.speed[eid].val = 2
         components.direction[eid].y = 0
         components.direction[eid].x = -1 
   print(b)
      else
         components.speed[eid].active = false
      end
   end 
end

function anim_spr_update_system()
   for eid, val in pairs(components.anim_sprite) do
      if val.on_motion then
         local s = components.speed[eid]
         if s and s.active == false then return end
      end
      val.timer = val.timer - 1
      if val.timer <= 0 then
        val.curr_frame = val.curr_frame + 1 
        if val.curr_frame > #val.frames and val.loop then
           val.curr_frame = 1
        end
        val.timer = val.timer_reset_val
      end
      local d = components.direction[eid]
      if d then
         if d.x < 0 then val.flip_x = true end
         if d.x > 0 then val.flip_x = false end
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
