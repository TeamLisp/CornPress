unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, SynEdit, Forms, Controls, Graphics, Dialogs,
  ShellCtrls, FileCtrl, ComCtrls, ExtCtrls, StdCtrls, EditBtn, Menus, Buttons,
  ComboEx, ActnList, process;
type

  { TForm1 }

  TForm1 = class(TForm)
    ComboBoxEx1: TComboBoxEx;
    Edit1: TEdit;
    ImageList1: TImageList;
    ImageList2: TImageList;
    ListView1: TListView;
    ListView2: TListView;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    ShellTreeView1: TShellTreeView;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    Splitter1: TSplitter;
    StatusBar1: TStatusBar;
    StatusBar2: TStatusBar;
    procedure ComboBoxEx1Change(Sender: TObject);
    procedure Edit1EditingDone(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListView1DblClick(Sender: TObject);
    procedure ListView1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ListView1SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure Listaz;
    procedure ListView2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem11Click(Sender: TObject);
    procedure MenuItem12Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure Szamol;
    procedure funkcio(funkc: Integer);
    function FileSizeFormat(bytes:Double):string;
    procedure ListView2DblClick(Sender: TObject);
    procedure ListView2SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure MenuItem2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    c: Integer;
  public

  end;

const
{$IFDEF UNIX}
  per: String = '/';
{$ENDIF}
{$IFDEF WINDOWS}
  per: String = '\';
{$ENDIF}

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Listaz;
var
  SR: TSearchRec;
  SA: TStringArray;
begin
  ListView1.Clear;
  c := 0;
  if FindFirst(Edit1.Text+'*', faDirectory, SR) = 0 then
  begin
    repeat
      if (SR.Attr and faDirectory) = faDirectory then
      if SR.Name<>'.' then begin
        with ListView1.Items.Add do
        begin
          Caption:=SR.Name;
          inc(c);
          if SR.Name<>'..' then
            ImageIndex:=0
          else
            ImageIndex:=2;
        end;
      end;
    until FindNext(SR)<>0;
    FindClose(SR);
  end;
  if FindFirst(Edit1.Text+'*', faArchive, SR) = 0 then
  begin
    repeat
      if SR.Name<>'.' then begin
        with ListView1.Items.Add do
        begin
          Caption:=SR.Name;
          inc(c);
          SubItems.Text:=FileSizeFormat(SR.Size)+#13+FormatDateTime('yyyy mm dd hh:mm:ss',fileDateToDateTime(SR.Time));
          SA := Caption.Split('.');
          ImageIndex:=1;
          if Length(SA)>1 then begin
            if SA[Length(SA)-1] = 'zstd' then ImageIndex:=3;
            if SA[Length(SA)-1] = 'cp'   then ImageIndex:=4;
          end;
        end;
      end;
    until FindNext(SR)<>0;
    FindClose(SR);
  end;
  StatusBar1.Panels.Items[0].Text:=' '+IntToStr(c)+' elem';
end;

procedure TForm1.ListView2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key.ToString = '13') or (Key.ToString = '37') or (Key.ToString = '46') or (Key.ToString = '32') then
    SpeedButton2Click(Sender);
end;

procedure TForm1.MenuItem10Click(Sender: TObject);
begin
  ShowMessage('Majd valaki fogalmazzon meg ide egy jó kis szöveget...');
end;

procedure TForm1.MenuItem11Click(Sender: TObject);
begin
  ListView2.Column[1].Visible := not ListView2.Column[1].Visible;
end;

procedure TForm1.MenuItem12Click(Sender: TObject);
begin
  ListView2.Column[2].Visible := not ListView2.Column[2].Visible;
end;

procedure TForm1.MenuItem4Click(Sender: TObject);
begin
  ComboBoxEx1.ItemIndex:=0;
  ComboBoxEx1Change(Sender);
  Listaz;
  ListView2.Clear;
  Szamol;
end;

procedure TForm1.MenuItem6Click(Sender: TObject);
begin
  ListView1.Column[0].Visible := not ListView1.Column[0].Visible;
end;

procedure TForm1.MenuItem7Click(Sender: TObject);
begin
  ListView1.Column[1].Visible := not ListView1.Column[1].Visible;
end;

procedure TForm1.MenuItem8Click(Sender: TObject);
begin
  ListView1.Column[2].Visible := not ListView1.Column[2].Visible;
end;

procedure TForm1.funkcio(funkc: Integer);
var
  i           : Integer;
  iniFile     : TextFile;
  fName, cmd  : String;
  line        : String;
  AProcess    : TProcess;
  AStringList : TStringList;
  SA          : TStringArray;
begin
  cmd := '';
  {$IFDEF UNIX}
    fName := 'unix.ini';
  {$ENDIF}
  {$IFDEF WINDOWS}
    fName := 'win.ini';
  {$ENDIF}
  AssignFile(iniFile, fName);
  Reset(iniFile);
  while not EOF(iniFile) do
  begin
    ReadLn(iniFile, line);
    SA := line.Split(';');
    if Length(SA) > 1 then
      if SA[0].IndexOf('#') < 0 then
        if StrToInt(SA[0]) = funkc then
        cmd := SA[1];
  end;
  CloseFile(iniFile);

  case funkc of
    0     : for i:=0 to ListView2.Items.Count-1 do
              cmd := cmd + ' "' + ListView2.Items.Item[i].Caption + '"';
    1,2,3 : cmd := cmd + ' "' + ListView1.Items.Item[ListView1.ItemIndex].Caption + '"';
  end;

  ShowMessage(cmd);

  AProcess             := TProcess.Create(nil);
  AStringList          := TStringList.Create;
  AProcess.CommandLine := cmd;
  AProcess.Options     := AProcess.Options + [poWaitOnExit, poUsePipes];
  AProcess.Execute;
  AStringList.LoadFromStream(AProcess.Output);
  //SynEdit1.lines       := AStringlist;
  cmd := '';
  for i:= 0 to AStringList.Count-1 do cmd := cmd + AStringList[i] + #13;
  if cmd <> '' then
    ShowMessage(cmd)
  else
      ShowMessage(
        'Nem indult el az algoritmus, vagy az algoritmus nem adott vissza üzenetet.'+#13#10#13#10+
        'Ellenőrizd:'+#13#10+
        ' - van-e Python telepítve a gépedre'+#13#10+
        ' - van-e a Python-hoz ZSTD könyvtár telepítve'+#13#10+
        {$IFDEF WINDOWS}
        ' - benne van-e a Python elérési útja a környezeti változók között'+#13#10+
        ' - megfelelő-e a win.ini file beállítása'+
        {$ENDIF}
        {$IFDEF UNIX}
        ' - megfelelő-e a unix.ini file beállítása'+
        {$ENDIF}
        ''
      );
  AStringList.Free;
  AProcess.Free;

  ListView2.Clear;
  ListView1.Refresh;
  Listaz;
  Szamol;
end;


procedure TForm1.SpeedButton3Click(Sender: TObject);
begin
  funkcio(0);
end;

procedure TForm1.SpeedButton4Click(Sender: TObject);
begin
  funkcio(2);
  SpeedButton4.Enabled := False;
end;

function TForm1.FileSizeFormat(bytes:Double):string;
begin
  if bytes < 1024 then
    Result:=floattostr(bytes) + ' B'
  else if (bytes >= 1024) and (bytes < 1024*1024) then
    Result:=FormatFloat('0.00', bytes/1024)+' KB'
  else if (bytes >= 1024*1024) and (bytes < 1024*1024*1024) then
    Result:=FormatFloat('0.00', bytes/1024/1024)+' MB'
  else if (bytes >= 1024*1024*1024) and (bytes < 1024*1024*1024*1024) then
    Result:=FormatFloat('0.00', bytes/1024/1024/1024)+' GB'
  else
    Result:=FormatFloat('0.00', bytes/1024/1024/1024/1024)+' TB';
end;

procedure TForm1.Szamol;
var
  i  : Integer;
  s,t: String;
  d,e: Double;
begin
  StatusBar2.Panels[0].Text:=' '+IntToStr(ListView2.Items.Count)+' elem';
  e := 0;
  for i := 0 to ListView2.Items.Count-1 do begin
    s := ListView2.Items.Item[i].SubItems.Text.Split({$IfDef UNIX}#10{$Else}#13{$EndIf})[0];
    t := s.Split(' ')[1];
    d := StrToFloat(s.Split(' ')[0]);
    if t = 'B'  then e := e + d;
    if t = 'KB' then e := e + d*1024;
    if t = 'MB' then e := e + d*1024*1024;
    if t = 'GB' then e := e + d*1024*1024*1024;
    if t = 'TB' then e := e + d*1024*1024*1024*1024;
  end;
  StatusBar2.Panels[1].Text:=' '+FileSizeFormat(e);

  if ListView2.Items.Count > 0 then
    SpeedButton3.Enabled := True
  else
    SpeedButton3.Enabled := False;
end;

procedure TForm1.ListView2DblClick(Sender: TObject);
begin
  if ListView2.ItemIndex > -1 then
  begin
    ListView2.Items.Delete(ListView2.ItemIndex);
  end;
end;

procedure TForm1.ListView2SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if ListView2.ItemIndex >= 0 then
    SpeedButton2.Enabled := True
  else
    SpeedButton2.Enabled := False;
end;


procedure TForm1.MenuItem2Click(Sender: TObject);
begin
  halt;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
var i: Integer;
begin
  for i := 0 to ListView1.Items.Count -1 do
    if ListView1.Items.Item[i].Selected then
      if ListView1.Items.Item[i].ImageIndex = 1 then
        with ListView2.Items.Add do begin
          Caption       := Edit1.Text+ListView1.Items[i].Caption;
          SubItems.Text := ListView1.Items[i].SubItems.Text;
          ImageIndex:=1;
        end;
  ListView1.ClearSelection;
  Szamol;
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
var i: Integer;
begin
  for i:=ListView2.Items.Count-1 downto 0 do
    if ListView2.Items.Item[i].Selected then
      ListView2.Items.Delete(i);
  ListView2.ClearSelection;
  Szamol;
end;


procedure TForm1.FormCreate(Sender: TObject);
var i: Integer;
begin
  for i:=0 to ShellTreeView1.Items.Count-1 do
    ComboBoxEx1.ItemsEx.AddItem(ShellTreeView1.Items.Item[i].Text,0);
  ComboBoxEx1.ItemIndex:=0;
  //Edit1.Text:=ComboBoxEx1.ItemsEx.Items[0].Caption+per;
  ComboBoxEx1Change(Sender);
  Listaz;
end;


procedure TForm1.Edit1EditingDone(Sender: TObject);
begin
  Listaz;
end;

procedure TForm1.ComboBoxEx1Change(Sender: TObject);
begin
  {$IFDEF UNIX}
    Edit1.Text:='/';
    if ComboBoxEx1.ItemsEx.Items[ComboBoxEx1.ItemIndex].Caption<>'/' then
      Edit1.Text:='/'+ComboBoxEx1.ItemsEx.Items[ComboBoxEx1.ItemIndex].Caption+per;
  {$ENDIF}
  {$IFDEF WINDOWS}
    Edit1.Text:=ComboBoxEx1.ItemsEx.Items[ComboBoxEx1.ItemIndex].Caption+per;
  {$ENDIF}
  Listaz;
end;


procedure TForm1.ListView1DblClick(Sender: TObject);
var
  i: Integer;
  s: String;
begin
  if ListView1.ItemIndex > -1 then begin
    s := ListView1.Selected.Caption;
    case ListView1.Selected.ImageIndex of
      0,2: begin
             Edit1.Text := Edit1.Text+s+per;
             Listaz;
           end;
      1  : with ListView2.Items.Add do
             begin
               Caption:=Edit1.Text+s;
               SubItems.Text := ListView1.Selected.SubItems.Text;
               ImageIndex:=1;
               Szamol;
             end;
      3  : case QuestionDlg ('CornPress','Valóban ki akarod csomagolni ezt az állományt? '+#10#13#10#13+s,mtCustom,[mrNo, 'Nem', mrYes,'Igen', 'IsDefault'],'') of
             mrYes: begin
                      funkcio(1);
                      //QuestionDlg ('CornPress','Kész!',mtCustom,[mrOK,'OK'],'');
                    end;
           end;
      4  : case QuestionDlg ('CornPress','Valóban vissza akarod alakítani ezt a csodálatos állományt zstd-re? '+#10#13#10#13+s,mtCustom,[mrNo, 'Nem', mrYes,'Hát hogy a francba ne!', 'IsDefault'],'') of
             mrYes: begin
                      funkcio(3);
                      //QuestionDlg ('CornPress','Kész!',mtCustom,[mrOK,'OK'],'');
                    end;
           end;
    end;

    if s = '..' then begin
      s := StringReplace(Edit1.Text,per+'..','',[rfReplaceAll]);
      i := s.Length-1;
      while s[i]<>per do dec(i);
      Edit1.Text := copy(s,1,i);
    end;
  end;
  SpeedButton4.Enabled := False;
end;

procedure TForm1.ListView1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key.ToString = '13') or (Key.ToString = '39') or (Key.ToString = '32') then
    SpeedButton1Click(Sender);
end;



procedure TForm1.ListView1SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if ListView1.ItemIndex >= 0 then begin
    StatusBar1.Panels.Items[0].Text := ' '+IntToStr(c)+' elem';
    StatusBar1.Panels.Items[1].Text := ' '+IntToStr(ListView1.SelCount)+' kijelölt elem';
    SpeedButton1.Enabled:=True;
    if (ListView1.SelCount = 1) and (ListView1.Selected.ImageIndex = 3) then
      SpeedButton4.Enabled := True
    else
      SpeedButton4.Enabled := False;
  end
  else begin
    StatusBar1.Panels.Items[0].Text := ' '+IntToStr(c)+' elem';
    StatusBar1.Panels.Items[1].Text := '';
    SpeedButton1.Enabled:=False;
  end;
//  if ListView1.i;
end;

end.

