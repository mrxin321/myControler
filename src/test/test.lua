local test = class("test",function()
	return cc.Layer:create()
end)

--[[
	沿给定线条移动
]]
local CENTER = 3
local MOVING = 1     --移动状态
local FREE   = 2     --空闲状态
local DRIGHT  = 1     --移动右方向
local DLEFT   = -1     --移动左方向
local DCENTER = 0     --移动中心 左右木有偏移
local S_1 = 0.7 		
local S_2 = 0.9
local S_3 = 1
local S_4 = 0
function test:ctor()

	self.interval_width_1 = 100
	self.interval_height_1 = -50
	self.interval_width_2 = 50
	self.interval_height_2 = 50
	self.scale_1 = 0.9
	self.scale_2 = 0.7
	self.itemList = {}
	self.index = 0                   --偏移量
	self.touchBeginPosition = {}
	self.state = FREE  
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

    --初始化item
    --self:init_()    



	-- --启动定时器
	-- local function update_(dt)
	-- 	print("===========")
	-- 	self:update_()
	-- end
	-- --self.schedulerID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(update_, 0, false)

	-- local sprite1 = ccui.Button:create("book.png","","")
	-- --local sprite1 = ccui.ImageView:create("book.png")
	-- sprite1:setPosition(cc.p(320,480))
	-- -- local action = cc.MoveTo:create(1,cc.p( 500,300))
	-- -- local function callback()
	-- -- 	sprite1:setPosition(cc.p(320,480))
	-- -- end
	-- -- local function callback_()
	-- -- 	sprite1:setScale(1)
	-- -- end
	-- -- local seq1 = cc.Sequence:create(action,cc.CallFunc:create(callback))
	-- -- local seq2 = cc.Sequence:create(cc.ScaleTo:create(1,0.8),cc.CallFunc:create(callback_))
	-- -- sprite1:runAction(cc.RepeatForever:create(seq1))
	-- -- sprite1:runAction(cc.RepeatForever:create(seq2))
	-- self:addChild(sprite1,3)
	-- local function event1(sender,event)
	-- 	print("=========touch1")
	-- end
	-- sprite1:addTouchEventListener(event1)

	-- local sprite2 = ccui.Button:create("book.png","","")
	-- sprite2:setPosition(cc.p(220,480))
	-- sprite2:setScale(self.scale_1)
	-- local function event2(sender,event)
	-- 	print("=========touch2")
	-- end
	-- sprite2:addTouchEventListener(event2)
	-- self:addChild(sprite2,2)
	-- sprite2:setTouchEnabled(false)
	-- local sprite3 = ccui.Button:create("book.png","","")
	-- sprite3:setScale(self.scale_1)
	-- sprite3:setPosition(cc.p(420,480))
	-- local function event3(sender,event)
	-- 	print("=========touch3")
	-- end
	-- sprite3:addTouchEventListener(event3)
	-- self:addChild(sprite3,2)
	-- sprite3:setTouchEnabled(false)

	-- local sprite4 = ccui.Button:create("book.png","","")
	-- sprite4:setPosition(cc.p(120,480))
	-- sprite4:setScale(self.scale_2)
	-- local function event4(sender,event)
	-- 	print("=========touch4")
	-- end
	-- sprite4:addTouchEventListener(event4)
	-- self:addChild(sprite4,1)
	-- sprite4:setTouchEnabled(false)

	-- local sprite5 = ccui.Button:create("book.png","","")
	-- sprite5:setPosition(cc.p(520,480))
	-- sprite5:setScale(self.scale_2)
	-- local function event5(sender,event)
	-- 	print("=========touch5")
	-- end
	-- sprite5:addTouchEventListener(event5)
	-- self:addChild(sprite5,1)
	-- sprite5:setTouchEnabled(false)

end
--设置上下左右间距，如显示有f1 f2 f3 f4 f5 f2-f1=第一间距  f3-f2=第二间距 f4-f3=第一间距 f5-f4=第二间距
--w1,h1第一间距宽高
--w2,h2第二间距
function test:setProperty(w1,h1,w2,h2)
	self.interval_width_1  = w1
	self.interval_height_1 = h1
	self.interval_width_2  = w2
	self.interval_height_2 = h2
end
function test:addItem_(item)
	table.insert(self.itemList, item)
end
--初始化item
function test:init_()
	print("=-=======count",#self.itemList)
	--初始化中心
	for i=1,6 do
		local item = self.itemList[i]
		item:setTouchEnabled(false)
		local x = (i - 3) * self.interval_width_1
		local y = (i - 3) * self.interval_height_1
		item:setPosition(cc.p(x,y))
		item:setScale( 1 - math.abs(i-3) * 0.1 )
		self:addChild(item, -math.abs(i-3) + 3)
		if i > 5 then
			item:setScale(0)
			item:setZOrder(100)
		end
	end
end
function test:test()
	local item = ccui.Button:create("book.png","","")
	--item:setScale(0)
	item:setPosition(cc.p(0,0))
    local function event(sender,event)
        print("=========touch",i)
    end
    item:addTouchEventListener(event)
    --self:addChild(item)
    self:moveDown(item,0)
end
function test:getWeight()

end
function test:getHeight()

end
function test:indexMove()
	self.index = self.index + 1
	if self.index > #self.itemList then
		self.index = 1
	end
end
--子控件移动
function test:itemMove(direction)
	for i=0,5 do
		local item = self:getItemByIndex(i)
		self:move(item, i, direction)
	end
end
function test:move(item,index,direction)
	--print("====item",index,item)
	if index == 0 then
		item:setPosition(cc.p(-200,100))
		print("========scale1",item:getScale())
	end
	local scale_ = cc.ScaleTo:create(1, self:getNextScale(index + 1))
	if index == 0 then
		print("========scale2",self:getNextScale(index + 1))
	end
	local moveby_ = cc.MoveBy:create(1, cc.p(direction * self.interval_width_1, direction * self.interval_height_1))
	local function setState()
		self.state = FREE
	end
	local seq = cc.Sequence:create(scale_,cc.CallFunc:create(setState))
	
	item:runAction(seq)
	item:runAction(moveby_)
end
--根据下标获取对应item
function test:getItemByIndex(index)
	if index > 5 then
		return
	end
	if index == 0 then
		if #self.itemList > 5 then
			print("=====cur",#self.itemList)
			return self.itemList[#self.itemList]
		end
	else
		return self.itemList[index + self.index]
	end

end
--获取下一个位置的缩放比例
function test:getNextScale(index)
	if index == 1 or index == 5 then
		return S_1
	elseif index == 2 or index == 4 then
		return S_2
	elseif index == 3 then
		return S_3
	elseif index == 0 or index == 6 then
		return S_4
	end
end
function test:getNextPosition()
end
function test:onTouchBegan(touch,event)
	--如果触摸点在item中，不反应
	-- if self:isValid(touch:getLocation()) then
	-- 	return false
	-- end
	--记录触摸点
	self.touchBeginPosition = touch:getLocation()
	return true
end
function test:onTouchMoved(touch, event)
	--判断方向
	if self.state == FREE then
		self.state = MOVING
		self:itemMove(self:checkDirection(self.touchBeginPosition, touch:getLocation()))
	end
end
function test:onTouchEnded(touch, event)
	-- if self:isValid(touch:getLocation()) then
	-- 	return
	-- end
	if self:checkDirection(self.touchBeginPosition, touch:getLocation()) == DCENTER then
		--激活按钮事件
		--判断是否在中心按钮]
		local item = self.itemList[CENTER]
		local contentSize = item:getContentSize()
		local center = {}
		center.x,center.y = item:getPosition()
		if(self:isInside(touch:getLocation(),center,contentSize)) then 
			print("激活按钮事件=========")
		end
	end
end
function test:update_()

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
--判断触摸点是否无效，如果触摸点在item上则无效
function test:isValid(target)
	for k,v in ipairs(self.itemList) do
		local center = {}
		center.x,center.y = v:getPosition()
		if self:isInside(target, center, v:getContentSize()) then
			return true
		end
	end
	return false
end
--判断触摸点在不在矩形内
function test:isInside(target,center,contentSize)
	print("========= t1,t2",target.x,target.y)
	print("========= x1,x2",center.x - contentSize.width /2,center.x + contentSize.width /2)
	print("========= y1 y2",center.y - contentSize.height / 2,center.y + contentSize.height / 2)
	if target.x >= center.x - contentSize.width /2 and target.x <= center.x + contentSize.width /2 
		and target.y >= center.y - contentSize.height / 2 and target.y <= center.y + contentSize.height / 2 then
		print("====inside")
		return true
	end
	print("====no inside")
	return false
end
function test:create()
	return test.new()
end

return test
