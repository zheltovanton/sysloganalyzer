object InfoModule: TInfoModule
  OldCreateOrder = True
  Actions = <
    item
      Name = 'CustomerList'
      PathInfo = '/customerlist'
      Producer = CustomerList
    end
    item
      Default = True
      Name = 'root'
      PathInfo = '/Root'
      Producer = Root
      OnAction = InfoModulerootAction
    end>
  Height = 513
  Width = 682
  object CustomerList: TPageProducer
    HTMLDoc.Strings = (
      '<HTML>'
      ' <!---------------------------------------------------->'
      '<!-- Copyright Borland Software Corporation 1999-2002 -->'
      ' <!---------------------------------------------------->'
      '<HEAD>'
      '<TITLE>Sample Delphi Web server application</TITLE>'
      '</HEAD>'
      '<BODY>'
      '<H2>Customer Order Information</H2>'
      '<HR>'
      'Click a customer name to view their orders.<P>'
      '<#CUSTLIST><P>'
      '</BODY>'
      '</HTML>'
      ' ')
    OnHTMLTag = CustomerListHTMLTag
    Left = 50
    Top = 89
  end
  object Customer: TTable
    DatabaseName = 'DBDEMOS'
    SessionName = 'Session1_1'
    IndexFieldNames = 'Company'
    TableName = 'CUSTOMER.DB'
    Left = 128
    Top = 88
    object CustomerCustNo: TFloatField
      FieldName = 'CustNo'
    end
    object CustomerCompany: TStringField
      FieldName = 'Company'
      Size = 30
    end
  end
  object Root: TPageProducer
    HTMLDoc.Strings = (
      '<HTML>'
      '<TITLE>SysLogAnalizer Web Client</TITLE>'
      '<BODY>'
      '<P>'
      
        '<body bgcolor="#FFFFFF"> <FONT face="Arial" size=4>SysLogAnalize' +
        'r main report.  Date <#DATE></font><BR><BR>'
      '<P>'
      '<B>TPageProducer using a Custom Tag</B><BR>'
      'For an example of using a TPageProducer with a Custom Tag click'
      
        '<A HREF="<#MODULENAME>/customerlist">here</A>.  This example ret' +
        'urns'
      
        'list of all customers from the Customer.DB table.  You can click' +
        ' the customer'#39's'
      'name to view a listing of their orders.'
      '<P>'
      ''
      ''
      'Number of hits from this browser  = <#VISITCOUNT>  <br>'
      'Your IP: <#IP>'
      '</BODY>'
      '</HTML>'
      ''
      ''
      ' '
      ' ')
    OnHTMLTag = RootHTMLTag
    Left = 50
    Top = 24
  end
  object Session1: TSession
    AutoSessionName = True
    Left = 48
    Top = 152
  end
end
