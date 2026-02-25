--------------------------------------------------------------------------------
PROGETTO: SAP IS-U TECHNICAL COCKPIT (REPORT ZZTEST)
--------------------------------------------------------------------------------

COS'È:
Uno strumento ABAP "tutto-in-uno" per navigare velocemente tra i dati tecnici
di SAP IS-U (Energia/Acqua). Invece di aprire 10 transazioni diverse, hai tutto
sotto controllo in una sola schermata a schede (Tab).

--------------------------------------------------------------------------------

STRUTTURA DELLE SCHEDE (TAB):

[TAB 1] - RICERCA E MAPPA RELAZIONALE
--------------------------------------
- Cerca impianti (EANL) tramite filtri.
- Mappa visiva dei collegamenti: mostra come il Business Partner (BUT000) 
  si collega al Contratto (EVER), all'Impianto (EANL) e al Contatore (EGERH).
- Pulsanti rapidi per saltare direttamente alle tabelle di sistema.

[TAB 2] - CONSOLE TRANSAZIONI (Pannello di Controllo)
--------------------------------------
- AREA LETTURE: Pulsanti diretti per ES31, EL01, EL31.
- AREA CONTATORI: Pulsanti diretti per EG30, EG34, IQ01/03.
- AREA FATTURAZIONE: Pulsanti diretti per EA00, EA40, EA60.
- AREA ORDINI: Pulsanti diretti per IW33, IW52 (Manutenzione).

[TAB 3] - SVILUPPO E UTILITY
--------------------------------------
- Shortcut per SE11 (Dizionario) e SE16 (Tabelle).
- Pulsante per Export dati veloce.
- Menu a tendina per lanciare query personalizzate o test rapidi.

--------------------------------------------------------------------------------

DETTAGLI TECNICI:
- Linguaggio: ABAP.
- Oggetti UI: Selection Screen con Tabbed Blocks e Subscreens (101, 103, 104).
- Griglia Dati: Visualizzazione tramite CL_SALV_TABLE (griglia moderna).
- Eventi: Navigazione attiva (cliccando su una riga si apre il dettaglio).

--------------------------------------------------------------------------------

COME INSTALLARE IL TOOL:
1. Apri la transazione SE38.
2. Crea il report "ZZTEST".
3. Incolla il codice.
4. Importante: In "Elementi di testo" -> "Simboli di testo", inserisci le 
   descrizioni per i titoli dei blocchi (es. tit1 = 'Filtri Ricerca').
5. Attiva tutto (Ctrl+F12).

--------------------------------------------------------------------------------

TODO:
- Implementare altre transazioni e tabelle.
- Altre funzionalità varie alle quali sto pensando da inserire in altri tab.

--------------------------------------------------------------------------------
