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
    local test = require("test.test"):create()
    test:setPosition(cc.p(320,480))
    print("=======myListView",test:getAnchorPoint())
    --添加子item
    for i=1,6 do
        local str = string.format("book_%s.png",i)
        local item = ccui.Button:create(str,"","")
        local function event(sender,event)
            print("=========touch",i)
        end
        item:addTouchEventListener(event)
        test:addItem_(item)
    end
    test:init_()
    --测试
    --test:test()
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
