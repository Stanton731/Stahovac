unit Unit4;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, lclintf;

type

  { TForm4 }

  TForm4 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Edit1: TEdit;
    Image1: TImage;
    Label1: TLabel;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
  private

  public

  end;

var
  Form4: TForm4;
  Fast: Integer;

implementation

{$R *.lfm}

{ TForm4 }

procedure TForm4.Button2Click(Sender: TObject);
begin
   Button3.Enabled := True;
   Label1.Enabled := False;
   Label1.Caption := ('Zjištěný nejvyšší efektivní počet částí: ');
   Fast := 0;
   Form4.Close;
end;

procedure TForm4.Button3Click(Sender: TObject);
begin
   Button3.Enabled := False;
   Label1.Enabled := True;
   Fast := (Fast * 1000) div 300;
   Label1.Caption := ('Zjištěný nejvyšší efektivní počet částí: ')+ IntToStr(Fast);
end;

procedure TForm4.Edit1Change(Sender: TObject);
begin
  Fast := StrToInt(Edit1.Caption);
end;

procedure TForm4.Button1Click(Sender: TObject);
begin
  OpenURL('https://speedtest.cesnet.cz/');
end;

end.

