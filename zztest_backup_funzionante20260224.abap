REPORT zztest.

TABLES: eanl, sscrfields.

* --- 1. DICHIARAZIONI GLOBALI ---
TYPE-POOLS: vrm.

CLASS lcl_events DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS on_link_click FOR EVENT link_click OF cl_salv_events_table
      IMPORTING row column.
ENDCLASS.

TYPES: BEGIN OF ty_output,
         partner   TYPE but000-partner,
         cognome   TYPE but000-name_last,
         nome      TYPE but000-name_first,
         vstelle   TYPE eanl-vstelle,
         vkont     TYPE fkkvkp-vkont,
         vertrag   TYPE ever-vertrag,
         anlage    TYPE eanl-anlage,
         anlart    TYPE eanl-anlart,
         text_imp  TYPE te439t-text30,
         equipment TYPE equi-equnr,
         n_serie   TYPE equi-sernr,
         fine_val2 TYPE egerh-bis,
       END OF ty_output.

DATA: lt_risultato TYPE STANDARD TABLE OF ty_output WITH EMPTY KEY.

DATA: gv_ucomm TYPE sy-ucomm.


" NOTA: NON DICHIARARE tab1, tab2, bt_eanl, ar1, ecc. qui con DATA.
" SAP le crea automaticamente tramite la definizione SELECTION-SCREEN.

* --- 2. DEFINIZIONE SCHERMO (TABS) ---
SELECTION-SCREEN BEGIN OF TABBED BLOCK mytabs FOR 30 LINES.
  SELECTION-SCREEN TAB (20) tab1 USER-COMMAND uline1 DEFAULT SCREEN 101.
  SELECTION-SCREEN TAB (20) tab2 USER-COMMAND uline2 DEFAULT SCREEN 104.
  SELECTION-SCREEN TAB (20) tab3 USER-COMMAND uline3 DEFAULT SCREEN 103.
  " SELECTION-SCREEN TAB (15) tab4 USER-COMMAND uline4 DEFAULT SCREEN 102.
SELECTION-SCREEN END OF BLOCK mytabs.

* --- TAB 1: RICERCA & MAPPA TABELLE ---
SELECTION-SCREEN BEGIN OF SCREEN 101 AS SUBSCREEN.
  SELECTION-SCREEN SKIP 1.

  " 1. Parte Ricerca
  SELECTION-SCREEN BEGIN OF BLOCK b_filt WITH FRAME TITLE tit1.
    SELECT-OPTIONS impianti FOR eanl-anlage.
  SELECTION-SCREEN END OF BLOCK b_filt.

  " 2. Parte Mappa
  SELECTION-SCREEN BEGIN OF BLOCK b_map WITH FRAME TITLE t_map.
    SELECTION-SCREEN BEGIN OF LINE.
      SELECTION-SCREEN PUSHBUTTON 1(10) bt_eanl USER-COMMAND m_eanl.
      SELECTION-SCREEN COMMENT 12(15) ar1.
      SELECTION-SCREEN PUSHBUTTON 28(10) bt_te43 USER-COMMAND m_te43.
      SELECTION-SCREEN COMMENT 39(20) tx1.
    SELECTION-SCREEN END OF LINE.
    SELECTION-SCREEN BEGIN OF LINE.
      SELECTION-SCREEN COMMENT 5(2) vl1.
      SELECTION-SCREEN COMMENT 32(2) vl2.
    SELECTION-SCREEN END OF LINE.
    SELECTION-SCREEN BEGIN OF LINE.
      SELECTION-SCREEN PUSHBUTTON 1(10) bt_ever USER-COMMAND m_ever.
      SELECTION-SCREEN COMMENT 12(15) ar2.
      SELECTION-SCREEN PUSHBUTTON 28(10) bt_east USER-COMMAND m_east.
      SELECTION-SCREEN COMMENT 39(20) tx2.
    SELECTION-SCREEN END OF LINE.
    SELECTION-SCREEN BEGIN OF LINE.
      SELECTION-SCREEN COMMENT 5(2) vl3.
      SELECTION-SCREEN COMMENT 32(2) vl4.
    SELECTION-SCREEN END OF LINE.
    SELECTION-SCREEN BEGIN OF LINE.
      SELECTION-SCREEN PUSHBUTTON 1(10) bt_fkk USER-COMMAND m_fkk.
      SELECTION-SCREEN COMMENT 12(15) ar3.
      SELECTION-SCREEN PUSHBUTTON 28(10) bt_eger USER-COMMAND m_eger.
      SELECTION-SCREEN COMMENT 39(20) tx3.
    SELECTION-SCREEN END OF LINE.
    SELECTION-SCREEN BEGIN OF LINE.
      SELECTION-SCREEN COMMENT 5(2) vl5.
      SELECTION-SCREEN COMMENT 32(2) vl6.
    SELECTION-SCREEN END OF LINE.
    SELECTION-SCREEN BEGIN OF LINE.
      SELECTION-SCREEN PUSHBUTTON 1(10) bt_but USER-COMMAND m_but.
      SELECTION-SCREEN COMMENT 12(15) ar4.
      SELECTION-SCREEN PUSHBUTTON 28(10) bt_equi USER-COMMAND m_equi.
      SELECTION-SCREEN COMMENT 39(20) tx4.
    SELECTION-SCREEN END OF LINE.
  SELECTION-SCREEN END OF BLOCK b_map.
SELECTION-SCREEN END OF SCREEN 101.


SELECTION-SCREEN BEGIN OF SCREEN 103 AS SUBSCREEN.
  SELECTION-SCREEN SKIP 1.
  SELECTION-SCREEN BEGIN OF LINE.
    SELECTION-SCREEN COMMENT 1(15) c1.
    SELECTION-SCREEN PUSHBUTTON 18(10) b_cic USER-COMMAND on.
    SELECTION-SCREEN PUSHBUTTON 29(10) b_se11 USER-COMMAND f_se11.
    SELECTION-SCREEN PUSHBUTTON 40(10) b_16 USER-COMMAND f_16.
    SELECTION-SCREEN PUSHBUTTON 51(12) b_exp USER-COMMAND export.
  SELECTION-SCREEN END OF LINE.
  SELECTION-SCREEN BEGIN OF LINE.
    SELECTION-SCREEN COMMENT 1(15) c2.
    SELECTION-SCREEN PUSHBUTTON 18(10) b_test USER-COMMAND b_test.
    SELECTION-SCREEN PUSHBUTTON 29(10) b_test2 USER-COMMAND b_test2.
    SELECTION-SCREEN PUSHBUTTON 40(12) b_help USER-COMMAND open_url.
    SELECTION-SCREEN PUSHBUTTON 53(16) b_note USER-COMMAND open_note.
  SELECTION-SCREEN END OF LINE.
  SELECTION-SCREEN BEGIN OF LINE.
        SELECTION-SCREEN COMMENT 1(15) c3.
        SELECTION-SCREEN PUSHBUTTON 18(16) b_bp USER-COMMAND f_mara.
    SELECTION-SCREEN END OF LINE.
  SELECTION-SCREEN SKIP 1.
  SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE gv_title.
    PARAMETERS: scegli TYPE char40 AS LISTBOX VISIBLE LENGTH 45 USER-COMMAND combo.
  SELECTION-SCREEN END OF BLOCK bl1.
SELECTION-SCREEN END OF SCREEN 103.

* --- TAB 2: CONSOLE INTEGRATA COMPLETA in base ai miei appunti ---
SELECTION-SCREEN BEGIN OF SCREEN 104 AS SUBSCREEN.

  " 1. IS-U Master & Letture
  SELECTION-SCREEN BEGIN OF BLOCK b4_1 WITH FRAME TITLE t4_1.
    SELECTION-SCREEN BEGIN OF LINE.
      SELECTION-SCREEN PUSHBUTTON 1(8) b_es31 USER-COMMAND t_es31.
      SELECTION-SCREEN PUSHBUTTON 10(8) b_es32 USER-COMMAND t_es32.
      SELECTION-SCREEN PUSHBUTTON 19(8) b_el01 USER-COMMAND t_el01.
      SELECTION-SCREEN PUSHBUTTON 28(8) b_el31 USER-COMMAND t_el31.
      SELECTION-SCREEN PUSHBUTTON 37(8) b_el37 USER-COMMAND t_el37.
      SELECTION-SCREEN PUSHBUTTON 46(8) b_el28 USER-COMMAND t_el28.
    SELECTION-SCREEN END OF LINE.
    SELECTION-SCREEN BEGIN OF LINE.
      SELECTION-SCREEN COMMENT 1(10) c_t1.
      SELECTION-SCREEN PUSHBUTTON 12(10) b4_eanl  USER-COMMAND m_eanl.
      SELECTION-SCREEN PUSHBUTTON 23(10) b4_eanlh USER-COMMAND m_eanlh.
    SELECTION-SCREEN END OF LINE.
  SELECTION-SCREEN END OF BLOCK b4_1.

  " 2. IS-U Apparecchiature
  SELECTION-SCREEN BEGIN OF BLOCK b4_2 WITH FRAME TITLE t4_2.
    SELECTION-SCREEN BEGIN OF LINE.
      SELECTION-SCREEN PUSHBUTTON 1(8) b_eg30 USER-COMMAND t_eg30.
      SELECTION-SCREEN PUSHBUTTON 10(8) b_eg34 USER-COMMAND t_eg34.
      SELECTION-SCREEN PUSHBUTTON 19(8) b_eg35 USER-COMMAND t_eg35.
      SELECTION-SCREEN PUSHBUTTON 28(8) b_eg50 USER-COMMAND t_eg50.
      SELECTION-SCREEN PUSHBUTTON 37(8) b_iq01 USER-COMMAND t_iq01.
      SELECTION-SCREEN PUSHBUTTON 46(8) b_iq03 USER-COMMAND t_iq03.
    SELECTION-SCREEN END OF LINE.
    SELECTION-SCREEN BEGIN OF LINE.
      SELECTION-SCREEN COMMENT 1(10) c_t2.
      SELECTION-SCREEN PUSHBUTTON 12(10) b4_equi  USER-COMMAND m_equi.
      SELECTION-SCREEN PUSHBUTTON 23(10) b4_sost  USER-COMMAND m_sost.
    SELECTION-SCREEN END OF LINE.
  SELECTION-SCREEN END OF BLOCK b4_2.

  " 3. Fatturazione
  SELECTION-SCREEN BEGIN OF BLOCK b4_3 WITH FRAME TITLE t4_3.
    SELECTION-SCREEN BEGIN OF LINE.
      SELECTION-SCREEN PUSHBUTTON 1(8) b_ea00 USER-COMMAND t_ea00.
      SELECTION-SCREEN PUSHBUTTON 10(8) b_ea05 USER-COMMAND t_ea05.
      SELECTION-SCREEN PUSHBUTTON 19(8) b_ea19 USER-COMMAND t_ea19.
      SELECTION-SCREEN PUSHBUTTON 28(8) b_ea20 USER-COMMAND t_ea20.
      SELECTION-SCREEN PUSHBUTTON 37(8) b_ea40 USER-COMMAND t_ea40.
      SELECTION-SCREEN PUSHBUTTON 46(8) b_ea60 USER-COMMAND t_ea60.
    SELECTION-SCREEN END OF LINE.
    SELECTION-SCREEN BEGIN OF LINE.
      SELECTION-SCREEN COMMENT 1(10) c_t3.
      SELECTION-SCREEN PUSHBUTTON 12(10) b4_erdk  USER-COMMAND m_erdk.
    SELECTION-SCREEN END OF LINE.
  SELECTION-SCREEN END OF BLOCK b4_3.

  " 4. Manutenzione
  SELECTION-SCREEN BEGIN OF BLOCK b4_4 WITH FRAME TITLE t4_4.
    SELECTION-SCREEN BEGIN OF LINE.
      SELECTION-SCREEN PUSHBUTTON 1(8) b_iw33 USER-COMMAND t_iw33.
      SELECTION-SCREEN PUSHBUTTON 10(8) b_iw52 USER-COMMAND t_iw52.
      SELECTION-SCREEN PUSHBUTTON 19(8) b_iw53 USER-COMMAND t_iw53.
    SELECTION-SCREEN END OF LINE.
        SELECTION-SCREEN BEGIN OF LINE.
      SELECTION-SCREEN COMMENT 1(10) c_t4.
      SELECTION-SCREEN PUSHBUTTON 12(10) b4_qmel  USER-COMMAND m_qmel.
    SELECTION-SCREEN END OF LINE.
  SELECTION-SCREEN END OF BLOCK b4_4.

  " 5. Sviluppo
  SELECTION-SCREEN BEGIN OF BLOCK b4_5 WITH FRAME TITLE t4_5.
    SELECTION-SCREEN BEGIN OF LINE.
      SELECTION-SCREEN PUSHBUTTON 1(8) c_se11 USER-COMMAND c_se11.
      SELECTION-SCREEN PUSHBUTTON 10(8) b_se16 USER-COMMAND t_se16.
      SELECTION-SCREEN PUSHBUTTON 19(8) b_se38 USER-COMMAND t_se38.
      SELECTION-SCREEN PUSHBUTTON 28(8) b_se80 USER-COMMAND t_se80.
      SELECTION-SCREEN PUSHBUTTON 37(8) b_st22 USER-COMMAND t_st22.
      SELECTION-SCREEN PUSHBUTTON 46(8) b_spro USER-COMMAND t_spro.
    SELECTION-SCREEN END OF LINE.
    SELECTION-SCREEN BEGIN OF LINE.
      SELECTION-SCREEN PUSHBUTTON 1(8) b_sm04 USER-COMMAND t_sm04.
      SELECTION-SCREEN PUSHBUTTON 10(8) b_sm30 USER-COMMAND t_sm30.
      SELECTION-SCREEN PUSHBUTTON 19(8) b_sm37 USER-COMMAND t_sm37.
      SELECTION-SCREEN PUSHBUTTON 28(8) b_sm62 USER-COMMAND t_sm62.
      SELECTION-SCREEN PUSHBUTTON 37(8) b_stms USER-COMMAND t_stms.
      SELECTION-SCREEN PUSHBUTTON 46(8) b_se10 USER-COMMAND t_se10.
    SELECTION-SCREEN END OF LINE.
  SELECTION-SCREEN END OF BLOCK b4_5.

  " 6. HR
  SELECTION-SCREEN BEGIN OF BLOCK b4_6 WITH FRAME TITLE t4_6.
    SELECTION-SCREEN BEGIN OF LINE.
      SELECTION-SCREEN PUSHBUTTON 1(8) b_cic0 USER-COMMAND t_cic0.
      SELECTION-SCREEN PUSHBUTTON 10(8) b_sost USER-COMMAND t_sost.
      SELECTION-SCREEN PUSHBUTTON 19(11) b_fqev USER-COMMAND t_fqev.
      SELECTION-SCREEN PUSHBUTTON 31(8) b_mm01 USER-COMMAND t_mm01.
      SELECTION-SCREEN PUSHBUTTON 40(8) b_pa30 USER-COMMAND t_pa30.
      SELECTION-SCREEN PUSHBUTTON 49(8) b_su01 USER-COMMAND t_su01.
    SELECTION-SCREEN END OF LINE.
    SELECTION-SCREEN BEGIN OF LINE.
      SELECTION-SCREEN COMMENT 1(10) c_t6.
      SELECTION-SCREEN PUSHBUTTON 12(10) b4_adrc  USER-COMMAND m_adrc.
      SELECTION-SCREEN PUSHBUTTON 23(10) b4_adr6  USER-COMMAND m_adr6.
    SELECTION-SCREEN END OF LINE.
  SELECTION-SCREEN END OF BLOCK b4_6.

SELECTION-SCREEN END OF SCREEN 104.


* --- 3. EVENTI ---
INITIALIZATION.
  tab1 = 'Ricerca'. tab3 = 'Extra'. tab2 = 'CONSOLE'.
  t_map = 'Modello Relazionale IS-U'. gv_title = 'Strumenti Rapidi'.
  bt_eanl = 'EANL'. ar1 = '--- ANLART --->'. bt_te43 = 'TE439T'. tx1 = '(Desc. Impianto)'.
  bt_ever = 'EVER'. ar2 = '--- ANLAGE --->'. bt_east = 'EASTL'.  tx2 = '(Dati Lettura)'.
  bt_fkk  = 'FKKVKP'. ar3 = '--- VKONTO --->'. bt_eger = 'EGERH'. tx3 = '(Dati Tecnici)'.
  bt_but  = 'BUT000'. ar4 = '--- GPART  --->'. bt_equi = 'EQUI'.  tx4 = '(Matricola)'.
  vl1 = vl2 = vl3 = vl4 = vl5 = vl6 = ' |'.
  c1 = 'Azioni:'. c2 = 'Transazioni:'. C3 = 'Random:'.
  b_cic = '@0Y@ CIC0'. b_se11 = '@0J@ SE11'. b_16 = '@36@ SE16'.
  b_bp = '@44@ IMP. Random'. b_exp = '@L1@ Export'. b_test = 'EL31'.
  b_test2 = 'EA00'. b_help = '@0S@ Manuale'. b_note = '@0Z@ Note Rapide'.

  " --- TAB 4: TESTI ---
  t4_1 = '1. IS-U Letture'.
  t4_2 = '2. IS-U Apparecchiature'.
  t4_3 = '3. Fatturazione'.
  t4_4 = '4. Manutenzione'.
  t4_5 = '5. Sviluppo'.
  t4_6 = '6. Cic0 & Indirizzi'.
  c_t1 = c_t2 = c_t3 = c_t6 = c_t4 = 'Tabelle:'.
  " Transazioni
  b_es31 = 'ES31'. b_es32 = 'ES32'. b_el01 = 'EL01'. b_el31 = 'EL31'. b_el37 = 'EL37'.
  b_eg30 = 'EG30'. b_eg34 = 'EG34'. b_eg50 = 'EG50'. b_iq01 = 'IQ01'. b_iq03 = 'IQ03'.
  b_ea00 = 'EA00'. b_ea60 = 'EA60'. b_ea19 = 'EA19'. b_ea40 = 'EA40'.
  b_iw33 = 'IW33'. b_iw52 = 'IW52'. b_iw53 = 'IW53'.
  b_se80 = 'SE80'. b_st22 = 'ST22'. b_sm37 = 'SM37'. b_spro = 'SPRO'. b_se16 = 'SE16'.
  b_cic0 = 'CIC0'. b_sost = 'SOST'. b_fqev = 'FQEV'.

  " (Nomi variabili < 8 caratteri) sennò mi va in errore
  b4_eanl  = 'EANL'.
  b4_eanlh = 'EANLH'.
  b4_equi  = 'EQUI'.
  b4_sost  = 'SOST'.
  b4_erdk  = 'ERDK'.
  b4_adrc  = 'ADRC'.
  b4_adr6  = 'ADR6'.
  b4_qmel = 'QMEL'. " aggiunto nuovo legame a tabella

  b_el28 = 'EL28'. b_eg35 = 'EG35'. b_iq01 = 'IQ01'.
  b_ea05 = 'EA05'. b_ea19 = 'EA19'. b_ea20 = 'EA20'.
  c_se11 = 'SE11'. b_se38 = 'SE38'. b_sm04 = 'SM04'.
  b_sm30 = 'SM30'. b_sm62 = 'SM62'. b_stms = 'STMS'.
  b_se10 = 'SE10'. b_pa30 = 'PA30'. b_su01 = 'SU01'.
  b_mm01 = 'MM01'.


AT SELECTION-SCREEN.
  " 1. Salviamo il comando
  gv_ucomm = sscrfields-ucomm.

  " 2. PULIZIA INTELLIGENTE:
  " Se il comando NON riguarda il cambio tab (ULINE1, ULINE2, ULINE3)
  " allora lo puliamo per evitare raddoppi.
  IF gv_ucomm(5) <> 'ULINE' and gv_ucomm <> 'ONLI'.
    CLEAR: sscrfields-ucomm, sy-ucomm.
  ENDIF.

  CASE gv_ucomm.
    " --- TASTI DI USCITA ---
    WHEN 'BACK' OR 'EXIT' OR 'CANC'.
      LEAVE TO SCREEN 0.

    " --- TAB 2: MAPPA RELAZIONALE ---
    WHEN 'M_EANL'. SET PARAMETER ID 'DTB' FIELD 'EANL'.   CALL TRANSACTION 'SE16'.
    WHEN 'M_TE43'. SET PARAMETER ID 'DTB' FIELD 'TE439T'. CALL TRANSACTION 'SE16'.
    WHEN 'M_EVER'. SET PARAMETER ID 'DTB' FIELD 'EVER'.   CALL TRANSACTION 'SE16'.
    WHEN 'M_EAST'. SET PARAMETER ID 'DTB' FIELD 'EASTL'.  CALL TRANSACTION 'SE16'.
    WHEN 'M_FKK'.  SET PARAMETER ID 'DTB' FIELD 'FKKVKP'. CALL TRANSACTION 'SE16'.
    WHEN 'M_EGER'. SET PARAMETER ID 'DTB' FIELD 'EGERH'.  CALL TRANSACTION 'SE16'.
    WHEN 'M_BUT'.  SET PARAMETER ID 'DTB' FIELD 'BUT000'. CALL TRANSACTION 'SE16'.
    WHEN 'M_EQUI'. SET PARAMETER ID 'DTB' FIELD 'EQUI'.   CALL TRANSACTION 'SE16'.

    " --- TAB 3: AZIONI OPERATIVE ---
    WHEN 'ON'.     CALL TRANSACTION 'CIC0'.
    WHEN 'F_SE11'. CALL TRANSACTION 'SE11'.
    WHEN 'F_16'.   CALL TRANSACTION 'SE16'.
    WHEN 'F_MARA'. PERFORM f_bp_random.
    WHEN 'EXPORT'. PERFORM f_esegui_export.
    WHEN 'B_TEST'. CALL TRANSACTION 'EL31'.
    WHEN 'B_TEST2'. CALL TRANSACTION 'EA00'.

    " --- GESTIONE TABELLE (M_...) ---
    WHEN 'M_EANL'.  SET PARAMETER ID 'DTB' FIELD 'EANL'.      CALL TRANSACTION 'SE16'.
    WHEN 'M_EANLH'. SET PARAMETER ID 'DTB' FIELD 'EANLH'.     CALL TRANSACTION 'SE16'.
    WHEN 'M_EQUI'.  SET PARAMETER ID 'DTB' FIELD 'EQUI'.      CALL TRANSACTION 'SE16'.
    WHEN 'M_SOST'.  SET PARAMETER ID 'DTB' FIELD 'ZWFM_SOST'. CALL TRANSACTION 'SE16'.
    WHEN 'M_ERDK'.  SET PARAMETER ID 'DTB' FIELD 'ERDK'.      CALL TRANSACTION 'SE16'.
    WHEN 'M_ADRC'.  SET PARAMETER ID 'DTB' FIELD 'ADRC'.      CALL TRANSACTION 'SE16'.
    WHEN 'M_QMEL'.  SET PARAMETER ID 'DTB' FIELD 'QMEL'.      CALL TRANSACTION 'SE16'.
    WHEN 'M_ADR6'.  SET PARAMETER ID 'DTB' FIELD 'ADR6'.      CALL TRANSACTION 'SE16'.

    " --- 1. IS-U LETTURE ---
    WHEN 'T_ES31'. CALL TRANSACTION 'ES31'.
    WHEN 'T_ES32'. CALL TRANSACTION 'ES32'.
    WHEN 'T_EL01'. CALL TRANSACTION 'EL01'.
    WHEN 'T_EL31'. CALL TRANSACTION 'EL31'.
    WHEN 'T_EL37'. CALL TRANSACTION 'EL37'.
    WHEN 'T_EL28'. CALL TRANSACTION 'EL28'.

    " --- 2. IS-U APPARECCHI ---
    WHEN 'T_EG30'. CALL TRANSACTION 'EG30'.
    WHEN 'T_EG34'. CALL TRANSACTION 'EG34'.
    WHEN 'T_EG50'. CALL TRANSACTION 'EG50'.
    WHEN 'T_IQ01'. CALL TRANSACTION 'IQ01'.
    WHEN 'T_IQ03'. CALL TRANSACTION 'IQ03'.

    " --- 3. FATTURAZIONE ---
    WHEN 'T_EA00'. CALL TRANSACTION 'EA00'.
    WHEN 'T_EA60'. CALL TRANSACTION 'EA60'.
    WHEN 'T_EA19'. CALL TRANSACTION 'EA19'.
    WHEN 'T_EA40'. CALL TRANSACTION 'EA40'.
    WHEN 'T_EA05'. CALL TRANSACTION 'EA05'.
    WHEN 'T_EA20'. CALL TRANSACTION 'EA20'.

    " --- 4. MANUTENZIONE  ---
    WHEN 'T_IW33'. CALL TRANSACTION 'IW33'.
    WHEN 'T_IW52'. CALL TRANSACTION 'IW52'.
    WHEN 'T_IW53'. CALL TRANSACTION 'IW53'.

    " --- 5. SVILUPPO ---
    WHEN 'T_SE80'. CALL TRANSACTION 'SE80'.
    WHEN 'T_ST22'. CALL TRANSACTION 'ST22'.
    WHEN 'T_SM37'. CALL TRANSACTION 'SM37'.
    WHEN 'T_SPRO'. CALL TRANSACTION 'SPRO'.
    WHEN 'C_SE11'. CALL TRANSACTION 'SE11'.
    WHEN 'T_SE16'. CALL TRANSACTION 'SE16'.
    WHEN 'T_SE38'. CALL TRANSACTION 'SE38'.
    WHEN 'T_SM04'. CALL TRANSACTION 'SM04'.
    WHEN 'T_SU01'. CALL TRANSACTION 'SU01'.
    WHEN 'T_STMS'. CALL TRANSACTION 'STMS'.
    WHEN 'T_SE10'. CALL TRANSACTION 'SE10'.
    WHEN 'T_SM30'. CALL TRANSACTION 'SM30'.

    " --- 6. VARIE ---
    WHEN 'T_CIC0'. CALL TRANSACTION 'CIC0'.
    WHEN 'T_SOST'. CALL TRANSACTION 'SOST'.
    WHEN 'T_FQEV'. CALL TRANSACTION 'FQEVENTS'.
    WHEN 'T_MM01'. CALL TRANSACTION 'MM01'.
    WHEN 'T_PA30'. CALL TRANSACTION 'PA30'.


    " --- LINK ESTERNO ---
    WHEN 'OPEN_URL'.
      CALL FUNCTION 'CALL_BROWSER'
        EXPORTING
          url = 'https://help.sap.com'
          window_name = 'HELP'.

    " --- NOTE ---
    WHEN 'OPEN_NOTE'.
      PERFORM f_gestisci_note.

    " --- COMBO BOX ---
    WHEN 'COMBO'.
      CASE scegli.
        WHEN 'CIC0'. CALL TRANSACTION 'CIC0'.
        WHEN 'SE11'. CALL TRANSACTION 'SE11'.
        WHEN 'SE16'. CALL TRANSACTION 'SE16'.
      ENDCASE.
      CLEAR scegli.
  ENDCASE.


AT SELECTION-SCREEN OUTPUT.
  PERFORM f_popola_combo.

START-OF-SELECTION.
  PERFORM f_get_data.
  IF lt_risultato IS NOT INITIAL.
    PERFORM f_display_alv.
  ENDIF.

* --- CLASSI & SOTTOPROGRAMMI ---
CLASS lcl_events IMPLEMENTATION.
  METHOD on_link_click.
    READ TABLE lt_risultato INTO DATA(ls_row) INDEX row.
    CHECK sy-subrc = 0.
    CASE column.
      WHEN 'ANLAGE'. SET PARAMETER ID 'ANL' FIELD ls_row-anlage. CALL TRANSACTION 'ES32' AND SKIP FIRST SCREEN.
      WHEN 'PARTNER'. SET PARAMETER ID 'BPA' FIELD ls_row-partner. CALL TRANSACTION 'BP' AND SKIP FIRST SCREEN.
    ENDCASE.
  ENDMETHOD.
ENDCLASS.

FORM f_get_data.
  SELECT b~partner, b~name_last AS cognome, b~name_first AS nome,
         e~vstelle, f~vkont, c~vertrag, e~anlage, e~anlart,
         te~text30 AS text_imp, eq~equnr AS equipment,
         eq~sernr AS n_serie, eg~bis AS fine_val2
  FROM eanl AS e
  LEFT OUTER JOIN ever AS c ON c~anlage = e~anlage AND c~auszdat = '99991231'
  LEFT OUTER JOIN fkkvkp AS f ON f~vkont = c~vkonto
  LEFT OUTER JOIN but000 AS b ON b~partner = f~gpart
  LEFT OUTER JOIN eastl AS ea ON ea~anlage = e~anlage
  LEFT OUTER JOIN egerh AS eg ON eg~logiknr = ea~logiknr AND eg~bis = '99991231'
  LEFT OUTER JOIN equi AS eq ON eq~equnr = eg~equnr
  LEFT OUTER JOIN te439t AS te ON te~anlart = e~anlart AND te~spras = @sy-langu
  WHERE e~anlage IN @impianti
  INTO CORRESPONDING FIELDS OF TABLE @lt_risultato UP TO 50 ROWS.
ENDFORM.

FORM f_popola_combo.
  DATA: lt_values TYPE vrm_values, ls_value TYPE vrm_value.
  ls_value-key = 'CIC0'. ls_value-text = 'Customer Interaction'. APPEND ls_value TO lt_values.
  ls_value-key = 'SE11'. ls_value-text = 'ABAP Dictionary'. APPEND ls_value TO lt_values.
  CALL FUNCTION 'VRM_SET_VALUES' EXPORTING id = 'SCEGLI' values = lt_values.
ENDFORM.

FORM f_display_alv.
  TRY.
      cl_salv_table=>factory(
        IMPORTING r_salv_table = DATA(gr)
        CHANGING  t_table      = lt_risultato
      ).

      " --- ATTIVARE TUTTI I BOTTONI ---
      gr->get_functions( )->set_all( abap_true ).

      " Ottimizzazione automatica larghezza colonne
      gr->get_columns( )->set_optimize( abap_true ).

      DATA(lo_cols) = gr->get_columns( ). " per i click
      TRY.
          DATA(lo_col_anl) = CAST cl_salv_column_table( lo_cols->get_column( 'ANLAGE' ) ).
          lo_col_anl->set_cell_type( if_salv_c_cell_type=>hotspot ).

          DATA(lo_col_but) = CAST cl_salv_column_table( lo_cols->get_column( 'PARTNER' ) ).
          lo_col_but->set_cell_type( if_salv_c_cell_type=>hotspot ).

          " Handler eventi click
          DATA(lo_events) = gr->get_event( ).
          SET HANDLER lcl_events=>on_link_click FOR lo_events.
        CATCH cx_salv_not_found.
      ENDTRY.

      gr->display( ).
    CATCH cx_salv_msg.
  ENDTRY.
ENDFORM.

FORM f_gestisci_note.
  DATA: lt_text      TYPE TABLE OF tline, " Tabella standard per testi
        lv_filename  TYPE string,
        lv_path      TYPE string,
        lv_fullpath  TYPE string,
        lv_action    TYPE i.

  " 1. Apre l'editor di testo in modalità popup
  CALL FUNCTION 'TERM_CONTROL_EDIT'
    EXPORTING
      titel          = 'Note Rapide'
    TABLES
      textlines      = lt_text
    EXCEPTIONS
      user_cancelled = 1
      OTHERS         = 2.

  " Se l'utente ha scritto qualcosa e non ha annullato
  IF sy-subrc = 0 AND lt_text IS NOT INITIAL.

    " 2. Chiede dove salvare il file sul PC
    CALL METHOD cl_gui_frontend_services=>file_save_dialog
      EXPORTING
        window_title      = 'Salva i tuoi appunti'
        default_extension = 'txt'
        file_filter       = 'File di testo (*.txt)|*.txt'
      CHANGING
        filename          = lv_filename
        path              = lv_path
        fullpath          = lv_fullpath
        user_action       = lv_action.

    IF lv_action = cl_gui_frontend_services=>action_ok.
      " 3. Scarica fisicamente il file
      CALL FUNCTION 'GUI_DOWNLOAD'
        EXPORTING
          filename = lv_fullpath
          filetype = 'ASC'
        TABLES
          data_tab = lt_text
        EXCEPTIONS
          OTHERS   = 1.

      IF sy-subrc = 0.
        MESSAGE 'Note salvate sul PC!' TYPE 'S'.
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.


FORM f_esegui_export.
  PERFORM f_get_data.
  IF lt_risultato IS NOT INITIAL.
    CALL FUNCTION 'GUI_DOWNLOAD'
      EXPORTING
        filename              = 'C:\temp\export_impianti.xls'
        write_field_separator = 'X'
      TABLES
        data_tab              = lt_risultato.
    IF sy-subrc = 0.
      MESSAGE 'Esportato in C:\temp' TYPE 'S'.
      cl_gui_frontend_services=>execute( EXPORTING document = 'C:\temp\' EXCEPTIONS OTHERS = 1 ).
    ENDIF.
  ENDIF.
ENDFORM.

* RANDOM IMPIANTI DEL TAB1

FORM f_bp_random.
  DATA: lt_bp_all TYPE TABLE OF ty_output,
        lt_bp_rnd TYPE TABLE OF ty_output,
        lv_lines  TYPE i,
        lv_index  TYPE i,
        lo_random TYPE REF TO cl_abap_random_int.

  " 1. Estraiamo un blocco di 200 record COMPLETI (con impianti e contratti)
  SELECT b~partner, b~name_last AS cognome, b~name_first AS nome,
         e~vstelle, f~vkont, c~vertrag, e~anlage, e~anlart,
         te~text30 AS text_imp, eq~equnr AS equipment,
         eq~sernr AS n_serie, eg~bis AS fine_val2
  FROM but000 AS b
  INNER JOIN fkkvkp AS f ON f~gpart = b~partner
  INNER JOIN ever AS c ON c~vkonto = f~vkont AND c~auszdat = '99991231'
  INNER JOIN eanl AS e ON e~anlage = c~anlage
  LEFT OUTER JOIN eastl AS ea ON ea~anlage = e~anlage
  LEFT OUTER JOIN egerh AS eg ON eg~logiknr = ea~logiknr AND eg~bis = '99991231'
  LEFT OUTER JOIN equi AS eq ON eq~equnr = eg~equnr
  LEFT OUTER JOIN te439t AS te ON te~anlart = e~anlart AND te~spras = @sy-langu
  INTO CORRESPONDING FIELDS OF TABLE @lt_bp_all UP TO 200 ROWS.

  lv_lines = lines( lt_bp_all ).
  CHECK lv_lines > 0.

  " 2. Inizializziamo il generatore random
  lo_random = cl_abap_random_int=>create( seed = cl_abap_random=>seed( )
                                          min  = 1
                                          max  = lv_lines ).

  " 3. 20 record RANDOM
  DO 20 TIMES.
    lv_lines = lines( lt_bp_all ).
    IF lv_lines = 0. EXIT. ENDIF.

    lv_index = lo_random->get_next( ).
    IF lv_index > lv_lines.
      lv_index = ( lv_index MOD lv_lines ) + 1.
    ENDIF.

    READ TABLE lt_bp_all INTO DATA(ls_rnd) INDEX lv_index.
    IF sy-subrc = 0.
      APPEND ls_rnd TO lt_bp_rnd.
      DELETE lt_bp_all INDEX lv_index.
    ENDIF.
  ENDDO.

  " 4. Visualizziamo il risultato con le stesse colonne del Tab 1
  IF lt_bp_rnd IS NOT INITIAL.
    TRY.
        cl_salv_table=>factory(
          IMPORTING r_salv_table = DATA(lo_salv)
          CHANGING  t_table      = lt_bp_rnd ).

        " Attiviamo le funzioni standard
        lo_salv->get_functions( )->set_all( abap_true ).
        lo_salv->get_columns( )->set_optimize( abap_true ).

        lo_salv->display( ).
      CATCH cx_salv_msg.
    ENDTRY.
  ENDIF.
ENDFORM.
