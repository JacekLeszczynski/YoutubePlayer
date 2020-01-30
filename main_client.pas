unit main_client;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, NetSocket, lNet;

type

  { TFClient }

  TFClient = class(TForm)
    client: TNetSocket;
    procedure clientAccept(aSocket: TLSocket);
    procedure clientConnect(aSocket: TLSocket);
    procedure clientDisconnect(aSocket: TLSocket);
    procedure clientError(const aMsg: string; aSocket: TLSocket);
    procedure clientReceiveString(aMsg: string; aSocket: TLSocket);
    procedure clientStatus(aActive, aCrypt: boolean);
    procedure clientTimeVector(aTimeVector: integer);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  FClient: TFClient;

implementation

{$R *.lfm}

{ TFClient }

procedure TFClient.clientTimeVector(aTimeVector: integer);
begin
  writeln(aTimeVector);
end;

procedure TFClient.FormCreate(Sender: TObject);
begin
  if client.Connect then writeln('Połączono') else writeln('Brak połączenia');
  //client.GetTimeVector;
  client.SendString('Hej!');
end;

procedure TFClient.clientError(const aMsg: string; aSocket: TLSocket);
begin
  writeln('Error: ',aMsg);
end;

procedure TFClient.clientConnect(aSocket: TLSocket);
begin
  writeln('Client: OnConnect!');
end;

procedure TFClient.clientDisconnect(aSocket: TLSocket);
begin
  writeln('Client: OnDisconnect!');
end;

procedure TFClient.clientAccept(aSocket: TLSocket);
begin
  writeln('Client: OnAccept!');
end;

procedure TFClient.clientReceiveString(aMsg: string; aSocket: TLSocket);
begin
  writeln('Client - otrzymano wiadomość: ',aMsg);
end;

procedure TFClient.clientStatus(aActive, aCrypt: boolean);
begin
  writeln('Client-status: ',aActive,' ',aCrypt);
end;

end.

