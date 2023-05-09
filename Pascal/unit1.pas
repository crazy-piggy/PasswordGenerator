unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    ButtonOpenFile: TButton;
    ButtonOutputFile: TButton;
    ButtonGen: TButton;
    ButtonExit: TButton;
    OutputFile: TEdit;
    Input: TEdit;
    LabelOutputFile: TLabel;
    LabelInput: TLabel;
    Output: TMemo;
    procedure ButtonExitClick(Sender: TObject);
    procedure ButtonGenClick(Sender: TObject);
    procedure ButtonOpenFileClick(Sender: TObject);
    procedure ButtonOutputFileClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  WriteLn('[Info] Initialization.');
  ButtonExit.SetTextBuf('退出');
  ButtonGen.SetTextBuf('生成');
  ButtonOpenFile.SetTextBuf('打开文件');
  ButtonOutputFile.SetTextBuf('输出到文件');
  Input.SetTextBuf('');
  Form1.SetTextBuf('密码生成器');
  LabelInput.SetTextBuf('密码长度：');
  LabelOutputFile.SetTextBuf('输出文件：');
  Output.Lines.Clear;
  OutputFile.SetTextBuf('');
end;

function GeneratePassword(Length: LongInt): String;
var
  a: Byte;
  i: Integer;
  s: String;
begin
  s:='';
  for i:=1 to Length do
  begin
    a:=random(95)+32;
    s:=s + Chr(a);
  end;
  GeneratePassword:=s;
end;

procedure TForm1.ButtonExitClick(Sender: TObject);
begin
  WriteLn('[Info] Exit.');
  halt;
end;

procedure TForm1.ButtonGenClick(Sender: TObject);
var
  InputLength: LongInt;
begin
  Output.Lines.Clear;
  try
    InputLength:=StrToInt(Input.Text);
  except
    on EConvertError do
    begin
      WriteLn('[ERROR] Empty input of the length of password.');
      Output.Text:='请输入数字！';
      Exit;
    end;
  end;
  Output.Text:=GeneratePassword(InputLength);
end;

procedure TForm1.ButtonOpenFileClick(Sender: TObject);
var
  OpenDialog1:TOpenDialog;
begin
  OpenDialog1:=TOpenDialog.Create(nil);
  try
    if OpenDialog1.Execute then
    begin
      OutputFile.Text:=OpenDialog1.FileName;
    end;
  finally
    OpenDialog1.Free;
  end;
end;

procedure TForm1.ButtonOutputFileClick(Sender: TObject);
var
  f: TextFile;
  InputLength: LongInt;
  s: String;
begin
  try
    begin
      AssignFile(f, OutputFile.Text);
    end;
  except
    on EConvertError do
    begin
      WriteLn('[ERROR] Illegal path of the output file.');
      Output.Text:='请检查输出文件的路径！';
      Exit;
    end;
  end;
  try
    if OutputFile.Text='' then raise Exception.Create('[ERROR] Empty input of output file.');
  except
    on E: Exception do
    begin
      WriteLn(E.Message);
      Output.Text:='请输入输出文件的路径！';
      Exit;
    end;
  end;
  if not FileExists(OutputFile.Text) then
  begin
    WriteLn('[WARN] No such file, now creating file: ' + OutputFile.Text);
    try
      Rewrite(f);
    except
      on E: Exception do
      begin
        WriteLn('[ERROR] Could not create file: ' + OutputFile.Text);
        WriteLn('└────── ' + E.Message);
        Exit;
      end;
    end;
  end;
  try
    InputLength:=StrToInt(Input.Text);
  except
    on EConvertError do
    begin
      WriteLn('[ERROR] Empty input of the length of password.');
      Output.Text:='请输入数字！';
      Exit;
    end;
  end;
  s:=GeneratePassword(InputLength);
  Output.Text:=s;
  Append(f);
  WriteLn(f, s);
  CloseFile(f)
end;

end.

