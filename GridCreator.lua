local ipairs = ipairs
script.TerrainTexture.Parent = game.ReplicatedStorage

local DrawTypes = {
	
	Beam = require(script.BeamQuad);
	WedgePart = require(script.WedgePart);
	SpecialMesh = require(script.SpecialMesh);
	
	--BeamTri = require(script.BeamTri); -- Decided not to support this since it's literally just a worse version of BeamQuad
}

local GridCreator = {}

function GridCreator.new(Settings)
	
	-- Assertions
	if type(Settings) ~= "table" then
		error("Invalid grid Settings: ".. tostring(Settings),2)
	end
	if typeof(Settings.Size) ~= "Vector3" then
		error("Invalid grid Size: ".. tostring(Settings.Size),2)
	end
	if typeof(Settings.Position) ~= "Vector3" then
		error("Invalid grid Position: ".. tostring(Settings.Position),2)
	end
	if not DrawTypes[Settings.DrawType] then
		error("Invalid DrawType: ".. tostring(Settings.DrawType).. ". Must be either 'Beam', 'SpecialMesh', or 'WedgePart'",2)
	end

	-- Localize settings to avoid table indexing
	local Resolution = math.clamp(Settings.Resolution or 20, 10,150)
	local Pos,Size = Settings.Position,Settings.Size
	local Pos_X = Pos.X
	local Pos_Y = Pos.Y
	local Pos_Z = Pos.Z
	local Size_X = Size.X
	local Size_Y = Size.Y
	local Size_Z = Size.Z
	local SetCF = CFrame.new(Pos)
	local HalfSize = Size *0.5

	local DrawLib = DrawTypes[Settings.DrawType]

	local Grid = {}
	
	-- Expose settings
	Grid.Resolution = Resolution
	Grid.Size = Size
	Grid.Position = Pos
	
	-- Prepare draw index
	Grid.Draws = table.create(Resolution)
	
	-- Generate Points
	Grid.Points = table.create(Resolution)
	
	for x=1, Resolution do
		
		Grid.Draws[x] = table.create(Resolution)
		
		local Row = table.create(Resolution)
		
		for z=1, Resolution do
			
			local Point = {
				-- Position
				X = ((x-1) / (Resolution-1) * Size_X) + (Pos_X - (Size_X/2));
				Y = Pos_Y;
				Z = ((z-1) / (Resolution-1) * Size_Z) + (Pos_Z - (Size_Z/2));
				-- Color
				Color = Color3.fromRGB(math.random(40,50),math.random(90,100),math.random(125,140))
			}
			
			-- use a proxy so we can protect invalid point changes and update quads when points change
			local PointProxy = newproxy(true); local Meta = getmetatable(PointProxy)
	
			Meta.__index = function(_, key)
				--print(tostring(Point).." - access to element ".. tostring(key))
				return Point[key]
			end
			Meta.__newindex = function(_, key, value)
				--print(tostring(Point).." - update to element ".. tostring(key) .. ' to ' .. tostring(value))
				if key == "X" or key == "Y" or key == "Z" then
					if type(value) == "number" then
						Point[key] = value
						for _, Quad in ipairs(Grid.Draws[x][z]) do
							Quad.Update()
						end
					else
						error("Point."..key.." can only be set to a number value", 2)
					end
					
				elseif key == "Color" then
					if typeof(value) == "Color3" then
						Point.Color = value
						for _, Quad in ipairs(Grid.Draws[x][z]) do
							Quad.Update()
						end
					else
						error("Point.Color can only be set to a Color3 value", 2)
					end					
					
				else
					error("You can only update Point.X/Y/Z or Point.Color, not Point.".. tostring(key), 2)
				end
			end
			Meta.__len = function()
				--print(tostring(Point).." - access to table length")
				return 4
			end
			
			Row[z] = PointProxy
			
			Grid.Draws[x][z] = {}
		end
		
		Grid.Points[x] = Row
	end
	
	-- Generate the Draws for all points
	if Settings.DrawType == "Beam" then
		-- Quads use 4 points instead of 3 so they need a different call, hence the special if statement
		
		for x=1,Resolution-1 do
			for z=1, Resolution-1 do
				local Quad = DrawLib.new(Grid.Points[x][z],Grid.Points[x][z+1],Grid.Points[x+1][z+1],Grid.Points[x+1][z], x,z)
				
				-- Index which points should update this quad when changed
				table.insert(Grid.Draws[x][z],Quad)
				table.insert(Grid.Draws[x][z+1],Quad)
				table.insert(Grid.Draws[x+1][z+1],Quad)
				table.insert(Grid.Draws[x+1][z],Quad)
			end
		end
		
	else
		
		for x=1,Resolution-1 do
			for z=1, Resolution-1 do
				local TriA = DrawLib.new(Grid.Points[x][z],Grid.Points[x][z+1],Grid.Points[x+1][z+1], x,z)
				local TriB = DrawLib.new(Grid.Points[x][z],Grid.Points[x+1][z],Grid.Points[x+1][z+1], x,z)
				
				-- Index which points should update these tris when changed
				table.insert(Grid.Draws[x][z],TriA)
				table.insert(Grid.Draws[x][z+1],TriA)
				table.insert(Grid.Draws[x+1][z+1],TriA)
				
				table.insert(Grid.Draws[x][z],TriB)
				table.insert(Grid.Draws[x+1][z],TriB)
				table.insert(Grid.Draws[x+1][z+1],TriB)
			end
		end
		
	end
	
	-- Use a proxy so we can make Grid read-only
	local GridProxy = newproxy(true); local GridMeta = getmetatable(GridProxy)

	GridMeta.__index = function(_, key)
		if key == "Draws" then return nil end -- seriously don't let users touch that
		return Grid[key]
	end
	GridMeta.__newindex = function(_, key, value)
		error("Grid.".. tostring(key).. " is read-only, do not attempt to set it",2)
	end
	GridMeta.__len = function()
		return 5
	end
	
	return GridProxy
	
end

return GridCreator

