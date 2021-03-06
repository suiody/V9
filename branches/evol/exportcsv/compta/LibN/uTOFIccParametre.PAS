{***********UNITE*************************************************
Auteur  ...... : COSTE Gilles
Cr�� le ...... : 19/03/2001
Modifi� le ... : 29/03/2001
Description .. : Source TOF de la TABLE : ICCPARAMETRE ()
Mots clefs ... : TOF;ICCPARAMETRE
*****************************************************************}
Unit uTOFIccParametre;

Interface

Uses StdCtrls,
     Controls,
     Classes,
{$IFDEF EAGLCLIENT}
     UTOB,
     MaineAGL,             // AGLLanceFICHE
{$ELSE}
     db,
     {$IFNDEF DBXPRESS} dbtables, {$ELSE} uDbxDataSet, {$ENDIF}
     FE_Main,              // AGLLanceFICHE
{$ENDIF}
     forms,
     sysutils,
     ComCtrls,
     HCtrls,
     HEnt1,
     HMsgBox,
     UTOF,
     Windows,
     Ent1,
     ParamSoc,
     Htb97,                // TtoolBarButton97
     Graphics,
     HFLabel,              // TFlashingLabel
     HPanel,               // THPanel
     HRichOLE,             // THRichEditOLE
     uTOFIccInteret,       // CPLanceFiche_ICCINTERET
     IccGlobale;

procedure CPLanceFiche_ICCPARAMETRE(psz : String);

Type
  TOF_ICCPARAMETRE = Class (TOF)
    procedure OnArgument (S : String ) ; override ;
    procedure OnClose                  ; override ;
    procedure OnLoad                   ; override ;
    procedure OnClickBValider          ( Sender : TObject );
    procedure OnKeyDownForm            ( Sender: TObject ; var Key: Word;Shift: TShiftState );
    procedure OnExitZDateDu            ( Sender : TObject );
    procedure OnExitZDateAu            ( Sender : TObject );

    procedure VerificationAvantCalcul  ( vStArgument : String ; D1, D2 : TDateTime  );

  private
    FStParam               : String;
    RichEdit               : THRichEditOLE;
    ZDateDu                : THEdit;
    ZDateAu                : THEdit;

  public

  end ;

Implementation

procedure CPLanceFiche_ICCPARAMETRE(psz : String);
begin
  AGLLanceFiche('CP', 'ICCPARAMETRE', '', '', psz);
end;

procedure TOF_ICCPARAMETRE.OnArgument (S : String ) ;
var stArg : String;
begin
  Inherited;
  { Param�tres pass�s dans la chaine S
      DATE 1 ( Date de d�but du calcul )
      DATE 2 ( Date de fin du calcul )
      LISTE DES COMPTES }

  stArg := S;

  { Date de D�but du calcul }
  FStParam := ReadTokenSt(stArg);
  SetControlText('ZDATEDU',FStParam);

  {Date de fin du calcul }
  FStParam := ReadTokenSt(stArg);
  SetControlText('ZDATEDU_', FStParam);

  { Listre des comptes s�lectionn�s }
  FStParam := stArg;

  ZDateDu := THEdit(GetControl('ZDATEDU'));
  ZDateAu := THEdit(GetControl('ZDATEDU_'));

  ZDateDu.OnExit := OnExitZDateDu;
  ZDateAu.OnExit := OnExitZDateAu;

  Ecran.OnKeyDown := OnKeyDownForm;

  TToolBarButton97(GetControl('BVALIDER')).OnClick := OnClickBValider;
  RichEdit := THRichEditOLE(GetControl('RichEdit'));
end ;

{***********A.G.L.***********************************************
Auteur  ...... : Gilles COSTE
Cr�� le ...... : 08/10/2001
Modifi� le ... :   /  /
Description .. :
Mots clefs ... :
*****************************************************************}
procedure TOF_ICCPARAMETRE.OnLoad;
begin
  inherited;
  SetControlText('ZMODE',GetParamSocSecur('SO_ICCNOMBREJOURS',''));

  if GetParamSocSecur('SO_ICCMETHODE','') = 'ICC' then
    THRadioGroup(GetControl('ZMETHODE')).ItemIndex := 0
  else
    THRadioGroup(GetControl('ZMETHODE')).ItemIndex := 1;

  VerificationAvantCalcul( FStParam, StrToDate(ZDateDu.Text), StrToDate(ZDateAu.Text) );

  // OU BIEN
  // V�rification des comptes Icc par rapport � ceux de la compta
  // Date1 := VH^.EnCours.Deb;
  // Date2 := IIF(VH^.Suivant.Code <> '',VH^.Suivant.Fin,VH^.Encours.Fin);
  //  VerificationAvantCalcul( FStParam, Date1, Date2 );

end;

{***********A.G.L.***********************************************
Auteur  ...... : Gilles COSTE
Cr�� le ...... : 08/10/2001
Modifi� le ... :   /  /
Description .. :
Mots clefs ... :
*****************************************************************}
procedure TOF_ICCPARAMETRE.OnExitZDateAu(Sender: TObject);
begin
  VerificationAvantCalcul( FStParam, StrToDate(ZDateDu.Text), StrToDate(ZDateAu.Text) );
end;

{***********A.G.L.***********************************************
Auteur  ...... : Gilles COSTE
Cr�� le ...... : 08/10/2001
Modifi� le ... :   /  /
Description .. :
Mots clefs ... :
*****************************************************************}
procedure TOF_ICCPARAMETRE.OnExitZDateDu(Sender: TObject);
begin
  VerificationAvantCalcul( FStParam, StrToDate(ZDateDu.Text), StrToDate(ZDateAu.Text) );
end;

procedure TOF_ICCPARAMETRE.OnClickBValider(Sender: TObject);
var Methode : Word;
    Mode : String;
    D1,D2 : TDateTime;
begin
  D1 := StrToDate(ZDateDu.Text);
  D2 := StrToDate(ZDateAu.Text);

  if D1 > D2 then
  begin
    PgiInfo('La date de fin du calcul doit �tre sup�rieure � la date de d�but.','Saisie de la date');
    Exit;
  end;

  if not ((D1 >= VH^.Encours.Deb) and (D2 <= VH^.Encours.Fin)) then
    if not ((D1 >= VH^.Suivant.Deb) and (D2 <= VH^.Suivant.Fin)) then
    begin
      PgiInfo('Les dates de calcul doivent �tre comprises dans l''intervalle de dates de l''un des exercices.','Saisie de la date');
      Exit;
    end;

  Methode := THRadioGRoup(GetControl('ZMETHODE')).ItemIndex;
  Mode := THValComboBox(GetControl('ZMODE')).Text;

  Icc_Data.AvecRecapitulatif := TCheckBox(GetControl('ZRECAPITULATIF')).Checked;

  CPLanceFiche_ICCINTERET(Mode + ';' + IntToStr(Methode) + ';' + DateToStr(D1) + ';' + DateToStr(D2) + ';' + FStParam);
  TToolBarButton97(GetControl('BFERME')).Click;
end;


{***********A.G.L.***********************************************
Auteur  ...... : Gilles COSTE
Cr�� le ...... : 08/10/2001
Modifi� le ... :   /  /
Description .. :
Mots clefs ... :
*****************************************************************}
procedure TOF_ICCPARAMETRE.OnKeyDownForm(Sender: TObject; var Key: Word;Shift: TShiftState);
begin
  if (Key = VK_F10) or (Key = VK_RETURN) then
    TToolBarButton97(GetControl('BVALIDER')).Click;
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Gilles COSTE
Cr�� le ...... : 21/09/2001
Modifi� le ... : 21/09/2001
Description .. :
Mots clefs ... :
*****************************************************************}
procedure TOF_ICCPARAMETRE.OnClose ;
begin
  inherited ;
end ;

{***********A.G.L.***********************************************
Auteur  ...... : Gilles COSTE
Cr�� le ...... : 08/10/2001
Modifi� le ... :   /  /
Description .. : V�rifie les comptes et les �l�ments nationaux avant les calculs
Mots clefs ... :
*****************************************************************}
procedure TOF_ICCPARAMETRE.VerificationAvantCalcul( vStArgument : String ; D1 , D2 : TDateTime );
var lStCompte : string;
begin
  if vStArgument = '' then Exit;

  Icc_Data.TauxAbsent        := False ;
  Icc_Data.TauxProvisoire    := False ;
  Icc_Data.NouvelleEcriture  := False ;
  Icc_Data.AvecRecapitulatif := False ;

  while vStArgument <> '' do
  begin
    lStCompte := ReadTokenSt( vStArgument );

    { V�rification si de nouvelles �critures ont �t� saisies dans la COMPTA }
    if not Icc_Data.NouvelleEcriture then
      Icc_Data.NouvelleEcriture := ExisteNouvelleEcriture ( lStCompte , D1 , D2 ) ;
  end;

  { V�rification si les taux sont saisis et de la fa�on dont ils sont d�finis }
  CalculTauxMaxLegal( D1 , D2 );

  RichEdit.Clear;
 
  if ICC_Data.SoldeDifferent then
  begin
    RichEdit.lines.Add('Le solde est diff�rent de celui de la comptabilit�');
    RichEdit.lines.Add(' ');
  end;

  if ICC_Data.NouvelleEcriture then
  begin
    RichEdit.lines.Add('Des nouvelles �critures n''ont pas �t� r�cup�r�es dans ICC');
    RichEdit.lines.Add(' ');
  end;

  if Icc_Data.TauxAbsent then
  begin
    RichEdit.lines.Add('Les �l�ments nationaux sont absents pour cette p�riode');
    RichEdit.lines.Add(' ');
  end;

  if Icc_Data.TauxProvisoire then
  begin
    RichEdit.lines.Add('Les �l�ments nationaux sont d�finis en "provisoires"');
    RichEdit.lines.Add(' ');
  end;

end;

Initialization
  registerclasses ( [ TOF_ICCPARAMETRE ] ) ;
end.
