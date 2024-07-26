math.randomseed(os.time(),os.time()-150)

hub = noobhub.new({server="187.73.30.41", port="15565"})
channel = math.random(10000,99999)
myTurn = true
inputchannel = ""
gameMessage = ""
menu = "start"

board = {}

redcolors = {}
redcolors[#redcolors+1] = {1, 0.851, 0}
redcolors[#redcolors+1] = {1, 0.459, 0}
redcolors[#redcolors+1] = {1, 0, 0.271}

bluecolors = {}
bluecolors[#bluecolors+1] = {0.29, 1, 0.659}
bluecolors[#bluecolors+1] = {0, 0.949, 1}
bluecolors[#bluecolors+1] = {0.29, 0.42, 1}

font = 32

team = 1 --1 for red 2 for blue
squaresAvailable = {}
squaresAvailable[#squaresAvailable+1] = 3
squaresAvailable[#squaresAvailable+1] = 3
squaresAvailable[#squaresAvailable+1] = 3
selectedSquare = 1

cursorBlink = 0.5
cursorBlinkMax = 0.5
cursorBlinkNow = false
unable = false
unableFn = function()end
dummyBoard = {}
dummyBoardReset = 5
dummyBoardResetMax = 5
warning,warningMsg = false,""

local centerspacing = 100

function mobileStraight()  
    local wait=true
    while wait do
        love.window.maximize()
        love.window.setMode(600,650)
        local tx, ty = love.graphics.getDimensions()
        if ty>tx then wait=false end
    end
    local standard = 650
    screenw, screenh = love.graphics.getDimensions()
    font = 40*(screenw/standard)
    font = love.graphics.newFont("Inter.ttf",font)
end

function loadTable()
    for i=1,9 do
        board[i] = 0
    end
end

function resetVars()
    channel=math.random(10000,99999)
    inputchannel=""
    loadTable()
    myTurn=true
    selectedSquare=1
    for i=1,3 do
        squaresAvailable[i]=3
    end
    team=1
end


mobileStraight() --this game is meant to be an app only
wspacing = (screenw-centerspacing)/3
hspacing = (screenh-centerspacing*3)/3
wspacing = math.min(wspacing,hspacing)
hspacing = math.min(wspacing,hspacing)
loadTable()