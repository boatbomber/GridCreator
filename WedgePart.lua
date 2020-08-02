local WedgeTri = {}

function WedgeTri.new(PointA,PointB,PointC, x,z)
	
	local Tri = {}
	
	local w1 = Instance.new("WedgePart")
		w1.Anchored = true;
		w1.TopSurface = Enum.SurfaceType.Smooth;
		w1.BottomSurface = Enum.SurfaceType.Smooth;
	local w2 = Instance.new("WedgePart")
		w2.Anchored = true;
		w2.TopSurface = Enum.SurfaceType.Smooth;
		w2.BottomSurface = Enum.SurfaceType.Smooth;		
	
	function Tri.Update()
		
		local a,b,c = Vector3.new(PointA.X,PointA.Y,PointA.Z),Vector3.new(PointB.X,PointB.Y,PointB.Z),Vector3.new(PointC.X,PointC.Y,PointC.Z)		
		
		local ab, ac, bc = b - a, c - a, c - b;
		local abd, acd, bcd = ab:Dot(ab), ac:Dot(ac), bc:Dot(bc);
		
		if (abd > acd and abd > bcd) then
			c, a = a, c;
		elseif (acd > bcd and acd > abd) then
			a, b = b, a;
		end
		
		ab, ac, bc = b - a, c - a, c - b;
		
		local right = ac:Cross(ab).unit;
		local up = bc:Cross(right).unit;
		local back = bc.unit;
		
		local height = math.abs(ab:Dot(up));

		w1.Size = Vector3.new(0.1, height, math.abs(ab:Dot(back)));
		w1.CFrame = CFrame.fromMatrix((a + b)/2, right, up, back);

		w2.Size = Vector3.new(0.1, height, math.abs(ac:Dot(back)));
		w2.CFrame = CFrame.fromMatrix((a + c)/2, -right, up, -back);
		
		w1.Color =Color3.new(
			(PointA.Color.R+PointB.Color.R+PointC.Color.R)/3,
			(PointA.Color.G+PointB.Color.G+PointC.Color.G)/3,
			(PointA.Color.B+PointB.Color.B+PointC.Color.B)/3
		)
		w2.Color = Color3.new(
			(PointA.Color.R+PointB.Color.R+PointC.Color.R)/3,
			(PointA.Color.G+PointB.Color.G+PointC.Color.G)/3,
			(PointA.Color.B+PointB.Color.B+PointC.Color.B)/3
		)
	end
	
	Tri.Update()
	
	w1.Parent = workspace.Terrain
	w2.Parent = workspace.Terrain
	
	return Tri
	
end

return WedgeTri
