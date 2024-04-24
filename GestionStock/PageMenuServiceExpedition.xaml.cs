namespace GestionStock;

public partial class PageMenuServiceExpedition : ContentPage
{

    public PageMenuServiceExpedition(Utilisateur userAuthentifie)
    {
        InitializeComponent();
        lblBonjour.Text += userAuthentifie.Prenom + " " + userAuthentifie.Nom.ToUpper();
        Application.Current.Resources["userAuthentifie"] = userAuthentifie;
    }

    private async void btnDeconnection_Clicked(object sender, EventArgs e)
    {
        Application.Current.Resources.Remove("userAuthentifie");
        await Navigation.PushAsync(new PageConnexion());
        Navigation.RemovePage(this);
    }

    private async void btnProduits_Clicked(object sender, EventArgs e)
    {
        await Navigation.PushAsync(new PageProduits());
    }

    private async void btnCommandes_Clicked(object sender, EventArgs e)
    {
        await Navigation.PushAsync(new PageCommandes());
    }
}