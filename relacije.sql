-- kreiramo bazu podataka ako ne postoji baza sa istim imenom
CREATE DATABASE IF NOT EXISTS`Dukat_dd` DEFAULT CHARACTER SET = `utf8` DEFAULT COLLATE = `utf8_bin`;

-- naredba da se koristi kreirana baza
USE `Dukat_dd`;

-- brisemo postojece relacije u bazi (u slucaju da je baza vec postojala)
DROP TABLE IF EXISTS `racuni_stavke`;
DROP TABLE IF EXISTS `racuni`;
DROP TABLE IF EXISTS `narudzbe_stavke`;
DROP TABLE IF EXISTS `narudzbe`;
DROP TABLE IF EXISTS `automobili_prijedeni_put`;
DROP TABLE IF EXISTS `automobili`;
DROP TABLE IF EXISTS `prodavaonice`;
DROP TABLE IF EXISTS `trgovacki_putnici`;
DROP TABLE IF EXISTS `cijene_proizvoda`;
DROP TABLE IF EXISTS `proizvodi`;
DROP TABLE IF EXISTS `kategorije_proizvoda`;

-- Kreiranje novih tablica sa indeksima
-- Koristimo InnoDB engine kako bi imali podrsku za strane kljuceve i ACID (sustav za transakcije)

CREATE TABLE `kategorije_proizvoda` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `naziv` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `proizvodi` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `naziv` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `jedinica` varchar(10) COLLATE utf8_bin DEFAULT NULL,
  `mjerna_jedinica` varchar(10) COLLATE utf8_bin DEFAULT NULL,
  `kategorija_proizvoda_id` int unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `kategorije_proizvodi_fk` (`kategorija_proizvoda_id`),
  CONSTRAINT `kategorije_proizvodi_fk` FOREIGN KEY (`kategorija_proizvoda_id`) REFERENCES `kategorije_proizvoda` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `cijene_proizvoda` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `datum_od` date DEFAULT NULL,
  `cijena` decimal(5,2) DEFAULT NULL,
  `pdv` decimal(4,2) DEFAULT NULL,
  `proizvod_id` int unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cijena_proizvod_fk` (`proizvod_id`),
  KEY `cijena_proizvoda_datum_index` (`datum_od`),
  CONSTRAINT `cijena_proizvod_fk` FOREIGN KEY (`proizvod_id`) REFERENCES `cijene_proizvoda` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `trgovacki_putnici` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `ime` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  `prezime` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  `datum_rodenja` date DEFAULT NULL,
  `oib` bigint DEFAULT NULL,
  `adresa` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  `postanski_broj` int DEFAULT NULL,
  `grad` varchar(30) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `prodavaonice` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `naziv` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  `adresa` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `postanski_broj` int DEFAULT NULL,
  `grad` varchar(30) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `automobili` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `marka` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  `model` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  `godiste` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `automobili_prijedeni_put` (
  `trgovacki_putnik_id` int unsigned DEFAULT NULL,
  `automobil_id` int unsigned DEFAULT NULL,
  `pocetak_kilometri` int unsigned DEFAULT NULL,
  `kraj_kilometri` int unsigned DEFAULT NULL,
  `datum` date DEFAULT NULL,
  KEY `automobil_kilometri_fk` (`automobil_id`),
  KEY `putnik_kilometri_fk` (`trgovacki_putnik_id`),
  CONSTRAINT `automobil_kilometri_fk` FOREIGN KEY (`automobil_id`) REFERENCES `automobili` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `putnik_kilometri_fk` FOREIGN KEY (`trgovacki_putnik_id`) REFERENCES `trgovacki_putnici` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `narudzbe` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `datum` date DEFAULT NULL,
  `prodavaonica_id` int unsigned DEFAULT NULL,
  `trgovacki_putnik_id` int unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `narudzba_putnik_fk` (`trgovacki_putnik_id`),
  KEY `narudzba_prodavaonica_fk` (`prodavaonica_id`),
  CONSTRAINT `narudzba_prodavaonica_fk` FOREIGN KEY (`prodavaonica_id`) REFERENCES `prodavaonice` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `narudzba_putnik_fk` FOREIGN KEY (`trgovacki_putnik_id`) REFERENCES `trgovacki_putnici` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `narudzbe_stavke` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `narudzba_id` int unsigned DEFAULT NULL,
  `proizvod_id` int unsigned DEFAULT NULL,
  `kolicina` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `narudzba_stavka_fk` (`narudzba_id`),
  CONSTRAINT `narudzba_proizvod_fk` FOREIGN KEY (`proizvod_id`) REFERENCES `proizvodi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `narudzba_stavka_fk` FOREIGN KEY (`narudzba_id`) REFERENCES `narudzbe` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `racuni` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `datum` date DEFAULT NULL,
  `prodavaonica_id` int unsigned DEFAULT NULL,
  `trgovacki_putnik_id` int unsigned DEFAULT NULL,
  `narudzba_id` int unsigned DEFAULT NULL,
  `cijena` decimal(10,2) default 0,
  `pdv` decimal(10,2) default 0,
  `ukupno` decimal(10,2) default 0,
  PRIMARY KEY (`id`),
  KEY `racun_putnik_fk` (`trgovacki_putnik_id`),
  KEY `racun_prodavaonica_fk` (`prodavaonica_id`),
  KEY `racun_narudzba_fk` (`narudzba_id`),
  CONSTRAINT `racun_prodavaonica_fk` FOREIGN KEY (`prodavaonica_id`) REFERENCES `prodavaonice` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `racun_putnik_fk` FOREIGN KEY (`trgovacki_putnik_id`) REFERENCES `trgovacki_putnici` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `racun_narudzba_fk` FOREIGN KEY (`narudzba_id`) REFERENCES `narudzbe` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `racuni_stavke` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `racun_id` int unsigned DEFAULT NULL,
  `proizvod_id` int unsigned DEFAULT NULL,
  `kolicina` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `racun_stavka_fk` (`racun_id`),
  CONSTRAINT `racun_proizvod_fk` FOREIGN KEY (`proizvod_id`) REFERENCES `proizvodi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `racun_stavka_fk` FOREIGN KEY (`racun_id`) REFERENCES `racuni` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;


-- Kreiranje inicijalnih podataka za svaku tablicu

INSERT INTO `kategorije_proizvoda`(`id`, `naziv`) VALUES(1, 'Čvrsti jogurt');
INSERT INTO `kategorije_proizvoda`(`id`, `naziv`) VALUES(2, 'Trajno mlijeko');
INSERT INTO `kategorije_proizvoda`(`id`, `naziv`) VALUES(3, 'Svježe mlijeko');
INSERT INTO `kategorije_proizvoda`(`id`, `naziv`) VALUES(4, 'Čokoladno mlijeko');
INSERT INTO `kategorije_proizvoda`(`id`, `naziv`) VALUES(5, 'Mlijeko bez laktoze');
INSERT INTO `kategorije_proizvoda`(`id`, `naziv`) VALUES(6, 'Mlijeko velebitskih pašnjaka');
INSERT INTO `kategorije_proizvoda`(`id`, `naziv`) VALUES(7, 'Tekući jogurt');
INSERT INTO `kategorije_proizvoda`(`id`, `naziv`) VALUES(8, 'Sirutka');
INSERT INTO `kategorije_proizvoda`(`id`, `naziv`) VALUES(9, 'Stepko');
INSERT INTO `kategorije_proizvoda`(`id`, `naziv`) VALUES(10, 'Dukatos');
INSERT INTO `kategorije_proizvoda`(`id`, `naziv`) VALUES(11, 'Maslac');
INSERT INTO `kategorije_proizvoda`(`id`, `naziv`) VALUES(12, 'Fit mlijeko');
INSERT INTO `kategorije_proizvoda`(`id`, `naziv`) VALUES(13, 'Fit sir');
INSERT INTO `kategorije_proizvoda`(`id`, `naziv`) VALUES(14, 'Fit protein snack');
INSERT INTO `kategorije_proizvoda`(`id`, `naziv`) VALUES(15, 'Fit sladoled');
INSERT INTO `kategorije_proizvoda`(`id`, `naziv`) VALUES(16, 'SenSia');
INSERT INTO `kategorije_proizvoda`(`id`, `naziv`) VALUES(17, 'Dukatela');
INSERT INTO `kategorije_proizvoda`(`id`, `naziv`) VALUES(18, 'Dukatino');
INSERT INTO `kategorije_proizvoda`(`id`, `naziv`) VALUES(19, 'Kiselo vrhnje');
INSERT INTO `kategorije_proizvoda`(`id`, `naziv`) VALUES(20, 'Mileram');
INSERT INTO `kategorije_proizvoda`(`id`, `naziv`) VALUES(21, 'Vrhnje za kuhanje');
INSERT INTO `kategorije_proizvoda`(`id`, `naziv`) VALUES(22, 'Vrhnje za šlag');
INSERT INTO `kategorije_proizvoda`(`id`, `naziv`) VALUES(23, 'Umak');
INSERT INTO `kategorije_proizvoda`(`id`, `naziv`) VALUES(24, 'Puding');
INSERT INTO `kategorije_proizvoda`(`id`, `naziv`) VALUES(25, 'Mousse');
INSERT INTO `kategorije_proizvoda`(`id`, `naziv`) VALUES(26, 'b.Aktiv jogurt');
INSERT INTO `kategorije_proizvoda`(`id`, `naziv`) VALUES(27, 'b.Aktiv Smoothie');
INSERT INTO `kategorije_proizvoda`(`id`, `naziv`) VALUES(28, 'Vrhnje za kavu');
INSERT INTO `kategorije_proizvoda`(`id`, `naziv`) VALUES(29, 'Sir');
INSERT INTO `kategorije_proizvoda`(`id`, `naziv`) VALUES(30, 'Salama');

INSERT INTO `proizvodi`(`id`, `naziv`, `jedinica`, `mjerna_jedinica`, `kategorija_proizvoda_id`) VALUES(1, 'Čvrsti jogurt 3,2% mliječne masti', '180', 'g', 1);
INSERT INTO `proizvodi`(`id`, `naziv`, `jedinica`, `mjerna_jedinica`, `kategorija_proizvoda_id`) VALUES(2, 'Čvrsti jogurt 3,2% mliječne masti', '800', 'g', 1);
INSERT INTO `proizvodi`(`id`, `naziv`, `jedinica`, `mjerna_jedinica`, `kategorija_proizvoda_id`) VALUES(3, 'Trajno mlijeko 0,5% mliječne masti u tetrapaku', '0,5', 'L', 2);
INSERT INTO `proizvodi`(`id`, `naziv`, `jedinica`, `mjerna_jedinica`, `kategorija_proizvoda_id`) VALUES(4, 'Trajno mlijeko 0,5% mliječne masti u tetrapaku', '1', 'L', 2);
INSERT INTO `proizvodi`(`id`, `naziv`, `jedinica`, `mjerna_jedinica`, `kategorija_proizvoda_id`) VALUES(5, 'Trajno mlijeko 2,5% mliječne masti u tetrapaku', '1', 'L', 2);
INSERT INTO `proizvodi`(`id`, `naziv`, `jedinica`, `mjerna_jedinica`, `kategorija_proizvoda_id`) VALUES(6, 'Svježe mlijeko 3,2% mliječne masti u boci', '1,5', 'L', 3);
INSERT INTO `proizvodi`(`id`, `naziv`, `jedinica`, `mjerna_jedinica`, `kategorija_proizvoda_id`) VALUES(7, 'Svježe mlijeko 3,2% mliječne masti u tetrapaku', '1', 'L', 3);
INSERT INTO `proizvodi`(`id`, `naziv`, `jedinica`, `mjerna_jedinica`, `kategorija_proizvoda_id`) VALUES(8, 'Svježe mlijeko 3,2% mliječne masti u boci', '1', 'L', 3);
INSERT INTO `proizvodi`(`id`, `naziv`, `jedinica`, `mjerna_jedinica`, `kategorija_proizvoda_id`) VALUES(9, 'Čokoladno mlijeko u boci', '1', 'L', 4);
INSERT INTO `proizvodi`(`id`, `naziv`, `jedinica`, `mjerna_jedinica`, `kategorija_proizvoda_id`) VALUES(10, 'Čokoladno mlijeko okus crna čokolada u boci', '0,5', 'L', 4);
INSERT INTO `proizvodi`(`id`, `naziv`, `jedinica`, `mjerna_jedinica`, `kategorija_proizvoda_id`) VALUES(11, 'Čokoladno mlijeko okus bijela čokolada u boci', '0,5', 'L', 4);
INSERT INTO `proizvodi`(`id`, `naziv`, `jedinica`, `mjerna_jedinica`, `kategorija_proizvoda_id`) VALUES(12, 'Čokoladno mlijeko u tetrapaku', '0,5', 'L', 4);
INSERT INTO `proizvodi`(`id`, `naziv`, `jedinica`, `mjerna_jedinica`, `kategorija_proizvoda_id`) VALUES(13, 'Čokoladno mlijeko u tetrapaku', '0,2', 'L', 4);
INSERT INTO `proizvodi`(`id`, `naziv`, `jedinica`, `mjerna_jedinica`, `kategorija_proizvoda_id`) VALUES(14, 'Lagano jutro mlijeko bez laktoze, 1,5% mliječne masti', '1', 'L', 5);
INSERT INTO `proizvodi`(`id`, `naziv`, `jedinica`, `mjerna_jedinica`, `kategorija_proizvoda_id`) VALUES(15, 'Lagano jutro mlijeko bez laktoze, 0% mliječne masti', '1', 'L', 5);
INSERT INTO `proizvodi`(`id`, `naziv`, `jedinica`, `mjerna_jedinica`, `kategorija_proizvoda_id`) VALUES(16, 'Trajno mlijeko velebitskih pašnjaka 2,5% mliječne masti', '1', 'L', 6);
INSERT INTO `proizvodi`(`id`, `naziv`, `jedinica`, `mjerna_jedinica`, `kategorija_proizvoda_id`) VALUES(17, 'Tekući jogurt 2,8% mliječne masti', '180', 'g', 7);
INSERT INTO `proizvodi`(`id`, `naziv`, `jedinica`, `mjerna_jedinica`, `kategorija_proizvoda_id`) VALUES(18, 'Tekući jogurt 2,8% mliječne masti', '230', 'g', 7);
INSERT INTO `proizvodi`(`id`, `naziv`, `jedinica`, `mjerna_jedinica`, `kategorija_proizvoda_id`) VALUES(19, 'Tekući jogurt 2,8% mliječne masti', '330', 'g', 7);
INSERT INTO `proizvodi`(`id`, `naziv`, `jedinica`, `mjerna_jedinica`, `kategorija_proizvoda_id`) VALUES(20, 'Tekući jogurt 2,8% mliječne masti', '500', 'g', 7);
INSERT INTO `proizvodi`(`id`, `naziv`, `jedinica`, `mjerna_jedinica`, `kategorija_proizvoda_id`) VALUES(21, 'Tekući jogurt 2,8% mliječne masti', '1', 'kg', 7);
INSERT INTO `proizvodi`(`id`, `naziv`, `jedinica`, `mjerna_jedinica`, `kategorija_proizvoda_id`) VALUES(22, 'Dukat sirutka', '1', 'L', 8);
INSERT INTO `proizvodi`(`id`, `naziv`, `jedinica`, `mjerna_jedinica`, `kategorija_proizvoda_id`) VALUES(23, 'Dukat stepko buttermilk', '1', 'kg', 9);
INSERT INTO `proizvodi`(`id`, `naziv`, `jedinica`, `mjerna_jedinica`, `kategorija_proizvoda_id`) VALUES(24, 'Dukatos jogurt natur', '150', 'g', 10);
INSERT INTO `proizvodi`(`id`, `naziv`, `jedinica`, `mjerna_jedinica`, `kategorija_proizvoda_id`) VALUES(25, 'Dukatos jogurt jagoda', '150', 'g', 10);
INSERT INTO `proizvodi`(`id`, `naziv`, `jedinica`, `mjerna_jedinica`, `kategorija_proizvoda_id`) VALUES(26, 'Dukatos jogurt badem pistacija', '150', 'g', 10);
INSERT INTO `proizvodi`(`id`, `naziv`, `jedinica`, `mjerna_jedinica`, `kategorija_proizvoda_id`) VALUES(27, 'Dukatos jogurt naranča cimet', '150', 'g', 10);
INSERT INTO `proizvodi`(`id`, `naziv`, `jedinica`, `mjerna_jedinica`, `kategorija_proizvoda_id`) VALUES(28, 'Dukatos ribiz cimet', '150', 'g', 10);
INSERT INTO `proizvodi`(`id`, `naziv`, `jedinica`, `mjerna_jedinica`, `kategorija_proizvoda_id`) VALUES(29, 'Dukatos jogurt natur kantica', '450', 'g', 10);
INSERT INTO `proizvodi`(`id`, `naziv`, `jedinica`, `mjerna_jedinica`, `kategorija_proizvoda_id`) VALUES(30, 'Maslac', '10', 'g', 11);
INSERT INTO `proizvodi`(`id`, `naziv`, `jedinica`, `mjerna_jedinica`, `kategorija_proizvoda_id`) VALUES(31, 'Maslac', '20', 'g', 11);
INSERT INTO `proizvodi`(`id`, `naziv`, `jedinica`, `mjerna_jedinica`, `kategorija_proizvoda_id`) VALUES(32, 'Maslac', '125', 'g', 11);
INSERT INTO `proizvodi`(`id`, `naziv`, `jedinica`, `mjerna_jedinica`, `kategorija_proizvoda_id`) VALUES(33, 'Maslac', '250', 'g', 11);
INSERT INTO `proizvodi`(`id`, `naziv`, `jedinica`, `mjerna_jedinica`, `kategorija_proizvoda_id`) VALUES(34, 'Dukat Fit mliječni proteinski napitak, kava', '0,5', 'L', 12);
INSERT INTO `proizvodi`(`id`, `naziv`, `jedinica`, `mjerna_jedinica`, `kategorija_proizvoda_id`) VALUES(35, 'Dukat Fit mliječni proteinski napitak okus vanilije', '0,5', 'L', 12);
INSERT INTO `proizvodi`(`id`, `naziv`, `jedinica`, `mjerna_jedinica`, `kategorija_proizvoda_id`) VALUES(36, 'Dukat Fit mliječni proteinski napitak okus čokolada', '0,5', 'L', 12);
INSERT INTO `proizvodi`(`id`, `naziv`, `jedinica`, `mjerna_jedinica`, `kategorija_proizvoda_id`) VALUES(37, 'Dukat Fit quark svježi sir', '250', 'g', 13);
INSERT INTO `proizvodi`(`id`, `naziv`, `jedinica`, `mjerna_jedinica`, `kategorija_proizvoda_id`) VALUES(38, 'Dukat Fit protein snack čokolada - slana karamela - lješnjak', '35', 'g', 14);
INSERT INTO `proizvodi`(`id`, `naziv`, `jedinica`, `mjerna_jedinica`, `kategorija_proizvoda_id`) VALUES(39, 'Dukat Fit proteinski sladoled okus vanilija', '140', 'ml', 15);
INSERT INTO `proizvodi`(`id`, `naziv`, `jedinica`, `mjerna_jedinica`, `kategorija_proizvoda_id`) VALUES(40, 'SenSia SNACK vanilija i žitarice', '190', 'g', 16);
INSERT INTO `proizvodi`(`id`, `naziv`, `jedinica`, `mjerna_jedinica`, `kategorija_proizvoda_id`) VALUES(41, 'SenSia natur', '1', 'kg', 16);
INSERT INTO `proizvodi`(`id`, `naziv`, `jedinica`, `mjerna_jedinica`, `kategorija_proizvoda_id`) VALUES(42, 'SenSia vanilija', '1', 'kg', 16);
INSERT INTO `proizvodi`(`id`, `naziv`, `jedinica`, `mjerna_jedinica`, `kategorija_proizvoda_id`) VALUES(43, 'Dukatela original', '70', 'g', 17);
INSERT INTO `proizvodi`(`id`, `naziv`, `jedinica`, `mjerna_jedinica`, `kategorija_proizvoda_id`) VALUES(44, 'Dukatela light', '70', 'g', 17);
INSERT INTO `proizvodi`(`id`, `naziv`, `jedinica`, `mjerna_jedinica`, `kategorija_proizvoda_id`) VALUES(45, 'Dukatela s povrćem', '70', 'g', 17);
INSERT INTO `proizvodi`(`id`, `naziv`, `jedinica`, `mjerna_jedinica`, `kategorija_proizvoda_id`) VALUES(46, 'Dukatino voćni jogurt marelica mrkva', '125', 'g', 18);
INSERT INTO `proizvodi`(`id`, `naziv`, `jedinica`, `mjerna_jedinica`, `kategorija_proizvoda_id`) VALUES(47, 'Dukatino voćni jogurt šumsko voće', '125', 'g', 18);
INSERT INTO `proizvodi`(`id`, `naziv`, `jedinica`, `mjerna_jedinica`, `kategorija_proizvoda_id`) VALUES(48, 'Dukatino voćni jogurt banana', '125', 'g', 18);
INSERT INTO `proizvodi`(`id`, `naziv`, `jedinica`, `mjerna_jedinica`, `kategorija_proizvoda_id`) VALUES(50, 'Brzo & Fino kiselo vrhnje 20% m.m.', '200', 'g', 19);
INSERT INTO `proizvodi`(`id`, `naziv`, `jedinica`, `mjerna_jedinica`, `kategorija_proizvoda_id`) VALUES(51, 'Brzo & Fino mileram 22% m.m.', '400', 'g', 20);
INSERT INTO `proizvodi`(`id`, `naziv`, `jedinica`, `mjerna_jedinica`, `kategorija_proizvoda_id`) VALUES(52, 'Brzo & Fino vrhnje za kuhanje 20% m.m.', '200', 'g', 21);
INSERT INTO `proizvodi`(`id`, `naziv`, `jedinica`, `mjerna_jedinica`, `kategorija_proizvoda_id`) VALUES(53, 'Brzo & Fino vrhnje za šlag 36% m.m.', '200', 'g', 22);
INSERT INTO `proizvodi`(`id`, `naziv`, `jedinica`, `mjerna_jedinica`, `kategorija_proizvoda_id`) VALUES(54, 'Brzo & Fino umak bechamel', '200', 'g', 23);
INSERT INTO `proizvodi`(`id`, `naziv`, `jedinica`, `mjerna_jedinica`, `kategorija_proizvoda_id`) VALUES(55, 'Puding čokolada i šlag', '170', 'g', 24);
INSERT INTO `proizvodi`(`id`, `naziv`, `jedinica`, `mjerna_jedinica`, `kategorija_proizvoda_id`) VALUES(56, 'Mousse čokolada', '100', 'g', 25);
INSERT INTO `proizvodi`(`id`, `naziv`, `jedinica`, `mjerna_jedinica`, `kategorija_proizvoda_id`) VALUES(57, 'LGG jogurt natur', '150', 'g', 26);
INSERT INTO `proizvodi`(`id`, `naziv`, `jedinica`, `mjerna_jedinica`, `kategorija_proizvoda_id`) VALUES(58, 'LGG Smoothie jabuka naranča banana', '330', 'g', 27);
INSERT INTO `proizvodi`(`id`, `naziv`, `jedinica`, `mjerna_jedinica`, `kategorija_proizvoda_id`) VALUES(59, 'Brzo & Fino vrhnje za kavu 10x10', '100', 'g', 28);
INSERT INTO `proizvodi`(`id`, `naziv`, `jedinica`, `mjerna_jedinica`, `kategorija_proizvoda_id`) VALUES(60, 'Podravec', '250', 'g', 29);
INSERT INTO `proizvodi`(`id`, `naziv`, `jedinica`, `mjerna_jedinica`, `kategorija_proizvoda_id`) VALUES(61, 'Galbani Milano, trajna kobasica, narezana', '80', 'g', 29);

INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(1,  '2020-04-01', 2.05,  25.0, 1);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(2,  '2020-04-01', 3.52,  25.0, 2);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(3,  '2020-04-01', 4.45,  25.0, 3);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(4,  '2020-04-01', 6.65,  25.0, 4);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(5,  '2020-04-01', 7.55,  25.0, 5);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(6,  '2020-04-01', 6.47,  25.0, 6);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(7,  '2020-04-01', 4.54,  25.0, 7);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(8,  '2020-04-01', 7.54,  25.0, 8);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(9,  '2020-04-01', 4.54,  25.0, 9);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(10, '2020-04-01', 8.22,  25.0, 10);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(11, '2020-04-01', 6.45,  25.0, 11);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(12, '2020-04-01', 7.59,  25.0, 12);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(13, '2020-04-01', 6.87,  25.0, 13);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(14, '2020-04-01', 6.42,  25.0, 14);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(15, '2020-04-01', 3.22,  25.0, 15);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(16, '2020-04-01', 8.14,  25.0, 16);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(17, '2020-04-01', 2.56,  25.0, 17);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(18, '2020-04-01', 3.33,  25.0, 18);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(19, '2020-04-01', 3.33,  25.0, 19);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(20, '2020-04-01', 3.41,  25.0, 20);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(21, '2020-04-01', 7.99,  25.0, 21);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(22, '2020-04-01', 6.99,  25.0, 22);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(23, '2020-04-01', 6.99,  25.0, 23);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(24, '2020-04-01', 3.51,  25.0, 24);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(25, '2020-04-01', 4.31,  25.0, 25);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(26, '2020-04-01', 3.51,  25.0, 26);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(27, '2020-04-01', 3.51,  25.0, 27);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(28, '2020-04-01', 4.24,  25.0, 28);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(29, '2020-04-01', 4.24,  25.0, 29);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(30, '2020-04-01', 2.99,  25.0, 30);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(31, '2020-04-01', 3.99,  25.0, 31);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(32, '2020-04-01', 22.99, 25.0, 32);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(33, '2020-04-01', 30.99, 25.0, 33);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(34, '2020-04-01', 5.55,  25.0, 34);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(35, '2020-04-01', 5.35,  25.0, 35);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(36, '2020-04-01', 5.45,  25.0, 36);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(37, '2020-04-01', 6.55,  25.0, 37);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(38, '2020-04-01', 4.75,  25.0, 38);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(39, '2020-04-01', 4.49,  25.0, 39);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(40, '2020-04-01', 5.41,  25.0, 40);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(41, '2020-04-01', 8.74,  25.0, 41);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(42, '2020-04-01', 8.50,  25.0, 42);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(43, '2020-04-01', 2.55,  25.0, 43);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(44, '2020-04-01', 2.65,  25.0, 44);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(45, '2020-04-01', 2.65,  25.0, 45);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(46, '2020-04-01', 6.54,  25.0, 46);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(47, '2020-04-01', 6.54,  25.0, 47);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(48, '2020-04-01', 6.54,  25.0, 48);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(50, '2020-04-01', 7.65,  25.0, 50);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(51, '2020-04-01', 7.65,  25.0, 51);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(52, '2020-04-01', 5.87,  25.0, 52);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(53, '2020-04-01', 5.87,  25.0, 53);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(54, '2020-04-01', 5.87,  25.0, 54);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(55, '2020-04-01', 6.87,  25.0, 55);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(56, '2020-04-01', 3.55,  25.0, 56);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(57, '2020-04-01', 4.45,  25.0, 57);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(58, '2020-04-01', 3.30,  25.0, 58);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(59, '2020-04-01', 2.89,  25.0, 59);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(60, '2020-04-01', 7.51,  25.0, 60);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(61, '2020-04-01', 4.89,  25.0, 61);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(62, '2020-04-02', 5.89,  25.0, 61);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(63, '2020-04-03', 6.89,  25.0, 61);
INSERT INTO `cijene_proizvoda`(`id`, `datum_od`, `cijena`, `pdv`, `proizvod_id`) VALUES(64, '2020-04-04', 7.89,  25.0, 61);

INSERT INTO `trgovacki_putnici`(`id`, `ime`, `prezime`, `datum_rodenja`, `oib`, `adresa`, `postanski_broj`, `grad`) VALUES(1, 'Hrvoje', 'Horvat', '1988-06-29', 54781321475, 'Palladiova ulica 1a', 52100, 'Pula');
INSERT INTO `trgovacki_putnici`(`id`, `ime`, `prezime`, `datum_rodenja`, `oib`, `adresa`, `postanski_broj`, `grad`) VALUES(2, 'Ana', 'Perić', '1989-05-29', 15644132145, 'Rovinjska ulica 16', 52100, 'Pula');
INSERT INTO `trgovacki_putnici`(`id`, `ime`, `prezime`, `datum_rodenja`, `oib`, `adresa`, `postanski_broj`, `grad`) VALUES(3, 'Enrico', 'Mirković', '1984-08-30', 78456874592, 'Galijotska ulica 21', 52100, 'Pula');
INSERT INTO `trgovacki_putnici`(`id`, `ime`, `prezime`, `datum_rodenja`, `oib`, `adresa`, `postanski_broj`, `grad`) VALUES(4, 'Erik', 'Marinović', '1970-07-16', 98542357964, 'Jeretova ulica 1', 52100, 'Pula');
INSERT INTO `trgovacki_putnici`(`id`, `ime`, `prezime`, `datum_rodenja`, `oib`, `adresa`, `postanski_broj`, `grad`) VALUES(5, 'Loris', 'Papić', '1987-04-11', 54239874565, 'Rakovčeva ulica 2', 52100, 'Pula');
INSERT INTO `trgovacki_putnici`(`id`, `ime`, `prezime`, `datum_rodenja`, `oib`, `adresa`, `postanski_broj`, `grad`) VALUES(6, 'Mateja', 'Udošić', '1981-01-29', 84521358745, 'Jeretova ulica 36', 52100, 'Pula');
INSERT INTO `trgovacki_putnici`(`id`, `ime`, `prezime`, `datum_rodenja`, `oib`, `adresa`, `postanski_broj`, `grad`) VALUES(7, 'Lara', 'Štajner', '1988-09-14', 85463258745, 'Marijanijeva ulica 52', 52100, 'Pula');
INSERT INTO `trgovacki_putnici`(`id`, `ime`, `prezime`, `datum_rodenja`, `oib`, `adresa`, `postanski_broj`, `grad`) VALUES(8, 'Mateja', 'Brlečić', '1991-01-19', 23546230142, 'Tomislavova ulica 26', 52100, 'Pula');
INSERT INTO `trgovacki_putnici`(`id`, `ime`, `prezime`, `datum_rodenja`, `oib`, `adresa`, `postanski_broj`, `grad`) VALUES(9, 'Ivan', 'Lukić', '1983-10-26', 23587456321, 'Teslina ulica 11', 52100, 'Pula');
INSERT INTO `trgovacki_putnici`(`id`, `ime`, `prezime`, `datum_rodenja`, `oib`, `adresa`, `postanski_broj`, `grad`) VALUES(10, 'Dalibor', 'Lazović', '1992-04-27', 02345125478, 'Stankovićeva ulica 3b', 52100, 'Pula');
INSERT INTO `trgovacki_putnici`(`id`, `ime`, `prezime`, `datum_rodenja`, `oib`, `adresa`, `postanski_broj`, `grad`) VALUES(11, 'Aleksandar', 'Blagojević', '1981-12-26', 02554481265, 'Dobrićeva ulica 5', 52100, 'Pula');
INSERT INTO `trgovacki_putnici`(`id`, `ime`, `prezime`, `datum_rodenja`, `oib`, `adresa`, `postanski_broj`, `grad`) VALUES(12, 'Luka', 'Jurković', '1987-04-19', 52468794532, 'Zagrebačka ulica 41', 52100, 'Pula');
INSERT INTO `trgovacki_putnici`(`id`, `ime`, `prezime`, `datum_rodenja`, `oib`, `adresa`, `postanski_broj`, `grad`) VALUES(13, 'Andrej', 'Udošić', '1981-03-17', 11458544884, 'Scaglierova ulica 15', 52100, 'Pula');
INSERT INTO `trgovacki_putnici`(`id`, `ime`, `prezime`, `datum_rodenja`, `oib`, `adresa`, `postanski_broj`, `grad`) VALUES(14, 'Marinko', 'Petković', '1974-11-04', 12549531282, 'Valvidalska ulica 3', 52100, 'Pula');
INSERT INTO `trgovacki_putnici`(`id`, `ime`, `prezime`, `datum_rodenja`, `oib`, `adresa`, `postanski_broj`, `grad`) VALUES(15, 'Martina', 'Isanović', '1993-05-03', 14662516513, 'Monvidalska ulica 4', 52100, 'Pula');
INSERT INTO `trgovacki_putnici`(`id`, `ime`, `prezime`, `datum_rodenja`, `oib`, `adresa`, `postanski_broj`, `grad`) VALUES(16, 'Hana', 'Fornazar', '1989-05-29', 81354613136, 'Pazinska ulica 8', 52100, 'Pula');
INSERT INTO `trgovacki_putnici`(`id`, `ime`, `prezime`, `datum_rodenja`, `oib`, `adresa`, `postanski_broj`, `grad`) VALUES(17, 'Veljko', 'Skol', '1983-03-05', 45643213245, 'Motikina ulica 8', 52100, 'Pula');
INSERT INTO `trgovacki_putnici`(`id`, `ime`, `prezime`, `datum_rodenja`, `oib`, `adresa`, `postanski_broj`, `grad`) VALUES(18, 'Emanuel', 'Bilić', '1981-05-29', 12311384131, 'Emova ulica 7', 52100, 'Pula');
INSERT INTO `trgovacki_putnici`(`id`, `ime`, `prezime`, `datum_rodenja`, `oib`, `adresa`, `postanski_broj`, `grad`) VALUES(19, 'Jelena', 'Nikolić', '1988-06-15', 54781321485, 'Splitska ulica 7', 52100, 'Pula');
INSERT INTO `trgovacki_putnici`(`id`, `ime`, `prezime`, `datum_rodenja`, `oib`, `adresa`, `postanski_broj`, `grad`) VALUES(20, 'Diana', 'Brkić', '1986-06-22', 34535318313, 'Ravenska ulica 15', 52100, 'Pula');
INSERT INTO `trgovacki_putnici`(`id`, `ime`, `prezime`, `datum_rodenja`, `oib`, `adresa`, `postanski_broj`, `grad`) VALUES(21, 'Ines', 'Jelovac', '1981-01-19', 89746132465, 'Vinogradska ulica 11', 52100, 'Pula');
INSERT INTO `trgovacki_putnici`(`id`, `ime`, `prezime`, `datum_rodenja`, `oib`, `adresa`, `postanski_broj`, `grad`) VALUES(22, 'Ivan', 'Dasko', '1994-02-18', 01034531312, 'Radnička ulica 13', 52100, 'Pula');
INSERT INTO `trgovacki_putnici`(`id`, `ime`, `prezime`, `datum_rodenja`, `oib`, `adresa`, `postanski_broj`, `grad`) VALUES(23, 'Mirko', 'Petrović', '1991-04-23', 89768413153, 'Plominska ulica 12', 52100, 'Pula');
INSERT INTO `trgovacki_putnici`(`id`, `ime`, `prezime`, `datum_rodenja`, `oib`, `adresa`, `postanski_broj`, `grad`) VALUES(24, 'Tatjana', 'Horvat', '1992-07-12', 89432132134, 'Vodovodna ulica 21', 52100, 'Pula');
INSERT INTO `trgovacki_putnici`(`id`, `ime`, `prezime`, `datum_rodenja`, `oib`, `adresa`, `postanski_broj`, `grad`) VALUES(25, 'Petar', 'Petković', '1979-04-04', 26652561653, 'Meštrovićeva ulica 27', 52100, 'Pula');
INSERT INTO `trgovacki_putnici`(`id`, `ime`, `prezime`, `datum_rodenja`, `oib`, `adresa`, `postanski_broj`, `grad`) VALUES(26, 'Marko', 'Orbanić', '1991-05-01', 34456132545, 'Rabarova ulica 43', 52100, 'Pula');
INSERT INTO `trgovacki_putnici`(`id`, `ime`, `prezime`, `datum_rodenja`, `oib`, `adresa`, `postanski_broj`, `grad`) VALUES(27, 'Denis', 'Orbanić', '1994-06-24', 78612313555, 'Carlijeva ulica 4', 52100, 'Pula');
INSERT INTO `trgovacki_putnici`(`id`, `ime`, `prezime`, `datum_rodenja`, `oib`, `adresa`, `postanski_broj`, `grad`) VALUES(28, 'Denis', 'Palac', '1988-02-04', 32547258621, 'Šenoina ulica 7', 52100, 'Pula');
INSERT INTO `trgovacki_putnici`(`id`, `ime`, `prezime`, `datum_rodenja`, `oib`, `adresa`, `postanski_broj`, `grad`) VALUES(29, 'Andrea', 'Perić', '1975-11-14', 12154351513, 'Palisina ulica 6', 52100, 'Pula');
INSERT INTO `trgovacki_putnici`(`id`, `ime`, `prezime`, `datum_rodenja`, `oib`, `adresa`, `postanski_broj`, `grad`) VALUES(30, 'Nikola', 'Blagojević', '1987-01-16', 42321351351, 'Rizzijeva ulica 1', 52100, 'Pula');

INSERT INTO `prodavaonice`(`id`, `naziv`, `adresa`, `postanski_broj`, `grad`) VALUES(1, 'Puljanka 16', 'Palladiova ulica 1a', 52100, 'Pula');
INSERT INTO `prodavaonice`(`id`, `naziv`, `adresa`, `postanski_broj`, `grad`) VALUES(2, 'Puljanka 17',  'Rovinjska ulica 16', 52100, 'Pula');
INSERT INTO `prodavaonice`(`id`, `naziv`, `adresa`, `postanski_broj`, `grad`) VALUES(3, 'Puljanka 18', 'Galijotska ulica 21', 52100, 'Pula');
INSERT INTO `prodavaonice`(`id`, `naziv`, `adresa`, `postanski_broj`, `grad`) VALUES(4, 'Puljanka 19', 'Jeretova ulica 1', 52100, 'Pula');
INSERT INTO `prodavaonice`(`id`, `naziv`, `adresa`, `postanski_broj`, `grad`) VALUES(5, 'Puljanka 10',  'Rakovčeva ulica 2', 52100, 'Pula');
INSERT INTO `prodavaonice`(`id`, `naziv`, `adresa`, `postanski_broj`, `grad`) VALUES(6, 'Puljanka 1', 'Jeretova ulica 36', 52100, 'Pula');
INSERT INTO `prodavaonice`(`id`, `naziv`, `adresa`, `postanski_broj`, `grad`) VALUES(7, 'Duravit 1', 'Marijanijeva ulica 52', 52100, 'Pula');
INSERT INTO `prodavaonice`(`id`, `naziv`, `adresa`, `postanski_broj`, `grad`) VALUES(8, 'Duravit 2', 'Tomislavova ulica 26', 52100, 'Pula');
INSERT INTO `prodavaonice`(`id`, `naziv`, `adresa`, `postanski_broj`, `grad`) VALUES(9, 'Duravit 3', 'Teslina ulica 11', 52100, 'Pula');
INSERT INTO `prodavaonice`(`id`, `naziv`, `adresa`, `postanski_broj`, `grad`) VALUES(10, 'Duravit 4', 'Stankovićeva ulica 3b', 52100, 'Pula');
INSERT INTO `prodavaonice`(`id`, `naziv`, `adresa`, `postanski_broj`, `grad`) VALUES(11, 'Duravit 5', 'Dobrićeva ulica 5', 52100, 'Pula');
INSERT INTO `prodavaonice`(`id`, `naziv`, `adresa`, `postanski_broj`, `grad`) VALUES(12, 'Studenac 1', 'Zagrebačka ulica 41', 52100, 'Pula');
INSERT INTO `prodavaonice`(`id`, `naziv`, `adresa`, `postanski_broj`, `grad`) VALUES(13, 'Studenac 2', 'Scaglierova ulica 15', 52100, 'Pula');
INSERT INTO `prodavaonice`(`id`, `naziv`, `adresa`, `postanski_broj`, `grad`) VALUES(14, 'Studenac 3', 'Valvidalska ulica 3', 52100, 'Pula');
INSERT INTO `prodavaonice`(`id`, `naziv`, `adresa`, `postanski_broj`, `grad`) VALUES(15, 'Studenac 4', 'Monvidalska ulica 4', 52100, 'Pula');
INSERT INTO `prodavaonice`(`id`, `naziv`, `adresa`, `postanski_broj`, `grad`) VALUES(16, 'Studenac 5', 'Pazinska ulica 8', 52100, 'Pula');
INSERT INTO `prodavaonice`(`id`, `naziv`, `adresa`, `postanski_broj`, `grad`) VALUES(17, 'Studenac 6', 'Motikina ulica 8', 52100, 'Pula');
INSERT INTO `prodavaonice`(`id`, `naziv`, `adresa`, `postanski_broj`, `grad`) VALUES(18, 'Duravit 6', 'Emova ulica 7', 52100, 'Pula');
INSERT INTO `prodavaonice`(`id`, `naziv`, `adresa`, `postanski_broj`, `grad`) VALUES(19, 'Duravit 7', 'Splitska ulica 7', 52100, 'Pula');
INSERT INTO `prodavaonice`(`id`, `naziv`, `adresa`, `postanski_broj`, `grad`) VALUES(20, 'Duravit 8', 'Ravenska ulica 15', 52100, 'Pula');
INSERT INTO `prodavaonice`(`id`, `naziv`, `adresa`, `postanski_broj`, `grad`) VALUES(21, 'Duravit 9', 'Vinogradska ulica 11', 52100, 'Pula');
INSERT INTO `prodavaonice`(`id`, `naziv`, `adresa`, `postanski_broj`, `grad`) VALUES(22, 'Ultra 1', 'Radnička ulica 13', 52100, 'Pula');
INSERT INTO `prodavaonice`(`id`, `naziv`, `adresa`, `postanski_broj`, `grad`) VALUES(23, 'Ultra 2', 'Plominska ulica 12', 52100, 'Pula');
INSERT INTO `prodavaonice`(`id`, `naziv`, `adresa`, `postanski_broj`, `grad`) VALUES(24, 'Ultra 3', 'Vodovodna ulica 21', 52100, 'Pula');
INSERT INTO `prodavaonice`(`id`, `naziv`, `adresa`, `postanski_broj`, `grad`) VALUES(25, 'Ultra 4', 'Meštrovićeva ulica 27', 52100, 'Pula');
INSERT INTO `prodavaonice`(`id`, `naziv`, `adresa`, `postanski_broj`, `grad`) VALUES(26, 'Ultra 5', 'Rabarova ulica 43', 52100, 'Pula');
INSERT INTO `prodavaonice`(`id`, `naziv`, `adresa`, `postanski_broj`, `grad`) VALUES(27, 'Konzum 1', 'Carlijeva ulica 4', 52100, 'Pula');
INSERT INTO `prodavaonice`(`id`, `naziv`, `adresa`, `postanski_broj`, `grad`) VALUES(28, 'Konzum 2', 'Šenoina ulica 7', 52100, 'Pula');
INSERT INTO `prodavaonice`(`id`, `naziv`, `adresa`, `postanski_broj`, `grad`) VALUES(29, 'Konzum 3', 'Palisina ulica 6', 52100, 'Pula');
INSERT INTO `prodavaonice`(`id`, `naziv`, `adresa`, `postanski_broj`, `grad`) VALUES(30, 'Konzum 4', 'Rizzijeva ulica 1', 52100, 'Pula');

INSERT INTO `automobili`(`id`, `marka`, `model`, `godiste`) VALUES(1, 'Volkswagen', 'Polo', 2017);
INSERT INTO `automobili`(`id`, `marka`, `model`, `godiste`) VALUES(2, 'Volkswagen', 'Polo', 2017);
INSERT INTO `automobili`(`id`, `marka`, `model`, `godiste`) VALUES(3, 'Volkswagen', 'Polo', 2017);
INSERT INTO `automobili`(`id`, `marka`, `model`, `godiste`) VALUES(4, 'Volkswagen', 'Polo', 2017);
INSERT INTO `automobili`(`id`, `marka`, `model`, `godiste`) VALUES(5, 'Volkswagen', 'Polo', 2017);
INSERT INTO `automobili`(`id`, `marka`, `model`, `godiste`) VALUES(6, 'Volkswagen', 'Polo', 2017);
INSERT INTO `automobili`(`id`, `marka`, `model`, `godiste`) VALUES(7, 'Volkswagen', 'Polo', 2017);
INSERT INTO `automobili`(`id`, `marka`, `model`, `godiste`) VALUES(8, 'Volkswagen', 'Polo', 2017);
INSERT INTO `automobili`(`id`, `marka`, `model`, `godiste`) VALUES(9, 'Škoda', 'Octavia', 2018);
INSERT INTO `automobili`(`id`, `marka`, `model`, `godiste`) VALUES(10, 'Škoda', 'Octavia', 2018);
INSERT INTO `automobili`(`id`, `marka`, `model`, `godiste`) VALUES(11, 'Škoda', 'Octavia', 2018);
INSERT INTO `automobili`(`id`, `marka`, `model`, `godiste`) VALUES(12, 'Škoda', 'Octavia', 2018);
INSERT INTO `automobili`(`id`, `marka`, `model`, `godiste`) VALUES(13, 'Škoda', 'Octavia', 2018);
INSERT INTO `automobili`(`id`, `marka`, `model`, `godiste`) VALUES(14, 'Škoda', 'Octavia', 2018);
INSERT INTO `automobili`(`id`, `marka`, `model`, `godiste`) VALUES(15, 'Škoda', 'Octavia', 2018);
INSERT INTO `automobili`(`id`, `marka`, `model`, `godiste`) VALUES(16, 'Škoda', 'Octavia', 2018);
INSERT INTO `automobili`(`id`, `marka`, `model`, `godiste`) VALUES(17, 'Škoda', 'Octavia', 2018);
INSERT INTO `automobili`(`id`, `marka`, `model`, `godiste`) VALUES(18, 'Škoda', 'Octavia', 2018);
INSERT INTO `automobili`(`id`, `marka`, `model`, `godiste`) VALUES(19, 'Volkswagen', 'Golf', 2018);
INSERT INTO `automobili`(`id`, `marka`, `model`, `godiste`) VALUES(20, 'Volkswagen', 'Golf', 2018);
INSERT INTO `automobili`(`id`, `marka`, `model`, `godiste`) VALUES(21, 'Volkswagen', 'Golf', 2018);
INSERT INTO `automobili`(`id`, `marka`, `model`, `godiste`) VALUES(22, 'Volkswagen', 'Golf', 2018);
INSERT INTO `automobili`(`id`, `marka`, `model`, `godiste`) VALUES(23, 'Volkswagen', 'Golf', 2018);
INSERT INTO `automobili`(`id`, `marka`, `model`, `godiste`) VALUES(24, 'Volkswagen', 'Golf', 2018);
INSERT INTO `automobili`(`id`, `marka`, `model`, `godiste`) VALUES(25, 'Volkswagen', 'Golf', 2018);
INSERT INTO `automobili`(`id`, `marka`, `model`, `godiste`) VALUES(26, 'Volkswagen', 'Golf', 2018);
INSERT INTO `automobili`(`id`, `marka`, `model`, `godiste`) VALUES(27, 'Volkswagen', 'Golf', 2018);
INSERT INTO `automobili`(`id`, `marka`, `model`, `godiste`) VALUES(28, 'Volkswagen', 'Golf', 2018);
INSERT INTO `automobili`(`id`, `marka`, `model`, `godiste`) VALUES(29, 'Volkswagen', 'Golf', 2018);
INSERT INTO `automobili`(`id`, `marka`, `model`, `godiste`) VALUES(30, 'Volkswagen', 'Golf', 2018);

INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(1, 1, 30120, 30134, '2020-04-01');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(1, 1, 30134, 30145, '2020-04-05');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(1, 1, 30145, 30167, '2020-04-08');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(2, 2, 32120, 32134, '2020-04-01');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(2, 2, 32134, 32145, '2020-04-05');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(2, 2, 32145, 32167, '2020-04-08');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(3, 3, 20120, 20134, '2020-04-01');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(3, 3, 20134, 20145, '2020-04-05');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(3, 3, 20145, 20167, '2020-04-08');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(4, 4, 20540, 20578, '2020-04-01');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(4, 4, 20578, 20598, '2020-04-05');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(4, 4, 20598, 20619, '2020-04-08');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(5, 5, 29540, 29578, '2020-04-01');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(5, 5, 29578, 29598, '2020-04-05');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(5, 5, 29598, 29619, '2020-04-08');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(6, 6, 26540, 26578, '2020-04-01');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(6, 6, 26578, 26598, '2020-04-05');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(6, 6, 26598, 26619, '2020-04-08');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(7, 7, 35120, 35134, '2020-04-01');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(7, 7, 35134, 35145, '2020-04-05');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(7, 7, 35145, 35167, '2020-04-08');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(8, 8, 18220, 18234, '2020-04-01');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(8, 8, 18234, 18245, '2020-04-05');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(8, 8, 18245, 18267, '2020-04-08');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(9, 9, 18220, 18234, '2020-04-01');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(9, 9, 18234, 18245, '2020-04-05');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(9, 9, 18245, 18267, '2020-04-08');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(10, 10, 15320, 15334, '2020-04-01');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(10, 10, 15334, 15345, '2020-04-05');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(10, 10, 15345, 15367, '2020-04-08');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(11, 11, 26540, 26578, '2020-04-01');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(11, 11, 26578, 26598, '2020-04-05');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(11, 11, 26598, 26619, '2020-04-08');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(12, 12, 26740, 26778, '2020-04-01');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(12, 12, 26778, 26798, '2020-04-05');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(12, 12, 26798, 26819, '2020-04-08');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(13, 13, 27840, 27878, '2020-04-01');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(13, 13, 27878, 27898, '2020-04-05');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(13, 13, 27898, 27919, '2020-04-08');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(14, 14, 31840, 31878, '2020-04-01');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(14, 14, 31878, 31898, '2020-04-05');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(14, 14, 31898, 31919, '2020-04-08');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(15, 15, 32640, 32678, '2020-04-01');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(15, 15, 32678, 32698, '2020-04-05');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(15, 15, 32698, 32719, '2020-04-08');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(16, 16, 32640, 32678, '2020-04-01');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(16, 16, 32678, 32698, '2020-04-05');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(16, 16, 32698, 32719, '2020-04-08');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(17, 17, 12640, 12678, '2020-04-01');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(17, 17, 12678, 12698, '2020-04-05');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(17, 17, 12698, 12719, '2020-04-08');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(18, 18, 35120, 35134, '2020-04-01');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(18, 18, 35134, 35145, '2020-04-05');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(18, 18, 35145, 35167, '2020-04-08');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(19, 19, 34120, 34134, '2020-04-01');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(19, 19, 34134, 34145, '2020-04-05');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(19, 19, 34145, 34167, '2020-04-08');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(20, 20, 14120, 14134, '2020-04-01');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(20, 20, 14134, 14145, '2020-04-05');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(20, 20, 14145, 14167, '2020-04-08');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(21, 21, 31120, 31134, '2020-04-01');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(21, 21, 31134, 31145, '2020-04-05');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(21, 21, 31145, 31167, '2020-04-08');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(22, 22, 38120, 38134, '2020-04-01');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(22, 22, 38134, 38145, '2020-04-05');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(22, 22, 38145, 38167, '2020-04-08');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(23, 23, 48120, 48134, '2020-04-01');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(23, 23, 48134, 48145, '2020-04-05');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(23, 23, 48145, 48167, '2020-04-08');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(24, 24, 27120, 27134, '2020-04-01');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(24, 24, 27134, 27145, '2020-04-05');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(24, 24, 27145, 27167, '2020-04-08');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(25, 25, 17120, 17134, '2020-04-01');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(25, 25, 17134, 17145, '2020-04-05');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(25, 25, 17145, 17167, '2020-04-08');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(26, 26, 18220, 18234, '2020-04-01');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(26, 26, 18234, 18245, '2020-04-05');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(26, 26, 18245, 18267, '2020-04-08');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(27, 27, 26220, 26234, '2020-04-01');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(27, 27, 26234, 26245, '2020-04-05');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(27, 27, 26245, 26267, '2020-04-08');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(28, 28, 16220, 16234, '2020-04-01');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(28, 28, 16234, 16245, '2020-04-05');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(28, 28, 16245, 16267, '2020-04-08');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(29, 29, 27220, 27234, '2020-04-01');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(29, 29, 27234, 27245, '2020-04-05');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(29, 29, 27245, 27267, '2020-04-08');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(30, 30, 16220, 16234, '2020-04-01');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(30, 30, 16234, 16245, '2020-04-05');
INSERT INTO `automobili_prijedeni_put`(`trgovacki_putnik_id`, `automobil_id`, `pocetak_kilometri`, `kraj_kilometri`, `datum`) VALUES(30, 30, 16245, 16267, '2020-04-08');

INSERT INTO `narudzbe`(`id`, `datum`, `prodavaonica_id`, `trgovacki_putnik_id`) VALUES(1, '2020-04-01', 1, 1);
INSERT INTO `narudzbe`(`id`, `datum`, `prodavaonica_id`, `trgovacki_putnik_id`) VALUES(2, '2020-04-05', 2, 1);
INSERT INTO `narudzbe`(`id`, `datum`, `prodavaonica_id`, `trgovacki_putnik_id`) VALUES(3, '2020-04-08', 3, 1);
INSERT INTO `narudzbe`(`id`, `datum`, `prodavaonica_id`, `trgovacki_putnik_id`) VALUES(4, '2020-04-01', 4, 2);
INSERT INTO `narudzbe`(`id`, `datum`, `prodavaonica_id`, `trgovacki_putnik_id`) VALUES(5, '2020-04-05', 5, 2);
INSERT INTO `narudzbe`(`id`, `datum`, `prodavaonica_id`, `trgovacki_putnik_id`) VALUES(6, '2020-04-08', 6, 2);
INSERT INTO `narudzbe`(`id`, `datum`, `prodavaonica_id`, `trgovacki_putnik_id`) VALUES(7, '2020-04-01', 7, 3);
INSERT INTO `narudzbe`(`id`, `datum`, `prodavaonica_id`, `trgovacki_putnik_id`) VALUES(8, '2020-04-05', 8, 3);
INSERT INTO `narudzbe`(`id`, `datum`, `prodavaonica_id`, `trgovacki_putnik_id`) VALUES(9, '2020-04-08', 9, 3);
INSERT INTO `narudzbe`(`id`, `datum`, `prodavaonica_id`, `trgovacki_putnik_id`) VALUES(10, '2020-04-01', 10, 4);
INSERT INTO `narudzbe`(`id`, `datum`, `prodavaonica_id`, `trgovacki_putnik_id`) VALUES(11, '2020-04-05', 11, 4);
INSERT INTO `narudzbe`(`id`, `datum`, `prodavaonica_id`, `trgovacki_putnik_id`) VALUES(12, '2020-04-08', 12, 4);
INSERT INTO `narudzbe`(`id`, `datum`, `prodavaonica_id`, `trgovacki_putnik_id`) VALUES(13, '2020-04-01', 13, 5);
INSERT INTO `narudzbe`(`id`, `datum`, `prodavaonica_id`, `trgovacki_putnik_id`) VALUES(14, '2020-04-05', 14, 5);
INSERT INTO `narudzbe`(`id`, `datum`, `prodavaonica_id`, `trgovacki_putnik_id`) VALUES(15, '2020-04-08', 15, 5);
INSERT INTO `narudzbe`(`id`, `datum`, `prodavaonica_id`, `trgovacki_putnik_id`) VALUES(16, '2020-04-01', 16, 6);
INSERT INTO `narudzbe`(`id`, `datum`, `prodavaonica_id`, `trgovacki_putnik_id`) VALUES(17, '2020-04-05', 17, 6);
INSERT INTO `narudzbe`(`id`, `datum`, `prodavaonica_id`, `trgovacki_putnik_id`) VALUES(18, '2020-04-08', 18, 6);
INSERT INTO `narudzbe`(`id`, `datum`, `prodavaonica_id`, `trgovacki_putnik_id`) VALUES(19, '2020-04-01', 19, 7);
INSERT INTO `narudzbe`(`id`, `datum`, `prodavaonica_id`, `trgovacki_putnik_id`) VALUES(20, '2020-04-05', 20, 7);
INSERT INTO `narudzbe`(`id`, `datum`, `prodavaonica_id`, `trgovacki_putnik_id`) VALUES(21, '2020-04-08', 21, 7);
INSERT INTO `narudzbe`(`id`, `datum`, `prodavaonica_id`, `trgovacki_putnik_id`) VALUES(22, '2020-04-01', 22, 8);
INSERT INTO `narudzbe`(`id`, `datum`, `prodavaonica_id`, `trgovacki_putnik_id`) VALUES(23, '2020-04-05', 23, 8);
INSERT INTO `narudzbe`(`id`, `datum`, `prodavaonica_id`, `trgovacki_putnik_id`) VALUES(24, '2020-04-08', 24, 8);
INSERT INTO `narudzbe`(`id`, `datum`, `prodavaonica_id`, `trgovacki_putnik_id`) VALUES(25, '2020-04-01', 25, 9);
INSERT INTO `narudzbe`(`id`, `datum`, `prodavaonica_id`, `trgovacki_putnik_id`) VALUES(26, '2020-04-05', 26, 9);
INSERT INTO `narudzbe`(`id`, `datum`, `prodavaonica_id`, `trgovacki_putnik_id`) VALUES(27, '2020-04-08', 27, 9);
INSERT INTO `narudzbe`(`id`, `datum`, `prodavaonica_id`, `trgovacki_putnik_id`) VALUES(28, '2020-04-01', 28, 10);
INSERT INTO `narudzbe`(`id`, `datum`, `prodavaonica_id`, `trgovacki_putnik_id`) VALUES(29, '2020-04-05', 29, 10);
INSERT INTO `narudzbe`(`id`, `datum`, `prodavaonica_id`, `trgovacki_putnik_id`) VALUES(30, '2020-04-08', 30, 10);

INSERT INTO `narudzbe_stavke`(`id`, `narudzba_id`, `proizvod_id`, `kolicina`) VALUES(1, 1, 4, 10);
INSERT INTO `narudzbe_stavke`(`id`, `narudzba_id`, `proizvod_id`, `kolicina`) VALUES(2, 1, 9, 15);
INSERT INTO `narudzbe_stavke`(`id`, `narudzba_id`, `proizvod_id`, `kolicina`) VALUES(3, 2, 21, 9);
INSERT INTO `narudzbe_stavke`(`id`, `narudzba_id`, `proizvod_id`, `kolicina`) VALUES(4, 2, 22, 21);
INSERT INTO `narudzbe_stavke`(`id`, `narudzba_id`, `proizvod_id`, `kolicina`) VALUES(5, 3, 5, 5);
INSERT INTO `narudzbe_stavke`(`id`, `narudzba_id`, `proizvod_id`, `kolicina`) VALUES(6, 3, 3, 4);
INSERT INTO `narudzbe_stavke`(`id`, `narudzba_id`, `proizvod_id`, `kolicina`) VALUES(7, 4, 8, 12);
INSERT INTO `narudzbe_stavke`(`id`, `narudzba_id`, `proizvod_id`, `kolicina`) VALUES(8, 4, 4, 1);
INSERT INTO `narudzbe_stavke`(`id`, `narudzba_id`, `proizvod_id`, `kolicina`) VALUES(9, 5, 7, 11);
INSERT INTO `narudzbe_stavke`(`id`, `narudzba_id`, `proizvod_id`, `kolicina`) VALUES(10, 5, 55, 5);
INSERT INTO `narudzbe_stavke`(`id`, `narudzba_id`, `proizvod_id`, `kolicina`) VALUES(11, 6, 34, 4);
INSERT INTO `narudzbe_stavke`(`id`, `narudzba_id`, `proizvod_id`, `kolicina`) VALUES(12, 6, 17, 12);
INSERT INTO `narudzbe_stavke`(`id`, `narudzba_id`, `proizvod_id`, `kolicina`) VALUES(13, 7, 7, 34);
INSERT INTO `narudzbe_stavke`(`id`, `narudzba_id`, `proizvod_id`, `kolicina`) VALUES(14, 7, 52, 52);
INSERT INTO `narudzbe_stavke`(`id`, `narudzba_id`, `proizvod_id`, `kolicina`) VALUES(15, 8, 22, 11);
INSERT INTO `narudzbe_stavke`(`id`, `narudzba_id`, `proizvod_id`, `kolicina`) VALUES(16, 8, 24, 6);
INSERT INTO `narudzbe_stavke`(`id`, `narudzba_id`, `proizvod_id`, `kolicina`) VALUES(17, 9, 17, 24);
INSERT INTO `narudzbe_stavke`(`id`, `narudzba_id`, `proizvod_id`, `kolicina`) VALUES(18, 9, 13, 35);
INSERT INTO `narudzbe_stavke`(`id`, `narudzba_id`, `proizvod_id`, `kolicina`) VALUES(19, 10, 14, 51);
INSERT INTO `narudzbe_stavke`(`id`, `narudzba_id`, `proizvod_id`, `kolicina`) VALUES(20, 10, 28, 45);
INSERT INTO `narudzbe_stavke`(`id`, `narudzba_id`, `proizvod_id`, `kolicina`) VALUES(21, 11, 34, 75);
INSERT INTO `narudzbe_stavke`(`id`, `narudzba_id`, `proizvod_id`, `kolicina`) VALUES(22, 11, 38, 95);
INSERT INTO `narudzbe_stavke`(`id`, `narudzba_id`, `proizvod_id`, `kolicina`) VALUES(23, 12, 39, 14);
INSERT INTO `narudzbe_stavke`(`id`, `narudzba_id`, `proizvod_id`, `kolicina`) VALUES(24, 12, 54, 21);
INSERT INTO `narudzbe_stavke`(`id`, `narudzba_id`, `proizvod_id`, `kolicina`) VALUES(25, 13, 4, 34);
INSERT INTO `narudzbe_stavke`(`id`, `narudzba_id`, `proizvod_id`, `kolicina`) VALUES(26, 13, 2, 24);
INSERT INTO `narudzbe_stavke`(`id`, `narudzba_id`, `proizvod_id`, `kolicina`) VALUES(27, 14, 1, 25);
INSERT INTO `narudzbe_stavke`(`id`, `narudzba_id`, `proizvod_id`, `kolicina`) VALUES(28, 14, 13, 7);
INSERT INTO `narudzbe_stavke`(`id`, `narudzba_id`, `proizvod_id`, `kolicina`) VALUES(29, 15, 13, 21);
INSERT INTO `narudzbe_stavke`(`id`, `narudzba_id`, `proizvod_id`, `kolicina`) VALUES(30, 15, 16, 14);
INSERT INTO `narudzbe_stavke`(`id`, `narudzba_id`, `proizvod_id`, `kolicina`) VALUES(31, 16, 31, 21);
INSERT INTO `narudzbe_stavke`(`id`, `narudzba_id`, `proizvod_id`, `kolicina`) VALUES(32, 16, 36, 12);
INSERT INTO `narudzbe_stavke`(`id`, `narudzba_id`, `proizvod_id`, `kolicina`) VALUES(33, 17, 27, 31);
INSERT INTO `narudzbe_stavke`(`id`, `narudzba_id`, `proizvod_id`, `kolicina`) VALUES(34, 18, 60, 35);
INSERT INTO `narudzbe_stavke`(`id`, `narudzba_id`, `proizvod_id`, `kolicina`) VALUES(35, 18, 17, 47);
INSERT INTO `narudzbe_stavke`(`id`, `narudzba_id`, `proizvod_id`, `kolicina`) VALUES(36, 19, 14, 74);
INSERT INTO `narudzbe_stavke`(`id`, `narudzba_id`, `proizvod_id`, `kolicina`) VALUES(37, 19, 16, 28);
INSERT INTO `narudzbe_stavke`(`id`, `narudzba_id`, `proizvod_id`, `kolicina`) VALUES(38, 20, 13, 16);
INSERT INTO `narudzbe_stavke`(`id`, `narudzba_id`, `proizvod_id`, `kolicina`) VALUES(39, 21, 12, 13);
INSERT INTO `narudzbe_stavke`(`id`, `narudzba_id`, `proizvod_id`, `kolicina`) VALUES(40, 22, 31, 11);
INSERT INTO `narudzbe_stavke`(`id`, `narudzba_id`, `proizvod_id`, `kolicina`) VALUES(41, 23, 36, 20);
INSERT INTO `narudzbe_stavke`(`id`, `narudzba_id`, `proizvod_id`, `kolicina`) VALUES(42, 24, 14, 41);
INSERT INTO `narudzbe_stavke`(`id`, `narudzba_id`, `proizvod_id`, `kolicina`) VALUES(43, 24, 18, 84);
INSERT INTO `narudzbe_stavke`(`id`, `narudzba_id`, `proizvod_id`, `kolicina`) VALUES(44, 25, 19, 13);
INSERT INTO `narudzbe_stavke`(`id`, `narudzba_id`, `proizvod_id`, `kolicina`) VALUES(45, 26, 26, 64);
INSERT INTO `narudzbe_stavke`(`id`, `narudzba_id`, `proizvod_id`, `kolicina`) VALUES(46, 27, 7, 84);
INSERT INTO `narudzbe_stavke`(`id`, `narudzba_id`, `proizvod_id`, `kolicina`) VALUES(47, 27, 8, 17);
INSERT INTO `narudzbe_stavke`(`id`, `narudzba_id`, `proizvod_id`, `kolicina`) VALUES(48, 28, 10, 31);
INSERT INTO `narudzbe_stavke`(`id`, `narudzba_id`, `proizvod_id`, `kolicina`) VALUES(49, 28, 1, 11);
INSERT INTO `narudzbe_stavke`(`id`, `narudzba_id`, `proizvod_id`, `kolicina`) VALUES(50, 29, 16, 23);
INSERT INTO `narudzbe_stavke`(`id`, `narudzba_id`, `proizvod_id`, `kolicina`) VALUES(51, 29, 19, 54);
INSERT INTO `narudzbe_stavke`(`id`, `narudzba_id`, `proizvod_id`, `kolicina`) VALUES(52, 30, 37, 87);
INSERT INTO `narudzbe_stavke`(`id`, `narudzba_id`, `proizvod_id`, `kolicina`) VALUES(53, 30, 61, 87);

DROP VIEW IF EXISTS `aktualne_cijene_proizvoda`;
CREATE VIEW `aktualne_cijene_proizvoda` as 
SELECT 
  p.`id`, kp.`naziv` as `kategorija`, p.`naziv`, p.`jedinica`, p.`mjerna_jedinica`, 
  (SELECT `cijena` 
    FROM `cijene_proizvoda` as cp 
    WHERE cp.`proizvod_id` = p.`id` 
    ORDER BY cp.`datum_od` DESC LIMIT 1) as `cijena`,
  (SELECT `pdv` 
    FROM `cijene_proizvoda` as cp 
    WHERE cp.`proizvod_id` = p.`id` 
    ORDER BY cp.`datum_od` DESC LIMIT 1) as `pdv`
  FROM `proizvodi` as p
  LEFT JOIN `kategorije_proizvoda` as kp ON kp.`id` = p.`kategorija_proizvoda_id`;

-- kreiramo racune insert into select naredbom automatski racunajuci cijenu, pdv i ukupno pomocu unutarnjih upita

INSERT INTO `racuni`(`id`, `datum`, `prodavaonica_id`, `trgovacki_putnik_id`, `narudzba_id`, `cijena`, `pdv`, `ukupno`) 
SELECT 
  n.`id`, CURDATE() as `datum`, n.`prodavaonica_id`, n.`trgovacki_putnik_id`, n.`id` as `narudzba_id`, 
  (SELECT 
    SUM(ROUND(cp.`cijena` * ns.`kolicina`, 2)) as `cijena`
    FROM `narudzbe_stavke` as ns
    LEFT JOIN `aktualne_cijene_proizvoda` as cp ON cp.`id` = ns.`proizvod_id`
    WHERE n.`id` = ns.`narudzba_id`
    GROUP BY ns.`narudzba_id`) as `cijena`,
  (SELECT 
    SUM(ROUND(cp.`cijena` * ns.`kolicina` * cp.`pdv` / 100, 2)) as `pdv_iznos`
    FROM `narudzbe_stavke` as ns
    LEFT JOIN `aktualne_cijene_proizvoda` as cp ON cp.`id` = ns.`proizvod_id`
    WHERE n.`id` = ns.`narudzba_id`
    GROUP BY ns.`narudzba_id`) as `pdv`,
  (SELECT 
    SUM(ROUND(cp.`cijena` * ns.`kolicina` + cp.`cijena` * ns.`kolicina` * cp.`pdv` / 100, 2)) as `ukupno`
    FROM `narudzbe_stavke` as ns
    LEFT JOIN `aktualne_cijene_proizvoda` as cp ON cp.`id` = ns.`proizvod_id`
    WHERE n.`id` = ns.`narudzba_id`
    GROUP BY ns.`narudzba_id`)  as `ukupno`
  FROM `narudzbe` as n
  GROUP BY n.`id`;

INSERT INTO `racuni_stavke`(`racun_id`, `proizvod_id`, `kolicina`)
SELECT 
  (SELECT r.`id` as `id`
    FROM `racuni` as r 
    LEFT JOIN `narudzbe` as n ON n.id = r.`narudzba_id`
    WHERE n.`id` = r.`narudzba_id`
    AND ns.`narudzba_id` = n.`id`
    ) as `racun_id`,
    ns.`proizvod_id`,
    ns.`kolicina`
FROM `narudzbe_stavke` as ns;

DROP FUNCTION IF EXISTS `dohvati_cijenu_proizvoda`;
DELIMITER $$
CREATE FUNCTION `dohvati_cijenu_proizvoda` (pid INT, dt DATE) 
RETURNS DECIMAL(5,2)
READS SQL DATA
BEGIN
  DECLARE c DECIMAL(5,2);
  SET c = (SELECT `cijena` FROM `cijene_proizvoda` as cp WHERE cp.`datum_od` <= dt AND cp.`proizvod_id` = pid ORDER BY cp.`datum_od` DESC LIMIT 1);
  RETURN c;
END$$
DELIMITER ;

-- Ispis sadrzaja tablica
SELECT * FROM `racuni_stavke`;
SELECT * FROM `racuni`;
SELECT * FROM `narudzbe_stavke`;
SELECT * FROM `narudzbe`;
SELECT * FROM `automobili_prijedeni_put`;
SELECT * FROM `automobili`;
SELECT * FROM `prodavaonice`;
SELECT * FROM `trgovacki_putnici`;
SELECT * FROM `cijene_proizvoda`;
SELECT * FROM `proizvodi`;
SELECT * FROM `kategorije_proizvoda`;

-- slozeni upiti

DROP VIEW IF EXISTS `asortiman_proizvoda`;
CREATE VIEW `asortiman_proizvoda` AS
SELECT 
  p.`id`, kp.`naziv` as `kategorija`, p.`naziv` as `proizvod`, CONCAT(p.`jedinica`, p.`mjerna_jedinica`) as `masa`,
  (SELECT cp.`cijena`
    FROM `aktualne_cijene_proizvoda` as cp
    WHERE cp.`id` = p.`id`) as `cijena`,
  (SELECT ROUND(cp.`cijena` * cp.`pdv` / 100, 2)
    FROM `aktualne_cijene_proizvoda` as cp
    WHERE cp.`id` = p.`id`) as `pdv_iznos`,
  (SELECT ROUND(cp.`cijena` + cp.`cijena` * cp.`pdv` / 100, 2)
    FROM `aktualne_cijene_proizvoda` as cp
    WHERE cp.`id` = p.`id`) as `iznos`
FROM `proizvodi` as p
LEFT JOIN `kategorije_proizvoda` as kp ON kp.`id` = p.`kategorija_proizvoda_id`;

DROP VIEW IF EXISTS `kilometri_po_trgovackom_putniku`;
CREATE VIEW `kilometri_po_trgovackom_putniku` as 
SELECT 
  tp.`ime`, tp.`prezime`, tp.`oib`, a.`model`, SUM(app.`kraj_kilometri` - app.`pocetak_kilometri`) as `prijedjeni_put (km)`
  FROM `trgovacki_putnici` as tp
  LEFT JOIN `automobili_prijedeni_put` as app ON tp.`id` = app.`trgovacki_putnik_id`
  LEFT JOIN `automobili` as a ON a.`id` = app.`automobil_id`
  GROUP BY tp.`ime`, tp.`prezime`, tp.`oib`, a.`model`;

DROP VIEW IF EXISTS `promet_putnika`;
CREATE VIEW `promet_putnika` AS
SELECT  
  CONCAT(tp.`ime`, ' ', tp.`prezime`) as putnik, 
  SUM(r.`cijena`) as `netto promet`, 
  SUM(r.`ukupno`) as `brutto promet`
FROM `trgovacki_putnici` as tp
LEFT JOIN `racuni` as r ON r.`trgovacki_putnik_id` = tp.`id`
GROUP BY tp.`id`
ORDER BY `netto promet` DESC;

DROP VIEW IF EXISTS `promet_prodavaonica`;
CREATE VIEW `promet_prodavaonica` AS
SELECT  
  p.`id` as `Prodavaonica ID`, 
  p.`naziv`,
  CONCAT(p.`adresa`, ', ', p.`postanski_broj`, ' ', p.`grad`) as `adresa`,
  SUM(r.`cijena`) as `netto promet`, 
  SUM(r.`ukupno`) as `brutto promet`
FROM `prodavaonice` as p
LEFT JOIN `racuni` as r ON r.`prodavaonica_id` = p.`id`
GROUP BY p.`id`
ORDER BY `netto promet` DESC;

-- narudzbe po prodavaonici
DROP VIEW IF EXISTS `narudzbe_prodavaonica`;
CREATE VIEW `narudzbe_prodavaonica` AS
SELECT  
  p.`id` as `Prodavaonica ID`, 
  p.`naziv`,
  CONCAT(p.`adresa`, ', ', p.`postanski_broj`, ' ', p.`grad`)  as `adresa`,
  COUNT(n.`id`) as `broj_narudzbi`
FROM `prodavaonice` as p
LEFT JOIN `narudzbe` as n ON n.`prodavaonica_id` = p.`id`
GROUP BY p.`id`

DROP VIEW IF EXISTS `narudzbe_sa_stavkama`;
CREATE VIEW `narudzbe_sa_stavkama` AS
SELECT  
  p.`id` as `Prodavaonica ID`, 
  p.`naziv`,
  CONCAT(p.`adresa`, ', ', p.`postanski_broj`, ' ', p.`grad`)  as `adresa`,
  CONCAT(tp.`ime`, ' ', tp.`prezime`) as `putnik`,
  n.`datum` as `datum_narudzbe`,
  pr.`naziv` as `proizvod`,
  ns.`kolicina`
FROM `narudzbe` as n
LEFT JOIN `narudzbe_stavke` as ns ON n.`id` = ns.`narudzba_id`
LEFT JOIN `prodavaonice` as p ON p.`id` = n.`prodavaonica_id`
LEFT JOIN `trgovacki_putnici` as tp ON tp.`id` = n.`trgovacki_putnik_id`
LEFT JOIN `proizvodi` as pr ON pr.`id` = ns.`proizvod_id`;

DROP VIEW IF EXISTS `racuni_sa_stavkama`;
CREATE VIEW `racuni_sa_stavkama` AS
SELECT  
  p.`id` as `Prodavaonica ID`, 
  p.`naziv`,
  CONCAT(p.`adresa`, ', ', p.`postanski_broj`, ' ', p.`grad`)  as `adresa`,
  CONCAT(tp.`ime`, ' ', tp.`prezime`) as `putnik`,
  r.`datum` as `datum_racuna`,
  pr.`naziv` as `proizvod`,
  rs.`kolicina`,
  ROUND(dohvati_cijenu_proizvoda(pr.`id`, r.`datum`) * rs.`kolicina`, 2) as `iznos`
FROM `racuni` as r
LEFT JOIN `racuni_stavke` as rs ON r.`id` = rs.`racun_id`
LEFT JOIN `prodavaonice` as p ON p.`id` = r.`prodavaonica_id`
LEFT JOIN `trgovacki_putnici` as tp ON tp.`id` = r.`trgovacki_putnik_id`
LEFT JOIN `proizvodi` as pr ON pr.`id` = rs.`proizvod_id`;

DROP VIEW IF EXISTS `najprodavaniji_proizvodi`;
CREATE VIEW `najprodavaniji_proizvodi` AS
SELECT  
  pr.`id` as `Proizvod ID`,
  pr.`naziv` as `proizvod`,
  SUM(rs.`kolicina`) as `kolicina`
FROM `racuni_stavke` as rs
LEFT JOIN `proizvodi` as pr ON pr.`id` = rs.`proizvod_id`
GROUP BY pr.`id`, pr.`naziv`
ORDER BY `kolicina` DESC;

DROP VIEW IF EXISTS `najprodavaniji_proizvodi_putnik`;
CREATE VIEW `najprodavaniji_proizvodi_putnik` AS
SELECT  
  CONCAT(tp.`ime`, ' ', tp.`prezime`) as `putnik`,
  pr.`naziv` as `proizvod`,
  SUM(rs.`kolicina`) as `kolicina`
FROM `racuni` as r 
LEFT JOIN `trgovacki_putnici` as tp on tp.`id` = r.`trgovacki_putnik_id`
LEFT JOIN `racuni_stavke` as rs ON rs.`racun_id` = r.`id`
LEFT JOIN `proizvodi` as pr ON pr.`id` = rs.`proizvod_id`
GROUP BY tp.`id`, pr.`naziv`
ORDER BY `kolicina` DESC;

-- ispis slozenih upita (kreiranih putem view-ova)
SELECT * FROM `aktualne_cijene_proizvoda`;
SELECT * FROM `kilometri_po_trgovackom_putniku`;
SELECT * FROM `asortiman_proizvoda`;
SELECT * FROM `promet_putnika`;
SELECT * FROM `promet_prodavaonica`;
SELECT * FROM `narudzbe_prodavaonica`;
SELECT * FROM `narudzbe_sa_stavkama`;
SELECT * FROM `racuni_sa_stavkama`;
SELECT * FROM `najprodavaniji_proizvodi`;
SELECT * FROM `najprodavaniji_proizvodi_putnik`;

