unit kwRGB2String;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// ���������� "ScriptEngine"
// ������: "kwRGB2String.pas"
// ������ Delphi ���������� (.pas)
// Generated from UML model, root element: ScriptKeyword::Class Shared Delphi Low Level::ScriptEngine::SysUtils::RGB2String
//
// ��������� ������������� R G B � ����������������� ������������� � ���� ������:
// {code}
// 151 40 30 RGB2String .
// {code}
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

{$Include ..\ScriptEngine\seDefine.inc}

interface

{$If not defined(NoScripts)}
uses
  tfwSysUtilsWord,
  tfwScriptingInterfaces
  ;
{$IfEnd} //not NoScripts

{$If not defined(NoScripts)}
type
 TkwRGB2String = {final scriptword} class(TtfwSysUtilsWord)
  {* ��������� ������������� R G B � ����������������� ������������� � ���� ������:
[code]
151 40 30 RGB2String .
[code] }
 protected
 // realized methods
   procedure DoDoIt(const aCtx: TtfwContext); override;
 protected
 // overridden protected methods
   class function GetWordNameForRegister: AnsiString; override;
 end;//TkwRGB2String
{$IfEnd} //not NoScripts

implementation

{$If not defined(NoScripts)}
uses
  Windows,
  Graphics,
  SysUtils,
  l3String,
  l3Base
  ;
{$IfEnd} //not NoScripts

{$If not defined(NoScripts)}

// start class TkwRGB2String

procedure TkwRGB2String.DoDoIt(const aCtx: TtfwContext);
//#UC START# *4DAEEDE10285_503C792001BA_var*
var
 l_SColor : AnsiString;
 l_Color  : TColor;
 l_R, l_G, l_B: Byte;
//#UC END# *4DAEEDE10285_503C792001BA_var*
begin
//#UC START# *4DAEEDE10285_503C792001BA_impl*
 l_B := aCtx.rEngine.PopInt;
 l_G := aCtx.rEngine.PopInt;
 l_R := aCtx.rEngine.PopInt;
 l_Color := TColor(RGB(l_R, l_G, l_B));
 l_SColor := ColorToString(l_Color);
 aCtx.rEngine.PushString(l_SColor);
//#UC END# *4DAEEDE10285_503C792001BA_impl*
end;//TkwRGB2String.DoDoIt

class function TkwRGB2String.GetWordNameForRegister: AnsiString;
 {-}
begin
 Result := 'RGB2String';
end;//TkwRGB2String.GetWordNameForRegister

{$IfEnd} //not NoScripts

initialization
{$If not defined(NoScripts)}
// ����������� RGB2String
 TkwRGB2String.RegisterInEngine;
{$IfEnd} //not NoScripts

end.