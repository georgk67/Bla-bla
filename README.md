# Abi 2027

Ein Schul- und Lernplaner für das Abitur 2027 als installierbare PWA: Stundenplan mit A/B-Wochen, Tagesablauf, Checkliste mit Streak und Punkten, Klausurtermine, Aufgaben und durchsuchbare Notizen in Markdown — eine einzige HTML-Datei, kein Framework, offline nutzbar.

Der **Lernfokus** im Wochen-Tab belegt Lern- und Silenziumblöcke automatisch mit dem Fach, dessen Klausur am nächsten liegt; offene `- [ ]` aus den Notizen tauchen unter *Aufgaben* auf und lassen sich dort abhaken.

**Deployen:** Repo auf GitHub pushen und unter *Settings › Pages* als Quelle den Branch mit Root-Verzeichnis (`/`) wählen; die Seite liegt danach unter `https://<nutzer>.github.io/<repo>/` und lässt sich auf Handy und iPad über *Zum Home-Bildschirm* installieren.

**Sync:** Trage unter *Notizen › Sync* auf jedem Gerät denselben Sync-Key (mindestens 20 Zeichen, Button erzeugt einen zufälligen) sowie Supabase-URL und anon-Key ein — danach lädt die App 3 Sekunden nach jeder Änderung hoch und beim Start bzw. beim Zurückkehren in den Vordergrund wieder herunter, wobei der neuere Stand gewinnt und der überschriebene lokale Stand vorher als Backup in `localStorage` unter `abi2027v2_backup` landet.

## Einrichten

Die App startet leer — Stundenplan, Klausuren, Fächer und Routine kommen aus deinem eigenen Backup, nicht aus dem Code. So liegt im Repo und auf der veröffentlichten Seite nichts Persönliches.

1. Seite öffnen, unter *Notizen › Daten sichern* dein Backup (`mein-plan.json`) einlesen. Alternativ Fächer unter *Notizen › Fächer* anlegen und den Plan von Hand eintragen.
2. Im Wochen-Tab bei Bedarf *Diese Woche → A* antippen, damit der A/B-Rhythmus stimmt.
3. Supabase-Projekt anlegen (kostenloses Tier genügt), `supabase.sql` im *SQL Editor* ausführen, Projekt-URL und `anon`-Key aus *Project Settings › API* kopieren.
4. Unter *Notizen › Sync* eintragen, Key erzeugen, auf dem zweiten Gerät denselben Key eintragen — der Plan kommt dann per Sync mit, ohne zweites Einlesen.

Ohne Sync läuft der Planer ganz normal weiter; die Daten liegen dann allein in `localStorage` unter `abi2027v2`. Die Backup-Datei gehört nicht ins Repo — `mein-plan.json` und die exportierten `abi-planer-*.json` stehen in `.gitignore`.

Für lokales Testen lässt sich `config.example.js` als `config.js` kopieren, um URL und anon-Key vorzubelegen. `config.js` steht ebenfalls in `.gitignore`.

## Sicherheit

Der Sync-Key ist das einzige Geheimnis: Die Tabelle `planer` hat RLS aktiv und für die `anon`-Rolle keinerlei direkten Zugriff. Gelesen und geschrieben wird ausschließlich über zwei `security definer`-Funktionen, die den Key als Argument erwarten und nur die eine passende Zeile herausgeben — fremde Zeilen lassen sich weder auflisten noch erraten.
