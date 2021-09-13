passageiro = {}

function generate_random_passenger (o, d)
  local pass = math.random(4)
  if pass == 1 then
    passenger = create_passenger(.3, sansWalk, sansOut, sansIn, sansSheet, o - 1, d, 170, 230, 275)
  elseif pass == 2 then
    passenger = create_passenger (1, outQuads, outQuads, outQuads, passSheet, o - 1, d, 56, 56, 76)
  elseif pass == 3 then
    passenger = create_passenger (1, outQuads, outQuads, outQuads, pass2Sheet, o - 1, d, 56, 56, 76)
  elseif pass == 4 then
    passenger = create_passenger (1, outQuads3, outQuads3, outQuads3, pass3Sheet, o - 1, d, 54, 54, 76)
  end
  return passenger
end

function shutDoor(passenger)
  if (not(passenger.hasShutDoor)) then
    portas_andares_abertas[passenger.oF] = false
    passenger.hasShutDoor = true
  end
end

function draw_passenger(passenger)
  if passenger.inElevator then
    love.graphics.setColor(1,1,1)
  else
    love.graphics.setColor(1,1,1, passenger.transparency)
  end
  local x = passenger.xCoord
  local y = passenger.yCoord
  local quad = passenger.currQuad
  local frame = passenger.frame
  local scale = passenger.scale
  local image = passenger.image
  local dir = passenger.dir
  local w = passenger.width
  love.graphics.draw(image, quad[frame], x, y, 0, scale*dir, scale, w/2, 0)
end

function create_passenger(scale, quadsGo, quadsOut, quadsIn, image, originFloor, destinationFloor, goWidth, outWidth, passenger_height)
  --[[
      A diferença entre timer e timerGo é: timer é usado apenas para implementar a animação
      em si. timerGo é usado para coordenar o processo de ida ao elevador.
      
      quadsGo é o conjunto de quads do passageiro andando. quadsOut é o conjunto de quads do jogsdor saindo da porta.
      
      currQuad é o conjunto de quads que a função draw_passenger deverá desenhar. O objetivo dessa variável
      é eliminar a necessidade de 'verificar' qual é o conjunto de quads que deve ser usado.
      
      dir é a direção em que o passageiro está caminhando
  --]]
  scale = scale or .1
  local passenger = {}
  passenger.height = passenger_height
  passenger.width = goWidth
  passenger.outWidth = outWidth
  passenger.goWidth = goWidth
  passenger.timer = 0
  passenger.frame = 1
  passenger.xCoord = 85
  passenger.yCoord = (580 - ((originFloor)*200)) - (passenger_height * scale)
  passenger.inOriginFloor = true
  passenger.inElevator = false
  passenger.scale = scale
  passenger.quadsGo = quadsGo
  passenger.quadsOut = quadsOut
  passenger.quadsIn = quadsIn
  passenger.image = image
  passenger.oF = originFloor
  passenger.dF = destinationFloor
  passenger.timerGo = 0
  passenger.currQuad = quadsGo
  passenger.inDFloor = false
  passenger.dir = 1
  passenger.transparency = 0
  passenger.remove = false
  passenger.hasShutDoor = false
  return passenger
end

--function draw_walk(passenger)
--  local x = passenger.xCoord
--  local y = passenger.yCoord
--  local frame = passenger.frame
--  local scale = passenger.scale
--  local quads = passenger.quads
--  local image = passenger.image
--  local dir = passenger.dir
--  love.graphics.draw(image, quads[frame], x, y, 0, scale, scale)
--  love.graphics.setColor(0,0,0)
--end

function isInElevator(passenger)
  local x = passenger.xCoord
  if 350 < x and  x < 450 then
    passenger.inElevator = true
  else
    passenger.inElevator = false
  end
end

function isInDFloor(passenger)
  local floor = passenger.dF - 1
  local y = passenger.yCoord
  local dCoord = (580 - ((floor)*200)) - (passenger.height * passenger.scale)
  if math.abs(y - dCoord) < 2 then
    passenger.inDFloor = true
  end
end

function isInOriginFloor(passenger)
  local oF = passenger.oF
  local h = passenger.height
  local scale = passenger.scale
  local originalY = (580 - ((oF)*200)) - (h * scale)
  local currY = passenger.yCoord
  if originalY == currY then
    passenger.inOriginFloor = true
  else
    passenger.inOriginFloor = false
  end
end
  

function goToElevatorDoor(passenger, dt)
  local timerGo = passenger.timerGo
  local origin = passenger.oF
  local scale = passenger.scale
  timerGo = timerGo + dt
--  portas_andares_abertas[origin] = true
  if timerGo < .75 then
    walk(passenger, 1, 0, 1, dt, 1, 4, .15)
  else
    walk(passenger, 1, 350 - 69, 1, dt, 1, 4, .15)
  end
  passenger.timerGo = timerGo
end

function getIntoElevator(passenger, dt)
  local timerGo = passenger.timerGo
  local x = passenger.xCoord
  walk(passenger, 1, 400, 1, dt, 1, 4, .15)
end

function getOutOfElevator(passenger, dt)
  local timerGo = passenger.timerGo
  local x = passenger.xCoord
  walk(passenger, -1, 0, -1, dt, 1, 4, .15)
end

function operate(passenger, dt)
  isInElevator(passenger, dt)
  isInDFloor(passenger)
  local inEl = passenger.inElevator
  local originFloor = passenger.oF
  local destFloor = passenger.dF
  local passenger_height = passenger.height * math.abs(passenger.scale)
  if inEl then
    if passenger.currQuad == passenger.quadsOut and passenger.image == sansSheet then
      passenger.yCoord = (oeb:getY() + h_elevador - passenger_height) - 3
    else
      passenger.yCoord = (oeb:getY() + h_elevador - passenger_height)
    end
  end
  if not passenger.inDFloor then
    if (not chegou_ao_andar(oeb, originFloor + 1)) or (chegou_ao_andar(oeb, originFloor + 1) and passenger.xCoord < (350 - 69)) then
      goToElevatorDoor(passenger, dt)
    elseif x_de_abertura_das_portas < 10 then
      getIntoElevator(passenger, dt)
    end
  end
  if passenger.inDFloor then
    if (inEl and x_de_abertura_das_portas < 10) or (not inEl and passenger.xCoord > 85) then
      passenger.timerGo = 0
      walk(passenger, -1, 85, 1, dt, 1, 4, .15)
    else
      passenger.timerGo = passenger.timerGo + dt
      walk(passenger, 0, 0, 0, dt, 1, 4, .15)
    end
  end
  if passenger.inElevator and passenger.xCoord == 400 then
    passenger.frame = 1
    passenger.currQuad = passenger.quadsOut
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

function sheetSans()
  local quads = {}
  local quad
  for i = 0, 3 do
    quad = love.graphics.newQuad(i * 240, 310, 230, 300, 2100, 900)
    table.insert(quads, quad)
  end
  return quads
end


function walk(passenger, dir, dX, vel, dt, f1, f2, tAnim)
  --[[
      dir é a direção para onde o passafeiro anda.
      1 representa direita e -1, esquerda
      
      dX é a coordenada final à qual o passageiro irá.
      
      vel é a velocidade em pixels
      
      f1 e f2 são índices de uma lista de quads. f1 é o primeiro frame em que o passageiro está andando, e f2, o último.
  --]]
  local timer = passenger.timer
  local frame = passenger.frame
  local xC = passenger.xCoord
  if timer < tAnim then
    timer = timer + dt
  else
    timer = 0
    if frame < f2 and ((xC > dX and dir == -1) or (dX==0) or (dX > xC and dir == 1)) then
      frame = frame + 1
    else
      frame = f1
    end
  end
  if dir == 1 then
    if xC <  dX then
      xC = xC + vel*dir
    end
  elseif dir == -1 then
    if xC >  dX then
      xC = xC + vel*dir
    end
  end
  passenger.timer = timer
  passenger.frame = frame
  passenger.xCoord = xC
  if dX == 0 then
    if dir == 1 then
      portas_andares_abertas[passenger.oF] = true
      passenger.currQuad = passenger.quadsOut
      passenger.transparency = transicao(0, 1, passenger.timerGo, .5)
    elseif dir == 0 then
      passenger.currQuad = passenger.quadsIn
      passenger.transparency = transicao(1, 0, passenger.timerGo, .5)
      if passenger.transparency > 0 then
        portas_andares_abertas[passenger.dF - 1] = true
      elseif not passenger.inElevator then
        portas_andares_abertas[passenger.dF - 1] = false
        passenger.remove = true
      end
    end
    --function walk(passenger, dir, dX, vel, dt, f1, f2, tAnim)
    --walk(passenger, 0, 0, 0, dt, 1, 4, .15)
    passenger.dir = 1
    passenger.width = passenger.outWidth
    --Retiramos a linha portas_andares_abertas[passenger.oF] = true daqui e passamos para 219
  else
    passenger.transparency = 1
    passenger.currQuad = passenger.quadsGo
    passenger.dir = dir
    passenger.width = passenger.goWidth
    shutDoor(passenger)
  end
end


function passageiro.load()
  sansOut = splitRow(0, 0, 2100, 900, 230, 296, 4, 10)
  sansIn = splitRow(1020, 0, 2100, 900, 230, 296, 4, 10)
  sansWalk = splitRow(0, 298, 2100, 900, 170, 299, 4, 10)
  sansSheet = love.graphics.newImage('images/sans.png')
  passSheet = love.graphics.newImage('images/passenger1.png')
  pass2Sheet = love.graphics.newImage('images/p1.png')
  pass3Sheet = love.graphics.newImage('images/p3.png')
  sans = create_passenger(.3, sansWalk, sansOut, sansIn, sansSheet, 5, 0, 170, 230, 275)
  pass = create_passenger(1, outQuads, outQuads, outQuads, passSheet, 4, 0, 170, 230, 275)
  outQuads = splitRow(14, 77, 774, 663, 56, 76, 4, 40)
  outQuads3 = splitRow(14, 77, 774, 663, 54, 76, 4, 40)
  passengers = {}
end

function passageiro.update(dt)
  for i = 1, # passengers do
    operate(passengers[i], dt)
  end
  for i = #passengers, 1, -1 do
    if (passengers[i].remove) then
      table.remove(passengers, i)
    end
  end
end

function passageiro.draw()
  for i = 1, #passengers do
    draw_passenger(passengers[i])
  end
end

return passageiro