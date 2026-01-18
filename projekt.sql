SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS `Bilety_Definicje`;
CREATE TABLE `Bilety_Definicje`  (
  `id_definicji` int(11) NOT NULL AUTO_INCREMENT,
  `nazwa_biletu` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `id_strefy` int(11) NULL DEFAULT NULL,
  `cena_bazowa_brutto` decimal(10, 2) NOT NULL,
  `czas_minuty` int(11) NOT NULL DEFAULT 60,
  PRIMARY KEY (`id_definicji`) USING BTREE,
  INDEX `id_strefy`(`id_strefy` ASC) USING BTREE,
  CONSTRAINT `Bilety_Definicje_ibfk_1` FOREIGN KEY (`id_strefy`) REFERENCES `Slownik_Stref` (`id_strefy`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic WITH SYSTEM VERSIONING;

INSERT INTO `Bilety_Definicje` VALUES (1, 'Miejski (Strefa 1)', 1, 4.00, 20);
INSERT INTO `Bilety_Definicje` VALUES (2, 'Aglomeracyjny (Strefa 2)', 2, 6.00, 60);
INSERT INTO `Bilety_Definicje` VALUES (3, 'Nocny (Strefa 1)', 1, 5.00, 30);

DROP TABLE IF EXISTS `Bilety_Sprzedane`;
CREATE TABLE `Bilety_Sprzedane`  (
  `id_biletu` int(11) NOT NULL AUTO_INCREMENT,
  `kod_biletu` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `id_pasazera` int(11) NULL DEFAULT NULL,
  `id_definicji` int(11) NULL DEFAULT NULL,
  `id_ulgi` int(11) NULL DEFAULT NULL,
  `data_zakupu` datetime NULL DEFAULT current_timestamp(),
  `data_waznosci_od` datetime NOT NULL,
  `data_waznosci_do` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id_biletu`, `data_waznosci_od`) USING BTREE,
  UNIQUE INDEX `kod_biletu`(`kod_biletu`, `data_waznosci_od`) USING BTREE,
  INDEX `id_pasazera`(`id_pasazera` ASC) USING BTREE,
  INDEX `id_definicji`(`id_definicji` ASC) USING BTREE,
  INDEX `id_ulgi`(`id_ulgi` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic WITH SYSTEM VERSIONING
PARTITION BY RANGE (YEAR(data_waznosci_od)) (
  PARTITION p2025 VALUES LESS THAN (2026),
  PARTITION p2026 VALUES LESS THAN (2027),
  PARTITION p2027 VALUES LESS THAN (2028),
  PARTITION pmax VALUES LESS THAN MAXVALUE
);

INSERT INTO `Bilety_Sprzedane` VALUES (1, 'QR-JAN-OK', 1, 1, 1, '2026-01-08 01:06:28', '2026-01-01 00:00:00', '2026-12-31 00:00:00');
INSERT INTO `Bilety_Sprzedane` VALUES (2, 'QR-ANNA-STARY', 2, 1, 2, '2026-01-08 01:06:28', '2025-01-01 00:00:00', '2025-01-06 00:00:00');
INSERT INTO `Bilety_Sprzedane` VALUES (3, 'QR-PIOTR-ZLA-STREFA', 3, 1, 3, '2026-01-08 01:06:28', '2026-01-01 00:00:00', '2026-12-31 00:00:00');
INSERT INTO `Bilety_Sprzedane` VALUES (4, 'QR-101201910047968569', 1, 1, 1, '2026-01-16 21:46:12', '2026-01-16 21:46:12', '2026-01-16 22:06:12');
INSERT INTO `Bilety_Sprzedane` VALUES (5, 'QR-101201910047968570', 1, 1, 1, '2026-01-16 21:47:40', '2026-01-16 21:47:40', '2026-01-16 22:07:40');
INSERT INTO `Bilety_Sprzedane` VALUES (6, 'QR-MARIA-AGLO', 4, 2, 1, '2026-01-10 11:00:00', '2026-01-10 11:00:00', '2026-01-10 12:00:00');
INSERT INTO `Bilety_Sprzedane` VALUES (7, 'QR-TOMEK-STUD', 5, 1, 2, '2026-01-12 15:00:00', '2026-01-12 15:00:00', '2026-01-12 15:20:00');
INSERT INTO `Bilety_Sprzedane` VALUES (8, 'QR-KASIA-BLIK', 6, 1, 1, '2026-01-14 10:00:00', '2026-01-14 10:00:00', '2026-01-14 10:20:00');

DROP TABLE IF EXISTS `Kontrole_Biletow`;
CREATE TABLE `Kontrole_Biletow`  (
  `id_kontroli` int(11) NOT NULL AUTO_INCREMENT,
  `data_kontroli` datetime NULL DEFAULT current_timestamp(),
  `id_kontrolera` int(11) NULL DEFAULT NULL,
  `id_pojazdu` int(11) NULL DEFAULT NULL,
  `id_biletu` int(11) NULL DEFAULT NULL,
  `wynik_kontroli` varchar(150) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id_kontroli`) USING BTREE,
  INDEX `id_kontrolera`(`id_kontrolera` ASC) USING BTREE,
  INDEX `id_pojazdu`(`id_pojazdu` ASC) USING BTREE,
  INDEX `id_biletu`(`id_biletu` ASC) USING BTREE,
  CONSTRAINT `Kontrole_Biletow_ibfk_1` FOREIGN KEY (`id_kontrolera`) REFERENCES `Kontrolerzy` (`id_kontrolera`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `Kontrole_Biletow_ibfk_2` FOREIGN KEY (`id_pojazdu`) REFERENCES `Pojazdy` (`id_pojazdu`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `Kontrole_Biletow_ibfk_3` FOREIGN KEY (`id_biletu`) REFERENCES `Bilety_Sprzedane` (`id_biletu`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic WITH SYSTEM VERSIONING;

INSERT INTO `Kontrole_Biletow` VALUES (1, '2026-01-08 01:14:10', 1, 1, 2, 'MANDAT: 125.00 PLN (Zastosowano ulgę pasażera)');
INSERT INTO `Kontrole_Biletow` VALUES (2, '2026-01-08 01:14:10', 1, 2, 3, 'MANDAT: 157.50 PLN (Zastosowano ulgę pasażera)');
INSERT INTO `Kontrole_Biletow` VALUES (3, '2026-01-10 11:30:00', 2, 4, 6, 'BILET WAŻNY - Dziękujemy');
INSERT INTO `Kontrole_Biletow` VALUES (4, '2026-01-14 10:25:00', 3, 5, 8, 'MANDAT: 250.00 PLN (Zastosowano ulgę pasażera)');

DROP TABLE IF EXISTS `Kontrolerzy`;
CREATE TABLE `Kontrolerzy`  (
  `id_kontrolera` int(11) NOT NULL AUTO_INCREMENT,
  `numer_sluzbowy` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `imie` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `nazwisko` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `aktywny` tinyint(1) NULL DEFAULT 1,
  PRIMARY KEY (`id_kontrolera`) USING BTREE,
  UNIQUE INDEX `numer_sluzbowy`(`numer_sluzbowy` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic WITH SYSTEM VERSIONING;

INSERT INTO `Kontrolerzy` VALUES (1, 'K-100', 'Robert', 'Srogi', 1);
INSERT INTO `Kontrolerzy` VALUES (2, 'K-101', 'Ewa', 'Rzetelna', 1);
INSERT INTO `Kontrolerzy` VALUES (3, 'K-102', 'Marek', 'Sprawny', 1);

DROP TABLE IF EXISTS `Pasazerowie`;
CREATE TABLE `Pasazerowie`  (
  `id_pasazera` int(11) NOT NULL AUTO_INCREMENT,
  `imie` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `nazwisko` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `email` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `id_ulgi` int(11) NULL DEFAULT NULL,
  `data_rejestracji` datetime NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_pasazera`) USING BTREE,
  UNIQUE INDEX `email`(`email` ASC) USING BTREE,
  INDEX `id_ulgi`(`id_ulgi` ASC) USING BTREE,
  CONSTRAINT `Pasazerowie_ibfk_1` FOREIGN KEY (`id_ulgi`) REFERENCES `Slownik_Ulg` (`id_ulgi`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic WITH SYSTEM VERSIONING;

INSERT INTO `Pasazerowie` VALUES (1, 'Jan', 'Kowalski', 'jan.kowalski@mail.com', 1, '2026-01-08 01:06:28');
INSERT INTO `Pasazerowie` VALUES (2, 'Anna', 'Nowak', 'anna.stud@uczelnia.pl', 2, '2026-01-08 01:06:28');
INSERT INTO `Pasazerowie` VALUES (3, 'Piotr', 'Zieliński', 'piotr.z@emerytura.pl', 3, '2026-01-08 01:06:28');
INSERT INTO `Pasazerowie` VALUES (4, 'Maria', 'Wiśniewska', 'maria.w@firma.pl', 1, '2026-01-10 10:30:00');
INSERT INTO `Pasazerowie` VALUES (5, 'Tomasz', 'Lewandowski', 'tomek.lew@student.edu.pl', 2, '2026-01-12 14:15:00');
INSERT INTO `Pasazerowie` VALUES (6, 'Katarzyna', 'Wójcik', 'k.wojcik@poczta.pl', 1, '2026-01-14 09:45:00');

DROP TABLE IF EXISTS `Platnosci`;
CREATE TABLE `Platnosci`  (
  `id_platnosci` int(11) NOT NULL AUTO_INCREMENT,
  `id_biletu` int(11) NULL DEFAULT NULL,
  `kwota_netto` decimal(10, 2) NOT NULL,
  `stawka_vat` decimal(5, 2) NULL DEFAULT 8.00,
  `kwota_brutto` decimal(10, 2) NOT NULL,
  `id_metody` int(11) NULL DEFAULT NULL,
  `data_platnosci` datetime NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_platnosci`) USING BTREE,
  INDEX `id_biletu`(`id_biletu` ASC) USING BTREE,
  INDEX `id_metody`(`id_metody` ASC) USING BTREE,
  CONSTRAINT `Platnosci_ibfk_1` FOREIGN KEY (`id_biletu`) REFERENCES `Bilety_Sprzedane` (`id_biletu`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `Platnosci_ibfk_2` FOREIGN KEY (`id_metody`) REFERENCES `Slownik_Metod_Platnosci` (`id_metody`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic WITH SYSTEM VERSIONING;

INSERT INTO `Platnosci` VALUES (1, 1, 3.70, 8.00, 4.00, 2, '2026-01-08 01:06:28');
INSERT INTO `Platnosci` VALUES (2, 2, 1.85, 8.00, 2.00, 1, '2026-01-08 01:06:28');
INSERT INTO `Platnosci` VALUES (3, 3, 2.33, 8.00, 2.52, 1, '2026-01-08 01:06:28');
INSERT INTO `Platnosci` VALUES (4, 4, 3.70, 8.00, 4.00, 1, '2026-01-16 21:46:12');
INSERT INTO `Platnosci` VALUES (5, 5, 3.70, 8.00, 4.00, 1, '2026-01-16 21:47:40');
INSERT INTO `Platnosci` VALUES (6, 6, 5.56, 8.00, 6.00, 2, '2026-01-10 11:00:00');
INSERT INTO `Platnosci` VALUES (7, 7, 1.85, 8.00, 2.00, 1, '2026-01-12 15:00:00');
INSERT INTO `Platnosci` VALUES (8, 8, 3.70, 8.00, 4.00, 3, '2026-01-14 10:00:00');

DROP TABLE IF EXISTS `Platnosci_Wezwan`;
CREATE TABLE `Platnosci_Wezwan`  (
  `id_platnosci_wezwania` int(11) NOT NULL AUTO_INCREMENT,
  `id_wezwania` int(11) NOT NULL,
  `kwota_wplacona` decimal(10, 2) NOT NULL,
  `id_metody` int(11) NOT NULL,
  `data_wplaty` datetime NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_platnosci_wezwania`) USING BTREE,
  INDEX `id_wezwania`(`id_wezwania` ASC) USING BTREE,
  INDEX `id_metody`(`id_metody` ASC) USING BTREE,
  CONSTRAINT `Platnosci_Wezwan_ibfk_1` FOREIGN KEY (`id_wezwania`) REFERENCES `Wezwania_Do_Zaplaty` (`id_wezwania`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `Platnosci_Wezwan_ibfk_2` FOREIGN KEY (`id_metody`) REFERENCES `Slownik_Metod_Platnosci` (`id_metody`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic WITH SYSTEM VERSIONING;

INSERT INTO `Platnosci_Wezwan` VALUES (1, 1, 125.00, 2, '2026-01-08 01:15:16');

DROP TABLE IF EXISTS `Pojazdy`;
CREATE TABLE `Pojazdy`  (
  `id_pojazdu` int(11) NOT NULL AUTO_INCREMENT,
  `numer_boczny` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `id_trasy` int(11) NULL DEFAULT NULL,
  `id_aktualnego_przystanku` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id_pojazdu`) USING BTREE,
  UNIQUE INDEX `numer_boczny`(`numer_boczny` ASC) USING BTREE,
  INDEX `id_trasy`(`id_trasy` ASC) USING BTREE,
  INDEX `id_aktualnego_przystanku`(`id_aktualnego_przystanku` ASC) USING BTREE,
  CONSTRAINT `Pojazdy_ibfk_1` FOREIGN KEY (`id_trasy`) REFERENCES `Trasy` (`id_trasy`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `Pojazdy_ibfk_2` FOREIGN KEY (`id_aktualnego_przystanku`) REFERENCES `Przystanki` (`id_przystanku`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic WITH SYSTEM VERSIONING;

INSERT INTO `Pojazdy` VALUES (1, 'TRAM-01', 1, 1);
INSERT INTO `Pojazdy` VALUES (2, 'BUS-02', 2, 2);
INSERT INTO `Pojazdy` VALUES (3, 'TRAM-05', 3, 6);
INSERT INTO `Pojazdy` VALUES (4, 'BUS-15', 4, 5);
INSERT INTO `Pojazdy` VALUES (5, 'TRAM-02', 1, 3);

DROP TABLE IF EXISTS `Przystanki`;
CREATE TABLE `Przystanki`  (
  `id_przystanku` int(11) NOT NULL AUTO_INCREMENT,
  `nazwa_przystanku` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `id_strefy` int(11) NULL DEFAULT NULL,
  `lokalizacja` point NULL,
  PRIMARY KEY (`id_przystanku`) USING BTREE,
  INDEX `id_strefy`(`id_strefy` ASC) USING BTREE,
  CONSTRAINT `Przystanki_ibfk_1` FOREIGN KEY (`id_strefy`) REFERENCES `Slownik_Stref` (`id_strefy`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic WITH SYSTEM VERSIONING;

INSERT INTO `Przystanki` VALUES (1, 'Centrum Handlowe', 1, ST_GeomFromText('POINT(19.9 50)'));
INSERT INTO `Przystanki` VALUES (2, 'Pętla Podmiejska', 2, ST_GeomFromText('POINT(19.8 50.1)'));
INSERT INTO `Przystanki` VALUES (3, 'Dworzec Główny', 1, ST_GeomFromText('POINT(19.95 50.05)'));
INSERT INTO `Przystanki` VALUES (4, 'Uniwersytet', 1, ST_GeomFromText('POINT(19.92 50.02)'));
INSERT INTO `Przystanki` VALUES (5, 'Stadion', 2, ST_GeomFromText('POINT(19.85 50.08)'));
INSERT INTO `Przystanki` VALUES (6, 'Rynek', 1, ST_GeomFromText('POINT(19.93 50.06)'));

DROP TABLE IF EXISTS `Slownik_Metod_Platnosci`;
CREATE TABLE `Slownik_Metod_Platnosci`  (
  `id_metody` int(11) NOT NULL AUTO_INCREMENT,
  `nazwa_metody` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  PRIMARY KEY (`id_metody`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic WITH SYSTEM VERSIONING;

INSERT INTO `Slownik_Metod_Platnosci` VALUES (1, 'Aplikacja');
INSERT INTO `Slownik_Metod_Platnosci` VALUES (2, 'Karta płatnicza');
INSERT INTO `Slownik_Metod_Platnosci` VALUES (3, 'BLIK');

DROP TABLE IF EXISTS `Slownik_Statusow_Wezwan`;
CREATE TABLE `Slownik_Statusow_Wezwan`  (
  `id_statusu` int(11) NOT NULL AUTO_INCREMENT,
  `nazwa_statusu` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  PRIMARY KEY (`id_statusu`) USING BTREE,
  UNIQUE INDEX `nazwa_statusu`(`nazwa_statusu` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic WITH SYSTEM VERSIONING;

INSERT INTO `Slownik_Statusow_Wezwan` VALUES (3, 'Anulowane');
INSERT INTO `Slownik_Statusow_Wezwan` VALUES (1, 'Oczekujące');
INSERT INTO `Slownik_Statusow_Wezwan` VALUES (2, 'Opłacone');

DROP TABLE IF EXISTS `Slownik_Stref`;
CREATE TABLE `Slownik_Stref`  (
  `id_strefy` int(11) NOT NULL AUTO_INCREMENT,
  `nazwa_strefy` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  PRIMARY KEY (`id_strefy`) USING BTREE,
  UNIQUE INDEX `nazwa_strefy`(`nazwa_strefy` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic WITH SYSTEM VERSIONING;

INSERT INTO `Slownik_Stref` VALUES (1, 'Strefa I - Miasto');
INSERT INTO `Slownik_Stref` VALUES (2, 'Strefa II - Aglomeracja');

DROP TABLE IF EXISTS `Slownik_Typow_Linii`;
CREATE TABLE `Slownik_Typow_Linii`  (
  `id_typu_linii` int(11) NOT NULL AUTO_INCREMENT,
  `nazwa_typu` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  PRIMARY KEY (`id_typu_linii`) USING BTREE,
  UNIQUE INDEX `nazwa_typu`(`nazwa_typu` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic WITH SYSTEM VERSIONING;

INSERT INTO `Slownik_Typow_Linii` VALUES (2, 'Autobus');
INSERT INTO `Slownik_Typow_Linii` VALUES (1, 'Tramwaj');
INSERT INTO `Slownik_Typow_Linii` VALUES (3, 'Metro');

DROP TABLE IF EXISTS `Slownik_Ulg`;
CREATE TABLE `Slownik_Ulg`  (
  `id_ulgi` int(11) NOT NULL AUTO_INCREMENT,
  `nazwa_ulgi` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `procent_znizki` decimal(5, 2) NULL DEFAULT 0.00,
  PRIMARY KEY (`id_ulgi`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic WITH SYSTEM VERSIONING;

INSERT INTO `Slownik_Ulg` VALUES (1, 'Normalny', 0.00);
INSERT INTO `Slownik_Ulg` VALUES (2, 'Student (Legitymacja)', 50.00);
INSERT INTO `Slownik_Ulg` VALUES (3, 'Senior (65+)', 37.00);
INSERT INTO `Slownik_Ulg` VALUES (4, 'Dziecko do 4 lat', 100.00);

DROP TABLE IF EXISTS `Trasy`;
CREATE TABLE `Trasy`  (
  `id_trasy` int(11) NOT NULL AUTO_INCREMENT,
  `numer_linii` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `id_typu_linii` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id_trasy`) USING BTREE,
  UNIQUE INDEX `numer_linii`(`numer_linii` ASC) USING BTREE,
  INDEX `id_typu_linii`(`id_typu_linii` ASC) USING BTREE,
  CONSTRAINT `Trasy_ibfk_1` FOREIGN KEY (`id_typu_linii`) REFERENCES `Slownik_Typow_Linii` (`id_typu_linii`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic WITH SYSTEM VERSIONING;

INSERT INTO `Trasy` VALUES (1, '10', 1);
INSERT INTO `Trasy` VALUES (2, '200', 2);
INSERT INTO `Trasy` VALUES (3, '5', 1);
INSERT INTO `Trasy` VALUES (4, '150', 2);

DROP TABLE IF EXISTS `Trasy_Przystanki`;
CREATE TABLE `Trasy_Przystanki`  (
  `id_trasy` int(11) NOT NULL,
  `id_przystanku` int(11) NOT NULL,
  `kolejnosc` int(11) NOT NULL,
  PRIMARY KEY (`id_trasy`, `id_przystanku`) USING BTREE,
  INDEX `id_przystanku`(`id_przystanku` ASC) USING BTREE,
  CONSTRAINT `Trasy_Przystanki_ibfk_1` FOREIGN KEY (`id_trasy`) REFERENCES `Trasy` (`id_trasy`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `Trasy_Przystanki_ibfk_2` FOREIGN KEY (`id_przystanku`) REFERENCES `Przystanki` (`id_przystanku`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic WITH SYSTEM VERSIONING;

INSERT INTO `Trasy_Przystanki` VALUES (1, 1, 1);
INSERT INTO `Trasy_Przystanki` VALUES (1, 3, 2);
INSERT INTO `Trasy_Przystanki` VALUES (1, 4, 3);
INSERT INTO `Trasy_Przystanki` VALUES (2, 2, 1);
INSERT INTO `Trasy_Przystanki` VALUES (2, 5, 2);
INSERT INTO `Trasy_Przystanki` VALUES (3, 6, 1);
INSERT INTO `Trasy_Przystanki` VALUES (3, 3, 2);
INSERT INTO `Trasy_Przystanki` VALUES (4, 5, 1);
INSERT INTO `Trasy_Przystanki` VALUES (4, 2, 2);

DROP TABLE IF EXISTS `Wezwania_Do_Zaplaty`;
CREATE TABLE `Wezwania_Do_Zaplaty`  (
  `id_wezwania` int(11) NOT NULL AUTO_INCREMENT,
  `id_kontroli` int(11) NOT NULL,
  `id_pasazera` int(11) NOT NULL,
  `kwota_mandatu` decimal(10, 2) NOT NULL,
  `termin_platnosci` date NOT NULL,
  `id_statusu` int(11) NOT NULL,
  PRIMARY KEY (`id_wezwania`) USING BTREE,
  INDEX `id_kontroli`(`id_kontroli` ASC) USING BTREE,
  INDEX `id_pasazera`(`id_pasazera` ASC) USING BTREE,
  INDEX `id_statusu`(`id_statusu` ASC) USING BTREE,
  CONSTRAINT `Wezwania_Do_Zaplaty_ibfk_1` FOREIGN KEY (`id_kontroli`) REFERENCES `Kontrole_Biletow` (`id_kontroli`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `Wezwania_Do_Zaplaty_ibfk_2` FOREIGN KEY (`id_pasazera`) REFERENCES `Pasazerowie` (`id_pasazera`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `Wezwania_Do_Zaplaty_ibfk_3` FOREIGN KEY (`id_statusu`) REFERENCES `Slownik_Statusow_Wezwan` (`id_statusu`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic WITH SYSTEM VERSIONING;

INSERT INTO `Wezwania_Do_Zaplaty` VALUES (1, 1, 2, 125.00, '2026-01-22', 2);
INSERT INTO `Wezwania_Do_Zaplaty` VALUES (2, 2, 3, 157.50, '2026-01-22', 1);
INSERT INTO `Wezwania_Do_Zaplaty` VALUES (3, 4, 6, 250.00, '2026-01-28', 1);

DROP VIEW IF EXISTS `Raport_Przychodow_Total`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `Raport_Przychodow_Total` AS select 'Sprzedaż Biletów' AS `Typ`,sum(`Platnosci`.`kwota_brutto`) AS `Suma` from `Platnosci` union all select 'Wpływy z Mandatów' AS `Typ`,sum(`Platnosci_Wezwan`.`kwota_wplacona`) AS `Suma` from `Platnosci_Wezwan`;

DROP FUNCTION IF EXISTS `CzyBiletWazny`;
delimiter ;;
CREATE FUNCTION `CzyBiletWazny`(p_id_biletu INT, p_id_pojazdu INT)
 RETURNS tinyint(1)
  DETERMINISTIC
BEGIN
    DECLARE v_strefa_pojazdu INT;
    DECLARE v_czy_ok TINYINT(1) DEFAULT 0;
    SELECT pr.id_strefy INTO v_strefa_pojazdu
    FROM Pojazdy poj 
    JOIN Przystanki pr ON poj.id_aktualnego_przystanku = pr.id_przystanku
    WHERE poj.id_pojazdu = p_id_pojazdu;
    SELECT COUNT(*) INTO v_czy_ok
    FROM Bilety_Sprzedane b
    JOIN Bilety_Definicje d ON b.id_definicji = d.id_definicji
    JOIN Platnosci p ON b.id_biletu = p.id_biletu
    WHERE b.id_biletu = p_id_biletu
      AND NOW() BETWEEN b.data_waznosci_od AND b.data_waznosci_do
      AND (d.id_strefy = v_strefa_pojazdu OR d.id_strefy IS NULL OR v_strefa_pojazdu IS NULL);

    RETURN v_czy_ok;
END
;;
delimiter ;

DROP PROCEDURE IF EXISTS `OplacMandat`;
delimiter ;;
CREATE PROCEDURE `OplacMandat`(IN p_id_wezwania INT,
    IN p_id_metody INT)
BEGIN
    DECLARE v_kwota_do_zaplaty DECIMAL(10, 2);
    DECLARE v_id_statusu_oplacone INT;
    DECLARE v_aktualny_status INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN 
        ROLLBACK; 
        SELECT 'BŁĄD: Nie udało się zaksięgować wpłaty.' AS Status; 
    END;
    SELECT id_statusu INTO v_id_statusu_oplacone 
    FROM Slownik_Statusow_Wezwan 
    WHERE nazwa_statusu = 'Opłacone';
    SELECT kwota_mandatu, id_statusu INTO v_kwota_do_zaplaty, v_aktualny_status
    FROM Wezwania_Do_Zaplaty
    WHERE id_wezwania = p_id_wezwania;
    START TRANSACTION;
        IF v_aktualny_status = v_id_statusu_oplacone THEN
            SELECT 'Mandat został już opłacony wcześniej!' AS Status;
            ROLLBACK;
        ELSE
            UPDATE Wezwania_Do_Zaplaty 
            SET id_statusu = v_id_statusu_oplacone 
            WHERE id_wezwania = p_id_wezwania;
            INSERT INTO Platnosci_Wezwan (id_wezwania, kwota_wplacona, id_metody)
            VALUES (p_id_wezwania, v_kwota_do_zaplaty, p_id_metody);
            COMMIT;
            SELECT CONCAT('Sukces! Zaksięgowano wpłatę w wysokości: ', v_kwota_do_zaplaty, ' PLN') AS Status;
        END IF;
END
;;
delimiter ;

DROP PROCEDURE IF EXISTS `WykonajKontrole_UczciwyMandat`;
delimiter ;;
CREATE PROCEDURE `WykonajKontrole_UczciwyMandat`(IN p_num_kontrolera VARCHAR(20),
    IN p_num_pojazdu VARCHAR(20),
    IN p_kod_skanowany VARCHAR(64))
BEGIN
    DECLARE v_id_kon, v_id_poj, v_id_pas, v_id_bil, v_id_knt INT DEFAULT NULL;
    DECLARE v_wazny TINYINT(1) DEFAULT 0;
    DECLARE v_procent_znizki DECIMAL(5,2) DEFAULT 0;
    DECLARE v_kwota_bazowa_mandatu DECIMAL(10,2) DEFAULT 250.00;
    DECLARE v_kwota_koncowa_mandatu DECIMAL(10,2);
    DECLARE v_komunikat VARCHAR(150);
    DECLARE v_id_statusu_oczekujace INT DEFAULT NULL;
    DECLARE v_error_msg TEXT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN 
        GET DIAGNOSTICS CONDITION 1 v_error_msg = MESSAGE_TEXT;
        ROLLBACK; 
        SELECT CONCAT('BŁĄD SYSTEMOWY: ', v_error_msg) AS Status; 
    END;
    SELECT id_statusu INTO v_id_statusu_oczekujace 
    FROM Slownik_Statusow_Wezwan 
    WHERE nazwa_statusu = 'Oczekujące' LIMIT 1;
    SELECT id_kontrolera INTO v_id_kon FROM Kontrolerzy WHERE numer_sluzbowy = p_num_kontrolera LIMIT 1;
    SELECT id_pojazdu INTO v_id_poj FROM Pojazdy WHERE numer_boczny = p_num_pojazdu LIMIT 1;
    IF v_id_kon IS NULL THEN
        SELECT CONCAT('BŁĄD: Nie znaleziono kontrolera o numerze: ', p_num_kontrolera) AS Status;
    ELSEIF v_id_poj IS NULL THEN
        SELECT CONCAT('BŁĄD: Nie znaleziono pojazdu o numerze: ', p_num_pojazdu) AS Status;
    ELSEIF v_id_statusu_oczekujace IS NULL THEN
        SELECT 'BŁĄD: W słowniku brak statusu mandatu Oczekujące!' AS Status;
    ELSE
        SELECT id_biletu, id_pasazera INTO v_id_bil, v_id_pas 
        FROM Bilety_Sprzedane WHERE kod_biletu = p_kod_skanowany LIMIT 1;
        SET v_wazny = IF(v_id_bil IS NOT NULL, CzyBiletWazny(v_id_bil, v_id_poj), 0);
        START TRANSACTION;
            IF v_wazny = 1 THEN
                SET v_komunikat = 'BILET WAŻNY - Dziękujemy';
                INSERT INTO Kontrole_Biletow (id_kontrolera, id_pojazdu, id_biletu, wynik_kontroli)
                VALUES (v_id_kon, v_id_poj, v_id_bil, v_komunikat);
            ELSEIF v_id_pas IS NOT NULL THEN
                SELECT COALESCE(u.procent_znizki, 0) INTO v_procent_znizki
                FROM Pasazerowie p
                LEFT JOIN Slownik_Ulg u ON p.id_ulgi = u.id_ulgi
                WHERE p.id_pasazera = v_id_pas;
                SET v_kwota_koncowa_mandatu = v_kwota_bazowa_mandatu * (1 - (v_procent_znizki / 100));
                SET v_komunikat = CONCAT('MANDAT: ', v_kwota_koncowa_mandatu, ' PLN (Zastosowano ulgę pasażera)');
                INSERT INTO Kontrole_Biletow (id_kontrolera, id_pojazdu, id_biletu, wynik_kontroli)
                VALUES (v_id_kon, v_id_poj, v_id_bil, v_komunikat);
                SET v_id_knt = LAST_INSERT_ID();
                INSERT INTO Wezwania_Do_Zaplaty (id_kontroli, id_pasazera, kwota_mandatu, termin_platnosci, id_statusu)
                VALUES (v_id_knt, v_id_pas, v_kwota_koncowa_mandatu, DATE_ADD(CURDATE(), INTERVAL 14 DAY), v_id_statusu_oczekujace);
            ELSE
                SET v_komunikat = 'BŁĄD: Nieznany kod biletu - brak danych pasażera';
            END IF;
        COMMIT;
        SELECT v_komunikat AS Wynik;
    END IF;
END
;;
delimiter ;

DROP TRIGGER IF EXISTS `trg_bilety_przed_insertem`;
delimiter ;;
CREATE TRIGGER `trg_bilety_przed_insertem`
BEFORE INSERT ON `Bilety_Sprzedane`
FOR EACH ROW
BEGIN
    IF NEW.kod_biletu IS NULL OR NEW.kod_biletu = '' THEN
        SET NEW.kod_biletu = CONCAT('BLT-', DATE_FORMAT(NOW(), '%Y%m%d'), '-', LPAD(FLOOR(RAND() * 999999), 6, '0'));
    END IF;
END
;;
delimiter ;

DROP TRIGGER IF EXISTS `trg_pasazerowie_walidacja_email_insert`;
delimiter ;;
CREATE TRIGGER `trg_pasazerowie_walidacja_email_insert`
BEFORE INSERT ON `Pasazerowie`
FOR EACH ROW
BEGIN
    IF NEW.email IS NOT NULL AND NEW.email NOT LIKE '%_@_%._%' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Nieprawidłowy format adresu email';
    END IF;
END
;;
delimiter ;

DROP TRIGGER IF EXISTS `trg_pasazerowie_walidacja_email_update`;
delimiter ;;
CREATE TRIGGER `trg_pasazerowie_walidacja_email_update`
BEFORE UPDATE ON `Pasazerowie`
FOR EACH ROW
BEGIN
    IF NEW.email IS NOT NULL AND NEW.email NOT LIKE '%_@_%._%' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Nieprawidłowy format adresu email';
    END IF;
END
;;
delimiter ;

DROP TRIGGER IF EXISTS `trg_kontrole_sprawdz_kontrolera`;
delimiter ;;
CREATE TRIGGER `trg_kontrole_sprawdz_kontrolera`
BEFORE INSERT ON `Kontrole_Biletow`
FOR EACH ROW
BEGIN
    DECLARE v_aktywny TINYINT(1);
    SELECT aktywny INTO v_aktywny FROM Kontrolerzy WHERE id_kontrolera = NEW.id_kontrolera;
    IF v_aktywny = 0 OR v_aktywny IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Kontroler nieaktywny lub nie istnieje';
    END IF;
END
;;
delimiter ;

DROP PROCEDURE IF EXISTS `ZakupBiletu`;
delimiter ;;
CREATE PROCEDURE `ZakupBiletu`(IN p_id_pasazera INT,
    IN p_id_definicji INT,
    IN p_id_metody INT)
BEGIN
    DECLARE v_cena_bazowa DECIMAL(10,2);
    DECLARE v_procent_ulgi DECIMAL(5,2);
    DECLARE v_czas_minuty INT;
    DECLARE v_cena_koncowa_brutto DECIMAL(10,2);
    DECLARE v_id_nowego_biletu INT;
    DECLARE v_id_ulgi_pasazera INT;
    DECLARE v_kod_biletu VARCHAR(64);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN 
        ROLLBACK; 
        SELECT 'BŁĄD: Zakup przerwany.' AS Status; 
    END;

    SELECT cena_bazowa_brutto, czas_minuty 
    INTO v_cena_bazowa, v_czas_minuty 
    FROM Bilety_Definicje 
    WHERE id_definicji = p_id_definicji;
    
    SELECT p.id_ulgi, u.procent_znizki 
    INTO v_id_ulgi_pasazera, v_procent_ulgi 
    FROM Pasazerowie p 
    LEFT JOIN Slownik_Ulg u ON p.id_ulgi = u.id_ulgi 
    WHERE p.id_pasazera = p_id_pasazera;

    SET v_cena_koncowa_brutto = v_cena_bazowa * (1 - (COALESCE(v_procent_ulgi, 0) / 100));
    SET v_kod_biletu = CONCAT('QR-', UUID_SHORT());

    START TRANSACTION;

        INSERT INTO Bilety_Sprzedane (
            kod_biletu, id_pasazera, id_definicji, id_ulgi, 
            data_zakupu, data_waznosci_od, data_waznosci_do
        ) VALUES (
            v_kod_biletu, p_id_pasazera, p_id_definicji, v_id_ulgi_pasazera,
            NOW(), 
            NOW(), 
            DATE_ADD(NOW(), INTERVAL v_czas_minuty MINUTE)
        );

        SET v_id_nowego_biletu = LAST_INSERT_ID();

        INSERT INTO Platnosci (id_biletu, kwota_netto, stawka_vat, kwota_brutto, id_metody)
        VALUES (
            v_id_nowego_biletu, 
            v_cena_koncowa_brutto / 1.08, 
            8.00, 
            v_cena_koncowa_brutto, 
            p_id_metody
        );

    COMMIT;

    SELECT 'SUKCES' AS Status, v_kod_biletu AS Kod, v_czas_minuty AS Waznosc_Minuty;

END
;;
delimiter ;

DROP PROCEDURE IF EXISTS `WykonajKontrole_All`;
delimiter ;;
CREATE PROCEDURE `WykonajKontrole_All`()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE v_id_biletu INT;
    DECLARE v_kod_biletu VARCHAR(64);
    DECLARE v_kontroler VARCHAR(20);
    DECLARE v_pojazd VARCHAR(20);
    DECLARE v_idx_ctrl INT DEFAULT 0;
    DECLARE v_idx_poj INT DEFAULT 0;
    DECLARE v_count_ctrl INT;
    DECLARE v_count_poj INT;
    DECLARE v_count_bilety INT;

    SELECT COUNT(*) INTO v_count_ctrl FROM Kontrolerzy;
    SELECT COUNT(*) INTO v_count_poj FROM Pojazdy;
    SELECT COUNT(*) INTO v_count_bilety 
    FROM Bilety_Sprzedane b
    WHERE NOT EXISTS (SELECT 1 FROM Kontrole_Biletow kb WHERE kb.id_biletu = b.id_biletu);

    SET v_idx_ctrl = 0;
    SET v_idx_poj = 0;
    SET done = 0;

    WYKONAJ_PETLE: WHILE done = 0 DO
        IF v_count_bilety = 0 THEN
            LEAVE WYKONAJ_PETLE;
        END IF;

        SELECT id_biletu, kod_biletu INTO v_id_biletu, v_kod_biletu
        FROM Bilety_Sprzedane b
        WHERE NOT EXISTS (SELECT 1 FROM Kontrole_Biletow kb WHERE kb.id_biletu = b.id_biletu)
        ORDER BY data_zakupu
        LIMIT 1;

        SET v_idx_ctrl = (v_idx_ctrl MOD v_count_ctrl);
        SELECT numer_sluzbowy INTO v_kontroler
        FROM Kontrolerzy
        ORDER BY id_kontrolera
        LIMIT v_idx_ctrl,1;
        SET v_idx_ctrl = v_idx_ctrl + 1;

        SET v_idx_poj = (v_idx_poj MOD v_count_poj);
        SELECT numer_boczny INTO v_pojazd
        FROM Pojazdy
        ORDER BY id_pojazdu
        LIMIT v_idx_poj,1;
        SET v_idx_poj = v_idx_poj + 1;

        CALL WykonajKontrole_UczciwyMandat(v_kontroler, v_pojazd, v_kod_biletu);
        SET v_count_bilety = v_count_bilety - 1;
    END WHILE WYKONAJ_PETLE;
END
;;
delimiter ;

-- trzeba uprawnień SUPER, bez tego eventy nie działają
-- SET GLOBAL event_scheduler = ON; 
-- DROP EVENT IF EXISTS `Kontrola`;
-- CREATE EVENT `Kontrola` ON SCHEDULE EVERY 3 HOUR DO CALL WykonajKontrole_All();

SET FOREIGN_KEY_CHECKS = 1;