entities = {}
components = 
{
  position = {},
  anim_sprite = {},
  direction = {},
  speed = {},
  is_player = {},
  is_string = {},
  death_timer = {}
}

function add_component(eid, name, vals)
  if components[name] then
    components[name][eid] = vals   
    return true
  end
  return false
end

function remove_component(eid, name)
  if components[name] then
    components[name][eid] = nil
    return true
  end
  return false
end

function remove_entity(eid)
  for _, c in pairs(components) do
    if c[eid] then del(c, c[eid]) end
  end
  del(entities, eid)
end

curr_eid = 0

function get_eid()
   local ret_val = curr_eid
   curr_eid = curr_eid + 1
   return ret_val
end

-- TODO:
-- Add a funciton for deleting an entity (and all of it's components, of course).

