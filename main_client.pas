unit main_client;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, NetSocket, lNet;

type

  { TFClient }

  TFClient = class(TForm)
    tcp: TNetSocket;
    procedure FormCreate(Sender: TObject);
    procedure tcpReceiveString(aMsg: string; aSocket: TLSocket);
    procedure tcpTimeVector(aTimeVector: integer);
  private

  public

  end;

var
  FClient: TFClient;

implementation

uses
  serwis;

{$R *.lfm}

{ TFClient }

procedure TFClient.FormCreate(Sender: TObject);
begin
  tcp.Connect;
  application.ProcessMessages;
  tcp.GetTimeVector;
end;

procedure TFClient.tcpReceiveString(aMsg: string; aSocket: TLSocket);
begin
  writeln('Message: ',aMsg);
end;

procedure TFClient.tcpTimeVector(aTimeVector: integer);
begin
  writeln('Wektor czasu = ',aTimeVector);
end;

end.

