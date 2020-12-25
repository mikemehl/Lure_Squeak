-- build a squeak entity
function new_squeak_ai(eid)
    local v = {
        state = "plotting", -- plotting or moving
        state_timer = 60,   -- time before changing state
        target_x = -1,
        target_y = -1
    }
    return add_component(eid, "squeak_ai", v)
end

function mk_sqk()
   local new_eid = get_eid()
   add(entities, new_eid)

   if new_position(new_eid) then
      components.position[new_eid].x = 64
      components.position[new_eid].y = 64
   end

   if new_anim_sprite(new_eid) then
      components.anim_sprite[new_eid].frames = {3, 4}
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

   return new_squeak_ai(new_eid)
end

function new_affects_squeak(eid)
    local a = {
        val = 0.0 -- must be between -1 and 1
    }
    return add_component(eid, "affects_squeak", a)
end

-- squeak ai system
function squeak_find_target(eid)
    local target_vec = {x = 0, y = 0}
    local count = 0
    local squeak_pos = components.position[eid]
    local total_squeak_affect = 0
    for id, val in pairs(components.affects_squeak) do
        local p = components.position[id]
        if p then
            -- construct a vector from squeak to this
            local v = direction(p, squeak_pos)
            if v then
                -- scale by the squeak affect
                v.x = v.x * val.val
                v.y = v.y * val.val
                -- add it to our running counters
                target_vec.x = target_vec.x + v.x
                target_vec.y = target_vec.y + v.y
                count = count + 1
                total_squeak_affect = total_squeak_affect + val.val
            end
        end
    end

    if count > 0 then
        -- average them
        target_vec.x = target_vec.x / count
        target_vec.y = target_vec.y / count
        total_squeak_affect = total_squeak_affect / count
        -- scale by the total squeak affect
        target_vec.x = target_vec.x  
        target_vec.y = target_vec.y  
    else
        target_vec.x = rnd(127)
        target_vec.y = rnd(127)
    end

    target_vec.x = target_vec.x % 128
    target_vec.y = target_vec.y % 128
    return target_vec
end

function squeak_ai_plotting(eid)
    local ai = components.squeak_ai[eid]
    assert(ai)
    local t = squeak_find_target(eid)
    ai.target_x = (ai.target_x + t.x) 
    ai.target_y = (ai.target_y + t.y)

    ai.state_timer = ai.state_timer - 1

    if ai.state_timer == 0 then
        -- target has been a DIRECTION until now!
        -- transform to a point to reach by scaling by some amount
        ai.target_x = ai.target_x * (32 + rnd(64))
        ai.target_y = ai.target_y * (32 + rnd(64))
        if ai.target_x < 0 then ai.target_x = 0 end
        if ai.target_y < 0 then ai.target_y = 0 end
        if ai.target_x > 124 then ai.target_x = 124 end
        if ai.target_y > 124 then ai.target_y = 124 end
        dbg:log("TARGET_VEC: "..ai.target_x..", "..ai.target_y)
        ai.state = "moving"
    end

end

function squeak_ai_moving(eid)
    local ai = components.squeak_ai[eid]
    local p = components.position[eid]
    local d = components.direction[eid]
    local s = components.speed[eid]
    assert(p and d and s)

    local targ = {x=ai.target_x, y=ai.target_y}
    local distance = dist(p, targ)

    if distance < 1 then 
        ai.state = "plotting"
        ai.state_timer = 60
        ai.target_x = -1
        ai.target_y = -1
        s.val = 0
        s.active = false
    else
        local dir = direction(targ, p)
        d.x = dir.x
        d.y = dir.y
        s.val = 1
        s.active = true
    end
end

function squeak_ai_system()
    for eid, val in pairs(components.squeak_ai) do
        if val.state == "plotting" then
            squeak_ai_plotting(eid)
        elseif val.state == "moving" then
            squeak_ai_moving(eid)
        else
            assert(false)
        end
    end
end
