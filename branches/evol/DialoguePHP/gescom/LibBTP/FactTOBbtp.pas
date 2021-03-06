unit FactTOBbtp;

interface

uses {$IFDEF VER150} variants,{$ENDIF} HEnt1, UTOB, UtilPGI, EntGC, SysUtils, Math, HCtrls;

procedure AddLesSupLignesBtp (TOBL : TOB ; Soeur : boolean);
procedure InitLesSupLigneBtp (TOBL : TOB);
procedure InitLesSupEnteteBtp (TOBPiece : TOB);

implementation

procedure InitLesSupEnteteBtp (TOBPiece : TOB);
begin
	if TOBPiece = nil then exit;
  if (not TOBPiece.FieldExists('_GERE_EN_STOCK')) then TOBPiece.AddChampsupValeur('_GERE_EN_STOCK', 'X', False);
  if VarIsNull(TOBPiece.GetValue('_GERE_EN_STOCK')) then TOBPiece.PutValue('_GERE_EN_STOCK', 'X');
  if (not TOBPiece.FieldExists('AFF_OKSIZERO')) then TOBPiece.AddChampsupValeur('AFF_OKSIZERO', '-',false);
  if VarIsNull(TOBPiece.GetValue('AFF_OKSIZERO')) then TOBPiece.PutValue('AFF_OKSIZERO', '-');
  if (not TOBPiece.FieldExists('_NEWFRAIS_')) then TOBPiece.AddChampsupValeur('_NEWFRAIS_', '-',false);
  if VarIsNull(TOBPiece.GetValue('_NEWFRAIS_')) then TOBPiece.PutValue('_NEWFRAIS_', '-');
end;

procedure AddLesSupLignesBtp (TOBL : TOB ; Soeur : boolean);
var Indice : integer;
begin
// MODIF LS Pour affichage montant de situation
	TOBL.AddChampSupValeur('MONTANTFACT',0,Soeur);
	TOBL.AddChampSupValeur('MONTANTSIT',0,Soeur);
//
	TOBL.AddChampSupValeur('_RUPTURE_AUTH_','-',Soeur);
  TOBL.AddChampSupValeur('INDICELIENDEVCHA', 0, Soeur);
//  TOBL.AddChampSupValeur('TPSUNITAIRE', 0, Soeur);
  TOBL.AddChampSupValeur('INDICEMETRE', 0, Soeur);
  TOBL.AddChampSupValeur('NUMCONSOPREC', 0, Soeur);
  TOBL.AddChampSupValeur('LIVREORIGINE',0,Soeur);
  TOBL.AddChampSupValeur('BLOBONE','-',Soeur);
  TOBL.AddChampSupValeur('MODIFIABLE','X',Soeur);
  // Cumul facture
  TOBL.AddChampSupValeur('OLD_QTESIT',0,Soeur);
  // MOdification avancement
  TOBL.AddChampSupValeur('DEJAFACT',0,Soeur);
  //
  (* Consommations *)
  TOBL.AddChampSupValeur('DIRECTFOU',0,Soeur);
  TOBL.AddChampSupValeur ('DPARECUPFROMRECEP',0,Soeur);

  TOBL.AddChampSupValeur ('_LIBREFLIVRFOU_','',Soeur);

  for Indice:= 0 to VH_GC.TOBParamTaxe.detail.count -1 do
  begin
     TOBL.addChampSupValeur ('MILLIEME'+IntToStr(indice+1),0);
     end;

  //Modif FV :  => gestion du regroupement sur piece
  //--si regroup� N� affaire = N� chantier sinon N� Affaire = N� Appel
  if not TOBL.FieldExists('GL_CHANTIER') then
  begin
    TOBL.AddChampSupValeur('GL_CHANTIER','',false);
  end else
  begin
    if (VarIsNull (TOBL.GetValue('GL_CHANTIER'))) or (VarAsType(TOBL.GetValue('GL_CHANTIER'),VarString)=#0) then
    begin
      TOBL.PutValue('GL_CHANTIER','')
    end;
  end;
  //
  if not TOBL.FieldExists('NEW_LIGNE') then
  begin
  	TOBL.AddChampSupValeur ('NEW_LIGNE','-') ;
  end;
  if not TOBL.FieldExists('UNIQUEBLO') then
  begin
  	TOBL.AddChampSupValeur ('UNIQUEBLO',0) ;
  end;

end;

procedure InitLesSupLigneBtp (TOBL : TOB);
var Indice : integer;
begin
	TOBL.PutValue('_RUPTURE_AUTH_','-');
  TOBL.PutValue('INDICELIENDEVCHA', 0);
//  TOBL.PutValue('TPSUNITAIRE', 0);
  TOBL.PutValue('INDICEMETRE', 0);
  TOBL.PutValue('NUMCONSOPREC', 0);
  TOBL.PutValue('LIVREORIGINE',0);
  TOBL.PutValue ('BCO_LIENTRANSFORME',0);
  TOBL.PutValue ('DPARECUPFROMRECEP',0);
  TOBL.Putvalue ('_LIBREFLIVRFOU_','');
  TOBL.PutValue('BLOBONE','-');
  TOBL.PutValue('MODIFIABLE','X');
//  TOBL.putValue('OLD_QTESIT',0);
//  TOBL.Putvalue('DEJAFACT',0);
//  TOBL.PutValue ('DPRRECUPFROMRECEP',0);
  for Indice:= 0 to VH_GC.TOBParamTaxe.detail.count -1 do
  begin
     TOBL.PutValue ('MILLIEME'+IntToStr(indice+1),0);
  end;
  // MODIF LS Pour affichage montant de situation
	TOBL.PutValue('MONTANTFACT',0);
	TOBL.PutValue('MONTANTSIT',0);
  //
end;

end.
