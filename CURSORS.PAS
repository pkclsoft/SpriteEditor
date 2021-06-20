Unit Cursors;

INTERFACE

uses  QDIntf, GSIntf, ConsoleIO;

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

var
	Current_cursor	: Integer;

	My_beam			: MyCursorType;
	
	Very_busy		: Boolean;

procedure Check_cursors(Current_window_ptr : WindowPtr);
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
		SetCursor(@My_beam);
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

procedure Check_cursors(Current_window_ptr : WindowPtr);
var
	code:	 integer;
	theWind : WindowPtr;
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
			if code =	wInContent
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
		HotSpot.h		:= 8;
		HotSpot.v		:= 6;
		
		Addr := Ord4(@data);
	    StuffHex(addr,  	'00000000000000000000');
	    StuffHex(addr+10,	'00000000000000000000');
	    StuffHex(addr+20,	'00000000000000000000');
	    StuffHex(addr+30,	'0000f0000f0000000000');
	    StuffHex(addr+40,	'00000f00f00000000000');
	    StuffHex(addr+50,	'00000000000000000000');
	    StuffHex(addr+60,	'00000000000000000000');
	    StuffHex(addr+70,	'00000f00f00000000000');
	    StuffHex(addr+80,	'0000f0000f0000000000');
	    StuffHex(addr+90,	'00000000000000000000');
	    StuffHex(addr+100,	'00000000000000000000');
	    StuffHex(addr+110,	'00000000000000000000');
	    StuffHex(addr+120,	'00000000000000000000');
	    StuffHex(addr+130,	'00000000000000000000');
	    StuffHex(addr+140,	'00000000000000000000');
	    StuffHex(addr+150,	'00000000000000000000');
	    StuffHex(addr+160,	'00000000000000000000');
	    StuffHex(addr+170,	'00000000000000000000');
	    StuffHex(addr+180,	'00000000000000000000');
	    StuffHex(addr+190,	'00000000000000000000');
	    StuffHex(addr+200,	'00000000000000000000');
	    StuffHex(addr+210,	'00000000000000000000');
	end;
end;

end.
