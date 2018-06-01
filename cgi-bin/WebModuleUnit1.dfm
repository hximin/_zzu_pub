object WebModule1: TWebModule1
  OldCreateOrder = False
  Actions = <
    item
      Name = 'DefaultHandler'
      PathInfo = '/'
      OnAction = WebModule1DefaultHandlerAction
    end
    item
      Name = 'WebActionItem1'
      PathInfo = '/test'
      OnAction = WebModule1WebActionItem1Action
    end
    item
      Name = 'WebActionItem2'
      PathInfo = '/lookausr'
      OnAction = lookausr
    end
    item
      Name = 'WebActionItem3'
      PathInfo = '/addaUsr'
      OnAction = addaUsr
    end
    item
      Name = 'WebActionItem4'
      PathInfo = '/login'
      OnAction = login
    end
    item
      Name = 'WebActionItem5'
      PathInfo = '/sendsms'
      OnAction = sendsms
    end
    item
      Name = 'WebActionItem6'
      PathInfo = '/appreg'
      OnAction = appreg
    end
    item
      Name = 'WebActionItem7'
      PathInfo = '/getRegUsers'
      OnAction = getRegUsers
    end
    item
      Name = 'WebActionItem8'
      PathInfo = '/deluser'
      OnAction = deluser
    end>
  Height = 230
  Width = 415
  object PageProducer1: TPageProducer
    Left = 56
    Top = 40
  end
  object ADOConnection1: TADOConnection
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=ZZU0416pub*;Persist Security Info=T' +
      'rue;User ID=hxm;Initial Catalog=vls3db;Data Source=192.168.66.13' +
      ',64321'
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 136
    Top = 40
  end
  object ADOQuery1: TADOQuery
    Connection = ADOConnection1
    Parameters = <>
    Left = 216
    Top = 40
  end
  object ADOQryP: TADOQuery
    Connection = ADOConnection1
    Parameters = <>
    Left = 312
    Top = 48
  end
  object adoqryP2: TADOQuery
    Connection = ADOConnection1
    Parameters = <>
    Left = 328
    Top = 112
  end
end
