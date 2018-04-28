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
    procedure Szamol;
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
          ImageIndex:=1;
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

procedure TForm1.SpeedButton3Click(Sender: TObject);
var
  i           : Integer;
  iniFile     : TextFile;
  fName, cmd  : String;
  AProcess    : TProcess;
  AStringList : TStringList;
begin
  cmd := '';
  {$IFDEF UNIX}
    fName := 'unix.ini';
  {$ENDIF}
  {$IFDEF WINDOWS}
    fName := 'win.ini';
  {$ENDIF}
  AssignFile(iniFile, fname);
  Reset(iniFile);
  while not EOF(iniFile) do
    ReadLn(iniFile, cmd);
  CloseFile(iniFile);

  for i:=0 to ListView2.Items.Count-1 do
    cmd := cmd + ' "' + ListView2.Items.Item[i].Caption + '"';

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
  ShowMessage(cmd);
  AStringList.Free;
  AProcess.Free;

  ListView2.Clear;
  ListView1.Refresh;
  Listaz;
  Szamol;
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
    if ListView1.Selected.ImageIndex <> 1 then begin
      Edit1.Text := Edit1.Text+s+per;
      Listaz;
    end else
      with ListView2.Items.Add do
        begin
          Caption:=Edit1.Text+s;
          SubItems.Text := ListView1.Selected.SubItems.Text;
          ImageIndex:=1;
          Szamol;
        end;
    if s = '..' then begin
      s := StringReplace(Edit1.Text,per+'..','',[rfReplaceAll]);
      i := s.Length-1;
      while s[i]<>per do dec(i);
      Edit1.Text := copy(s,1,i);
    end;
  end;
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
  end
  else begin
    StatusBar1.Panels.Items[0].Text := ' '+IntToStr(c)+' elem';
    StatusBar1.Panels.Items[1].Text := '';
    SpeedButton1.Enabled:=False;
  end;
end;

end.

