---@class UnityEngine.Sprite : UnityEngine.Object
---@field bounds UnityEngine.Bounds
---@field rect UnityEngine.Rect
---@field texture UnityEngine.Texture2D
---@field associatedAlphaSplitTexture UnityEngine.Texture2D
---@field textureRect UnityEngine.Rect
---@field textureRectOffset UnityEngine.Vector2
---@field packed bool
---@field packingMode UnityEngine.SpritePackingMode
---@field packingRotation UnityEngine.SpritePackingRotation
---@field pivot UnityEngine.Vector2
---@field border UnityEngine.Vector4
---@field vertices table
---@field triangles table
---@field uv table
---@field pixelsPerUnit float
local m = {}
---@overload fun(texture:UnityEngine.Texture2D, rect:UnityEngine.Rect, pivot:UnityEngine.Vector2, pixelsPerUnit:float, extrude:uint, meshType:UnityEngine.SpriteMeshType, border:UnityEngine.Vector4):UnityEngine.Sprite
---@overload fun(texture:UnityEngine.Texture2D, rect:UnityEngine.Rect, pivot:UnityEngine.Vector2, pixelsPerUnit:float, extrude:uint, meshType:UnityEngine.SpriteMeshType):UnityEngine.Sprite
---@overload fun(texture:UnityEngine.Texture2D, rect:UnityEngine.Rect, pivot:UnityEngine.Vector2, pixelsPerUnit:float, extrude:uint):UnityEngine.Sprite
---@overload fun(texture:UnityEngine.Texture2D, rect:UnityEngine.Rect, pivot:UnityEngine.Vector2, pixelsPerUnit:float):UnityEngine.Sprite
---@overload fun(texture:UnityEngine.Texture2D, rect:UnityEngine.Rect, pivot:UnityEngine.Vector2):UnityEngine.Sprite
---@param texture UnityEngine.Texture2D
---@param rect UnityEngine.Rect
---@param pivot UnityEngine.Vector2
---@param pixelsPerUnit float
---@param extrude uint
---@param meshType UnityEngine.SpriteMeshType
---@param border UnityEngine.Vector4
---@param generateFallbackPhysicsShape bool
---@return UnityEngine.Sprite
function m.Create(texture, rect, pivot, pixelsPerUnit, extrude, meshType, border, generateFallbackPhysicsShape) end
---@param vertices table
---@param triangles table
function m:OverrideGeometry(vertices, triangles) end
---@return int
function m:GetPhysicsShapeCount() end
---@param shapeIdx int
---@return int
function m:GetPhysicsShapePointCount(shapeIdx) end
---@param shapeIdx int
---@param physicsShape table
---@return int
function m:GetPhysicsShape(shapeIdx, physicsShape) end
---@param physicsShapes System.Collections.Generic.IList
function m:OverridePhysicsShape(physicsShapes) end
UnityEngine = {}
UnityEngine.Sprite = m
return m