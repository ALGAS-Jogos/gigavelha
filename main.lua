require('utils.json')
require('utils.noobhub')
require('utils.vars')
require('utils.draw')
require('utils.utils')
require('utils.network')

function love.load()
    love.graphics.setBackgroundColor(0.2,0.2,0.2)
    love.graphics.setLineWidth(5)
end

function love.update(dt)
    hub:enterFrame()
    cursorBlink=cursorBlink-dt
    if cursorBlink<=0 then
        cursorBlink=cursorBlinkMax
        cursorBlinkNow=not cursorBlinkNow
    end
    dummyBoardReset=dummyBoardReset-dt
    if dummyBoardReset<=0 then
        resetDummyBoard()
        dummyBoardReset=dummyBoardResetMax
    end
end

function love.draw()
    if menu=="game" then
        drawGame()
    elseif menu=="start" or menu=="waitingmyown" or menu=="waitingqueue" or menu=="typenumber" then
        drawStartMenu()
    else
        drawEndMenu()
    end

    if warning then drawWarning() end
end

function love.mousepressed(mx,my)
    if menu=="end" then
        resetVars()
        return false
    end

    if myTurn==false or menu~="game" then return false end

    --bounds
    --x+w >= cx and x <= cx + cw and y+h >= cy and y <= cy + ch
    x = screenw/2-(wspacing*3)/2
    y = 50
    if mx >= x and mx <= x+wspacing*3 and my >= y and my <= y+hspacing*3 then
        if squaresAvailable[selectedSquare]<=0 then return false end
        boxNumber = tableBounds(mx,my)
        local squarePut = team+(2*selectedSquare-2)
        if squarePut>=board[boxNumber]+team then
            board[boxNumber] = squarePut
            publish("play",json.encode({play=boxNumber,square=squarePut}))
            myTurn=false
            squaresAvailable[selectedSquare]=squaresAvailable[selectedSquare]-1 --take one
        end
    else
        x=25
        y=screenh-screenh/4+25
        for i=1,3 do
            local size = 25*i
            local spacing = 25*i+10
            local bx,by = x+(spacing/2-size/2), y+(75/2-size/2)
            if mx >= bx and mx <= bx+size and my >= by and my <= by+size then
                selectedSquare=i
            end
            x=x+spacing
        end
    end
end

function love.textinput(t)
    if menu=="typenumber" then
        if tonumber(t) then
            inputchannel=inputchannel..t
            inputchannel=string.sub(inputchannel,1,5)
        end
    end
end

function love.keypressed(key)
    if menu~="game" then
        if key=="backspace" and menu=="typenumber" then
            inputchannel=string.sub(inputchannel,1,#inputchannel-1)
        end
        if key=="return" and menu=="typenumber" then
            enterGame(inputchannel)
            menu="game"
            myTurn=false
            team=2
        end
    end
end

function love.mousereleased()
    unable=false
    unableFn()
    unableFn=function()end
end

function tableBounds(mx,my)
    for i=1,9 do --figure which box
        bx = (i-1)%3+1 --block x
        by = math.floor((i-1)/3)+1 --block y
        x = screenw/2-(wspacing*3)/2+(wspacing*(bx-1))
        y = 50+(hspacing*(by-1))
        if mx >= x and mx <= x+wspacing and my >= y and my <= y+hspacing then
            return i
        end
    end
end
