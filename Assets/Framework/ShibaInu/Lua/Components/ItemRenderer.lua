--
-- 列表子项基类
-- 2017/12/19
-- Author LOLO
--

---@class ItemRenderer : View
---@field New fun():ItemRenderer
---
---@field deselect boolean @ 在已选中时，是否可以取消选中
---@field itemWidth number @ 布局宽度
---@field itemHeight number @ 布局高度
---
---@field protected _list BaseList
---@field protected _index number
---@field protected _data any
---@field protected _selected boolean
---@field protected _enabled boolean
---
local ItemRenderer = class("ItemRenderer", View)


--
function ItemRenderer:Ctor()
    ItemRenderer.super.Ctor(self)

    self.deselect = false
    self._selected = false
    self._enabled = true
end


--
--- 更新内容
---@param data any
---@param index number
function ItemRenderer:Update(data, index)
    self._data = data
    self._index = index
end


--
--- 是否被选中
function ItemRenderer:SetSelected(value)
    self._selected = value
end

function ItemRenderer:GetSelected()
    return self._selected
end


--
--- 是否启用
---@param value boolean
function ItemRenderer:SetEnabled(value)
    self._enabled = value
end

function ItemRenderer:GetEnabled()
    return self._enabled
end


--
--- 对应的数据
---@return any
function ItemRenderer:GetData()
    return self._data
end

--
--- 在列表中的索引
---@return number
function ItemRenderer:GetIndex()
    return self._index
end

--
--- 对应的列表
---@return BaseList
function ItemRenderer:GetList()
    return self._list
end



--=------------------------------[ event ]------------------------------=--

--- 初始化时。由 BaseList 调用
function ItemRenderer:OnInitialize()
    ItemRenderer.super.OnInitialize(self)

    local sizeDelta = GetComponent.RectTransform(self.gameObject).sizeDelta
    self.itemWidth = sizeDelta.x
    self.itemHeight = sizeDelta.y
end


--
--- 被回收到缓存池时。由 BaseList 调用
function ItemRenderer:OnRecycle()
end


--
--- 被销毁时。由 BaseList 调用
function ItemRenderer:OnDestroy()
    ItemRenderer.super.OnDestroy(self)
end



--
return ItemRenderer