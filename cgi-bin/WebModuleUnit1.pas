unit WebModuleUnit1;

interface

uses System.SysUtils, System.Classes, Web.HTTPApp, Web.HTTPProd, Data.DB,System.Types,
  Data.Win.ADODB,System.json,antiAttack,messageDigest_5;
type
  TWebModule1 = class(TWebModule)
    PageProducer1: TPageProducer;
    ADOConnection1: TADOConnection;
    ADOQuery1: TADOQuery;
    procedure WebModule1DefaultHandlerAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1WebActionItem1Action(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure lookausr(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure addaUsr(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure login(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  WebModuleClass: TComponentClass = TWebModule1;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TWebModule1.addaUsr(Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean);
var
  ss:string;
  usrid,pw,nickname:string;
  jsobj,jsobjo:tjsonObject;
  md5:imd5;
begin
  try
    //response.SetCustomHeader('Content-Type', 'text/html;charset=UTF-8');
    response.SetCustomHeader('Access-Control-Allow-Origin', '*');
    response.SetCustomHeader('Access-Control-Allow-Headers','Origin, X-Requested-With, Content-Type, Accept');
    //response.SetCustomHeader('Access-Control-Allow-Headers','*');
    ss:=utf8encode(request.Content);
    if antiattak(ss) then exit;
    jsobjo:=TJSONObject.ParseJSONValue(Trim(ss)) as TJSONObject;
    usrid:=jsobjo.GetValue('userid').Value;//.ToJSON;
    pw:=jsobjo.GetValue('passwd1').Value;
    nickname:=jsobjo.GetValue('nickname').Value;
    MD5 := GetMD5;
    MD5.Init;
    MD5.Update(TByteDynArray(RawByteString(pw)), Length(pw));
    pw:=md5.AsString;
    jsobj:=tjsonobject.Create;
    adoquery1.SQL.Clear;
    adoquery1.SQL.Add('insert into ab_users(用户号,密码,创建时间,用户类别,对应表名) values('''+usrid+''','''+pw+''','''+datetimetostr(now)+''',''0'',''ab_reguser'')');
    adoquery1.SQL.Add('insert into ab_reguser(用户号,昵称,注册时间,注册IP) values('''+usrid+''','''+nickname+''','''+datetimetostr(now)+''','''+request.RemoteAddr+''')');
    //adoquery1.SQL.Add('insert into ab_users(用户号,密码,创建时间) values('+'''xxx'''+','+'''xxx'''+','''+datetimetostr(now)+''')');
    adoquery1.ExecSQL;

    //jsobj.AddPair('code',adoquery1.SQL.Text);
    jsobj.AddPair('code','0');
    response.Content:=jsobj.ToJSON;
  except on e:exception do begin
    jsobj:=tjsonobject.Create;
    jsobj.AddPair('code','0');
    jsobj.AddPair('code1',e.Message);
    response.Content:=jsobj.ToJSON;
  end;
  end;
end;

procedure TWebModule1.lookausr(Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean);
var
  jsobj:TJsonObject;
  ss:string;
begin
  try
    response.SetCustomHeader('Access-Control-Allow-Origin', '*');
    ss:=request.QueryFields.Values['usrid'];
    if antiattak(ss) then exit;
    adoquery1.SQL.Clear;
    adoquery1.SQL.Add('select * from ab_users where 用户号 ='''+ss+'''');
    adoquery1.Open;
    jsobj:=tjsonObject.Create;
    if adoquery1.RecordCount>0 then
      jsobj.AddPair('code','1')

    else jsobj.AddPair('code','0');
    jsobj.AddPair('username','黄喜民');
    response.Content:=jsobj.ToJSON;
    adoquery1.Close;
  except on e:exception do
    response.Content:=e.Message;
  end;

end;

procedure TWebModule1.login(Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean);
var
  ss:string;
  level,nickname,usrid,pw,ptopid:string;
  jsobj:tjsonObject;
  md5:imd5;
begin
  try
    response.SetCustomHeader('Access-Control-Allow-Origin', '*');
    response.SetCustomHeader('Access-Control-Allow-Headers','Origin, X-Requested-With, Content-Type, Accept');
    ss:=utf8encode(request.Content);
    //if antiattak(ss) then exit;
    jsobj:=TJSONObject.ParseJSONValue(Trim(ss)) as TJSONObject;
    usrid:=jsobj.GetValue('userid').Value;//.ToJSON;
    pw:=jsobj.GetValue('passwd').Value;
    MD5 := GetMD5;
    MD5.Init;
    MD5.Update(TByteDynArray(RawByteString(pw)), Length(pw));
    pw:=md5.AsString;
    jsobj:=tjsonObject.Create;
    adoquery1.SQL.Clear;
    adoquery1.SQL.Add('select top 1 * from ab_users where 用户号 = '''+usrid+''' and 密码 = '''+pw+'''');
    //adoquery1.SQL.Add('select top 1 ab_users.用户号,昵称,用户类别 from ab_users,ab_reguser where (ab_users.用户号 = '''+usrid+
      //              ''') and (密码 = '''+pw+''') and (ab_users.用户号=ab_reguser.用户号)');
    adoquery1.Open;

    if adoquery1.RecordCount=0 then begin
      jsobj.AddPair('code','1') ;
      jsobj.AddPair('code2',adoquery1.SQL.Text) ;
    end else begin
      nickname:=adoquery1.FieldByName('昵称').AsString;
      level:=adoquery1.FieldByName('用户类别').AsString;
      ptopid:=getGuid;
      adoquery1.Close;
      adoquery1.SQL.Clear;
      adoquery1.SQL.Add('insert into ab_ptop(对话号,用户号,权限级别,权限类别,昵称,IP地址,到期时间) values('''+
                         ptopid+''','''+usrid+''','''+'D'+''','''+level+''','''+nickname+''','''+request.RemoteAddr+
                         ''','''+datetimetostr(now+0.1)+''')');
       adoquery1.ExecSQL;
       adoquery1.sql.Clear;
       adoquery1.SQL.Add('update ab_regUser set 最后登录时间='''+datetimetostr(now())+''', 最后登录IP='''+
                         request.RemoteAddr+''',登录次数=1  where 用户号='''+usrid+'''');
       adoquery1.ExecSQL;
       jsobj.AddPair('code','0');
       jsobj.AddPair('ptopid',ptopid);
    end;
    response.Content:=jsobj.ToJSON;

  except on e:exception do begin
     jsobj.AddPair('error',e.Message);
     response.Content:=jsobj.ToJSON;
     end;
  end;

end;

procedure TWebModule1.WebModule1DefaultHandlerAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  Response.Content :=
    '<html>' +
    '<head><title>Web Server Application</title></head>' +
    '<body>暂未实现</body>' +
    '</html>';
  response.SendResponse;
end;

procedure TWebModule1.WebModule1WebActionItem1Action(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  Response.Content :=
    '<html>' +
    '<head><title>Web Server Application</title></head>' +
    '<body>暂未实现</body>' +
    '</html>';
  response.SendResponse;
end;

end.
