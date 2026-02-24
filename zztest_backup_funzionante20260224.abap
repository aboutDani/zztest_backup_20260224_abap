REPORT zztest.

TABLES: eanl, sscrfields.

* --- 1. DICHIARAZIONI GLOBALI ---
TYPE-POOLS: vrm.

* Definizione locale per eventi ALV
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

* --- 2. DEFINIZIONE SCHERMO ---

* FILTRO IMPIANTO
SELECTION-SCREEN SKIP 1.
SELECT-OPTIONS impianti FOR eanl-anlage.
SELECTION-SCREEN SKIP 1.

* --- SCHEMA RELAZIONALE INTERATTIVO ---
SELECTION-SCREEN BEGIN OF BLOCK b_map WITH FRAME TITLE t_map.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN PUSHBUTTON 1(10)  bt_eanl USER-COMMAND m_eanl.
SELECTION-SCREEN COMMENT 12(15)    ar1.
SELECTION-SCREEN PUSHBUTTON 28(10) bt_te43 USER-COMMAND m_te43.
SELECTION-SCREEN COMMENT 39(20)    tx1.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 5(2)      vl1.
SELECTION-SCREEN COMMENT 32(2)     vl2.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN PUSHBUTTON 1(10)  bt_ever USER-COMMAND m_ever.
SELECTION-SCREEN COMMENT 12(15)    ar2.
SELECTION-SCREEN PUSHBUTTON 28(10) bt_east USER-COMMAND m_east.
SELECTION-SCREEN COMMENT 39(20)    tx2.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 5(2)      vl3.
SELECTION-SCREEN COMMENT 32(2)     vl4.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN PUSHBUTTON 1(10)  bt_fkk  USER-COMMAND m_fkk.
SELECTION-SCREEN COMMENT 12(15)    ar3.
SELECTION-SCREEN PUSHBUTTON 28(10) bt_eger USER-COMMAND m_eger.
SELECTION-SCREEN COMMENT 39(20)    tx3.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 5(2)      vl5.
SELECTION-SCREEN COMMENT 32(2)     vl6.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN PUSHBUTTON 1(10)  bt_but  USER-COMMAND m_but.
SELECTION-SCREEN COMMENT 12(15)    ar4.
SELECTION-SCREEN PUSHBUTTON 28(10) bt_equi USER-COMMAND m_equi.
SELECTION-SCREEN COMMENT 39(20)    tx4.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK b_map.

* --- BOTTONI OPERATIVI ---
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(15) c1.
SELECTION-SCREEN PUSHBUTTON 18(10) b_cic  USER-COMMAND on.
SELECTION-SCREEN PUSHBUTTON 29(10) b_se11 USER-COMMAND f_se11.
SELECTION-SCREEN PUSHBUTTON 40(10) b_16   USER-COMMAND f_16.
SELECTION-SCREEN PUSHBUTTON 51(10) b_bp   USER-COMMAND f_mara.
SELECTION-SCREEN PUSHBUTTON 62(12) b_exp  USER-COMMAND export.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(15) c2.
SELECTION-SCREEN PUSHBUTTON 18(10) b_test USER-COMMAND b_test.
SELECTION-SCREEN PUSHBUTTON 29(10) b_test2 USER-COMMAND b_test2.
SELECTION-SCREEN PUSHBUTTON 40(12) b_help USER-COMMAND open_url.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN SKIP 1.
SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE gv_title.
PARAMETERS: scegli TYPE char40 AS LISTBOX VISIBLE LENGTH 45 USER-COMMAND combo.
SELECTION-SCREEN END OF BLOCK bl1.

* --- 3. EVENTI ---
INITIALIZATION.
  t_map   = 'Modello relazionale per la gestione degli impianti'.
  bt_eanl = 'EANL'.     ar1 = '--- ANLART --->'. bt_te43 = 'TE439T'. tx1 = '(Desc. Impianto)'.
  bt_ever = 'EVER'.     ar2 = '--- ANLAGE --->'. bt_east = 'EASTL'.  tx2 = '(Dati Lettura)'.
  bt_fkk  = 'FKKVKP'.   ar3 = '--- VKONTO --->'. bt_eger = 'EGERH'.  tx3 = '(Dati Tecnici)'.
  bt_but  = 'BUT000'.   ar4 = '--- GPART  --->'. bt_equi = 'EQUI'.   tx4 = '(Matricola)'.
  vl1 = vl2 = vl3 = vl4 = vl5 = vl6 = ' |'.

  c1       = 'Azioni:'.
  b_cic    = '@0Y@ CIC0'.
  b_se11   = '@0J@ SE11'.
  b_16     = '@36@ SE16'.
  b_bp     = '@44@ BP rand'.
  b_exp    = '@L1@ Export'.
  b_test   = 'EL31'.
  b_test2  = 'EA00'.
  b_help = '@0S@ Manuale'.
  gv_title = 'Utility'.

AT SELECTION-SCREEN.
  CASE sy-ucomm.
    WHEN 'M_EANL'. SET PARAMETER ID 'DTB' FIELD 'EANL'.   CALL TRANSACTION 'SE16'.
    WHEN 'M_EVER'. SET PARAMETER ID 'DTB' FIELD 'EVER'.   CALL TRANSACTION 'SE16'.
    WHEN 'M_BUT'.  SET PARAMETER ID 'DTB' FIELD 'BUT000'. CALL TRANSACTION 'SE16'.
    WHEN 'M_EQUI'. SET PARAMETER ID 'DTB' FIELD 'EQUI'.   CALL TRANSACTION 'SE16'.
    WHEN 'M_FKK'.  SET PARAMETER ID 'DTB' FIELD 'FKKVKP'. CALL TRANSACTION 'SE16'.
    WHEN 'M_TE43'. SET PARAMETER ID 'DTB' FIELD 'TE439T'. CALL TRANSACTION 'SE16'.
    WHEN 'M_EAST'. SET PARAMETER ID 'DTB' FIELD 'EASTL'.  CALL TRANSACTION 'SE16'.
    WHEN 'M_EGER'. SET PARAMETER ID 'DTB' FIELD 'EGERH'.  CALL TRANSACTION 'SE16'.

    WHEN 'ON'.     CALL TRANSACTION 'CIC0'.
    WHEN 'F_SE11'. CALL TRANSACTION 'SE11'.
    WHEN 'F_16'.   CALL TRANSACTION 'SE16'.
    WHEN 'F_MARA'. PERFORM f_bp_random.
    WHEN 'B_TEST'. CALL TRANSACTION 'EL31'.
    WHEN 'B_TEST2'. CALL TRANSACTION 'EA00'.
    WHEN 'EXPORT'. PERFORM f_esegui_export.
    WHEN 'OPEN_URL'.
      DATA(lv_url) = 'https://help.sap.com'. " Il tuo link SharePoint o Wiki
      CALL FUNCTION 'CALL_BROWSER'
        EXPORTING
          url                    = lv_url
          window_name            = 'HELP'
        EXCEPTIONS
          frontend_not_available = 1
          OTHERS                 = 2.

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

* --- IMPLEMENTAZIONE CLASSI ---
CLASS lcl_events IMPLEMENTATION.
  METHOD on_link_click.
    READ TABLE lt_risultato INTO DATA(ls_row) INDEX row.
    IF sy-subrc <> 0. RETURN. ENDIF.

    CASE column.
      WHEN 'ANLAGE'.
        SET PARAMETER ID 'ANL' FIELD ls_row-anlage.
        CALL TRANSACTION 'ES32' AND SKIP FIRST SCREEN.
      WHEN 'PARTNER'.
        SET PARAMETER ID 'BPA' FIELD ls_row-partner.
        CALL TRANSACTION 'BP' AND SKIP FIRST SCREEN.
    ENDCASE.
  ENDMETHOD.
ENDCLASS.

* --- 6. SOTTOPROGRAMMI ---
FORM f_popola_combo.
  DATA: lt_values TYPE vrm_values, ls_value TYPE vrm_value.
  ls_value-key = 'CIC0'. ls_value-text = 'Customer Interaction Center'. APPEND ls_value TO lt_values.
  ls_value-key = 'SE11'. ls_value-text = 'ABAP Dictionary'.             APPEND ls_value TO lt_values.
  ls_value-key = 'SE16'. ls_value-text = 'tabelle'.             APPEND ls_value TO lt_values.
  CALL FUNCTION 'VRM_SET_VALUES' EXPORTING id = 'SCEGLI' values = lt_values.
ENDFORM.

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

FORM f_display_alv.
  TRY.
      cl_salv_table=>factory(
        IMPORTING r_salv_table = DATA(gr)
        CHANGING  t_table      = lt_risultato
      ).

      " --- AGGIUNGI QUESTA RIGA PER ATTIVARE TUTTI I BOTTONI ---
      gr->get_functions( )->set_all( abap_true ).

      " Ottimizzazione automatica larghezza colonne
      gr->get_columns( )->set_optimize( abap_true ).

      " (Opzionale) Se vuoi mantenere gli Hotspot (click) aggiungi qui:
      DATA(lo_cols) = gr->get_columns( ).
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


FORM f_bp_random.
  SELECT partner, type, name_last, name_first
    FROM but000 INTO TABLE @DATA(lt_bp) UP TO 20 ROWS.
  IF sy-subrc = 0.
    TRY.
        cl_salv_table=>factory( IMPORTING r_salv_table = DATA(lo_bp) CHANGING t_table = lt_bp ).
        lo_bp->display( ).
      CATCH cx_salv_msg.
    ENDTRY.
  ENDIF.
ENDFORM.