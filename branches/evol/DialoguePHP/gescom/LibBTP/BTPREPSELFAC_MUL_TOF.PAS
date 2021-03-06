{***********UNITE*************************************************
Auteur  ...... : LS
Cr�� le ...... : 05/12/2008
Modifi� le ... :   /  /
Description .. : Source TOF de la FICHE : BTPREPSELFAC_MUL ()
Mots clefs ... : TOF;BTPREPSELFAC_MUL
*****************************************************************}
Unit BTPREPSELFAC_MUL_TOF ;

Interface

Uses StdCtrls,
     Controls,
     Classes,
{$IFNDEF EAGLCLIENT}
     db,
     {$IFNDEF DBXPRESS} dbtables, {$ELSE} uDbxDataSet, {$ENDIF}
     mul,
     fe_main,
{$else}
     eMul,
     uTob,
     MainEagl,
{$ENDIF}
     AglInit,
     forms,
     sysutils,
     ComCtrls,
     HCtrls,
     HEnt1,
     HMsgBox,
     UTOB,
     HTB97,
     UTOF ;

Type
  TOF_BTPREPSELFAC_MUL = Class (TOF)
  private
    LaTOBSel,TOBRES,TheTOBSelect : TOB;
    GS : THgrid;
    LaTOBAff : TOB;
    LesColonnes : string;
    procedure GetControls;
    procedure prepareTOBaff;
    procedure SetEvents;
    procedure AddChampsSup(TOBL : TOB);
    procedure DefiniGrid;
    procedure RemplitGrid;
    procedure GSDblClick (Sender : TObject);
  public
    procedure OnNew                    ; override ;
    procedure OnDelete                 ; override ;
    procedure OnUpdate                 ; override ;
    procedure OnLoad                   ; override ;
    procedure OnArgument (S : String ) ; override ;
    procedure OnDisplay                ; override ;
    procedure OnClose                  ; override ;
    procedure OnCancel                 ; override ;
  end ;

function ChoixSelectionFacture (TOBTMP : TOB) : TOB;
Implementation


function ChoixSelectionFacture (TOBTMP : TOB) : TOB;
begin
  TheTOB := TOBTMP;
  AglLanceFiche ('BTP','BTPREPSELFAC_MUL','','','');
  result := TheTOB;
  TheTOB := nil;
end;

procedure TOF_BTPREPSELFAC_MUL.OnNew ;
begin
  Inherited ;
end ;

procedure TOF_BTPREPSELFAC_MUL.OnDelete ;
begin
  Inherited ;
end ;

procedure TOF_BTPREPSELFAC_MUL.OnUpdate ;
begin
  Inherited ;
  TheTOB := TheTOBSelect;
end ;

procedure TOF_BTPREPSELFAC_MUL.OnLoad ;
begin
  Inherited ;
end ;

procedure TOF_BTPREPSELFAC_MUL.OnArgument (S : String ) ;
begin
  Inherited ;
  TheTOBSelect := nil;
  LesColonnes :='__SEL;__DEVIS;';
  LaTOBAff := TOB.Create ('LA TOB DE SELECTION',nil,-1);
  LaTOBSel := LaTOB;
  prepareTOBaff;
  GetControls;
  DefiniGrid;
  RemplitGrid;
  SetEvents;
end ;

procedure TOF_BTPREPSELFAC_MUL.OnClose ;
begin
  LaTOBAff.free;
  Inherited ;
end ;

procedure TOF_BTPREPSELFAC_MUL.OnDisplay () ;
begin
  Inherited ;
end ;

procedure TOF_BTPREPSELFAC_MUL.OnCancel () ;
begin
  Inherited ;
end ;

procedure TOF_BTPREPSELFAC_MUL.prepareTOBaff;
var Indice,NumSit : Integer;
    TOBL,TOBLS : TOB;
    NoDevis,Nature,Souche : string;
    QQ : TQuery;
begin
  //Codessaff := 'Z'+CleDocAffaire.NaturePiece+CledocAffaire.Souche+Codessaff+'00';
  for Indice := 0 to LaTOBSel.detail.count -1 do
  begin
    TOBLS := LaTOBSel.detail[Indice];
    TOBL := TOB.Create ('UNE TOB',LaTOBAff,-1);
    AddChampsSup(TOBL);
    Nature := Copy(TOBLS.getValue('BST_SSAFFAIRE'),2,3);
    Souche := Copy(TOBLS.getValue('BST_SSAFFAIRE'),5,3);
    NoDevis := Copy(TOBLS.getValue('BST_SSAFFAIRE'),8,8);
    NumSit := TOBLS.getValue('BST_NUMEROSIT');
    QQ := OpenSql ('SELECT GP_REFINTERNE,GP_DATEPIECE FROM PIECE WHERE GP_NATUREPIECEG="'+Nature+'" AND GP_SOUCHE="'+Souche+'" AND '+
                   'GP_NUMERO='+NoDevis,true,-1,'',true);
    if Not QQ.eof then
    begin
      TOBL.PutValue('__DEVIS','Ajouter ce devis au devis de base N� '+ NoDevis+' du '+
                    DateToStr(QQ.FinDfield('GP_DATEPIECE').AsDateTime)+ ' (Derni�re situation N�'+IntToStr(NumSit)+
                    ')  Ref interne : '+ QQ.findField('GP_REFINTERNE').AsString);
    end;
    ferme (QQ);
    TOBL.Data := TOBLS;
  end;
  // ajout sur une nouvelle facture
  TOBL := TOB.Create ('UNE TOB',LaTOBAff,-1);
  AddChampsSup(TOBL);
  TOBL.PutValue('__DEVIS','Facturer ce devis ind�pendamment...');
  TOBL.PutValue ('__NEW','X');
  TOBLS := TOB.Create ('BSITUATIONS',nil,-1);
  TOBL.Data := TOBLS;
end;

procedure TOF_BTPREPSELFAC_MUL.GetControls;
begin
  GS := THgrid(GetCOntrol('GS'));
end;

procedure TOF_BTPREPSELFAC_MUL.SetEvents;
begin
  GS.OnDblClick := GSDblClick;
end;

procedure TOF_BTPREPSELFAC_MUL.AddChampsSup(TOBL: TOB);
begin
  TOBL.AddChampSupValeur ('__SEL','');
  TOBL.AddChampSupValeur ('__DEVIS','');
  TOBL.AddChampSupValeur ('__NEW','-');
end;

procedure TOF_BTPREPSELFAC_MUL.DefiniGrid;
begin
  GS.RowCount := LaTOBAff.detail.count +1;
  GS.ColCount := 2;
  GS.Cells[0,0]:=' ';
  GS.Cells[0,1]:='Rattachement';
  GS.ColWidths [0] := 10;
  GS.ColWidths [1] := 80*GS.Canvas.TextWidth('W') ;
end;

procedure TOF_BTPREPSELFAC_MUL.RemplitGrid;
var Indice : integer;
begin
  for Indice := 0 to LaTOBAff.detail.count -1 do
  begin
    laTOBAff.detail[Indice].PutLigneGrid (GS,Indice+1,false,false,LesColonnes);
  end;
end;

procedure TOF_BTPREPSELFAC_MUL.GSDblClick(Sender: TObject);
begin
  //
  if GS.row = 0 then exit;
  TheTOBSelect := TOB(LaTOBAff.detail[GS.row-1].data);
  TToolbarButton97 (GetControl('BValider')).Click; 
end;

Initialization
  registerclasses ( [ TOF_BTPREPSELFAC_MUL ] ) ;
end.
