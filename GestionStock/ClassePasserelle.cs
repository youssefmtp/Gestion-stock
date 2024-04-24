using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;

namespace GestionStock
{
    /// <summary>
    /// Permet d'accéder aux informations de la base de données via un web service.
    /// </summary>
    /// 
    public class ClassePasserelle
    {

        public static string urlServiceWeb = "http://localhost/ServiceWebGestionStock"; //Windows : localhost // Android : 10.0.2.2
        public static HttpClient httpClient = new HttpClient();


        /// <summary>
        /// Obtient les informations de l'utilisateur correspondant a l'adresse mail et au mot de passe
        /// </summary>
        /// <param name="mail">Adresse mail</param>
        /// <param name="mdp">Mot de passe</param>
        /// <exception cref="Exception">Si la connexion n'a pas aboutie</exception>
        /// <returns>Un objet Utilisateur contenant les données de l'utilisateur</returns>
        public static async Task<Utilisateur> GetUser(string mail, string mdp)
        {
            Utilisateur leUser = null;

            string urlAPI = ClassePasserelle.urlServiceWeb + "/connexion/";

            MultipartFormDataContent form = new MultipartFormDataContent();
            form.Add(new StringContent(mail), name: "mail");
            form.Add(new StringContent(mdp), name: "mdp");

            HttpResponseMessage reponse = await ClassePasserelle.httpClient.PostAsync(new Uri(urlAPI), form);
            if (reponse.IsSuccessStatusCode)
            {
                string resultat = await reponse.Content.ReadAsStringAsync();
                if (resultat.Contains("false") == false) //Si le résultat ne contient pas la chaine False : il existe un utilisateur
                {
                    JsonSerializerOptions optionJson = new JsonSerializerOptions();
                    optionJson.PropertyNameCaseInsensitive = true;
                    leUser = JsonSerializer.Deserialize<Utilisateur>(resultat, optionJson);
                }
                //Sinon le login et le mot de passe n'existe pas, alors leUser reste null
            }
            else
            {
                throw new Exception("Problème de connexion. Merci de réessayer ultérieurement."); //Lève une exception si la connexion n'a pas aboutie
            }
            return leUser;
        }

        /// <summary>
        /// Obtient la liste de tous les produits de la base de données
        /// </summary>
        /// <exception cref="Exception">Si aucun produits n'est retourner</exception>
        /// <returns>La liste de tous les produits </returns>
        public static async Task<List<Produit>> GetProduits()
        {

            string urlAPI = ClassePasserelle.urlServiceWeb + "/produits/";

            HttpResponseMessage resultatRequete = await ClassePasserelle.httpClient.GetAsync(new Uri(urlAPI));
            if (resultatRequete.IsSuccessStatusCode)
            {
                string contenu = await resultatRequete.Content.ReadAsStringAsync();

                JsonSerializerOptions optionJson = new JsonSerializerOptions();
                optionJson.PropertyNameCaseInsensitive = true;
                List<Produit> lesProds = JsonSerializer.Deserialize<List<Produit>>(contenu, optionJson);

                return lesProds;
            }
            else
            {
                throw new Exception("Erreur" + resultatRequete.StatusCode.ToString());
            }

        }

        /// <summary>
        /// Obtient le produit passer en paramétre de la base de données
        /// </summary>
        /// <param name="unP"> un produit </param>
        /// <returns> le produit </returns>
        /// <exception cref="Exception">Si le produit n'est retourner</exception>
        public static async Task<List<Produit>> GetProduitsById(Produit unP)
        {

            string urlAPI = urlServiceWeb + "/produitbyid/" + unP.Id + "/";

            HttpResponseMessage resultatRequete = await ClassePasserelle.httpClient.GetAsync(new Uri(urlAPI));
            if (resultatRequete.IsSuccessStatusCode)
            {
                string contenu = await resultatRequete.Content.ReadAsStringAsync();

                JsonSerializerOptions optionJson = new JsonSerializerOptions();
                optionJson.PropertyNameCaseInsensitive = true;
                List<Produit> leProd = JsonSerializer.Deserialize<List<Produit>>(contenu, optionJson);

                return leProd;
            }
            else
            {
                throw new Exception("Erreur" + resultatRequete.StatusCode.ToString());
            }

        }

        /// <summary>
        /// Obtient la liste de toutes les commandes de la base de données
        /// </summary>
        /// <exception cref="Exception">Si aucune commandes n'est retourner</exception>
        /// <returns>La liste de toutes les commandes </returns>
        public static async Task<List<Commande>> GetCommandes()
        {

            string urlAPI = ClassePasserelle.urlServiceWeb + "/commandes/";

            HttpResponseMessage resultatRequete = await ClassePasserelle.httpClient.GetAsync(new Uri(urlAPI));
            if (resultatRequete.IsSuccessStatusCode)
            {
                string contenu = await resultatRequete.Content.ReadAsStringAsync();

                JsonSerializerOptions optionJson = new JsonSerializerOptions();
                optionJson.PropertyNameCaseInsensitive = true;
                List<Commande> lesCmds = JsonSerializer.Deserialize<List<Commande>>(contenu, optionJson);

                return lesCmds;
            }
            else
            {
                throw new Exception("Erreur" + resultatRequete.StatusCode.ToString());
            }

        }

        /// <summary>
        /// Obtient les statuts de la commande
        /// </summary>
        /// <exception cref="Exception">Retourne le message d'erreur </exception>
        /// <returns>Collection des changements statuts </returns>
        public static async Task<List<ChangementStatut>> GetStatutCmd(Commande uneCmd)
        {
            string urlAPI = urlServiceWeb + "/statutcommande/" + uneCmd.Ref + "/";


            HttpResponseMessage resultatRequete = await ClassePasserelle.httpClient.GetAsync(new Uri(urlAPI));
            if (resultatRequete.IsSuccessStatusCode)
            {
                string contenu = await resultatRequete.Content.ReadAsStringAsync();

                JsonSerializerOptions optionJson = new JsonSerializerOptions();
                optionJson.PropertyNameCaseInsensitive = true;
                List<ChangementStatut> lesS = JsonSerializer.Deserialize<List<ChangementStatut>>(contenu, optionJson);

                
                return lesS;
            }
            else
            {
                throw new Exception("Erreur au chargement des données : " + resultatRequete.StatusCode.ToString());
            }
        }

        public static async void UpdateSeuil(string nvSeuil, Produit unProduit)
        {
            string urlAPI = urlServiceWeb + "/updateseuil/";

            MultipartFormDataContent form = new MultipartFormDataContent();
            form.Add(new StringContent(nvSeuil), name: "nvseuil");
            form.Add(new StringContent(unProduit.Id.ToString()), name: "idproduit");

            HttpResponseMessage resultatRequete = await ClassePasserelle.httpClient.PostAsync(new Uri(urlAPI), form);
            if (resultatRequete.IsSuccessStatusCode)
            {
                string contenu = await resultatRequete.Content.ReadAsStringAsync();

                JsonSerializerOptions optionJson = new JsonSerializerOptions();
                optionJson.PropertyNameCaseInsensitive = true;


            }
            else
            {
                throw new Exception("Erreur au chargement des données : " + resultatRequete.StatusCode.ToString());
            }

        }

        public static async void UpdateStock(string nvStock, Produit unProduit)
        {
            string urlAPI = urlServiceWeb + "/updatestock/";

            MultipartFormDataContent form = new MultipartFormDataContent();
            form.Add(new StringContent(nvStock), name: "nvstock");
            form.Add(new StringContent(unProduit.Id.ToString()), name: "idproduit");

            HttpResponseMessage resultatRequete = await ClassePasserelle.httpClient.PostAsync(new Uri(urlAPI), form);
            

            if (resultatRequete.IsSuccessStatusCode)
            {
                string contenu = await resultatRequete.Content.ReadAsStringAsync();

                JsonSerializerOptions optionJson = new JsonSerializerOptions();
                optionJson.PropertyNameCaseInsensitive = true;

            }
            else
            {
                throw new Exception("Erreur au chargement des données : " + resultatRequete.StatusCode.ToString());
            }
        }


        public static async Task<List<Produit>> GetProduitsHuile()
        {

            string urlAPI = ClassePasserelle.urlServiceWeb + "/produitshuile/";

            HttpResponseMessage resultatRequete = await ClassePasserelle.httpClient.GetAsync(new Uri(urlAPI));
            if (resultatRequete.IsSuccessStatusCode)
            {
                string contenu = await resultatRequete.Content.ReadAsStringAsync();

                JsonSerializerOptions optionJson = new JsonSerializerOptions();
                optionJson.PropertyNameCaseInsensitive = true;
                List<Produit> lesProds = JsonSerializer.Deserialize<List<Produit>>(contenu, optionJson);

                return lesProds;
            }
            else
            {
                throw new Exception("Erreur" + resultatRequete.StatusCode.ToString());
            }

        }

        public static async Task<List<Produit>> GetProduitsRasoir()
        {

            string urlAPI = ClassePasserelle.urlServiceWeb + "/produitsrasoir/";

            HttpResponseMessage resultatRequete = await ClassePasserelle.httpClient.GetAsync(new Uri(urlAPI));
            if (resultatRequete.IsSuccessStatusCode)
            {
                string contenu = await resultatRequete.Content.ReadAsStringAsync();

                JsonSerializerOptions optionJson = new JsonSerializerOptions();
                optionJson.PropertyNameCaseInsensitive = true;
                List<Produit> lesProds = JsonSerializer.Deserialize<List<Produit>>(contenu, optionJson);

                return lesProds;
            }
            else
            {
                throw new Exception("Erreur" + resultatRequete.StatusCode.ToString());
            }

        }

        public static async Task<List<Produit>> GetProduitsAccessoire()
        {

            string urlAPI = ClassePasserelle.urlServiceWeb + "/produitsaccessoire/";

            HttpResponseMessage resultatRequete = await ClassePasserelle.httpClient.GetAsync(new Uri(urlAPI));
            if (resultatRequete.IsSuccessStatusCode)
            {
                string contenu = await resultatRequete.Content.ReadAsStringAsync();

                JsonSerializerOptions optionJson = new JsonSerializerOptions();
                optionJson.PropertyNameCaseInsensitive = true;
                List<Produit> lesProds = JsonSerializer.Deserialize<List<Produit>>(contenu, optionJson);

                return lesProds;
            }
            else
            {
                throw new Exception("Erreur" + resultatRequete.StatusCode.ToString());
            }

        }

        public static async Task<List<Produit>> GetProduitsAsc()
        {

            string urlAPI = ClassePasserelle.urlServiceWeb + "/produitsasc/";

            HttpResponseMessage resultatRequete = await ClassePasserelle.httpClient.GetAsync(new Uri(urlAPI));
            if (resultatRequete.IsSuccessStatusCode)
            {
                string contenu = await resultatRequete.Content.ReadAsStringAsync();

                JsonSerializerOptions optionJson = new JsonSerializerOptions();
                optionJson.PropertyNameCaseInsensitive = true;
                List<Produit> lesProds = JsonSerializer.Deserialize<List<Produit>>(contenu, optionJson);

                return lesProds;
            }
            else
            {
                throw new Exception("Erreur" + resultatRequete.StatusCode.ToString());
            }

        }

        public static async Task<List<Produit>> GetProduitsDesc()
        {

            string urlAPI = ClassePasserelle.urlServiceWeb + "/produitsdesc/";

            HttpResponseMessage resultatRequete = await ClassePasserelle.httpClient.GetAsync(new Uri(urlAPI));
            if (resultatRequete.IsSuccessStatusCode)
            {
                string contenu = await resultatRequete.Content.ReadAsStringAsync();

                JsonSerializerOptions optionJson = new JsonSerializerOptions();
                optionJson.PropertyNameCaseInsensitive = true;
                List<Produit> lesProds = JsonSerializer.Deserialize<List<Produit>>(contenu, optionJson);

                return lesProds;
            }
            else
            {
                throw new Exception("Erreur" + resultatRequete.StatusCode.ToString());
            }

        }

        public static async Task<List<Categorie>> GetCategories()
        {

            string urlAPI = ClassePasserelle.urlServiceWeb + "/categories/";

            HttpResponseMessage resultatRequete = await ClassePasserelle.httpClient.GetAsync(new Uri(urlAPI));
            if (resultatRequete.IsSuccessStatusCode)
            {
                string contenu = await resultatRequete.Content.ReadAsStringAsync();

                JsonSerializerOptions optionJson = new JsonSerializerOptions();
                optionJson.PropertyNameCaseInsensitive = true;
                List<Categorie> lesCategs = JsonSerializer.Deserialize<List<Categorie>>(contenu, optionJson);

                return lesCategs;
            }
            else
            {
                throw new Exception("Erreur" + resultatRequete.StatusCode.ToString());
            }

        }

        public static async Task<List<ChangementStatut>> GetNvStatutCmd(Commande uneCmd, Utilisateur unUser)
        {
            string urlAPI = urlServiceWeb + "/statutcommandesuivant/" + uneCmd.Ref + "/" + unUser.Id + "/";


            HttpResponseMessage resultatRequete = await ClassePasserelle.httpClient.GetAsync(new Uri(urlAPI));
            if (resultatRequete.IsSuccessStatusCode)
            {
                string contenu = await resultatRequete.Content.ReadAsStringAsync();

                JsonSerializerOptions optionJson = new JsonSerializerOptions();
                optionJson.PropertyNameCaseInsensitive = true;
                List<ChangementStatut> lesS = JsonSerializer.Deserialize<List<ChangementStatut>>(contenu, optionJson);


                return lesS;
            }
            else
            {
                throw new Exception("Erreur au chargement des données : " + resultatRequete.StatusCode.ToString());
            }
        }
        

    }
}
