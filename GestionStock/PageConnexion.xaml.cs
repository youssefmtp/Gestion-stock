namespace GestionStock;

public partial class PageConnexion : ContentPage
{
	public PageConnexion()
	{
		InitializeComponent();
	}

    private async void btEnvoyer_Clicked(object sender, EventArgs e)
    {
        
        try
        {
            Utilisateur unUser = await ClassePasserelle.GetUser(txtMail.Text, txtMdp.Text);

            if (unUser != null)
            {
                //Permet d'accéder à la page passée en paramètre

                if(int.Parse(unUser.IdRole) == 5)
                {
                    await Navigation.PushAsync(new PageMenuServiceExpedition(unUser));
                }
                else
                {
                    await Navigation.PushAsync(new PageMenuUtilisateur(unUser));

                }

                //Supprime la page courante de la navigation afin de ne pas pouvoir revenir dessus
                Navigation.RemovePage(this);
            }
            else
            {
                lblErreur.IsVisible = true;
                txtMail.Text = txtMdp.Text = "";
            }
        }
        catch (ArgumentNullException)
        {
            await DisplayAlert("Erreur", "Vous devez saisir un nom d'utilisateur et un mot de passe", "OK");
        }
        catch (Exception ex)
        {
            await DisplayAlert("Erreur", ex.Message, "OK");
        }
    }


}