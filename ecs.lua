entities = {}
components = 
{
  position = {},
  anim_sprite = {},
  direction = {},
  speed = {},
  is_player = {},
  is_string = {},
  is_crutch = {},
  death_timer = {},
  squeak_ai = {},
  affects_squeak = {},
  is_door = {}
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
    if c[eid] then c[eid] = nil end
  end
  del(entities, eid)
end

curr_eid = 4

-- TODO: Change entities so they store some data besides their id.
--       Should interfere less with default table behavior of sequences?
--       Maybe have entities be tables with an id and a component list (just true and false values).
function get_eid()
   local ret_val = curr_eid
   curr_eid = curr_eid + 2
   return ret_val
end