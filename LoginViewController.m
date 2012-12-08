//
//  LoginViewController.m
//  kupidum
//
//  Created by Albert Nadal Garriga on 18/11/12.
//  Copyright (c) 2012 laFruitera.com. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "KMUIUtilities.h"

@interface LoginViewController ()

- (void)ferLogin;
- (void)restartData;
- (void)showNavigationBarButtons;
- (void)backPressed;

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)restartData
{
	//Al camp usuari s'hi posa el mail guardat al Defaults de l'usuari
	[usuari setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"VinthinkUsername"]];
	[contrassenya setText:@""];
}

- (BOOL)textFieldShouldReturn:(UITextField *)text_field
{
	//Es tanca el teclat de l'input
	[text_field resignFirstResponder];

	if(text_field == usuari)
	{
		//S'ha premut el botó de següent per introduïr el camp contrassenya
		[contrassenya becomeFirstResponder];

	}
	else if(text_field == contrassenya)
	{
		//Usuari ha premut la tecla aceptar del teclat del password
		//S'inicia la petició de Log In
		[self iniciarFerLogin];
	}

	return YES;
}

- (void)showNavigationBarButtons
{
    UIButton *backButton = [KMUIUtilities customCircleBarButtonWithImage:@"nav_black_circle_button.png"
                                                          andInsideImage:@"nav_arrow_back_button.png"
                                                             andSelector:@selector(backPressed)
                                                               andTarget:self];
    
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:backButton]];
}

- (void)backPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)iniciarFerLogin
{
	//S'oculten els teclats
	[usuari resignFirstResponder];
	[contrassenya resignFirstResponder];

	//S'eliminen els espais en blanc que hi pugui haver al camp usuari i contrassenya
	[usuari setText:[[usuari text] stringByReplacingOccurrencesOfString:@" " withString:@""]];

	//Primer caldria validar que els camps entrats son correctes
	if(([[usuari text] isEqualToString:@""]) || ([[contrassenya text] isEqualToString:@""]))
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Login failed.", @"") message:NSLocalizedString(@"Siusplau, omple tots els camps.", @"") delegate:self
											  cancelButtonTitle:NSLocalizedString(@"Continuar", @"") otherButtonTitles:nil];
		[alert setTag:2]; //Tag 2 => Alerta d'error de camps no ben complerts
		[alert show];
	}
	else
	{
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] showKupidumTabBar];

		//Mostrar la caixa amb l'indicador rotatori
		//[contenidorCarregant setHidden:NO];
//		[self startLoadingIndicator];

		//S'inicia el procés de Log In
		//[NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(ferLogin) userInfo:nil repeats:NO];
	}
}

- (IBAction)desfocalitzarLabels
{
	//S'oculten els teclats
	[usuari resignFirstResponder];
	[contrassenya resignFirstResponder];	
}

- (void)ferLogin
{
/*
	NSLocale *currentUsersLocale = [NSLocale currentLocale];
	NSString *locale = [currentUsersLocale localeIdentifier];

	NSLog(@"FerLogin Username:%@ Password:%@ Locale:%@", usuari.text, contrassenya.text, locale);

	VinthinkWS *vinthinkws = [[VinthinkWS alloc] init];
	VinthinkWSLoginLanguageResponse *response = [vinthinkws LoginLanguage:usuari.text:contrassenya.text:locale];

	NSLog(response.type);
	NSLog(response.error_code);
	NSLog(response.error_message);
	NSLog(response.user_id);

	//Amagar la caixa amb l'indicador rotatori
	//[contenidorCarregant setHidden:YES];

	//Si hi ha hagut algun error es mostra el missatge d'error i el camp "usuari" recupera el focus
	if(([response.type isEqualToString:@"Error"]))
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Login failed.", @"") message:response.error_message delegate:self
											  cancelButtonTitle:NSLocalizedString(@"Continuar", @"") otherButtonTitles:nil];
		[alert setTag:1]; //Tag 1 => Alerta d'error de credencials
		[alert show];
		[alert release];
	}
	else if((response.type == response.error_code) && (response.error_code == response.error_message))
	{
		NSLog(@"L'aplicació està experimentant problemes de connectivitat.");
		//Si s'entra aquí es degut a que hi ha problemes de connectivitat amb el servidor de Vinthink

		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"L'aplicació està experimentant problemes de connectivitat.\n\nRevisa l'accés a Internet d'aquest dispositiu i torna-ho a intentar.", @"") delegate:self
											  cancelButtonTitle:NSLocalizedString(@"Continuar", @"") otherButtonTitles:nil];	
		[alert setTag:3]; //Tag 3 => Alerta d'error de falta de connectivitat
		[alert show];
		[alert release];

		//S'amaga l'indicador rotatori, en el cas que aquest estigui visible.
		[self stopLoadingIndicator];
	}	
	else
	{
		//Cal guardar les dades Username i UserID als defaults per tal de fer auto-login el pròxim cop que l'usuari obri l'aplicació.
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		[defaults setObject:response.user_id forKey:@"VinthinkTokenKey"];
		[defaults setObject:usuari.text forKey:@"VinthinkUsername"];

		[defaults synchronize];

		//Autentificació autoritzada. S'inicia la sessió.
		[aplicacio iniciarSessioUsuariFormulariLogin:response.user_id];

		//Es restaura la info del formulari de login.
		[self restartData];
	}

	[self stopLoadingIndicator];
*/
}

/*- (void)startLoadingIndicator
{
    if(contenidor_indicador == nil)
    {
        contenidor_indicador = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 548)];
        //[contenidor_indicador setBackgroundColor:[UIColor lightGrayColor]];
        [contenidor_indicador setBackgroundColor:[UIColor colorWithRed:0.666f green:0.666f blue:0.666f alpha:0.2f]];

        if(bg_indicador == nil)
        {
            bg_indicador = [[UIImageView alloc] initWithFrame:CGRectMake((320 / 2) - (60 / 2), (367 / 2) - (60 / 2), 60, 60)];
            [bg_indicador setImage:[UIImage imageNamed:@"bg_indicador_rotatori.png"]];
            [bg_indicador setAlpha:0.60f];
            [contenidor_indicador addSubview:bg_indicador];
        }

        if(indicador == nil)
        {
            indicador = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            [indicador setFrame:CGRectMake((320/2) - (indicador.frame.size.width/2), (367/2) - (indicador.frame.size.height/2), indicador.frame.size.width, indicador.frame.size.height)];
            [indicador startAnimating];
            [contenidor_indicador addSubview:indicador];
        }

        [self.view addSubview:contenidor_indicador];
    }

    [contenidor_indicador setHidden:NO];
    [contenidor_indicador setAlpha:0.9999f];
    [self.view bringSubviewToFront:contenidor_indicador];
}

- (void)stopLoadingIndicator
{
	[contenidor_indicador setHidden:NO];
	[contenidor_indicador setAlpha:0.9999f];
	
	[UIView beginAnimations:@"stopLoadingIndicator" context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.3];
	[contenidor_indicador setAlpha:0.0f];
	[UIView commitAnimations];	
}*/

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if([alertView tag] == 1)
	{
		//Alerta corresponent al missatge d'error després d'entrar login i password
		//El camp "usuari" ha de recuperar el focus amb el teclat desplegat
		[usuari becomeFirstResponder];
	}
	else if([alertView tag] == 2)
	{
		//Alerta corresponent per no completar tots els camps correctament
		if([[usuari text] isEqualToString:@""])				[usuari becomeFirstResponder]; //El camp usuari recupera el fòcus
		else if([[contrassenya text] isEqualToString:@""])	[contrassenya becomeFirstResponder]; //El camp contrassenya recupera el fòcus
	}
	else if([alertView tag] == 3)
	{
		//Aquest cas es dona quan s'han detectat problemes de connectivitat
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showNavigationBarButtons];

    [self setTitle:NSLocalizedString(@"Iniciar sessió", @"")];
	[labelTextEtsMembre setText:NSLocalizedString(@"¿Ja ets membre de Kupidum?", @"")];
	[labelTextUsuari setText:NSLocalizedString(@"Email:", @"")];
	[labelTextPassword setText:NSLocalizedString(@"Contrassenya:", @"")];
	[buttonAccedir setTitle:NSLocalizedString(@"Accedir", @"") forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

	// Release any cached data, images, etc that aren't in use.
}

#pragma mark UIViewController delegate methods

// called after this controller's view was dismissed, covered or otherwise hidden
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];

    //S'oculten els teclats
	[usuari resignFirstResponder];
	[contrassenya resignFirstResponder];
}

// called after this controller's view will appear
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

@end
