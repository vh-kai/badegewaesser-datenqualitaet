-- 1. Datenmodell/Primärschlüssel: Primary Keys bestimmen

-- zusammengesetzter Primary Key badesaison: BADEGEWAESSERID + SAISONBEGINN
SELECT BADEGEWAESSERID,
	SAISONBEGINN,
	COUNT(*) AS Anzahl
FROM badesaison
GROUP BY BADEGEWAESSERID,
	SAISONBEGINN
HAVING Anzahl > 1;

/* zusammengesetzter Primary Key einstufung: BADEGEWAESSERID + BEURTEILUNGSZEITRAUM_VON + BEURTEILUNGSZEITRAUM_BIS +
 EINSTUFUNG_ODER_VORABBEWERTUNG--> alle Spalten */
SELECT BADEGEWAESSERID,	
	BEURTEILUNGSZEITRAUM_VON,
	BEURTEILUNGSZEITRAUM_BIS,
	EINSTUFUNG_ODER_VORABBEWERTUNG,
	COUNT(*) AS Anzahl
FROM einstufung
GROUP BY BADEGEWAESSERID, 
	BEURTEILUNGSZEITRAUM_VON,  
	BEURTEILUNGSZEITRAUM_BIS, 
	EINSTUFUNG_ODER_VORABBEWERTUNG
HAVING Anzahl > 1;

-- zusammengesetzter Primary Key infrastruktur: BADEGEWAESSERID + INFRASTRUKTURID
SELECT BADEGEWAESSERID,
	INFRASTRUKTURID,
	COUNT(*) AS Anzahl
FROM infrastruktur
GROUP BY BADEGEWAESSERID,
	INFRASTRUKTURID
HAVING Anzahl > 1;

-- zusammengesetzter Primary Key messungen: BADEGEWAESSERID + PROBEID
SELECT BADEGEWAESSERID,
	PROBEID,
	COUNT(*) AS Anzahl
FROM messungen
GROUP BY BADEGEWAESSERID,
	PROBEID
HAVING Anzahl > 1;

-- Primary Key stammdaten: BADEGEWAESSERID
SELECT BADEGEWAESSERID,
	COUNT(*) AS Anzahl
FROM stammdaten
GROUP BY BADEGEWAESSERID
HAVING Anzahl > 1;


/* 2. Referentielle Integrität
Für die Tabellen badesaison, einstufung, infrastruktur und messungen wurde geprüft, ob jede verwendete BADEGEWAESSERID in stammdaten vorhanden ist.

Insgesamt wurden 27 unterschiedliche BADEGEWAESSERID identifiziert, die in mindestens einer der abhängigen Tabellen verwendet werden,
aber nicht in stammdaten vorhanden sind.

Die 27 IDs treten dabei nicht in allen abhängigen Tabellen auf:
- badesaison: 26
- einstufung: 27
- infrastruktur: 22
- messungen: 19

Die Ursache dieser Abweichung konnte anhand der verfügbaren Datensatzbeschreibung nicht eindeutig bestimmt werden. */

-- es gibt bei badesaison 26 BADEGEWAESSERID, die nicht in stammdaten vorkommen
SELECT DISTINCT b.BADEGEWAESSERID AS badesaison_ID
FROM badesaison b
LEFT JOIN stammdaten s
ON b.BADEGEWAESSERID = s.BADEGEWAESSERID
WHERE s.BADEGEWAESSERID IS NULL
ORDER BY b.BADEGEWAESSERID;

-- es gibt bei einstufung 27 BADEGEWAESSERID, die nicht in stammdaten vorkommen
SELECT DISTINCT e.BADEGEWAESSERID AS einstufung_ID
FROM einstufung e
LEFT JOIN stammdaten s
ON e.BADEGEWAESSERID = s.BADEGEWAESSERID
WHERE s.BADEGEWAESSERID IS NULL
ORDER BY e.BADEGEWAESSERID;

-- es gibt bei infrastruktur 22 BADEGEWAESSERID, die nicht in stammdaten vorkommen
SELECT DISTINCT i.BADEGEWAESSERID AS infrastruktur_ID
FROM infrastruktur i
LEFT JOIN stammdaten s
ON i.BADEGEWAESSERID = s.BADEGEWAESSERID
WHERE s.BADEGEWAESSERID IS NULL
ORDER BY i.BADEGEWAESSERID;

-- es gibt bei messungen 19 BADEGEWAESSERID, die nicht in stammdaten vorkommen
SELECT DISTINCT m.BADEGEWAESSERID AS messungen_ID
FROM messungen m
LEFT JOIN stammdaten s
ON m.BADEGEWAESSERID = s.BADEGEWAESSERID
WHERE s.BADEGEWAESSERID IS NULL
ORDER BY m.BADEGEWAESSERID;


-- 3. Vollständigkeit

-- 3.1 Die Felder der angenommenen Primary Keys auf Vollständigkeit prüfen

-- Primary Key-Felder in badesaison sind vollständig
SELECT COUNT(*) 
FROM badesaison
WHERE BADEGEWAESSERID IS NULL
   OR SAISONBEGINN IS NULL;

-- In der Tabelle einstufung wurden zwei Datensätze mit einem fehlenden Wert in EINSTUFUNG_ODER_VORABBEWERTUNG festgestellt. 
-- Die übrigen Bestandteile des angenommenen zusammengesetzten Primärschlüssels sind vorhanden.   
SELECT *
FROM einstufung
WHERE BADEGEWAESSERID IS NULL
   OR BEURTEILUNGSZEITRAUM_VON IS NULL
   OR BEURTEILUNGSZEITRAUM_BIS IS NULL
   OR EINSTUFUNG_ODER_VORABBEWERTUNG IS NULL;
   
-- Primary Key-Felder in infrastruktur sind vollständig
SELECT COUNT(*) 
FROM infrastruktur
WHERE BADEGEWAESSERID IS NULL
   OR INFRASTRUKTURID IS NULL;
   
-- Primary Key-Felder in messungen sind vollständig
SELECT COUNT(*) 
FROM messungen
WHERE BADEGEWAESSERID IS NULL
   OR PROBEID IS NULL;
   
-- Primary Key-Felder in stammdaten sind vollständig
SELECT COUNT(*) 
FROM stammdaten
WHERE BADEGEWAESSERID IS NULL;

-- 3.2 Die Felder MESSSTELLENNAME, MESSSTELLENID und DATUMMESSUNG der Tabelle messungen auf Vollständigkeit prüfen

-- Gibt es Messungen ohne MESSSTELLENNAME? --> nein
SELECT COUNT(*)
FROM messungen
WHERE MESSSTELLENNAME IS NULL;

-- Gibt es Messungen ohne MESSSTELLENID? --> nein
SELECT COUNT(*)
FROM messungen
WHERE MESSSTELLENID IS NULL;

-- Gibt es Messungen ohne DATUMMESSUNG? --> nein
SELECT COUNT(*)
FROM messungen
WHERE DATUMMESSUNG IS NULL;

-- 3.3 Die Felder der Messparameter auf Vollständigkeit prüfen

-- Gibt es Messungen ohne einen Wert für ECOLI? --> 11 Messungen
SELECT COUNT(*)
FROM messungen
WHERE ECOLI IS NULL;

-- Gibt es Messungen ohne einen Wert für INTEST_ENTEROKOKKEN? --> 15 Messungen
SELECT COUNT(*)
FROM messungen
WHERE INTEST_ENTEROKOKKEN IS NULL;

-- Gibt es Messungen ohne einen Wert für WASSERTEMP? --> 421 Messungen
SELECT COUNT(*)
FROM messungen
WHERE WASSERTEMP IS NULL;

-- Gibt es Messungen ohne einen Wert für LUFTTEMP? --> 25 Messungen
SELECT COUNT(*)
FROM messungen
WHERE LUFTTEMP IS NULL;

-- Gibt es Messungen ohne einen Wert für SICHTTIEFE? --> 2315 Messungen
SELECT COUNT(*)
FROM messungen
WHERE SICHTTIEFE IS NULL;

-- Gibt es Messungen ganz ohne Messwert? --> 1 Messung
SELECT COUNT(*)
FROM messungen
WHERE ECOLI IS NULL
	AND INTEST_ENTEROKOKKEN IS NULL
	AND WASSERTEMP IS NULL
	AND LUFTTEMP IS NULL
	AND SICHTTIEFE IS NULL;

/* 3.4 Anteile fehlender Messwerte je Messstelle
Welche Messstellen weisen im Vergleich zu den übrigen Messstellen besonders hohe Anteile fehlender Messwerte auf?
Zur Identifikation von Messstellen mit vergleichsweise hohen Fehlwertanteilen wurde das 90. Perzentil der Fehlwertanteile über alle 
Messstellen bestimmt. Das 90. Perzentil entspricht einem Fehlwertanteil von 7,84 %. Messstellen oberhalb dieses Schwellenwerts werden 
als vergleichsweise auffällig eingestuft.
Messstellen mit einem Fehlwertanteil oberhalb dieses Schwellenwerts wurden als auffällig hohe Fehlwertanteile eingestuft.
*/

WITH anteile AS (
    SELECT
        MESSSTELLENID,
        MESSSTELLENNAME,
        COUNT(*) AS anzahl_proben,
        SUM(
            CASE WHEN ECOLI IS NULL THEN 1 ELSE 0 END
            + CASE WHEN INTEST_ENTEROKOKKEN IS NULL THEN 1 ELSE 0 END
            + CASE WHEN WASSERTEMP IS NULL THEN 1 ELSE 0 END
            + CASE WHEN LUFTTEMP IS NULL THEN 1 ELSE 0 END
            + CASE WHEN SICHTTIEFE IS NULL THEN 1 ELSE 0 END
        ) AS anzahl_fehlende_messwerte
    FROM messungen
    GROUP BY MESSSTELLENID, MESSSTELLENNAME
),

sortiert AS (
    SELECT
        MESSSTELLENID,
        MESSSTELLENNAME,
        anzahl_proben,
        anzahl_fehlende_messwerte,
        anzahl_fehlende_messwerte * 100.0 / (anzahl_proben * 5)
            AS anteil_fehlende_werte,
        ROW_NUMBER() OVER (
            ORDER BY
                anzahl_fehlende_messwerte * 100.0 / (anzahl_proben * 5)
        ) AS rang,
        COUNT(*) OVER () AS anzahl_stationen
    FROM anteile
),

position AS (
    SELECT
        CAST(0.90 * anzahl_stationen AS INTEGER)
        + CASE
            WHEN 0.90 * anzahl_stationen
                 > CAST(0.90 * anzahl_stationen AS INTEGER)
            THEN 1
            ELSE 0
          END AS perzentil_position
    FROM sortiert
    LIMIT 1
),

p90 AS (
    SELECT
        s.anteil_fehlende_werte
    FROM sortiert s
    CROSS JOIN position p
    WHERE s.rang = p.perzentil_position
)

SELECT
    s.MESSSTELLENID,
    s.MESSSTELLENNAME,
    s.anzahl_proben,
    s.anzahl_fehlende_messwerte,
    s.anteil_fehlende_werte
FROM sortiert s
CROSS JOIN p90
WHERE s.anteil_fehlende_werte > p90.anteil_fehlende_werte
ORDER BY s.anteil_fehlende_werte DESC;


-- 4. Konsistenz

-- 4.1 Gewässerkategorie ↔ Küstengewässer 
-- Gibt es Messungen der GEWAESSERKATEGORIE 'Küstengewässer' ohne eine Angabe in KUESTENGEWAESSER? --> nein
SELECT COUNT(*)
FROM messungen
WHERE GEWAESSERKATEGORIE = 'Küstengewässer'
	AND KUESTENGEWAESSER IS NULL;

-- 4.2 Messstellen-ID ↔ Messstellenname
-- Ist MESSSTELLENID eindeutig für MESSSTELLENNAME? --> Jede MESSSTELLENID ist innerhalb der messungen-Tabelle eindeutig einem Messstellennamen zugeordnet. 
SELECT MESSSTELLENID,
    COUNT(DISTINCT MESSSTELLENNAME) AS anzahl_namen
FROM messungen
GROUP BY MESSSTELLENID
HAVING COUNT(DISTINCT MESSSTELLENNAME) > 1;

/* Werden gleiche Messstellennamen für mehrere MESSSTELLENID verwendet? 
--> Es gibt 9 Messstellennamen, die jeweils mehreren unterschiedlichen MESSSTELLENID zugeordnet sind. */
SELECT MESSSTELLENNAME,
    COUNT(DISTINCT MESSSTELLENID) AS anzahl_namen
FROM messungen
GROUP BY MESSSTELLENNAME
HAVING COUNT(DISTINCT MESSSTELLENID) > 1;

-- 4.3 Überwachungsart-ID ↔ Überwachungsarttext
/* Sind einer UEBERWACHUNGSARTID mehrere unterschiedliche UEBERWASCHUNGSARTTEXT zugeordnet? -> Jede UEBERWACHUNGSARTID ist innerhalb der messungen-Tabelle eindeutig einem Überwachungsarttext 
zugeordnet. */
SELECT UEBERWACHUNGSARTID,
    COUNT(DISTINCT UEBERWASCHUNGSARTTEXT) AS anzahl_texte
FROM messungen
GROUP BY UEBERWACHUNGSARTID
HAVING COUNT(DISTINCT UEBERWASCHUNGSARTTEXT) > 1;

/* Sind einem UEBERWASCHUNGSARTTEXT mehrere unterschiedliche UEBERWACHUNGSARTID zugeordnet? 
--> Jede UEBERWACHUNGSARTTEXT ist innerhalb der messungen-Tabelle eindeutig eine Überwachungs-ID zugeordnet. */
SELECT UEBERWASCHUNGSARTTEXT,
    COUNT(DISTINCT UEBERWACHUNGSARTID) AS anzahl_ids
FROM messungen
GROUP BY UEBERWASCHUNGSARTTEXT
HAVING COUNT(DISTINCT UEBERWACHUNGSARTID) > 1;

/* 5. Plausibilität der Wertebereiche:
    Als Plausibilitätsannahmen wurden folgende Wertebereiche verwendet:
    Wassertemperatur: -5 bis 30 °C
    Lufttemperatur: -10 bis 40 °C
    Sichttiefe: 0 bis 10 m
*/

-- 5.1 Temperaturen
-- 32 °C, 32 °C, 129 °C
SELECT WASSERTEMP
FROM messungen
WHERE WASSERTEMP > 30
	OR WASSERTEMP < -5
ORDER BY WASSERTEMP;

-- 114 °C, 115 °C, 150 °C, 174 °C, 177 °C, 270 °C
SELECT LUFTTEMP
FROM messungen
WHERE LUFTTEMP > 40
	OR LUFTTEMP < -10
ORDER BY LUFTTEMP;

-- 5.2 Sichttiefe
-- -9.9 m, -9.9 m, -9.9 m, -1.0 m, 11.0 m, 20.0 m, 20.0 m, 20.0 m, 20.0 m, 99.0 m
SELECT SICHTTIEFE
FROM messungen
WHERE SICHTTIEFE > 10
	OR SICHTTIEFE < 0;

-- 5.3 negative mikrobiologische Werte
-- keine Werte 
SELECT COUNT(*)
FROM messungen
WHERE ECOLI < 0;
	
-- keine Werte 
SELECT COUNT(*)
FROM messungen
WHERE INTEST_ENTEROKOKKEN < 0;

-- 5.4 Datumsformat --> keine Werte
SELECT DATUMMESSUNG
FROM messungen
WHERE LENGTH (DATUMMESSUNG) != 10
	OR SUBSTR (DATUMMESSUNG, 3, 1) != '.'
	OR SUBSTR (DATUMMESSUNG, 6, 1) != '.'
	OR CAST(SUBSTR (DATUMMESSUNG, 1, 2) AS INTEGER) > 31
	OR CAST(SUBSTR (DATUMMESSUNG, 1, 2) AS INTEGER) < 1
	OR CAST(SUBSTR (DATUMMESSUNG, 4, 2) AS INTEGER) > 12
	OR CAST(SUBSTR (DATUMMESSUNG, 4, 2) AS INTEGER) < 1
	OR CAST(SUBSTR (DATUMMESSUNG, 7, 4) AS INTEGER) > 2026;
