unit DelayDM;

interface

uses 
  Windows, Messages, SysUtils, Classes, Forms, 
  DAVDCommon, DVSTModule;

type
  TDelayDataModule = class(TVSTModule)
    procedure VSTModuleEditOpen(Sender: TObject; var GUI: TForm; ParentWindow: Cardinal);
    procedure VSTModuleCreate(Sender: TObject);
    procedure VSTModuleProcess(const Inputs,
      Outputs: TAVDArrayOfSingleDynArray; const SampleFrames: Integer);
    procedure DelayDataModuleParameterProperties0ParameterChange(
      Sender: TObject; const Index: Integer; var Value: Single);
  private
    fBuffer     : array[0..1] of TAVDSingleDynArray;
    fBufferSize : Integer;
    fBufferPos  : Integer;
  public
  end;

implementation

{$R *.DFM}

uses
  DelayUI;

procedure TDelayDataModule.VSTModuleEditOpen(Sender: TObject; var GUI: TForm; ParentWindow: Cardinal);
begin
  GUI := TArvinDelayUI.Create(Self);
end;

procedure TDelayDataModule.VSTModuleCreate(Sender: TObject);
begin
  Parameter[0]:=441;
  fBufferPos:=0;
end;

procedure TDelayDataModule.VSTModuleProcess(const Inputs,
  Outputs: TAVDArrayOfSingleDynArray; const SampleFrames: Integer);
  var j : Integer;
begin
  for j:=0 to sampleframes-1 do
  begin
   outputs[0,j]:=inputs[0,j]+fBuffer[0,fBufferPos];
   outputs[1,j]:=inputs[1,j]+fBuffer[1,fBufferPos];
   fBuffer[0,fBufferPos]:=inputs[0,j];
   fBuffer[1,fBufferPos]:=inputs[1,j];
   Inc(fBufferPos);
   if fBufferPos>=fBufferSize
    then fBufferPos:=0;
   end;
end;

procedure TDelayDataModule.DelayDataModuleParameterProperties0ParameterChange(
  Sender: TObject; const Index: Integer; var Value: Single);
begin
fBufferSize:=round(Value);
 SetLength(fBuffer[0],fBufferSize);
 SetLength(fBuffer[1],fBufferSize);
 if fBufferPos>=fBufferSize
  then fBufferPos:=0;
end;

end.
