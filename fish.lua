local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local uis = game:GetService("UserInputService")
local vim = game:GetService("VirtualInputManager")

-- Remote references
local netFolder = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):FindFirstChild("sleitnick_net@0.2.0")
local miniGameRemote = netFolder.net:FindFirstChild("RF/RequestFishingMinigameStarted")
local sellRemote = netFolder.net:FindFirstChild("RF/SellItem")
local fishCaughtRemote = netFolder.net:FindFirstChild("RE/ObtainedNewFishNotification")

-- 🎯 Auto Perfect Cast (anti cheat offset & delay)
local Old
Old = hookmetamethod(game, "__namecall", function(Self, ...)
	local Method = getnamecallmethod()
	local Args = {...}
	if Method == "InvokeServer" and Self == miniGameRemote then
		local perfectX = 0.5 + math.random(-3, 3) * 0.001
		local perfectY = 2.0 + math.random() * 0.03
		task.wait(0.1 + math.random() * 0.1)
		return Old(Self, perfectX, perfectY)
	end
	return Old(Self, ...)
end)

-- 🖱️ Auto Clicker GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "FishItClicker"
gui.ResetOnSpawn = false

local button = Instance.new("TextButton", gui)
button.Size = UDim2.new(0, 40, 0, 40)
button.Position = UDim2.new(0, 715, 0, 290)
button.Text = "OFF"
button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
button.BackgroundTransparency = 0.3
button.TextColor3 = Color3.new(1, 1, 1)
button.BorderSizePixel = 0
button.AutoButtonColor = false
button.Font = Enum.Font.SourceSansBold
button.TextSize = 14
button.TextWrapped = true
button.Active = true
button.Draggable = true 

local corner = Instance.new("UICorner", button)
corner.CornerRadius = UDim.new(0, 40)

-- 🔘 Toggle ON/OFF via double click
local autoClick = false
local lastClick = 0

button.MouseButton1Click:Connect(function()
	local now = tick()
	if now - lastClick < 0.35 then
		autoClick = not autoClick
		button.Text = autoClick and "ON" or "OFF"
		button.TextColor3 = autoClick and Color3.fromRGB(0, 255, 0) or Color3.new(1, 1, 1)
	end
	lastClick = now
end)

-- 🔁 Auto Click Loop (anti cheat)
task.spawn(function()
	while true do
		if autoClick then
			local pos = button.AbsolutePosition
			local size = button.AbsoluteSize
			local centerX = pos.X + size.X / 2 + math.random(-1, 1)
			local centerY = pos.Y + size.Y / 2 + math.random(-1, 1)

			vim:SendMouseButtonEvent(centerX, centerY, 0, true, game, 0)
			task.wait(0.015 + math.random() * 0.01)
			vim:SendMouseButtonEvent(centerX, centerY, 0, false, game, 0)
			
			task.wait(0.09 + math.random() * 0.05)
		else
			task.wait(0.02)
		end
	end
end)
