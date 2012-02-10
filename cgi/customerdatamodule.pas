unit customerdatamodule;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Classes, httpdefs, fpHTTP, fpWeb, fpJson, jsonparser;

type

  { TCustomerData }

  TCustomerData = class(TFPWebModule)
    procedure insertRequest(Sender: TObject; ARequest: TRequest;
      AResponse: TResponse; var Handled: Boolean);
    procedure updateRequest(Sender: TObject; ARequest: TRequest;
      AResponse: TResponse; var Handled: Boolean);
  private
    { private declarations }
  public
    { public declarations }
  end;



var
  CustomerData: TCustomerData;

implementation

{$R *.lfm}

{ TCustomerData }

procedure TCustomerData.insertRequest(Sender: TObject; ARequest: TRequest;
  AResponse: TResponse; var Handled: Boolean);
var
  lResponse: TJSONObject;
  lJSON: TJSONObject;
  lResult: TJSONObject;
  lArray: TJSONArray;
  lJSonParser: TJSONParser;
  lStr: TStringList;
  lFile: string;
  I: Integer;
begin
  Randomize;
  (* Load "database" *)
  lFile := ExtractFilePath(ParamStr(0)) + 'users.json';
  lStr := TStringList.Create;
  lStr.LoadFromFile(lFile);
  lJSonParser := TJSONParser.Create(lStr.Text);
  lResponse :=TJSONObject.Create;
  try
    try
      lJSON := lJSonParser.Parse as TJSonObject;
      lArray := lJSON.Arrays['root'];
      (* Assign values to local variables *)
      lResult := TJSONObject.Create;
      lResult.Integers['Id'] := Random(1000);
      lResult.Strings['Name'] := ARequest.ContentFields.Values['Name'];
      lResult.Floats['Sales'] := StrToFloatDef(ARequest.ContentFields.Values['Sales'], 0);
      lArray.Add(lResult);
      (* Save the file *)
      lStr.Text:= lJSON.AsJSON;
      lStr.SaveToFile(lFile);

      lResponse.Add('success', true);
      lResponse.Add('msg', 'ok');

      AResponse.Content := lResponse.AsJSON;
    except
      on E: Exception do
      begin
        lResponse.Add('success', true);
        lResponse.Add('msg', E.Message);
        AResponse.Content := lResponse.AsJSON;
      end;
    end;
  finally
    lResponse.Free;
    lJSonParser.Free;
    lStr.Free;
  end;

  Handled := True;
end;

procedure TCustomerData.updateRequest(Sender: TObject; ARequest: TRequest;
  AResponse: TResponse; var Handled: Boolean);
var
  lResponse: TJSONObject;
  lJSON: TJSONObject;
  lResult: TJSONObject;
  lArray: TJSONArray;
  lId: string;
  lName: string;
  lSales: string;
  lJSonParser: TJSONParser;
  lStr: TStringList;
  lFile: string;
  I: Integer;
begin
  (* Load "database" *)
  lFile := ExtractFilePath(ParamStr(0)) + 'users.json';
  lStr := TStringList.Create;
  lStr.LoadFromFile(lFile);
  lJSonParser := TJSONParser.Create(lStr.Text);
  lResponse :=TJSONObject.Create;
  try
    try
      (* Assign values to local variables *)
      lId := ARequest.ContentFields.Values['Id'];
      lName := ARequest.ContentFields.Values['Name'];
      lSales := ARequest.ContentFields.Values['Sales'];

      (* Traverse data finding by Id *)
      lJSON := lJSonParser.Parse as TJSonObject;
      lArray := lJSON.Arrays['root'];
      for I := 0 to lArray.Count - 1 do
      begin
        lResult := lArray.Objects[I] as TJsonObject;
        if lResult.Strings['Id'] = lId then
        begin
          lResult.Strings['Name'] := lName;
          lResult.Strings['Sales'] := lSales;
          lStr.Text := lJSon.AsJSON;
          lStr.SaveToFile(lFile);
          Break;
        end;
      end;
      lResponse.Add('success', true);
      lResponse.Add('msg', 'ok');

      AResponse.Content := lResponse.AsJSON;

    except
      on E: Exception do
      begin
        lResponse.Add('success', true);
        lResponse.Add('msg', E.Message);
        AResponse.Content := lResponse.AsJSON;
      end;
    end;
  finally
    lResponse.Free;
    lJSonParser.Free;
    lStr.Free;
  end;

  Handled := True;

end;

initialization
  RegisterHTTPModule('CustomerData', TCustomerData);
end.

