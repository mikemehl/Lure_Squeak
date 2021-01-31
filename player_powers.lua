function mk_string_toy()
   local eid = ecs:new_entity()
   add(entities, eid)

   assert(new_position(eid))
   ecs.components.position[eid].x = 0
   ecs.components.position[eid].y = 0

   assert(new_anim_sprite(eid))
   ecs.components.anim_sprite[eid].frames = {5, 6}
   ecs.components.anim_sprite[eid].timer = 3
   ecs.components.anim_sprite[eid].curr_frame = 1
   ecs.components.anim_sprite[eid].timer_reset_val = 3
   ecs.components.anim_sprite[eid].on_motion = false 
   ecs.components.anim_sprite[eid].loop = true

   assert(new_death_timer(eid)) 
   ecs.components.death_timer[eid].timer = 15
   ecs.components.death_timer[eid].step = 1

   assert(new_affects_squeak(eid))
   ecs.components.affects_squeak[eid].val = 0.45
   ecs.components.affects_squeak[eid].radius = 64

   return ecs:add_component(eid, "is_string", true)
end

function update_string_toy_position_system()
    for sid, val in pairs(ecs.components.is_string) do
        local as = ecs.components.affects_squeak[sid]
        if as.val > 0.0 then
            as.val = as.val - (0.60/60)
        elseif as.val < 0.0 then
            as.val = 0.0
        end
        for pid, val in pairs(ecs.components.is_player) do
            local s = ecs.components.position[sid]
            local p = ecs.components.position[pid]
            local pflip = ecs.components.direction[pid].x <= 0
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

function mk_crutch()
   local eid = ecs:new_entity()
   add(entities, eid)

   assert(new_position(eid))
   ecs.components.position[eid].x = 0
   ecs.components.position[eid].y = 0

   assert(new_anim_sprite(eid))
   ecs.components.anim_sprite[eid].frames = {9}
   ecs.components.anim_sprite[eid].timer = 60
   ecs.components.anim_sprite[eid].curr_frame = 1
   ecs.components.anim_sprite[eid].timer_reset_val = 60
   ecs.components.anim_sprite[eid].on_motion = false 
   ecs.components.anim_sprite[eid].loop = true

   assert(new_death_timer(eid)) 
   ecs.components.death_timer[eid].timer = 15
   ecs.components.death_timer[eid].step = 1

   assert(new_affects_squeak(eid))
   ecs.components.affects_squeak[eid].val = -0.65
   ecs.components.affects_squeak[eid].radius = 64

   return ecs:add_component(eid, "is_crutch", true)
end

function update_crutch_position_system()
    for sid, val in pairs(ecs.components.is_crutch) do
        local as = ecs.components.affects_squeak[sid]
        if as.val > 0.0 then
            as.val = as.val - (0.60/60)
        elseif as.val < 0.0 then
            as.val = 0.0
        end
        for pid, val in pairs(ecs.components.is_player) do
            local s = ecs.components.position[sid]
            local p = ecs.components.position[pid]
            local pflip = ecs.components.direction[pid].x <= 0
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