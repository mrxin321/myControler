require "Cocos2d"
require "Cocos2dConstants"

-- cclog
cclog = function(...)
    print(string.format(...))
end

-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
    cclog("----------------------------------------")
    cclog("LUA ERROR: " .. tostring(msg) .. "\n")
    cclog(debug.traceback())
    cclog("----------------------------------------")
    return msg
end

local function main()
    collectgarbage("collect")
    -- avoid memory leak
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)

    cc.FileUtils:getInstance():setPopupNotify(false)
    cc.FileUtils:getInstance():addSearchPath("src/")
    cc.FileUtils:getInstance():addSearchPath("res/")

    cc.Director:getInstance():setDisplayStats(true)
    cc.Director:getInstance():getOpenGLView():setFrameSize(640,960)
    cc.Director:getInstance():getOpenGLView():setDesignResolutionSize(640, 960, 1)
    
    --local layer = require("GameScene"):create()
    local layer = cc.Layer:create()
    local sceneGame =  cc.Scene:create()
    sceneGame:addChild(layer)  

   
    --测试
    local test = require("test.test2"):create()
    test:setPosition(cc.p(320,480))
    --添加子item
    for i=1,6 do 
        local str = string.format("book_%s.png",i)
        local item = ccui.Button:create(str,"","")
        item.index = i
        local function event(sender,event)
            print("=========touch",i)
        end
        item:addTouchEventListener(event)
        test:addItem_(item)
    end
    test:init_()
    --测试
    -- local button = ccui.Button:create("menu1.png","","")
    -- button:setPosition(cc.p(480,320))
    -- layer:addChild(button)
    -- local function event(sender,event)
    --     if event == ccui.TouchEventType.ended then
    --         test:testMoveRight()
    --     end
    -- end 
    -- button:addTouchEventListener(event)

    -- local button2 = ccui.Button:create("menu1.png","","")
    -- button2:setPosition(cc.p(400,320))
    -- layer:addChild(button2)
    -- local function event2(sender,event)
    --     if event == ccui.TouchEventType.ended then
    --         test:testMoveLeft()
    --     end
    -- end 
    -- button2:addTouchEventListener(event2)

    layer:addChild(test)

    if cc.Director:getInstance():getRunningScene() then
        cc.Director:getInstance():replaceScene(sceneGame)
    else  
        cc.Director:getInstance():runWithScene(sceneGame) 
    end 
end


local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    error(msg)
end
