<?php
header ("Cache-Control: no-cache, must-revalidate");
header ("pragma: no-cache");

try
{			
	$pdo_options[PDO::ATTR_ERRMODE] = PDO::ERRMODE_EXCEPTION;
	$bdd = new PDO('mysql:host=127.0.0.1:3307;dbname=base_gestion_stock', 'root', '');
	$bdd->query("SET NAMES utf8");                  

	if ($_SERVER['REQUEST_METHOD'] == 'GET')
	{
		switch($_GET['data']){

			case 'lesProduits':
				$req = $bdd->prepare('SELECT id, refProd, marque, P.libelle, qteEnStock, prix
									FROM produit P
									ORDER BY refProd ASC');
				$req->execute();
				$results=$req->fetchAll(PDO::FETCH_ASSOC);
				print(json_encode($results));
			break;

			case 'produitbyid':
				$req = $bdd->prepare('SELECT marque, P.libelle, resume, photoProd, qteEnStock, prix, seuilAlerte, S.libelle As LibelleSousCateg
									FROM produit P
									  	Join sous_categorie S On P.idSousCateg = S.id
									Where P.id = :id');
				$req->execute(array('id' => $_GET['id']));
				$results=$req->fetchAll(PDO::FETCH_ASSOC);
				print(json_encode($results));
			break;

			case 'lesCommandes':
				$req = $bdd->prepare('SELECT ref, U.nom AS nomClient, U.prenom AS prenomClient, T.nom AS nomTransporteur
									FROM commande C
									  	Join utilisateur U On C.idClient = U.id
										Join transporteur T On C.idTransporteur = T.id
									ORDER BY ref DESC');
				$req->execute();
				$results=$req->fetchAll(PDO::FETCH_ASSOC);
				print(json_encode($results));
			break;

			case 'statutCmd':
				$req = $bdd->prepare('SELECT S.libelle AS libelleStatut, dateChangement, refCommande
									FROM changement_statut CS
									  	Join statut S On CS.idStatut = S.id
										Join commande C On CS.refCommande = C.ref
									Where refCommande = :refCommande
									ORDER BY dateChangement DESC');
				$req->execute(array('refCommande' => $_GET['refCommande']));
				$results=$req->fetchAll(PDO::FETCH_ASSOC);
				print(json_encode($results));
			break;

			case 'produitHuile':
				$req = $bdd->prepare('SELECT P.id, refProd, marque, P.libelle, qteEnStock, prix
									FROM produit P
										Join sous_categorie S ON P.idSousCateg = S.id
										Join categorie C ON S.idCateg = C.id
									Where C.nom = "Huiles" 
									ORDER BY refProd ASC');
				$req->execute();
				$results=$req->fetchAll(PDO::FETCH_ASSOC);
				print(json_encode($results));
			break;

			case 'produitRassoir':
				$req = $bdd->prepare('SELECT P.id, refProd, marque, P.libelle, qteEnStock, prix
									FROM produit P
										Join sous_categorie S ON P.idSousCateg = S.id
										Join categorie C ON S.idCateg = C.id
									Where C.nom = "Rasoirs" 
									ORDER BY refProd ASC');
				$req->execute();
				$results=$req->fetchAll(PDO::FETCH_ASSOC);
				print(json_encode($results));
			break;

			case 'produitAccessoire':
				$req = $bdd->prepare('SELECT P.id, refProd, marque, P.libelle, qteEnStock, prix
									FROM produit P
										Join sous_categorie S ON P.idSousCateg = S.id
										Join categorie C ON S.idCateg = C.id
									Where C.nom = "Accessoires" 
									ORDER BY refProd ASC');
				$req->execute();
				$results=$req->fetchAll(PDO::FETCH_ASSOC);
				print(json_encode($results));
			break;

			case 'produitASC':
				$req = $bdd->prepare('SELECT P.id, refProd, marque, P.libelle, qteEnStock, prix
									FROM produit P 
									ORDER BY qteEnStock ASC');
				$req->execute();
				$results=$req->fetchAll(PDO::FETCH_ASSOC);
				print(json_encode($results));
			break;

			case 'produitDESC':
				$req = $bdd->prepare('SELECT P.id, refProd, marque, P.libelle, qteEnStock, prix
									FROM produit P
									ORDER BY qteEnStock DESC');
				$req->execute();
				$results=$req->fetchAll(PDO::FETCH_ASSOC);
				print(json_encode($results));
			break;

			case 'lesCategs':
				$req = $bdd->prepare('SELECT id, nom
									FROM categorie');
				$req->execute();
				$results=$req->fetchAll(PDO::FETCH_ASSOC);
				print(json_encode($results));
			break;

			case 'nvStatutCmd':
				$req = $bdd->prepare('INSERT INTO changement_statut (idStatut, refCommande, dateChangement, idUtilisateur) VALUES ((Select MAX(idStatut) + 1  From changement_statut  Where refCommande = :refCommande, :refCommande, DATE(), :user)');
				$req->execute(array('refCommande' => $_GET['refCommande'], 'user' => $_GET['user']));
				$results=$req->fetchAll(PDO::FETCH_ASSOC);
				print(json_encode($results));
			break;

			
		}
	}
	else if ($_SERVER['REQUEST_METHOD'] == 'POST')
	{
		switch($_GET['action'])
		{
			case 'authentification':
				$req = $bdd->prepare('Select id, nom, prenom, genre, dateNaissance, mail, telephone, adresse, cp, ville, mdp, idRole 
									From Utilisateur Where mail = :mail AND mdp = :mdp');
				$req->execute(array('mail' => $_POST['mail'],'mdp' => $_POST['mdp']));
				$resultat = $req->fetch(PDO::FETCH_ASSOC);
				print(json_encode($resultat));
			break;

			case 'updateseuil':
				$req = $bdd->prepare('UPDATE produit set seuilAlerte = :nvseuil where id = :idproduit');
				$req->execute(array('nvseuil' => $_POST['nvseuil'], 'idproduit' => $_POST['idproduit']));
				$results=$req->fetchAll(PDO::FETCH_ASSOC);
				print(json_encode($results));
			break;

			case 'updatestock':
				$req = $bdd->prepare('UPDATE produit set qteEnStock = qteEnStock + :nvstock where id = :idproduit');
				$req->execute(array('nvstock' => $_POST['nvstock'], 'idproduit' => $_POST['idproduit']));
				$results=$req->fetchAll(PDO::FETCH_ASSOC);
				print(json_encode($results));
			break;
			
				
		}
	}
}
catch (Exception $e)
{
	die('Erreur : ' . $e->getMessage());
}
