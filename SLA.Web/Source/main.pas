unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  HTTPApp, DBWeb, DBTables, Db, DSProd, HTTPProd, DBBdeWeb;

type
  TInfoModule = class(TWebModule)
    CustomerList: TPageProducer;
    Customer: TTable;
    CustomerCustNo: TFloatField;
    CustomerCompany: TStringField;
    Root: TPageProducer;
    Session1: TSession;
    procedure InfoModulerootAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure CustomerListHTMLTag(Sender: TObject; Tag: TTag;
      const TagString: String; TagParams: TStrings;
      var ReplaceText: String);
    procedure InfoModuleRedirectAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure RootHTMLTag(Sender: TObject; Tag: TTag;
      const TagString: String; TagParams: TStrings;
      var ReplaceText: String);
    procedure EmployeeListFormatCell(Sender: TObject; CellRow,
      CellColumn: Integer; var BgColor: THTMLBgColor;
      var Align: THTMLAlign; var VAlign: THTMLVAlign; var CustomAttrs,
      CellData: String);
  public
    { Public declarations }
  end;

var
  InfoModule: TInfoModule;

implementation

uses JPeg;

{$R *.dfm}

procedure TInfoModule.CustomerListHTMLTag(Sender: TObject; Tag: TTag;
  const TagString: String; TagParams: TStrings; var ReplaceText: String);
var
  Customers: String;
begin
  Customers := '';
  if CompareText(TagString, 'CUSTLIST') = 0 then
  begin
    Customer.Open;
    try
      while not Customer.Eof do
      begin
        Customers := Customers + Format('<A HREF="%s/runquery?CustNo=%d">%s</A><BR>',
          [Request.ScriptName, CustomerCustNo.AsInteger, CustomerCompany.AsString]);
        Customer.Next;
      end;
    finally
      Customer.Close;
    end;
  end;
  ReplaceText := Customers;
end;



procedure TInfoModule.EmployeeListFormatCell(Sender: TObject;
  CellRow, CellColumn: Integer; var BgColor: THTMLBgColor;
  var Align: THTMLAlign; var VAlign: THTMLVAlign; var CustomAttrs,
  CellData: String);
begin
  if CellRow = 0 then BgColor := 'Gray'
  else if CellRow mod 2 = 0 then BgColor := 'Silver';
end;




procedure TInfoModule.InfoModuleRedirectAction(
  Sender: TObject; Request: TWebRequest; Response: TWebResponse;
  var Handled: Boolean);
begin
  Response.SendRedirect('http://www.borland.com');
end;

procedure TInfoModule.InfoModulerootAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
//  root.HTMLFile:='index.html';
end;

procedure TInfoModule.RootHTMLTag(Sender: TObject; Tag: TTag;
  const TagString: String; TagParams: TStrings; var ReplaceText: String);
begin

  if TagString = 'DATE' then ReplaceText := datetimetostr(now);
  if TagString = 'MODULENAME' then
    ReplaceText := Request.ScriptName;

  if TagString = 'VISITCOUNT' then
    with Response.Cookies.Add do
    begin
      Name := 'TheCookie';
      Value :=  Request.CookieFields.Values['TheCookie'];
      if Value = '' then Value := '0';
      try
        Value := IntToStr(StrToInt(Value) + 1);
      except
        Value := '1';
      end;
      Expires := Now + 1;  // this cookie expires in one day
      ReplaceText := Value;
    end;

 if TagString = 'IP' then ReplaceText := root.HTMLFile;
end;

end.

