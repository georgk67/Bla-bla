/* Optional. Als config.js kopieren, um Supabase-URL und anon-Key beim ersten
   Start vorzubelegen – praktisch beim lokalen Testen.

   config.js steht in .gitignore und wird deshalb nicht deployt. Auf Handy und
   iPad trägst du die beiden Werte stattdessen einmalig unter Notizen › Sync ein;
   sie bleiben dann in localStorage auf dem Gerät.

   Fehlt die Datei, läuft die App ohne Sync ganz normal weiter. */

window.ABI_CONFIG = {
  url: 'https://DEIN-PROJEKT.supabase.co',
  anon: 'DEIN-ANON-KEY'
};
