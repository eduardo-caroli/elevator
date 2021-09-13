elevador = {}

function draw_doors(x, y, x_de_abertura_das_portas)
  local w = largura_da_tela / 8
  local h = 130
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
  end
end

function set_doors()
  if x_de_abertura_das_portas > 30 then
    x_de_abertura_das_portas = x_de_abertura_das_portas - 0.5
  elseif x_de_abertura_das_portas < 10 then
    x_de_abertura_das_portas = x_de_abertura_das_portas + 0.5
  end
end

function vetor(x, y, mag, esc)
  if valores_booleanos_dos_botoes_do_menu_opcoes[4] then
  --a escala é um valor em pixels correspondente a cada Newton de força
  --recomenda-se que seja igual a 1/100
  esc = esc or 1/120
  local h = mag*esc
  if h < 0 then
    love.graphics.setColor(0,0,1)
  else
    love.graphics.setColor(1,0,0)
  end
  love.graphics.line(x, y, x, y+h)
  local sentido = h/math.abs(h)
  love.graphics.polygon('fill', x - 10, y + h, x + 10, y + h, x, y + h + (10*sentido))
  end
end

function precoenergia(j)
  kwh = j * 25 / 9
  kwh = kwh / (10^7)
  preco = .68
  custo = preco * kwh
  return custo
end

function velocimetro(vel, xCentro, yCentro, r)
  love.graphics.setColor(.4, .4, .4)
  love.graphics.arc('fill', xCentro, yCentro, 11*r/8, -(7 * ((math.pi)/6)),  ((math.pi)/6))
  love.graphics.setColor(0,0,0)
  love.graphics.arc('line', xCentro, yCentro, 11*r/8, -(7 * ((math.pi)/6)),  ((math.pi)/6))
  love.graphics.setColor(.65, .65, .65)
  love.graphics.circle('fill', xCentro, yCentro, 19*r/16)
  love.graphics.setColor(0,0,0)
  love.graphics.circle('line', xCentro, yCentro, 19*r/16)
  parafuso(xCentro + (r*20.5/16)*math.cos((math.pi)/10), yCentro + (r*20.5/16)*math.sin((math.pi)/10), r/18, 1.9871)
  parafuso(xCentro + (r*20.5/16)*math.cos(-math.pi/5), yCentro + (r*20.5/16)*math.sin(-math.pi/5), r/18, 1.9871)
  parafuso(xCentro + (r*20.5/16)*math.cos(-8*math.pi/10), yCentro + (r*20.5/16)*math.sin(-8*math.pi/10), r/18, 1.9871)
  parafuso(xCentro + (r*20.5/16)*math.cos((math.pi)-math.pi/10), yCentro + (r*20.5/16)*math.sin((math.pi)-math.pi/10), r/18, 1.11091)
  parafuso(xCentro + (r*20.5/16)*math.cos(-math.pi/2), yCentro + (r*20.5/16)*math.sin(-math.pi/2), r/18, 1.11091)
  local angulo_inicial = 7 * math.pi / 6
  local angulo_atual = angulo_inicial + vel*math.pi/2
  love.graphics.setColor(0,0,0)
  love.graphics.circle('fill', xCentro, yCentro, r)
  comp_x = (r/2)*math.cos(angulo_atual)
  comp_y = (r/2)*math.sin(angulo_atual)
  love.graphics.setColor(1,0,0)
  love.graphics.line(xCentro, yCentro, xCentro + comp_x, yCentro + comp_y)
  for i = -1, 11 do
    love.graphics.setColor(1,1,1)
    local angulo = angulo_inicial + math.pi*i/15
    coord_x = r*math.cos(angulo)
    coord_x_2 = (9/10)*r*math.cos(angulo)
    coord_y = r*math.sin(angulo)
    coord_y_2 = (9/10)*r*math.sin(angulo)
    love.graphics.line(xCentro+coord_x, yCentro+coord_y, xCentro+coord_x_2, yCentro+coord_y_2)
  end
end



--CONSTANTES--
altura_da_tela = love.graphics.getPixelHeight()
largura_da_tela = love.graphics.getPixelWidth()
--Esse é o fator de conversão metros/pixels
MtoP = 199.8/3.5


--Carregamos, no callback love.load, apenas valores que, fora dela, poderiam
--causar lentidão no programa. Os valores usados pelo módulo love.physics fo-
--ram, de um modo geral, carregados aqui.
local world = love.physics.newWorld(0, 0, true)
local objects = {}
objects.elevador = {}
objects.box = {}
objects.elevador.body = love.physics.newBody(world, 400, 450, "dynamic")
objects.elevador.shape = love.physics.newRectangleShape(20, 20)
objects.elevador.fixture = love.physics.newFixture(objects.elevador.body, objects.elevador.shape)
objects.elevador.body:setLinearVelocity(0, 0)
local oe = objects.elevador
oeb = objects.elevador.body
local massa_contrapeso = 500
local massa_elevador = 800
oeb:setMass(500)
local pedido = 1
local cronometro = 0
a = 0
g = 9.81
passageiros = {}
destino_atual_da_lista_passageiros = 2
massa_passageiros = 0
pedido_mais_longo = {0, 0, false, 0}
tempos_dos_pedidos = {}
energia_total_do_motor = 0
potencias = {}
potencia = 0
energia = 0
fNormal = 0


--FUNÇÕES NÃO-CALLBACK--

function normal(a, massa_passageiros, g)
  return (a-g)*massa_passageiros
end

function determina_intervalos_iguais(t, pos)
  local posicoes = {}
  local inicio = 1
  local fim = 1
  local finais = {}
  local inicios = {}
  for i = 1, #t-1 do
    if t[i][pos] ~= t[i+1][1] then
      table.insert(finais, i)
    end
  end
  table.insert(inicios, 1)
  for i = 1, #finais do
    table.insert(inicios, finais[i] + 1)
  end
  table.insert(finais,#t)
  for i = 1, #inicios do
    table.insert(posicoes, {inicios[i], finais[i]})
  end
  return posicoes
end

function potenciaTotal(pot)
  local total = 0
  local intervalos = determina_intervalos_iguais(pot, 1)
  local t = 0
  local p = 0
  for i = 1, #intervalos do
    local inicio = intervalos[i][1]
    local fim = intervalos[i][2]
    t = pot[fim][2] - pot[inicio][2]
    p = pot[inicio][1]
    total = total + t*p
  end
  return total
end


function passou_pelo_andar_de_origem(andar)
  for i = 1, #tempos_dos_pedidos do
    if tempos_dos_pedidos[i][1] == andar then
      tempos_dos_pedidos[i][3] = true
    end
  end
end

function atualiza_timer_pedidos(dt)
  for i = 1, #tempos_dos_pedidos do
    if tempos_dos_pedidos[i][3] then
      tempos_dos_pedidos[i][4] = tempos_dos_pedidos[i][4] + dt
    end
  end
end

function encerra_timer_pedidos(andar, vMax)
  local remover = {}
  for i = 1, #tempos_dos_pedidos do
    if tempos_dos_pedidos[i][2] == andar then
      if tempos_dos_pedidos[i][4] > pedido_mais_longo[4] then
        pedido_mais_longo = tempos_dos_pedidos[i]
      end
      table.insert(remover, i)
    end
  end
  for i = #remover, 1, -1 do
    table.remove(tempos_dos_pedidos, i)
  end
end  


function passageiro_sai(andar)
  local remover = {}
  for i = 1, #passageiros do
    if passageiros[i][2] == andar then
      table.insert(remover, i)
    end
  end
  for i = #remover, 1, -1 do
    index = remover[i]
    table.remove(passageiros, index)
  end
end

function passageiro_entra(andar_de_destino)
  local peso = math.random(50, 100)
  table.insert(passageiros, {peso, andar_de_destino})
end

function peso_passageiros()
  local peso = 0
  for i = 1, #passageiros do
    peso = peso + passageiros[i][1]
  end
  return peso
end

function determina_tracao_contrapeso(a, mC, g)
  local pC = mC * g
  local tC = pC + (mC * a) 
  return tC
end

function determina_tracao_motor(a, mC, g, mE)
  local pE = g*mE
  local t2 = determina_tracao_contrapeso(a, mC, g)
  local t1 = pE - (mE*a) - t2
  return t1
end


--[[
    Essas funções realizam a escrita dos dados no arquivo csv. A função 'substitui' é responsável por trocar o '.' por uma vírgula
    em cada número decimal exportado. Tentei usar o método gsub, mas sem muito sucesso, por isso desenvolvi essa função.
--]]
function substitui(string)
  local a = ''
  for i = 1, #string do
    if string:sub(i,i) == '.' then
      a = a .. ','
    else
      a = a .. string:sub(i,i)
    end
  end
  return a
end
--[[
    Essa função abre o arquivo csv e escreve a primeira linha, isto é, a legenda.
--]]
function open_file(filename)
  arquivocsv= io.open(filename, 'w')
  arquivocsv:write('Tempo;Altura;Velocidade;Força do Motor;Força do Contrapeso;Energia do Motor;Potencia do elevador\n')
end
--[[
    Essa função escreve uma linha de dados no csv a cada iteração, motivo pelo qual é chamada na love.update(dt).
--]]



function escreve(tempo, altura, velocidade, fMotor, fContrapeso, eMotor,potencia)
  altura = -altura/MtoP + 7.8
  tempo = substitui(tostring(tempo))
  altura = substitui(tostring(altura))
  velocidade = substitui(tostring(velocidade))
  fMotor = substitui(tostring(fMotor))
  fContrapeso = substitui(tostring(fContrapeso))
  eMotor = substitui(tostring(eMotor))
  potencia = substitui(tostring(custo))
  string = tempo..';'..altura..';'..velocidade..';'..fMotor..';'..fContrapeso..';'..eMotor..';'..potencia..'\n'
  arquivocsv:write(string)
end
open_file('dados.csv')
--[[
    Essa função faz com que o elevador se movimente até um andar, mas apenas se
    o movimento for de subida. Ela acelera o elevador, mantém a velocidade constante depois e,
    por fim, desacelera quando se aproxima do andar.
    O valor 63.5 foi determinado experimentalmente, e é a distância em pixels necessária para a
    frenagem do elevador quando sua velocidade é 1.5*MtoP e a aceleração oposta é de 1*MtoP.
    Para alterar a velocidade do elevador, é necessário, desse modo, alterar também o valor de
    63.5 e o da aceleração.
    O parâmetro body recebe um objeto como 'objects.elevador.body'
--]]
function sobe(body, andar)
  local velx, vely = body:getLinearVelocity()
  local y_atual = body:getY()
  local massa = body:getMass()
  if math.abs(coordenada_do_andar_em_pixels(andar)-y_atual) < 64 and vely < 0 then
    body:applyForce(0, massa*1*MtoP)
    a = 1
  elseif vely > -1.5*MtoP then
    body:applyForce(0, -massa*1*MtoP)
    a = -1
  else
    a = 0
  end
end

--[[
    A função desce faz algo muito similar à função sobe(). A diferença é que desce()
    realiza, exclusivamente, movimentos de descida.
--]]

function desce(body, andar)
  local velx, vely = body:getLinearVelocity()
  local y_atual = body:getY()
  local massa = body:getMass()
  if math.abs(coordenada_do_andar_em_pixels(andar)-y_atual) < 64 and vely > 0 then
    body:applyForce(0, -massa*1*MtoP)
    a = -1
  elseif vely < 1.5*MtoP then
    body:applyForce(0, massa*1*MtoP)
    a = 1
  else
    a = 0
  end
end

--[[
    Essa função distingue pedidos de subida e descida e, com base nisso, chama
    as funções sobe() ou desce(), que não são diretamente chamadas na love.update
--]]
function translada(body, andar)
  abrir_portas_do_elevador = false
  local y_atual = body:getY()
  local y_andar = coordenada_do_andar_em_pixels(andar)
  local distancia = y_andar - y_atual
  if distancia < 0 then
    sobe(body, andar)
  elseif distancia > 0 then
    desce(body,andar)
  end
end



--[[
    Essa função recebe um valor de andar(1 = térreo, 2 = 1º andar ...) e retorna a altura, em pixels, na qual o
    canto superior esquerdo do elevador deverá parar.
--]]
function coordenada_do_andar_em_pixels(andar)
  ----Essa função retorna a coordenada, em pixels, em que o elevador deverá parar----
  --Cada andar tem 200 px de altura. A altura inicial do elevador é 1.3 * largura da tela / 8. Assim:
  return (600 - ((andar-1) * 200) - 1.3 * largura_da_tela / 8 - altura_da_tela/30)
end



--[[
    O funcionamento dessa função é relativamente simples. Ela recebe um objeto do tipo love.physics.body e
    extrai sua coordenada y.
--]]
function chegou_ao_andar(body, andar)
  local y_atual = body:getY()
  local y_final = coordenada_do_andar_em_pixels(andar)
  if math.abs(y_atual - y_final) < 0.3 then
    return true
  else
    return false
  end
end

--[[
    Essa função tem como único objetivo exportar o valor da coordenada y do elevador
    para a main, habilitando, assim, o acompanhamento da câmera.
--]]
function valor()
  return oeb:getY()
end





--FUNÇÕES CALLBACK--

--[[
    A elevador.draw desenha APENAS o elevador em si, e faz o mecanismo de abertura/fechamento de portas.
--]]
function elevador.draw()
  if valores_booleanos_dos_botoes_do_menu_opcoes[2] then
    velocimetro(math.abs(velocidadeY/MtoP), -150, oeb:getY()-35, 65)
  end
  love.graphics.rectangle("line", objects.elevador.body:getX(), objects.elevador.body:getY(), 20, 20)
  --[[
      Aqui, desenhamos o elevador de fato
  --]]
  local w = largura_da_tela / 8
  local x = 7 * largura_da_tela / 16
  local h = 1.3 * w
  local y = oeb:getY()
  
  local TmO = determina_tracao_motor(a, massa_contrapeso, g, massa_elevador)
--  love.graphics.print(tostring(massa_contrapeso), 120, y+20)
--  love.graphics.print(tostring(massa_elevador), 120, y+40)
  
  love.graphics.setColor(203/255,65/255,84/255)
  love.graphics.rectangle('fill', 390, altura_do_telhado-5, 20, 4.5)
  
  
  love.graphics.setColor(152/255, 152/255, 152/255)
  love.graphics.rectangle("fill", x, y, w, h)
  --Aqui, desenhamos a "caixa" do elevador
  

  
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
  
--  love.graphics.setColor(211/255, 211/255, 211/255)
--  love.graphics.rectangle("fill",x, y, x_de_abertura_das_portas, h)
--  love.graphics.rectangle("fill",x + w, y, -x_de_abertura_das_portas, h)
--  love.graphics.setColor(0,0,0)
--  if x_de_abertura_das_portas > 0 and x_de_abertura_das_portas < w/2 then
--    love.graphics.rectangle("line",x, y, x_de_abertura_das_portas, h)
--    love.graphics.rectangle("line",x + w, y, -x_de_abertura_das_portas, h)
--  elseif x_de_abertura_das_portas >= w/2 then
--    love.graphics.rectangle("line",x, y, w / 2, h)
--    love.graphics.rectangle("line",x , y, w , h)
--  else
--    love.graphics.rectangle("line", x, y, w, h)
--  end
  vetor(x+15, y, -fMotor)
  vetor(x+85, y, -fContrapeso)
  vetor(x+100, y+(h/2), 800*g)
  vetor(x, y+(h/2), massa_passageiros*g)
  vetor(x, y+(h/2), fNormal)
  love.graphics.setColor(0,0,0)
  love.graphics.rectangle('line', x, y, w, h)
end



function elevador.load()
  som_elevador = love.audio.newSource("sounds/elevador.mp3", "static")
  x_de_abertura_das_portas = 0
  abrir_portas_do_elevador = false
  fMotor = 0
  fContrapeso = 0
  custo_total = 0
end

function elevador.update(dt)
  local height = oeb:getY()
  velocidadeX, velocidadeY = oeb:getLinearVelocity()
  fMotor = determina_tracao_motor(a, massa_contrapeso, g, massa_elevador)
  eMotor = fMotor * (velocidadeY/MtoP)
  fNormal = normal(a, massa_passageiros, g)
  fContrapeso = determina_tracao_contrapeso(a, massa_contrapeso, g)
  escreve(tempo, height, velocidadeY, fMotor, fContrapeso, eMotor,custo,total)
  world:update(dt)
  cronometro = cronometro + dt
  t = t + dt
  massa_passageiros = peso_passageiros()
  massa_elevador = 800+ massa_passageiros
  atualiza_timer_pedidos(dt)
  energia = energia + math.abs(eMotor*dt)
  custo_total = precoenergia(energia)
  table.insert(potencias, {math.abs(eMotor), dt})
  if t > 5 then
    local andar = pedidos[1]
    if not chegou_ao_andar(oeb, andar) then
      translada(oeb, andar)
      cronometro = 0
    else
      passageiro_sai(andar)
      passou_pelo_andar_de_origem(andar)
      encerra_timer_pedidos(andar, pedido_mais_longo)
      a = 0
      oeb:setLinearVelocity(0,0)
      if cronometro < 1.1 and cronometro > 1 then
        love.audio.play(som_elevador)
      end
      if cronometro > 1.2 and cronometro < 4 then
        abrir_portas_do_elevador = true
      end
      if cronometro > 5 and cronometro < 7 and pedido < #pedidos then
        abrir_portas_do_elevador = false
      end
      if pedido < #pedidos and cronometro > 7.5 then
        table.remove(pedidos,1)
      end
    end
  end
  
  if abrir_portas_do_elevador == false and x_de_abertura_das_portas < largura_da_tela/16 then
    x_de_abertura_das_portas = x_de_abertura_das_portas + 0.5
  elseif abrir_portas_do_elevador == true and x_de_abertura_das_portas > 0 then
    x_de_abertura_das_portas = x_de_abertura_das_portas - 0.5
  end
end


return elevador