export type SquareData = {
	Bottom: number,
	Left: number,
	Right: number,
	Top: number,
}

return {
	Rectangle = function(Horizontal: number, Vertical: number): SquareData
		return {
			Bottom = Vertical;
			Left = Horizontal;
			Right = Horizontal;
			Top = Vertical;
		}
	end;

	Square = function(Side: number): SquareData
		return {
			Bottom = Side;
			Left = Side;
			Right = Side;
			Top = Side;
		}
	end;

	Quad = function(Top: number, Right: number, Bottom: number, Left: number): SquareData
		return {
			Bottom = Bottom;
			Left = Left;
			Right = Right;
			Top = Top;
		}
	end;
}
