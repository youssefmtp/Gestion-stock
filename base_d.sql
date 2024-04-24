-- Base de données pour le site Ecommerce
-- SGBD MariaDB
-- Script de création ou de restauration
-- 2SIO v2023 Y. ENNOUR
-- Création de la base si elle n'existe pas
CREATE DATABASE IF NOT EXISTS `base_gestion_stock` /*!40100 DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci */;
USE `base_gestion_stock`;
-- Suppression des tables si elles existent

DROP TABLE IF EXISTS `categorie`;
DROP TABLE IF EXISTS `sous_categorie`;
DROP TABLE IF EXISTS `role`;
DROP TABLE IF EXISTS `produit`;
DROP TABLE IF EXISTS `utilisateur`;
DROP TABLE IF EXISTS `transporteur`;
DROP TABLE IF EXISTS `commande`;
DROP TABLE IF EXISTS `detail_commande`;
DROP TABLE IF EXISTS `fournisseur`;
DROP TABLE IF EXISTS `demande`;
DROP TABLE IF EXISTS `avis`;
DROP TABLE IF EXISTS `statut`;
DROP TABLE IF EXISTS `changement_statut`;


--
-- création des tables
--

CREATE TABLE IF NOT EXISTS `categorie` (
  `id` integer NOT NULL AUTO_INCREMENT,
  `nom` varchar(60),
  CONSTRAINT `pk_categorie` PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE IF NOT EXISTS `sous_categorie` (
  `id` integer NOT NULL AUTO_INCREMENT,
  `libelle` varchar(60),
  `idCateg` integer NOT NULL,
  CONSTRAINT `pk_sous_categorie` PRIMARY KEY (`id`),
  FOREIGN KEY (`idCateg`) REFERENCES `categorie`(`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE IF NOT EXISTS `role` (
  `id` integer NOT NULL AUTO_INCREMENT,
  `libelle` varchar(60),
  CONSTRAINT `pk_role` PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE IF NOT EXISTS `produit` (
  `id` integer NOT NULL AUTO_INCREMENT,
  `refProd` varchar(60),
  `marque` varchar(30),
  `libelle` varchar(80),
  `resume` varchar(260),
  `description` varchar(556),
  `photoProd` varchar(128),
  `qteEnStock` integer,
  `prix` decimal(10,2),
  `seuilAlerte` integer,
  `idSousCateg` integer NOT NULL,
  CONSTRAINT `pk_produit` PRIMARY KEY (`id`),
  FOREIGN KEY (`idSousCateg`) REFERENCES `sous_categorie`(`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE IF NOT EXISTS `utilisateur` (
  `id` integer  NOT NULL AUTO_INCREMENT,
  `nom` varchar(20) NOT NULL,
  `prenom` varchar(20) NOT NULL,
  `genre` char(5),
  `dateNaissance` date,
  `mail` varchar(80) NOT NULL,
  `telephone` integer,
  `adresse` varchar(200),
  `cp` char(5),
  `ville` varchar(30),
  `mdp` varchar(60),
  `idRole` integer NOT NULL,
  CONSTRAINT `pk_utilisateur` PRIMARY KEY (`id`),
  FOREIGN KEY (`idRole`) REFERENCES `role`(`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


CREATE TABLE IF NOT EXISTS `transporteur` (
  `id` integer NOT NULL AUTO_INCREMENT,
  `nom` varchar(60),
  `ad` varchar(200),
  `cp` char(5),
  `ville` varchar(30),
  `telephone` char(10),
  CONSTRAINT `pk_transporteur` PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE IF NOT EXISTS `commande` (
  `ref` integer NOT NULL AUTO_INCREMENT,
  `adLivraison` varchar(200),
  `cpLivraison` char(5),
  `villeLivraison` varchar(30),
  `idClient` integer NOT NULL,
  `idTransporteur` integer NOT NULL,
  CONSTRAINT `pk_commande` PRIMARY KEY (`ref`),
  FOREIGN KEY (`idClient`) REFERENCES `utilisateur`(`id`),
  FOREIGN KEY (`idTransporteur`) REFERENCES `transporteur`(`id`)  
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE IF NOT EXISTS `detail_commande` (
  `refCommande` integer NOT NULL,
  `idProduit` integer NOT NULL,
  `quantite` integer NOT NULL,
  CONSTRAINT `pk_detail_commande` PRIMARY KEY (`refCommande`, `idProduit`), 
  FOREIGN KEY (`refCommande`) REFERENCES `commande`(`ref`),
  FOREIGN KEY (`idProduit`) REFERENCES `produit`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE IF NOT EXISTS `fournisseur` (
  `id` integer NOT NULL AUTO_INCREMENT,
  `nom` varchar(60),
  `ad` varchar(200),
  `cp` char(5),
  `ville` varchar(30),
  `telephone` char(10),
  CONSTRAINT `pk_fournisseur` PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE IF NOT EXISTS `demande` (
  `id` integer NOT NULL AUTO_INCREMENT,
  `qte` integer,
  `dateDemande` datetime,
  `dateLivraison` date,
  `idFournisseur` integer NOT NULL,
  `idProduit` integer NOT NULL,
  CONSTRAINT `pk_demande` PRIMARY KEY (`id`),
  FOREIGN KEY (`idFournisseur`) REFERENCES `fournisseur`(`id`),
  FOREIGN KEY (`idProduit`) REFERENCES `produit`(`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE IF NOT EXISTS `avis` (
  `id` integer NOT NULL AUTO_INCREMENT,
  `description` varchar(500),
  `estFavorie` boolean,
  `nbEtoiles` integer,
  `dateAvis` date,
  `idClient` integer NOT NULL,
  `idProduit` integer NOT NULL,
  CONSTRAINT `pk_avis` PRIMARY KEY (`id`),
  FOREIGN KEY (`idClient`) REFERENCES `utilisateur`(`id`),
  FOREIGN KEY (`idProduit`) REFERENCES `produit`(`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE IF NOT EXISTS `statut` (
  `id` integer NOT NULL AUTO_INCREMENT,
  `libelle` varchar(60),
  CONSTRAINT `pk_statut` PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE IF NOT EXISTS `changement_statut` (
  `idStatut` integer NOT NULL,
  `refCommande` integer NOT NULL,
  `dateChangement` datetime,
  CONSTRAINT `pk_statut_commande` PRIMARY KEY (`idStatut`, `refCommande`),
  FOREIGN KEY (`idStatut`) REFERENCES `statut`(`id`),
  FOREIGN KEY (`refCommande`) REFERENCES `commande`(`ref`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;





--
-- insertion des enregistrements pour la table catégorie
--
INSERT INTO `categorie` (`nom`) VALUES
('Huiles'),
('Rasoirs'),
('Accessoires');

--
-- insertion des enregistrements pour la table sous-catégorie
--
INSERT INTO `sous_categorie` (`libelle`, `idCateg`) VALUES
('Huiles Pousse Barbe', 1), 
('Huiles Adoucissante', 1), 
('Huiles Enrichissante', 1), 

('Rasoirs à lame', 2), 
('Rasoirs éléctriques', 2), 


('Brosses', 3), 
('Beard Roller', 3), 
('Lames', 3), 
('Blaireaux', 3), 
('Allumettes hémostatiques', 3), 
('Crème', 3), 
('Baumes', 3); 


--
-- insertion des enregistrements pour la table role
--
INSERT INTO `role` (`libelle`) VALUES
('admin'),
('utilisateur'),
('transporteur'),
('fournisseur');


--
-- insertion des enregistrements pour la table produit
--
INSERT INTO `produit` (`marque`,`refProd`, `libelle`, `resume`, `description`, `photoProd`, `qteEnStock`, `prix`, `seuilAlerte`, `idSousCateg`) 
VALUES
('MaxBarber', 'maxbarber-huile1', 'Croissance de la barbe', "Notre produit n'est pas une huile à barbe ordinaire, mais un traitement innovant à base de principes actifs d’orgines 100% naturels qui agissent efficacement pour stimuler la croissance de votre barbe.",
"Notre produit n'est pas une huile à barbe ordinaire, mais un traitement innovant à base de principes actifs d’orgines 
100% naturels qui agissent efficacement pour stimuler la croissance de votre barbe. Avec sa texture unique et ses 30 
ml de formule puissante, vous pourrez constater une barbe renforcée, plus dense et revitalisée grâce à la création de 
nouveaux bulbes. ",
'huile2.png', 20, 29.90, 5, 1),

('BeardRoller', 'beardroller-rl1', 'Rouleau pousse barbe', "Des recherches ont démontré que certains types de cellules immunitaires, les macrophages, sont actives dans la stimulation des cellules de peau responsables de la production de cheveux et poils.",
"Des recherches ont démontré que certains types de cellules immunitaires, les macrophages, sont actives 
dans la stimulation des cellules de peau responsables de la production de cheveux et poils. Cette découverte 
permet de nouvelles stratégies comme le Beard-Roller pour booster la création de nouveaux follicules pileux et 
obtenir une barbe plus forte et plus dense.  ",
'poussebarbe2.png', 12, 31.90, 10, 7),

("O'barber", 'obarber-brosse1', 'Brosse pour barbe', "Brosse à barbe et moustache O'barber.",
"Brosse à barbe et moustache O'barber.
Fabriqué en bois et en poils de sanglier cet accessoire permet de déméler et discipliner votre barbe ou votre moustache.
Ses dimensions : 8 cm x 4 cm x 4 cm lui offre une prise en main facile pour une utilisation quotidienne. ",
'brosseobarber.jpg', 5, 9.90, 5, 6),

("O'barber", 'obarber-rasoir1', 'Rasoir avec lame interchangeable', "Rasoir à lames interchangeables",
"Porte lame en acier inoxydable recouvert de titane
Manche plastique
Vendu sans lames  ",
'rasoir.jpg', 4, 24.90, 5, 4),

("Giorgio Armani",  'armani-baume1', 'Baume apres-rasage', "La puissance masculine dans un parfum frais et aquatique. C'est le rivage aride et secret de l'île de Pantelleria, où Giorgio Armani aime se ressourcer, qui a inspiré ce parfum.",
"La puissance masculine dans un parfum frais et aquatique. C'est le rivage aride et secret de l'île de Pantelleria, où Giorgio Armani 
aime se ressourcer, qui a inspiré ce parfum. Ce baume est conçu pour un usage quotidien. Testé dermatologiquement, il convient à tous 
les types de peaux, même les plus sensibles. Ce dernier nourrit en profondeur et hydrate l’épiderme. Il le rend plus lisse et aide à 
lutter contre les irritations ou les microcoupures pouvant provoquer des infections ou des démangeaisons.",
'baumearmani1.png', 16, 41.50, 12, 12),

("NeoFollics",  'neofollics-beardroller1', 'Rouleau pousse barbe qui améliore la croissance de la barbe', "Le Neofollics Beard Roller est le rouleau à barbe le plus avancé qui active et stimule la croissance de la barbe de plusieurs manières. Le rouleau ergonomique comporte 540 aiguilles microscopiques de 0,5 mm qui pénètrent sans douleur dans la surface supérieure de la peau. ",
"Le Neofollics Beard Roller est le rouleau à barbe le plus avancé qui active et stimule la croissance de la barbe de plusieurs 
manières. Le rouleau ergonomique comporte 540 aiguilles microscopiques de 0,5 mm qui pénètrent sans douleur dans la surface supérieure
 de la peau. Il crée des trous microscopiques dans la peau au niveau de la barbe, ce qui améliore l'absorption du sérum à barbe. 
 Le Neofollics Beard Roller convient à tout homme (18 ans et plus) qui souhaite stimuler la 
 croissance de la barbe, activer de nouveaux poils de barbe, avoir une barbe plus fournie et améliorer l'état de la peau du visage.",
'beardrollerneofollics.png', 22, 19.95, 10, 7),

("Face Theory",  'facetheory-huile1', 'Huile de Barbe L15 Finition Satinée ', "L’Huile de Barbe L15 contrôle les frisottis de barbe et de poils avec une finition sèche et non grasse. Peut également être utilisée comme sérum de soin pour les cheveux.",
"L’Huile de Barbe L15 contrôle les frisottis de barbe et de poils avec une finition sèche et non grasse. Peut également être utilisée
comme sérum de soin pour les cheveux.
 
Respectueuse de l'environnement et entièrement biodégradable. Formulé avec Emogreen, un substitut de silicone ultramoderne issu 
d'extraits de plantes.", 'huilefacetheory.png', 20, 13, 5, 3),

('Philips', 'phillips-rasoirelec2', 'OneBlade pour le Visage et le Corps, Taillez, Stylisez et Rasez, Lame Originale, Peigne Réglable 5 en 1', 
"Obtenez la barbe que vous souhaitez et rasez vos poils à la longueur désirée grâce au peigne réglable 5 en 1, sans obstruction, même sur les poils longs et épais.", 
"La Philips OneBlade ne rase pas d'aussi près qu'une lame traditionnelle, ce qui garantit un rasage confortable, quelle que soit la longueur des poils du corps ou de la barbe.", 
'rasoirphilips2.png', 15, 44.20, 10, 5),



("Nocibé MEN",  'nocibe-baume1', 'Baume après-rasage homme', "Les soins de peau ne sont pas exclusivement réservés aux femmes ! Vous aussi, messieurs, vous avez le droit de vous faire plaisir et de prendre soin de vous.",
"Les soins de peau ne sont pas exclusivement réservés aux femmes ! Vous aussi, messieurs, vous avez le droit de vous faire plaisir et 
de prendre soin de vous. Le Baume Après Rasage associe des actifs apaisants qui atténuent les irritations causées par le rasage. 
Sa formule au ginseng nourrit et adoucit la peau, et procure une sensation de confort tout au long de la journée.",
'baumenocibe1.png', 18, 18.95, 10, 12),

("Horace",  'horace-brosse1', 'Brosse à barbe', "Libérez votre barbe de l'accumulation quotidienne et lissez les nœuds avec cette brosse à barbe de conception allemande et végétalienne.", "Libérez votre barbe de l'accumulation quotidienne et lissez les nœuds avec 
cette brosse à barbe de conception allemande et végétalienne. De la taille d'une paume et facile à manœuvrer, la brosse à barbe Horace 
encourage les huiles naturelles de votre barbe à se répartir uniformément tout au long de la croissance pour une meilleure condition. 
Les nœuds et les débris sont montrés à la porte de sortie et votre feuillage facial est laissé en parfait état après utilisation.",
'brossehorace1.png', 2, 18, 5, 6),

("L'Occitane",  'occitane-blaireau1', 'Blaireau pur blaireau ', "Ce blaireau de rasage permet de préparer la peau au rasage et d'appliquer son savon ou sa crème de rasage sur le visage.",
"Ce blaireau de rasage permet de préparer la peau au rasage et d'appliquer son savon ou sa crème de rasage sur 
le visage.",
'blaireauloccitane1.png', 5, 30.00, 10, 9), 

("Osma",  'osma-allumette1', '20 Allumettes Hémostatiques', "Allumettes anti-saignement post rasage",
"Allumettes anti-saignement post rasage. Les Allumettes Hémostatiques Osma permettent d'arrêter les petits saignements et micro-coupures
post-rasage. Aide à cicatriser et apaiser les petites coupures au bout de quelques secondes.
Pochette de 20 allumettes.
Fabriqué en France.",
'allumetteosma1.png', 10, 1.60, 5, 10),

("Nivea Men",  'niveamen-creme1', 'Crème à raser douce', "Crème à raser pour homme.",
"Crème à raser pour homme. Pour tous types de peaux", 'cremenivea1.png', 20, 6.99, 5, 11),


("O'barber",  'obarber-brosse2', 'Brosse pour barbe', "Brosse à barbe et moustache O'barber. ",
"Brosse à barbe et moustache O'barber.
Fabriqué en bois et en poils de sanglier cet accessoire permet de déméler et discipliner votre barbe ou votre moustache.
Ses dimensions : 8 cm x 4 cm x 4 cm lui offre une prise en main facile pour une utilisation quotidienne. ",
'brossebarbemoustache.jpg', 15, 10.90, 5, 6),

('Sephora', 'sephora-huile1', 'Huile barbe douce Hydrate + Assouplit', "Formulée avec 97% d'ingrédients d'origine naturelle, cette huile hydrate la peau et assouplit la barbe pour qu'elle soit plus belle au quotidien.",
"Formulée avec 97% d'ingrédients d'origine naturelle, cette huile hydrate la peau et assouplit la barbe pour qu'elle 
soit plus belle au quotidien.
Une combinaison d'huile de Moringa et un extrait de Romarin, dans une formule qui pénètre rapidement pour hydrater 
la peau et assouplir la barbe. Nourrie, votre barbe est plus belle et plus douce au toucher. Le Romarin est connu 
pour apaiser la peau.",
'huilesephora.png', 5, 11.90, 5, 2),


("O'barber",  'obarber-blaireau1', 'Blaireau pur blaireau ', "Ce blaireau de rasage permet de préparer la peau au rasage et d'appliquer son savon ou sa crème de rasage sur le visage.",
"Ce blaireau de rasage permet de préparer la peau au rasage et d'appliquer son savon ou sa crème de rasage sur 
le visage. Ce pinceau O'barber avec son manche en plastique est fabriqué en poils pur blaireau. 
Il permet de créer une mousse homogène et dense. Ses poils extrèmement doux apportant une agréable sensation de 
douceur à votre peau. ",
'blaireaupur.jpg', 10, 30.00, 5, 9),


('Barbier',  'barbier-creme1', 'Crème de rasage', "Voici la solution idéale pour un rasage super onctueux des peaux sensibles, tout en douceur et en précision.",
"Voici la solution idéale pour un rasage super onctueux des peaux sensibles, tout en douceur et en précision, 
avec votre crème à raser concentrée Better-Shave à l'arnica, au cyprès et au gingembre pour faire de votre rasage 
un soin visage à part entière.",
'moussearaser.png', 12, 9.90, 10, 11),

('Lincoln ',  'lincoln-huile1', 'Huile pour barbe enrichit', "Notre huile pour barbe homme est un mélange d'huiles végétales et naturelles reconnues pour leurs bienfaits hydratants et nourrissants.",
"Notre huile pour barbe homme est un mélange d'huiles végétales et naturelles reconnues pour leurs 
bienfaits hydratants et nourrissants. Enrichie entre autre en huile d'amande douce, cette huile pour la barbe 
est un indispensable pour les hommes. ",
'huilejaune.png', 4, 16.99, 5, 3),

("O'barber",  'obarber-baumeapresrasage-1', 'Baume après rasage', "Baume après rasage, apaise rafraichit et adoucit la peau Texture fluide et légère.",
"Baume après rasage, apaise rafraichit et adoucit la peau Texture fluide et légère Appliquer après le rasage sur le 
visage et le cou ",
'baumeapresrasage.jpg', 20, 4.90, 5, 12),


("O'barber",  'obarber-alummette-1', 'Pochette de 20 allumettes hémostatiques spéciale rasage', "Pochette contenant 20 bâtonnets hémostatiques permettant d'arrêter les petits saignements des coupures.",
"Pochette contenant 20 bâtonnets hémostatiques permettant d'arrêter les petits saignements des coupures, 
suite au rasage.",
'pochetteallumetteshemostatiquerasage.jpg', 21, 2.00, 5, 10),

("O'barber",  'obarber-lames2', 'Lames de rasoir longues par 20', "Fabriquées en alliage de cobalt.",
"Fabriquées en alliage de cobalt. Boite de 20 lames.", 'lamesrasoirbarbier.jpg', 20, 4.90, 5, 8),

("Horace",  'horace-huile1', 'Huile pour Barbe Patchouli & Cèdre', "Utilisée au quotidien, cette huile pour barbe d'origine naturelle",
"Utilisée au quotidien, cette huile pour barbe d'origine naturelle sans huile minérale, nourrit et adoucit votre barbe, sans aucune 
sensation de gras. Son parfum est une invitation à une belle et longue marche en forêt.",
'huilehorace2.png', 19, 13, 5, 1),

("Pop Modern",  'popmodern-huile1', 'Huile De Croissance De Barbe', "BOOSTE LA CROISSANCE DE LA BARBE: Notre formule d'huile de croissance de barbe soigneusement formulée fournit les vitamines et les nutriments nécessaires à la croissance de la barbe. ",
"BOOSTE LA CROISSANCE DE LA BARBE: Notre formule d'huile de croissance de barbe soigneusement formulée fournit les vitamines 
et les nutriments nécessaires à la croissance de la barbe. Améliore la santé de la barbe, renforce les racines des cheveux et 
favorise une croissance rapide de la barbe. Gardez votre barbe plus longue, épaisse et saine.",
'huilepopmodern.png', 10, 16.99, 5, 1),



("Red-Blooded",  'redblooded-beardroller1', 'Rouleau pour la pousse de la barbe', "Notre rouleau de croissance de barbe aidera à promouvoir une barbe beaucoup plus saine et plus épaisse !",
"Notre rouleau de croissance de barbe aidera à promouvoir une barbe beaucoup plus saine et plus épaisse ! Elle fonctionne en attirant 
du sang riche en hormones et en nutriments dans la zone. ",
'beardrollerredblooded.png', 23, 14.99, 10, 7),



("Parker",  'parker-rasoirlame&', 'Rasoir à lame interchangeable', "Simple à utiliser, elle se compose d'un manche et d'un porte-lame dans lequel on insère une demi-lame jetable.", "Plus simple à utiliser, elle se compose d'un manche et d'un porte-lame dans lequel on 
insère une demi-lame jetable. Son manche de 14,5 cm assure une bonne maniabilité, et sa matière en inox lui confère un poids fiable 
lors de l'utilisation ainsi qu'une excellente durabilité.", 'rasoirparker1.png', 10, 20, 5, 4),



("Camden",  'camden-huile1', 'Huile à Barbe', "POUR UNE BARBE SOIGNEE ET TELLEMENT DOUCE AU TOUCHER : Notre huile à barbe rafraîchit les poils secs, les rend souples et doux et rehausse l’éclat de votre barbe, tout en lui donnant un parfum frais et masculin.",
"POUR UNE BARBE SOIGNéE ET TELLEMENT DOUCE AU TOUCHER : Notre huile à barbe rafraîchit les poils secs, 
les rend souples et doux et rehausse l’éclat de votre barbe, tout en lui donnant un parfum frais et masculin. 
Elle lutte par ailleurs contre les démangeaisons et desquamations désagréables.", 'huilecamden1.png', 12, 15.99, 5, 2),

("Au Poil",  'aupoil-huile1', 'L''Huile Nourrissante', "Elle rend la barbe plus douce et plus soyeuse.",
"Elle rend la barbe plus douce et plus soyeuse. Elle nourrit et protège les poils (et les pointes de cheveux). En plus, elle est 
composée de 99 % d'ingrédients d'origine naturelle (huile de sésame, huile d'amande douce).", 
'huileaupoil.png', 20, 9.50, 5, 2),

("LMDB",  'lmdb-creme1', 'Crème de rasage bio', "Crème à raser pour homme.",
"Crème à raser pour homme. Pour tous types de peaux",
'cremelmdb1.png', 22, 9.19, 10, 11),

('Philips', 'phillips-rasoirelec1', 'Rasoir électrique', "Rasage de près pratique et sans effort ",
"Rasage de près pratique et sans effort
Efficacité: lames auto-affûtées pour un rasage de près (système powercut)
Confort: têtes flexibles dans 4 directions pour un suivi optimal des contours du visage
Autonomie: 45 minutes d’autonomie pour une heure de charge. Charge rapide en 5 minutes pour un rasage complet. Utilisable aussi sur secteur
Accessoires: tondeuse rétractable (pour entretenir votre moustache et tailler vos pattes) et capot de protection ",
'rasoirelec.png', 23, 49.90, 15, 5),



("O'barber", 'obarber-rasoir2', 'Rasoir avec lame interchangeable', "Rasoir à lames interchangeables ",
"Rasoir à lames interchangeables
Porte lame en acier inoxydable recouvert de titane
Manche en bois
Vendu avec une boite de 5 lames  ",
'rasoirbois.jpg', 25, 34.90, 5, 4),

("O'barber",  'obarber-lames1', 'Boîte de 5 lames', "Ses lames de rasoir sont en alliage de cobalt pour un rasage de qualité.",
"Ses lames de rasoir sont en alliage de cobalt pour un rasage de qualité.
Boite de 5 lames  ",
'boitecinqlame.jpg', 18, 1.20, 10, 8),


("The Shave Factory", 'theShaveFactory-brosse1', 'Brosse à barbe', "Cette grande brosse est idéale pour le soin et le coiffage des barbes longues. Un brossage quotidien de votre barbe permet d'éliminer les peaux mortes et améliorer la pousse du poil.",
"Cette grande brosse est idéale pour le soin et le coiffage des barbes longues.
Un brossage quotidien de votre barbe permet d'éliminer les peaux mortes et améliorer la pousse du poil.
Le manche en bois, 100% naturel, s'adapte parfaitement à votre main. ",
'brosse.jpg', 20, 8.90, 5, 6);

--
-- insertion des enregistrements pour la table utilisateur
--


INSERT INTO `utilisateur` (`nom`, `prenom`, `genre` , `dateNaissance` , `mail`, `telephone`, `adresse`, `cp`, `ville`, `mdp`, `idRole`) VALUES
('ADMIN', 'Admin', 'Homme', '2000-01-01', 'admin@gmail.com', '0600000000','717 Av. Jean Mermoz', '34000', 'Montpellier' , 'azerty34', 1),
('ZIDANE', 'Zinedine', 'Homme', '1972-06-23', 'zizou13@gmail.com', '0600000001','12 place de la canebiere', '13020', 'Marseille' , 'azerty34', 2), 
('MARIO', 'Balotteli', 'Homme', '1990-08-12' , 'marioitalia@gmail.com', '0600000102','Avenue de l europe', '34000', 'Montpellier', 'azerty34', 2), 
('DI MANSINI', 'Leornardo', 'Homme', '2000-02-19', 'leo.dimansini@gmail.com', '0600000003','3 place d Italie', '06001', 'Nice' , 'azerty34', 2), 
('LUIZ', 'David', 'Homme', '1988-09-20', 'luiz@gmail.com', '0600000004','4 rue brasilia', '75000', 'Paris' , 'azerty34', 2), 
('JR', 'Neymar', 'Homme', '1999-12-22', 'neymarjr@gmail.com', '0600000005','Avenue des champs élysée', '75001', 'Paris' , 'azerty34', 2), 
('PEREZ', 'Rodri', 'Homme', '2001-04-29', 'rodri16@gmail.com', '0600000006','98 rue louis labo', '69000', 'Lyon' , 'azerty34', 2), 
('INIESTA', 'Andres', 'Homme', '1980-03-11', 'iniesta8@gmail.com', '0600000007','12 rue saint-jacques', '66000', 'Perpignan' , 'azerty34', 2),
('Menvussat', 'Gérard', 'Homme', '2000-01-01', 'gerard@gmail.com', '0600000000','717 Av. Jean Mermoz', '34000', 'Montpellier' , 'azerty34', 1);

--
-- insertion des enregistrements pour la table transporteur
--
INSERT INTO `transporteur` (`nom`, `ad`, `cp`, `ville`, `telephone`) VALUES
('Mondial Relay', '1 avenue de l''horizon', '59650', 'VILLENEUVE D''ASCQ', '0969322332'), 
('La Poste', '430 Rue Henri Farman', '34430 ', 'Saint-Jean-de-Védas', '0970823631'),  
('Chronopost', '1129 Rue de la Castelle', '34070 ', 'Montpellier', '0969391391'),
('DPD', '2 Rue du Salaison', '34130', 'Mauguio', '0970808566'),   
('UPS', 'Avenue Margot Duhalde', '34130', 'Mauguio', '0430001991');  


--
-- insertion des enregistrements pour la table commande
--
INSERT INTO `commande` (`idClient`, `idTransporteur`, `adLivraison`, `cpLivraison`, `villeLivraison`) VALUES
('2', '1', 'Rue Mohamed V', '34080', 'Montpellier'),
('3', '2', '82 Rue du Faubourg Figuerolles', '34070', 'Montpellier'),
('2', '3', 'Rue Mohamed V', '34080', 'Montpellier'),
('4', '4', '16 Rue de l''Éolienne', '34830', 'Clapiers'),
('5', '5', '200 Av. de l''Europe', '34170', 'Castelnau-le-Lez'),
('2', '1', 'Rue Mohamed V', '34080', 'Montpellier'),
('6', '2', '9 Rue des Aramons', '34990', 'Juvignac'),
('7', '3', '21 Rue de la Poésie', '34090', 'Montpellier');  


--
-- insertion des enregistrements pour la table detail_commande
--

INSERT INTO `detail_commande` (`refCommande`, `idProduit`, `quantite`) VALUES
('1', '2', '3'), ('1', '4', '2'), ('2', '4', '1'), ('2', '14', '2'),
('3', '4', '3'), ('3', '10', '5'), ('4', '4', '3'), ('4', '12', '1'), 
('5', '9', '2'), ('6', '17', '3'), ('6', '16', '2'), ('7', '1', '1'),
('7', '2', '1'); 


--
-- insertion des enregistrements pour la table fournisseur
--
INSERT INTO `fournisseur` (`nom`, `ad`, `cp`, `ville`, `telephone`) VALUES
('O''barber', '430 Rue Henri Farman', '34430 ', 'Saint-Jean-de-Védas', '0900000000'), 
('Sephora', '69 rue du Faubourg National', '45000', 'Orléans', '0900000001'),  
('Grossite-En-Coiffure', '69 rue du Faubourg National', '94320', 'Thiais', '0900000002'),
('Europages', '43 boulevard de la Liberation', '13002', 'Marseille', '0900000003'),   
('La beauté Française', '64 Rue de Verdun', '35000', 'Rennes', '0900000004'); 


--
-- insertion des enregistrements pour la table demande
--
INSERT INTO `demande` (`qte`, `dateDemande`, `dateLivraison`, `idFournisseur`, `idProduit`) VALUES
('10', '2023-01-01', '2023-01-04', '1', '1'), 
('15', '2023-03-11', '2023-03-14', '1', '2'),
('5', '2023-08-19', '2023-08-22', '2', '6'), 
('8', '2023-10-22', '2023-10-25', '3', '7'),
('5', '2023-11-09', '2023-11-12', '4', '11'),
('25', '2023-11-10', '2023-11-13', '5', '12');
 

--
-- insertion des enregistrements pour la table avis
--
INSERT INTO `avis` (`description`, `estFavorie`, `nbEtoiles`, `dateAvis`, `idClient`, `idProduit`) VALUES
('J''adore ce produit! Il répond totalement à mes attentes. Facile à utiliser, très efficace, je le recommande vivement!',
 'true', 5, '2023-01-04', '2', '1'), 
('Un excellent rapport qualité-prix! Le produit est robuste et bien conçu. J''ai été agréablement surpris par sa performance.',
 'false', 4, '2023-01-05', '3', '1'),
 ('Pas mal, mais peut-être améliorable. J''apprécie certaines fonctionnalités, mais il y a place à l''amélioration. Dans l''ensemble, 
 satisfait.', 'false', 3, '2023-02-11', '4', '1'),
 ('Exceptionnel! Je ne peux pas me passer de ce produit. Il a considérablement amélioré mon quotidien. Cinq étoiles bien méritées!',
 'false', 5, '2023-10-10', '2', '6'),
 ('Déçu. Le produit ne correspondait pas à mes attentes. J''espérais mieux pour le prix. Je ne le recommande pas.',
 'true', 1, '2023-10-13', '4', '32');


--
-- insertion des enregistrements pour la table statut
--
INSERT INTO `statut` (`libelle`) VALUES
('En cours de préparation'),
('En attente d''expédition'),
('Expédiée'),
('En cours de livraison'),
('Livrée'),
('Annulé');


--
-- insertion des enregistrements pour la table changement_statut
--
INSERT INTO `changement_statut` (`idStatut`, `refCommande`, `dateChangement`) VALUES
('1', '1', '2023-02-12 21:00'),
('2', '1', '2023-02-13 8:00'),
('3', '1', '2023-02-13 15:00'),
('4', '1', '2023-02-15 7:50'),
('5', '1', '2023-02-15 11:12'),

('1', '2', '2023-02-13 8:00'),
('2', '2', '2023-02-14 10:12'),
('3', '2', '2023-02-14 18:00'),
('4', '2', '2023-02-16 8:00'),
('5', '2', '2023-02-16 8:10'),

('1', '3', '2023-02-15 01:12'),
('2', '3', '2023-02-16 17:00'),
('3', '3', '2023-02-16 18:00'),
('4', '3', '2023-02-18 07:42'),
('5', '3', '2023-02-18 15:11'),

('1', '4', '2023-02-20 14:29'),

('1', '5', '2023-02-23 05:06'),
('2', '5', '2023-02-24 07:12'),
('3', '5', '2023-02-24 10:00'),


('1', '6', '2023-02-24 11:00'),
('2', '6', '2023-02-25 12:00'),
('3', '6', '2023-02-25 15:00'),
('4', '6', '2023-02-27 08:01'),


('1', '7', '2023-03-02 16:01'),
('2', '7', '2023-03-03 9:00'),

('1', '8', '2023-03-03 16:00'),
('2', '8', '2023-03-04 7:52'),
('3', '8', '2023-03-04 10:00');