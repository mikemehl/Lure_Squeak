-- make the player entity
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

-- player specific systems
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
