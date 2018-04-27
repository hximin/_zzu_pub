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
    end>
  Height = 230
  Width = 415
  object PageProducer1: TPageProducer
    Left = 112
    Top = 64
  end
end
