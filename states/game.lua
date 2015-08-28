game = {}

function game:enter()
    self.world = love.physics.newWorld(0, 50, false)
	
	local beginContact = function(fixtureA, fixtureB, contact)
		if fixtureA:getUserData() == 'Active' then -- the fixture is the active object
			self:removeActiveFaller()
		elseif fixtureB:getUserData() == 'Active' then -- the fixture is the active object
			self:removeActiveFaller()
		end
	end
	
	self.world:setCallbacks(beginContact)
	
	self.staticObjects = {}
	local x, y, width, height, angle = love.graphics.getWidth()/2, love.graphics.getHeight()-100, 300, 60, 0
	table.insert(self.staticObjects, Platform:new(x, y, width, height, angle))
	
	self.activeObjects = {}
	
	self.activeFaller = true
	
	self.spawnCooldown = 4
	self.spawnTimer = 0
	
	self.spawnType = 1
	self:addFaller()
end

function game:update(dt)
	self.spawnTimer = self.spawnTimer + dt

	if not self.activeFaller and self.spawnTimer >= self.spawnCooldown then
		self:addFaller()
		self.activeFaller = true
		self.spawnTimer = 0
	end

	for k, faller in pairs(self.activeObjects) do
		if faller.active then
			faller:update(dt)
		end
		
		self:checkOut(faller)
	end
	
	for k, faller in pairs(self.activeObjects) do
		if faller.destroy then
			self:removeObject(faller)
		end
	end

	self.world:update(dt)
end

function game:keypressed(key, isrepeat)
    if console.keypressed(key) then
        return
    end
end

function game:mousepressed(x, y, mbutton)
    if console.mousepressed(x, y, mbutton) then
        return
    end
end

function game:draw()
    for k, platform in pairs(self.staticObjects) do
		platform:draw()
	end
	
	for k, faller in pairs(self.activeObjects) do
		faller:draw()
	end
	
	love.graphics.print(love.timer.getFPS()..' FPS', 5, 5)
	love.graphics.print(#self.activeObjects+#self.staticObjects..' objects', 5, 45)
end


function game:addFaller()
	local x, y = love.graphics.getWidth()/2, 100
	if self.spawnType == 1 then -- rectangle
		local width, height = 200, 30
		table.insert(self.activeObjects, FallerRectangle:new(x, y, width, height, 0, true))
		self.spawnType = 2
	elseif self.spawnType == 2 then -- circle
		local radius = 30
		table.insert(self.activeObjects, FallerCircle:new(x, y, radius, true))
		self.spawnType = 1
	elseif self.spawnType == 3 then -- rhombus
		local w, h, w2 = 150, 40, 100
		--table.insert(self.activeObjects, FallerRhombus:new(x, y, w, h, w2, true))
		self.spawnType = 1
	end
end

function game:removeActiveFaller()
	for k, faller in pairs(self.activeObjects) do
		if faller.active then
			faller.fixture:setUserData(nil)
			faller.active = false
		end
	end
	
	self.activeFaller = false
end

function game:checkOut(faller)
	local offscreen = faller:onScreen()
	if offscreen then
		faller.destroy = true
	end
end

function game:removeObject(faller)
	if faller.active then self.activeFaller = false end
	for i, v in ipairs(self.activeObjects) do
        if v == faller then
            table.remove(self.activeObjects, i)
            break
        end
    end
end