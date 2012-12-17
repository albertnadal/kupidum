//
//  InitialScreenViewController.m
//  kupidum
//
//  Created by Albert Nadal Garriga on 18/11/12.
//  Copyright (c) 2012 laFruitera.com. All rights reserved.
//

#import "InitialScreenViewController.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"

@interface InitialScreenViewController ()

- (void)showContenidorCarregant;
- (void)hideContenidorCarregant;
- (void)startLoadingIndicator;
- (void)stopLoadingIndicator;
//- (IBAction)iniciarShowLoginFacebook;

@end

@implementation InitialScreenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setTitle:NSLocalizedString(@"Benvingut a Kupidum!", @"")];
	[labelTextEscull setText:NSLocalizedString(@"Escull una forma d'entrar", @"")];
	[buttonIniciarSessio setTitle:NSLocalizedString(@"Iniciar sessió", @"") forState:UIControlStateNormal];
	[buttonRegistrat setTitle:NSLocalizedString(@"Registra't ara", @"") forState:UIControlStateNormal];
	[buttonEntrarViaFacebook setTitle:NSLocalizedString(@"Entrar mitjançant Facebook", @"") forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startLoadingIndicator
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
}

- (void)showContenidorCarregant
{
	//[contenidorCarregant setHidden:NO];
}

- (void)hideContenidorCarregant
{
	//[contenidorCarregant setHidden:YES];
}

/*- (IBAction)iniciarShowLoginFacebook
{
	[termes initStartOperations];
	[termes registreViaFacebook];

    termes.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self.navigationController presentModalViewController:termes animated:YES];
}*/

- (IBAction)showLoginFacebook
{
	//Anar a la pantalla per entrar via Facebook
	[self startLoadingIndicator];
//	[[NSTimer scheduledTimerWithTimeInterval:0.01 target:aplicacio selector:@selector(showLoginFacebook) userInfo:nil repeats:NO] retain];
}

- (IBAction)showLogin
{
	//Anar a la pantalla per entrar login i password de Kupidum
    LoginViewController *loginScreen = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController pushViewController:loginScreen animated:YES];
}

- (IBAction)showRegister
{
	//Anar a la pantalla per omplir el formulari de registre
    RegisterViewController *registerScreen = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil step:0];
    [self.navigationController pushViewController:registerScreen animated:YES];
}

- (void)restartData
{
	[self stopLoadingIndicator];
}


#pragma mark UIViewController delegate methods

// called after this controller's view was dismissed, covered or otherwise hidden
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

// called after this controller's view will appear
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

@end
