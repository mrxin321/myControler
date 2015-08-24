local test = class("test",function()
	return cc.Layer:create()
end)

--[[
	沿给定线条移动
]]
local CENTER = 3
local MOVING = 2     --移动状态
local FREE   = 1     --空闲状态
local DRIGHT  = 1     --移动右方向
local DLEFT   = -1     --移动左方向
local DCENTER = 0     --移动中心 左右木有偏移
local S_1 = 0.7 		
local S_2 = 0.9
local S_3 = 1
local S_4 = 0
function test:ctor()

	self.interval_width = 100
	self.interval_height = -50
	self.itemList = {}
	self.index = -1                   --当前指向
	self.touchBeginPosition = {}
	self.state = FREE  
	self.direction = -1
	--层触摸事件
	local function onTouchBegan(touch, event)
		return self:onTouchBegan(touch, event)
	end 
	local function onTouchMoved(touch, event)
		self:onTouchMoved(touch, event)
	end
	local function onTouchCancel(touch, event)
		self:onTouchCancel(touch, event)
	end
	local function onTouchEnded(touch, event)
		self:onTouchEnded(touch, event)
	end
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler(onTouchCancel,cc.Handler.EVENT_TOUCH_CANCELLED )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)

end
---------废 设置上下左右间距，如显示有f1 f2 f3 f4 f5 f2-f1=第一间距  f3-f2=第二间距 f4-f3=第一间距 f5-f4=第二间距
--所有的item移动只有一个间距宽高 待改
--w1,h1第一间距宽高
function test:setProperty(w1,h1)
	self.interval_width  = w1
	self.interval_height = h1
end
function test:addItem_(item)
	table.insert(self.itemList, item)
end
--初始化item
function test:init_()

	--如果子item不足6个，补足到6个
	if #self.itemList < 6 then
		for i=#self.itemList + 1,6 do
			table.insert(self.itemList, ccui.Button:create())
		end
	end
	self.index = #self.itemList

	--初始化中心
	for i=1,#self.itemList do
		local item = self:getItemByIndex(i)
		item:setTouchEnabled(false)
		local x = (i - 3) * self.interval_width
		local y = (i - 3) * self.interval_height
		item:setPosition(cc.p(x,y))
		item:setScale(self:getScale_(i))
		self:addChild(item)
		if i > 5 then
			item:setScale(0) 
			item:setLocalZOrder(1)
		end
	end
	self:orderReSet()
end

--获取在环中的位置
function test:getIndexInLoop(index)
	index = index % #self.itemList
	if index == 0 then
		index = #self.itemList
	end
	return index
end

function test:indexMove(direction) 
	self.index = (self.index - direction) % #self.itemList
	if self.index == 0  then
		self.index = #self.itemList
	end
end
--子控件移动
function test:itemMove()
	local direction = self.direction
	for i=0,5 do
		local index = self:getIndexInLoop(self.index + i) 
		if i == 0 and direction == DLEFT then
			index = self:getIndexInLoop(self.index + 6) 
		end
		local item = self:getItemByIndex(index)

		--变换位置
		if i == 0 and direction == DLEFT then
			item:setLocalZOrder(0)
			item:setPosition(cc.p(300,-150))
		elseif i == 0 and direction == DRIGHT then 
			item:setLocalZOrder(0)
			item:setPosition(cc.p(-300,150)) 
		end

		local x,y = self.interval_width * direction,self.interval_height * direction
		local scale = self:getScale_(i + direction)
		if #self.itemList > 6 and i == 5   then
			self:move(i,item, scale, x , y,direction,true)
		elseif #self.itemList <= 6 and i == #self.itemList - 1 then
			self:move(i,item, scale, x , y,direction,true)
		else
			self:move(i,item, scale, x , y,direction)
		end
	end
end
--移动函数
--@item 		 要移动的item
--@x,y  		 偏移量
--@isCallBack    是否执行回调函数 
--@scale         缩放值
function test:move(index,item,scale,x,y,direction,isCallBack)
	--print(""..index.."个".."scale:"..scale)
	print("",index,item.index,scale,item:getLocalZOrder())
	-- if item == nil  then
	-- 	return 
	-- end

	local scale_ = cc.ScaleTo:create(0.5, scale)
	local moveby_ = cc.MoveBy:create(0.5, cc.p(x, y))
	
	if isCallBack  == true then
		local function setState()
			self.state = FREE
			--一次移动表现完，当前item列表指向下标向左右移动
			self:indexMove(direction)
			self:orderReSet()
		end
		local seq = cc.Sequence:create(scale_,cc.DelayTime:create(0.1),cc.CallFunc:create(setState))
		item:runAction(seq)
	else
		item:runAction(scale_)
	end
	item:runAction(moveby_)
end
--根据下标获取对应item
function test:getItemByIndex(index)
	return self.itemList[index]
end
--获取当前位置的缩放比例
function test:getScale_(index)
	if index == 6 or index == 0 then
		return S_4
	elseif index == 1 or index == 5 or index == -1 then
		return S_1
	elseif index == 2 or index == 4 then
		return S_2
	elseif index == 3 then
		return S_3
	end
	return 0
end
--层级重排
function test:orderReSet()
	for i=0,#self.itemList do
		local item = self:getItemByIndex(self:getIndexInLoop(self.index + i) )
		item:setLocalZOrder(3 - math.abs(i - 3))
		if i > 5 then
			item:setLocalZOrder(0)
		end
		if i == 3 then
			item:setTouchEnabled(true)
		else
			item:setTouchEnabled(false)
		end
	end
end
function test:onTouchBegan(touch,event)
	self.touchBeginPosition = touch:getLocation()
	return true
end
function test:onTouchMoved(touch, event)
	local direction = self:checkDirection(self.touchBeginPosition, touch:getLocation())
	self.direction = direction
	if self.direction == DCENTER then
		return
	end
	--判断方向
	if self.state == FREE then
		self.state = MOVING
		self:itemMove()
	end
end
function test:onTouchEnded(touch, event)
end

--根据起点和终点判断方向
--@start  	  起点坐标
--@end_ 	  终点坐标
function test:checkDirection(start,end_)
	local interval = start.x - end_.x
	if interval > 0  then
		return DLEFT
	elseif interval < 0 then
		return DRIGHT
	else
		return DCENTER 
	end
end

function test:create()
	return test.new()
end

return test

