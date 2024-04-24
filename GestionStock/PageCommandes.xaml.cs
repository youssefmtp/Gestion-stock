namespace GestionStock;

public partial class PageCommandes : ContentPage
{
    private Utilisateur userAuthentifie = (Utilisateur)Application.Current.Resources["userAuthentifie"];

    public PageCommandes()
	{
		InitializeComponent();
	}

    private async void btnPrecedent_Clicked(object sender, EventArgs e)
    {
        if(int.Parse(userAuthentifie.IdRole) == 5)
        {
            await Navigation.PushAsync(new PageMenuServiceExpedition(userAuthentifie));
        } 
        else 
        { 
          await Navigation.PushAsync(new PageMenuUtilisateur(userAuthentifie));
        }

        Navigation.RemovePage(this);
    }

    private async void ContentPage_Loaded(object sender, EventArgs e)
    {
        try
        {
            List<Commande> lesCommandes = await ClassePasserelle.GetCommandes();

            this.colViewCommandes.ItemsSource = lesCommandes;
        }
        catch (Exception ex)
        {
            await DisplayAlert("Erreur", ex.Message, "OK");
        }
    }

    private async void colViewCommandes_SelectionChanged(object sender, SelectionChangedEventArgs e)
    {

        if (int.Parse(userAuthentifie.IdRole) == 5)
        {
            Commande commandeSelectionne = (Commande)e.CurrentSelection.FirstOrDefault();
            await Navigation.PushAsync(new PageDetailCmdExpediteur(commandeSelectionne));
        }
        else
        {
            Commande commandeSelectionne = (Commande)e.CurrentSelection.FirstOrDefault();
            await Navigation.PushAsync(new PageDetailCmd(commandeSelectionne));
        }

        
    }
}