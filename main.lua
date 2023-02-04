require("utils.math")
require("variables")

function love.load()
    setInitionalStateValues()
    initTarget()
    initSprites()
    gameFont = graphics.newFont(40)
    mouse.setVisible(false)
end

function love.update(dt)
    if timer > 0 then
        timer = timer - dt
    end

    if timer < 0 then
        timer = 0
        gameState = start
    end
end

function love.draw()
    graphics.draw(sprites.sky, 0, 0)
    setText()

    if gameState == start then
        graphics.printf("Click anywhere to begin!", 0, 250, graphics.getWidth(), "center")
    end

    if gameState == playing then
        graphics.draw(sprites.target, target.x - target.radius, target.y - target.radius)
    end
    graphics.draw(sprites.crosshairs, mouse.getX() - 20, mouse.getY() - 20)
end

function love.mousepressed(x, y, button, istouch, presses)
    local mouseToTarget = distanceBetween(x, y, target.x, target.y)
    if gameState == playing then
        if mouseToTarget < target.radius then 
            if button == leftClick then
                score = score + 1
            elseif button == rightClick then
                score = score + 2
                timer = timer - 1
            end
            getRandomeTargetPosition()
        elseif score > 0 then
            score = score - 1
        end
    elseif button == leftClick and gameState == start then
        gameState = playing
        timer = 10
        score = 0
    end
end

function initTarget()
    target = {}
    target.x = 200
    target.y = 200
    target.radius = 50
end

function setInitionalStateValues()
    score = 0
    timer = 0
    gameState = start
end

function initSprites()
    sprites = {}
    sprites.sky = graphics.newImage('sprites/sky.png')
    sprites.target = graphics.newImage('sprites/target.png')
    sprites.crosshairs = graphics.newImage('sprites/crosshairs.png')
end

function setText()
    graphics.setColor(1, 1, 1)
    graphics.setFont(gameFont)
    graphics.print("Score: " .. score, 5, 5)
    graphics.print("Time: " .. math.ceil(timer), graphics.getWidth() / 2 , 5)
end

function getRandomeTargetPosition() 
    target.x = math.random(target.radius, graphics.getWidth() - target.radius)
    target.y = math.random(target.radius, graphics.getHeight() - target.radius)
end