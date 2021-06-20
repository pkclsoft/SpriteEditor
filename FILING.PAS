Unit Filing;

INTERFACE

uses Common, DialogMgr, QuickDrawII, Cursors, SFToolSet, WindowMgr, Globals;

var
	myReply		: ReplyRecord; { misc globals}
	SpriteFile	: Text;
	SpriteWidth	: Integer;
	SpriteHeight : Integer;
	i,j : Integer;
	chartr : char;
	TList : typeList;
	
procedure SaveSprite;
procedure OpenSprite;

IMPLEMENTATION

procedure SaveSprite;
var
  i, j: Integer;
begin
	SetPort(Mywindow[Message]);
	MoveTo(1,10);
	SetBackColor(15);
	SetForeColor(7);
	Writeln('Enter width :');
	SetForeColor(10);
	Readln(SpriteWidth);
	SetForeColor(7);
	Writeln('Enter Height :');
	SetForeColor(10);
	Readln(SpriteHeight);
	
	SFPutFile(25, 20, 'Save sprite as:', '', 15, myReply);
	
	If MyReply.Good then
	begin
		WaitCursor;

		Rewrite(SpriteFile, myReply.fullpathname);
	
		for j := 0 to SpriteHeight - 1 do
		begin
			for i := 0 to SpriteWidth - 1 do
			begin
				If Sprite[i,j] > 9
				then
					begin
						write(SpriteFile,chr(Sprite[i,j] + 55));
					end
				else
					write(SpriteFile,chr(Sprite[i,j] + 48));
			end;
			writeln(SpriteFile,'');
		end;
	
		close(SpriteFile);
	end;

end;

procedure OpenSprite;
var
	openDlog: grafPortPtr;
	r:	   Rect;
	itemHit:   Integer;
	i, j: Integer;
	ic : colorTable;
begin
	with	r do begin
		top := 50; left := 50; bottom := 100; right := 270;
	end;
	openDlog :=	NewModalDialog(r,true,0);

	SetPort(openDlog);
	with	r do begin
		top := 30; left := 10; bottom := 0; right := 0;
	end;

	NewDItem(openDlog,1,r,10,@'Ok',0,0,ic);

	with	r do begin
		top := 30; left := 135; bottom := 0; right := 0;
	end;

	NewDItem(openDlog,2,r,10,@'Cancel',0,0,ic);
	SetDefButton(2,openDlog);

	SetForeColor(7);
	SetBackColor(15);
	MoveTo(44,20);  DrawString('Lose current Sprite ?');

	itemHit := ModalDialog(nil);

	CloseDialog(openDlog);

	If itemHit = 1 then 		{lets get another one then}
	begin
		TList.NumEntries := 1;
		TList.FileType[1]  := $04;
	
		SFGetFile(25, 20, 'Load which sprite :',Nil,@TList, myReply);
		
		If Myreply.good then 	{definitely want one}
		begin
			ClearSprite;
			
			Reset(SpriteFile, MyReply.FullPathname);
			
			for j := 0 to 49 do
			begin
			    i := 0;
			    repeat
					Read(SpriteFile,chartr);
					If ord(chartr) > 64
					then
						begin
							Sprite[i,j] := ord(chartr) - 55;
						end
					else 
					begin
					    if ord(chartr) <> 13 then
							Sprite[i,j] := ord(chartr) - 48;
					end;
					
					i := i + 1;
				until (i = 49) or (ord(chartr) = 13);
				
				If ord(chartr) <> 13 then Read(SpriteFile,chartr);
			end;
	
			close(SpriteFile);
		end;
	end;
end;

end.
