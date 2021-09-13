local interruptor = {}
Cont = 0

function interruptor.load()
  sheet_interruptor = love.graphics.newImage("images/interruptor.png")
  quads_interruptor = {}
  frames_interruptor = {}
  for i = 1, 7 do
    table.insert(quads_interruptor, love.graphics.newQuad(15 + (i-1)*(44), 108, 40, 27, 422, 159))
    table.insert(frames_interruptor, 1)
  end
end

function interruptor.update(dt)
  for andar = 1, numero_de_andares do
    if lampadas_acesas[andar] == true and frames_interruptor[andar] > 1 then
      frames_interruptor[andar] = frames_interruptor[andar] - 1
      temp_interruptor = 0
    elseif lampadas_acesas[andar] == false and frames_interruptor[andar] < 5 then 
      frames_interruptor[andar] = frames_interruptor[andar] + 1
      temp_interruptor = 0
    end
  end
end

function interruptor.draw()
  for andar = 1, numero_de_andares do
    love.graphics.draw(sheet_interruptor, quads_interruptor[frames_interruptor[andar]], 570 + 144/2.1, math.pi/229 * altura_da_tela / 30 - 72 - ((andar - 4) * altura_da_tela / 3), math.pi/2, 1, 1, 20, 13.5)
  end
end

return interruptor