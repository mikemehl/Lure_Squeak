-- basic components and such
function new_position(eid)
   local new_pos = { x = 0, y = 0 }
   return add_component(eid, "position", new_pos) 
end

function new_anim_sprite(eid)
   -- frames is an array of sprite indexes
   local anim = { frames = {}, timer = 0, curr_frame = 0, timer_reset_val = 0}
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
      components.anim_sprite[new_eid].timer = 10
      components.anim_sprite[new_eid].curr_frame = 1
      components.anim_sprite[new_eid].timer_reset_val = 10
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

