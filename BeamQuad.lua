local TERRAIN = workspace.Terrain
local SPIN = CFrame.Angles(math.pi/2, 0, 0)
local UP = Vector3.new(0,1,0)
local BEAM = Instance.new("Beam")
	BEAM.LightInfluence = 1
	BEAM.Segments = 1
	BEAM.TextureSpeed = 0
	BEAM.Transparency = NumberSequence.new(0)

local ColorTick = tick()

-- Class

local BeamQuad = {}

-- Public Constructors

function BeamQuad.new(PointA,PointB,PointC,PointD, x,z)
	local Quad = {}
	
	local Attach0 = Instance.new("Attachment")
		Attach0.Name = x..":"..z.."/0"
		--Attach0.Visible = true
	local Attach1 = Instance.new("Attachment", TERRAIN)
		--Attach1.Visible = true
		Attach0.Name = x..":"..z.."/1"
	
	local BaseCF = TERRAIN.CFrame
	
	local Beam = BEAM:Clone()
	Beam.Attachment0 = Attach0
	Beam.Attachment1 = Attach1
	
	function Quad.Update()
		
		local a,b,c,d = Vector3.new(PointA.X,PointA.Y,PointA.Z),Vector3.new(PointB.X,PointB.Y,PointB.Z),Vector3.new(PointC.X,PointC.Y,PointC.Z),Vector3.new(PointD.X,PointD.Y,PointD.Z)
		
		local ab = a-b
		local cd = d-c
		
	    local axis0 = UP-ab.Unit:Dot(UP)*ab.Unit
	    local axis1 = UP-cd.Unit:Dot(UP)*cd.Unit
	
	    Attach0.WorldPosition = (a+b)/2
	    Attach1.WorldPosition = (c+d)/2
	
	    Attach0.Axis = axis0
	    Attach1.Axis = axis1
	
	    Attach0.SecondaryAxis = ab
	    Attach1.SecondaryAxis = cd
	
	    Beam.Width0 = ab.Magnitude
	    Beam.Width1 = cd.Magnitude
	
		Beam.Color = ColorSequence.new(Color3.new(
			(PointA.Color.R+PointB.Color.R)/2,
			(PointA.Color.G+PointB.Color.G)/2,
			(PointA.Color.B+PointB.Color.B)/2
		),Color3.new(
			(PointC.Color.R+PointD.Color.R)/2,
			(PointC.Color.G+PointD.Color.G)/2,
			(PointC.Color.B+PointD.Color.B)/2
		))

	end
	
	function Quad.Hide()
		Beam.Parent = nil
		Attach0.Parent = nil
		Attach1.Parent = nil
	end
	
	function Quad.Show()
		Beam.Parent = TERRAIN
		Attach0.Parent = TERRAIN
		Attach1.Parent = TERRAIN
	end
	
	Quad.Update()
	Quad.Show()
	
	
	return Quad
end

return BeamQuad
