# 🕷️ Web Scraping Workshop mit Cursor

Ein hands-on Workshop zum Erlernen von Web Scraping mit Scrapy, BigQuery und AI-gestützter Entwicklung.

---

## 🤔 Was ist Web Scraping?

**Web Scraping** ist das automatische Extrahieren von Daten aus Websites. Statt manuell Daten zu kopieren, schreibst du ein Programm, das:

1. **HTTP Requests** sendet (wie ein Browser)
2. **HTML parst** (den Quellcode analysiert)
3. **Daten extrahiert** (mit CSS Selektoren bestimmte Elemente findet)
4. **Daten speichert** (in Datenbank oder Datei)

### Warum Scrapy?

- ⚡ **Asynchron & Parallel**: Hunderte Requests gleichzeitig
- 🔄 **Built-in Features**: Pagination, Retry, Caching
- 🏭 **Production-Ready**: Von Firmen weltweit genutzt

### Heute

Wir scrapen **alle 1000 Bücher** von [books.toscrape.com](https://books.toscrape.com) (einer Übungs-Website) und laden sie in **Google BigQuery**.

---

## 🎯 Deine Aufgabe

Wähle **EINEN** der beiden Modi und baue den Scraper mit Cursor:

### Option A: Fast Crawler ⚡ (Empfohlen für Einsteiger)

**Ziel**: 1000 Bücher schnell scrapen

**Vorgehen**:
- Nur Übersichtsseiten scrapen (keine Detail-Klicks)
- 50 Seiten Pagination durchlaufen
- Weniger HTTP Requests = Schneller fertig

**Start-URL**: `https://books.toscrape.com/catalogue/category/books_1/index.html`

**Extrahierte Felder**: 8 von 13
- ✅ user, title, url, price, available, rating, image_url, scraped_at
- ❌ category, upc, description, num_available, num_reviews

**Requests**: ~51

---

### Option B: Full Crawler 🔍 (Für Fortgeschrittene)

**Ziel**: 1000 Bücher mit allen Details

**Vorgehen**:
- Alle 50 Kategorien durchlaufen
- Jede Buchliste besuchen
- Jedes Buch einzeln öffnen (Detail-Seite)
- Zusätzliche Daten aus Produkt-Tabelle extrahieren

**Start-URL**: `https://books.toscrape.com/`

**Extrahierte Felder**: Alle 13
- ✅ Alles aus Fast Mode +
- ✅ category, upc, description, num_available, num_reviews

**Requests**: ~1081

---

## 📊 BigQuery Schema

Dein Scraper **MUSS** diese exakte Struktur produzieren:

| Feld | Typ | Pflicht? | Beschreibung | Verfügbar in |
|------|-----|----------|--------------|--------------|
| **user** | STRING | ✅ REQUIRED | **Dein Name** (z.B. "Max") | Fast + Full |
| **title** | STRING | ✅ REQUIRED | Buchtitel | Fast + Full |
| **url** | STRING | ✅ REQUIRED | URL zur Detailseite | Fast + Full |
| **price** | FLOAT | ✅ REQUIRED | Preis in GBP | Fast + Full |
| **available** | BOOLEAN | ✅ REQUIRED | `true` = In Stock, `false` = Out of Stock | Fast + Full |
| **rating** | INTEGER | ✅ REQUIRED | Bewertung (1-5 Sterne) | Fast + Full |
| **image_url** | STRING | ✅ REQUIRED | URL zum Buchcover | Fast + Full |
| **scraped_at** | TIMESTAMP | ✅ REQUIRED | Zeitstempel des Scrapings | Fast + Full |
| category | STRING | ❌ NULLABLE | Buchkategorie (z.B. "Fiction") | Nur Full |
| upc | STRING | ❌ NULLABLE | Universal Product Code | Nur Full |
| description | STRING | ❌ NULLABLE | Produktbeschreibung | Nur Full |
| num_available | INTEGER | ❌ NULLABLE | Anzahl verfügbare Exemplare | Nur Full |
| num_reviews | INTEGER | ❌ NULLABLE | Anzahl Bewertungen | Nur Full |

### ⚠️ Wichtig: Das `user` Feld

**Fülle das `user` Feld mit deinem eigenen Namen!**

```python
item['user'] = "Dein Name"  # z.B. "Max", "Lisa", "Mohammed"
```

So können wir später sehen, wer wie viele Bücher gescrapt hat! 🏆

---

## ☁️ BigQuery Integration

### Setup (bereits vorbereitet)

Die BigQuery-Infrastruktur muss eingerichtet werden:

- **Projekt**: `your-project-id` (in `.env` konfigurieren)
- **Dataset**: `your-dataset-id` (in `.env` konfigurieren)
- **Tabelle**: `your-table-id` (in `.env` konfigurieren)
- **Credentials**: `credentials.json` (Service Account Key)

### Upload-Methode

Dein Scraper soll Daten in **Batches** hochladen (effizienter als einzeln):

```python
from google.cloud import bigquery

client = bigquery.Client(project="your-project-id")
table_id = "your-project-id.your-dataset-id.your-table-id"

# Batch Insert (empfohlen: 100 Items pro Request)
errors = client.insert_rows_json(table_id, rows)
if errors:
    print(f"Fehler: {errors}")
```

### Datenformat für BigQuery

BigQuery erwartet JSON mit **spezifischen Typen**:

```json
{
  "user": "Max",
  "title": "A Light in the Attic",
  "url": "https://books.toscrape.com/catalogue/book_123.html",
  "price": 51.77,
  "available": true,
  "rating": 3,
  "image_url": "https://books.toscrape.com/media/cache/cover.jpg",
  "scraped_at": "2025-10-06T14:30:00",
  "category": "Poetry",
  "upc": "a897fe39b1053632",
  "description": "It's hard to imagine...",
  "num_available": 22,
  "num_reviews": 0
}
```

**Wichtige Details**:
- ✅ `scraped_at`: ISO 8601 String (z.B. `"2025-10-06T14:30:00"`)
- ✅ `available`: Boolean (`true`/`false`), **nicht** String (`"In stock"`)
- ✅ `price`: Float (z.B. `51.77`), **nicht** String (`"£51.77"`)
- ✅ `rating`: Integer (z.B. `3`), **nicht** String (`"Three"`)

---

## 🤖 Mit Cursor arbeiten

### Beispiel-Prompts für Cursor

#### 1. Projekt-Setup
```
Erstelle ein Scrapy-Projekt für books.toscrape.com.

Spider-Name: 'books'
Start-URL: https://books.toscrape.com/catalogue/category/books_1/index.html

Extrahiere folgende Felder:
- title, price, rating, image_url, url
```

#### 2. CSS Selektoren finden
```
Analysiere die HTML-Struktur von https://books.toscrape.com 
und finde die CSS Selektoren für:
- Container aller Bücher
- Buchtitel
- Preis
- Bewertung (Rating-Klasse)
- Bild-URL
```

#### 3. Pagination implementieren
```
Erweitere den Spider um Pagination.
Finde den "next" Button und folge allen Seiten bis zur letzten.
```

#### 4. BigQuery Pipeline
```
Erstelle eine Scrapy Pipeline, die Items zu BigQuery hochlädt.

Projekt: [aus .env laden]
Dataset: [aus .env laden]
Tabelle: [aus .env laden]
Batch-Size: 100

Schema: [siehe BigQuery Schema oben]
```

#### 5. Detailseiten (Full Mode)
```
Erweitere den Spider um Detailseiten.
Von jeder Übersichtsseite soll auf das Buch geklickt werden.
Extrahiere aus der Produkttabelle:
- UPC
- Description  
- Anzahl verfügbare Exemplare (aus Text "In stock (22 available)")
```

### Tipps für effektives Prompting

1. **Sei spezifisch**: Nenne exakte URLs, Feldnamen, Selektoren
2. **Zeige Beispiele**: Zeige Cursor die Ziel-Website oder HTML-Struktur
3. **Frage nach Erklärungen**: "Erkläre, wie dieser CSS Selektor funktioniert"
4. **Iteriere**: Erst Basics, dann erweitern
5. **Teste häufig**: Nach jeder Änderung kurz testen

---

## 📋 HTML-Struktur (Spickzettel)

### Übersichtsseite (Fast Mode)

```html
<article class="product_pod">
    <div class="image_container">
        <a href="book-url.html">
            <img src="cover.jpg" alt="Book Title">
        </a>
    </div>
    <h3>
        <a href="book-url.html" title="A Light in the Attic">
            A Light in the...
        </a>
    </h3>
    <div class="product_price">
        <p class="price_color">£51.77</p>
        <p class="instock availability">In stock</p>
    </div>
    <p class="star-rating Three"></p>
</article>
```

**Wichtige Selektoren**:
- Container: `article.product_pod`
- Titel: `h3 a::attr(title)`
- Preis: `p.price_color::text`
- Rating: `p.star-rating::attr(class)`
- Bild: `img::attr(src)`
- Verfügbarkeit: `p.instock.availability::text`

### Detailseite (Full Mode)

```html
<table class="table table-striped">
    <tr>
        <th>UPC</th>
        <td>a897fe39b1053632</td>
    </tr>
    <tr>
        <th>Availability</th>
        <td>In stock (22 available)</td>
    </tr>
    <tr>
        <th>Number of reviews</th>
        <td>0</td>
    </tr>
</table>

<div id="product_description">
    <p>It's hard to imagine a world without A Light in the Attic...</p>
</div>
```

**Wichtige Selektoren**:
- UPC: `table tr:contains("UPC") td::text`
- Verfügbarkeit: `table tr:contains("Availability") td::text`
- Bewertungen: `table tr:contains("Number of reviews") td::text`
- Beschreibung: `#product_description + p::text`

---

## ✅ Validierung & Testing

### Checkliste: Ist dein Scraper fertig?

- [ ] Spider läuft ohne Fehler
- [ ] Mindestens 100 Bücher werden gescrapt
- [ ] Alle **REQUIRED** Felder sind befüllt
- [ ] `user` Feld enthält **deinen Namen**
- [ ] BigQuery Upload funktioniert
- [ ] Daten erscheinen in BigQuery-Tabelle

### Test-Query für BigQuery

Prüfe, ob deine Daten angekommen sind:

```sql
-- Wie viele Bücher hast du heute gescrapt?
SELECT 
    user,
    COUNT(*) as book_count,
    MIN(scraped_at) as first_scrape,
    MAX(scraped_at) as last_scrape
FROM `your-project-id.your-dataset-id.your-table-id`
WHERE DATE(scraped_at) = CURRENT_DATE()
GROUP BY user
ORDER BY book_count DESC;
```

### Lokaler Test (ohne BigQuery)

Teste deinen Spider zuerst mit JSON-Output:

```bash
# Scrapy ausführen
scrapy crawl books -o test_output.json

# Prüfe die Datei
cat test_output.json | jq '.[0]'  # Erstes Buch anzeigen
```

---

## 🐛 Troubleshooting

### Problem: "Scraped 0 books"

**Ursache**: CSS Selektor ist falsch

**Lösung**: Teste mit Scrapy Shell
```bash
scrapy shell "https://books.toscrape.com"
>>> response.css('article.product_pod').getall()
>>> response.css('h3 a::attr(title)').get()
```

---

### Problem: "BigQuery Access Denied"

**Ursache**: Credentials nicht gefunden

**Lösung**: Prüfe Umgebungsvariable
```bash
echo $GOOGLE_APPLICATION_CREDENTIALS
# Sollte zeigen: /path/to/credentials.json
```

Oder setze in `.env`:
```bash
GOOGLE_APPLICATION_CREDENTIALS=credentials.json
```

---

### Problem: "TypeError: Object of type datetime is not JSON serializable"

**Ursache**: BigQuery will ISO String, nicht datetime Object

**Lösung**: Konvertiere zu String
```python
from datetime import datetime

item['scraped_at'] = datetime.now().isoformat()
# Ergebnis: "2025-10-06T14:30:00"
```

---

### Problem: Duplikate in BigQuery

**Ursache**: Mehrere Runs ohne Deduplication

**Lösung**: Nutze URL als eindeutigen Key
```python
# In Pipeline: Prüfe, ob URL schon existiert
seen_urls = set()

if item['url'] not in seen_urls:
    seen_urls.add(item['url'])
    # Upload to BigQuery
```

---

## 📚 Nützliche Ressourcen

- **Scrapy Docs**: https://docs.scrapy.org
- **CSS Selektoren**: https://www.w3schools.com/cssref/css_selectors.asp
- **BigQuery Python Client**: https://cloud.google.com/python/docs/reference/bigquery/latest
- **Übungs-Website**: https://books.toscrape.com

---

## 🆘 Hilfe & Support

**Stuck?** Frage:
1. Cursor (zeige ihm die Fehlermeldung)
2. Workshop-Leiter
3. Kollegen (Pair Programming!)

---

**Viel Erfolg! 🚀**


