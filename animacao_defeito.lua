animacao_defeito = {}

function anim_portas_elevador(x, abre)
  if abre then
    if x < 30 then
      x = x + .5
    else
      abre = false
    end
  else
    if x > 10 then
      x = x - .5
    else
      abre = true
    end
  end
  return {x, abre}
end

function elevador_preenchido(x, y, w, x_de_abertura_das_portas)
  local h = 1.3*w
  love.graphics.setColor(152/255, 152/255, 152/255)
  love.graphics.rectangle("fill", x, y, w, h)
  love.graphics.setColor(0,0,0)
  love.graphics.rectangle('line', x, y, w, h)
  --Aqui, desenhamos a "caixa" do elevador
  --Observe se vamos ter problemas aqui defninindo largura_da_tela fora da função
  
  love.graphics.setColor(77/255, 166/255, 1)
  love.graphics.rectangle("fill", x + w / 10, y + w / 10, 4 * w / 5, h / 2 )
  --Aqui desenhamos o espelho
  
  love.graphics.setColor(100/255, 200/255, 1)
  local xM = x + w / 2
  local yM = y + w / 10 + h / 4
  local cX = 4 * w / 10
  local cY = h / 4
  love.graphics.setColor(100/255, 200/255, 1)
  local xI, xS = xM - 3*cX/4, xM - cX/4
  local yI, yS = yM - cY/4, yM - 3*cY/4
  love.graphics.line(xI, yI, xS, yS)
  love.graphics.line(xI + cX/4, yI, xS, yS + cY/4)
  love.graphics.line(xI, yI - cY/4, xS - cX/4, yS)
  --Aqui, desenhamos o reflexo no espelho
  
  love.graphics.setColor(211/255, 211/255, 211/255)
  love.graphics.rectangle("fill", x + w/10, y + w / 5 + h / 2, 4 * w / 5, w / 20)
  --Aqui, desenhamos a "barra" do elevador
  
  love.graphics.setColor(0,0,0)
  love.graphics.setLineWidth(0.1)
  love.graphics.rectangle("line", x + w/10, y + w / 5 + h / 2, 4 * w / 5, w / 20)
  love.graphics.rectangle("line", x + w / 10, y + w / 10, 4 * w / 5, h / 2 )
  
  love.graphics.setColor(211/255, 211/255, 211/255)
  love.graphics.rectangle("fill",x, y, x_de_abertura_das_portas, h)
  love.graphics.rectangle("fill",x + w, y, -x_de_abertura_das_portas, h)
  love.graphics.setColor(0,0,0)
  if x_de_abertura_das_portas > 0 and x_de_abertura_das_portas < w/2 then
    love.graphics.rectangle("line",x, y, x_de_abertura_das_portas, h)
    love.graphics.rectangle("line",x + w, y, -x_de_abertura_das_portas, h)
  elseif x_de_abertura_das_portas >= w/2 then
    love.graphics.rectangle("line",x, y, w / 2, h)
    love.graphics.rectangle("line",x , y, w , h)
  else
    love.graphics.rectangle("line", x, y, w, h)
  end
  --processo de abertura e fechamento de portas

end


function ruptura(dInicios, dPontas, timer, fRuptura, rompeu, totalFrames, dt)
  if fRuptura < totalFrames - 1 and not rompeu then
    dInicios = dInicios + .5
    timer = timer + dt
    if timer > .3 and dInicios > 20 then
      fRuptura = fRuptura + 1
      timer = 0
    end
  elseif dPontas < 180 then
    dPontas = dPontas + 8
    rompeu = true
  else
    rompeu = false
    timer = 0
    dInicios, dPontas = 0, 0
    fRuptura = 1
  end
  return {dInicios, dPontas, timer, fRuptura, rompeu}
end

function desenha_ruptura(x, y, dInicios, dPontas, fRuptura, rachadura)
  love.graphics.setColor(.789,.789,.789)
  love.graphics.rectangle('fill', x - 70 - dInicios, y, 70 + dInicios - dPontas, 50)
  love.graphics.rectangle('fill', x + dPontas, y, 70 + dInicios - dPontas, 50)
  love.graphics.setColor(0,0,0)
  love.graphics.setLineWidth(2)
  if fRuptura > 1 then
    for i = 1, fRuptura do
      love.graphics.line(rachadura[i][1] + x + dPontas , rachadura[i][2]+y, rachadura[i+1][1]+ x + dPontas, rachadura[i+1][2]+y)
      love.graphics.line(rachadura[i][1] + x - dPontas, rachadura[i][2]+y, rachadura[i+1][1]+ x - dPontas, rachadura[i+1][2]+y)
    end
  end
  love.graphics.setLineWidth(1)
  danger_bar(x-70-dInicios, y,70 + dInicios-dPontas,50,6, false, true)
  danger_bar(x + dPontas, y,70 + dInicios - dPontas,50,6, false, true)
  love.graphics.setColor(.6,.6,.6)
  love.graphics.rectangle('fill', x-73, y-5, -125, 60)
  love.graphics.rectangle('fill', x+73, y-5, 125, 60)
end

function divideSheet(distancias_quads)
  distancias_quads = distancias_quads or {132, 263, 400, 524, 654, 785, 912, 1040, 1168, 1293, 1399}
  quads = {}
  quad = love.graphics.newQuad(0, 27, 89, 69, 1664, 128)
  table.insert(quads, quad)
  for i = 1, #distancias_quads do
    quad = love.graphics.newQuad(distancias_quads[i], 27, 96, 69, 1664, 128)
    table.insert(quads, quad)
  end
  return quads
end

function gera_ruptura_vertical(xI, yI, xF, yF)
  yA = yI
  xA = xI
  local i = 1
  pontos = {{xI, yI}}
  math.randomseed(os.time())
  while yA < yF do
    yA = yA + math.random(5, 10)
    xA = xI + ((i*math.random(1, 3)))
    i = -i
    if yA > yF then
      yA = yF
      xA = xF
    end
    table.insert(pontos, {xA, yA})
  end
  return pontos
end


function animacao_defeito.load()
  rachadura = gera_ruptura_vertical(0,0,0,50)
  quads_fumaca = divideSheet()
  fumaca = love.graphics.newImage('images/smoke.png')
  framefumaca = 1
  timerfumaca = 0
  dInicios = 0
  dPontas = 0
  frameRuptura = 1
  timerRuptura = 0
  caboRompeu = false
  x_portas_defeito = 20
  abre_portas_defeito = true
  mensagens_defeito = {
  {'Cabos Rompendo!', 400 - .85*(tahoma:getWidth('Cabos Rompendo!')/2), 450, .85},  
  {'Defeito nas Portas!', 400 - .85*(tahoma:getWidth('Defeito nas Portas!')/2), 450, .85},
  {'Pane no Motor!', 400 - .85*(tahoma:getWidth('Pane no Motor!')/2), 450, .85}
  }  
end

function danger_bar(x, y, w, h, nL, fill, cabo)
  wLine = w / (2*nL)
  for i = 0, nL-1 do
    if fill then
      love.graphics.polygon('fill', x + (i*2*wLine), y+h, x + wLine + (i*2*wLine), y+h, x + 2*wLine + (i*2*wLine), y, x + wLine +(i*2*wLine), y)
    else
      love.graphics.polygon('line', x + (i*2*wLine), y+h, x + wLine + (i*2*wLine), y+h, x + 2*wLine + (i*2*wLine), y, x + wLine +(i*2*wLine), y)
    end
  end
  if cabo then
    love.graphics.line(x, y, x+w, y)
    love.graphics.line(x, y+h, x+w, y+h)
  else
    love.graphics.rectangle('line', x, y, w, h)
  end
end

function motor_com_defeito(x, y)
  motor(x, y, 1.5)
  love.graphics.setColor(1,1,1)
  love.graphics.draw(fumaca, quads_fumaca[framefumaca], x + 7, y - 45, 0, .65, .65)
end

function cabos()
end

function animacao_defeito.draw()
  love.graphics.translate(0, -450 + y_cam)
  if defeitos[3] then
    motor_com_defeito(350, 350)
    love.graphics.setColor(0,0,0)
    love.graphics.print(mensagens_defeito[3][1], mensagens_defeito[3][2], mensagens_defeito[3][3], 0, mensagens_defeito[3][4], mensagens_defeito[3][4])
  end
  if defeitos[1] then
    love.graphics.setColor(0,0,0)
    love.graphics.print(mensagens_defeito[1][1], mensagens_defeito[1][2], mensagens_defeito[1][3], 0, mensagens_defeito[1][4], mensagens_defeito[1][4])
    love.graphics.setColor(0,0,0)
    desenha_ruptura(400, 350, dInicios, dPontas, frameRuptura, rachadura)
  end
  love.graphics.setColor(0,0,0)
  love.graphics.rectangle('line', 330, 300, 140, 140)
  love.graphics.setColor(.6,.6,.6)
  love.graphics.rectangle('fill', 300, 300, 29, 140)
  love.graphics.rectangle('fill', 471, 300, 29, 140)
  if defeitos[2] then
    love.graphics.setColor(0,0,0)
    love.graphics.print(mensagens_defeito[2][1], mensagens_defeito[2][2], mensagens_defeito[2][3], 0, mensagens_defeito[2][4], mensagens_defeito[2][4])
    elevador_preenchido(362.5, 324, 75, x_portas_defeito)
  end
  love.graphics.translate(0, 450 - y_cam)
end

function animacao_defeito.update(dt)
  valoresCabo = ruptura(dInicios, dPontas, timerRuptura, frameRuptura, caboRompeu, #rachadura, dt)
  dInicios, dPontas, timerRuptura = valoresCabo[1], valoresCabo[2], valoresCabo[3]
  frameRuptura, caboRompeu = valoresCabo[4], valoresCabo[5]
  timerfumaca = timerfumaca + dt
  if framefumaca < 12 then
    if timerfumaca > .08 then
      framefumaca = framefumaca + 1
      timerfumaca = 0
    end
  else
    framefumaca = 1
    timerfumaca = 0
  end
  valores_porta_defeito = anim_portas_elevador(x_portas_defeito, abre_portas_defeito)
  x_portas_defeito, abre_portas_defeito = valores_porta_defeito[1], valores_porta_defeito[2]
end

return animacao_defeito