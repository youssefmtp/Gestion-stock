namespace GestionStock;

public partial class PageDetailProd : ContentPage
{

    public PageDetailProd(Produit unProd)
    {
        InitializeComponent();
        Application.Current.Resources["produit"] = unProd;


    }

    private async void btnPrecedent_Clicked(object sender, EventArgs e)
    {
        Application.Current.Resources.Remove("produit");
        await Navigation.PushAsync(new PageProduits());
        Navigation.RemovePage(this);
    }

    private async void ContentPage_Loaded(object sender, EventArgs e)
    {
        try
        {
            Produit unP = (Produit)Application.Current.Resources["produit"];
            this.colViewDetailProduits.ItemsSource = await ClassePasserelle.GetProduitsById(unP);
        }
        catch (Exception ex)
        {
            await DisplayAlert("Erreur", ex.Message, "OK");
        }

        
    }

    private async void btnNvSeuil_Clicked(object sender, EventArgs e)
    {

        try
        {
            Produit unP = (Produit)Application.Current.Resources["produit"];
            ClassePasserelle.UpdateSeuil(txtSeuilAlerte.Text, unP);
            
            await DisplayAlert("Succès", "Seuil mis à jour.", "OK");
            await Navigation.PushAsync(new PageDetailProd(unP));

        }
        catch (Exception ex)
        {
            await DisplayAlert("Erreur", ex.Message, "OK");
        }
    }

    private async void btnAjoutStock_Clicked(object sender, EventArgs e)
    {

        try
        {
            Produit unP = (Produit)Application.Current.Resources["produit"];
            ClassePasserelle.UpdateStock(txtQteEnStock.Text, unP);

            await DisplayAlert("Succès", "Quantité mise à jour.", "OK");
            await Navigation.PushAsync(new PageDetailProd(unP));

        }
        catch (Exception ex)
        {
            await DisplayAlert("Erreur", ex.Message, "OK");
        }
    }
}