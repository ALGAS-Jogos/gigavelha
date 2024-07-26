function enterGame(channel)
    hub:subscribe({
        channel = channel,
        callback = function(message)
            print("RECEIVED: "..message.action)
            if message.action=="join" then
                menu="game"
            elseif message.action=="play" then
                local play = json.decode(message.content)
                board[play.play]=play.square
                myTurn=true
                winner = checkVictory()
                if winner=="draw" then
                    publish("draw","")
                    menu="end"
                    gameMessage="Empate!"
                elseif winner==1 or winner==2 then
                    publish("win",winner)
                    menu="end"
                    if winner==team then
                        gameMessage="Você venceu!"
                    else
                        gameMessage="Você perdeu! :("
                    end
                end
            elseif message.action=="draw" then
                menu="end"
                gameMessage="Empate!"
            elseif message.action=="win" then
                menu="end"
                if message.content==team then
                    gameMessage="Você venceu!"
                else
                    gameMessage="Você perdeu! :("
                end
            elseif message.action=="rematch" then
                menu="rematch"
            elseif message.action=="rematchaccept" then
                menu="game"
                resetVars()
                myTurn=false
                team=2
            end
        end
    })
    publish("join","")
end

function enterQueue(channel)
    hub:subscribe({
        channel = channel,
        callback = function(message)
            if message.action=="join" then
                publish("game",channel)
            end
            if message.action=="game" then
                publish("accept",message.content)
                enterGame(message.content)
                menu="game"
                myTurn=false
                team=2
            end
            if message.action=="accept" then
                if message.content==channel then
                    enterGame(channel)
                    menu="game"
                    myTurn=true
                    team=1
                end
            end
        end
    })
    publish("join","")
end

function publish(action,content)    
    hub:publish({
        message = {
            action = action,
            content = content,
            id = localId,
            name = localName,
            timestamp = os.time()
        }
    })
    print(action)
end
