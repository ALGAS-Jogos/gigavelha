function drawStartMenu()
    y = 50
    love.graphics.setColor(0.1,0.1,0.1)
    love.graphics.printf("GigaVelha",font,5,y+5,screenw,"center")
    love.graphics.setColor(1,1,1)
    love.graphics.printf("GigaVelha",font,0,y,screenw,"center")
    y=screenh/2-font:getHeight()/2
    if menu=="start" then
        newDummyBoard()
        y=screenh-font:getHeight()-45
        btnWrap("Entrar na fila",y,function ()
            menu="waitingqueue"
            enterQueue(0)
        end)
        y=y-font:getHeight()-45
        btnWrap("Criar uma sala",y,function ()
            menu="waitingmyown"
            enterGame(channel)
        end)
        y=y-font:getHeight()-45
        btnWrap("Entrar em uma sala",y,function ()
            menu="typenumber"
        end)
        if (hspacing*3+20)<y-(50+font:getHeight()+15) then drawBoard(50+font:getHeight()+15) end
    elseif menu=="typenumber" then
        y=y-font:getHeight()-30
        love.graphics.printf("Digite o número da sala de alguém",font,0,y,screenw,"center")
        local _, wrap = font:getWrap("Digite o número da sala de alguém",screenw)
        y=y+(font:getHeight()*#wrap)+30
        textboxWrapper("Sala:",inputchannel,y)
        y=y+font:getHeight()+45
        btnWrap("Entrar",y,function ()
            if #inputchannel==5 then
                menu="game"
                enterGame(inputchannel)
                team=2
                myTurn=false
            else
                warning=true
                warningMsg="O jogo inserido não existe"
            end
        end)
        y=screenh-font:getHeight()-45
        btnWrap("Voltar",y,function ()
            menu="start"
            hub:unsubscribe()
        end)
    elseif menu=="waitingmyown" then
        love.graphics.printf("Sala: "..channel,font,0,y,screenw,"center")
        y=y+font:getHeight()
        love.graphics.printf("Esperando alguém entrar...",font,0,y,screenw,"center")
        y=screenh-font:getHeight()-45
        btnWrap("Voltar",y,function ()
            menu="start"
            hub:unsubscribe()
        end)
    elseif menu=="waitingqueue" then
        love.graphics.printf("Aguardando na fila!",font,0,y,screenw,"center")
        y=screenh-font:getHeight()-45
        btnWrap("Voltar",y,function ()
            menu="start"
            hub:unsubscribe()
        end)
    end
end

function drawGame()
    x = screenw/2-(wspacing*3)/2+wspacing
    y = 50
    for i=1,2 do
        love.graphics.setColor(1,1,1)
        love.graphics.rectangle('fill',x,y,10,hspacing*3)
        x=x+wspacing
    end
    x = screenw/2-(wspacing*3)/2
    y = 50+hspacing
    for i=1,2 do
        love.graphics.setColor(1,1,1)
        love.graphics.rectangle('fill',x,y,wspacing*3,10)
        y=y+hspacing
    end
    for i=1,9 do --search for any obj
        local obj = board[i]
        bx = (i-1)%3+1 --block x
        by = math.floor((i-1)/3)+1 --block y
        if obj==1 then
            local size = 25
            x = screenw/2-(wspacing*3)/2+(wspacing*(bx-1))+(wspacing/2-size/2)+5
            y = 50+(hspacing*(by-1))+(hspacing/2-size/2)+5
            love.graphics.setColor(redcolors[1])
            love.graphics.rectangle('fill',x,y,size,size)
        elseif obj==2 then
            local size = 25
            x = screenw/2-(wspacing*3)/2+(wspacing*(bx-1))+(wspacing/2-size/2)+5
            y = 50+(hspacing*(by-1))+(hspacing/2-size/2)+5
            love.graphics.setColor(bluecolors[1])
            love.graphics.rectangle('fill',x,y,size,size)
        elseif obj==3 then
            local size = 50
            x = screenw/2-(wspacing*3)/2+(wspacing*(bx-1))+(wspacing/2-size/2)+5
            y = 50+(hspacing*(by-1))+(hspacing/2-size/2)+5
            love.graphics.setColor(redcolors[2])
            love.graphics.rectangle('fill',x,y,size,size)
        elseif obj==4 then
            local size = 50
            x = screenw/2-(wspacing*3)/2+(wspacing*(bx-1))+(wspacing/2-size/2)+5
            y = 50+(hspacing*(by-1))+(hspacing/2-size/2)+5
            love.graphics.setColor(bluecolors[2])
            love.graphics.rectangle('fill',x,y,size,size)
        elseif obj==5 then
            local size = 75
            x = screenw/2-(wspacing*3)/2+(wspacing*(bx-1))+(wspacing/2-size/2)+5
            y = 50+(hspacing*(by-1))+(hspacing/2-size/2)+5
            love.graphics.setColor(redcolors[3])
            love.graphics.rectangle('fill',x,y,size,size)
        elseif obj==6 then
            local size = 75
            x = screenw/2-(wspacing*3)/2+(wspacing*(bx-1))+(wspacing/2-size/2)+5
            y = 50+(hspacing*(by-1))+(hspacing/2-size/2)+5
            love.graphics.setColor(bluecolors[3])
            love.graphics.rectangle('fill',x,y,size,size)
        end
    end
    x=25
    y=screenh-screenh/4+25
    for i=1,3 do --draw squares
        local size = 25*i
        local spacing = 25*i+10
        if team==1 then
            love.graphics.setColor(redcolors[i])
        elseif team==2 then
            love.graphics.setColor(bluecolors[i])
        end
        love.graphics.rectangle('fill',x+(spacing/2-size/2),y+(75/2-size/2),size,size)
        love.graphics.setColor(1,1,1)
        if selectedSquare==i then
            love.graphics.rectangle('line',x+(spacing/2-size/2),y+(75/2-size/2),size,size,5)
        end
        love.graphics.printf(squaresAvailable[i],font,x,y+75,spacing,"center")
        x=x+spacing
    end
    love.graphics.setColor(1,1,1)
    if myTurn then
        love.graphics.printf("É seu turno!",font,0,y+15,screenw-screenw/15,"right")
    else
        love.graphics.printf("Aguarde!",font,0,y+15,screenw-screenw/15,"right")
    end
end

function drawEndMenu()
    y = 50
    love.graphics.printf("GigaVelha",font,0,y,screenw,"center")
    y=y+font:getHeight()*2.5
    love.graphics.printf(gameMessage,font,15,y,screenw-30,"center")
    local tw,th = font:getWrap(gameMessage,screenw-30)
    y=y+font:getHeight()*#th+30
    if menu=="end" then
        btnWrap("Revanche",y,function ()
            publish("rematch","")
            menu="rematchask"
        end)
    elseif menu=="rematch" then
        local tw,th = font:getWrap("O oponente propos uma revanche",screenw-30)
        love.graphics.printf("O oponente propos uma revanche",font,15,y,screenw-30,"center")
        y=y+font:getHeight()*#th+30
        btnWrap("Aceitar!",y,function ()
            publish("rematchaccept","")
            resetVars()
            menu="game"
        end)
    elseif menu=="rematchask" then
        love.graphics.printf("Revanche pedida",font,15,y,screenw-30,"center")
    end
    y=screenh-font:getHeight()-45
    btnWrap("Voltar",y,function ()
        menu="start"
        hub:unsubscribe()
    end)
end

function drawConfig()
    
end

--draws a button centralized in the desired y pos
--text, y pos, function
function btnWrap(text,y,fun)
    local tw,th = font:getWrap(text,screenw-30)
    button(text,screenw/2-tw/2-15,y,tw+30,fun)
end


--draw a button
--text, x pos, y pos, width, function
function button(text,x,y,w,fun)
    local tw,th = font:getWrap(text,w-30)
    local height = font:getHeight()*#th+30

    local color = {0.45,0.45,0.45}

    if love.mouse.isDown(1) then
        local mx,my = love.mouse.getPosition()
        if mx >= x and mx <= x+w and my >= y and my <= y+height then
            unableFn=fun
            color={0.55,0.55,0.55}
            unable=true
        end
    end

    love.graphics.setColor(0.1,0.1,0.1)
    love.graphics.rectangle('fill',x+10,y+10-15,w,height)
    
    love.graphics.setColor(color)
    love.graphics.rectangle('fill',x,y-15,w,height)
    
    love.graphics.setColor(1,1,1)
    love.graphics.printf(text,font,x+15,y,w-30,"center")
end

function textboxWrapper(label,text,y)
    local w = screenw-15-15
    love.graphics.setColor(1,1,1)
    love.graphics.printf(label,font,15,y,w,"left")
    local tw = font:getWidth(label)+15
    textbox(text,15+tw,y,w-tw)
end

function textbox(text,x,y,w)
    local height = font:getHeight()+30

    love.graphics.setColor(0.1,0.1,0.1)
    love.graphics.rectangle('fill',x+5,y+5-15,w,height)
    
    love.graphics.setColor(0.45,0.45,0.45)
    love.graphics.rectangle('fill',x,y-15,w,height)

    love.graphics.setColor(0.8,0.8,0.8)
    love.graphics.rectangle('fill',x+5,y+height-5-15-5,w-10,5)

    love.graphics.setColor(1,1,1)
    love.graphics.printf(text,font,x+15,y,w-30,"left")

    if love.keyboard.hasTextInput() and text~="" and cursorBlinkNow then
        local tw = font:getWidth(text)
        love.graphics.rectangle('fill',x+15+tw,y,5,font:getHeight())
    end

    if love.mouse.isDown(1) then
        local mx,my = love.mouse.getPosition()
        if mx >= x and mx <= x+w and my >= y and my <= y+height then
            love.keyboard.setTextInput(true)
        end
    end
end

function drawBoard(ny)
    x = screenw/2-(wspacing*3)/2+wspacing
    y = ny
    for i=1,2 do
        love.graphics.setColor(1,1,1)
        love.graphics.rectangle('fill',x,y,10,hspacing*3)
        x=x+wspacing
    end
    x = screenw/2-(wspacing*3)/2
    y = ny+hspacing
    for i=1,2 do
        love.graphics.setColor(1,1,1)
        love.graphics.rectangle('fill',x,y,wspacing*3,10)
        y=y+hspacing
    end
    for i=1,9 do --search for any obj
        local obj = dummyBoard[i]
        bx = (i-1)%3+1 --block x
        by = math.floor((i-1)/3)+1 --block y
        if obj==1 then
            local size = 25
            x = screenw/2-(wspacing*3)/2+(wspacing*(bx-1))+(wspacing/2-size/2)+5
            y = ny+(hspacing*(by-1))+(hspacing/2-size/2)+5
            love.graphics.setColor(redcolors[1])
            love.graphics.rectangle('fill',x,y,size,size)
        elseif obj==2 then
            local size = 25
            x = screenw/2-(wspacing*3)/2+(wspacing*(bx-1))+(wspacing/2-size/2)+5
            y = ny+(hspacing*(by-1))+(hspacing/2-size/2)+5
            love.graphics.setColor(bluecolors[1])
            love.graphics.rectangle('fill',x,y,size,size)
        elseif obj==3 then
            local size = 50
            x = screenw/2-(wspacing*3)/2+(wspacing*(bx-1))+(wspacing/2-size/2)+5
            y = ny+(hspacing*(by-1))+(hspacing/2-size/2)+5
            love.graphics.setColor(redcolors[2])
            love.graphics.rectangle('fill',x,y,size,size)
        elseif obj==4 then
            local size = 50
            x = screenw/2-(wspacing*3)/2+(wspacing*(bx-1))+(wspacing/2-size/2)+5
            y = ny+(hspacing*(by-1))+(hspacing/2-size/2)+5
            love.graphics.setColor(bluecolors[2])
            love.graphics.rectangle('fill',x,y,size,size)
        elseif obj==5 then
            local size = 75
            x = screenw/2-(wspacing*3)/2+(wspacing*(bx-1))+(wspacing/2-size/2)+5
            y = ny+(hspacing*(by-1))+(hspacing/2-size/2)+5
            love.graphics.setColor(redcolors[3])
            love.graphics.rectangle('fill',x,y,size,size)
        elseif obj==6 then
            local size = 75
            x = screenw/2-(wspacing*3)/2+(wspacing*(bx-1))+(wspacing/2-size/2)+5
            y = ny+(hspacing*(by-1))+(hspacing/2-size/2)+5
            love.graphics.setColor(bluecolors[3])
            love.graphics.rectangle('fill',x,y,size,size)
        end
    end
end

function newDummyBoard()
    if #dummyBoard==0 then
        for i=1,9 do
            dummyBoard[i] = math.random(0,6)
        end
    end
end

function resetDummyBoard()
    for i=1,9 do
        dummyBoard[i] = math.random(0,6)
    end
end

function drawWarning()
    love.graphics.setColor(0,0,0,0.5)
    love.graphics.rectangle('fill',0,0,screenw,screenh)

    local w = math.min(screenw-30,font:getWidth(warningMsg)+30)
    local _, wrap = font:getWrap(warningMsg,w)
    local h = font:getHeight()+(font:getHeight()*#wrap)+15+15+font:getHeight()+30+30
    local x = screenw/2-w/2
    local y = screenh/2-h/2

    --draw middle
    love.graphics.setColor(0.1,0.1,0.1,0.5)
    love.graphics.rectangle("fill",x+10,y+10,w,h)
    love.graphics.setColor(0.2,0.2,0.2)
    love.graphics.rectangle('fill',x,y,w,h)

    --draw message
    love.graphics.setColor(1,1,1)
    love.graphics.printf("Aviso:",font,x,y+5,w,"center")
    y=y+5+font:getHeight()+15

    love.graphics.printf(warningMsg,font,x+15,y,w-30,"center")
    y=y+15+(font:getHeight()*#wrap)+15

    btnWrap("Fechar",y,function ()
        warning=false
    end)
    
end