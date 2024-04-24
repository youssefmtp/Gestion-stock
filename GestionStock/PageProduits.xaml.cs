using System.Reflection.Metadata.Ecma335;

namespace GestionStock;

public partial class PageProduits : ContentPage
{
    Utilisateur userAuthentifie = (Utilisateur)Application.Current.Resources["userAuthentifie"];
    private bool estCroissant = true;

    public PageProduits()
	{
		InitializeComponent();
		
    }

	private async void btnPrecedent_Clicked(object sender, EventArgs e)
	{
        await Navigation.PushAsync(new PageMenuUtilisateur(userAuthentifie));
        Navigation.RemovePage(this);
    }

    private async void ContentPage_Loaded(object sender, EventArgs e)
    {
        try
        {
            List<Produit> lesProduits = await ClassePasserelle.GetProduits();
            List<Categorie> lesCateg = await ClassePasserelle.GetCategories();

            this.colViewProduits.ItemsSource = lesProduits;
            this.picker.ItemsSource = lesCateg;
        }
        catch (Exception ex)
        {
            await DisplayAlert("Erreur", ex.Message, "OK");
        }
    }

                
    private async void pickerFiltreProd_IndexChanged(object sender, EventArgs e)
    {
        Categorie laCateg = picker.SelectedItem as Categorie;
        List<Produit> lesProduits = new List<Produit>();

        if(laCateg.Nom == "Huiles")
        {
            lesProduits = await ClassePasserelle.GetProduitsHuile();


        } 
        else if (laCateg.Nom == "Rasoirs")
        {
            lesProduits = await ClassePasserelle.GetProduitsRasoir();
        }
        else
        {
            lesProduits = await ClassePasserelle.GetProduitsAccessoire();
        }

        this.colViewProduits.ItemsSource = lesProduits;

    }

    private async void colViewProduits_SelectionChanged(object sender, SelectionChangedEventArgs e)
    {
        Produit produitSelectionne = (Produit)e.CurrentSelection.FirstOrDefault();
        await Navigation.PushAsync(new PageDetailProd(produitSelectionne));
    }

    private async void btnTous_Clicked(object sender, EventArgs e)
    {
        try
        {
            List<Produit> lesProduits = await ClassePasserelle.GetProduits();

            this.colViewProduits.ItemsSource = lesProduits;
        }
        catch (Exception ex)
        {
            await DisplayAlert("Erreur", ex.Message, "OK");
        }
    }

    private async void triProduitByQte(object sender, EventArgs e)
    {
        try
        {
            
            if (estCroissant)
            {
                List<Produit> lesProduits = await ClassePasserelle.GetProduitsAsc();
                this.colViewProduits.ItemsSource = lesProduits;
                estCroissant = false;
            }
            else
            {
                List<Produit> lesProduits = await ClassePasserelle.GetProduitsDesc();
                this.colViewProduits.ItemsSource = lesProduits;
                estCroissant = true;

            }

        }
        catch (Exception ex)
        {
            await DisplayAlert("Erreur", ex.Message, "OK");
        }
    }
}