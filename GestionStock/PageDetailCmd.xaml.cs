namespace GestionStock;

public partial class PageDetailCmd : ContentPage
{
	private Commande laCmd = new Commande();

    public PageDetailCmd(Commande uneCmd)
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
}