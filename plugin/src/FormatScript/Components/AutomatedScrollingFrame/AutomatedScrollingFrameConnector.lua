local function AutomatedScrollingFrameConnector(ScrollingFrame: ScrollingFrame, PossibleUIGridStyleLayout: UIGridStyleLayout?)
	local UIGridStyleLayout = PossibleUIGridStyleLayout or ScrollingFrame:FindFirstChildWhichIsA("UIGridStyleLayout") :: UIGridStyleLayout
	local function UpdateFrame()
		local AbsoluteContentSize = UIGridStyleLayout.AbsoluteContentSize
		ScrollingFrame.CanvasSize = UDim2.fromOffset(AbsoluteContentSize.X, AbsoluteContentSize.Y)
	end

	UpdateFrame()
	UIGridStyleLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateFrame)
end

return AutomatedScrollingFrameConnector