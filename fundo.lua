fundo = {}

circles_lua = {}
raio_circles_lua = 1

function estrelas(nEstrelas)
  local stern = {}
  xE = 0
  yE = 0
  math.randomseed(os.time())
  for i = 1, nEstrelas + 1 do
    for j = 1, #stern do
      if xE < stern[j][1] + 5 or xE > stern[j][1] - 5 or yE < stern[j][2] + 5 or yE > stern[j][2] - 5 then
        xE = math.random(1400)
        yE = math.random(600)
      end
    end
    table.insert(stern, {xE, yE})
  end
  table.remove(stern, 1)
  return stern
end

function lua(xLua, yLua, raio, t)
  love.graphics.setColor(1,1,1, t)
  love.graphics.circle('fill', xLua, yLua, raio)
  love.graphics.setColor(0.5,0.5,0.5, t)
  love.graphics.circle('line', xLua, yLua, raio)
  love.graphics.circle('fill',xLua + ((27/50)*raio), yLua + ((13/50)*raio), 8*(raio/50))
  love.graphics.circle('fill', xLua - ((13/50)*raio), yLua + ((29/50)*raio), 8*(raio/50))
  love.graphics.circle('fill', xLua - ((12/50)*raio), yLua - ((11/50)*raio), 15*(raio/50))
end

function fundo.load()
  hora = 0
  angulo = 0
  pi = math.pi
  seno = math.sin
  coss = math.cos
  lg = love.graphics
  xSol = 0
  ySol = 0
  xLua = 0
  yLua = 0
  transp = 0
  stern = estrelas(600)
end
function degrade(intervalo, cor, largura, altura, transparencia)
  hInd = altura/intervalo
  for i = 1, intervalo do
    love.graphics.setColor(cor[1], cor[2], cor[3], (1 - (i/intervalo))*transparencia)
    love.graphics.rectangle('fill', 0, 600 - (i*hInd), largura, hInd)
  end
end


function dualDegrade(intervalo, cor, largura, altura, transparencia, x, y)
  hInd = altura/intervalo
  for i = 1, intervalo do
    love.graphics.setColor(cor[1], cor[2], cor[3], (1 - (i/intervalo))*transparencia)
    love.graphics.rectangle('fill', x, y - (i*hInd), largura, hInd)
    love.graphics.rectangle('fill', x, y + (i*hInd), largura, hInd)
  end
end

function transicao(vI, vF, iA, iF)
  local vA = vI + ((iA/iF)*(vF - vI))
  return vA
end

function transicao_cor(cor1, cor2, iA, iF)
  local r = transicao(cor1[1], cor2[1], iA, iF)
  local g = transicao(cor1[2], cor2[2], iA, iF)
  local b = transicao(cor1[3], cor2[3], iA, iF)
  return {r, g, b}
end

function horaToAngulo(hora)
  local escala = (2*pi)/(24*60)
  local angulo = escala*hora
  return angulo + pi/2
end



function dia(hora, xC, yC, raio, estrelas)
  local CeuNoite = {0, .1, .3}
  local CeuMadrugada = {0.3, .3, .8}
  local CeuDia = {0.54, .81, .94}
  hora = hora/60
  local hDegrade = 0
  local tDegrade = 0
  local angulo = transicao(0, math.pi, hora, 12)
  local xSol = xC - (math.cos(angulo)*raio)
  local ySol = yC - (math.sin(angulo)*raio)
  if hora < 2 then
    if hora <= 1 then
      corDoCeu = transicao_cor(CeuNoite, CeuMadrugada, hora, 1)
      hDegrade = transicao(0, 200, hora, 1)
      tDegrade = transicao(0, .6, hora, 1)
      tLua = transicao(1, 0, hora, 1)
      tEstrelas = transicao(1, 0, hora, 1)
    else
      corDoCeu = transicao_cor(CeuMadrugada, CeuDia, hora - 1, 1)
      tDegrade = transicao(.6, 0, hora-1, 1)
      hDegrade = 200
      tLua = 0
    end
  end  
  if hora > 10 and hora < 12 then
    if hora >= 11 then
      corDoCeu = transicao_cor(CeuMadrugada, CeuNoite, hora-11, 1)
      hDegrade = 200
      tDegrade = transicao(.6, 0, hora-11, 1)
      tLua = 1
    else
      corDoCeu = transicao_cor(CeuDia, CeuMadrugada, hora - 10, 1)
      hDegrade = 200
      tDegrade = transicao(0, .6, hora-10, 1)
      tLua = transicao(0, 1, hora-10, 1)
      tEstrelas = transicao(0, 1, hora - 10, 1)
    end
  end
  if hora > 12 and hora < 13 then
    tEstrelas = 1
    tLua = 1
  elseif hora < 24 and hora > 23 then
    tEstrelas = 1
    tLua = 1
  end
  if hora > 2 and hora < 10 then
    tLua = 0
    tEstrelas = 0
  end
  if hora > 12 and hora < 24 then
    tLua = 1
    tEstrelas = 1
  end
  love.graphics.setColor(corDoCeu[1], corDoCeu[2], corDoCeu[3])
  love.graphics.rectangle('fill', 0,0,1400, 600)
  love.graphics.setColor(0,0,0)
  local corDegrade = {.8, .7, 0}
  degrade(hDegrade, corDegrade, 1400, hDegrade, tDegrade)
  love.graphics.setColor(1,1,0)
  love.graphics.circle('fill', xSol, ySol, 30)
  love.graphics.setColor(1,1,1, tEstrelas)
  for i = 1, #estrelas do
    love.graphics.points(estrelas[i][1], estrelas[i][2])
  end
  lua(100, 100, 30, tLua)
end


function noite(hora, xC, yC, raio)
  local corDoCeu
end

function fundo.update(dt)
  xM, yM = love.mouse.getPosition()
  if hora/60 <= 24 then
    hora = hora + 0.5
  else hora = 0
  end
  angulo = horaToAngulo(hora)
  if (hora/60) > 12 then
    boolLamp = true
  else
    boolLamp = false
  end
  for i = 1, #lampadas_acesas do
    lampadas_acesas[i] = boolLamp
  end
end

function fundo.keypressed(key)
  if key == 'm' then
    raio_circles_lua = raio_circles_lua + 1
  elseif key == 'n' then
    raio_circles_lua = raio_circles_lua - 1
  end
  if key == 't' then
    hora = 0
  end
end

function fundo.draw()
  love.graphics.translate(-300, 0)
  local centroX = 400
  local centroY = 0
  local raio = 300
  xSol = centroX + seno(angulo)*raio
  ySol = centroY + coss(angulo)*raio
  xLua = centroX + seno(angulo+pi)*raio
  yLua = centroY + coss(angulo+pi)*raio
  love.graphics.setColor(1,1,1)
  lg.circle('fill', xLua, yLua, 10)
  lg.setColor(1,1,0)
  lg.circle('fill', xSol, ySol, 10)
  dia(hora, 700, 600, 450, stern)
  love.graphics.setColor(1,0,0)
--love.graphics.setBackgroundColor(0,0.1,0.3)
--love.graphics.setColor(1,1,1)
--for i = 1, #stern do
--  love.graphics.points(stern[i][1], stern[i][2])
--end
  for i = 1, #circles_lua do
    love.graphics.circle('fill',circles_lua[i][1], circles_lua[i][2], circles_lua[i][3])
  end
  love.graphics.circle('fill',xM, yM, raio_circles_lua)
  love.graphics.setColor(0,0,0)
  love.graphics.translate(300, 0)
end
function fundo.mousepressed(x, y)
  table.insert(circles_lua, {x, y, raio_circles_lua})
end

return fundo