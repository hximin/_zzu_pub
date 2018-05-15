unit antiAttack;


interface
  uses System.Classes,system.json,System.SysUtils,Web.HTTPApp;

  function antiAttak(querystr:string):boolean;
  function isLegalIp(request:TwebRequest):boolean;
  function GetGUID: string;

implementation

function isLegalIp(request:TwebRequest):boolean;
  var
    legalIp:string;
  begin
    legalIp:='';
    if pos(request.remoteAddr,legalIp)>0 then result:=true
    else result:=true;
  end;
function GetGUID: string;
  var
    vGUID: TGUID;
    vTemp:string;
begin
  if S_OK = CreateGuid(vGUID) then
    begin
    vTemp := GUIDToString(vGUID);
    //ȥ���ַ����е�{,-�ַ�
    vTemp:=StringReplace(vTemp,'-','',[rfReplaceAll]);
    vTemp:=StringReplace(vTemp,'{','',[rfReplaceAll]);
    vTemp:=StringReplace(vTemp,'}','',[rfReplaceAll]);
    end;
  Result:=uppercase(vTemp);
end;


function antiAttak(queryStr:string):boolean;
var
  i:integer;
  qStr:string;
  antiStrings:string;
  antiS:tStringlist;

function split(s,s1:string):TStringList;
begin
  Result:=TStringList.Create;
  while Pos(s1,s)>0 do
    begin
      Result.Add(Copy(s,1,Pos(s1,s)-1));
      Delete(s,1,Pos(s1,s));
    end;
  Result.Add(s);
end;

begin
  if queryStr='' then begin
    result:=true;
    exit;
  end;


  antiStrings:='SELECT|UPDATE|INSERT|FROM|EXEC|MASTER|CREATE|DROP|TABLE|OR|AND|DELETE|IF|NULL|UNION|WHERE|HAVING|>|%|=|<|)';
  qstr:=Uppercase(queryStr);
  antis:=tStringlist.Create;
  antis:=split(antistrings,'|');
  i:=0;
  while i<antis.Count do begin
   if pos(antis[i],qstr)>0 then begin
     result:=true;
     exit;
   end;
   inc(i);
  end;
  result:=false;
end;
end.
