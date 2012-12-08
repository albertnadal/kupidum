//
//  RegisterViewController.m
//  kupidum
//
//  Created by Albert Nadal Garriga on 18/11/12.
//  Copyright (c) 2012 laFruitera.com. All rights reserved.
//

#import "AppDelegate.h"
#import "RegisterViewController.h"
#import "KMUIUtilities.h"

#define SELECTOR_SOC_TAG 1
#define SELECTOR_EDAT_TAG 2
#define SELECTOR_DATA_NAIXEMENT_TAG 3
#define SELECTOR_PAIS_TAG 4

#define TOTAL_STEPS 3

@interface RegisterViewController ()

- (void)startLoadingIndicator;
- (void)stopLoadingIndicator;
- (void)showStep:(int)theCurrentStep
              of:(int)theTotalSteps;
- (void)showNavigationBarButtons;
- (void)backPressed;
//- (void)mostrarFinestraTermesCondicions;

@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil step:(int)theStep
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        totalSteps = TOTAL_STEPS;
        currentStep = theStep;

        labelTextEtsNou = nil;
        labelTextSoc = nil;
        labelTextEdatEntre = nil;
        labelTextDataNaixement = nil;
        labelTextPais = nil;

        labelTextEsConfidencial = nil;
        labelTextCodiPostal = nil;
        labelTextSobrenom = nil;
        labelTextContrassenya = nil;
        labelTextEmail = nil;

        buttonAccedir = nil;
        buttonSeguent = nil;
        
        contenidorFormulari = nil;

        selectorSoc = nil;
        selectorEdat = nil;
        selectorDataNaixement = nil;
        selectorPais = nil;

        indexSelectorSoc = 0;
        edatMinima = 18;
        edatMaxima = 45;
        diaNaixement = 0;
        mesNaixement = 0;
        anyNaixement = 0;
        indexSelectorPais = 0;

        selectedLabelTextSoc = nil;
        selectedLabelTextEdat = nil;
        selectedLabelDataNaixement = nil;
        selectedLabelTextPais = nil;

        codiPostal = nil;
        sobrenom = nil;
        email = nil;
        contrassenya = nil;
    }
    return self;
}

- (NSString *)getTextForSelectorDataNaixement
{
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setDateStyle:NSDateFormatterLongStyle];
	[df setTimeStyle:NSDateFormatterNoStyle];
    return [df stringFromDate:selectorDataNaixement.date];
}

- (NSString *)getTextForSelectorSocAtIndex:(int)index
{
    switch(index)
    {
        case 0: return NSLocalizedString(@"Una dona que busca un home", @"");
                break;
        case 1: return NSLocalizedString(@"Un home que busca una dona", @"");
                break;
        case 2: return NSLocalizedString(@"Una dona que busca una dona", @"");
                break;
        case 3: return NSLocalizedString(@"Un home que busca un home", @"");
                break;
    }

    return @"";
}

- (NSString *)getTextForSelectorPaisAtIndex:(int)index
{
    switch(index)
    {
        case 0: return NSLocalizedString(@"Espanya", @"");
            break;
        case 1: return NSLocalizedString(@"França", @"");
            break;
        case 2: return NSLocalizedString(@"Italia", @"");
            break;
        case 3: return NSLocalizedString(@"Portugal", @"");
            break;
    }
    
    return @"";
}

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view {

    UILabel *pickerLabel = (UILabel *)view;

    if (pickerLabel == nil) {
        CGRect frame = CGRectMake(0.0, 0.0, 320, 34);
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        //[pickerLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
    }

    if([pickerView tag] == SELECTOR_SOC_TAG)
    {
        [pickerLabel setText:[self getTextForSelectorSocAtIndex:row]];
    }
    else if([pickerView tag] == SELECTOR_EDAT_TAG)
    {
        [pickerLabel setText:[NSString stringWithFormat:@"%d", row + 18]];
        if((component == 1) && ((row + 18) < edatMinima))
                [pickerLabel setTextColor:[UIColor grayColor]];
        else    [pickerLabel setTextColor:[UIColor blackColor]];
            
    }
    else if([pickerView tag] == SELECTOR_PAIS_TAG)
    {
        [pickerLabel setText:[self getTextForSelectorPaisAtIndex:row]];
    }

    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{

    if([pickerView tag] == SELECTOR_SOC_TAG)
    {
        indexSelectorSoc = row;
        [selectedLabelTextSoc setText:[(UILabel*)[pickerView viewForRow:indexSelectorSoc forComponent:0] text]];
    }
    else if([pickerView tag] == SELECTOR_EDAT_TAG)
    {
        switch (component)
        {
            case 0: edatMinima = row + 18;
                    break;
            case 1: edatMaxima = row + 18;
                    break;
        }

        [selectorEdat reloadAllComponents];

        if ((edatMinima - 18) > (edatMaxima - 18))
        {
            edatMaxima = edatMinima;
            [selectorEdat selectRow:(edatMaxima - 18) inComponent:1 animated:YES];
        }

        [selectedLabelTextEdat setText:[NSString stringWithFormat:NSLocalizedString(@"%d i %d anys", @""), edatMinima, edatMaxima]];
    }
    else if([pickerView tag] == SELECTOR_PAIS_TAG)
    {
        indexSelectorPais = row;
        [selectedLabelTextPais setText:[(UILabel*)[pickerView viewForRow:indexSelectorPais forComponent:0] text]];
    }

}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if([pickerView tag] == SELECTOR_SOC_TAG)        return 4;
    else if([pickerView tag] == SELECTOR_EDAT_TAG)  return 82;
    else if([pickerView tag] == SELECTOR_PAIS_TAG)  return 4;
    else return 0;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if([pickerView tag] == SELECTOR_SOC_TAG)        return 1;
    else if([pickerView tag] == SELECTOR_EDAT_TAG)  return 2;
    else if([pickerView tag] == SELECTOR_PAIS_TAG)  return 1;
    else return 0;
}

/*- (void)mostrarFinestraTermesCondicions
{
	[termes initStartOperations];
	[termes registreViaFormulari];

    termes.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self.navigationController presentModalViewController:termes animated:YES];
}*/

- (BOOL)textFieldShouldReturn:(UITextField *)text_field
{
	//Es tanca el teclat de l'input
	[text_field resignFirstResponder];

	if(text_field == codiPostal)
	{
		//S'ha premut el botó de següent per introduïr el camp contrassenya
		[sobrenom becomeFirstResponder];

	}
	if(text_field == sobrenom)
	{
		//S'ha premut el botó de següent per introduïr el camp contrassenya
		[contrassenya becomeFirstResponder];
		
	}
	if(text_field == contrassenya)
	{
		//S'ha premut el botó de següent per introduïr el camp contrassenya
		[email becomeFirstResponder];
		
	}	
	else if(text_field == email)
	{
		//Usuari ha premut la tecla aceptar del teclat del password
		//S'inicia la petició de Log In
		[self validarCamps];
	}

	return YES;
}

- (void)startLoadingIndicator
{
/*
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
*/
}

- (void)stopLoadingIndicator
{
/*
	[contenidor_indicador setHidden:NO];
	[contenidor_indicador setAlpha:0.9999f];
	
	[UIView beginAnimations:@"stopLoadingIndicator" context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.3];
	[contenidor_indicador setAlpha:0.0f];
	[UIView commitAnimations];
*/
}

- (IBAction)desfocalitzarCamps
{
    [self desfocalitzarLabels];
    [self desfocalitzarSelectors];

	[UIView beginAnimations:@"defocalitzarLabels" context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.35];
    
	[contenidorFormulari setFrame:CGRectMake(contenidorFormulari.frame.origin.x, 0 , contenidorFormulari.frame.size.width, contenidorFormulari.frame.size.height)];
    
	[UIView commitAnimations];
}

- (IBAction)desfocalitzarLabels
{
	//S'oculten els teclats
	[codiPostal resignFirstResponder];
	[sobrenom resignFirstResponder];
	[email resignFirstResponder];
	[contrassenya resignFirstResponder];
}

- (IBAction)desfocalitzarSelectors
{
    [selectorSoc setHidden:YES];
    [selectorEdat setHidden:YES];
    [selectorDataNaixement setHidden:YES];
    [selectorPais setHidden:YES];
}

- (IBAction)focalitzarSelector:(id)sender
{
    [self desfocalitzarSelectors];
    [self desfocalitzarLabels];

    UIView *selector = nil;

    if([sender tag] == SELECTOR_SOC_TAG)                    selector = selectorSoc;
    else if([sender tag] == SELECTOR_EDAT_TAG)              selector = selectorEdat;
    else if([sender tag] == SELECTOR_DATA_NAIXEMENT_TAG)    selector = selectorDataNaixement;
    else if([sender tag] == SELECTOR_PAIS_TAG)              selector = selectorPais;

    [self.view bringSubviewToFront:selector];
    [selector setHidden:NO];
    [selector setFrame:CGRectMake(selector.frame.origin.x, (self.view.frame.origin.y + self.view.frame.size.height) , selector.frame.size.width, selector.frame.size.height)];

	[UIView beginAnimations:@"focalitzarSelector" context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.35];

    [selector setFrame:CGRectMake(selector.frame.origin.x, selector.frame.origin.y - selector.frame.size.height , selector.frame.size.width, selector.frame.size.height)];

    if([[UIScreen mainScreen] bounds].size.height <= 480)
        [contenidorFormulari setFrame:CGRectMake(contenidorFormulari.frame.origin.x, -(MIN([sender frame].origin.y - 54, 79)) , contenidorFormulari.frame.size.width, contenidorFormulari.frame.size.height)];

	[UIView commitAnimations];

    if([sender tag] == SELECTOR_SOC_TAG)
    {
        [selectedLabelTextSoc setText:[(UILabel*)[selectorSoc viewForRow:indexSelectorSoc forComponent:0] text]];
    }
    else if([sender tag] == SELECTOR_EDAT_TAG)
    {
        [selectedLabelTextEdat setText:[NSString stringWithFormat:NSLocalizedString(@"%d i %d anys", @""), edatMinima, edatMaxima]];
    }
    else if([sender tag] == SELECTOR_PAIS_TAG)
    {
        [selectedLabelTextPais setText:[(UILabel*)[selectorPais viewForRow:indexSelectorPais forComponent:0] text]];
    }

}

- (IBAction)focalitzarLabel:(id)sender
{
    [self desfocalitzarSelectors];

	[UIView beginAnimations:@"focalitzarLabel" context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.35];

    if([[UIScreen mainScreen] bounds].size.height <= 480)
        [contenidorFormulari setFrame:CGRectMake(contenidorFormulari.frame.origin.x, -(MIN([sender frame].origin.y - 54, 79)) , contenidorFormulari.frame.size.width, contenidorFormulari.frame.size.height)];

	[UIView commitAnimations];
}

- (IBAction)goToNext
{
    [self desfocalitzarCamps];

    switch (currentStep)
    {
        case 0:
        {
                        [[KMRegisterData sharedInstance] setProfileType:[[NSNumber alloc] initWithInt:indexSelectorSoc]
                                                                 minAge:[[NSNumber alloc] initWithInt:edatMinima]
                                                                 maxAge:[[NSNumber alloc] initWithInt:edatMaxima]
                                                               birthday:[[NSNumber alloc] initWithInt:diaNaixement]
                                                             birthmonth:[[NSNumber alloc] initWithInt:mesNaixement]
                                                              birthyear:[[NSNumber alloc] initWithInt:anyNaixement]
                                                            countryCode:@"es"];

                        //Anar a la pantalla per indicar el sobrenom, contrassenya i correu
                        RegisterViewController *registerScreen = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController+AliasPasswordEmail" bundle:nil step:currentStep+1];
                        [self.navigationController pushViewController:registerScreen animated:YES];
        }
        break;

        case 1:
        {
                        //Anar a la pantalla per fer foto
                        RegisterViewController *photoScreen = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController+FrontPhoto" bundle:nil step:currentStep+1];
                        [self.navigationController pushViewController:photoScreen animated:YES];
        }
        break;
    }
}

- (IBAction)validarCamps
{
	//S'oculten els teclats
	[codiPostal resignFirstResponder];
	[sobrenom resignFirstResponder];
	[email resignFirstResponder];
	[contrassenya resignFirstResponder];

	//Es desplaça l'scrolll a la posició original
	[self desfocalitzarLabels];

	//S'eliminen els espais en blanc que hi pugui haver als camps email i contrassenya
	[email setText:[[email text] stringByReplacingOccurrencesOfString:@" " withString:@""]];
	[contrassenya setText:[[contrassenya text] stringByReplacingOccurrencesOfString:@" " withString:@""]];


	//Primer caldria validar que els camps entrats son correctes
	if(([[codiPostal text] isEqualToString:@""]) || ([[sobrenom text] isEqualToString:@""]) || ([[email text] isEqualToString:@""]) || ([[contrassenya text] isEqualToString:@""]))
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Login failed.", @"") message:NSLocalizedString(@"Siusplau, omple tots els camps.", @"") delegate:self
											  cancelButtonTitle:NSLocalizedString(@"Continuar", @"") otherButtonTitles:nil];
		[alert setTag:2]; //Tag 2 => Alerta d'error de camps no ben complerts
		[alert show];
	}
	else
	{
        [self goToNext];
//		[NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(ferRegistre) userInfo:nil repeats:NO];
	}
}

- (IBAction)iniciarFerRegistre
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] showKupidumTabBar];
}

- (void)ferRegistre
{
/*
	NSLocale *currentUsersLocale = [NSLocale currentLocale];
	NSString *locale = [currentUsersLocale localeIdentifier];

	NSLog(@"FerRegistre Nom:%@ Cognom:%@ Email:%@ Password:%@", nom.text, cognoms.text, email.text, contrassenya.text);

	VinthinkWS *vinthinkws = [[VinthinkWS alloc] init];

	VinthinkWSRegisterResponse *response = [vinthinkws Register:email.text:nom.text:cognoms.text:contrassenya.text:locale];

	NSLog(response.type);
	NSLog(response.error_code);
	NSLog(response.error_message);
	NSLog(response.user_id);

	//Amagar la caixa amb l'indicador rotatori
	[contenidorCarregant setHidden:YES];

	//Si hi ha hagut algun error es mostra el missatge d'error i el camp "usuari" recupera el focus
	if(([response.type isEqualToString:@"Error"]))
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Register failed.", @"") message:response.error_message delegate:self
											  cancelButtonTitle:NSLocalizedString(@"Continuar", @"") otherButtonTitles:nil];
		[alert setTag:1]; //Tag 1 => Alerta d'error de credencials
		[alert show];
	}
	else if((response.type == response.error_code) && (response.error_code == response.error_message))
	{
		NSLog(@"L'aplicació està experimentant problemes de connectivitat.");
		//Si s'entra aquí es degut a que hi ha problemes de connectivitat amb el servidor de Vinthink
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"L'aplicació està experimentant problemes de connectivitat.\n\nRevisa l'accés a Internet d'aquest dispositiu i torna-ho a intentar.", @"") delegate:self
											  cancelButtonTitle:NSLocalizedString(@"Continuar", @"") otherButtonTitles:nil];	
		[alert setTag:3]; //Tag 3 => Alerta d'error de falta de connectivitat
		[alert show];
		
		//S'amaga l'indicador rotatori, en el cas que aquest estigui visible
		[self stopLoadingIndicator];
	}		
	else
	{
		//Cal guardar les dades Username i UserID als defaults per tal de fer auto-login el pròxim cop que l'usuari obri l'aplicació.
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		[defaults setObject:response.user_id forKey:@"VinthinkTokenKey"];
		[defaults setObject:email.text forKey:@"VinthinkUsername"];
		[defaults setObject:nom.text forKey:@"VinthinkFirstname"];
		[defaults setObject:cognoms.text forKey:@"VinthinkLastname"];
		[defaults synchronize];

		//Autentificació autoritzada. S'inicia la sessió.
		[aplicacio iniciarSessioUsuariFormulariRegistre:response.user_id];

		//Es restaura la info del formulari
		[self restartData];
	}

	[self stopLoadingIndicator];
*/
}

- (IBAction)actualitzarCampDataNaixement
{
    [selectedLabelDataNaixement setText:[self getTextForSelectorDataNaixement]];

    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:selectorDataNaixement.date];
    diaNaixement = [components day];
    mesNaixement = [components month];
    anyNaixement = [components year];
}

- (void)restartData
{
	[labelTextEtsNou setText:NSLocalizedString(@"¿Ets nou? Omple el formulari i registra't!", @"")];
	[labelTextSoc setText:NSLocalizedString(@"Sóc", @"")];
	[labelTextEdatEntre setText:NSLocalizedString(@"Que tingui entre", @"")];
	[labelTextDataNaixement setText:NSLocalizedString(@"Vaig nèixer el", @"")];
	[labelTextPais setText:NSLocalizedString(@"Visc a", @"")];
	[buttonSeguent setTitle:NSLocalizedString(@"Següent", @"") forState:UIControlStateNormal];
	[buttonAccedir setTitle:NSLocalizedString(@"Accedir", @"") forState:UIControlStateNormal];

    [labelTextEsConfidencial setText:NSLocalizedString(@"No et preocupis, el teu email és confidencial", @"")];
    [labelTextCodiPostal setText:NSLocalizedString(@"El meu codi postal", @"")];
    [labelTextSobrenom setText:NSLocalizedString(@"El meu sobrenoml", @"")];
    [labelTextContrassenya setText:NSLocalizedString(@"La meva contrassenya", @"")];
    [labelTextEmail setText:NSLocalizedString(@"El meu email", @"")];

	[codiPostal setText:@""];
	[sobrenom setText:@""];
	[email setText:@""];
	[contrassenya setText:@""];

    [labelTextLaTevaFoto setText:NSLocalizedString(@"La teva foto és clau, somriu!", "")];
    [labelTextAfegirFoto setText:NSLocalizedString(@"afegir foto", @"")];

	[self stopLoadingIndicator];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if([alertView tag] == 1)
	{
		//Alerta corresponent al missatge d'error després d'entrar login i password
		//El camp "nom" ha de recuperar el focus amb el teclat desplegat
//		[nom becomeFirstResponder];
	}
	else if([alertView tag] == 2)
	{
		//Alerta corresponent per no completar tots els camps correctament
		if([[codiPostal text] isEqualToString:@""])			[codiPostal becomeFirstResponder];				//El camp nom recupera el fòcus
		else if([[sobrenom text] isEqualToString:@""])		[sobrenom becomeFirstResponder];			//El camp cognom recupera el fòcus
		else if([[contrassenya text] isEqualToString:@""])	[contrassenya becomeFirstResponder];			//El camp email recupera el fòcus
		else if([[email text] isEqualToString:@""])         [email becomeFirstResponder];	//El camp contrassenya recupera el fòcus
	}
	else if([alertView tag] == 3)
	{
		//Aquest cas es dona quan s'han detectat problemes de connectivitat
	}
	
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

	// Release any cached data, images, etc that aren't in use.
}

#pragma mark - PrivateMethods
- (void)showStep:(int)theCurrentStep
              of:(int)theTotalSteps
{
    UILabel *stepLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 75, 32)];
    [stepLabel setTextAlignment:NSTextAlignmentRight];
    [stepLabel setContentMode:UIViewContentModeScaleAspectFit];
    [stepLabel setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [stepLabel setText:[NSString stringWithFormat:NSLocalizedString(@"Pas %d/%d", @""), theCurrentStep, theTotalSteps]];
    [stepLabel setTextColor:[UIColor whiteColor]];
    [stepLabel setBackgroundColor:[UIColor clearColor]];
    [stepLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0f]];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:stepLabel]];
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

#pragma mark UIViewController delegate methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showNavigationBarButtons];
    [self showStep:currentStep+1 of:totalSteps];

    [logo setFrame:CGRectMake(logo.frame.origin.x, [[UIScreen mainScreen] bounds].size.height - self.navigationController.navigationBar.frame.size.height - [[UIApplication sharedApplication] statusBarFrame].size.height - logo.frame.size.height - 38.0, logo.frame.size.width, logo.frame.size.height)];
    [self desfocalitzarSelectors];

    [self setTitle:NSLocalizedString(@"Registre", @"")];
	[labelTextEtsNou setText:NSLocalizedString(@"¿Ets nou? Omple el formulari i registra't!", @"")];
	[labelTextSoc setText:NSLocalizedString(@"Sóc", @"")];
	[labelTextEdatEntre setText:NSLocalizedString(@"Que tingui entre", @"")];
	[labelTextDataNaixement setText:NSLocalizedString(@"Vaig nèixer el", @"")];
	[labelTextPais setText:NSLocalizedString(@"Visc a", @"")];
	[buttonSeguent setTitle:NSLocalizedString(@"Següent", @"") forState:UIControlStateNormal];
	[buttonAccedir setTitle:NSLocalizedString(@"Accedir", @"") forState:UIControlStateNormal];

	[self stopLoadingIndicator];

    selectorDataNaixement.maximumDate = [[ NSDate alloc ] initWithTimeIntervalSinceNow: (NSTimeInterval) (-18 * 365 * 24 * 60 * 60) ];

    [selectorSoc reloadAllComponents];
    [selectorEdat reloadAllComponents];
    [selectorPais reloadAllComponents];

    indexSelectorSoc = 0;
    [selectorSoc selectRow:indexSelectorSoc inComponent:0 animated:NO];
    [selectedLabelTextSoc setText:[self getTextForSelectorSocAtIndex:indexSelectorSoc]];

    edatMinima = 18;
    edatMaxima = 45;
    [selectorEdat selectRow:0 inComponent:0 animated:NO];
    [selectorEdat selectRow:(45 - 18) inComponent:1 animated:NO];
    [selectedLabelTextEdat setText:[NSString stringWithFormat:NSLocalizedString(@"%d i %d anys", @""), edatMinima, edatMaxima]];

    [selectedLabelDataNaixement setText:[self getTextForSelectorDataNaixement]];

    indexSelectorPais = 0;
    [selectorPais selectRow:indexSelectorPais inComponent:0 animated:NO];
    [selectedLabelTextPais setText:[self getTextForSelectorPaisAtIndex:indexSelectorSoc]];

	//[[NSTimer scheduledTimerWithTimeInterval:0.35 target:self selector:@selector(mostrarFinestraTermesCondicions) userInfo:nil repeats:NO] retain];
}

// called after this controller's view was dismissed, covered or otherwise hidden
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];

    [self desfocalitzarCamps];

	//S'oculten els teclats
	[codiPostal resignFirstResponder];
	[sobrenom resignFirstResponder];
	[email resignFirstResponder];
	[contrassenya resignFirstResponder];

	[UIView beginAnimations:@"focalitzarLabel" context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.15];
	
	[contenidorFormulari setFrame:CGRectMake(contenidorFormulari.frame.origin.x, 0, contenidorFormulari.frame.size.width, contenidorFormulari.frame.size.height)];
	
	[UIView commitAnimations];
	
}

// called after this controller's view will appear
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

    [selectorSoc reloadAllComponents];
    [selectorEdat reloadAllComponents];
    [selectorPais reloadAllComponents];
}

@end
