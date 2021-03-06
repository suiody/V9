{***********UNITE*************************************************
Auteur  ...... : 
Cr�� le ...... : 15/09/2016
Modifi� le ... :   /  /
Description .. : Source TOF de la FICHE : BTSHAREY2 ()
Mots clefs ... : TOF;BTSHAREY2
*****************************************************************}
Unit BTSHAREY2_TOF ;

Interface

Uses StdCtrls, 
     Controls, 
     Classes, 
{$IFNDEF EAGLCLIENT}
     db, 
     {$IFNDEF DBXPRESS} dbtables, {$ELSE} uDbxDataSet, {$ENDIF} 
     mul, 
{$else}
     eMul, 
     uTob, 
{$ENDIF}
     forms, 
     sysutils, 
     ComCtrls,
     HCtrls, 
     HEnt1,
     HMsgBox,
     HTB97,
     Windows,
     messages,
     UTOF,
     URegenVues ;

Type
  TOF_BTSHAREY2 = Class (TOF)
    procedure OnNew                    ; override ;
    procedure OnDelete                 ; override ;
    procedure OnUpdate                 ; override ;
    procedure OnLoad                   ; override ;
    procedure OnArgument (S : String ) ; override ;
    procedure OnDisplay                ; override ;
    procedure OnClose                  ; override ;
    procedure OnCancel                 ; override ;
  private
    procedure EcritDatas;
    procedure BdeleteClick (Sender : Tobject); 
  end ;

Implementation

uses Math, TntStdCtrls;

procedure TOF_BTSHAREY2.OnNew ;
begin
  Inherited ;
end ;

procedure TOF_BTSHAREY2.OnDelete ;
begin
  Inherited ;
end ;

procedure TOF_BTSHAREY2.OnUpdate ;
begin
  Inherited ;
  if V_PGI.DBName = THValComboBox (GetControl('CBLISTDB')).text then
  begin
    PGIError ('Vous ne pouvez pas partager la base avec elle m�me ...');
    ecran.ModalResult := 0;
    exit;
  end;
  if PGIAsk('ATTENTION : Vous allez partager les donn�es avec une base de donn�e CEGID Y2.#13#10 Confirmez-vous ?') <> mryes then
  begin
    ecran.ModalResult := 0;
    exit;
  end;
  if PGIAsk('Confirmez-vous la mise en place avec la base de donn�e s�lectionn�e ?') <> mryes then
  begin
    ecran.ModalResult := 0;
    exit;
  end;
  if TRANSACTIONS (EcritDatas,0) = OeOk then
  begin
    PgiInfo ('Les donn�es sont � pr�sent partag�s avec la base de donn�e CEGID Y2 '+THValComboBox (GetControl('CBLISTDB')).Value+'.#13#10 Veuillez vous deconnecter de l''applicatif');
    PostMessage(Application.Handle, WM_CLOSE, 0, 0);
  end else
  begin
    PgiInfo ('ERREUR d''inscription du partage');
    ecran.Close;
  end;
end ;

procedure TOF_BTSHAREY2.OnLoad ;
begin
  Inherited ;
end ;

procedure TOF_BTSHAREY2.OnArgument (S : String ) ;
var QQ : TQuery;
begin
  Inherited ;
  if ExisteSQL('SELECT 1 FROM DESHARE') then
  begin
    TToolbarButton97 (GetControl('BDelete')).Visible := true;
    TToolbarButton97 (GetControl('BDelete')).OnClick := BdeleteClick;
  end;
  QQ := OpenSql ('SELECT NAME FROM SYSDATABASES WHERE DBID > 4',true,-1,'',true);
  if not QQ.eof then
  begin
    QQ.first;
    repeat
      THValComboBox (GetControl('CBLISTDB')).AddItem(QQ.fields[0].AsString,nil);
      qq.next;
    until QQ.eof;
  end;
  ferme (QQ);
end ;

procedure TOF_BTSHAREY2.OnClose ;
begin
  Inherited ;
end ;

procedure TOF_BTSHAREY2.OnDisplay () ;
begin
  Inherited ;
end ;

procedure TOF_BTSHAREY2.OnCancel () ;
begin
  Inherited ;                         
end ;

procedure TOF_BTSHAREY2.EcritDatas;
var DbName,SQL : string;
begin
  DBName := THValComboBox (GetControl('CBLISTDB')).Text;
  // PARAMSOC
  if ExecuteSQL('insert into deshare (ds_nomtable,ds_modefonc,ds_nombase,ds_typtable,ds_vue) select soc_nom,"LIB","'+DBName+'","PAR","" from paramsoc where soc_tree like "001;001;%"') = 0 then V_PGI.IOError := OeUnknown;
  if ExecuteSQL('insert into deshare (ds_nomtable,ds_modefonc,ds_nombase,ds_typtable,ds_vue) select soc_nom,"LIB","'+DBName+'","PAR","" from paramsoc where soc_tree like "001;027;%"') = 0 then V_PGI.IOError := OeUnknown;
  if ExecuteSQL('insert into deshare (ds_nomtable,ds_modefonc,ds_nombase,ds_typtable,ds_vue) select soc_nom,"LIB","'+DBName+'","PAR","" from paramsoc where soc_tree like "001;035;%"') = 0 then V_PGI.IOError := OeUnknown;
  if ExecuteSQL('insert into deshare (ds_nomtable,ds_modefonc,ds_nombase,ds_typtable,ds_vue) select soc_nom,"LIB","'+DBName+'","PAR","" from paramsoc where soc_tree like "001;012;%"') = 0 then V_PGI.IOError := OeUnknown;
  if ExecuteSQL('insert into deshare (ds_nomtable,ds_modefonc,ds_nombase,ds_typtable,ds_vue) select soc_nom,"LIB","'+DBName+'","PAR","" from paramsoc where soc_tree like "001;002;%"') = 0 then V_PGI.IOError := OeUnknown;
  if ExecuteSQL('insert into deshare (ds_nomtable,ds_modefonc,ds_nombase,ds_typtable,ds_vue) select soc_nom,"LIB","'+DBName+'","PAR","" from paramsoc where soc_tree like "001;023;%"') = 0 then V_PGI.IOError := OeUnknown;
  if ExecuteSQL('insert into deshare (ds_nomtable,ds_modefonc,ds_nombase,ds_typtable,ds_vue) select soc_nom,"LIB","'+DBName+'","PAR","" from paramsoc where soc_tree like "001;006;%"') = 0 then V_PGI.IOError := OeUnknown;
  if ExecuteSQL('insert into deshare (ds_nomtable,ds_modefonc,ds_nombase,ds_typtable,ds_vue) select soc_nom,"LIB","'+DBName+'","PAR","" from paramsoc where soc_tree like "001;005;%"') = 0 then V_PGI.IOError := OeUnknown;
  if ExecuteSQL('insert into deshare (ds_nomtable,ds_modefonc,ds_nombase,ds_typtable,ds_vue) select soc_nom,"LIB","'+DBName+'","PAR","" from paramsoc where soc_tree like "001;014;%"') = 0 then V_PGI.IOError := OeUnknown;
  if ExecuteSQL('insert into deshare (ds_nomtable,ds_modefonc,ds_nombase,ds_typtable,ds_vue) select soc_nom,"LIB","'+DBName+'","PAR","" from paramsoc where soc_tree like "001;031;%"') = 0 then V_PGI.IOError := OeUnknown;
  if ExecuteSQL('insert into deshare (ds_nomtable,ds_modefonc,ds_nombase,ds_typtable,ds_vue) select soc_nom,"LIB","'+DBName+'","PAR","" from paramsoc where soc_tree like "001;013;%"') = 0 then V_PGI.IOError := OeUnknown;
  if ExecuteSQL('insert into deshare (ds_nomtable,ds_modefonc,ds_nombase,ds_typtable,ds_vue) select soc_nom,"LIB","'+DBName+'","PAR","" from paramsoc where soc_tree like "001;018;%"') = 0 then V_PGI.IOError := OeUnknown;
  if ExecuteSQL('insert into deshare (ds_nomtable,ds_modefonc,ds_nombase,ds_typtable,ds_vue) select soc_nom,"LIB","'+DBName+'","PAR","" from paramsoc where soc_tree like "001;021;%"') = 0 then V_PGI.IOError := OeUnknown;
  // TABLES
  SQL := 'insert into deshare (ds_nomtable,ds_modefonc,ds_nombase,ds_typtable,ds_vue) '+
  			 'select dt_nomtable ,"LIB","'+DBName+'","TAB","" '+
         'from detables '+
         'where dt_domaine IN ("C","P","Y","T","D","0") AND DT_NOMTABLE NOT IN ("RTDOCUMENT","RESSOURCEEQUIPE","RESSOURCEPR","CHOIXCOD","CHOIXEXT","EXERCICE","YMYBOBS")';
  if EXECUTESQL(SQL)=0 then V_PGI.IOError := OeUnknown;
  // Tablettes CHOIXCOD et CHOIXEXT
  if EXECUTESQL('insert into deshare (ds_nomtable,ds_modefonc,ds_nombase,ds_typtable,ds_vue) select do_combo ,"LIB","'+DBName+'","TTE","" from decombos where do_domaine in ("C","P","Y","T","D","0")  and do_prefixe in ("CC","YX")')=0 then V_PGI.IOError := OeUnknown;
  // EXERCICE
  if EXECUTESQL('insert into deshare (ds_nomtable,ds_modefonc,ds_nombase,ds_typtable,ds_vue) values ("EXERCICE","LIB","'+DBName+'","TAB","")')=0 then V_PGI.IOError := OeUnknown;
  // SOCIETE
  if EXECUTESQL('insert into deshare (ds_nomtable,ds_modefonc,ds_nombase,ds_typtable,ds_vue) values ("SOCIETE","LIB","'+DBName+'","TAB","")')=0 then V_PGI.IOError := OeUnknown;
  // COMPTEURS
  if EXECUTESQL('insert into deshare (ds_nomtable,ds_modefonc,ds_nombase,ds_typtable,ds_vue) values ("DESEQUENCES","LIB","'+DBName+'","TAB","")')=0 then V_PGI.IOError := OeUnknown;
//  RegenereVues;
end;

procedure TOF_BTSHAREY2.BdeleteClick(Sender: Tobject);
begin
  if PGIAsk('ATTENTION : Vous allez casser le lien entre la base de donn�e Y2 et cette base de donn�e.#13#10 Confirmez-vous cette action ?')<>mryes then exit;
  if PGIAsk('Confirmez-vous la suppression de ce lien ?')<>mryes then exit;
  ExecuteSQL('DELETE FROM DESHARE');
//  RegenereVues;
  PgiInfo ('Les donn�es ne sont plus partag�s avec la base de donn�e CEGID Y2 '+THValComboBox (GetControl('CBLISTDB')).Value+'.#13#10 Veuillez vous deconnecter de l''applicatif');
  PostMessage(Application.Handle, WM_CLOSE, 0, 0);
end;

Initialization
  registerclasses ( [ TOF_BTSHAREY2 ] ) ;
end.
