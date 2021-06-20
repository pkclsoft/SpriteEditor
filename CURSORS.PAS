Unit Cursors;

INTERFACE

uses  Common, QuickDrawII, IntegerMath, WindowMgr, EventMgr;

const
	Arrow_cursor = 0;
	Beam_cursor = 1;
	Watch_cursor = 2;

Type
	MyCursorType = record
	      CursorHeight	:	Integer;
	      CursorWidth	:	Integer;
	      data			:	array[1..11,1..5] of Integer;
	      mask			:	array[1..11,1..5] of Integer;
	      HotSpot		:	Point;
	   end;

{procedure SetMyCursor (var theCursor: MyCursorType); tool ($04, $8E);}

var
	Current_cursor	: Integer;

	My_beam			: cursor;
	
	Very_busy		: Boolean;

procedure Check_cursors(Current_window_ptr : grafPortPtr);
procedure Do_arrow;
procedure Do_watch;
procedure Do_beam;
procedure Form_cursors;

IMPLEMENTATION

procedure Do_beam;
begin
	If (Current_cursor = Arrow_cursor) or
	   (Current_cursor = Watch_cursor) then
	begin
		SetCursor(My_beam);
		Current_cursor := Beam_cursor;
	end;
end;

procedure Do_watch;
begin
		WaitCursor;
		Current_cursor := Watch_cursor;
end;

procedure Do_arrow;
begin
	If (Current_cursor = Beam_cursor)  or
	   (Current_cursor = Watch_cursor) then
	begin
		InitCursor;
		Current_cursor := Arrow_cursor;
	end;
end;

procedure Check_cursors; {(Current_window_ptr : WindowPtr);}
var
	code:	 integer;
	theWind : grafPortPtr;
	myPoint : Point;
begin
	{ Make sure cursor is	being displayed	as the correct type }
	GetMouse(myPoint);
	LocalToGlobal(myPoint);
	code := FindWindow(theWind,myPoint.h,myPoint.v);
	
	if Very_busy
	then
		begin
			Do_watch;
		end
	else
		begin
			if code = wInContent
			then
				begin
					Do_beam;
				end
			else
				Do_arrow;
		end;
end;

procedure Form_cursors;
var
	Addr : Longint;
begin

	with My_beam do			{ Form Beam cursor. }
	begin
		CursorHeight := 11;
		CursorWidth		:= 5;
		HotSpotX		:= 8;
		HotSpotY		:= 6;
		
		Addr := Ord4(@cursorImage);
	    addr := Hex2Long('0000000000000000', 16); addr := addr + 8;
	    addr := Hex2Long('0000000000000000', 16); addr := addr + 8;
	    addr := Hex2Long('0000000000000000', 16); addr := addr + 8;
	    addr := Hex2Long('00f0000f00000000', 16); addr := addr + 8;
	    addr := Hex2Long('000f00f000000000', 16); addr := addr + 8;
	    addr := Hex2Long('0000000000000000', 16); addr := addr + 8;
	    addr := Hex2Long('0000000000000000', 16); addr := addr + 8;
	    addr := Hex2Long('000f00f000000000', 16); addr := addr + 8;
	    addr := Hex2Long('00f0000f00000000', 16); addr := addr + 8;
	    addr := Hex2Long('0000000000000000', 16); addr := addr + 8;
	    addr := Hex2Long('0000000000000000', 16); addr := addr + 8;
	    addr := Hex2Long('0000000000000000', 16); addr := addr + 8;
	    addr := Hex2Long('0000000000000000', 16); addr := addr + 8;
	    addr := Hex2Long('0000000000000000', 16); addr := addr + 8;
	    addr := Hex2Long('0000000000000000', 16); addr := addr + 8;
	    addr := Hex2Long('0000000000000000', 16); addr := addr + 8;
	    addr := Hex2Long('0000000000000000', 16); addr := addr + 8;
	    addr := Hex2Long('0000000000000000', 16); addr := addr + 8;
	    addr := Hex2Long('0000000000000000', 16); addr := addr + 8;
	    addr := Hex2Long('0000000000000000', 16); addr := addr + 8;
	    addr := Hex2Long('0000000000000000', 16); addr := addr + 8;
	    addr := Hex2Long('0000000000000000', 16); addr := addr + 8;
	end;
end;

end.
