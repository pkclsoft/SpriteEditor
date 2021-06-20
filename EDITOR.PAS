Program Editor;

uses Common, DialogMgr, QuickDrawII, Cursors, SFToolSet, WindowMgr, Globals, Filing, 
     ToolLocator, MemoryMgr, MscToolSet, IntegerMath, EventMgr, ControlMgr, MenuMgr,
     ScrapMgr, LineEdit, DeskMgr, TextToolSet;

{ This routine initializes each of the //GS Tools required for every application.}

procedure startup_tools;
const
   {  -------------------   Toolbox Numbers   -------------------  }

    { Toolbox number constants for use in Tool Locator type calls. }

    ToolLocator     = 1;
    MemoryManager   = 2;
    MiscToolSet     = 3;
    QuickDrawII     = 4;
    DeskManager     = 5;
    EventManager    = 6;
    Scheduler       = 7;
    SoundToolSet    = 8;
    ADBToolSet      = 9;
    SANEToolSet     = 10;
    IntegerMath     = 11;
    TextToolSet     = 12;
    ReservedSet     = 13;
    WindowManager   = 14;
    MenuManager     = 15;
    ControlManager  = 16;
    SystemLoader    = 17;
    QuickDrawIIAux  = 18;
    PrintManager    = 19;
    LineEditToolSet = 20;
    DialogManager   = 21;
    ScrapManager    = 22;
    StandardFile    = 23;
    NotAvailable    = 24;
    NoteSynthesizer = 25;
    NoteSequencer   = 26;
    FontManager     = 27;
    ListManager     = 28;
    ACEToolSet      = 29;
    ResourceManager = 30;
    MIDIToolSet     = 31;
    TextEditToolSet = 34;

type 
    startStopRecordPtr = ^startStopRecord;
var
    Toolrec :  startStopRecordPtr;
    dummy: longint;
begin
    TLStartUp;                          { init Tool Locator }
    Myuserid := MMStartUp;              { init Memory manager }
    MTStartUp;                          { init Misc Tools }

   { Allocate 8 pages of memory in bank 0 for use by GS Tools.
     3 pages for QuickDraw, 
     1 page for Event Manager, 
     1 page for Menu Manager,
     1 page for Control Manager,
     1 page for Line Edit,
     1 page for Standard File}

    Myhandle :=  NewHandle(8 * 256,                     { allocate 7 pages }
                          Myuserid,                     { User ID for memory blocks }
                          attrBank+attrFixed+attrLocked,    { Attributes }
                          ptr(0));                      { start in bank 0 }

    QDStartUp(LoWord(Myhandle^),                { low address of the first 3 zero pages }
             ScreenMode,                        { 640 mode }
             160,                               { max size of scan line }
             Myuserid);                         { User ID for memory blocks }       

   EMStartUp(LoWord(Myhandle^) +    $300,       { low address of 4th zero page }
             20,                                { event queue size }
             0,                                 { X min clamp }
             MaxX,                              { X max clamp }
             0,                                 { Y min clamp }
             200,                               { Y max clamp }
             Myuserid);                         { User ID for memory blocks }

   { Give a message while we load RAM based tools }

    MoveTo(0,40);
    SetBackColor(0);
    SetForeColor(15);
    DrawString('Loading RAM based tools.....Please wait.');
   
   { Now load RAM based tools (and RAM patches to ROM tools!) }

   new(ToolRec);

   with ToolRec^ do
   begin
		flags := 0;
		videoMode := mode320;
		numTools := 26;
	
		toolArray[01].toolNumber := ToolLocator;
		toolArray[01].minVersion := $0300;
		toolArray[02].toolNumber := ADBToolSet;
		toolArray[02].minVersion := $0201;
		toolArray[03].toolNumber := TextToolSet;
		toolArray[03].minVersion := $0201;
		toolArray[04].toolNumber := MemoryManager;
		toolArray[04].minVersion := $0300;
		toolArray[05].toolNumber := SANEToolSet;
		toolArray[05].minVersion := $0202;
		toolArray[06].toolNumber := ResourceManager;
		toolArray[06].minVersion := $0100;
		toolArray[07].toolNumber := MiscToolSet;
		toolArray[07].minVersion := $0300;
		toolArray[08].toolNumber := Scheduler;
		toolArray[08].minVersion := $0200;
		toolArray[09].toolNumber := SystemLoader;
		toolArray[09].minVersion := $0300;
		toolArray[10].toolNumber := QuickDrawII;
		toolArray[10].minVersion := $0301;
		toolArray[11].toolNumber := QuickDrawIIAux;
		toolArray[11].minVersion := $0301;
		toolArray[12].toolNumber := EventManager;
		toolArray[12].minVersion := $0300;
		toolArray[13].toolNumber := WindowManager;
		toolArray[13].minVersion := $0301;
		toolArray[14].toolNumber := ControlManager;
		toolArray[14].minVersion := $0301;
		toolArray[15].toolNumber := MenuManager;
		toolArray[15].minVersion := $0301;
		toolArray[16].toolNumber := lineEditToolSet;
		toolArray[16].minVersion := $0301;
		toolArray[17].toolNumber := DialogManager;
		toolArray[17].minVersion := $0302;
		toolArray[18].toolNumber := SoundToolSet;
		toolArray[18].minVersion := $0301;
		toolArray[19].toolNumber := NoteSynthesizer;
		toolArray[19].minVersion := $0104;
		toolArray[20].toolNumber := StandardFile;
		toolArray[20].minVersion := $0301;
		toolArray[21].toolNumber := ScrapManager;
		toolArray[21].minVersion := $0300;
		toolArray[22].toolNumber := DeskManager;
		toolArray[22].minVersion := $0302;
		toolArray[23].toolNumber := ListManager;
		toolArray[23].minVersion := $0301;
		toolArray[24].toolNumber := FontManager;
		toolArray[24].minVersion := $0301;
		toolArray[25].toolNumber := PrintManager;
		toolArray[25].minVersion := $0300;
		toolArray[26].toolNumber := TextEditToolSet;
		toolArray[26].minVersion := $0101;
   end;
   dummy := StartupTools(Myuserid, 0, ToolRec);                  { Load the tools I need }
    
   if TLStatus
   then
        begin
            MoveTo(0,80);
            SetBackColor(0);
            SetForeColor(1);
            DrawString('Error occured during load of tools.');
        end
    else
        begin
            MoveTo(0,80);
            SetBackColor(0);
            SetForeColor(1);
            DrawString('Tools loaded ok.');
        end;

    QDAuxStartUp;
                  
    WindStartUp(Myuserid);                      { init Window Manager }
    RefreshDesktop(nil);
                                                { init Control Manager }   
    CtlStartUp(Myuserid,                        { User ID for memory blocks }
              LoWord(Myhandle^) +   $400);      { low address of 5th zero page }
        
                                                { init Menu Manager }
    MenuStartUp(Myuserid,                       { UserID for memory blocks }
                LoWord(Myhandle^) + $500);      { low address of 6th zero page }

    ScrapStartUp;                               { init Scrap Manager }
   
                                                { init Line Editor }
    LEStartUp(LoWord(Myhandle^) +   $600,       { low address of 6th zero page }
              Myuserid);                        { User ID for memory blocks }
       
   SFStartUp(Myuserid,                          { UserID for memory blocks }
             LoWord(MyHandle^) +    $700);      { low address of 8th zero page }

                                                { init Dialog Manager }
    DialogStartUp(Myuserid);                    { User ID for memory blocks }

    DeskStartUp;                                { init Desk Manager }
   
    InitCursor;
    
end; { of Startup_tools }

procedure SetUpMenus;
{ This procedure creates the menus for the application.

  NOTE:  The parameters to NewMenu MUST not be local variables or expressions.
     NewMenu maintains pointers to the string passed to it which must
     remain the same.  Thus only global variables are allowable.
}
var Height: Integer;
begin
   AppleMenuStr :=  concat('>>@\XN1\0',
                           '==About SprEditor...\N300\0',
                           '==-\N260D\0..');
                           
   FileMenuStr  :=  concat('>>  File  \N2\0',
                           '==Clear Editor\N400\0',
                           '==Open\N401*Oo\0',
                           '==Save as ...\N402*Ss\0',
                           '==-\N263D\0',
                           '==Quit\N403*Qq\0.');

   SetMTitleStart(5);

   InsertMenu(NewMenu(@FileMenuStr[1]),0);      { File Menu }
   InsertMenu(NewMenu(@AppleMenuStr[1]),0);     { Apple Menu }
   
   FixAppleMenu(1);         { Add DAs to apple menu }
   
   Height := FixMenuBar;    { Set sizes of menus }
   
   DrawMenuBar;             { ... and draw the menu bar! }
end;

{ Shut down each of the //GS Tools initialized previously before exitting this
  application. }

procedure Shutdown_tools;
begin   
    GrafOff;
    DeskShutDown;
    DialogShutDown;
    SFShutdown;
    LEShutDown;
    ScrapShutDown;
    MenuShutDown;
    CtlShutDown;
    WindShutDown;
    QDAuxShutdown;
    EMShutDown;
    QDShutDown;
    MTShutDown;
    MMShutDown(Myuserid);
    TLShutDown;
end; { of Shutdown_tools }

procedure GetColorRect(i,j : Integer; var result: Rect);
var
    r : rect;
begin
    with r do
    begin
        left := (10 * i) + ColLeft;
        right := left + 10;
        top := (20 * j) + ColTop;
        bottom := top + 20;
    end;
    
    result := r;
end;

procedure GetDotRect(i,j : integer; var result: Rect);
var
    r : rect;
begin
    with r do
    begin
        left := (MagLeft * Freshit)  + (4 * i) + (2 - (Freshit * 2));
        right := left + 2;
        top := (MagTop * Freshit) + (3 * j) + (2 - (Freshit * 2));
        bottom := top + 2;
    end;
    
    result := r;
end;

procedure SetSprite(k,l : Integer);
var
    r : rect;
begin
    GetDotRect(k,l, r);
    SetSolidPenPat(Sprite[k,l]);
    PaintRect(r);
end;

procedure SetDot(k,l : Integer);
var
    r : rect;
begin
    r := WindRect[Actual];

    with r do
    begin
        top := (top * Freshit) + l + 2;
        bottom := top + 1;
        left := (left * Freshit) + k + 2;
        right := left + 1;
    end;
    SetSolidPenPat(Sprite[k,l]);
    PaintRect(r);
end;

function MousedWindow : Integer;
var
    i : integer;
begin
    i := 0;
    repeat
        i := i + 1;
    until PtInRect(Event.eventWhere, WindRect[i]) or (i = TotalWindow);

    MousedWindow := i;
end;
        
procedure RefreshColour;
var
    r : rect;
begin
    SetSolidPenPat(CurrentColour);
    GetPortRect(r);
    PaintRect(r);
    SetSolidBackPat(0);
end;

Procedure RefreshPalete;
var
    r : rect;
    i,j : integer;
begin
    for i := 0 to 7 do
    begin
        for j := 0 to 1 do
        begin
            GetColorRect(i,j, r);
            SetSolidPenPat(i + (j * 8));
            PaintRect(r);
        end;
    end;
end;

procedure RefreshSprite;
var
    r : rect;
    i,j : integer;
begin
    Freshit := 1;
    SetSolidPenPat(0);
    PaintRect(WindRect[Magnified]);
    WaitCursor;
    Current_cursor := Watch_cursor;

    for i := 0 to 49 do
    begin
        for j := 0 to 49 do
        begin
            SetSprite(i,j);
        end;
    end;
    Freshit := 0;
end;

procedure RefreshActual;
var
    r : rect;
    i,j : integer;
begin
    Freshit := 1;
    SetSolidPenPat(0);
    PaintRect(WindRect[Actual]);
    WaitCursor;
    Current_cursor := Watch_cursor;

    for i := 0 to 49 do
    begin
        for j := 0 to 49 do
        begin
            SetDot(i,j);
        end;
    end;
    Freshit := 0;
end;

procedure RefreshMessage;
var
    r : rect;
begin
    SetSolidPenPat(15);
    PaintRect(WindRect[Message]);
end;

procedure Startup_window(WindNum,Minx,Miny,Maxx,Maxy : Integer;
                         Content : Ptr);
var
    r:     Rect;
begin
    Current_window := WindNum;
      
    With WindRect[Current_window] do
    Begin
        Top := Miny;
        Bottom := Maxy;
        Left := Minx;
        Right := Maxx;
    end;

    with Windrecord[Current_window] do begin
      paramLength := sizeof(paramList);
      wFrameBits       := $0020;
      wTitle       := nil;
      wRefCon      := 0;
      wZoom.top    := Miny;
      wZoom.left   := Minx;
      wZoom.bottom := Maxy;
      wZoom.right  := Maxx;
      wColor       := nil;
      wYOrigin     := Miny;
      wXOrigin     := Minx;
      wDataH       := Maxy - Miny - 4;
      wDataW       := Maxx - Minx - 4;
      wMaxH        := Maxy - Miny - 4;
      wMaxW        := Maxx - Minx - 4;
      wScrollVer   := 0;
      wScrollHor   := 0;
      wPageVer     := 0;
      wPageHor     := 0;
      wInfoRefCon  := 0;
      wInfoHeight  := 0;
      wFrameDefProc:= nil;
      wInfoDefProc := nil;
      wContDefProc := Content;
      wPosition.top    := Miny;
      wPosition.left   := Minx;
      wPosition.bottom := Maxy;
      wPosition.right  := Maxx;
      wPlane       := nil;
      wStorage     := nil;
    end;

    Mywindow[Current_window] := NewWindow(Windrecord[Current_window]);
   
    TotalWindow := TotalWindow + 1;
   
    SetPort(Mywindow[Current_window]);
    
    SetSolidPenPat(0);
    PaintRect(WindRect[Current_window]);
end;
{ Set up window record }

procedure NewDItemPtr (theDialog: grafPortPtr; itemID: integer; var itemRect: rect;
                    itemType: integer; itemDescr: univ longint;
                    itemValue, itemFlag: integer; itemColorPtr: colorTblPtr);
tool ($15, $0D);

procedure DoAbout;
var
    aboutDlog: grafPortPtr;
    r:     Rect;
    itemHit:   Integer;
    ic : colorTable;
begin
    with    r do begin
        top := 50; left := 50; bottom := 100; right := 270;
    end;
    aboutDlog :=    NewModalDialog(r,true,0);

    SetPort(aboutDlog);
    with    r do begin
        top := 30; left := 68; bottom := 45; right := 155;
    end;

    NewDItemPtr(aboutDlog,1,r,10,@'Ok',0,0,nil);
    SetDefButton(1,aboutDlog);

    SetForeColor(10);
    SetBackColor(15);
    MoveTo(78,10);  DrawString('SPrEditor');
  
    SetForeColor(13);
    MoveTo(10,22);  DrawString('(C)  1988,  By Peter Easdown.');

   itemHit := ModalDialog(nil);

   CloseDialog(aboutDlog);

end; { of DoAbout }

procedure DoQuit;
var
    quitDlog: grafPortPtr;
    r:     Rect;
    itemHit:   Integer;
    ic : colorTable;
begin
    with    r do begin
        top := 50; left := 50; bottom := 100; right := 270;
    end;
    quitDlog := NewModalDialog(r,true,0);

    SetPort(quitDlog);
    with    r do begin
        top := 30; left := 10; bottom := 0; right := 0;
    end;

    NewDItemPtr(quitDlog,1,r,10,@'Quit',0,0,nil);
    SetDefButton(1,quitDlog);

    with    r do begin
        top := 30; left := 135; bottom := 0; right := 0;
    end;

    NewDItemPtr(quitDlog,2,r,10,@'Cancel',0,0,nil);

    SetForeColor(7);
    SetBackColor(15);
    MoveTo(44,20);  DrawString('Quit, are you sure ?');

    itemHit := ModalDialog(nil);

    CloseDialog(quitDlog);

    If itemHit = 1 then
        Time_to_quit := true;

end; { of DoQuit }

procedure ProcessMenu(MenuWord : Longint);
const
    Applemenu                       = 1;
        AboutItem                   = 300;      {Done}
    
    FileMenu                        = 2;
        ClearEditorItem             = 400;      {Done}
        OpenItem                    = 401;
        SaveAsItem                  = 402;
        QuitItem                    = 403;      {Done}
var
    menuNum:    Integer;
    itemNum:    Integer;
begin
    menuNum := HiWord(MenuWord);
    itemNum := LoWord(MenuWord);
    
    case itemNum of
        AboutItem       :   DoAbout;
        QuitItem        :   DoQuit;
        ClearEditorItem :   ClearSprite;
        OpenItem        :   OpenSprite;
        SaveAsItem      :   SaveSprite;
    end;
    
    HiliteMenu(false,menuNum);
    MDown := False;

end; { of ProcessMenu }

procedure Change_windows;
var
    New_window : grafPortPtr;
    i : Integer;
    r : rect;
    My_window : Boolean;
    
begin
    New_window := FrontWindow;
    i := 1;
    
    while (New_window <> Mywindow[i]) and (i <= TotalWindow) do
    begin
        i := i + 1;
    end;
    
    If (New_window <> Mywindow[Current_window]) and
       (TotalWindow <= TotalWindow)
      then
        Current_window := i;
end;

procedure InitWindows;
begin
    Startup_window(Colour,
                   ColLeft,
                   ColTop,
                   ColRight,
                   ColBottom,
                   @RefreshPalete);
    Startup_window(Magnified,
                   MagLeft - 2,
                   MagTop - 2,
                   MagRight + 2,
                   MagBottom + 2,
                   @RefreshSprite);
    Startup_window(Actual,
                   ActLeft - 2,
                   ActTop - 2,
                   ActRight + 2,
                   ActBottom + 2,
                   @RefreshActual);
    Startup_window(Current,
                   CurLeft,
                   CurTop,
                   CurRight,
                   CurBottom,
                   @RefreshColour);
    Startup_window(Message,
                   MesLeft,
                   MesTop,
                   MesRight,
                   MesBottom,
                   @RefreshMessage);

end;

procedure DoMouseDown;
var
    i,j : integer;
    r : rect;
    found : boolean;
    p : point;
begin
    Current_window := MousedWindow;
    ShowWindow(Mywindow[Current_window]);

    If Current_window = Colour then
    begin
        i := 0;
        Found := false;
        repeat
            j := 0;
            repeat
                GetColorRect(i,j, r);
                If PtInRect(Event.eventwhere,r) then
                begin
                    Found := true;
                end;
                j := j + 1;
            until Found or (j = 2);
            
            i := i + 1;
        until Found or (i = 8);

        If Found then
        begin
            CurrentColour := i + (j * 8);
            SetPort(Mywindow[Current]);
            RefreshColour;
        end;
    end;
    
    If Current_window = Magnified then
    begin
        i := Event.eventwhere.h - MagLeft;
        i := trunc(i / 4);
        j := Event.eventwhere.v - MagTop;
        j := trunc(j / 3);

        Sprite[i,j] := CurrentColour;
        
        SetSprite(i,j);
        SetPort(Mywindow[Actual]);
        SetDot(i,j);
        SetPort(Mywindow[Current_window]);
    end;        
end;

procedure Monitor_tasks;
var
    i,j : Integer;
begin
    while Event_number = Non_event do
    begin
        If MDown then DoMouseDown;
        Event_number := TaskMaster($ffff,Event);
        Check_cursors(Mywindow[Current_window]);
    end;
        
    case Event.eventwhat of
    { Event manager Events }
        ActivateEvt :   ;
        MouseDownEvt    :   MDown := True;
        MouseUpEvt      :   MDown := False;
        keyDownEvt      :   ;
        autoKeyEvt      :   ;
    end;
    
    case Event_number of
    { Task  Master Events }
        wInMenuBar  :   ProcessMenu(Event.TaskData);
    end;
    
    Event_number := Non_event;
end;        

begin
    Startup_tools;
    
    SetUpMenus;

    Event_number := Non_event;
    Event.TaskMask := $1FFF;                { allow TaskMaster to do everything }
    Time_to_quit := false;
    Current_cursor := Arrow_cursor;
    TotalWindow := 0;
    CurrentColour := 0;
    Freshit := 0;

    InitWindows;
    
    ClearSprite;

    Form_cursors;
    
    while not Time_to_quit do begin
    
        Monitor_tasks;
        
    end;
    
    Shutdown_Tools;
end.
