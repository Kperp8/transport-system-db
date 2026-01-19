-- 1. PASAŻEROWIE Z ULGAMI (JOIN)
SELECT 
    CONCAT(p.imie, ' ', p.nazwisko) AS pasazer,
    u.nazwa_ulgi,
    CONCAT(u.procent_znizki, '%') AS znizka
FROM Pasazerowie p
LEFT JOIN Slownik_Ulg u ON p.id_ulgi = u.id_ulgi;

-- 2. BILETY ZE STATUSEM (CASE, MULTI-JOIN)
SELECT 
    bs.kod_biletu,
    CONCAT(p.imie, ' ', p.nazwisko) AS pasazer,
    bd.nazwa_biletu,
    CASE 
        WHEN NOW() BETWEEN bs.data_waznosci_od AND bs.data_waznosci_do THEN 'AKTYWNY'
        ELSE 'WYGASŁY'
    END AS status
FROM Bilety_Sprzedane bs
JOIN Pasazerowie p ON bs.id_pasazera = p.id_pasazera
JOIN Bilety_Definicje bd ON bs.id_definicji = bd.id_definicji;

-- 3. WIDOK - RAPORT PRZYCHODÓW
SELECT * FROM Raport_Przychodow_Total;

-- 4. AGREGACJE - STATYSTYKI BILETÓW
SELECT 
    bd.nazwa_biletu,
    COUNT(bs.id_biletu) AS sprzedane,
    SUM(pl.kwota_brutto) AS przychod
FROM Bilety_Definicje bd
LEFT JOIN Bilety_Sprzedane bs ON bd.id_definicji = bs.id_definicji
LEFT JOIN Platnosci pl ON bs.id_biletu = pl.id_biletu
GROUP BY bd.id_definicji;

-- 5. PARTYCJE - BILETY WG LAT
SELECT YEAR(data_waznosci_od) AS rok, COUNT(*) AS liczba
FROM Bilety_Sprzedane
GROUP BY YEAR(data_waznosci_od);

-- 6. FUNKCJA CzyBiletWazny
SELECT bs.kod_biletu, CzyBiletWazny(bs.id_biletu, 1) AS wazny
FROM Bilety_Sprzedane bs LIMIT 3;

-- 7. SYSTEM VERSIONING - HISTORIA
SELECT id_pasazera, imie, nazwisko, ROW_START, ROW_END
FROM Pasazerowie FOR SYSTEM_TIME ALL
WHERE id_pasazera = 1;

-- 8. PROCEDURA ZakupBiletu
CALL ZakupBiletu(1, 1, 1);

-- 9. PROCEDURA WykonajKontrole
CALL WykonajKontrole_UczciwyMandat('K-100', 'TRAM-01', 'QR-JAN-OK');

-- 10. PODSUMOWANIE
SELECT 
    (SELECT COUNT(*) FROM Pasazerowie) AS pasazerowie,
    (SELECT COUNT(*) FROM Bilety_Sprzedane) AS bilety,
    (SELECT COUNT(*) FROM Kontrole_Biletow) AS kontrole,
    (SELECT SUM(kwota_brutto) FROM Platnosci) AS przychod;
