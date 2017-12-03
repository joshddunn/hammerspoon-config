-- window management

-- animation set 0 for instant sizing
hs.window.animationDuration = 0

function windowOrder()
  local KEYBOARD_MODIFIER = {'ctrl', 'option'}

  function getPos()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()
    return {win = win, f = f, screen = screen, max = max}
  end

  function position(area)
    if area == 'right' then
      return function()
        local pos = getPos();
        local westPastHalf = pos.f.x + 10 > pos.max.w / 2;
        local eastAtMax = pos.f.x + pos.f.w + 10 > pos.max.w;

        if westPastHalf or eastAtMax then
            pos.f.x = pos.max.w / 2
            pos.f.w = pos.max.w / 2
        else
            pos.f.w = pos.max.w - pos.f.x
        end

        pos.win:setFrame(pos.f)
      end
    end

    if area == 'left' then
      return function()
        local pos = getPos();
        local eastPastHalf = pos.f.x + pos.f.w + 10 > pos.max.w / 2;
        local westAtMin = pos.f.x == 0;

        if not eastPastHalf or westAtMin then
            pos.f.x = 0 
            pos.f.w = pos.max.w / 2
        else
            pos.f.w = pos.f.x + pos.f.w
            pos.f.x = 0
        end

        pos.win:setFrame(pos.f)
      end
    end

    if area == "up" then
      return function() 
        local pos = getPos();
        local bar = 23;
        local southPastHalf = pos.f.y + pos.f.h > pos.max.h / 2;
        local northAtTop = pos.f.y == bar;

        if northAtTop and southPastHalf then
            pos.f.y = bar
            pos.f.h = pos.max.h / 2;
        else
            pos.f.h = pos.f.h + pos.f.y - bar
            pos.f.y = bar
        end
            
        pos.win:setFrame(pos.f)
      end
    end

    if area == "down" then
      return function() 
        local pos = getPos();
        local bar = 23;
        local northPastHalf = pos.f.y > pos.max.h / 2;
        local southAtBottom = pos.f.y + pos.f.h + 10 > pos.max.h;

        if southAtBottom and not northPastHalf then
            pos.f.y = pos.max.h / 2 + bar 
            pos.f.h = pos.max.h / 2;
        else
            pos.f.h = pos.max.h - pos.f.y + bar 
        end

        pos.win:setFrame(pos.f)
      end
    end

    if area == 'centre' then
      return function()
        hs.window.focusedWindow():centerOnScreen()
      end
    end

    if area == 'small' then
      return function()
        local pos = getPos()
        pos.f.w = 1280
        pos.f.h = 720

        pos.win:setFrame(pos.f)
        position('centre')()
      end
    end

    if area == 'full' then
      return function()
        hs.window.focusedWindow():maximize()
      end
    end

    if area == 'screen' then
      return function()
        hs.window.focusedWindow():moveOneScreenWest()
      end
    end


  end

  hs.hotkey.bind(KEYBOARD_MODIFIER, 'l', position('right'))
  hs.hotkey.bind(KEYBOARD_MODIFIER, 'k', position('up'))
  hs.hotkey.bind(KEYBOARD_MODIFIER, 'j', position('down'))
  hs.hotkey.bind(KEYBOARD_MODIFIER, 'h', position('left'))

  hs.hotkey.bind(KEYBOARD_MODIFIER, 'right', position('right'))
  hs.hotkey.bind(KEYBOARD_MODIFIER, 'up', position('up'))
  hs.hotkey.bind(KEYBOARD_MODIFIER, 'down', position('down'))
  hs.hotkey.bind(KEYBOARD_MODIFIER, 'left', position('left'))

  hs.hotkey.bind(KEYBOARD_MODIFIER, 'c', position('centre'))
  hs.hotkey.bind(KEYBOARD_MODIFIER, '-', position('small'))
  hs.hotkey.bind(KEYBOARD_MODIFIER, '=', position('full'))

  hs.hotkey.bind(KEYBOARD_MODIFIER, 'v', position('screen'))
end

return windowOrder
