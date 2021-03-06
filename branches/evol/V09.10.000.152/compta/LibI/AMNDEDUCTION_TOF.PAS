{***********UNITE*************************************************
Auteur  ...... : TGA
Cr�� le ...... : 27/04/2006
Modifi� le ... : 02/06/2006
Description .. : Source TOF de la FICHE : AMNDEDUCTION ()
               : Saisie de l'affectation des DPI
Mots clefs ... : TOF;AMNDEDUCTION
// MVG 12/10/2006 FQ 18969
// MVG 12/10/2006 FQ 18970
// MVG 12/10/2006 FQ 18971       
*****************************************************************}
Unit AMNDEDUCTION_TOF ;

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
     MaineAGL,
{$ENDIF}
     ImEnt,
     forms,
     sysutils,
     ComCtrls,
     HCtrls,
     HEnt1,
     HMsgBox,
     HTB97,
     Vierge,
     uTOB,
     windows,
     UTOF ;

Type
  TOF_AMNDEDUCTION = Class (TOF)

    procedure OnArgument (S : String ) ; override;
    procedure OnAfterFormShowEcran;
    procedure OnUpdate ; override;

    private
    { Variables }
    FNatureDeduction : String;
    FDateDebut : TDateTime;
    FDateFin : TDateTime;
    FTotalSolde : Double;
    FEXO : array[0..5] of TDateTime;
    FDebn5 : TDateTime;
    FAncienMontant : Double;
    FAncienneDate : TDateTime;
    Fsavdate : String;
    Fcreation : Boolean;
    procedure OnbFermeClick(Sender: TObject);
    Function  ControleDuMontant :Boolean;
    Function  ControleDeLaDate  :Boolean;
    procedure OnGrilleKeyDown (Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure OnExitDE_DMTDPI(Sender:TObject);
  end ;

Function AMLanceFiche_MontantDPI(stCode: string):String;
Function AM_MONTANT_DPI_UTILISEE(Dinvest: TdateTime):Double;

Implementation

const
  HM: array[0..18] of string =
   ('D�duction pour investissement',
    'Affectation aux stocks',
    'Affectation aux parts de coop�ratives agricoles',
    'R�int�gration anticip�e',
    'La date d''investissement doit �tre comprise dans l''exercice en cours du tableau de suivi.',
    'Le montant affect� doit �tre diff�rent de ',
    'Le montant de la DPI ne peut �tre inf�rieur au montant de la DPI d�j� affect�',
    'Le montant de la DPI appliqu� ne peut pas d�passer ',
    'Voulez-vous enregistrer cette op�ration ?',
    'L''enregistrement de la DPI � �chou�.',
    'L''affectation aux stocks ',
    'L''affectation aux parts de coop�ratives agricoles ',
    'La r�int�gration anticip�e ',
    'a d�j� �t� r�alis�e pour l''exercice en cours du tableau de suivi.' + #13 + #10 +
    'Vous pouvez annuler cette affectation par la synth�se des DPI.',
    'Montant affect�' ,
    'Le montant de la DPI a �t� enti�rement affect�.',
    'L''affectation � une immobilisation sortie ',
    'Affectation � une immobilisation sortie',
    'Montant n�gatif');


{***********A.G.L.***********************************************
Auteur  ...... : TGA
Cr�� le ...... : 27/04/2006
Modifi� le ... :   /  /
Description .. :  Activation de la fen�tre DPI
Mots clefs ... :
*****************************************************************}
Function AMLanceFiche_MontantDPI(Stcode: string):String;
var
  Ok : Boolean;
  savcode,NatureDeduction: String;
  Solde : Double;
  DateDebut: TDateTime;
  DateFin: TDateTime;
  z : TdateTime;
  y : Integer;
  Q : Tquery;
begin
  Result :='0';
  Ok:=True;
  Savcode := Stcode;


  // D�codage des param�tres pass�
  NatureDeduction := ReadTokenSt(Stcode);
  Solde := StrToFloat(ReadTokenSt(Stcode));

  // Pour message compil
  IF ok=true Then
    DateDebut:=idate1900
  else
    DateDebut:=idate1900;
  DateFin:=DateDebut;
  // Fin pour message compil

  FOR y :=1 TO 12  DO
    DateDebut := StrToDate(ReadTokenSt(Stcode));

  // Pour message compil
  if (DateDebut<>idate1900) AND (DateFin<>idate1900) then
     ok:=True;
  // Fin pour message compil

  DateDebut := StrToDate(ReadTokenSt(Stcode));
  DateFin   := StrToDate(ReadTokenSt(Stcode));

  IF NatureDeduction <> 'DPI' THEN
    Begin

      If (Solde=0) Then
         Begin
           // dpi enti�rement affecte
           PGIBox(HM[15]);
           Ok:=False;
         End
      Else
         Begin
           // Contr�le si une DPI � d�j� �t� affect�e sur une m�me nature
           // � une m�me date d'investissement
           Q :=OpenSQL('SELECT * FROM IMMOMVTD WHERE IZ_NATURED="'+NatureDeduction+'"', FALSE) ;

           While Not Q.Eof do
              begin
                 z := StrToDate(Copy(Q.FindField('IZ_LIBELLE').AsString,1,10));
                 if (z >= DateDebut) AND (z <= DateFin) then
                    Begin
                      // Si affectation d�j� saisie on sort
                      If NatureDeduction= 'STC' THEN
                        Y:=10
                      Else If NatureDeduction= 'COO' THEN
                        Y:=11
                      Else If NatureDeduction= 'REI' THEN
                        Y:=12
                      Else // IMS
                        Y:=16;

                      // dpi d�j� r�alis�e pour l'exercice en cours du tableau de suivi.'
                      Ok:=False;
                      IF ok=False then
                        PGIBox(HM[y]+HM[13]);
                      exit;
                    End
                 Else
                   Q.Next ;
              End;
           Ferme(Q);
         end;
    End;

  If Ok=True Then
    result := AGLLanceFiche('AM', 'AMNDEDUCTION','' , '', Savcode);

end;


{***********A.G.L.***********************************************
Auteur  ...... : TGA
Cr�� le ...... : 27/04/2006
Modifi� le ... :   /  /
Description .. :  Pr�paration de la fen�tre DPI
Mots clefs ... :
*****************************************************************}
procedure TOF_AMNDEDUCTION.OnArgument (S: String ) ;
Var
    I : Integer;
    Q : Tquery;
begin
  Inherited ;

  // Initialisation
  FAncienMontant :=0;

  // R�cup�ration des param�tres d'entr�e
  // Param�tres en entr�e : Nature;Date d�but;Date fin; Total solde
  FNatureDeduction := ReadTokenSt(S);
  FTotalSolde  := StrToFloat(ReadTokenSt(S));
  FancienneDate:= StrToDate(ReadTokenSt(S));
  FExo[0] := StrToDate(ReadTokenSt(S));
  FancienneDate:= StrToDate(ReadTokenSt(S));
  FExo[1] := StrToDate(ReadTokenSt(S));
  FancienneDate:= StrToDate(ReadTokenSt(S));
  FExo[2] := StrToDate(ReadTokenSt(S));
  FancienneDate:= StrToDate(ReadTokenSt(S));
  FExo[3] := StrToDate(ReadTokenSt(S));
  FancienneDate:= StrToDate(ReadTokenSt(S));
  FExo[4] := StrToDate(ReadTokenSt(S));
  FDebn5  := StrToDate(ReadTokenSt(S));
  FExo[5] := StrToDate(ReadTokenSt(S));
  FDateDebut := StrToDate(ReadTokenSt(S));
  FDateFin   := StrToDate(ReadTokenSt(S));

  FancienneDate  := idate1900;

  // Pr�paration de la fen�tre
  TToolbarButton97(GetControl('BFerme')).Onclick := OnbFermeClick;
  TFVIERGE(ECRAN).retour := IntToStr(MrNo);
  TFVIERGE(ECRAN).OnAfterFormShow := OnAfterFormShowEcran;
  TFVIERGE(ECRAN).OnKeyDown := OnGrilleKeyDown;
  ThEdit(GetControl('DE_DMTDPI')).OnExit := OnExitDE_DMTDPI;

  // Affichage du titre de la fen�tre selon la nature
  If FNatureDeduction= 'DPI' THEN
     I:=0
  Else If FNatureDeduction= 'STC' THEN
     I:=1
  Else If FNatureDeduction= 'COO' THEN
     I:=2
  Else If FNatureDeduction= 'REI' THEN
     I:=3
  Else
     I:=17; // IMS
  TFVIERGE(ECRAN).Caption := HM[I];

  // Lecture de IMMOMVTD pour IZ_DATE = fin de l'exercice en cours
  Fcreation := True;
  Q :=OpenSQL('SELECT * FROM IMMOMVTD WHERE IZ_DATE="'+USDATETIME(FDateFin)+'"  AND ' +
                          'IZ_NATURED="'+FNatureDeduction+'"', FALSE) ;
  If Not Q.EOF Then
    Begin
      // Sauvegarde du montant et de la date
      FAncienMontant := Q.FindField('IZ_MONTANT').AsFloat;
      If (FNatureDeduction<> 'DPI') AND (Q.FindField('IZ_LIBELLE').AsString<>'') THEN
         FancienneDate  := StrToDate(Copy(Q.FindField('IZ_LIBELLE').AsString,1,10));
      Fcreation := False;
    End;
  Ferme(Q);

  // si nature DPI
  If (FNatureDeduction= 'DPI') THEN
    Begin
      // Affichage des dates d'exercice
      SetControlCaption('DE_DDEBEX',DateToStr(FDateDebut));
      SetControlCaption('DE_DFINEX',DateToStr(FDateFin));

      // Cache de la date d'investissement
      SetControlVisible('DE_DLABEL3', False);
      SetControlVisible('DE_DINVEST', False);

      // Affichage du montant de la DPI
      SetControlText('DE_DMTDPI',StrFMontant(FAncienMontant,15,V_PGI.OkDecV,'',True));

    End
  Else
    // si nature diff�rente de DPI
    Begin
      // on cache les dates d'exercice
      SetControlVisible('DE_DLABEL1', False);
      SetControlVisible('DE_DDEBEX', False);
      SetControlVisible('DE_DLABEL2', False);
      SetControlVisible('DE_DFINEX', False);

      // Affichage par d�faut date investissement = date fin d'exercice en cours du tableau
      SetControlText('DE_DINVEST',DateToStr(FDateFin));

      // Modification du libell� du montant
      SetControlCaption('DE_DLABEL4',HM[14]);
    End;
 End ;


{***********A.G.L.***********************************************
Auteur  ...... : TGA
Cr�� le ...... : 27/04/2006
Modifi� le ... :   /  /
Description .. :  Mise � Jour des masques apres affichage
Mots clefs ... :
*****************************************************************}
procedure TOF_AMNDEDUCTION.OnAfterFormShowEcran;
begin
  SetControlProperty('DE_DMTDPI','DisplayFormat',StrfMask(V_PGI.OkDecV,'', True));;
  //sauvegarde date pour test de modification
  Fsavdate := GetControlText('DE_DINVEST');
end;



{***********A.G.L.***********************************************
Auteur  ...... : TGA
Cr�� le ...... : 04/11/2005
Modifi� le ... :   /  /
Description .. : Affichage des montants de l'op�ration
Mots clefs ... :
*****************************************************************}
Procedure TOF_AMNDEDUCTION.OnExitDE_DMTDPI;
Var
  montant : double;
begin
   // R�cup�ration du montant de l'op�ration
  montant := Valeur(GetControlText('DE_DMTDPI'));
  SetControlText('DE_DMTDPI', StrFMontant(montant,15,V_PGI.OkDecV,'',True));
End;



{***********A.G.L.***********************************************
Auteur  ...... : TGA
Cr�� le ...... : 27/04/2006
Modifi� le ... :   /  /
Description .. : Sortie par validation
Mots clefs ... :
*****************************************************************}
procedure TOF_AMNDEDUCTION.OnUpdate;

var erreur  : Boolean;
    montant : Double;
    MTdpi : Double;
    MTaffecte : Double;
    MTdispo : Double;
    Q : Tquery;
    sequence : integer;
    I : integer;
    TLog : TOB;
begin
   Inherited ;

   erreur := ControleDeLaDate;
   IF erreur=True then
     Begin
       ecran.ModalResult :=mrNone;
       SetFocusControl('DE_DINVEST');
       exit;
     end;

   erreur := ControleDuMontant;
   IF erreur=True then
     Begin
       ecran.ModalResult :=mrNone;
       SetFocusControl('DE_DMTDPI');
       exit;
     end;

   // Mise � jour du montant selon la nature
   montant := Valeur(GetControlText('DE_DMTDPI'));

   IF FNatureDeduction = 'DPI' Then

      Begin
        IF montant = 0 Then
          Begin
            // Suppression de l'enreg dans IMMOMVTD si existant
            IF Fcreation = False Then
               executeSQL('DELETE FROM IMMOMVTD WHERE IZ_DATE="'+USDATETIME(FDateFin)+'"  AND ' +
                         'IZ_NATURED="'+FNatureDeduction+'"')
          End
        Else
          Begin

            BEGINTRANS ;
            try

              // Recherche dernier num�ro de s�quence pour la date de fin d'exercice
              sequence := 0 ;
              Q :=OpenSQL('SELECT * FROM IMMOMVTD WHERE IZ_DATE="'+USDATETIME(FDateFin)+'"', FALSE) ;
              try
                 While Not Q.Eof do
                   begin
                     IF Q.FindField('IZ_SEQUENCE').AsINTEGER > sequence THEN
                        sequence := Q.FindField('IZ_SEQUENCE').AsINTEGER;
                     Q.Next ;
                   End;
              finally
                Ferme(Q);
              End;

              // Mise � jour de IMMOMVTD
              Q :=OpenSQL('SELECT * FROM IMMOMVTD WHERE IZ_DATE="'+USDATETIME(FDateFin)+'"  AND ' +
                               'IZ_NATURED="'+FNatureDeduction+'"  ', FALSE) ;
              If Not Q.EOF Then
                // Mise � jour montant et date
                Begin
                  Q.Edit;
                  Q.FindField('IZ_MONTANT').AsFloat := montant ;
                  If (FNatureDeduction<> 'DPI') THEN
                     Q.FindField('IZ_LIBELLE').AsString := GetControlText('DE_DINVEST');
                  Q.Post;
                  Ferme(Q);
                End
              Else
                // Cr�ation complet de l'enreg
                Begin
                  TLog := TOB.Create ('IMMOMVTD',nil,-1);
                  try
                    TLog.PutValue('IZ_SEQUENCE', sequence + 1) ;
                    TLog.PutValue('IZ_DATE',Fdatefin) ;
                    TLog.PutValue('IZ_MONTANT',montant) ;
                    TLog.PutValue('IZ_NATURED',FnatureDeduction) ;
                    If (FNatureDeduction<> 'DPI') THEN
                       TLog.PutValue('IZ_LIBELLE',GetControlText('DE_DINVEST'));
                    TLog.InsertDB(nil);
                  finally
                    TLog.Free;
                  End;
                End;

            COMMITTRANS ;
            Except
              PGIBox(HM[9]);
              ROLLBACK ;
            End;
          End;
      End
   Else
      // Mise � jour des montants affect�s

      Begin
        for I := 5 downto 0 do
           Begin
             IF (montant<>0) AND (Fexo[i]<> idate1900) AND (Fexo[i]<FDateFin) Then
               // Affectation sur les exercices ant�rieurs
               Begin

                  // Recherche du montant de la DPI pour l'exercice concern�
                  Q :=OpenSQL('SELECT * FROM IMMOMVTD WHERE IZ_DATE="'+USDATETIME(Fexo[i])+'"  AND ' +
                             'IZ_NATURED="DPI"', FALSE) ;
                  If Not Q.EOF Then
                     MTdpi := Q.FindField('IZ_MONTANT').AsFloat
                  else
                     MTdpi :=0;

                  // Recherche des affectations de la DPI pour l'exercice concern�
                  MTaffecte := AM_MONTANT_DPI_UTILISEE(Fexo[i]);

                  // Dpi disponible
                  MTdispo := MTdpi - MTaffecte;

                  // Affectation si montant disponible
                  IF MTdispo<>0 THEN
                     Begin
                       BEGINTRANS ;
                       try

                         // Recherche dernier num�ro de s�quence pour la date de fin d'exercice
                         sequence := 0 ;
                         Q :=OpenSQL('SELECT * FROM IMMOMVTD WHERE IZ_DATE="'+USDATETIME(Fexo[i])+'"', FALSE) ;
                         try
                           While Not Q.Eof do
                             begin
                               IF Q.FindField('IZ_SEQUENCE').AsINTEGER > sequence THEN
                                  sequence := Q.FindField('IZ_SEQUENCE').AsINTEGER;
                               Q.Next ;
                             End;
                         finally
                           Ferme(Q);
                         End;

                         // Cr�ation de l'affectation
                         TLog := TOB.Create ('IMMOMVTD',nil,-1);
                         try
                           TLog.PutValue('IZ_SEQUENCE', sequence + 1) ;
                           TLog.PutValue('IZ_DATE',Fexo[i]) ;
                           IF montant > Mtdispo Then
                             Begin
                               TLog.PutValue('IZ_MONTANT',Mtdispo) ;
                               montant := montant - MTdispo
                             End
                           Else
                             Begin
                               TLog.PutValue('IZ_MONTANT',Montant) ;
                               montant := 0 ;
                             end;
                           TLog.PutValue('IZ_NATURED',FnatureDeduction) ;
                           TLog.PutValue('IZ_LIBELLE',GetControlText('DE_DINVEST'));
                           TLog.InsertDB(nil);
                         finally
                           TLog.Free;
                         End;

                       COMMITTRANS ;
                       Except
                         PGIBox(HM[9]);
                         ROLLBACK ;
                       End;

                     End;

               End;
           End;
      End;

   TFVIERGE(ECRAN).retour := IntToStr(MrYes);

End;


{***********A.G.L.***********************************************
Auteur  ...... : TGA
Cr�� le ...... : 27/04/2006
Modifi� le ... :   /  /
Description .. : Contr�le de la date d'investissement
Mots clefs ... :
*****************************************************************}
Function TOF_AMNDEDUCTION.ControleDeLaDate :Boolean;
var
  date_saisie: TdateTime;
begin

  result := False;
  // Ctl si nature <> DPI
  If (FNatureDeduction<> 'DPI') THEN
    Begin
      // La date d'investissement doit �tre comprise dans l'exercice du tableau de suivi
      date_saisie := StrToDate(GetControlText('DE_DINVEST'));
      if (date_saisie < FDateDebut) OR (date_saisie > FDateFin) then
        Begin
          PGIBox(HM[4]);
          result := True;
        End
    End;
end;


{***********A.G.L.***********************************************
Auteur  ...... : TGA
Cr�� le ...... : 27/04/2006
Modifi� le ... :   /  /
Description .. : Contr�le du montant de l'investissement
Mots clefs ... :
*****************************************************************}
Function TOF_AMNDEDUCTION.ControleDuMontant :Boolean;
var
   montant:Double;
   max:Double;
   i : Integer;
   com : double;
begin
   i :=0;
   com :=0;
   result := False;

   // R�cup�ration du montant de la d�duction saisi
   montant := Valeur(GetControlText('DE_DMTDPI'));

// MVG 12/10/2006 FQ 18970
   IF (Montant<0) then
   Begin
       PGIBox(HM[18]);
       Result:=true;
       exit;
   End;

     IF (FNatureDeduction ='DPI') Then
       // Controle du montant de la DPI par rapport � la DPI affect�
       Begin
         Max := AM_MONTANT_DPI_UTILISEE(FDateFin);
         IF montant < Max Then
           Begin
             i:=6;
             Com := Max;
           End;
         End
      Else
        // Controle de l'affectation de la DPI
       Begin
        // Ctl montant differend de 0
       IF montant=0 then
         i := 5
       Else
         Begin
           // Ctl mt < au maximum
           IF (montant > Ftotalsolde) then
             Begin
               i:=7;
               Com := Ftotalsolde;
             End;
         End;
     End;

   if (i<>0) Then
     Begin
       PGIBox(HM[i]+' '+StrFMontant(com,15,V_PGI.OkDecV,'',True)+'.');
       result:=True;
     end;
end;

{***********A.G.L.***********************************************
Auteur  ...... : TGA
Cr�� le ...... : 27/04/2006
Modifi� le ... :   /  /
Description .. : Sortie par la X sans validation
Mots clefs ... :
*****************************************************************}
procedure TOF_AMNDEDUCTION.OnbFermeClick(Sender: TObject);
Var montant : double;
    dd :String;
    question : TmodalResult;
begin

  dd := GetControlText('DE_DINVEST');
  montant:= valeur(GetControlText('DE_DMTDPI'));

  // Ctl si la saisie � �t� modifi�e
  IF (montant = FAncienMontant) AND (dd = FsavDate) THEN
    Begin
      // Pas de saisie on sort
      Ecran.ModalResult := mrNo;
    end
  Else
    Begin
     // Action Echap ou Fermer par la croix
     Question := PGIAskCancel(HM[8],Ecran.Caption);
     If Question = mrYes then
        // contr�le validation
        OnUpdate
     else If Question = mrNo then
        // Sortir
        Ecran.ModalResult := mrNo
     else
        // Cancel
        Ecran.ModalResult := mrNone;
    end
end;

{***********A.G.L.***********************************************
Auteur  ...... : TGA
Cr�� le ...... : 27/04/2006
Modifi� le ... :   /  /
Description .. : Test sur Touche F6 et F10
Mots clefs ... :
*****************************************************************}
procedure TOF_AMNDEDUCTION.OnGrilleKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_F6 : SetControlText('DE_DMTDPI',StrFMontant(FTotalSolde,15,V_PGI.OkDecV,'',True));
    VK_F10:
       begin
          OnUpdate;
          Ecran.ModalResult := 1;
       end;
  end;
end;


{***********A.G.L.***********************************************
Auteur  ...... : TGA
Cr�� le ...... : 27/04/2006
Modifi� le ... :   /  /
Description .. : Contr�le de l'utilisation de la DPI � une date fin d'exercice donn�e
Mots clefs ... :
*****************************************************************}
Function AM_MONTANT_DPI_UTILISEE(Dinvest: TdateTime):Double;
Var
  montant: Double;
  Q : Tquery;
Begin
  montant:=0;

  Q :=OpenSQL('SELECT * FROM IMMOMVTD WHERE IZ_DATE="'+USDATETIME(Dinvest)+
              '" AND IZ_NATURED<>"DPI"' , FALSE) ;
  try
    While Not Q.Eof do
      begin
        montant := montant + Q.FindField('IZ_MONTANT').AsFloat;
        Q.Next ;
      End;
  finally
    Ferme(Q);
  End;
  Result:=montant;

End;




Initialization
  registerclasses ( [ TOF_AMNDEDUCTION ] ) ;
end.


