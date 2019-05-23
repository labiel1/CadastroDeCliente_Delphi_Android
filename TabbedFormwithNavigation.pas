unit TabbedFormwithNavigation;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.StdCtrls, FMX.Controls.Presentation,
  FMX.Gestures, System.Actions, FMX.ActnList, FMX.Edit, FMX.DateTimeCtrls,
  FMX.Bind.GenData, Data.Bind.GenData, Data.Bind.EngExt, FMX.Bind.DBEngExt,
  System.Rtti, System.Bindings.Outputs, FMX.ListView.Types, FMX.ListView,
  Data.Bind.Components, Data.Bind.ObjectScope, System.RegularExpressions,
  FMX.Effects, System.MaskUtils, FMX.Layouts, FMX.ListBox,
  System.IOUtils, Androidapi.IOUtils,FMX.ExtCtrls, FMX.ScrollBox,
  FMX.Memo, FMX.Objects, FMX.Ani, FireDAC.UI.Intf, FireDAC.FMXUI.Wait,
  FireDAC.Stan.Intf, FireDAC.Comp.UI;

type
  TTabbedwithNavigationForm = class(TForm)
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabControl2: TTabControl;
    TabItem5: TTabItem;
    TabItem6: TTabItem;
    ToolBar2: TToolBar;
    lblTitle2: TLabel;
    btnBack: TSpeedButton;
    TabItem2: TTabItem;
    ToolBar3: TToolBar;
    lblTitle3: TLabel;
    GestureManager1: TGestureManager;
    ActionList1: TActionList;
    NextTabAction1: TNextTabAction;
    PreviousTabAction1: TPreviousTabAction;
    edtTelefone: TEdit;
    ClearEditButton1: TClearEditButton;
    lblNome: TLabel;
    edtNome: TEdit;
    lblEmail: TLabel;
    PrototypeBindSource1: TPrototypeBindSource;
    BindingsList1: TBindingsList;
    LinkFillControlToField1: TLinkFillControlToField;
    edtEmail: TEdit;
    SEResult: TShadowEffect;
    SERTelresult: TShadowEffect;
    Panel1: TPanel;
    btnExport: TButton;
    pnlCadastro: TPanel;
    btnOK: TButton;
    btnCancela: TButton;
    lbClientes: TListBox;
    ListView1: TListView;
    LbFolder: TLabel;
    pnlTitulo: TPanel;
    btnSair: TButton;
    lblTitulo: TLabel;
    Panel2: TPanel;
    btnCadastroCurso: TButton;
    imgFundo: TImage;
    cbCurso: TComboBox;
    lblCurso: TLabel;
    FloatKeyAnimation1: TFloatKeyAnimation;
    edtCurso: TEdit;
    pnlControles: TPanel;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    lblTelefone: TLabel;
    btnCadastroAluno: TButton;
    lbCursos: TListBox;
    lbVersao: TListBox;
    VertScrollBox1: TVertScrollBox;
    MainLayout1: TLayout;
    procedure GestureDone(Sender: TObject; const EventInfo: TGestureEventInfo;
      var Handled: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure edtEmailEnter(Sender: TObject);
    procedure edtNomeEnter(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnSairClick(Sender: TObject);
    procedure btnCancelaClick(Sender: TObject);
    procedure edtTelefoneExit(Sender: TObject);
    procedure edtTelefoneChangeTracking(Sender: TObject);
    procedure ListView1ItemClickEx(const Sender: TObject; ItemIndex: Integer;
      const LocalClickPos: TPointF; const ItemObject: TListItemObject);
    procedure btnExportClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure edtNomeExit(Sender: TObject);
    procedure edtTelefoneEnter(Sender: TObject);
    procedure btnCadastroCursoClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btnCadastroAlunoClick(Sender: TObject);
    procedure FormFocusChanged(Sender: TObject);
    procedure FormVirtualKeyboardHidden(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormVirtualKeyboardShown(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure edtEmailExit(Sender: TObject);
  private
    FKBBounds: TRectF;
    FNeedOffset: Boolean;
    function Mascara(edt, str: String): string;
    function ListBox2File(sFile: String; oList: TListBox): Boolean;
    procedure carregadiretorio(diretorio: string);
    procedure percorrerListBox(listBox1: TListBox);
    function Exportar(PastaNome: string; Lista: TListBox): Boolean;
    procedure PreencherCurso;
    function mensagemConfirmacao(pMensagem: String): TModalResult;
    function TrocaCaracterEspecial(aTexto: string; aLimExt: Boolean): string;
    procedure FormControle(Valor: Integer);
    procedure DeletarArquivoVersao(nomeArquivo: String);
    procedure UpdateKBBounds;
    procedure RestorePosition;
    procedure CalcContentBoundsProc(Sender: TObject; var ContentBounds: TRectF);

    { Private declarations }
  public
    { Public declarations }
  end;

var
  TabbedwithNavigationForm: TTabbedwithNavigationForm;

implementation

uses System.Math;
{$R *.fmx}

procedure TTabbedwithNavigationForm.btnCancelaClick(Sender: TObject);
begin
  edtNome.Text := '';
  edtTelefone.Text := '';
  edtEmail.Text := '';
end;

procedure TTabbedwithNavigationForm.btnExportClick(Sender: TObject);
begin
  Exportar(LbFolder.Text + '/CadastroCliente.csv', lbClientes);
end;

function TTabbedwithNavigationForm.Exportar(PastaNome: string;
  Lista: TListBox): Boolean;
begin
  result := false;
  // para usar no android
  // result := ListBox2File(LbFolder.Text + '/CadastroCliente.csv', lbClientes);
  result := ListBox2File(PastaNome, Lista);
end;

procedure TTabbedwithNavigationForm.btnOKClick(Sender: TObject);
var
  Feito: Boolean;
  tamanho : integer;
begin
  Feito := false;
  try
      tamanho := Length(StringReplace(edtTelefone.Text, ' ', '', [rfReplaceAll]));

      //tamanho :=  StringReplace(edtTelefone.Text, ' ', '', [rfReplaceAll]);
         if (edtNome.Text <> '') and (edtTelefone.Text <> '') and
      (edtEmail.Text <> '') and (tamanho >= 14) then
    begin

      lbClientes.Items.Add(edtNome.Text + '|' + edtTelefone.Text + '|' +
        edtEmail.Text + '|' + UpperCase(cbCurso.Items.Strings
        [cbCurso.ItemIndex]));
      Feito := Exportar(LbFolder.Text + '/CadastroCliente.txt', lbClientes);
      Exportar(LbFolder.Text + '/CadastroCliente.csv', lbClientes);
      edtNome.Text := '';
      edtTelefone.Text := '';
      edtEmail.Text := '';

    end

  finally
    if Feito = True then
    begin
      lbVersao.Items.Add('1');
      Exportar(LbFolder.Text + '/versao.txt', lbVersao);
      ShowMessage('Cadastrado com Sucesso');
      lbVersao.Clear;
    end
    else
      //ShowMessage(inttostr(tamanho));
      if (tamanho < 14) then
      ShowMessage('Preencha o telefone completo Exemplo: (11)99999-9999')
      else
      ShowMessage('Preencha todos os dados')
  end;
end;

procedure TTabbedwithNavigationForm.btnSairClick(Sender: TObject);
begin
  Exportar(LbFolder.Text + '/CadastroCliente.csv', lbClientes);
  Exportar(LbFolder.Text + '/CadastroCliente.txt', lbClientes);
  Close();
end;

procedure TTabbedwithNavigationForm.Button1Click(Sender: TObject);
begin
  mensagemConfirmacao('Teste de envio');
end;

procedure TTabbedwithNavigationForm.btnCadastroAlunoClick(Sender: TObject);
begin
  FormControle(7);
end;

procedure TTabbedwithNavigationForm.btnCadastroCursoClick(Sender: TObject);
Var
  I: Integer;
  StrX, curso: String;
  SL: TListBox;
begin

  try
    // SL := TListBox.Create(Self);
    // SL.Parent := Self;
    // SL.Name := 'Curso';

    // for I := 0 to cbCurso.Items.Count - 1 do
    // SL.Items.Add(UpperCase(cbCurso.Items.Strings[I]));

    // SL := Tmemo.Create(Self);
    // SL.Parent := Self;
    // SL.Name := 'Curso';
    // SL.Lines.LoadFromFile(LbFolder.Text + '/Curso.txt');
    StrX := '';
    // curso := InputBox('Cadastrar Curso', 'nome do Curso', StrX);
    curso := UpperCase(TrocaCaracterEspecial(edtCurso.Text, True));
    if curso <> '' then
    begin

      lbCursos.Items.Add(UpperCase(curso));


      // SL.Lines.Append(curso);
      // ShowMessage(curso);
      // SL.Lines.SaveToFile(LbFolder.Text + '/Curso.txt');

      Exportar(LbFolder.Text + '/Curso.txt', lbCursos);
    end;

  finally
    PreencherCurso;
    edtCurso.Text := '';
    // SL.Free;
  end;
end;

procedure TTabbedwithNavigationForm.edtEmailEnter(Sender: TObject);
begin
  edtEmail.Text := '';
end;

procedure TTabbedwithNavigationForm.edtEmailExit(Sender: TObject);
var
  MemoEmailValido: String;
begin
  MemoEmailValido := '^((?>[a-zA-Z\d!#$%&''*+\-/=?^_`{|}~]+\x20*' +
    '|"((?=[\x01-\x7f])[^"\\]|\\[\x01-\x7f])*"\' +
    'x20*)*(?<angle><))?((?!\.)(?>\.?[a-zA-Z\d!' +
    '#$%&''*+\-/=?^_`{|}~]+)+|"((?=[\x01-\x7f])' +
    '[^"\\]|\\[\x01-\x7f])*")@(((?!-)[a-zA-Z\d\' +
    '-]+(?<!-)\.)+[a-zA-Z]{2,}|\[(((?(?<!\[)\.)' +
    '(25[0-5]|2[0-4]\d|[01]?\d?\d)){4}|[a-zA-Z\' +
    'd\-]*[a-zA-Z\d]:((?=[\x01-\x7f])[^\\\[\]]|' +
    '\\[\x01-\x7f])+)\])(?(angle)>)$';
  if (TRegEx.IsMatch(edtEmail.Text, MemoEmailValido)) then
    SEResult.ShadowColor := TAlphaColors.Green
  else
    SEResult.ShadowColor := TAlphaColors.Red;
end;

procedure TTabbedwithNavigationForm.edtNomeEnter(Sender: TObject);
begin
  edtNome.Text := '';
end;

procedure TTabbedwithNavigationForm.edtNomeExit(Sender: TObject);
begin
  edtNome.Text := UpperCase(edtNome.Text);
end;

procedure TTabbedwithNavigationForm.edtTelefoneChangeTracking(Sender: TObject);
var
  MemoTelValido: String;
begin
  MemoTelValido := '\(\d{2}\)\s(\d{4}-\d{5}|\d{5}-\d{4}|\d{4}-\d{4})';
  if (TRegEx.IsMatch(edtTelefone.Text, MemoTelValido)) then
    SERTelresult.ShadowColor := TAlphaColors.Green
  else
    SERTelresult.ShadowColor := TAlphaColors.Red;
end;

procedure TTabbedwithNavigationForm.edtTelefoneEnter(Sender: TObject);
begin
  edtTelefone.Text := StringReplace(edtTelefone.Text, '(', '', [rfReplaceAll]);
  edtTelefone.Text := StringReplace(edtTelefone.Text, ')', '', [rfReplaceAll]);
  edtTelefone.Text := StringReplace(edtTelefone.Text, ' ', '', [rfReplaceAll]);
  edtTelefone.Text := StringReplace(edtTelefone.Text, '-', '', [rfReplaceAll]);
end;

procedure TTabbedwithNavigationForm.edtTelefoneExit(Sender: TObject);
var
  verifica: string;
begin
  edtTelefone.Text := (FormatMaskText('\(00\) 00000-0009;0;',
    edtTelefone.Text));
  verifica := StringReplace(edtTelefone.Text, '(', '', [rfReplaceAll]);
  verifica := StringReplace(verifica, ')', '', [rfReplaceAll]);
  verifica := StringReplace(verifica, ' ', '', [rfReplaceAll]);
  verifica := StringReplace(verifica, '-', '', [rfReplaceAll]);
  if verifica = '' then
    edtTelefone.Text := '';

end;

procedure TTabbedwithNavigationForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  try
    // TTabbedwithNavigationForm.Hide;
  finally
    Application.MainForm.DisposeOf;
  end;
end;

procedure TTabbedwithNavigationForm.FormCreate(Sender: TObject);
var
  pasta, versao: string;

begin
  VertScrollBox1.OnCalcContentBounds := CalcContentBoundsProc;

  { This defines the default active tab at runtime }
  TabControl1.ActiveTab := TabItem1;
  carregadiretorio(GetSharedDownloadsDir);
  // LbFolder.Text := 'C:\tmp\';

  versao := LbFolder.Text + '/versao.txt';

  if FileExists(versao) then
  begin
    lbVersao.Items.LoadFromFile(versao);

    if lbVersao.Items[0] <> '1' then
    begin
      DeletarArquivoVersao(LbFolder.Text + '/CadastroCliente.txt');
      DeletarArquivoVersao(LbFolder.Text + '/Curso.txt');
    end;
  end
  else
  begin
    DeletarArquivoVersao(LbFolder.Text + '/CadastroCliente.txt');
    DeletarArquivoVersao(LbFolder.Text + '/Curso.txt');
  end;

  pasta := LbFolder.Text + '/CadastroCliente.txt';

  pasta := StringReplace(pasta, '//', '/', [rfReplaceAll]);
  lbClientes.Clear;
  cbCurso.Items.Clear;

  // btnNext.Visible := false;

  // ShowMessage(pasta);

  if FileExists(pasta) then
  begin

    lbClientes.Items.LoadFromFile(pasta);

    percorrerListBox(lbClientes);
  end;

  PreencherCurso;
  mensagemConfirmacao('Deseja Cadastrar Curso?');
end;

procedure TTabbedwithNavigationForm.FormFocusChanged(Sender: TObject);
begin
  UpdateKBBounds;
end;

procedure TTabbedwithNavigationForm.PreencherCurso;
var
  I: Integer;
  pasta: string;
  arq: TextFile;
  PegaTexto, Campo: String;
begin
  // Cadastro de curso
  cbCurso.Clear;
  pasta := LbFolder.Text + '/Curso.txt';
  pasta := StringReplace(pasta, '//', '/', [rfReplaceAll]);
  lbCursos.Clear;
  if FileExists(pasta)
  then { Melhor Testar a Existência do Arquivo, já que a excessão não está sendo tratada. By, Mestrecal. }
  begin
    lbCursos.Items.LoadFromFile(pasta);

    for I := 0 to lbCursos.Items.Count - 1 do
      cbCurso.Items.Add(lbCursos.Items[I]);

    cbCurso.ItemIndex := 0;
  end;

end;

procedure TTabbedwithNavigationForm.FormKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkReturn then
  begin
    Key := vkTab;
    KeyDown(Key, KeyChar, Shift);
  end;

  if (Length(edtTelefone.Text) >= 15) then
    edtTelefone.Text := copy(edtTelefone.Text, 0, 15);
end;

procedure TTabbedwithNavigationForm.FormKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkHardwareBack then
  begin
    if (TabControl1.ActiveTab = TabItem1) and (TabControl2.ActiveTab = TabItem6)
    then
    begin
      TabControl2.Previous;
      Key := 0;
    end;
  end;
end;

procedure TTabbedwithNavigationForm.FormVirtualKeyboardHidden(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
  FKBBounds.Create(0, 0, 0, 0);
  FNeedOffset := false;
  RestorePosition;
end;

procedure TTabbedwithNavigationForm.FormVirtualKeyboardShown(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
  FKBBounds := TRectF.Create(Bounds);
  FKBBounds.TopLeft := ScreenToClient(FKBBounds.TopLeft);
  FKBBounds.BottomRight := ScreenToClient(FKBBounds.BottomRight);
  UpdateKBBounds;
end;

procedure TTabbedwithNavigationForm.GestureDone(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
begin
  case EventInfo.GestureID of
    sgiLeft:
      begin
        if TabControl1.ActiveTab <> TabControl1.Tabs[TabControl1.TabCount - 1]
        then
          TabControl1.ActiveTab := TabControl1.Tabs[TabControl1.TabIndex + 1];
        Handled := True;
      end;

    sgiRight:
      begin
        if TabControl1.ActiveTab <> TabControl1.Tabs[0] then
          TabControl1.ActiveTab := TabControl1.Tabs[TabControl1.TabIndex - 1];
        Handled := True;
      end;
  end;
end;

function TTabbedwithNavigationForm.Mascara(edt: String; str: String): string;
var
  I: Integer;
begin
  for I := 1 to Length(edt) do
  begin
    if (str[I] = '9') and not(edt[I] in ['0' .. '9']) and
      (Length(edt) = Length(str) + 1) then
      delete(edt, I, 1);
    if (str[I] <> '9') and (edt[I] in ['0' .. '9']) then
      insert(str[I], edt, I);
  end;
  result := edt;
end;

function TTabbedwithNavigationForm.ListBox2File(sFile: String;
  oList: TListBox): Boolean;
var
  fFile: Text;
  x: Integer;
begin
  result := false;
  try
    // ShowMessage(sFile);
    sFile := sFile;
    // ShowMessage(sFile);
    AssignFile(fFile, sFile);
    Rewrite(fFile);
    x := 0;
    While x <> oList.Items.Count do
    begin
      writeln(fFile, StringReplace(oList.Items[x], '|', ';', [rfReplaceAll]));
      inc(x);
    end;
    CloseFile(fFile);
  finally
    result := True;
  end;
end;

procedure TTabbedwithNavigationForm.ListView1ItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemObject);
begin
  if ListView1.Items[ListView1.ItemIndex].Detail = 'folder' then
    carregadiretorio(LbFolder.Text + PathDelim + ListView1.Items
      [ListView1.ItemIndex].Text)
  else if ListView1.Items[ListView1.ItemIndex].Detail = 'voltar' then
    carregadiretorio(copy(ExtractFilePath(LbFolder.Text), 0,
      Length(ExtractFilePath(LbFolder.Text)) - 1));
end;

procedure TTabbedwithNavigationForm.carregadiretorio(diretorio: string);
var
  listapastas, listaarquivos: TStringDynArray;
  pasta, arquivo: string;
  LItem: TListViewItem;
begin

  ListView1.Items.Clear;
  LbFolder.Text := diretorio;
  listapastas := TDirectory.GetDirectories(diretorio);
  listaarquivos := TDirectory.GetFiles(diretorio);
  ListView1.BeginUpdate;

  LItem := ListView1.Items.Add;
  LItem.Detail := 'voltar';
  LItem.Text := '..<<';

  for pasta in listapastas do
  begin
    // Carrega as Pastas
    LItem := ListView1.Items.Add;
    LItem.Detail := 'folder';
    LItem.Text := copy(pasta, Length(ExtractFilePath(pasta)) + 1,
      Length(pasta));
  end;

  for arquivo in listaarquivos do
  begin
    // Carrega os Arquivos
    LItem := ListView1.Items.Add;
    LItem.Detail := 'file';
    LItem.Text := ExtractFileName(arquivo);
  end;

  ListView1.EndUpdate;
end;

procedure TTabbedwithNavigationForm.percorrerListBox(listBox1: TListBox);
var
  I: Integer;
begin
  for I := 0 to listBox1.Items.Count - 1 do
  begin
    listBox1.Items.Strings[I] :=
      UpperCase(StringReplace(listBox1.Items.Strings[I], ';', '|',
      [rfReplaceAll]));
    // ShowMessage(listBox1.Items.Strings[i]);
  end;
end;

function TTabbedwithNavigationForm.mensagemConfirmacao(pMensagem: String)
  : TModalResult;
var
  MR: TModalResult;
begin
  MessageDlg(pMensagem, System.UITypes.TMsgDlgType.mtConfirmation,
    [System.UITypes.TMsgDlgBtn.mbYes, System.UITypes.TMsgDlgBtn.mbNo], 0,
    procedure(const AResult: TModalResult)
    begin
      MR := AResult;
    end);

  while MR = mrNone do
    Application.ProcessMessages;

  FormControle(MR);
  result := MR;
end;

procedure TTabbedwithNavigationForm.FormControle(Valor: Integer);
begin
  if Valor = 7 then
  begin
    TabControl1.Tabs[0].Visible := True;
    TabControl1.Tabs[1].Visible := false;

    lblNome.Visible := True;
    lblNome.Align := TAlignLayout.Top;

    edtNome.Visible := True;
    edtNome.Align := TAlignLayout.Top;
    lblEmail.Visible := True;
    lblEmail.Align := TAlignLayout.Top;
    edtEmail.Visible := True;
    edtEmail.Align := TAlignLayout.Top;
    lblTelefone.Visible := True;
    lblTelefone.Align := TAlignLayout.Top;
    edtTelefone.Visible := True;
    edtTelefone.Align := TAlignLayout.Top;

    lblCurso.Visible := false;
    edtCurso.Visible := false;
    lblTitulo.Text := 'Cadastro de Aluno';
    btnCadastroCurso.Visible := false;
    btnCadastroAluno.Visible := false;
    btnOK.Visible := True;
  end
  else
  begin
    TabControl1.Tabs[0].Visible := True;
    TabControl1.Tabs[1].Visible := false;

    lblNome.Visible := false;
    lblNome.Align := TAlignLayout.Bottom;

    edtNome.Align := TAlignLayout.Bottom;
    edtNome.Visible := false;

    lblEmail.Visible := false;
    lblEmail.Align := TAlignLayout.Bottom;
    edtEmail.Visible := false;
    edtEmail.Align := TAlignLayout.Bottom;
    lblTelefone.Visible := false;
    lblTelefone.Align := TAlignLayout.Bottom;
    edtTelefone.Visible := false;
    edtTelefone.Align := TAlignLayout.Bottom;

    lblTitulo.Text := 'Cadastro de Cursos';
    lblCurso.Visible := True;

    edtCurso.Visible := True;
    btnCadastroCurso.Visible := True;
    btnCadastroAluno.Visible := True;
    btnOK.Visible := false;

  end;
end;

function TTabbedwithNavigationForm.TrocaCaracterEspecial(aTexto: string;
aLimExt: Boolean): string;
const
  // Lista de caracteres especiais
  xCarEsp: array [1 .. 38] of String = ('á', 'à', 'ã', 'â', 'ä', 'Á', 'À', 'Ã',
    'Â', 'Ä', 'é', 'è', 'É', 'È', 'í', 'ì', 'Í', 'Ì', 'ó', 'ò', 'ö', 'õ', 'ô',
    'Ó', 'Ò', 'Ö', 'Õ', 'Ô', 'ú', 'ù', 'ü', 'Ú', 'Ù', 'Ü', 'ç', 'Ç', 'ñ', 'Ñ');
  // Lista de caracteres para troca
  xCarTro: array [1 .. 38] of String = ('a', 'a', 'a', 'a', 'a', 'A', 'A', 'A',
    'A', 'A', 'e', 'e', 'E', 'E', 'i', 'i', 'I', 'I', 'o', 'o', 'o', 'o', 'o',
    'O', 'O', 'O', 'O', 'O', 'u', 'u', 'u', 'u', 'u', 'u', 'c', 'C', 'n', 'N');
  // Lista de Caracteres Extras
  xCarExt: array [1 .. 48] of string = ('<', '>', '!', '@', '#', '$', '%', '¨',
    '&', '*', '(', ')', '_', '+', '=', '{', '}', '[', ']', '?', ';', ':', ',',
    '|', '*', '"', '~', '^', '´', '`', '¨', 'æ', 'Æ', 'ø', '£', 'Ø', 'ƒ', 'ª',
    'º', '¿', '®', '½', '¼', 'ß', 'µ', 'þ', 'ý', 'Ý');
var
  xTexto: string;
  I: Integer;
begin
  xTexto := aTexto;
  for I := 1 to 38 do
    xTexto := StringReplace(xTexto, xCarEsp[I], xCarTro[I], [rfReplaceAll]);
  // De acordo com o parâmetro aLimExt, elimina caracteres extras.
  if (aLimExt) then
    for I := 1 to 48 do
      xTexto := StringReplace(xTexto, xCarExt[I], '', [rfReplaceAll]);
  result := xTexto;
end;

procedure TTabbedwithNavigationForm.DeletarArquivoVersao(nomeArquivo: String);
begin
  deletefile(nomeArquivo);
end;

procedure TTabbedwithNavigationForm.UpdateKBBounds;
var
  LFocused: TControl;
  LFocusRect: TRectF;
begin
  FNeedOffset := false;
  if Assigned(Focused) then
  begin
    LFocused := TControl(Focused.GetObject);
    LFocusRect := LFocused.AbsoluteRect;
    LFocusRect.Offset(VertScrollBox1.ViewportPosition);
    if (LFocusRect.IntersectsWith(TRectF.Create(FKBBounds))) and
      (LFocusRect.Bottom > FKBBounds.Top) then
    begin
      FNeedOffset := True;
      MainLayout1.Align := TAlignLayout.Horizontal;
      VertScrollBox1.RealignContent;
      Application.ProcessMessages;
      VertScrollBox1.ViewportPosition :=
        PointF(VertScrollBox1.ViewportPosition.x,
        LFocusRect.Bottom - FKBBounds.Top);
    end;
  end;
  if not FNeedOffset then
    RestorePosition;
end;

procedure TTabbedwithNavigationForm.RestorePosition;
begin
  VertScrollBox1.ViewportPosition :=
    PointF(VertScrollBox1.ViewportPosition.x, 0);
  MainLayout1.Align := TAlignLayout.Client;
  VertScrollBox1.RealignContent;
end;

procedure TTabbedwithNavigationForm.CalcContentBoundsProc(Sender: TObject;
var ContentBounds: TRectF);
begin
  if FNeedOffset and (FKBBounds.Top > 0) then
  begin
    ContentBounds.Bottom := Max(ContentBounds.Bottom,
      2 * ClientHeight - FKBBounds.Top);
  end;
end;

end.
