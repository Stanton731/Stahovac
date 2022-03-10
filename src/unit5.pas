unit Unit5;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Process, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, LCLIntf;

type

  { TForm5 }

  TForm5 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    CheckBox1: TCheckBox;
    Image1: TImage;
    StaticText1: TStaticText;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private

  public

  end;

var
  Form5: TForm5;
  DontShow: TProcess;

implementation

{$R *.lfm}

{ TForm5 }

procedure TForm5.Button1Click(Sender: TObject);
begin
   OpenURL('http://vzum.hys.cz/');
end;

procedure TForm5.Button2Click(Sender: TObject);
begin
  if CheckBox1.Checked = True then
  begin
    DontShow:=TProcess.Create(nil);
    DontShow.CommandLine := 'c:\windows\system32\cmd.exe /c "echo. 2>%AppData%\Stahovac\dontshow.txt"';
    DontShow.Execute;
    Form5.Close;
  end
  else
  begin
    Form5.Close;
  end;

end;

end.

