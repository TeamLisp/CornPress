unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, SynEdit, Forms, Controls, Graphics, Dialogs,
  ShellCtrls, FileCtrl, ComCtrls, ExtCtrls, StdCtrls, EditBtn, Menus, process;
type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    CheckBox1: TCheckBox;
    Edit1: TEdit;
    Edit2: TEdit;
    GroupBox1: TGroupBox;
    ImageList1: TImageList;
    ListView1: TListView;
    ListView2: TListView;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Splitter1: TSplitter;
    StatusBar1: TStatusBar;
    SynEdit1: TSynEdit;
    procedure Button1Click(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure Edit1EditingDone(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListView1DblClick(Sender: TObject);
    procedure ListView1SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure Listaz;
    function FileSizeFormat(bytes:Double):string;
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
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
  StatusBar1.SimpleText:=' '+IntToStr(c)+' elem';
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


procedure TForm1.MenuItem2Click(Sender: TObject);
begin
  halt;
end;


procedure TForm1.FormCreate(Sender: TObject);
begin
  {$IFDEF UNIX}
    Edit1.Text:='/';
  {$ENDIF}
  {$IFDEF WINDOWS}
    Edit1.Text:='C:\';
  {$ENDIF}
  Listaz;
end;


procedure TForm1.Edit1EditingDone(Sender: TObject);
begin
  Listaz;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  AProcess: TProcess;
  AStringList: TStringList;
begin
   AProcess := TProcess.Create(nil);
   AStringList := TStringList.Create;
   AProcess.CommandLine := Edit2.text;
   AProcess.Options := AProcess.Options + [poWaitOnExit, poUsePipes];
   AProcess.Execute;
   AStringList.LoadFromStream(AProcess.Output);
   SynEdit1.lines:=AStringlist;
   AStringList.Free;
   AProcess.Free;
end;

procedure TForm1.CheckBox1Change(Sender: TObject);
begin
  ListView2.Visible := not CheckBox1.Checked;
  GroupBox1.Visible :=     CheckBox1.Checked;
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
    end;
    if s = '..' then begin
      s := StringReplace(Edit1.Text,per+'..','',[rfReplaceAll]);
      i := s.Length-1;
      while s[i]<>per do dec(i);
      Edit1.Text := copy(s,1,i);
    end;
  end;
end;



procedure TForm1.ListView1SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if ListView1.ItemIndex > 0 then
    StatusBar1.SimpleText:=' '+IntToStr(c)+' elem | '+IntToStr(ListView1.SelCount)+' kijelölt elem'
  else
    StatusBar1.SimpleText:=' '+IntToStr(c)+' elem';
    //Form1.Caption := ListView1.Items.Item[ListView1.ItemIndex].Caption;
end;

end.

