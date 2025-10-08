# 🕷️ Web Scraping Workshop mit Cursor

Ein hands-on Workshop zum Erlernen von Web Scraping mit Scrapy, BigQuery und AI-gestützter Entwicklung.

---

## 🤔 Was ist Web Scraping?

**Web Scraping** ist das automatische Extrahieren von Daten aus Websites. Dein Programm:

1. **Sendet HTTP Requests** (wie ein Browser)
2. **Parst HTML** (analysiert den Quellcode)
3. **Extrahiert Daten** (mit CSS Selektoren)
4. **Speichert Daten** (in Datenbank oder Datei)

### Warum Scrapy?

- ⚡ **Asynchron & Parallel**: Hunderte Requests gleichzeitig
- 🔄 **Built-in Features**: Pagination, Retry, Caching
- 🏭 **Production-Ready**: Von Firmen weltweit genutzt

### Deine Mission

Scrape **alle 1000 Bücher** von [books.toscrape.com](https://books.toscrape.com) und lade sie in **Google BigQuery**!

---

## 🎯 Zwei Modi zur Auswahl

### Option A: Fast Crawler ⚡ (Empfohlen für Einsteiger)

**Ziel**: 1000 Bücher schnell scrapen

- Nur Übersichtsseiten scrapen (keine Detail-Klicks)
- 50 Seiten durchlaufen
- **Start-URL**: `https://books.toscrape.com/catalogue/category/books_1/index.html`
- **Extrahierte Felder**: 8 von 13
- **Requests**: ~51

---

### Option B: Full Crawler 🔍 (Für Fortgeschrittene)

**Ziel**: 1000 Bücher mit allen Details

- Jedes Buch einzeln öffnen (Detail-Seite)
- Zusätzliche Daten aus Produkt-Tabelle extrahieren
- **Start-URL**: `https://books.toscrape.com/`
- **Extrahierte Felder**: Alle 13
- **Requests**: ~1081

---

## 📊 Welche Daten sollen extrahiert werden?

### Fast Mode: Übersichtsseiten (8 Informationen)

Von jeder Übersichtsseite sollst du folgende Informationen zu jedem Buch extrahieren:

1. **Dein Name** – Damit wir wissen, wer die Daten gescraped hat
2. **Titel des Buches** – Der vollständige Buchtitel
3. **URL zur Detailseite** – Die vollständige URL zum Buch
4. **Preis** – Was kostet das Buch? (als Zahl, ohne Währungssymbol)
5. **Verfügbarkeit** – Ist das Buch vorrätig? (Ja oder Nein)
6. **Bewertung** – Wie viele Sterne hat das Buch? (1-5)
7. **Bild-URL** – Die URL zum Buchcover
8. **Zeitstempel** – Wann wurde dieses Buch gescraped?

---

### Full Mode: Mit Detailseiten (+5 zusätzliche Informationen)

Zusätzlich zu allen Fast Mode Informationen:

9. **Kategorie** – Zu welcher Kategorie gehört das Buch? (z.B. "Fiction", "Poetry")
10. **Produktcode (UPC)** – Der eindeutige Universal Product Code
11. **Beschreibung** – Der Beschreibungstext des Buches
12. **Anzahl verfügbar** – Wie viele Exemplare sind vorrätig? (als Zahl)
13. **Anzahl Bewertungen** – Wie viele Bewertungen hat das Buch?

---

### ⚠️ Wichtig: BigQuery Integration

Die extrahierten Daten müssen in die BigQuery-Tabelle passen!

**Deine Aufgaben:**
- 🔍 Finde heraus, welche Feldnamen BigQuery erwartet
- 🔍 Finde heraus, welche Datentypen verwendet werden müssen
- 🔍 Stelle sicher, dass deine Daten das richtige Format haben

**Tipps:**
```
"Wie kann ich das Schema einer BigQuery-Tabelle abrufen?"
"Wie konvertiere ich einen Preis-String in eine Zahl?"
"Wie erstelle ich einen ISO 8601 Zeitstempel in Python?"
```

---

## ☁️ BigQuery Setup

### Konfiguration (.env)

Die Credentials sind bereits in der `.env` Datei konfiguriert:

```bash
GOOGLE_CLOUD_PROJECT_ID=holding-llm-sichtbarkeit
BIGQUERY_DATASET_ID=keep_learning_scraper
BIGQUERY_TABLE_ID=scraper_results
GOOGLE_APPLICATION_CREDENTIALS=bigquery_credentials.json
```

### Upload-Methode

Dein Scraper soll Daten in **Batches** hochladen (empfohlen: 100 Items pro Request).

---

## 🤖 Mit Cursor arbeiten

### Dein Workflow:

1. **🎯 Verstehe das Ziel**: Was soll der Scraper machen?
2. **🔍 Analysiere die Website**: Öffne [books.toscrape.com](https://books.toscrape.com) im Browser
3. **💭 Stelle Cursor Fragen**: Sei spezifisch und klar
4. **🔄 Iteriere**: Klein anfangen, dann erweitern
5. **✅ Teste oft**: Nach jeder Änderung testen

### Beispiel-Fragen an Cursor:

```
"Wie kann ich das Schema der BigQuery-Tabelle abrufen?"

"Erstelle ein Scrapy-Projekt für books.toscrape.com"

"Wie finde ich CSS-Selektoren für Buch-Titel auf dieser Website?"

"Wie konvertiere ich '£51.77' zu einem Float-Wert?"

"Wie extrahiere ich eine Zahl aus der CSS-Klasse 'star-rating Three'?"

"Implementiere Pagination, um alle Seiten zu durchlaufen"

"Erstelle eine Scrapy Pipeline, die Daten in Batches zu BigQuery hochlädt"
```

### 💡 Profi-Tipps:

- **Zeige Cursor die Website**: Öffne die HTML-Struktur mit DevTools (F12)
- **Sei präzise**: Nenne exakte Feldnamen und URLs
- **Teste Selektoren**: Nutze `scrapy shell "URL"` zum Testen
- **Frage nach Erklärungen**: "Warum funktioniert dieser Selektor?"

---

## 🎯 Deine Challenges

### Challenge 0: BigQuery Schema verstehen ⭐
- [ ] BigQuery-Tabelle erkunden
- [ ] Feldnamen herausfinden
- [ ] Datentypen verstehen
- [ ] Schema dokumentieren

**Tipp**: Frage Cursor, wie man das Schema einer BigQuery-Tabelle abruft!

---

### Challenge 1: Projekt Setup ⭐
- [ ] Virtual Environment erstellen
- [ ] Scrapy installieren
- [ ] Scrapy-Projekt initialisieren
- [ ] Ersten Spider erstellen

**Tipp**: Frage Cursor nach dem Setup-Workflow für ein Scrapy-Projekt!

---

### Challenge 2: Erste Daten extrahieren ⭐⭐
- [ ] Spider läuft ohne Fehler
- [ ] Mindestens 1 Buch wird gescrapt
- [ ] Titel und Preis werden extrahiert

**Tipp**: Starte mit `scrapy crawl books -o test.json` zum Testen!

---

### Challenge 3: Alle Felder (Fast Mode) ⭐⭐
- [ ] Alle 8 Informationen werden extrahiert (siehe oben)
- [ ] Datentypen entsprechen dem BigQuery-Schema
- [ ] Feldnamen entsprechen dem BigQuery-Schema
- [ ] Dein Name ist als user gespeichert

**Tipp**: Nutze Browser DevTools, um HTML-Struktur zu analysieren!

---

### Challenge 4: Pagination ⭐⭐⭐
- [ ] Spider durchläuft alle 50 Seiten
- [ ] ~1000 Bücher werden gescrapt
- [ ] Keine Duplikate

**Tipp**: Suche nach dem "next" Button in der Pagination!

---

### Challenge 5: BigQuery Integration ⭐⭐⭐
- [ ] Pipeline erstellt
- [ ] Daten werden in Batches hochgeladen
- [ ] Daten erscheinen in BigQuery-Tabelle

**Tipp**: Frage Cursor nach der `google-cloud-bigquery` Library!

---

### Challenge 6: Full Mode (Optional) ⭐⭐⭐⭐
- [ ] Spider öffnet Detailseiten für jedes Buch
- [ ] Zusätzliche 5 Informationen werden extrahiert
- [ ] Alle 13 Felder entsprechen dem BigQuery-Schema

**Tipp**: Nutze `scrapy.Request()` mit `callback` für Detailseiten!

---

## ✅ Testing & Validierung

### Lokaler Test (ohne BigQuery)

```bash
# Virtual Environment aktivieren
source venv/bin/activate

# Spider ausführen (nur erste Seite zum Testen)
scrapy crawl books -o test_output.json -s CLOSESPIDER_PAGECOUNT=1

# Ergebnis prüfen
cat test_output.json | head -n 30
```

### Test mit BigQuery

```bash
# Vollständiger Crawl mit BigQuery Upload
scrapy crawl books
```

### Validierung in BigQuery

```sql
-- Wie viele Bücher hast du heute gescrapt?
SELECT 
    user,
    COUNT(*) as book_count,
    MIN(scraped_at) as first_scrape,
    MAX(scraped_at) as last_scrape
FROM `holding-llm-sichtbarkeit.keep_learning_scraper.scraper_results`
WHERE DATE(scraped_at) = CURRENT_DATE()
GROUP BY user
ORDER BY book_count DESC;
```

---

## 🐛 Troubleshooting

### "Scraped 0 books"
→ CSS Selektoren sind falsch. Teste mit `scrapy shell "https://books.toscrape.com"`

### "BigQuery Access Denied"
→ Prüfe, ob `bigquery_credentials.json` existiert

### "TypeError: not JSON serializable"
→ Prüfe Datentypen (Float, Boolean, ISO-String für Timestamp)

### Spider zu langsam
→ Erhöhe `CONCURRENT_REQUESTS` in `settings.py`

---

## 📚 Nützliche Ressourcen

- **Scrapy Dokumentation**: https://docs.scrapy.org
- **CSS Selektoren Tutorial**: https://www.w3schools.com/cssref/css_selectors.asp
- **BigQuery Python Client**: https://cloud.google.com/python/docs/reference/bigquery/latest
- **Übungs-Website**: https://books.toscrape.com

---

## 🏆 Leaderboard

Wer scraped die meisten Bücher? Schau dir die BigQuery-Tabelle an!

---

## 🆘 Hilfe & Support

**Stuck?** 
1. 🤖 Frage Cursor (zeige ihm die Fehlermeldung)
2. 👨‍🏫 Workshop-Leiter fragen
3. 👥 Pair Programming mit Kollegen

---

**Viel Erfolg! 🚀**
