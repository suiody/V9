�
 TFLEVOPT 0�  TPF0�TFLevOptFLevOptLeft�Top� Caption   Levée d'optionClientHeight�OnCreate
FormCreatePixelsPerInch`
TextHeight �THPanelHPanel3Top� �TToolbarButton97bValiderLeftn  �TToolbarButton97ToolbarButton976Left�   �THPanelHPanel2Height� �	TGroupBox	GroupBox1HeightY  �	TGroupBox	GroupBox2Top\HeightqCaption-   Immobilisation issue de la levée de l'option �THLabelHLabel3Top  �THLabelHLabel4LeftTop,Width7HeightCaption&Code immo.FocusControlCODEIMMOFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  �THLabelHLabel5Left� Top,Width8HeightCaption   Dési&gnationFocusControlDESIGNATIONFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  �THLabelHLabel2LeftTopCWidthoHeightCaptionCompte d'&immobilisationFocusControl
COMPTEIMMOFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  �THLabelHLabel9LeftTopZWidth'HeightCaption&MontantFocusControlMONTANTLEVEEFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  �THCritMaskEditDATEOPELeft~Top  TEditCODEIMMOLeft~Top(WidthVHeightHint!   Code de l'immobilisation  crééeFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFontTabOrderTextCODEIMMO  TEditDESIGNATIONLeftTop(Width� HeightHint(   Désignation de l'immobilisation crééeFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFontTabOrderTextDESIGNATION  THCritMaskEdit
COMPTEIMMOLeft~Top?WidthUHeightHintCompte de l'immobilisationFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFontTabOrderOnExitCOMPTEIMMOExitTagDispatch ElipsisButton	ElipsisAutoHide	OnElipsisClickCOMPTEIMMOElipsisClick  	THNumEditMONTANTLEVEELeft~TopVWidthUHeightHint    Montant de la levée de l'optionDecimalsDigitsFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameMS Sans Serif
Font.Style Masks.PositiveMask#,##0.00Debit
ParentFontTabOrderUseRounding	Validate   �TPageControlPAGESLeftTop+Width�HeightkAlignalBottomTabOrder �	TTabSheet	PBLOCNOTE �THRichEditOLEIL_BLOCNOTEWidth�HeightO    	TGroupBox	GroupBox4LeftTop� Width�Height[Caption   Amortissement économiqueFont.CharsetDEFAULT_CHARSET
Font.ColorclNavyFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFontTabOrder THLabelHLabel10LeftTopWidthxHeightCaption   Méthode d'&amortissementFocusControlMETHODEAMORFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  THLabelHLabel11LeftTop-WidthSHeightCaption   Durée d'&utilisationFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  THLabelHLabel12LeftTopDWidthHeightCaption&TauxFocusControlTAUXECOFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  THLabelHLabel13Left� Top-WidthHeightCaptionmoisFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  	THNumEditTAUXECOLeft� Top@Width4HeightHint   Taux économiqueDecimalsDigitsEnabledFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameMS Sans Serif
Font.Style Masks.PositiveMask#,##0.00Debit
ParentFontTabOrderUseRounding	ValidateOnExitOnChangeMethode  THValComboBoxMETHODEAMORLeft� TopWidthtHeightHint   Méthode d'amortissementStylecsDropDownListFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameMS Sans Serif
Font.Style 
ItemHeight
ParentFontTabOrder OnChangeOnChangeMethodeTagDispatch PlusAND CO_CODE<>"VAR"DataTypeTIMETHODEIMMO  	TSpinEdit	DureeUtilLeft� Top)Width9HeightHint%   Durée de l'amortissement économiqueFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameMS Sans Serif
Font.Style MaxValue�MinValue 
ParentFontTabOrderValue OnExitOnChangeMethode    �THMsgBoxHMLeftHTop�  �THSystemMenuHMTradLeftxTop�  THMsgBoxHM2Police.CharsetDEFAULT_CHARSETPolice.ColorclWindowTextPolice.Height�Police.NameMS Sans SerifPolice.Style Mess.Strings;0;?Caption?;Vous devez renseigner toutes les zones;E;O;O;O;>1;?Caption?;Le compte d'immobilisation est incorrect.;E;O;O;O;O   2;?Caption?;Le montant de la levée de l'option ne doit pas être nul.;E;O;O;O;P   3;?Caption?;La durée d'amortissement doit être supérieure à 12 mois;E;O;O;O;Z   4;?Caption?;Ce crédit bail possède un dépôt de garantie. Est-il remboursé ?;Q;YN;N;N;e   5;?Caption?;Vous devez créer tous les comptes associés pour valider la levée de l'option.;W;O;O;O;z   6;?Caption?;La date de levée d'option est différente de la date de fin de contrat.#10#13Voulez-vous continuer?;Q;YN;Y;N;b   7;?caption?;La durée d'un amortissement dégressif doit être au moins égale à 36 mois;E;O;O;O;`   8;?caption?;La durée d'un amortissement linéaire doit être au moins égale à 1 mois;E;O;O;O;   Left� Top�   