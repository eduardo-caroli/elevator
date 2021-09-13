io.stdout:setvbuf('no')
local simulacao = require 'simulacao'
local menu = require "menu"
local cenario = require 'cenario'
local elevador = require 'elevador'
local duto = require 'duto'
local interruptor = require 'interruptor'
local controles = require 'controles'
local opcoes = require 'opcoes'
local trajetoria = require 'trajetoria'
local menu_pedidos = require 'menu_pedidos'
local manutencao = require 'manutencao'
local auxiliar_manutencao = require 'auxiliar_manutencao' 
local animacao_defeito = require 'animacao_defeito'
local fundo = require 'fundo'
local painel = require 'painel'
local passageiro = require 'passageiro'
local engineman = require 'engineman'

--CONSTANTES--
altura_da_tela = love.graphics.getPixelHeight()
largura_da_tela = love.graphics.getPixelWidth()
numero_de_andares = 6
tahoma = love.graphics.newFont('fonts/tahoma.ttf', 25)
h_elevador = 1.3 * love.graphics.getPixelWidth() / 8
  --[[
      Essa variável será usada em cenario.lua e em chamine.lua. representa a ordenada (y) da linha inferior do telhado.
      A "espessura" do telhado é de 50 px.
  --]]
  altura_do_telhado = altura_da_tela - (numero_de_andares * altura_da_tela / 3) - 100





--FUNÇÕES CALLBACK--
function love.keypressed(key)
  currState.keypressed(key)
  if key == "l" or key == "d" then
    for p = 1, 6 do
      love.audio.play(som_do_interruptor)
    end
  end
  if key == 't' then
    timer_manutencao = 0
  end
end

function love.mousepressed(x, y)
  for andar  = 1, numero_de_andares, 1 do
    if toca_interruptor(570 + 144/2.1, 29 * altura_da_tela / 30 - 72 - ((andar - 1) * altura_da_tela / 3) + y_camera, 10, 20, x, y) then
      love.audio.play(som_do_interruptor)
    end
    if toca_interruptor(70 + 144/2.1, 29 * altura_da_tela / 30 - 72 - ((andar - 1) * altura_da_tela / 3) + y_camera, 10, 20, x, y) and andar > 2 then
      love.audio.play(som_da_campainha)
    end
  end
  if porta_aberta == false and toca_interruptor(70 + 144/2.1, 19 * altura_da_tela / 30 - 72 + y_camera, 10, 20, x, y) == true then
    porta_aberta = true
    som_campainha_1 = love.audio.newSource("sounds/som.mp3", "stream")
    love.audio.play(som_campainha_1)
  else
    porta_aberta = false
    love.audio.pause(som_campainha_1)
  end
  if toca_botao_de_cima_do_elevador(x, y) == true then
    love.audio.play(som_do_interruptor)
  end
  if toca_botao_de_baixo_do_elevador(x, y) == true then
    love.audio.play(som_do_interruptor)
  end

determina_o_andar_em_que_o_interruptor_foi_ligado(x, y)
if toca_interruptor(450, 260, 300, 80, x, y) then
  abrir_tela = true
  segue_txt = true
  segue_txt = true
elseif toca_interruptor(70,260,300,80,x,y) then
  abrir_tela = true
  segue_txt = false
end
currState.mousepressed(x, y)
end
function love.update(dt)
  local mute = export_mute()
  if mute then
    love.audio.setVolume(0)
  else
    love.audio.setVolume(0.5)
  end
  tempo = tempo + dt
  --t = t + dt
--  chamine.update(dt)
  y_camera = -valor() + altura_da_tela - 150
  currState.update(dt)
end

function love.load()
  --Essa variável permite distinguir os menus entre menu de tela inicial
  --e menu de pausa. Só será true até a simulação ser iniciada pela primeira
  --vez. Depois, será false.
  tela_inicial = true
  --Essa variável é vital na mudança menu/simulação
  currState = menu
  --Essa variável distingue se o modo rodado será simulação ou jogo
  isGame =false
  tempo = 0
  segue_txt = nil
  trajetoria.load()
  engineman.load()
  fundo.load()
  passageiro.load()
  painel.load()
  opcoes.load()
  cenario.load()
  controles.load()
  elevador.load()
  duto.load()
  interruptor.load()
  menu.load()
  menu_pedidos.load()
  manutencao.load()
  auxiliar_manutencao.load()
  animacao_defeito.load()
  currState.load()
  pedidos = p('pedidos.txt')
  t = 0
  --[[
      Aqui, criamos uma tabela que será exportada para a função cenário. A tabela contém valores de abrir ou fechar para as portas
      de todos os andares menos do primeiro (porta roxa). Note também que não há porta no térreo, de modo que o # da lista é igual
      ao número de andares -2.
  --]]
  abrir_portas = {}
  for i = 1,numero_de_andares-1 do
    table.insert(abrir_portas, false)
  end
  y_camera = 0
--  chamine.load()
  som_da_campainha = love.audio.newSource("sounds/doorbell-fx.mp3", "static")
  som_do_interruptor = love.audio.newSource("sounds/interruptor.mp3", "static")
  som_do_elevador = love.audio.newSource("sounds/elevador.mp3", "stream")
end
function love.draw()
  if currState == simulacao or currState == manutencao then
    love.graphics.translate(300, 0)
  end
  currState.draw()
end



--FUNÇÕES NÃO-CALLBACK--

--[[
    Essa função lê os pedidos de um arquivo .txt e organiza na ordem em que serão atendidos.
--]]
function p(filename)
  file = io.open(filename, 'r')
  local i = 1
  local requests = {}
  local origem
  local destino 
  local subida= {}
  local descida = {}
  for line in file:lines() do
    local posvirg = line:find(',')
    
    origem = tonumber(line:sub(1,posvirg-1))
    destino = tonumber(line:sub(posvirg+1))
    if origem < destino then 
      table.insert(subida,origem)
      table.insert(subida,destino)
    elseif origem > destino then
      table.insert(descida,destino)
      table.insert(descida,origem)
    end
  end
  
  table.sort(descida, function(a, b) 
      return a > b 
  end) 
  table.sort(subida)
  for i = 1, #subida do 
    if subida[i] ~= requests[#requests] then
      table.insert(requests,subida[i])
    end
  end
  for i = 1, #descida do
    if descida[i] ~= requests[#requests] then
      table.insert(requests,descida[i])
    end
  end
  file:close()
  return requests
end

--[[
    Essa função verifica se a parte inferior do botão do elevador foi clicada. Ela usa a função
  "toca_interruptor" e passa como argumentos a coordenada "x" do canto superior esquerdo do
  interruptor, sua coordenada y mais a metade de sua altura, sua largura e metade de sua altura,
  de modo que cria uma "hitbox" que corresponde apenas à metade inferior.
--]]
function toca_botao_de_baixo_do_elevador(xMouse, yMouse)
  for andar = 1, numero_de_andares, 1 do
    if toca_interruptor(330, 29*altura_da_tela/30 - 67 - ((andar - 1) * altura_da_tela/3), 10, 35/4, xMouse, yMouse) then
        return true
    end
  end
  return false
end

--[[
    Essa função verifica se a parte superior do botão do elevador foi clicada. Ela usa a função
  "toca_interruptor" e passa como argumentos as coordenadas do interruptor, sua largura e metade
  de sua altura, de modo que cria uma "hitbox" que corresponde apenas à metade superior.
--]]
function toca_botao_de_cima_do_elevador(xMouse, yMouse)
  for andar = 1,numero_de_andares,1 do
    if toca_interruptor(330, 29*altura_da_tela/30 - 67 - 35/4 - ((andar -1 ) * altura_da_tela/3), 10, 35/4, xMouse, yMouse) then
      return true
    end
  end
  return false
end
--[[
    Essa função verifica se algum dos interruptores em algum dos andares foi ligado.
  Essa função funciona em conjunto com uma tabela 'lampadas_acesas', que tem um valor
  booleano para cada andar. Se o valor for true, todas as lâmpadas se acendem. Se for
  false, ficam apagadas.
--]]
function determina_o_andar_em_que_o_interruptor_foi_ligado(x, y)
  for andar = 1, numero_de_andares , 1 do
    if toca_interruptor(570 + 144/2.1, (29 * altura_da_tela / 30) - 72 - ((andar-1) * altura_da_tela / 3), 10, 20, x, y) == true then
      if lampadas_acesas[andar] == false then
        lampadas_acesas[andar] = true
      else
        lampadas_acesas[andar] = false
      end
    end
    if toca_interruptor(70 + 144/2.1, (29 * altura_da_tela / 30) - 72 - ((andar-1) * altura_da_tela / 3), 10, 20, x, y) == true then
      abrir_portas[andar-2] = true
      t = 0
    end
  end
end

--[[
      Essa função recebe as coordenadas do canto superior esquerdo, a largura e a altura
    de um interruptor retangular e recebe também as coordenadas do mouse no momento em
    que houve um "clique", e determina se o interruptor foi ou não clicado. Se sim, a
    função retorna true. Se não, retorna false.
--]]
function toca_interruptor(x, y, w, h, xMouse, yMouse)
  y = y + y_camera
  if xMouse > x and xMouse < x + w and yMouse > y and yMouse < y + h then
    return true
  else
    return false
  end
end
