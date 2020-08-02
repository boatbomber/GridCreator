local GridCreator = require(script.GridCreator)

local Grid = GridCreator.new({
	Position = Vector3.new(0,0,0);
	Size = Vector3.new(200,5,200);
	Resolution = 60;
	DrawType = "WedgePart";
})


for x = 1, Grid.Resolution do
	for y = 1, Grid.Resolution do
		local Height = (math.noise(x/9,y/9)+1)*20
		Grid.Points[x][y].Y = Height
		Grid.Points[x][y].Color = Color3.fromRGB(17, 50, 0):Lerp(Color3.fromRGB(65, 90, 52), Height/10)
	end
end
