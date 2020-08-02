# Docs:
https://devforum.roblox.com/t/gridcreator-draw-grids-with-whatever-tradeoff-you-prefer/698328/1

-----

Inspired by [GridModule](https://devforum.roblox.com/t/gridmodule-a-module-for-creating-triangle-grids/697635/5) by brokenVectors, I decided to make a module that allows you to draw with WedgeParts, Beams, or SpecialMeshes.

Shoutout to EgoMoose and TheGrandBraker for help with various draw math.  

https://www.roblox.com/library/5465157438/G

My module is designed to give you control over what tradeoff you want, and handle as much as possible for you to make this super simple to use.

Utilizing proxies, it knows when you update a point and will automatically update any tris/quads that are connected to that point. This way, you don't have to concern yourself with drawing tris/quads and it also only alters the ones that need the change instead of all of them.

By using proxies, I also prevent you from changing things you shouldn't so that you hopefully won't break the points. Instead, I give you a descriptive error message.

-----

## Module usage is really straightforward.

```Lua
function GridCreator.new(Settings)
```
`Settings` is a table with Position, Size, Resolution, and DrawType
- `Position (Vector3)`
Where the center of the grid will be
- `Size (Vector3)`
How big the grid will be (Y value is meaningless here)
- `Resolution (number)`
How many points per side of the grid
- `DrawType (string)`
Which method for rendering the grid should be used

**returns** Grid

------

**Grid Properties**

```Lua
-- Read Only properties

Grid.Size -- The Vector3 you passed into GridCreator.new settings
Grid.Position -- The Vector3 you passed into GridCreator.new settings
Grid.Resolution -- The number you passed into GridCreator.new settings

-- Alterable properties

Grid.Points -- 2D array of Points | eg: Grid.Points[x][y].Y = HeightValue

-- Each Point in the 2D array is a table like so
local Point = {
	X = number;
	Y = number;
	Z = number;
	Color = Color3;
}
```

----

## Example:
```Lua
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
```

------

## DrawTypes:

`"WedgePart"`

- Has collisions on the grid. Makes it the by far most expensive option but if you need collisions then this is your only option.

`"SpecialMesh"`

- Has no collisions, so it's a significantly faster version of WedgePart.

`"Beam"`

- Has no collisions, no lighting, and draws quads instead of tris so updates far fewer Instances.
- Gets throttled by Roblox if you make the grid too large and will look funky.

------

https://www.roblox.com/library/5465157438/G

Hopefully this module makes it easy for you to do triangle terrain, audio visualizers, fluid sim, whatever.

*Note that it's a bit more expensive than handling it all yourself, you're paying for the convenience and simplicity of my proxy backend.*

-----

### Enjoying my work? I love to create and share with the community, for free.
I make loads of free and open source scripts and modules for you all to use in your projects!
You can find a lot of them listed for you in my [portfolio](https://devforum.roblox.com/t/boatbomber-programmers-portfolio/426661/1). Enjoy!

If you'd like to help fund my work, check out my [Patreon](https://www.patreon.com/boatbomberrblx) or [PayPal](http://paypal.me/boatbomberrblx)!
