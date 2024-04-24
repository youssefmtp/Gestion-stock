namespace GestionStock;

public partial class PageDetailCmdExpediteur : ContentPage
{
	private Commande laCmd = new Commande();
    private Utilisateur userAuthentifie = (Utilisateur)Application.Current.Resources["userAuthentifie"];

    public PageDetailCmdExpediteur(Commande uneCmd)
	{
		InitializeComponent();
		laCmd = uneCmd;
        lblRefCmd.Text += uneCmd.Ref;
     

    }

    private async void ContentPage_Loaded(object sender, EventArgs e)
    {
        try
        {
            this.colViewStatutCmd.ItemsSource = await ClassePasserelle.GetStatutCmd(laCmd);
        }
        catch (Exception ex)
        {
            await DisplayAlert("Erreur", ex.Message, "OK");
        }
    }

    private async void btnPrecedent_Clicked(object sender, EventArgs e)
    {
        await Navigation.PushAsync(new PageCommandes());
        Navigation.RemovePage(this);
    }

    private async void btnEtapeSuivante_Clicked(object sender, EventArgs e)
    {
        this.colViewStatutCmd.ItemsSource = await ClassePasserelle.GetNvStatutCmd(laCmd, userAuthentifie);
    }
    
} 