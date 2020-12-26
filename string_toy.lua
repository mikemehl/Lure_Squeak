function mk_string_toy()
   local eid = get_eid()
   add(entities, eid)

   assert(new_position(eid))
   components.position[eid].x = 0
   components.position[eid].y = 0

   assert(new_anim_sprite(eid))
   components.anim_sprite[eid].frames = {5, 6}
   components.anim_sprite[eid].timer = 3
   components.anim_sprite[eid].curr_frame = 1
   components.anim_sprite[eid].timer_reset_val = 3
   components.anim_sprite[eid].on_motion = false 
   components.anim_sprite[eid].loop = true

   assert(new_death_timer(eid)) 
   components.death_timer[eid].timer = 15
   components.death_timer[eid].step = 1

   assert(new_affects_squeak(eid))
   components.affects_squeak[eid].val = 0.45
   components.affects_squeak[eid].radius = 64

   return add_component(eid, "is_string", true)
end

function update_string_toy_position_system()
    for sid, val in pairs(components.is_string) do
        local as = components.affects_squeak[sid]
        if as.val > 0.0 then
            as.val = as.val - (0.60/60)
        elseif as.val < 0.0 then
            as.val = 0.0
        end
        for pid, val in pairs(components.is_player) do
            local s = components.position[sid]
            local p = components.position[pid]
            local pflip = components.direction[pid].x <= 0
            assert(s)
            assert(p)
            if pflip then 
               s.x = p.x-4
            else
               s.x = p.x+4
            end
            s.y = p.y-4
        end
    end
end