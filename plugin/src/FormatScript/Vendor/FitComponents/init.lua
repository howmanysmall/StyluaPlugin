local Square = require(script.Square)

return {
	FitFrameHorizontal = require(script.FitFrameHorizontal);
	FitFrameOnAxis = require(script.FitFrameOnAxis);
	FitFrameVertical = require(script.FitFrameVertical);
	FitTextLabel = require(script.FitTextLabel);
	Rect = Square; -- For compatibility with roact-fit-components
	Square = Square;
}
