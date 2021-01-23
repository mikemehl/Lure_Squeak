function mk_door()
    local id = get_eid()

    assert(new_position(id))
    components.position[id].x = 32
    components.position[id].y = 32

    assert(new_anim_sprite(id))
    components.anim_sprite[id].frames = {7}
    components.anim_sprite[id].timer = 60 
    components.anim_sprite[id].curr_frame = 1
    components.anim_sprite[id].timer_reset_val = 60
    components.anim_sprite[id].loop = true 
    components.anim_sprite[id].on_motion = false

    assert(new_affects_squeak(id))
    components.affects_squeak[id].val = -0.25
    components.affects_squeak[id].radius = 16
    
    return add_component(id, "is_door", true)
end

function mk_bed()
    local id = get_eid()

    assert(new_position(id))
    components.position[id].x = 64
    components.position[id].y = 64

    assert(new_anim_sprite(id))
    components.anim_sprite[id].frames = {8}
    components.anim_sprite[id].timer = 60 
    components.anim_sprite[id].curr_frame = 1
    components.anim_sprite[id].timer_reset_val = 60
    components.anim_sprite[id].loop = true 
    components.anim_sprite[id].on_motion = false

    assert(new_affects_squeak(id))
    components.affects_squeak[id].val = 0.25
    components.affects_squeak[id].radius =32 
    
    return add_component(id, "is_bed", true)
end