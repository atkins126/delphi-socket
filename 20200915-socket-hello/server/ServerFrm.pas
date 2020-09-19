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
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
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

var
  Server: TSocket;
{$R *.dfm}

procedure TForm1.ButtonStartClick(Sender: TObject);
var

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
  // ������ǰ��IP�Ͷ˿ں��Ƿ��пͻ�������
  if listen(Server, SOMAXCONN) = SOCKET_ERROR then
  begin
    Memo1.Lines.Add('����ʧ��');
    exit;
  end;
  Memo1.Lines.Add('�����ɹ�');
  // ��ȡ�ͻ������Ӷ���

  // TODO ������ʧ��ʱ������Ҫ���д���
  var
  AddrSize := sizeof(ServerAddr);
  var
  ClientSocket := accept(Server, @ServerAddr, @AddrSize);

  if ClientSocket = INVALID_SOCKET then
  begin
    case ClientSocket of
      WSAEFAULT:
        Memo1.Lines.Add('IP��ȡʧ��')
    end;
    Memo1.Lines.Add('��ȡ����ʧ��');
    exit;
  end;

  // ������result����0ʱ��ʾ�пͻ��˳ɹ����ӵ���ǰ������
  // ���ͻ������ӳɹ�ʱ����ʾһ�¿ͻ��˵�IP
  var
  CustomWinSocket := TCustomWinSocket.Create(ClientSocket);
  Memo1.Lines.Add('�ͻ���IP��' + CustomWinSocket.RemoteAddress);
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // �ر�socket����
  if Server <> INVALID_SOCKET then
  begin
    closesocket(Server);
  end;

  // ����汾����Ϣ
  if WSACleanup = SOCKET_ERROR then
    showmessage('����汾��ʧ��')

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
