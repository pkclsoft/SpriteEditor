Unit Globals;

INTERFACE

uses QDIntf, GSIntf, MiscTools, ConsoleIO, Cursors, ProDOS16;

const
	ScreenMode = $00;	{   0 for 320 mode, $80 for 640 mode }
	MaxX = 320;			{ 320 for 320 mode, 640 for 640 mode }
	MaxColour = 16;		{  16 for 320 mode,   4 for 640 mode }
	MaxWindow = 5;		{ limit the number of user windows }
	Non_event = 0;		{ no event has occurred }
	Actual = 3;
	ActLeft = 24;
	ActRight = 74;
	ActTop = 17;
	ActBottom = 67;
	Magnified = 2;
	MagLeft = 117;
	MagRight = 315;
	MagTop = 17;
	MagBottom = 166;
	Colour = 1;
	ColLeft = 18;
	ColRight = 98;
	ColTop = 75;
	ColBottom = 115;
	Current = 4;
	CurLeft = 18;
	CurRight = 98;
	CurTop = 116;
	CurBottom = 121;
	Message = 5;
	MesLeft = 2;
	MesRight = 112;
	MesTop = 125;
	MesBottom = 199;
		
var
	AppleMenuStr	: Str255;
	FileMenuStr		: Str255;
	EditMenuStr		: Str255;
	PhoneMenuStr	: Str255;
	ReceiveMenuStr	: Str255;
	SendMenuStr		: Str255;
	SessionMenuStr	: Str255;

	Myuserid		: Integer;
	Event_number	: Integer;
	Current_window	: Integer;
	TotalWindow		: Integer;
	CurrentColour	: Integer;
	Myhandle		: Handle;
	a,b				: Integer;
	Freshit			: Integer;

	Windrecord		: array [1..Maxwindow] of NewWindowParamBlk;
	Mywindow		: array [1..Maxwindow] of WindowPtr;
	Sprite			: array [0..49,0..49]  of Byte;
	WindRect		: array [1..Maxwindow] of rect;

	Event			: EventRecord;

	Time_to_quit 	: Boolean;
	MDown			: Boolean;

procedure ClearSprite;

IMPLEMENTATION

procedure ClearSprite;
var
	r : rect;
begin
	WaitCursor;
	Current_cursor := Watch_cursor;

	SetPort(Mywindow[Actual]);
	GetPortRect(r);
	SetSolidPenPat(0);
	PaintRect(r);
	SetPort(Mywindow[Magnified]);
	GetPortRect(r);
	SetSolidPenPat(0);
	PaintRect(r);

	for a := 0 to 49 do
	begin
		for b := 0 to 49 do
		begin
			Sprite[a,b] := 0;
		end;
	end;
	
end;

end.