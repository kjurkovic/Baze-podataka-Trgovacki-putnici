
CREATE DATABASE `Dukat_dd` DEFAULT CHARACTER SET = `utf8` DEFAULT COLLATE = `utf8_bin`;
USE `Dukat_dd`;

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
  `cijena` double DEFAULT NULL,
  `pdv` double DEFAULT NULL,
  `ukupno` double DEFAULT NULL,
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
  `oib` int DEFAULT NULL,
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
  CONSTRAINT `narudzba_proizvod_fk` FOREIGN KEY (`id`) REFERENCES `proizvodi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `narudzba_stavka_fk` FOREIGN KEY (`narudzba_id`) REFERENCES `narudzbe` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `racuni` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `datum` date DEFAULT NULL,
  `prodavaonica_id` int unsigned DEFAULT NULL,
  `trgovacki_putnik_id` int unsigned DEFAULT NULL,
  `narudzba_id` int unsigned DEFAULT NULL,
  `cijena` double default 0,
  `pdv` double default 0,
  `ukupno` double default 0,
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
  CONSTRAINT `racun_proizvod_fk` FOREIGN KEY (`id`) REFERENCES `proizvodi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `racun_stavka_fk` FOREIGN KEY (`racun_id`) REFERENCES `racuni` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
