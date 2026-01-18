# Dokumentacja Struktury Bazy Danych - System Transportu Publicznego

## 1. Tabele Słownikowe (Słowniki)

Tabele te pełnią rolę centralnych rejestrów dla stałych wartości. Dzięki nim unikamy błędów w pisowni i ułatwiamy rozbudowę systemu (np. dodanie nowej strefy bez zmiany kodu bazy).

- **Slownik_Stref**: Definiuje obszary obowiązywania biletów (np. Strefa I - Miasto, Strefa II - Aglomeracja).
- **Slownik_Ulg**: Przechowuje rodzaje dostępnych ulg (np. Student 50%, Senior 37%) wraz z ich wartością procentową wykorzystywaną do obliczeń.
- **Slownik_Metod_Platnosci**: Definiuje dostępne formy płatności (np. Aplikacja, Karta płatnicza, BLIK).
- **Slownik_Typow_Linii**: Określa rodzaj transportu (np. Tramwaj, Autobus, Metro).
- **Slownik_Statusow_Wezwan**: Statusy wezwań do zapłaty/mandatów (Oczekujące, Opłacone, Anulowane).

## 2. Infrastruktura i Logika Tras

### Przystanki

Definiuje wszystkie fizyczne punkty zatrzymywania się pojazdów.

- `id_przystanku` – Klucz główny.
- `nazwa_przystanku` – Pełna nazwa przystanku (np. "Centrum Handlowe").
- `id_strefy` – Klucz obcy przypisujący przystanek do strefy biletowej.
- `lokalizacja` – Współrzędne GPS przystanku (typ POINT).

### Trasy

Tabela definiująca konkretną linię komunikacyjną.

- `id_trasy` – Klucz główny.
- `numer_linii` – Krótkie oznaczenie linii (np. "10", "200").
- `id_typu_linii` – Klucz obcy określający typ (np. autobusowa, tramwajowa).

### Trasy_Przystanki

Tabela łącząca (wiele-do-wielu), definiująca przebieg linii.

- `id_trasy`, `id_przystanku` – Klucze obce tworzące relację.
- `kolejnosc` – Numer porządkowy przystanku na danej trasie.

### Pojazdy

Rejestr fizycznych jednostek taboru.

- `id_pojazdu` – Klucz główny.
- `numer_boczny` – Unikalny identyfikator pojazdu (np. "TRAM-01", "BUS-02").
- `id_trasy` – Klucz obcy wskazujący linię, na której aktualnie kursuje pojazd.
- `id_aktualnego_przystanku` – Klucz obcy wskazujący bieżącą lokalizację pojazdu.

## 3. System Biletowy i Finansowy

### Bilety_Definicje

Wzorzec biletów dostępnych w ofercie.

- `id_definicji` – Klucz główny.
- `nazwa_biletu` – Opis handlowy (np. "Miejski (Strefa 1)", "Aglomeracyjny (Strefa 2)").
- `id_strefy` – Klucz obcy określający strefę obowiązywania biletu.
- `cena_bazowa_brutto` – Cena wyjściowa biletu przed nałożeniem ulgi.
- `czas_minuty` – Czas ważności biletu w minutach (domyślnie 60).

### Bilety_Sprzedane

Rejestr zakupionych i unikalnych biletów przypisanych do pasażerów. Tabela posiada partycjonowanie po roku oraz wersjonowanie systemowe.

- `id_biletu` – Klucz główny.
- `kod_biletu` – Unikalny identyfikator (np. kod QR).
- `id_pasazera` – Klucz obcy łączący bilet z właścicielem.
- `id_definicji` – Klucz obcy do wzorca biletu.
- `id_ulgi` – Klucz obcy do zastosowanej ulgi.
- `data_zakupu` – Moment zakupu biletu.
- `data_waznosci_od` / `data_waznosci_do` – Ramy czasowe ważności biletu.

### Platnosci

Szczegóły finansowe każdej transakcji zakupu biletu.

- `id_platnosci` – Klucz główny.
- `id_biletu` – Klucz obcy do opłaconego biletu.
- `kwota_netto` – Wartość przed opodatkowaniem.
- `stawka_vat` – Procentowa wartość podatku (domyślnie 8.00).
- `kwota_brutto` – Pełna cena zapłacona przez klienta.
- `id_metody` – Klucz obcy określający sposób zapłaty.
- `data_platnosci` – Moment zaksięgowania płatności.

## 4. Ludzie i Kontrole

### Pasazerowie

Rejestr użytkowników systemu.

- `id_pasazera` – Klucz główny.
- `imie`, `nazwisko` – Dane osobowe.
- `email` – Adres email (musi być unikalny).
- `id_ulgi` – Klucz obcy do przysługującej ulgi.
- `data_rejestracji` – Moment dołączenia do systemu.

### Kontrolerzy

Pracownicy uprawnieni do weryfikacji biletów.

- `id_kontrolera` – Klucz główny.
- `numer_sluzbowy` – Unikalny identyfikator pracownika (np. "K-100").
- `imie`, `nazwisko` – Dane osobowe kontrolera.
- `aktywny` – Status zatrudnienia (umożliwia blokadę dostępu).

### Kontrole_Biletow

Rejestr zdarzeń sprawdzania biletów w terenie.

- `id_kontroli` – Klucz główny.
- `data_kontroli` – Moment przeprowadzenia kontroli.
- `id_kontrolera` – Klucz obcy do kontrolera.
- `id_pojazdu` – Klucz obcy do pojazdu.
- `id_biletu` – Klucz obcy (może być NULL w przypadku braku biletu).
- `wynik_kontroli` – Rezultat (np. "BILET WAŻNY", "MANDAT: 250.00 PLN").

## 5. System Mandatów

### Wezwania_Do_Zaplaty

Rejestr wystawionych mandatów za jazdę bez ważnego biletu.

- `id_wezwania` – Klucz główny.
- `id_kontroli` – Klucz obcy do kontroli, podczas której wystawiono mandat.
- `id_pasazera` – Klucz obcy do ukaranego pasażera.
- `kwota_mandatu` – Wysokość mandatu (uwzględnia ulgę pasażera).
- `termin_platnosci` – Data, do której należy opłacić mandat.
- `id_statusu` – Klucz obcy do statusu wezwania.

### Platnosci_Wezwan

Rejestr wpłat za mandaty.

- `id_platnosci_wezwania` – Klucz główny.
- `id_wezwania` – Klucz obcy do opłacanego wezwania.
- `kwota_wplacona` – Wysokość wpłaty.
- `id_metody` – Klucz obcy do metody płatności.
- `data_wplaty` – Moment zaksięgowania wpłaty.

## 6. Widoki

- **Raport_Przychodow_Total**: Podsumowanie łącznych przychodów ze sprzedaży biletów oraz wpływów z mandatów.
- **Aktywne_Bilety**: Podsumowanie wszystkich obecnie ważnych biletów. Wykorzystuje *CTE*.
- **Przychody_Po_Biletach**: Podsumowanie łączych przychodów ze sprzedaży biletów z podziałem na typy biletów. Wykorzystuje *CTE*.

## 7. Procedury Składowane

- **ZakupBiletu(p_id_pasazera, p_id_definicji, p_id_metody)**: Obsługuje zakup biletu z automatycznym naliczeniem ulgi, wygenerowaniem kodu QR i rejestracją płatności.
- **WykonajKontrole_UczciwyMandat(p_num_kontrolera, p_num_pojazdu, p_kod_skanowany)**: Przeprowadza kontrolę biletu, sprawdza ważność i strefę, wystawia mandat z uwzględnieniem ulgi pasażera.
- **OplacMandat(p_id_wezwania, p_id_metody)**: Rejestruje wpłatę za mandat i aktualizuje jego status.

## 8. Funkcje

- **CzyBiletWazny(p_id_biletu, p_id_pojazdu)**: Sprawdza czy bilet jest ważny w danym pojeździe (weryfikuje czas i strefę).
- **Przewidywany_Czas_Trasy(p_id_trasy)**: Zwraca przewidywany czas, jaki zajmie ukończenie trasy.

## 9. Triggery

- **trg_bilety_przed_insertem**: Auto-generuje kod biletu jeśli nie został podany.
- **trg_pasazerowie_walidacja_email_insert/update**: Waliduje format adresu email przy dodawaniu/edycji pasażera.
- **trg_kontrole_sprawdz_kontrolera**: Blokuje rejestrację kontroli przez nieaktywnego kontrolera.
