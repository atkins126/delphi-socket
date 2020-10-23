program ApplicationConsole;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  WinAPI.windows, System.SysUtils;

type
  // ������һ������
  TPackageProcedure = procedure(Num1, Num2: Integer); stdcall;

var
  Handle: HMODULE;

var
  // ����һ���͵��õ��Ǹ������Ĳ�������ֵһ�µı���
  ShowMsg: function(Content: String): String; stdcall;
  PackageAdd: TPackageProcedure;

begin
  try
    try
      // ����Package
      Handle := LoadPackage('PackageDynamic.bpl');

      @ShowMsg := GetProcAddress(Handle, 'ShowMessage');
      // У�麯���Ƿ���ҳɹ�
      if @ShowMsg <> nil then
        Writeln(ShowMsg('Package�Ķ�̬����'));

      @PackageAdd := GetProcAddress(Handle, 'Add');
      // У�麯���Ƿ���ҳɹ�
      if @PackageAdd <> nil then
        PackageAdd(10, 20);
    except
      on E: Exception do
        Writeln(E.ClassName, ': ', E.Message);
    end;

  finally
    // ж��Package
    if Handle <> 0 then
      UnLoadPackage(Handle);

  end;

  readln;

end.
