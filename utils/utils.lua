function checkVictory()
    local winningCombinations = {
        {1, 2, 3}, {4, 5, 6}, {7, 8, 9}, -- Rows
        {1, 4, 7}, {2, 5, 8}, {3, 6, 9}, -- Columns
        {1, 5, 9}, {3, 5, 7}             -- Diagonals
    }

    for t=1,2 do
        for i, combination in ipairs(winningCombinations) do
            local a, b, c = combination[1], combination[2], combination[3]
            if t==1 then
                if isOdd(board[a]) and isOdd(board[b]) and isOdd(board[c]) and board[a]>0 and board[b]>0 and board[c]>0 then
                   return t
                end
            else
                if not isOdd(board[a]) and not isOdd(board[b]) and not isOdd(board[c]) and board[a]>0 and board[b]>0 and board[c]>0 then
                    return t
                 end
            end
        end
    end

    for i = 1, 9 do
        if board[i]<=2 then
            return nil -- Game is still ongoing
        end
    end

    return "draw"
end

function isOdd(n)
    if n%2==0 then return false end
    return true
end

function isStrictBigger(n,m)
    if isOdd(n) then --red team
        return m-2<=n+1
    else --blue team
        return m-2<=n
    end
end

function isSameTeam(n,m)
    return isOdd(n) and isOdd(m)
end