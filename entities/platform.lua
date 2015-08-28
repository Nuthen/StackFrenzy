Platform = class('Platform')

function Platform:initialize(x, y, width, height, angle)
	self.body = love.physics.newBody(game.world, x, y)
	self.shape = love.physics.newRectangleShape(width, height)
	self.fixture = love.physics.newFixture(self.body, self.shape, 1)
	self.body:setAngle(math.rad(angle))
	self.fixture:setRestitution(.1)
	
	self.width = width
	self.height = height
end

function Platform:draw()
	love.graphics.setColor(255, 255, 255)
	
	local w, h = self.width/2, self.height/2
	local x1, y1, x2, y2, x3, y3, x4, y4 = self.body:getWorldPoints(-w, -h, w, -h, w, h, -w, h)
	love.graphics.polygon('fill', x1, y1, x2, y2, x3, y3, x4, y4)
end