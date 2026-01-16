# Dokumentacja Struktury Bazy Danych - System Transportu Publicznego

## 1. Tabele Słownikowe (Słowniki)

Tabele te pełnią rolę centralnych rejestrów dla stałych wartości. Dzięki nim unikamy błędów w pisowni i ułatwiamy rozbudowę systemu (np. dodanie nowej strefy bez zmiany kodu bazy).

- **Slownik_Stref**: Definiuje obszary obowiązywania biletów (np. Strefa I, Strefa I+II).
- **Slownik_Ulg**: Przechowuje rodzaje dostępnych ulg (np. Student 50%, Senior 37%) wraz z ich wartością procentową wykorzystywaną do obliczeń.
- **Slownik_Metod_Platnosci**: Definiuje dostępne formy płatności (np. Karta, BLIK, Gotówka).
- **Slownik_Typow_Linii**: Określa rodzaj transportu (np. Tramwaj, Autobus dzienny, Autobus nocny).

## 2. Infrastruktura i Logika Tras

### Przystanki

Definiuje wszystkie fizyczne punkty zatrzymywania się pojazdów.

- `id_przystanku` – Klucz główny.
- `nazwa_przystanku` – Pełna nazwa przystanku (np. "Centrum").
- `id_strefy` – Klucz obcy przypisujący przystanek do strefy biletowej.

### Trasy

Tabela definiująca konkretną linię komunikacyjną.

- `id_trasy` – Klucz główny.
- `numer_linii` – Krótkie oznaczenie linii (np. "10", "N2").
- `id_typu_linii` – Klucz obcy określający typ (np. autobusowa, tramwajowa).

### Trasy_Przystanki

Tabela łącząca (wiele-do-wielu), definiująca przebieg linii.

- `id_trasy`, `id_przystanku` – Klucze obce tworzące relację.
- `kolejnosc` – Numer porządkowy przystanku na danej trasie.

### Pojazdy

Rejestr fizycznych jednostek taboru.

- `id_pojazdu` – Klucz główny.
- `numer_boczny` – Unikalny identyfikator pojazdu (np. "TR-101").
- `id_trasy` – Klucz obcy wskazujący linię, na której aktualnie kursuje pojazd.

## 3. System Biletowy i Finansowy

### Bilety_Definicje

Wzorzec biletów dostępnych w ofercie.

- `id_definicji` – Klucz główny.
- `nazwa_biletu` – Opis handlowy (np. "Bilet 20-minutowy", "Grupowy Weekendowy").
- `czy_grupowy` – Flaga logiczna (Boolean) określająca charakter biletu.
- `limit_osob` – Maksymalna liczba osób uprawnionych (domyślnie 1).
- `cena_bazowa_brutto` – Cena wyjściowa biletów przed nałożeniem ulgi.

### Bilety_Sprzedane

Rejestr zakupionych i unikalnych biletów przypisanych do pasażerów.

- `id_biletu` – Klucz główny.
- `kod_biletu` – Unikalny identyfikator (np. hash do kodu QR lub numer seryjny).
- `id_pasazera` – Klucz obcy łączący bilet z właścicielem.
- `data_waznosci_od` / `do` – Ramy czasowe (kluczowe dla biletów okresowych).

### Platnosci

Szczegóły finansowe każdej transakcji.

- `id_platnosci` – Klucz główny.
- `kwota_netto` – Wartość przed opodatkowaniem (obliczana).
- `stawka_vat` – Procentowa wartość podatku (np. 8.00).
- `kwota_brutto` – Pełna cena zapłacona przez klienta.
- `id_metody` – Klucz obcy określający sposób zapłaty.

## 4. Ludzie i Kontrole

### Pasazerowie

Rejestr użytkowników systemu.

- `id_pasazera` – Klucz główny.
- `imie`, `nazwisko`, `email` – Dane identyfikacyjne (email musi być unikalny).
- `data_rejestracji` – Moment dołączenia do systemu.

### Kontrolerzy

Pracownicy uprawnieni do weryfikacji biletów.

- `id_kontrolera` – Klucz główny.
- `numer_sluzbowy` – Unikalny identyfikator pracownika.
- `aktywny` – Status zatrudnienia (umożliwia blokadę dostępu).

### Kontrole_Biletow

Rejestr zdarzeń sprawdzania biletów w terenie.

- `id_kontroli` – Klucz główny.
- `id_kontrolera`, `id_pojazdu` – Dane o tym kto i gdzie sprawdzał.
- `id_biletu` – Klucz obcy (może być pusty/NULL w przypadku braku biletu).
- `wynik_kontroli` – Rezultat (np. "Ważny", "Mandat nr 456").
