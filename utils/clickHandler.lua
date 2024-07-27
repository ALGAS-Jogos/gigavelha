function mousePressed(mx,my)
    if menu=="end" then
        resetVars()
        return false
    end

    if menu~="game" then return false end

    --bounds
    --x+w >= cx and x <= cx + cw and y+h >= cy and y <= cy + ch
    x = screenw/2-(wspacing*3)/2
    y = 50
    if mx >= x and mx <= x+wspacing*3 and my >= y and my <= y+hspacing*3 and myTurn then
        if squaresAvailable[selectedSquare]<=0 then return false end
        boxNumber = tableBounds(mx,my)
        local squarePut = team+(2*selectedSquare-2)
        if squarePut>=board[boxNumber]+team and isStrictBigger(board[boxNumber],squarePut) and not isSameTeam(board[boxNumber],squarePut) then
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