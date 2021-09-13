engineman = {}  

function gen_fall(bH, fH, g, precision, scale)
  --[[
      Essa função recebe uma coordenada inicial e uma final, e gera as coordenadas
      intermediárias a cada intervalo de 'precision' segundos, correspondentes a uma
      queda sob gravidade g.
      
      As coordenadas são CRESCENTES, uma vez que representam uma queda em LOVE2D.
      
      Scale é um valor de conversão metros/pixels
  --]]
  g = g * scale
  local cH = bH
  local coords = {}
  local vel = 0
  local finalT = math.sqrt((2*(bH - fH))/g)
  for t = 0, finalT, precision do
    table.insert(coords, fH + (g*(t^2)/2))
  end
  for i = #coords, 1, -1 do
    if coords[i] > bH then
      table.remove(coords, i)
    end
  end
  table.insert(coords, bH)
  return coords
end

function currFloor(coord)
  for i = 0, 6 do
    if coord <= 600 - (200*i) and coord >= 400 - (200*i) then
      return i + 1
    end
  end
end

function gen_fall_floor(yCoord)
  floor = currFloor(yCoord)
  if floor < 7 then
    floorHeight = 780 - (200*floor)
  else
    floorHeight = -610
  end
  local fallse = gen_fall(floorHeight, yCoord, 9.81, .01, 66)
  return fallse
end


function currFloorEngineer(coord)
  for i = 0, 6 do
    if coord <= 600 - (200*i) and coord >= 400 - (200*i) then
      return i + 1
    end
  end
end

function engineerCanFix(engineer, xM, yM, yE)
  local y = engineer.yCoord
  local x = engineer.xCoord
  if x > 180 and x < 345 and y > -700 and y <= -610 then
    engineer.canFix[3] = true
  else
    engineer.canFix[3] = false
  end
  if  currFloorEngineer(yE) == engineer.currFloor and ((math.abs(x - 400)) <= 100) then
    engineer.canFix[2] = true
  else
    engineer.canFix[2] = false
  end  
  --love.graphics.rectangle('fill', 300, oeb:getY(), 200, -80)
  if  ((math.abs(y - yE)) <= 80) and ((math.abs(x - 400)) <= 100) then
    engineer.canFix[1] = true
  else
    engineer.canFix[1] = false
  end
end

function splitRow(xI, yI, wSheet, hSheet, wQuad, hQuad, nS, d)
  local quads = {}
  for i = 0, nS-1 do
    local xQ = xI + (wQuad + d) * i
    local quad = love.graphics.newQuad(xQ, yI, wQuad, hQuad, wSheet, hSheet)
    table.insert(quads, quad)
  end
  return quads
end

function draw_stairs()
  love.graphics.setColor(1,1,0)
  for i = 1, 6 do
    if i % 2 == 1 then
      love.graphics.rectangle('fill', 50, 600 - (220*i), 100, 220)
    else
      love.graphics.rectangle('fill', 300, 600 - (220*i), 100, 220)
    end
  end
end

function create_engineer(scale, walkQuad, image, width, height)
  local engineer = {}
  engineer.xCoord = 400
  engineer.yCoord = 300
  engineer.scale = scale
  engineer.walkQuad = walkQuad
  engineer.width = width
  engineer.height = height
  engineer.move_right_leg = false
  engineer.frame = 2
  engineer.timer = 0
  engineer.image = image
  engineer.currFloor = 1
  engineer.inStairs = false
  engineer.onFloor = true
  engineer.fall = false
  engineer.fallList = {300}
  engineer.fallFrame = 1
  engineer.fallTimer = 0
  engineer.canFix = {false, false, false}
  return engineer
end

function engineerInStairs(engineer)
  local width = engineer.width
  local height = engineer.height
  local x = engineer.xCoord
  local y = engineer.yCoord
  local currFloor = engineer.currFloor
  if 200 < x and 240 > x then
    engineer.inStairs = true
  else
    engineer.inStairs = false
  end
end

function engineerCurrFloor(engineer)
  local cF = currFloorEngineer(engineer.yCoord)
  engineer.currFloor = cF
end


function engineerOnFloor(engineer)
  local cF = engineer.currFloor
  local fH = 780 - (200*cF)
  local y = engineer.yCoord
  if (math.abs(fH - y)) < 1 then
    engineer.onFloor = true
  else
    engineer.onFloor = false
  end
end

function check(engineer, dt)
  engineerCanFix(engineer, 180, -700, oeb:getY())
  engineerCurrFloor(engineer)
  engineerInStairs(engineer)
  engineerOnFloor(engineer)
  if (not engineer.onFloor) and not engineer.inStairs then
    if not engineer.fall then
      engineer.fallList = gen_fall_floor(engineer.yCoord)
      engineer.fall = true
    end
    engineer_fall(engineer, dt)
  else
    engineer.fallList = {(780 - (engineer.currFloor)*200)}
    engineer.fall = false
    engineer.fallFrame = 1
  end
end

function engineer_fall(engineer, dt)
  if engineer.fall then
    local heights = engineer.fallList
    local frame = engineer.fallFrame
    local timer = engineer.fallTimer
    timer = timer + dt
    if timer > .01 and frame < #heights then
      frame = frame + 1
      timer = 0
    end
    engineer.yCoord = heights[frame]
    engineer.fallFrame = frame
    engineer.fallTimer = timer
  end
end

function engineer_walk(engineer, dir, vel, tAnim, f1, f2, dt)
  local x = engineer.xCoord
  local timer = engineer.timer
  local frame = engineer.frame
  local go = engineer.move_right_leg
  if not engineer.inStairs then
    x = x + (dir * vel)
    timer = timer + dt
    if timer > tAnim then
      if go then
        if frame < f2 then
          frame = frame + 1
        else
          go = false
        end
      else
        if frame > f1 then
          frame = frame - 1
        else
          go = true
        end
      end
      timer = 0
    end
  else
    if x > 200 and x < 240 then
      x = x + vel*dir
    end
    frame = 2
  end
  engineer.xCoord = x
  engineer.timer = timer
  engineer.frame = frame
  engineer.move_right_leg = go
  engineer.scale = math.abs(engineer.scale) * dir
end

function draw_engineer(engineer)
  love.graphics.setColor(1,1,1)
  local x = engineer.xCoord
  local y = engineer.yCoord
  local scale = engineer.scale
  local width = engineer.width
  local height = engineer.height
  local frame = engineer.frame
  local quad = engineer.walkQuad
  local image = engineer.image
  love.graphics.draw(image, quad[frame], x, y, 0, scale, math.abs(scale), width/2, height)
end


function engineman.load()
  engineer_image = love.graphics.newImage('images/engineer.png')
  engineer_quads = splitRow(33, 70, 1904, 736, 159, 313, 3, 110)
  engineer = create_engineer(0.25, engineer_quads, engineer_image, 159, 313)
  m = engineer.width/2
end

function engineman.update(dt)
  check(engineer, dt)
  engineerInStairs(engineer)
  if engineer.inStairs then
    if love.keyboard.isDown('w') and engineer.yCoord > -620 then
      engineer.yCoord = engineer.yCoord - 2
    elseif love.keyboard.isDown('s') and engineer.yCoord < 580 then
      engineer.yCoord = engineer.yCoord + 2
    end
  elseif not engineer.fall then
    if engineer.currFloor < 7 then
      engineer.yCoord = 780 - 200*engineer.currFloor
    else
      engineer.yCoord = -610
    end
  end
  if love.keyboard.isDown('d') then
    engineer_walk(engineer, 1, 2, .1, 1, 3, dt)
  elseif love.keyboard.isDown('a') then
    engineer_walk(engineer, -1, 2, .1, 1, 3, dt)
  end
end

function engineman.draw()
  barra(engineer.xCoord - 37.5, engineer.yCoord - (engineer.height * math.abs(engineer.scale)) - 40, 75, 15, timer_manutencao, 60)
  draw_engineer(engineer)
end

return engineman