unit WebModuleUnit1;

interface

uses System.SysUtils, System.Classes, Web.HTTPApp, Web.HTTPProd, Data.DB,System.Types,
  Data.Win.ADODB,System.json,antiAttack,messageDigest_5,IdHashSHA, IdSSLOpenSSLHeaders,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,DateUtils,
  IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL,System.RegularExpressions;
const
  accessKey='LFTAPP01_38FC87EA23';

type
  TWebModule1 = class(TWebModule)
    PageProducer1: TPageProducer;
    ADOConnection1: TADOConnection;
    ADOQuery1: TADOQuery;
    ADOQryP: TADOQuery;
    adoqryP2: TADOQuery;
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
    procedure sendsms(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure appreg(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
  private
    procedure addAmobileUser(mobile:string);
    function makeAptopid(mobile:string):TjsonObject;
    { Private declarations }
  public

    { Public declarations }
  end;

var
  WebModuleClass: TComponentClass = TWebModule1;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

function Twebmodule1.makeAptopid(mobile:string):TjsonObject;
var
  js:TjsonObject;
  firsturl,ptopid,nickname,userid,userlevel,usertypeid,usertype,logintimes:string;
begin
  try
    js:=tjsonobject.Create;
    ptopid:=getGuid();
    adoqryP.SQL.Add('select top 1 ab_users.用户号,昵称,内容 as 用户身份,用户类别,用户级别,登录次数 from '+
                    'ab_users,ab_reguser,ab_codeb where (ab_reguser.手机号 = '''+mobile+
                    ''') and (ab_users.用户号=ab_reguser.用户号) and (ab_users.用户类别=ab_codeb.编码) and '+
                    '(ab_codeb.类别号=''61'')');
    adoqryP.Open;
      if adoqryP.RecordCount=0 then begin
        js.AddPair('code','1') ;
        js.AddPair('ptopid','0');
      end else begin
        userid:=adoqryP.FieldByName('用户号').AsString;
        nickname:=adoqryP.FieldByName('昵称').AsString;
        userlevel:=adoqryP.FieldByName('用户级别').AsString;
        usertypeid:=adoqryP.FieldByName('用户类别').AsString;
        usertype:=adoqryP.FieldByName('用户身份').AsString;
        logintimes:=adoqryP.FieldByName('登录次数').AsString;
        adoqryP.Close;
        adoqryP.SQL.Clear;
        adoqryP.SQL.Add('insert into ab_ptop(对话号,用户号,用户类别,用户级别,昵称,IP地址,到期时间) values('''+
                         ptopid+''','''+userid+''','''+usertypeid+''','''+userlevel+''','''+nickname+''','''+request.RemoteAddr+
                         ''','''+datetimetostr(now+0.1)+''')');
        adoqryP.ExecSQL;
         //jsobj.AddPair('code1',adoqryP.SQL.Text);
         adoqryP.sql.Clear;
         adoqryP.SQL.Add('update ab_Users set 最后登录时间='''+datetimetostr(now())+''', 最后登录IP='''+
                         request.RemoteAddr+''',登录次数=登录次数+1  where 用户号='''+userid+'''');
         adoqryP.ExecSQL;
         //jsobj.AddPair('code2',adoqryP.SQL.Text);
         adoqryP.SQL.Clear;
         adoqryP.SQL.Add('select * from ab_sysfun where 模块编号='''+usertypeid+'AP''');
         adoqryP.Open;
         firsturl:=adoqryP.FieldByName('模块指针').AsString;
         firsturl:=stringreplace(firsturl,'#P',ptopid,[]);
         js.AddPair('code','0');
         js.AddPair('ptopid',ptopid);
         js.AddPair('expiration',datetimetostr(now+0.1));
         js.AddPair('userType',usertype);
         js.AddPair('nickName',nickName);
         js.AddPair('userGrade',userLevel);
         js.AddPair('loginTimes',loginTimes);
         js.AddPair('vmoney','1000');
        js.AddPair('myurl',firsturl);
        js.AddPair('errmsg','OK');
      end;
    except on e:exception do
     begin
        js.AddPair('code','3');
        js.AddPair('errmsg',e.Message);
     end
    end;
    result:=js;
end;
procedure TWebModule1.addAmobileUser(mobile:string);
begin
        adoqryP.SQL.Clear;
        adoqryP.SQL.Add('insert into ab_users(用户号,密码,创建时间,用户类别,对应表名) values(''a'+mobile+''','''+''+''','''+datetimetostr(now)+''',''D'',''ab_reguser'')');
        adoqryP.SQL.Add('insert into ab_reguser(用户号,昵称,手机号,注册时间,注册IP) values(''a'+mobile+''',''a'+mobile+''','''+mobile+''','''+datetimetostr(now)+''','''+request.RemoteAddr+''')');
        adoquery1.ExecSQL;
end;


procedure TWebModule1.addaUsr(Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean);
var
  ss:string;
  usrid,pw,nickname,mobile:string;
  jsobj,jsobjo:tjsonObject;
  md5:imd5;
begin
  try
    //response.SetCustomHeader('Content-Type', 'text/html;charset=UTF-8');
    response.SetCustomHeader('Access-Control-Allow-Origin', '*');
    response.SetCustomHeader('Access-Control-Allow-Headers','Origin, X-Requested-With, Content-Type, Accept');
    //response.SetCustomHeader('Access-Control-Allow-Headers','*');
    ss:=utf8encode(request.Content);
    if ss='' then ss:='{"ok":"0"}';
    if antiattak(ss) then exit;
    jsobjo:=TJSONObject.ParseJSONValue(Trim(ss)) as TJSONObject;
    usrid:=jsobjo.GetValue('userid').Value;//.ToJSON;
    pw:=jsobjo.GetValue('passwd1').Value;
    nickname:=jsobjo.GetValue('nickname').Value;
    mobile:=jsobjo.GetValue('mobile').Value;
    MD5 := GetMD5;
    MD5.Init;
    MD5.Update(TByteDynArray(RawByteString(pw)), Length(pw));
    pw:=md5.AsString;
    jsobj:=tjsonobject.Create;
    if mobile<>'' then begin
      adoquery1.SQL.Clear;
      adoquery1.SQL.Add('select 手机号 from ab_regUser where 手机号='''+mobile+'''');
      adoquery1.Open;
      if adoquery1.RecordCount>0  then begin
        jsobj.AddPair('code','2');
        jsobj.AddPair('errmsg','该手机号已经注册!');
        adoquery1.Close;

      end else begin
        adoquery1.SQL.Clear;
        adoquery1.SQL.Add('insert into ab_users(用户号,密码,创建时间,用户类别,对应表名) values('''+usrid+''','''+pw+''','''+datetimetostr(now)+''',''D'',''ab_reguser'')');
        adoquery1.SQL.Add('insert into ab_reguser(用户号,昵称,手机号,注册时间,注册IP) values('''+usrid+''','''+nickname+''','''+mobile+''','''+datetimetostr(now)+''','''+request.RemoteAddr+''')');
        adoquery1.ExecSQL;
        jsobj.AddPair('code','0');
        jsobj.AddPair('errmsg','OK');;//
      end;

    end else begin
        adoquery1.SQL.Clear;
        adoquery1.SQL.Add('insert into ab_users(用户号,密码,创建时间,用户类别,对应表名) values('''+usrid+''','''+pw+''','''+datetimetostr(now)+''',''D'',''ab_reguser'')');
        adoquery1.SQL.Add('insert into ab_reguser(用户号,昵称,手机号,注册时间,注册IP) values('''+usrid+''','''+nickname+''','''+mobile+''','''+datetimetostr(now)+''','''+request.RemoteAddr+''')');
        adoquery1.ExecSQL;
        jsobj.AddPair('code','0');
        jsobj.AddPair('errmsg','OK');;//
    end;//
    response.Content:=jsobj.ToJSON;
  except on e:exception do begin
    jsobj:=tjsonobject.Create;
    jsobj.AddPair('code','1');
    jsobj.AddPair('errmsg',e.Message+mobile);
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
    jsobj.AddPair('username','none');
    response.Content:=jsobj.ToJSON;
    adoquery1.Close;
  except on e:exception do
    response.Content:=e.Message;
  end;

end;

procedure TWebModule1.sendsms(Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean);
const
  pattern='^1[34578](\d{9})$';
  appkey='appkey=1ad520885f2aa08102a39951b593f8ed&';
  tpl_id='120578';
var
  SHA256 : TIdHashSHA256;
  jsobjo,jsback,jsobj,jsobjc:tjsonObject;
  jsArr:TJsonArray;
  phonenum,userkey,reqStr,timestamp,ext,randomNum,sdkappid,params,sig,sign,mobile:string;
  arandom,lasttime:integer;
  jsontosend,ss:tstringStream;
  httpClient:Tidhttp;
  idsslioHsossl1:tidSSLIOHandlerSocketOpenSSL;
  retNo:string;

begin
  try
    //response.SetCustomHeader('Content-Type', 'text/html;charset=UTF-8');
    //response.SetCustomHeader('Access-Control-Allow-Headers','*');
    response.SetCustomHeader('Access-Control-Allow-Origin', '*');
    response.SetCustomHeader('Access-Control-Allow-Headers','Origin, X-Requested-With, Content-Type, Accept');
    reqStr:=utf8encode(request.Content);
    if antiattak(reqstr) then exit;
    jsobjo:=TJSONObject.ParseJSONValue(Trim(reqStr)) as TJSONObject;
    ext:=jsobjo.GetValue('ext').value;
    userkey:=jsobjo.GetValue('userkey').Value;
    timestamp:=jsobjo.GetValue('time').value;
    phonenum:=jsobjo.GetValue('phonenum').value;
    arandom:=round(random()*10000);
    if (arandom<1000) then arandom:=arandom+1000;
    adoquery1.SQL.Clear;
    adoquery1.SQL.Add('select top 1 timer from ab_sendsms where phoneNo='''+phonenum+''' order by sendtime desc');
    adoquery1.Open;
    if adoquery1.RecordCount>0 then begin
      lasttime:=adoquery1.FieldByName('timer').AsInteger;
    end else lasttime:=0;
    adoquery1.Close;
    jsback:=tjsonobject.Create;
    if (strToint(timestamp)-lasttime)>60 then begin
      randomNum:='random='+inttostr(arandom)+'&';
      if (userkey=accessKey) then begin
       if TRegEx.IsMatch(phonenum,pattern)then begin
         IdSSLOpenSSLHeaders.Load();
         SHA256 := TIdHashSHA256.Create;
         mobile:='mobile='+phonenum;
         sig:=appkey+randomNum+'time='+timestamp+'&'+mobile;
         sig:=(LowerCase(SHA256.HashStringAsHex(sig)));  //默认得出的字符串是大写的，这里转换成小写
         SHA256.Free;

         jsobj:=tjsonobject.Create;
         jsarr:=tjsonArray.Create;
         jsobjc:=tjsonobject.Create;
         jsobj.AddPair('ext',ext);
         JSobj.AddPair('extend','');

         jsarr.Add(inttostr(arandom));
         jsobj.AddPair('params',jsarr);
         jsobj.AddPair('sig',sig);
         jsobj.AddPair('sign','');
         jsobjc.AddPair('mobile',phonenum);
         jsobjc.AddPair('nationcode','86');
         jsobj.AddPair('tel',jsobjc);
         jsobj.AddPair('time',timestamp);
         jsobj.AddPair('tpl_id',tpl_id);
         jsonToSend := TStringStream.Create(jsobj.ToString,TEncoding.UTF8);//创建一个包含JSON数据的变量
         jsonToSend.Position := 0;//将流位置置为0
         SS := TStringStream.Create('', TEncoding.UTF8);
         idsslioHsossl1:=tidSSLIOHandlerSocketOpenSSL.Create(nil);
         HttpClient := TIdHttp.Create(nil);
         httpClient.IOHandler:=idsslioHsossl1;
         HTTPclient.HandleRedirects := True;
         httpclient.Request.Accept := 'text/javascript';
         httpclient.Request.ContentType := 'application/json';//设置内容类型为json
         httpclient.Request.ContentEncoding := 'utf-8';
         HttpClient.Post('https://yun.tim.qq.com/v5/tlssmssvr/sendsms?sdkappid=1400090894&random='+intTostr(arandom),jsonTosend,ss);

         jsobjc:=tjsonobject.ParseJSONValue(SS.DataString) as tjsonobject; //处理返回json

         retNo:=jsobjc.Values['result'].Value;//.ToString;

         if (retno='0') then begin
           ;
         end;
         jsback.AddPair('code',retno);
         jsback.AddPair('errmsg',jsobjc.Values['errmsg'].Value);

        end else begin
          retno:='2';
          jsback.AddPair('code',retno);
          jsback.AddPair('errmsg','phone number is bad.');

        end;
       end else begin
         retno:='1';
         jsback.AddPair('code',retno);
         jsback.AddPair('errmsg','accessKey is bad.');
       end;
    end else begin
       retno:='3';
       jsback.AddPair('code',retno);
       jsback.AddPair('errmsg','time offset less 60s.');
       jsback.AddPair('ext',ext);
    end;
      //写记录
       adoquery1.SQL.Clear;
       adoquery1.SQL.Add('insert into ab_sendsms values('''+userkey+''','''+datetimetostr(now)+
                   ''','''+phoneNum+''','''+inttostr(arandom)+''','''+retno+''','+timestamp+')');
       adoquery1.ExecSQL;
       response.Content:=jsback.ToJSON;
  except on e:exception do
    begin
     jsback.AddPair('sysErr',e.Message);
     response.Content:=jsback.ToJSON;
     jsonToSend.free;
     SS.Free;
     HttpClient.Free;
     idsslioHsossl1.Free;
    end;
  end;
end;

procedure TWebModule1.appreg(Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean);
var
  ss,firsturl:string;
  userkey,mobile,usertype,userlevel,nickname,usrid,vcode,ptopid,logintimes,usertypeid:string;
  jsback,jsobjo:tjsonObject;
  md5:imd5;
begin
  try
    response.SetCustomHeader('Access-Control-Allow-Origin', '*');
    response.SetCustomHeader('Access-Control-Allow-Headers','Origin, X-Requested-With, Content-Type, Accept');
    ss:=utf8encode(request.Content);
    if antiattak(ss) then exit;
    jsobjo:=TJSONObject.ParseJSONValue(Trim(ss)) as TJSONObject;
    userkey:=jsobjo.GetValue('userkey').Value;//.ToJSON;
    mobile:=jsobjo.GetValue('mobile').Value;//.ToJSON;
    vcode:=jsobjo.GetValue('vcode').Value;
    jsback:=tjsonobject.Create;
    adoquery1.SQL.Clear;
    adoquery1.SQL.Add('select top 1 * from ab_sendsms where phoneNo = '''+mobile+''' and vcode = '''+vcode+''' order by timer desc');
    adoquery1.Open;
    if (adoquery1.RecordCount=0)or(userkey<>accessKey) then begin
      jsback.AddPair('code','1');
      jsback.AddPair('errmsg','userkey or 验证码不正确。');
    end else begin
      adoquery1.Close;
      adoquery1.SQL.Clear;
      adoquery1.SQL.Add('select * from ab_reguser where 手机号='''+mobile+'''');
      adoquery1.Open;
      if adoquery1.RecordCount=0 then begin
        addAmobileUser(mobile);
      end;
      adoquery1.Close;
      jsback:=makeAptopid(mobile);
    end;

    response.Content:=jsback.ToJSON;

  except on e:exception do begin
     jsback:=tjsonobject.Create;
     jsback.AddPair('code','2');
     jsback.AddPair('errmsg',e.Message);
     response.Content:=jsback.ToJSON;
     end;
  end;
end;

procedure TWebModule1.login(Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean);
var
  ss,firsturl,userTable:string;
  usertype,userlevel,nickname,usrid,pw,ptopid,logintimes,usertypeid:string;
  jsobj,jsobjo:tjsonObject;
  md5:imd5;
begin
  try
    response.SetCustomHeader('Access-Control-Allow-Origin', '*');
    response.SetCustomHeader('Access-Control-Allow-Headers','Origin, X-Requested-With, Content-Type, Accept');
    ss:=utf8encode(request.Content);
    if antiattak(ss) then exit;
    jsobjo:=TJSONObject.ParseJSONValue(Trim(ss)) as TJSONObject;
    usrid:=jsobjo.GetValue('userid').Value;//.ToJSON;
    pw:=jsobjo.GetValue('passwd').Value;
    MD5 := GetMD5;
    MD5.Init;
    MD5.Update(TByteDynArray(RawByteString(pw)), Length(pw));
    pw:=md5.AsString;

    jsobj:=tjsonObject.Create;
    usertable:='ab_reguser';
    adoquery1.SQL.Clear;
    adoquery1.SQL.Add('select 对应表名 from ab_users where 用户号='''+usrid+'''');
    adoquery1.Open;
    if adoquery1.RecordCount>0 then begin
      usertable:=adoquery1.Fields[0].AsString;
      adoquery1.Close;
    end;
    adoquery1.SQL.Clear;
    adoquery1.SQL.Add('select top 1 ab_users.用户号,昵称,内容 as 用户身份,用户类别,用户级别,登录次数 from '+
                    'ab_users,'+userTable+',ab_codeb where ((ab_users.用户号 = '''+usrid+
                    ''')or('+userTable+'.手机号='''+usrid+''')) and (密码 = '''+pw+''') and (ab_users.用户号='+userTable+'.用户号) and (ab_users.用户类别=ab_codeb.编码) and '+
                    '(ab_codeb.类别号=''61'')');

    {adoquery1.SQL.Add('select top 1 ab_users.用户号,昵称,内容 as 用户身份,用户类别,用户级别,登录次数 from '+
                    'ab_users,ab_codeb where (ab_users.用户号 = '''+usrid+
                    ''') and (密码 = '''+pw+''') and (ab_users.用户类别=ab_codeb.编码) and '+
                    '(ab_codeb.类别号=''61'')');}
    adoquery1.Open;
    if adoquery1.RecordCount=0 then begin
      jsobj.AddPair('code','1') ;
      jsobj.AddPair('ptopid','0') ;
    end else begin
      nickname:=adoquery1.FieldByName('昵称').AsString;
      userlevel:=adoquery1.FieldByName('用户级别').AsString;
      usertypeid:=adoquery1.FieldByName('用户类别').AsString;
      usertype:=adoquery1.FieldByName('用户身份').AsString;
      logintimes:=adoquery1.FieldByName('登录次数').AsString;
      ptopid:=getGuid;
      adoquery1.Close;
      adoquery1.SQL.Clear;
      adoquery1.SQL.Add('insert into ab_ptop(对话号,用户号,用户类别,用户级别,昵称,IP地址,到期时间) values('''+
                         ptopid+''','''+usrid+''','''+usertypeid+''','''+userlevel+''','''+nickname+''','''+request.RemoteAddr+
                         ''','''+datetimetostr(now+0.1)+''')');
       adoquery1.ExecSQL;
       //jsobj.AddPair('code1',adoquery1.SQL.Text);
       adoquery1.sql.Clear;
       adoquery1.SQL.Add('update ab_Users set 最后登录时间='''+datetimetostr(now())+''', 最后登录IP='''+
                         request.RemoteAddr+''',登录次数=登录次数+1  where 用户号='''+usrid+'''');
       adoquery1.ExecSQL;
       jsobj.AddPair('code','0');
       //jsobj.AddPair('code2',adoquery1.SQL.Text);
       adoquery1.SQL.Clear;
       adoquery1.SQL.Add('select * from ab_sysfun where 模块编号='''+usertypeid+'01''');
       adoquery1.Open;
       firsturl:=adoquery1.FieldByName('模块指针').AsString;
       firsturl:=stringreplace(firsturl,'#P',ptopid,[]);
       jsobj.AddPair('ptopid',ptopid);
       jsobj.AddPair('expiration',datetimetostr(now+0.1));
       jsobj.AddPair('userType',usertype);
       jsobj.AddPair('nickName',nickName);
       jsobj.AddPair('userGrade',userLevel);
       jsobj.AddPair('loginTimes',loginTimes);
       jsobj.AddPair('vmoney','1000');
       jsobj.AddPair('myurl',firsturl);
    end;
    response.Content:=jsobj.ToJSON;

  except on e:exception do begin
     jsobj:=tjsonobject.Create;
     jsobj.AddPair('code','2');
     jsobj.AddPair('code2',e.Message);
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
