-- build a tootsie entity
function new_tootsie_ai(eid)
    local v = {
        state = "plotting", -- plotting or moving
        state_timer = 15,   -- time before changing state
        target_x = -1,
        target_y = -1
    }
    return ecs:add_component(eid, "tootsie_ai", v)
end

function mk_toots()
   local new_eid = ecs:new_entity()
   add(entities, new_eid)

   if new_position(new_eid) then
      ecs.components.position[new_eid].x = 64
      ecs.components.position[new_eid].y = 64
   end

   if new_anim_sprite(new_eid) then
      ecs.components.anim_sprite[new_eid].frames = {10, 11}
      ecs.components.anim_sprite[new_eid].timer = 3
      ecs.components.anim_sprite[new_eid].curr_frame = 1
      ecs.components.anim_sprite[new_eid].timer_reset_val = 5
      ecs.components.anim_sprite[new_eid].on_motion = true
   end

   if new_direction(new_eid) then
      ecs.components.direction[new_eid].x = 1
      ecs.components.direction[new_eid].y = 0
   end

   if new_speed(new_eid) then
      ecs.components.speed[new_eid].val = 0
      ecs.components.speed[new_eid].active = false
   end

   if new_affects_squeak(new_eid) then
      ecs.components.affects_squeak[new_eid].val = -0.35
      ecs.components.affects_squeak[new_eid].radius = 32
   end

   return new_tootsie_ai(new_eid)

end

-- tootsie ai system

function tootsie_plot(eid)
    local ai = ecs.components.tootsie_ai[eid]
    assert(ai)
    ai.state_timer = ai.state_timer - 1

    if ai.state_timer <= 0 then
        ai.target_x = 5 + rnd(120)
        ai.target_y = 5 + rnd(120)
        ai.state = "moving"
        ai.state_timer = 3 * 15
    end
end

function tootsie_move(eid)
    local ai = ecs.components.tootsie_ai[eid]
    local s = ecs.components.speed[eid]
    local d = ecs.components.direction[eid]
    local p = ecs.components.position[eid]

    ai.state_timer = ai.state_timer - 1
    if ai.state_timer <= 0 then
        ai.state = "plotting"
        ai.state_timer = 6*30
        s.active = false
        s.val = 0
        return
    end

    local count = 0
    local t = {x=0, y=0}
    
    for id,v in pairs(ecs.components.squeak_ai) do
        local squeak_pos = ecs.components.position[id]
        local squeak_dir = ecs.components.direction[id]
        local squeak_speed = ecs.components.speed[id]

        if dist(p, squeak_pos) < 16 then
            local d = direction(p, {x=5+rnd(120), y=5+rnd(120)})
            if d then
                t = add_vect(t, d)
            else
                t = {x=rnd(1), y=rnd(1)}
            end
            count = 1
            break
        end

        local s_dest = {x=2*squeak_dir.x*squeak_speed.val + squeak_pos.x, y=2*squeak_dir.y*squeak_speed.val + squeak_pos.y}
        local d = direction(s_dest, p)
        if d then
            t = add_vect(t, d)
        else
            t = {x=rnd(1), y=rnd(1)}
        end
        count = count + 1
    end

    if count > 0 then
       t.x = t.x/count
       t.y = t.y/count
    else
        t.x = 5+rnd(120)
        t.y = 5+rnd(120)
    end

    d.x = t.x
    d.y = t.y
    s.val = 2
    s.active = true
end

function tootsie_ai_system()
    for eid,val in pairs(ecs.components.tootsie_ai) do
        if val.state == "plotting" then
            tootsie_plot(eid)
        elseif val.state == "moving" then
            tootsie_move(eid)
        else
            assert(false)
        end
    end
end