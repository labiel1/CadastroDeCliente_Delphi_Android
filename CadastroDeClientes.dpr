program CadastroDeClientes;

uses
  System.StartUpCopy,
  FMX.Forms,
  TabbedFormwithNavigation in 'TabbedFormwithNavigation.pas' {TabbedwithNavigationForm};

{$R *.res}

begin
  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.Portrait];
  Application.CreateForm(TTabbedwithNavigationForm, TabbedwithNavigationForm);
  Application.Run;
end.
