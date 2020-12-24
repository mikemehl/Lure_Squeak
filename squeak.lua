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
      components.position[new_eid].x = 4
      components.position[new_eid].y = 4
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
-- todo: here's the idea (steps)
--       1. iterate through everything that affects squeak (component list) in a certain radius
--       2. find the vectors between then and squeak
--       3. scale those vectors by how much they affect squeak 
--       4. average those vectors together. this is squeak's target spot
--   That's it! negative affects will push squeak away, positive draw her near
--   more todo: have squeak speed change based on distance of target found in plotting (set speed in polotting)
function squeak_ai_plotting(eid)
    local ai = components.squeak_ai[eid]
    assert(ai)

    if ai.target_x == -1 then
        ai.target_x = rnd(127)
        ai.target_y = rnd(127)
    end

    ai.state_timer = ai.state_timer - 1

    if ai.state_timer == 0 then
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

    if distance < 5 then 
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
