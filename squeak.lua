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
        val = 0.0, -- must be between -1 and 1
        radius = 0.0
    }
    return add_component(eid, "affects_squeak", a)
end

-- squeak ai system
function squeak_find_target(eid)
    return {x=rnd(120), y=rnd(120)}
end

function squeak_ai_plotting(eid)
    local ai = components.squeak_ai[eid]
    assert(ai)
    ai.state_timer = ai.state_timer - 1

    if ai.state_timer == 0 then
        local t = squeak_find_target(eid)
        ai.target_x = t.x 
        ai.target_y = t.y 
        ai.state = "moving"
    end

end

function squeak_steering(curr_pos, curr_vel, target)
    local MAX_STEER = 10 
    local MAX_TGT = 7
    local steer = {x=0, y=0}
    local tgt_vel = {x=0, y=0}
    tgt_vel.x = target.x - curr_pos.x 
    tgt_vel.y = target.y - curr_pos.y 

    local m = mag(tgt_vel)
    if m > MAX_TGT then
        tgt_vel.x = tgt_vel.x / m * MAX_TGT
        tgt_vel.y = tgt_vel.y / m * MAX_TGT
    end

    for id, v in pairs(components.affects_squeak) do 
        local p = components.position[id]
        assert(p)
        assert(v)
        assert(v.val)
        if dist(p, curr_pos) < v.radius then
            local s = {x = v.val*(p.x - curr_pos.x), y = v.val*(p.y - curr_pos.y)}
            steer.x = steer.x + s.x
            steer.y = steer.y + s.y
        end
    end

    m = mag(steer)
    if m > MAX_STEER then
        steer.x = steer.x / m * MAX_STEER
        steer.y = steer.y / m * MAX_STEER
    end

    local r = {x = steer.x + tgt_vel.x, y = steer.y + tgt_vel.y}
    m = mag(r)
    r.x = r.x / m
    r.y = r.y / m
    return r
end

function squeak_determine_comfort(pos)
    local avg = 0
    local count = 0
    for eid, v in pairs(components.affects_squeak) do
        local p = components.position[eid]
        assert(p)
        if dist(p, pos) < v.radius then
            avg = avg + v.val
            count = count + 1
        end
    end

    return avg/count
end

function squeak_ai_moving(eid)
    local ai = components.squeak_ai[eid]
    local p = components.position[eid]
    local d = components.direction[eid]
    local s = components.speed[eid]
    assert(p and d and s)

    local targ = {x=ai.target_x, y=ai.target_y}
    local distance = dist(p, targ)

    if distance < 8 then 
        ai.state = "plotting"
        local comf = ceil(squeak_determine_comfort(p)*30)
        ai.state_timer = 60 + comf 
        ai.target_x = -1
        ai.target_y = -1
        s.val = 0
        s.active = false
    else
        local curr_dir = {x=d.x, y=d.y}
        local dir = squeak_steering(p, curr_dir, {x=ai.target_x, y=ai.target_y})
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
