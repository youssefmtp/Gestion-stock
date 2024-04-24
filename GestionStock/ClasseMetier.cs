using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection.Metadata.Ecma335;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace GestionStock
{

    public class Fournisseur
    {
        public int Id { get; set; }

        public string Nom { get; set; }

        public string Ad { get; set; }

        public int Cp { get; set; }

        public string Ville { get; set; }

        public int Telephone { get; set; }  

    }

    public class Statut
    {
        public int Id { get; set; }

        public string Libelle { get; set; }

    }

    public class Role
    {
        public int Id { get; set; }

        public string Libelle { get; set; }

    }

    public class Transporteur
    {
        public int Id { get; set; }

        public string Nom { get; set; }

        public string Ad { get; set; }

        public int Cp { get; set; }

        public string Ville { get; set; }

        public int Telephone { get; set; }

    }


    public class Categorie
    {
        public string Id { get; set; }

        public string Nom { get; set; }

        public override string ToString()
        {
            return this.Nom;
        }

    }

    public class SousCategorie
    {
        public int Id { get; set; }

        public string Libelle { get; set; }

        public int IdCateg { get; set; }

    }

    public class Produit
    {
        public string Id { get; set; }

        public string RefProd { get; set; }

        public string Marque { get; set; }

        public string Libelle { get; set; }

        public string Resume { get; set; }

        public string Description { get; set; }

        public string PhotoProd { get; set; }

        public string Prix { get; set; }

        public string QteEnStock { get; set; }

        public string SeuilAlerte { get; set; }

        public string IdSousCateg { get; set; }
        public string LibelleSousCateg { get; set; }

        public string AfficheMarqueLibelle
        {
            get { return this.Marque + " - " + this.Libelle; }
        }
        public string AffichePrix
        {
            get { return "Prix : " + this.Prix + "€"; }
        }

        public string AfficheQteEnStock
        {
            get { return "Quantité en stock : " + this.QteEnStock; }
        }

        public string AfficheSeuilAlerte
        {
            get { return "Seuil d'alerte : " + this.SeuilAlerte; }
        }

        public string AfficheLibelleSousCateg
        {
            get { return "Sous catégorie : " + this.LibelleSousCateg; }
        }

    }

    public class Demande
    {
        public int Id { get; set; }

        public DateTime DateDemande { get; set; }

        public DateTime DateLivraison { get; set; }

        public int Qte{ get; set; }

        [JsonPropertyName("idFournisseur")]
        public int IdFour { get; set; }

        [JsonPropertyName("idProduit")]

        public int IdProd { get; set; }

    }

    public class Utilisateur
    {
        public string Id { get; set; }

        public string Nom { get; set; }

        public string Prenom { get; set; }

        public string Genre { get; set; }

        public DateTime DateNaissance { get; set; }

        public string Mail { get; set; }

        public string Telephone { get; set; }

        public string Adresse { get; set; }

        public string Cp { get; set; }

        public string Ville { get; set; }

        public string Mdp { get; set; }

        public string IdRole { get; set; }

    }

    public class Commande
    {
        public string Ref { get; set; }

        public string AdLivraison { get; set; }

        public string CpLivraison { get; set; }

        public string VilleLivraison { get; set; }

        public int IdClient { get; set; }

        public int IdTransporteur { get; set; }
        public string NomClient { get; set; }
        public string PrenomClient { get; set; }
        public string NomTransporteur { get; set; }

        public string AfficheNomPrenom
        {
            get { return this.PrenomClient + " " + this.NomClient; }
        }


    }

    public class DetailCommande
    {

        [JsonPropertyName("refCommande")]
        public int RefCmd { get; set; }

        [JsonPropertyName("idProduit")]
        public int IdProd { get; set; }

        public int Quantite { get; set; }

    }

    public class ChangementStatut
    {
        public string IdStatut { get; set; }

        [JsonPropertyName("refCommande")]
        public string RefCmd { get; set; }

        public string DateChangement { get; set; }
        public string LibelleStatut { get; set; }

        public string AfficheLibelleDate
        {
            get { return this.LibelleStatut + " le " + this.DateChangement; }
        }

        public string LibelleStatutSuivant { get; set; }

    }

    public class Avis
    {
        public int Id { get; set; }

        public string Description { get; set; }

        public bool EstFavorie { get; set; }

        public int NbEtoiles { get; set; }

        public DateTime DateAvis { get; set; }

        public int IdClient { get; set; }

        public int IdProduit { get; set; }

    }


}
