unit ServerFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    ButtonStart: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ButtonStartClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

// ���õĵ�Ԫ
uses Winapi.WinSock2, ScktComp;

{$R *.dfm}

procedure TForm1.ButtonStartClick(Sender: TObject);
var
  Server: TSocket;
  ServerAddr: TSockAddrIn;

begin
  // �����������˶���
  Server := socket(PF_INET, SOCK_STREAM, IPPROTO_IP);
  // �����Ƿ�ɹ�
  if (Server = INVALID_SOCKET) then
  begin
    Memo1.Lines.Add('����������ʧ��');
    exit;
  end;
  Memo1.Lines.Add('�����������ɹ�');

  // ��������ָ��IP�Ͷ˿�
  // ��װ��Ϣ
  with ServerAddr do
  begin

    sin_family := PF_INET;
    // �˿ں�
    sin_port := 8080;
    // ���������п��ܵ�IP��Ϊ�������˵�IP
    // sin_addr.S_addr:=INaddr_any;
    sin_addr.S_addr := inet_addr('127.0.0.1');

  end;
  if bind(Server, TSockAddr(ServerAddr), sizeof(ServerAddr)) = SOCKET_ERROR then
  begin
    Memo1.Lines.Add('�˿ںű�ռ��');
    exit;
  end;
  Memo1.Lines.Add('IP�Ͷ˿ڰ󶨳ɹ�');

end;

{ ��ʼ�� }
procedure TForm1.FormCreate(Sender: TObject);
const
  // �����汾��2.2
  WINSOCKET_VERSION = $0202;
var

  WSAData: TWSAData;

begin

  // ���嵱ǰʹ�������汾
  if WSAStartup(WINSOCKET_VERSION, WSAData) <> 0 then
  begin
    showmessage('��ʼ��ʧ��');
  end;
  Memo1.Lines.Add('������ʼ���ɹ�');
end;

end.
