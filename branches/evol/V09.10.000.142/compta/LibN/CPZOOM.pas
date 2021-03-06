unit CPZOOM;

interface

uses
     Forms
     , SysUtils
     , HEnt1
     , HCtrls
     , AGLInit
     {$IFDEF EAGLCLIENT}
     {$ELSE}
     {$IFNDEF DBXPRESS} , dbtables {$ELSE}, uDbxDataSet {$ENDIF}
     {$ENDIF}
     , CritEdt
     , UtilEdt
     , SaisUtil
     , SaisComm
     , Saisie
     , SaisBor
     , SaisODA
      {$IFNDEF CCMP}
     , eSaisBud
     , BUDGENE_TOM
     , BUDSECT_TOM
     {$ENDIF CCMP}
     , Lettrage
     {$IFDEF AMORTISSEMENT}
     , IMMO_TOM
     {$ENDIF}
     , CPGENERAUX_TOM
     , CPTIERS_TOM
     , CPSECTION_TOM
     , CPJOURNAL_TOM
     , uTofCPGLGENE;

Type Tab10Str = Array[1..10] Of String ;

{$IFDEF AMORTISSEMENT}
procedure ZoomEdtImmo(Qui : Integer ; Quoi : String) ;
Procedure ZoomEdtEtatImmo(Quoi : String) ;
{$ENDIF}
Procedure ZoomEdtEtat(Quoi : String) ;
Procedure ZoomEdt(Qui : Integer ; Quoi : String) ;

implementation

uses
  {$IFDEF MODENT1}
  CPTypeCons,
  CPProcMetier,
  {$ENDIF MODENT1}
  Ent1,
  UtilPGI;


procedure QuellePiece ( StAuto : String ; Var Tab : Tab10Str ) ;
Var StA,StC : String ;
    i    : integer ;
BEGIN
StA:=StAuto ; i:=0 ; Fillchar(Tab,SizeOf(Tab),#0) ;
Repeat
 StC:=ReadTokenSt(StA) ;
 if StC<>'' then
    BEGIN
    Inc(i) ; Tab[i]:=StC ;
    END ;
Until (StC='') ;
END ;

{$IFDEF AMORTISSEMENT}
procedure ZoomEdtImmo(Qui : Integer ; Quoi : String) ;
begin
  case Qui of
    91 : AMLanceFiche_FicheImmobilisation(Quoi,taConsult,'');
    92 : FicheGene(nil,'',Quoi,taConsult,0) ;
  end;
  Screen.Cursor:=SyncrDefault ;
end;

Procedure ZoomEdtEtatImmo(Quoi : String) ;
var i,Qui: Integer ;
begin
  i := Pos(';',Quoi);
  Qui := StrToInt (Copy (Quoi,1,i-1));
  Quoi:=Copy(Quoi,i+1,Length(Quoi)-i) ;
  ZoomEdtImmo(Qui,Quoi) ;
end;
{$ENDIF}

Procedure ZoomEdtEtat(Quoi : String) ;
var i: Integer ;
BEGIN
i:=StrToInt(Copy(Quoi,1,1)) ;
Quoi:=Copy(Quoi,3,Length(Quoi)-2) ;
ZoomEdt(i,Quoi) ;
END ;


Procedure ZoomEdt(Qui : Integer ; Quoi : String) ;
{$IFNDEF IMP}
Var St,St1 : String ;
    Lefb : TFichierBase ;
    ll,Lp : Integer ;
    Q : TQuery ;
    Trouv : Boolean ;
    Tab : Tab10Str ;
    M : RMvt ;
    R : RLettR ;
    DD : TDateTime ;
    JalP : String ;
    StNumP,StNumL : String ;
//{$IFNDEF IMP}
    P  : RParFolio ;
{$IFNDEF CCMP}
    D1,D2 : TDateTime ;
    Lp2 : Integer ;
    ACritEdt : ClassCritEdt;
{$ENDIF}
{$ENDIF}
BEGIN
{$IFNDEF IMP}
Case Qui Of
  1 : BEGIN
      St:=Copy(Quoi,1,VH^.Cpta[fbGene].Lg);
      FicheGene(Nil,'',St,taConsult,0);
      END ;
  2 : BEGIN
      St:=Copy(Quoi,1,VH^.Cpta[fbAux].Lg) ;
      FicheTiers(Nil,'',St,taConsult,1);
      END ;
  3 : BEGIN
        Lp:=Pos('@',Quoi) ;
        // GCO - 28/11/2006 - FQ 18927
        if Lp <> 0 Then
        begin
          St   := Quoi ;
          St1  := Copy(Quoi,Lp+2,2);
          LeFb := AxeToFb(St1);
          St:=Copy(Quoi,1,VH^.Cpta[Lefb].Lg) ;
        end
        else
        begin
          St  := ReadTokenSt(Quoi); // Section
          St1 := ReadTokenSt(Quoi); // Axe
        end;
        // FIN GCO
        FicheSection(Nil,St1,st,taConsult,0) ;
      END ;
  4 : BEGIN
      St:=Quoi ; ll:=Pos(' ',St) ; If ll>0 Then St:=Copy(St,1,ll-1) ;
      FicheJournal(Nil,'',st,taConsult,0) ;
      END ;
  5 : BEGIN { Zoom Pi�ce }
      QuellePiece(Quoi,tab) ;
      If PieceSurFolio(Tab[1]) Then
        BEGIN
        Q:=OpenSQL('Select E_DATECOMPTABLE from Ecriture where E_JOURNAL="'+Tab[1]+'"'
                  +' AND E_EXERCICE="'+Tab[4]+'"'
                  +' AND E_DATECOMPTABLE="'+Tab[2]+'"'
                  +' AND E_NUMEROPIECE='+Tab[3],True) ;
        If Not Q.Eof Then
          BEGIN
          DD:=Q.Fields[0].AsDateTime ;
          Ferme(Q) ;
          FillChar(P, Sizeof(P), #0) ;
          P.ParPeriode:=DateToStr(DD) ;
          P.ParCodeJal:=Tab[1] ;
          P.ParNumFolio:=Tab[3] ;
          P.ParNumLigne:=StrToInt(Tab[5]) ;
          ChargeSaisieFolio(P, taConsult) ;
          END Else Ferme(Q) ;
        END Else
        BEGIN
        Q:=OpenSQL('SELECT ' + SQLForIdent( fbGene ) + ' FROM ECRITURE WHERE E_JOURNAL="'+Tab[1]+'"'
                  +' AND E_EXERCICE="'+Tab[4]+'"'
                  +' AND E_DATECOMPTABLE="'+Tab[2]+'"'
                  +' AND E_NUMEROPIECE='+Tab[3],True) ;
        Trouv:=Not Q.EOF ; if Trouv then M:=MvtToIdent(Q,fbGene,False) ; Ferme(Q) ;
        M.NumLigVisu:=StrToInt(Tab[5]) ;
  //      if Trouv then ZoomSaisie(M) ; ZoomSaisie n'est plus maintenue ...
        if Trouv then LanceSaisie(Nil,taConsult,M) ;
        END ;
      END ;
  6 : BEGIN { ZoomLettrage }
      QuellePiece(Quoi,tab) ;
      Q:=OpenSQL('Select E_GENERAL, E_AUXILIAIRE, E_DEVISE, E_LETTRAGE, E_LETTRAGEDEV from Ecriture where E_JOURNAL="'+Tab[1]+'"'
                +' AND E_EXERCICE="'+Tab[4]+'"'
                +' AND E_DATECOMPTABLE="'+Tab[2]+'"'
                +' AND E_NUMEROPIECE='+Tab[3]
                +' AND E_NUMLIGNE='+Tab[5],True) ;
      Trouv:=Not Q.EOF ;
      if Trouv then
         BEGIN
         FillChar(R,Sizeof(R),#0) ;
         R.General:=Q.Fields[0].AsString ; R.Auxiliaire:=Q.Fields[1].AsString ;
         R.CritDev:=Q.Fields[2].AsString ; R.GL:=NIL ; R.CritMvt:='' ; R.Appel:=tlMenu ;
         R.CodeLettre:=Q.Fields[3].AsString ; R.DeviseMvt:=R.CritDev ;
         R.LettrageDevise:=(Q.Fields[4].AsString='X') ;
         END ;
      Ferme(Q) ;
      If Trouv Then LettrageManuel(R,False,taConsult) ;
      END ;
  7 : BEGIN { Zoom Pi�ce analytique }
{$IFNDEF CCMP}
      QuellePiece(Quoi,tab) ;
      Q:=OpenSQL('SELECT ' + SQLForIdent( fbSect ) + ' FROM ANALYTIQ WHERE Y_JOURNAL="'+Tab[1]+'"'
                +' AND Y_EXERCICE="'+Tab[4]+'"'
                +' AND Y_DATECOMPTABLE="'+Tab[2]+'"'
                +' AND Y_NUMEROPIECE='+Tab[3]
                +' AND Y_NUMLIGNE='+Tab[5]
                {b FP FQ16854}
                //+' AND Y_AXE="'+Tab[6]+'"',True) ;
                +' AND '+TSQLAnaCroise.ConditionAxe(Tab[6]),True) ;
                {e FP FQ16854}
      Trouv:=Not Q.EOF ; if Trouv then M:=MvtToIdent(Q,fbSect,False) ; Ferme(Q) ;
      //M.NumLigVisu:=StrToInt(Tab[5]) ;
      if Trouv then LanceSaisieODA(Nil,taConsult,M) ;
{$ENDIF}
      END ;
  8 : BEGIN
{$IFNDEF CCMP}
      Lp:=Pos(' ',Quoi) ;
      St:=Copy(Quoi,1,Lp-1) ;
      FicheBudgene(Nil,'',St,taConsult,0) ;
{$ENDIF}
      END ;
  9 : BEGIN
{$IFNDEF CCMP}
      Lp:=Pos('@',Quoi) ; Lp2:=Pos(' ',Quoi) ;
      If Lp=0 Then Exit ;
      St:=Quoi ; St1:=Copy(Quoi,Lp+2,2) ; //LeFb:=AxeToFbBud(St1) ;
      St:=Copy(Quoi,1,Lp2-1) ;
      FicheBudsect(Nil,St1,st,taConsult,0) ;
{$ENDIF}
      END ;
  10 : BEGIN { Zoom Budecr }
{$IFNDEF CCMP}
      QuellePiece(Quoi,tab) ;
      Q:=OpenSQL('Select * from BUDECR where BE_BUDJAL="'+Tab[1]+'"'
                +' AND BE_EXERCICE="'+Tab[4]+'"'
                +' AND BE_DATECOMPTABLE="'+Tab[2]+'"'
                +' AND BE_NUMEROPIECE='+Tab[3],True) ;
      Trouv:=Not Q.EOF ;
      if Trouv then TrouveEtLanceSaisBud(Q,taconsult) ;
      Ferme(Q) ;
{$ENDIF}
      END ;
  11 : BEGIN { Zoom Facture avec TP }
      QuellePiece(Quoi,tab) ;
      If VH^.OuiTP And ((Tab[1]=VH^.JalVTP) Or (Tab[1]=VH^.JalATP)) Then
        BEGIN
        Q:=OpenSQL('Select E_PIECETP from Ecriture where E_JOURNAL="'+Tab[1]+'"'
                  +' AND E_EXERCICE="'+Tab[4]+'"'
                  +' AND E_DATECOMPTABLE="'+Tab[2]+'"'
                  +' AND E_NUMEROPIECE='+Tab[3],True) ;
        If Not Q.Eof Then
          BEGIN
          St:=Q.Fields[0].AsString ;
          St1:=ReadTokenSt(St) ;
          St1:=ReadTokenSt(St) ; StNumP:=St1 ;
          St1:=ReadTokenSt(St) ; StNumL:=St1 ;
          St1:=ReadTokenSt(St) ;
          St1:=ReadTokenSt(St) ; JalP:=St1 ;
          Tab[1]:=JalP ; Tab[3]:=StNumP ; Tab[5]:=StNumL ;
          END ;
        Ferme(Q) ;
        END ;
      Q:=OpenSQL('SELECT ' + SQLForIdent( fbGene ) + ' FROM ECRITURE WHERE E_JOURNAL="'+Tab[1]+'"'
                +' AND E_EXERCICE="'+Tab[4]+'"'
                +' AND E_DATECOMPTABLE="'+Tab[2]+'"'
                +' AND E_NUMEROPIECE='+Tab[3],True) ;
      Trouv:=Not Q.EOF ; if Trouv then M:=MvtToIdent(Q,fbGene,False) ; Ferme(Q) ;
      M.NumLigVisu:=StrToInt(Tab[5]) ;
      if Trouv then LanceSaisie(Nil,taConsult,M) ;
      END ;
  100 : BEGIN { GL pour justif centralisation }
{$IFNDEF CCMP}
        QuellePiece(Quoi,tab) ;
        ACritEdt := ClassCritEdt.Create;
        Fillchar(ACritEdt.CritEdt, SizeOf(ACritEdt.CritEdt), #0);
        D1:=StrToDate(Tab[3]) ; D2:=StrToDate(Tab[4]) ;
        ACritEdt.CritEdt.Date1:=D1 ; ACritEdt.CritEdt.Date2:=D2 ;
        ACritEdt.CritEdt.DateDeb:=ACritEdt.CritEdt.Date1 ;
        ACritEdt.CritEdt.DateFin:=ACritEdt.CritEdt.Date2 ;
        ACritEdt.CritEdt.GL.ForceNonCentralisable:=TRUE ;
        ACritEdt.CritEdt.Cpt1:=Tab[1] ; ACritEdt.CritEdt.Cpt2:=ACritEdt.CritEdt.Cpt1 ;
        ACritEdt.CritEdt.SQLPLUS:='AND E_JOURNAL="'+TAB[2]+'"' ;
        TheData := ACritEdt;
        CPLanceFiche_CPGLGene('');
        TheData := nil;
{$ENDIF}
        END ;
  END ;
Screen.Cursor:=SyncrDefault ;
{$ENDIF}
END ;

end.
 