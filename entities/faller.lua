Faller = class('Faller')

function Faller:initialize(x, y, active)
	self.body = love.physics.newBody(game.world, x, y, 'dynamic')
	self.fixture = love.physics.newFixture(self.body, self.shape, 1)
	self.active = active
	self.fixture:setRestitution(.1)
	
	if active then
		self.fixture:setUserData('Active')
	end
	
	self.turnSpeed = 4
	self.moveSpeed = 200
	self.fastFallSpeed = 400
	
	self.destroy = false
end

function Faller:update()
	local angle = self.body:getAngle()
	if love.keyboard.isDown('q') then
		local newAngle = angle + math.rad(self.turnSpeed*5)
		self.body:setAngle(newAngle)
		
		--self.body:applyLinearImpulse(self.turnSpeed, 0, 5, 0)
		--self.body:applyLinearImpulse(-self.turnSpeed, 0, -5, 0)
	elseif love.keyboard.isDown('e') then
		local newAngle = angle - math.rad(self.turnSpeed*5)
		self.body:setAngle(newAngle)
		
		--self.body:applyLinearImpulse(self.turnSpeed, 0, 50, 0)
		--self.body:applyLinearImpulse(-self.turnSpeed, 0, -50, 0)
	end
	
	if love.keyboard.isDown('a') then
		self.body:applyForce(-self.moveSpeed, 0)
	elseif love.keyboard.isDown('d') then
		self.body:applyForce(self.moveSpeed, 0)
	end
	
	if love.keyboard.isDown('s') then
		self.body:applyForce(0, self.fastFallSpeed)
	end
end



-- FallerRectangle
FallerRectangle = class('FallerRectangle')

function FallerRectangle:initialize(x, y, width, height, angle, active)
	self.shape = love.physics.newRectangleShape(width, height)
	
	Faller.initialize(self, x, y, active)
	
	self.body:setAngle(math.rad(angle))
	
	self.width = width
	self.height = height
	
	self.update = Faller.update
end

function FallerRectangle:draw()
	love.graphics.setColor(255, 255, 255)
	
	local w, h = self.width/2, self.height/2
	local x1, y1, x2, y2, x3, y3, x4, y4 = self.body:getWorldPoints(-w, -h, w, -h, w, h, -w, h)
	love.graphics.polygon('fill', x1, y1, x2, y2, x3, y3, x4, y4)
	
	if self.active then
		love.graphics.setLineWidth(5)
		love.graphics.setColor(255, 0, 0)
		love.graphics.polygon('line', x1, y1, x2, y2, x3, y3, x4, y4)
	end
end

function FallerRectangle:onScreen()
	local sw, sh = love.graphics.getDimensions()
	local w, h = self.width/2, self.height/2
	local x1, y1, x2, y2, x3, y3, x4, y4 = self.body:getWorldPoints(-w, -h, w, -h, w, h, -w, h)
	
	local points = 0
	if x1 < 0 or x1 > sw or y1 < 0 or y1 > sh then points = points + 1 end
	if x2 < 0 or x2 > sw or y2 < 0 or y2 > sh then points = points + 1 end
	if x3 < 0 or x3 > sw or y3 < 0 or y3 > sh then points = points + 1 end
	if x4 < 0 or x4 > sw or y4 < 0 or y4 > sh then points = points + 1 end
	
	if points == 4 then -- all 4 points offscreen
		return true
	end
end


-- CircleFaller
FallerCircle = class('FallerCircle')

function FallerCircle:initialize(x, y, radius, active)
	self.shape = love.physics.newCircleShape(radius)
	
	Faller.initialize(self, x, y, active)
	
	self.update = Faller.update
end

function FallerCircle:draw()
	love.graphics.setColor(255, 255, 255)
	
	local x, y = self.body:getPosition()
	local r = self.shape:getRadius()
	love.graphics.circle('fill', x, y, r)
	
	if self.active then
		love.graphics.setLineWidth(5)
		love.graphics.setColor(255, 0, 0)
		love.graphics.circle('line', x, y, r)
	end
end

function FallerCircle:onScreen()
	local sw, sh = love.graphics.getDimensions()
	local x, y = self.body:getPosition()
	local r = self.shape:getRadius()
	
	if x+r < 0 or y+r < 0 or x-r > sw or y-r > sh then -- offscreen check
		return true
	end
end