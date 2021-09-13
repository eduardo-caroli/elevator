andar = 1
--Esse é o fator de conversão metros/pixels
MtoP = 199.8/3.5
local world = love.physics.newWorld(0, 0, true)
local objects = {}
local y_inicial = 600
objects.elevador = {}
objects.box = {}
objects.elevador.body = love.physics.newBody(world, 400, y_inicial, "dynamic")
objects.elevador.shape = love.physics.newRectangleShape(20, 20)
objects.elevador.fixture = love.physics.newFixture(objects.elevador.body, objects.elevador.shape)
objects.elevador.body:setLinearVelocity(0, -1.5*MtoP)
local oe = objects.elevador
local oeb = objects.elevador.body
local massa_elevador = oeb:getMass()

function love.draw()
  love.graphics.rectangle("line", objects.elevador.body:getX(), objects.elevador.body:getY(), 20, 20)
  love.graphics.print(a, 10, 10)
  love.graphics.print(b, 10, 20)
end

function love.update(dt)
  world:update(dt)
  a, b = oe.body:getLinearVelocity()
  if 0<b and b<1 then
    io.write(tostring(y_inicial - oeb:getY()).."\n")
  end
  if math.abs(0-oeb:getY()) < 63.5 and b < 0 then
    oeb:applyForce(0, massa_elevador*1*MtoP)
  end
end