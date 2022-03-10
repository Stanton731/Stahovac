unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, Process, SysUtils, Forms, Controls, Dialogs, StdCtrls, LCLType,
  LCLIntf, ExtCtrls, unix, Clipbrd, ComCtrls, Buttons, Unit2, Unit3, Unit4, unit5;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button2: TButton;
    CAPTCHA: TCheckBox;
    SaveBall: TImage;
    InfoBall: TImage;
    Label7: TLabel;
    Rychlost: TEdit;
    Image1: TImage;
    Label3: TLabel;
    Label5: TLabel;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    Informace: TStaticText;
    URL: TEdit;
    Folder: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure Button2Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Label7Click(Sender: TObject);
    procedure RychlostChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label5Click(Sender: TObject);
    procedure FolderClick(Sender: TObject);
    procedure URLClick(Sender: TObject);
  private

  public

  end;

const
  BUF_SIZE = 2048; // Buffer size for reading the output in chunks

var
  Form1: TForm1;
  StartProcess     : TProcess;
  CAPTCHAProcess : TProcess;
  URLProcess : TProcess;
  PartsProcess: TProcess;
  SaveProcess: TProcess;
  lastDir: TProcess;
  lastParts: TProcess;
  BytesRead    : longint;
  adresa: string;
  slozka: string;
  casti: string;
  ZobrazSlozku: TStringList;
  ZobrazCasti: TStringList;
  terminal : string;
  Buffer : array[1..4096] of byte;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
 {$IFDEF Linux}
   if FileExists(GetUserDir + '.config/stahovac/lastDir.txt') then
    begin
     ZobrazSlozku := TStringList.Create();
     ZobrazSlozku.LoadFromFile(GetUserDir + '.config/stahovac/lastDir.txt');
     ZobrazSlozku.Delimiter := ' ';
     Folder.Caption := ZobrazSlozku.DelimitedText;
     slozka := ZobrazSlozku.DelimitedText;
    end;
   if FileExists(GetUserDir + '.config/stahovac/lastParts.txt') then
    begin
     ZobrazCasti := TStringList.Create();
     ZobrazCasti.LoadFromFile(GetUserDir + '.config/stahovac/lastParts.txt');
     ZobrazCasti.Delimiter := ' ';
     Rychlost.Caption := ZobrazCasti.DelimitedText;
     casti := ZobrazCasti.DelimitedText;
    end;
 {$ENDIF Linux}
end;

procedure TForm1.URLClick(Sender: TObject);
begin
  URL.Caption := Clipboard.AsText;
  adresa := URL.Caption;
end;

procedure TForm1.RychlostChange(Sender: TObject);
begin
  casti := Rychlost.Caption;
end;

procedure TForm1.Label5Click(Sender: TObject);
begin
  Form4.ShowModal;
end;

procedure TForm1.FolderClick(Sender: TObject);
begin
   if SelectDirectoryDialog1.Execute then
     Folder.Caption := SelectDirectoryDialog1.FileName + PathDelim;
     slozka := SelectDirectoryDialog1.FileName + PathDelim;
end;
procedure TForm1.Button2Click(Sender: TObject);
begin
  Button2.Enabled:= False;
  InfoBall.Visible := False;
  SaveBall.Visible := True;
  Informace.Caption := 'Váš soubor se stahuje...' + sLineBreak + 'Vyčkejte do zavření konzolového okna.';

  StartProcess:=TProcess.Create(nil);
  SaveProcess:=TProcess.Create(nil);
  CAPTCHAProcess:=TProcess.Create(nil);
  URLProcess:=TProcess.Create(nil);
  PartsProcess:=TProcess.Create(nil);
  lastDir:=TProcess.Create(nil);
  lastParts:=TProcess.Create(nil);

  {$IFDEF Windows}
  begin
    if not FileExists(GetUserDir + 'AppData\Roaming\Stahovac\dontshow.txt') then
       begin
         Form5.ShowModal;
    end;
     if CAPTCHA.Checked = True then
      begin
          CAPTCHAProcess.CommandLine := 'c:\windows\system32\cmd.exe /c "echo set captcha=--auto-captcha > %AppData%\Stahovac\captcha.bat"';
      end
     else if CAPTCHA.Checked = False then
      begin
       CAPTCHAProcess.CommandLine := 'c:\windows\system32\cmd.exe /c "echo set captcha= > %AppData%\Stahovac\captcha.bat"';
      end
  end;
    SaveProcess.CommandLine := 'c:\windows\system32\cmd.exe /c "echo set dir=' + slozka + ' > %AppData%\Stahovac\directory.bat"';
    lastDir.CommandLine := 'c:\windows\system32\cmd.exe /c "echo ' + slozka + ' > %AppData%\Stahovac\lastDir.txt"';
    URLProcess.CommandLine := 'c:\windows\system32\cmd.exe /c "echo set url=' + adresa + ' > %AppData%\Stahovac\url.bat"';
    PartsProcess.CommandLine := 'c:\windows\system32\cmd.exe /c "echo set parts=' + casti + ' > %AppData%\Stahovac\parts.bat"';
    lastParts.CommandLine := 'c:\windows\system32\cmd.exe /c "echo ' + casti + ' > %AppData%\Stahovac\lastParts.txt"';
    StartProcess.CommandLine := 'c:\windows\system32\cmd.exe /c "%AppData%\Stahovac\call-python.bat"';

  {$ENDIF Windows}

  {$IFDEF Unix}
    {$IFDEF Linux}
    begin
    if FileExists('/usr/bin/konsole') then
      terminal:='konsole'
    else if FileExists('/usr/bin/gnome-terminal') then
      terminal:='gnome-terminal'
    else if FileExists('/usr/bin/xfce4-terminal') then
      terminal:='xfce-terminal'
    else if FileExists('/usr/bin/mate-terminal') then
      terminal:='mate-terminal'
    else if FileExists('/usr/bin/lxterminal') then
      terminal:='lxterminal'
    else
      terminal:='xterm'
    end;
    begin
     if CAPTCHA.Checked = True then
      begin
          CAPTCHAProcess.CommandLine := terminal + ' -e /bin/bash -l -c "echo "captcha=--auto-captcha" > ~/.config/stahovac/captcha.txt"';
      end
     else if CAPTCHA.Checked = False then
      begin
       CAPTCHAProcess.CommandLine := terminal + ' -e /bin/bash -l -c "echo "captcha=" > ~/.config/stahovac/captcha.txt"';
      end
    end;
    SaveProcess.CommandLine := terminal + ' -e /bin/bash -l -c "echo "dir=' + slozka + '" > ~/.config/stahovac/directory.txt"';
    lastDir.CommandLine := terminal + ' -e /bin/bash -l -c "echo "' + slozka + '" > ~/.config/stahovac/lastDir.txt"';
    URLProcess.CommandLine := terminal + ' -e /bin/bash -l -c "echo "url=' + adresa + '" > ~/.config/stahovac/url.txt"';
    PartsProcess.CommandLine := terminal + ' -e /bin/bash -l -c "echo "parts=' + casti + '" > ~/.config/stahovac/parts.txt"';
    lastParts.CommandLine := terminal + ' -e /bin/bash -l -c "echo "' + casti + '" > ~/.config/stahovac/lastParts.txt"';
    StartProcess.CommandLine := terminal + ' -e /bin/bash -l -c "~/.config/stahovac/call-python.sh"';
    {$ENDIF Linux}

    //AProcess.Parameters.Add('-l');
  {$ENDIF Unix}
    lastDir.Execute;
    lastParts.Execute;
    CAPTCHAProcess.Execute;
    SaveProcess.Execute;
    PartsProcess.Execute;
    URLProcess.Execute;
    StartProcess.Execute;
    StartProcess.Free;
end;

procedure TForm1.Image1Click(Sender: TObject);
begin
  Form3.ShowModal;
end;

procedure TForm1.Label7Click(Sender: TObject);
begin
   Form2.ShowModal;
end;

end.
