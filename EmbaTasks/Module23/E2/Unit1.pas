unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, Vcl.ExtCtrls;

type
  TfmMain = class(TForm)
    pnlTop: TPanel;
    btnStart: TButton;
    lbl1: TLabel;
    edtTimeKeeper: TEdit;
    tmrMain: TTimer;
    procedure btnStartClick(Sender: TObject);
    procedure tmrMainTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

procedure TfmMain.btnStartClick(Sender: TObject);
begin
  tmrMain.Enabled := True;
end;

procedure TfmMain.tmrMainTimer(Sender: TObject);
var
  TimeBefore, TimeAfter : TDateTime;
begin
  TimeBefore := StrToTime(edtTimeKeeper.Text);
  TimeAfter := TimeBefore - (1 / 60 / 60 / 24 );
  edtTimeKeeper.Text := TimeToStr(TimeAfter);
end;

end.
