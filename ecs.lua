ecs = {}
ecs.curr_eid = 4
ecs.entities = {}
ecs.components = 
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
  tootsie_ai = {},
  affects_squeak = {},
  is_door = {},
  is_bed = {}
}

function ecs:add_component(eid, name, vals)
  if self.components[name] then
    self.components[name][eid] = vals   
    return true
  end
  return false
end

function ecs:remove_component(eid, name)
  if self.components[name] then
    self.components[name][eid] = nil
    return true
  end
  return false
end

function ecs:get_component(eid, name)
  if self.components[name] then
    return self.components[name][eid] 
  end
  return nil 
end

function ecs:has_component(eid, name)
  if self.components[name] then 
    return true
  end
  return false
end

function ecs:new_entity()
   local ret_val = self.curr_eid
   self.curr_eid = self.curr_eid + 2
   add(self.entities, ret_val)
   return ret_val
end

function ecs:remove_entity(eid)
  for _, c in pairs(self.components) do
    if c[eid] then c[eid] = nil end
  end
  del(self.entities, eid)
end

function ecs:system(comp_list, f, ...)
  local r = function(...)
    for _,v in pairs(self.entities) do
      for _,c in pairs(comp_list) do
        if not self.components[c][v] then
          goto _skip
        end
      end
      f(v, ...)
    ::_skip::
    end
  end
  return r
end