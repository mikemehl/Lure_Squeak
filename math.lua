-- find the distance between two position componenta
function dist(a, b)
    return sqrt((a.x - b.x) ^ 2 + (a.y - b.y) ^ 2)
end

-- get a unit vector (direction component) from a to b
function direction(a, b)
    local dir = {}
    dir.x = a.x - b.x
    dir.y = a.y - b.y
    local mag = sqrt(dir.x^2 + dir.y^2)
    if mag != 0 then
       dir.x = dir.x / mag
       dir.y = dir.y / mag
       return dir
    end
    return nil
end