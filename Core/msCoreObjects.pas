unit msCoreObjects;

interface

uses
 System.Classes,
 System.Generics.Collections
 ;

type
 TmsLog = class;

 TmsLogLambda = reference to procedure (aLog: TmsLog);

 TmsLog = class
  strict private
   f_FS : TFileStream;
  public
   class procedure Log(const aFileName: String; aLambda: TmsLogLambda);
   constructor Create(const aFileName: String);
   destructor Destroy; override;
   procedure ToLog(const aString: AnsiString);
 end;//TmsLog

 TmsClassInstanceCount = record
  public
   rCount : Integer;
   rMaxCount : Integer;
   constructor Create(aCount: Integer);
   constructor IncCreate(const anOther: TmsClassInstanceCount);
   constructor DecCreate(const anOther: TmsClassInstanceCount);
 end;//TmsClassInstanceCount

 TmsClassInstanceCountList = TDictionary<String, TmsClassInstanceCount>;
 // ms-help://embarcadero.rs_xe7/libraries/System.Generics.Collections.TDictionary.html

 TmsDefferedObjects = class(TList<TObject>)
 // - ������ ���������� ��������
 //   http://programmingmindstream.blogspot.ru/2014/11/blog-post_8.html
 public
  destructor Destroy; override;
 end;//TmsDefferedObjects

 TmsObjectsWatcher = class
  // - �������� �� ���������
  // �� �������� ����������������
 private
  class var f_ObjectsCreatedCount : Integer;
  class var f_ObjectsCreated: TmsClassInstanceCountList;
  class var f_DefferedObjects : TmsDefferedObjects;
 public
  class procedure CreateObject(aClass: TClass; var theInstance: TObject);
  class procedure DestroyObject(anObject: TObject);
  class procedure ObjectCreated(anObject: TObject);
  class procedure ObjectDestroyed(anObject: TObject);
  class destructor Destroy;
 end;//TmsObjectsWatcher

 TmsWatchedObject = class abstract(TObject)
 // - �����, ������� ����� ��������������� ��������/����������� ����� �����������
 public
  class function NewInstance: TObject; override;
  // ms-help://embarcadero.rs_xe7/libraries/System.TObject.NewInstance.html
  procedure FreeInstance; override;
  // ms-help://embarcadero.rs_xe7/libraries/System.TObject.FreeInstance.html
 end;//TmsWatchedObject

 TmsStringList = class abstract(TStringList)
 // - �����, ������� ����� ��������������� ��������/����������� ����� �����������
 public
  class function NewInstance: TObject; override;
  // ms-help://embarcadero.rs_xe7/libraries/System.TObject.NewInstance.html
  procedure FreeInstance; override;
  // ms-help://embarcadero.rs_xe7/libraries/System.TObject.FreeInstance.html
 end;//TmsStringList

 TmsInterfacedNonRefcounted = class abstract(TmsWatchedObject)
  // - ���������� �������� ����������� ����������, �� ��� �������� ������
  //   �.�. ������������� ������ - �� ������������� � "��������" - �� ��������� �������� �����
  //   �����? ����� �������� �����-������.
  //   �� TmsInterfacedNonRefcounted ������ ������������� �������-����������,
  //   ������� ����� �������� ����� "�����" ���� ����������.
  //
  //   ��� ���� ���� �������� - ������-��������� - � ���� ������� ����� ��������
  //   "�������", �� �� ��� ����� - ��������, ����� �����.
 protected
  function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
  function _AddRef: Integer; stdcall;
  function _Release: Integer; stdcall;
 end;//TmsInterfacedNonRefcounted

 TmsInterfacedRefcounted = class abstract(TInterfacedObject)
  // ���������� ��������, ����������� ����������. � ����ר��� ������.
  //
  // �� ����� ������� ����������, ����� ���������� ��� - http://18delphi.blogspot.ru/2013/04/iunknown.html
  // �� � ������ ARC - ���������� ���� "�������� ����������"
  //
  // ���� ��� ���� ��� ��� "��������":
  // - http://18delphi.blogspot.ru/2013/07/blog-post_3683.html
  // - http://18delphi.blogspot.ru/2013/07/1.html
  // - http://18delphi.blogspot.ru/2013/07/2.html
  // - http://18delphi.blogspot.ru/2013/07/2_18.html
  // - http://18delphi.blogspot.ru/2013/07/blog-post_8789.html
 public
  class function NewInstance: TObject; override;
  // ms-help://embarcadero.rs_xe7/libraries/System.TObject.NewInstance.html
  procedure FreeInstance; override;
  // ms-help://embarcadero.rs_xe7/libraries/System.TObject.FreeInstance.html
 end;//TmsInterfacedRefcounted

implementation

uses
 System.SysUtils,
 Math
 ;

// TmsClassInstanceCount

constructor TmsClassInstanceCount.Create(aCount: Integer);
begin
 rCount := aCount;
 rMaxCount := rCount;
end;

constructor TmsClassInstanceCount.IncCreate(const anOther: TmsClassInstanceCount);
begin
 Self := anOther;
 Inc(rCount);
 rMaxCount := Max(anOther.rMaxCount, rCount);
end;

constructor TmsClassInstanceCount.DecCreate(const anOther: TmsClassInstanceCount);
begin
 Self := anOther;
 Dec(rCount);
end;

destructor TmsDefferedObjects.Destroy;
var
 l_Object : TObject;
begin
 for l_Object in Self do
  FreeMem(Pointer(l_Object), l_Object.InstanceSize);
 inherited;
end;

// TmsObjectsWatcher

class procedure TmsObjectsWatcher.CreateObject(aClass: TClass; var theInstance: TObject);
begin
 GetMem(Pointer(theInstance), aClass.InstanceSize);
 // - ������������ ������ ���������� ����. �����?
 //   ����� ������� �� ��������� ���������.
 //   http://programmingmindstream.blogspot.ru/2014/11/blog-post_8.html
 aClass.InitInstance(theInstance);
 ObjectCreated(theInstance);
end;

class procedure TmsObjectsWatcher.DestroyObject(anObject: TObject);
begin
 ObjectDestroyed(anObject);
 anObject.CleanupInstance;
 FreeMem(Pointer(anObject));
end;

class procedure TmsObjectsWatcher.ObjectCreated(anObject: TObject);
var
 l_ClassName : String;
begin
 Inc(f_ObjectsCreatedCount);
 if (f_ObjectsCreated = nil) then
  f_ObjectsCreated := TmsClassInstanceCountList.Create;
 l_ClassName := anObject.ClassName;
 if (not f_ObjectsCreated.ContainsKey(l_ClassName)) then
  f_ObjectsCreated.Add(l_ClassName, TmsClassInstanceCount.Create(1))
 else
  f_ObjectsCreated.Items[l_ClassName] := TmsClassInstanceCount.IncCreate(f_ObjectsCreated.Items[l_ClassName]);
end;

class procedure TmsObjectsWatcher.ObjectDestroyed(anObject: TObject);
var
 l_ClassName : String;
begin
 Assert(f_ObjectsCreatedCount > 0, '�����-�� ������� ��� ���� ����������� ��������� ���');
 if (f_ObjectsCreated <> nil) then
 begin
  l_ClassName := anObject.ClassName;
  if f_ObjectsCreated.ContainsKey(l_ClassName) then
   f_ObjectsCreated.Items[l_ClassName] := TmsClassInstanceCount.DecCreate(f_ObjectsCreated.Items[l_ClassName]);
 end;//f_ObjectsCreated <> nil
 Dec(f_ObjectsCreatedCount);
end;

class procedure TmsLog.Log(const aFileName: String; aLambda: TmsLogLambda);
var
 l_Log : TmsLog;
begin
 l_Log := Create(aFileName);
 try
  aLambda(l_Log);
 finally
  FreeAndNil(l_Log);
 end;//try..finally
end;

constructor TmsLog.Create(const aFileName: String);
begin
 inherited Create;
 f_FS := TFileStream.Create(aFileName, fmCreate);
end;

destructor TmsLog.Destroy;
begin
 FreeAndNil(f_FS);
 inherited;
end;

procedure TmsLog.ToLog(const aString: AnsiString);
const
 cEOL : ANSIString = #13#10;
begin//OutLn
 f_FS.Write(aString[1], Length(aString));
 f_FS.Write(cEOL[1], Length(cEOL));
end;//OutLn

class destructor TmsObjectsWatcher.Destroy;
begin
 if (f_ObjectsCreated <> nil) then
  if (f_ObjectsCreated.Count > 0) then
  begin
   // ����� ������� ���������� �������������� �������� � ���:
   TmsLog.Log(ParamStr(0) + '.objects.log',
    procedure (aLog: TmsLog)
    var
     l_Key : String;
     l_Value : TmsClassInstanceCount;
    begin
     aLog.ToLog('������������� ��������: ' + IntToStr(f_ObjectsCreatedCount));
     for l_Key in f_ObjectsCreated.Keys do
     begin
      l_Value := f_ObjectsCreated[l_Key];
      aLog.ToLog(l_Key + ' �������������: ' + IntToStr(l_Value.rCount) + ' ����������� ������������: ' + IntToStr(l_Value.rMaxCount));
     end;//for l_Key
    end
   );
  end;//f_ObjectsCreated.Count > 0
 FreeAndNil(f_ObjectsCreated);
 FreeAndNil(f_DefferedObjects);
 if (f_ObjectsCreatedCount > 0) then
  raise Exception.Create('�����-�� ������� �� �����������: ' + IntToStr(f_ObjectsCreatedCount));
end;

// TmsWatchedObject

class function TmsWatchedObject.NewInstance: TObject;
begin
 TmsObjectsWatcher.CreateObject(Self, Result);
end;

procedure TmsWatchedObject.FreeInstance;
begin
 TmsObjectsWatcher.DestroyObject(Self);
end;

// TmsStringList

class function TmsStringList.NewInstance: TObject;
begin
 TmsObjectsWatcher.CreateObject(Self, Result);
end;

procedure TmsStringList.FreeInstance;
begin
 TmsObjectsWatcher.DestroyObject(Self);
end;

// TmsInterfacedNonRefcounted

function TmsInterfacedNonRefcounted.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
 Result := E_NoInterface;
end;

function TmsInterfacedNonRefcounted._AddRef: Integer;
begin
 Result := -1;
end;

function TmsInterfacedNonRefcounted._Release: Integer;
begin
 Result := -1;
end;

//TmsInterfacedRefcounted

class function TmsInterfacedRefcounted.NewInstance: TObject;
begin
 TmsObjectsWatcher.CreateObject(Self, Result);
 TmsInterfacedRefcounted(Result).FRefCount := 1;
end;

procedure TmsInterfacedRefcounted.FreeInstance;
begin
 TmsObjectsWatcher.DestroyObject(Self);
end;

end.
