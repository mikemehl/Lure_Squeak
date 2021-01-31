function mk_door()
    local id = ecs:new_entity()

    assert(new_position(id))
    ecs.components.position[id].x = 32
    ecs.components.position[id].y = 32

    assert(new_anim_sprite(id))
    ecs.components.anim_sprite[id].frames = {7}
    ecs.components.anim_sprite[id].timer = 60 
    ecs.components.anim_sprite[id].curr_frame = 1
    ecs.components.anim_sprite[id].timer_reset_val = 60
    ecs.components.anim_sprite[id].loop = true 
    ecs.components.anim_sprite[id].on_motion = false

    assert(new_affects_squeak(id))
    ecs.components.affects_squeak[id].val = -0.25
    ecs.components.affects_squeak[id].radius = 16
    
    return ecs:add_component(id, "is_door", true)
end

function mk_bed()
    local id = ecs:new_entity()

    assert(new_position(id))
    ecs.components.position[id].x = 64
    ecs.components.position[id].y = 64

    assert(new_anim_sprite(id))
    ecs.components.anim_sprite[id].frames = {8}
    ecs.components.anim_sprite[id].timer = 60 
    ecs.components.anim_sprite[id].curr_frame = 1
    ecs.components.anim_sprite[id].timer_reset_val = 60
    ecs.components.anim_sprite[id].loop = true 
    ecs.components.anim_sprite[id].on_motion = false

    assert(new_affects_squeak(id))
    ecs.components.affects_squeak[id].val = 0.25
    ecs.components.affects_squeak[id].radius =32 
    
    return ecs:add_component(id, "is_bed", true)
end