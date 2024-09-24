if SERVER then return end -- we don't want server to run GUI code.

local modPath = ...
updateTime = 0

-- our main frame where we will put our custom GUI
local frame = GUI.Frame(GUI.RectTransform(Vector2(1, 1)), nil)
frame.CanBeFocused = false

-- menu frame
local menu = GUI.Frame(GUI.RectTransform(Vector2(1, 1), frame.RectTransform, GUI.Anchor.Center), nil)
menu.CanBeFocused = false
menu.Visible = false

-- put a button that goes behind the menu content, so we can close it when we click outside
local closeButton = GUI.Button(GUI.RectTransform(Vector2(1, 1), menu.RectTransform, GUI.Anchor.Center), "", GUI.Alignment.Center, nil)
closeButton.OnClicked = function ()
    menu.Visible = not menu.Visible
end

-- a button top right of our screen to open a sub-frame menu
local button = GUI.Button(GUI.RectTransform(Vector2(0.2, 0.2), frame.RectTransform, GUI.Anchor.TopRight), "SurgicalTrauma - 外科创伤", GUI.Alignment.Center, "GUIButtonSmall")
button.RectTransform.AbsoluteOffset = Point(25, 100)
button.OnClicked = function ()
    menu.Visible = not menu.Visible
end

local menuContent = GUI.Frame(GUI.RectTransform(Vector2(0.4, 0.6), menu.RectTransform, GUI.Anchor.Center))
local menuList = GUI.ListBox(GUI.RectTransform(Vector2(1, 1), menuContent.RectTransform, GUI.Anchor.BottomCenter))

GUI.TextBlock(GUI.RectTransform(Vector2(1, 0.05), menuList.Content.RectTransform), "SurgicalTrauma - 外科创伤", nil, nil, GUI.Alignment.Center)

local tickBox = GUI.TickBox(GUI.RectTransform(Vector2(1, 0.2), menuList.Content.RectTransform), "This is a tick box")
tickBox.Selected = true
tickBox.OnSelected = function ()
    print(tickBox.Selected)
end

GUI.TextBlock(GUI.RectTransform(Vector2(1, 0.05), menuList.Content.RectTransform), "Call update interval - 调用更新间隔时间", nil, nil, GUI.Alignment.Center)
local numberInput = GUI.NumberInput(GUI.RectTransform(Vector2(1, 0.1), menuList.Content.RectTransform), NumberType.Float)
numberInput.MinValueFloat = 0.5
numberInput.MaxValueFloat = 4
numberInput.IntValue = 2
numberInput.valueStep = 0.5
numberInput.OnValueChanged = function ()
    updateTime = numberInput.FloatValue * 60
    print(numberInput.FloatValue)
end

Hook.Patch("Barotrauma.GameScreen", "AddToGUIUpdateList", function()
    frame.AddToGUIUpdateList()
end)

Hook.Patch("Barotrauma.SubEditorScreen", "AddToGUIUpdateList", function()
    frame.AddToGUIUpdateList()
end)