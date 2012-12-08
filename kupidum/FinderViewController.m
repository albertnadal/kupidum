//
//  FinderViewController.m
//  kupidum
//
//  Created by Albert Nadal Garriga on 08/12/12.
//  Copyright 2012 Albert Nadal Garriga. All rights reserved.
//

@implementation VinsViewController

/*
- (void)initStartOperations
{
	//S'inicialitzen tots els filtres
	fent_transicio = false;
	hi_ha_alerta_no_connectivitat = false;
	hi_ha_alertes_visibles = false;
	intents_centrat = 3;
	id_pais = 0; //Tots els paisos
	llista_preus = [[NSMutableArray alloc] initWithCapacity:7];
	[llista_preus removeAllObjects]; //Tots els preus
	llista_dos = [[NSMutableArray alloc] init];

	[search_bar setText:@""];
	[search_bar setPlaceholder:NSLocalizedString(@"Sobrenom a cercar", @"")];

	for (UIView *searchBarSubview in [search_bar subviews]) {
		
		if ([searchBarSubview conformsToProtocol:@protocol(UITextInputTraits)]) {
			
			@try {
				
				[(UITextField *)searchBarSubview setReturnKeyType:UIReturnKeyDone];
			}
			@catch (NSException * e) {
				
				// ignore exception
			}
		}
	}


	//S'inicialitzen els textos dels botons dels filtres
	[boto_pais setTitle:NSLocalizedString(@"País", @"") forState:UIControlStateNormal];
	[boto_tipus_vi setTitle:NSLocalizedString(@"Tipus de vi", @"") forState:UIControlStateNormal];
	[boto_preu setTitle:NSLocalizedString(@"Preu", @"") forState:UIControlStateNormal];
	[boto_do setTitle:NSLocalizedString(@"D.O", @"") forState:UIControlStateNormal];
	[boto_varietat setTitle:NSLocalizedString(@"Varietat", @"") forState:UIControlStateNormal];	

	//Textos filtres
	[text_pais_escollit setText:NSLocalizedString(@"Tots els paisos", @"")];
	[text_tipus_vi setText:NSLocalizedString(@"Tots els tipus", @"")];
	[text_preu setText:NSLocalizedString(@"Tots els preus", @"")];
	[text_do setText:NSLocalizedString(@"Totes les denominacions", @"")];
	[text_varietat setText:NSLocalizedString(@"Totes les varietats", @"")];

	//S'initicialitzen les variables de control
	reloading = false;
	if(search_bar != nil)	[search_bar setText:@""];

	previousPage = 0; //D'entrada la pàgina inicial és la 0
	user_id = [[NSString alloc] initWithString:@""];
	[boto_item setTitle:NSLocalizedString(@"Vins", @"")];
	[vins_scroll_content removeFromSuperview];
	[scroll addSubview:vins_scroll_content];

//	[tableViewController initStartOperations];
//	[tableView setBackgroundColor: [UIColor colorWithRed:0.8862f green:0.9058f blue:0.9294f alpha:0.99]];

	//S'inicialitza l'scroll paginat
	[scroll setPagingEnabled:YES];
	[scroll setShowsVerticalScrollIndicator:NO];
	[scroll setShowsHorizontalScrollIndicator:NO];
	[scroll setContentSize:CGSizeMake(320 * 2, scroll.frame.size.height)];
	[scroll setContentOffset:CGPointMake(0.0,0.0) animated:NO]; //Es mou al top

	//Cal descarregar la llista de paisos que tenen vins
	[self obtenirPaisosAmbVins];

	//Cal descarregar les denominacions d'origen amb vins
	[self obtenirDenominacionsOrigen];

	//Cal descarregar les varietats de raïm
	[self obtenirVarietatsDeRaim];

	//Cal descarregar la llista de vins destacats
	//[self obtenirVinsDestacats];
	//[self iniciarActualitzarLlistaVinsPropers];

	//Es carrega el LocationManager per obtenir sempre l'última posició de l'usuari
	if(locationManager == nil)
	{
		locationManager = [[CLLocationManager alloc] init];
		locationManager.delegate = self;
		locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
		locationManager.distanceFilter = 1; //0 => Fa update sempre que pot de la posició GPS, 1 = > Fa update cada cada cop k el dispositiu es mou un metre
		[locationManager startUpdatingLocation];
	}

	[self stopLoadingIndicator];
}

- (NSMutableArray *)llistaGrapes
{
	return llista_grapes;
}

- (NSMutableArray *)paisosDO
{
	return llista_paisos_dos;
}

- (NSMutableDictionary *)paisosAmbVins
{
	return llista_paisos;
}

- (void)assignarPaisosAmbVins:(NSMutableDictionary *)paisos
{
	//Ara cal assignar la llistat d'estats rebuda al tableViewController
	if(llista_paisos == nil)
	{
		llista_paisos = [[NSMutableDictionary alloc] init];
	}
	
	[llista_paisos removeAllObjects];
	
	Pais *all_countries = [[Pais alloc] init];
	[all_countries setName:NSLocalizedString(@"Tots els paisos", @"")];
	[all_countries setCountryId:@"0"];
	[all_countries setCode:@""];
	[llista_paisos setObject:all_countries forKey:@"all"];
	
	for (NSString* key in paisos)
	{
		Pais *country = [[paisos objectForKey:key] clonar];
		[llista_paisos setObject: country forKey:key]; //key = [country code];
	}

}

- (void)showWine:(NSString *)id_wine
{
	//Crea una vista de tipus UserProfileView i la carrega a la pila de navegació
	NSString *user_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"VinthinkTokenKey"];
	
	WineProfileViewController *wine_profile = [[WineProfileViewController alloc] init];
	
	[wine_profile assignarAplicacio:aplicacio];	// <= Referència de l'aplicació
	[wine_profile assignarUserId:user_id];		// <= El nostre user_id
	[wine_profile assignarWineId:id_wine];		// <= L'id del vi que es vol mostrar
	[wine_profile startLoadingIndicator];
	
	self.title = NSLocalizedString(@"Nearby wines", @"");
	[self.navigationController pushViewController:wine_profile animated:YES];
	
	[[NSTimer scheduledTimerWithTimeInterval:0.001 target:wine_profile selector:@selector(initStartOperations) userInfo:nil repeats:NO] retain];
}

- (void)mostrarBotoAddWine
{
	if(boto_add_wine == nil)
	{
		boto_add_wine = [UIButton buttonWithType:UIButtonTypeCustom];
		[boto_add_wine setFrame:CGRectMake(265, 6.8, 49, 30)];
		[boto_add_wine setBackgroundImage:[UIImage imageNamed:@"boto_add_wine.png"] forState:UIControlStateNormal];
		[boto_add_wine setShowsTouchWhenHighlighted:NO];
		[boto_add_wine setTitle:NSLocalizedString(@"", @"") forState:UIControlStateNormal];
		[boto_add_wine setFont:[UIFont boldSystemFontOfSize:13.5f]];
		boto_add_wine.titleLabel.textAlignment = UITextAlignmentCenter;
		boto_add_wine.titleLabel.textColor = [UIColor whiteColor];
		boto_add_wine.titleLabel.shadowColor = [UIColor blackColor];
		boto_add_wine.titleLabel.shadowOffset = CGSizeMake(0, -1.0); 
		[self.navigationController.navigationBar addSubview:boto_add_wine];
		[self.navigationController.navigationBar bringSubviewToFront:boto_add_wine];
		//[boto_add_wine addTarget:self action:@selector(iniciarAfegirVi) forControlEvents:UIControlEventTouchUpInside];
	}

	if([boto_add_wine isHidden])
	{
		[boto_add_wine setHidden:NO];
		[boto_add_wine setAlpha:0.0001f];
		
		[UIView beginAnimations:@"mostrarBotoAddWine" context:NULL];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDuration:0.3];
		[boto_add_wine setAlpha:0.9999f];
		[UIView commitAnimations];
	}

	if(boto_add_wine != nil)
	{
		[boto_add_wine setEnabled:YES];
		[boto_add_wine setUserInteractionEnabled:YES];
	}
}

- (void)amagarBotoAddWine
{
	if(boto_add_wine != nil)
		[boto_add_wine setHidden:YES];
}

- (IBAction)ferReset
{
	[self startLoadingIndicator];
	[[NSTimer scheduledTimerWithTimeInterval:0.45 target:self selector:@selector(restartData) userInfo:nil repeats:NO] retain];
}

- (void)restartData
{
	reloading = false;
	hi_ha_alertes_visibles = false;
	hi_ha_alerta_no_connectivitat = false;

	[search_bar setText:@""];
	[search_bar resignFirstResponder];
	[scroll setScrollEnabled:YES];
	[self habilitarBotonsFiltre];

	//Es buida la taula amb el Timeline
//	if(tableViewController != nil)
//		[tableViewController restoreCache];
	
	//Es posiciona l'scroll content del TimeLine al top.
	[tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];

	//Ara cal fer restart dels diferents selectors de filtre

	//Restart del selector de tipus de vi
	[choose_wine_type_controller restartData];

	//Restart del selector de preu
	[choose_price_controller restartData];

	//Restart del selector de país
	[choose_country_controller restartData];

	//Restart del selector de denominació d'origen
	[choose_do_controller restartData];

	//Restart del selector de varietat de raïm
	[choose_grape_controller restartData];

	//S'amaga l'indicador rotatori
	[self stopLoadingIndicator];
}

- (void)startLoadingIndicator
{
	if(contenidor_indicador == nil)
	{
		contenidor_indicador = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
		//[contenidor_indicador setBackgroundColor:[UIColor lightGrayColor]];
		[contenidor_indicador setBackgroundColor:[UIColor colorWithRed:0.666f green:0.666f blue:0.666f alpha:0.6f]];
		
		if(bg_indicador == nil)
		{
			bg_indicador = [[UIImageView alloc] initWithFrame:CGRectMake((320 / 2) - (60 / 2), (367 / 2) - (60 / 2), 60, 60)];
			[bg_indicador setImage:[UIImage imageNamed:@"bg_indicador_rotatori.png"]];
			[bg_indicador setAlpha:0.8f];
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

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation: (CLLocation *)newLocation fromLocation: (CLLocation *)oldLocation
{
	NSLog(@"LAT: %f | LON: %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
	
	usuari_latitude = newLocation.coordinate.latitude;
	usuari_longitude = newLocation.coordinate.longitude;

	if(intents_centrat)
	{
		if(intents_centrat == 3)
		{
			// En pic s'obté la posició de l'usuari s'obté els cellers i events al voltant seu
			[[NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(iniciarActualitzarLlistaVinsPropers) userInfo:nil repeats:NO] retain];
		}
		
		intents_centrat--;
	}

}

- (void)iniciarActualitzarLlistaVinsPropers
{
	if(placesTableView == nil)
	{
		if(placesTableViewController != nil)
		{
			[placesTableViewController release];
			placesTableViewController = nil;
		}

		placesTableViewController = [[PlacesWithWinesSearchTableViewController alloc] init];
		[placesTableViewController assignarControlador:self];
		[placesTableViewController assignarAplicacio:aplicacio];

		placesTableView = [[UITableView alloc] initWithFrame:CGRectMake(320, 0, 320, 341) style:UITableViewStylePlain];
		placesTableView.separatorStyle = UITableViewCellSeparatorStyleNone; //S'amaga la linia separatòria
		[vins_scroll_content addSubview:placesTableView];

		[placesTableView setDelegate:placesTableViewController];
		[placesTableView setDataSource:placesTableViewController];
	}

	//Es buida qualsevol possible contingut llistat
	[placesTableViewController restoreCache];

	//Ara comença la descàrrega dels vins destacats de Vinthink

	NSLog(@"Iniciant: obtenirVinsPropersAUsuari");

	VinthinkWS *vinthinkws = [[VinthinkWS alloc] init];

	//NSString *user_id = @"ce34382d0d58a241833017d0c42f7b14"; //[[NSUserDefaults standardUserDefaults] objectForKey:@"VinthinkTokenKey"];
	NSString *user_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"VinthinkTokenKey"];

	VinthinkWSPlacesWineListResponse *response = [vinthinkws PlacesWineList:user_id:usuari_latitude:usuari_longitude:3];

	NSLog(response.type);
	NSLog(response.error_code);
	NSLog(response.error_message);

	//Si hi ha hagut algun error es mostra el missatge d'error i el camp "usuari" recupera el focus
	if(([response.type isEqualToString:@"Error"]))
	{
		if(!hi_ha_alertes_visibles)
		{
			hi_ha_alertes_visibles = true;
			
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error retrieving nearby wines", @"") message:response.error_message delegate:self
											  cancelButtonTitle:NSLocalizedString(@"Continuar", @"") otherButtonTitles:nil];
			[alert setTag:1]; //Tag 1 => Alerta d'error de credencials
			[alert show];
			[alert release];
		}

		//Hi ha hagut un error. Es farà Logout de la sessió i es tornarà a començar.
		return;
	}
	else if((response.type == response.error_code) && (response.error_code == response.error_message))
	{
		NSLog(@"L'aplicació està experimentant problemes de connectivitat.");
		//Si s'entra aquí es degut a que hi ha problemes de connectivitat amb el servidor de Vinthink

		if(!hi_ha_alerta_no_connectivitat)
		{
			hi_ha_alerta_no_connectivitat = true;
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"L'aplicació està experimentant problemes de connectivitat.\n\nRevisa l'accés a Internet d'aquest dispositiu i torna-ho a intentar.", @"") delegate:self
												  cancelButtonTitle:NSLocalizedString(@"Continuar", @"") otherButtonTitles:nil];	
			[alert setTag:3]; //Tag 3 => Alerta d'error de falta de connectivitat
			[alert show];
			[alert release];
		}
	}	
	else
	{
		//Ara cal assignar la llistat d'estats rebuda al tableViewController
		if(llista_places_with_wines == nil)
		{
			llista_places_with_wines = [[NSMutableArray alloc] init];
		}

		[llista_places_with_wines removeAllObjects];

		for(int i=0; i<[response.places_with_wines count]; i++)
		{
			PlaceWithWines *place = [response.places_with_wines objectAtIndex:i];
			[llista_places_with_wines addObject:place];
		}

		//S'obté el total de resultats que ha generat la querie
	}

	[vinthinkws release];

	NSLog(@"Fi: obtenirVinsPropersAUsuari");

	//[tableViewController assignarTextFooter:@""]; //[NSString stringWithFormat:@"%@ %@", ordenats_per, ordenats_en_ordre]];
	[[NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(mostrarResultatsVinsPropers) userInfo:nil repeats:NO] retain];

}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	NSLog(@"Error en obtenir posició");
	//Mostrar missatge d'avís!
}

- (void)habilitarBotonsFiltre
{
	[boto_pais setEnabled:YES];
	[boto_tipus_vi setEnabled:YES];
	[boto_preu setEnabled:YES];
	[boto_do setEnabled:YES];
	[boto_varietat setEnabled:YES];

	[boto_pais setUserInteractionEnabled:YES];
	[boto_tipus_vi setUserInteractionEnabled:YES];
	[boto_preu setUserInteractionEnabled:YES];
	[boto_do setUserInteractionEnabled:YES];
	[boto_varietat setUserInteractionEnabled:YES];
}

- (void)deshabilitarBotonsFiltre
{
	[boto_pais setEnabled:FALSE];
	[boto_tipus_vi setEnabled:FALSE];
	[boto_preu setEnabled:FALSE];
	[boto_do setEnabled:FALSE];
	[boto_varietat setEnabled:FALSE];

	[boto_pais setUserInteractionEnabled:FALSE];
	[boto_tipus_vi setUserInteractionEnabled:FALSE];
	[boto_preu setUserInteractionEnabled:FALSE];
	[boto_do setUserInteractionEnabled:FALSE];
	[boto_varietat setUserInteractionEnabled:FALSE];	
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
	//[search_bar setText:@""];
	[scroll setScrollEnabled:NO];
	[self deshabilitarBotonsFiltre];

	//[search_bar becomeFirstResponder];

	return true;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	//[search_bar setText:@""];
	[search_bar resignFirstResponder];
	[scroll setScrollEnabled:YES];
	[self habilitarBotonsFiltre];

	[search_bar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	[search_bar resignFirstResponder];
	[scroll setScrollEnabled:YES];
	[self habilitarBotonsFiltre];

	[search_bar resignFirstResponder];

	//[[NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(iniciarCercaUbicacioManual) userInfo:nil repeats:NO] retain];
}

- (void)definirFiltreGrape:(int)i:(NSString *)nom
{
	id_grape = i;
	[text_varietat setText:nom];
}

- (void)definirFiltreDO:(NSMutableArray *)dos:(NSString *)text_dos
{
	if(llista_dos == nil)
		llista_dos = [[NSMutableArray alloc] init];

	[llista_dos removeAllObjects];

	for(int i=0; i<[dos count]; i++)
	{
		PairValueCheck *pair = [dos objectAtIndex:i];
		int id_do = [[pair do_id] intValue];
		[llista_dos addObject:[NSNumber numberWithLong:id_do]];
	}

	[text_do setText:text_dos];
}

- (void)definirFiltreTipus:(NSMutableArray *)tipus:(NSString *)text_tipus
{
	if(llista_tipus == nil)
		llista_tipus = [[NSMutableArray alloc] init];

	[llista_tipus removeAllObjects];

	for(int i=0; i<[tipus count]; i++)
		[llista_tipus addObject:[NSNumber numberWithLong:[[tipus objectAtIndex:i] longValue]]];

	[text_tipus_vi setText:text_tipus];	
}

- (void)definirFiltrePreus:(NSMutableArray *)preus:(NSString *)text_preus
{
	if(llista_preus == nil)
		llista_preus = [[NSMutableArray alloc] init];

	[llista_preus removeAllObjects];

	for(int i=0; i<[preus count]; i++)
		[llista_preus addObject:[NSNumber numberWithLong:[[preus objectAtIndex:i] longValue]]];

	[text_preu setText:text_preus];
}

- (void)definirFiltrePais:(int)i:(NSString *)nom
{
	id_pais = i;
	[text_pais_escollit setText:nom];
}

- (void)obtenirVinsDestacats
{
	if(tableView == nil)
	{
		if(tableViewController != nil)
		{
			[tableViewController release];
			tableViewController = nil;
		}
		
		tableViewController = [[WineSearchTableViewController alloc] init];
		[tableViewController disableModeEliminar];
		[tableViewController assignarControlador:self];
		[tableViewController assignarAplicacio:aplicacio];

		tableView = [[UITableView alloc] initWithFrame:CGRectMake(640, 0, 320, 341) style:UITableViewStylePlain];
		tableView.separatorStyle = UITableViewCellSeparatorStyleNone; //S'amaga la linia separatòria
		[self.view addSubview:tableView];
		
		[tableView setDelegate:tableViewController];
		[tableView setDataSource:tableViewController];
	}
	
	//Es buida qualsevol possible contingut llistat
	[tableViewController restoreCache];

	//Ara comença la descàrrega dels vins destacats de Vinthink

	NSLog(@"Iniciant: obtenirVinsDestacats");

	VinthinkWS *vinthinkws = [[VinthinkWS alloc] init];

	NSString *user_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"VinthinkTokenKey"];
	//NSString *user_id = @"ce34382d0d58a241833017d0c42f7b14"; //[[NSUserDefaults standardUserDefaults] objectForKey:@"VinthinkTokenKey"];

	VinthinkWSWineFeaturedResponse *response = [vinthinkws WineFeatured:user_id];

	NSLog(response.type);
	NSLog(response.error_code);
	NSLog(response.error_message);

	//Si hi ha hagut algun error es mostra el missatge d'error i el camp "usuari" recupera el focus
	if(([response.type isEqualToString:@"Error"]))
	{
		if(!hi_ha_alertes_visibles)
		{
			hi_ha_alertes_visibles = true;

			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error retrieving featured wines", @"") message:response.error_message delegate:self
											  cancelButtonTitle:NSLocalizedString(@"Continuar", @"") otherButtonTitles:nil];
			[alert setTag:1]; //Tag 1 => Alerta d'error de credencials
			[alert show];
			[alert release];
		}

		return;
	}
	else if((response.type == response.error_code) && (response.error_code == response.error_message))
	{
		NSLog(@"L'aplicació està experimentant problemes de connectivitat.");
		//Si s'entra aquí es degut a que hi ha problemes de connectivitat amb el servidor de Vinthink

		if(!hi_ha_alerta_no_connectivitat)
		{
			hi_ha_alerta_no_connectivitat = true;
			
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"L'aplicació està experimentant problemes de connectivitat.\n\nRevisa l'accés a Internet d'aquest dispositiu i torna-ho a intentar.", @"") delegate:self
											  cancelButtonTitle:NSLocalizedString(@"Continuar", @"") otherButtonTitles:nil];	
			[alert setTag:3]; //Tag 3 => Alerta d'error de falta de connectivitat
			[alert show];
			[alert release];
		}
	}
	else
	{
		//Ara cal assignar la llistat d'estats rebuda al tableViewController
		if(llista_vins_featured == nil)
		{
			llista_vins_featured = [[NSMutableArray alloc] init];
		}

		[llista_vins_featured removeAllObjects];

		for(int i=0; i<[response.wines count]; i++)
		{
			WineSearch *wine = [response.wines objectAtIndex:i];
			[llista_vins_featured addObject:wine];
		}
		
		//S'obté el total de resultats que ha generat la querie
		[tableViewController assignarTotalResultats:[response obtenirTotalCount]];
	}
	
	[vinthinkws release];
	
	NSLog(@"Fi: obtenirVinsDestacats");
	
	[tableViewController assignarTextFooter:@""]; //[NSString stringWithFormat:@"%@ %@", ordenats_per, ordenats_en_ordre]];
	
	[[NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(mostrarResultatsVinsDestacats) userInfo:nil repeats:NO] retain];
	
}

- (void)mostrarResultatsVinsDestacats
{
	[tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
	
	[tableViewController setVins:llista_vins_featured];
	[tableView reloadData];
}

- (void)mostrarResultatsVinsPropers
{
	[placesTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
	
	[placesTableViewController setPlaces:llista_places_with_wines];
	[placesTableView reloadData];
}

- (void)obtenirDenominacionsOrigen
{
	NSLog(@"Iniciant: obtenirDenominacionsOrigen");

	VinthinkWS *vinthinkws = [[VinthinkWS alloc] init];

	NSString *user_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"VinthinkTokenKey"];
	//NSString *user_id = @"ce34382d0d58a241833017d0c42f7b14"; //[[NSUserDefaults standardUserDefaults] objectForKey:@"VinthinkTokenKey"];

	VinthinkWSPDOCountryResponse *response = [vinthinkws PDOCountry:user_id];

	NSLog(response.type);
	NSLog(response.error_code);
	NSLog(response.error_message);

	//Si hi ha hagut algun error es mostra el missatge d'error i el camp "usuari" recupera el focus
	if(([response.type isEqualToString:@"Error"]))
	{
		if(!hi_ha_alertes_visibles)
		{
			hi_ha_alertes_visibles = true;

			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error retrieving D.O,", @"") message:response.error_message delegate:self
											  cancelButtonTitle:NSLocalizedString(@"Continuar", @"") otherButtonTitles:nil];
			[alert setTag:1]; //Tag 1 => Alerta d'error de credencials
			[alert show];
			[alert release];
		}

		return;
	}
	else if((response.type == response.error_code) && (response.error_code == response.error_message))
	{
		NSLog(@"L'aplicació està experimentant problemes de connectivitat.");
		//Si s'entra aquí es degut a que hi ha problemes de connectivitat amb el servidor de Vinthink
	
		if(!hi_ha_alerta_no_connectivitat)
		{
			hi_ha_alerta_no_connectivitat = true;
			
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"L'aplicació està experimentant problemes de connectivitat.\n\nRevisa l'accés a Internet d'aquest dispositiu i torna-ho a intentar.", @"") delegate:self
											  cancelButtonTitle:NSLocalizedString(@"Continuar", @"") otherButtonTitles:nil];	
			[alert setTag:3]; //Tag 3 => Alerta d'error de falta de connectivitat
			[alert show];
			[alert release];
		}
	}
	else
	{
		//Ara cal assignar la llistat d'estats rebuda al tableViewController
		if(llista_paisos_dos == nil)
		{
			llista_paisos_dos = [[NSMutableArray alloc] init];
		}
		
		[llista_paisos_dos removeAllObjects];

		for(int i=0; i<[response.countries count]; i++)
		{
			PaisDO *country = [response.countries objectAtIndex:i];
			[llista_paisos_dos addObject:country];
		}		
	}
	
	[vinthinkws release];
	
	NSLog(@"Fi: obtenirDenominacionsOrigen");	
}

- (void)obtenirVarietatsDeRaim
{
	NSLog(@"Iniciant: obtenirGrapes");
	
	VinthinkWS *vinthinkws = [[VinthinkWS alloc] init];

	NSString *user_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"VinthinkTokenKey"];
	//NSString *user_id = @"ce34382d0d58a241833017d0c42f7b14"; //[[NSUserDefaults standardUserDefaults] objectForKey:@"VinthinkTokenKey"];

	VinthinkWSGrapesResponse *response = [vinthinkws Grapes:user_id];
	
	NSLog(response.type);
	NSLog(response.error_code);
	NSLog(response.error_message);
	
	//Si hi ha hagut algun error es mostra el missatge d'error i el camp "usuari" recupera el focus
	if(([response.type isEqualToString:@"Error"]))
	{
		if(!hi_ha_alertes_visibles)
		{
			hi_ha_alertes_visibles = true;
			
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error retrieving Grapes,", @"") message:response.error_message delegate:self
											  cancelButtonTitle:NSLocalizedString(@"Continuar", @"") otherButtonTitles:nil];
			[alert setTag:1]; //Tag 1 => Alerta d'error de credencials
			[alert show];
			[alert release];
		}

		return;
	}
	else if((response.type == response.error_code) && (response.error_code == response.error_message))
	{
		NSLog(@"L'aplicació està experimentant problemes de connectivitat.");
		//Si s'entra aquí es degut a que hi ha problemes de connectivitat amb el servidor de Vinthink

		if(!hi_ha_alerta_no_connectivitat)
		{
			hi_ha_alerta_no_connectivitat = true;

			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"L'aplicació està experimentant problemes de connectivitat.\n\nRevisa l'accés a Internet d'aquest dispositiu i torna-ho a intentar.", @"") delegate:self
											  cancelButtonTitle:NSLocalizedString(@"Continuar", @"") otherButtonTitles:nil];	
			[alert setTag:3]; //Tag 3 => Alerta d'error de falta de connectivitat
			[alert show];
			[alert release];
		}
	}	
	else
	{
		//Ara cal assignar la llistat d'estats rebuda al tableViewController
		if(llista_grapes == nil)
		{
			llista_grapes = [[NSMutableArray alloc] init];
		}

		[llista_grapes removeAllObjects];

		GrapeClass *all_grapes = [[GrapeClass alloc] init];
		[all_grapes setName:NSLocalizedString(@"Totes les varietats", @"")];
		[all_grapes setGrapeId:@"0"];
		[llista_grapes addObject:all_grapes];

		for(int i=0; i<[response.grapes count]; i++)
		{
			GrapeClass *grape = [response.grapes objectAtIndex:i];
			[llista_grapes addObject:grape]; //setObject: grape forKey:[grape name]];
		}
	}

	[vinthinkws release];

	NSLog(@"Fi: obtenirGrapes");
}

- (void)obtenirPaisosAmbVins
{
	NSLog(@"Iniciant: obtenirPaisosAmbVins");

	VinthinkWS *vinthinkws = [[VinthinkWS alloc] init];

	NSString *user_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"VinthinkTokenKey"];
	//NSString *user_id = @"ce34382d0d58a241833017d0c42f7b14"; //[[NSUserDefaults standardUserDefaults] objectForKey:@"VinthinkTokenKey"];

	VinthinkWSGetCountriesWithWinesResponse *response = [vinthinkws GetCountriesWithWines:user_id];
	
	NSLog(response.type);
	NSLog(response.error_code);
	NSLog(response.error_message);
	
	//Si hi ha hagut algun error es mostra el missatge d'error i el camp "usuari" recupera el focus
	if(([response.type isEqualToString:@"Error"]))
	{
		if(!hi_ha_alertes_visibles)
		{
			hi_ha_alertes_visibles = true;

			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error retrieving Countries,", @"") message:response.error_message delegate:self
											  cancelButtonTitle:NSLocalizedString(@"Continuar", @"") otherButtonTitles:nil];
			[alert setTag:1]; //Tag 1 => Alerta d'error de credencials
			[alert show];
			[alert release];
		}

		return;
	}
	else if((response.type == response.error_code) && (response.error_code == response.error_message))
	{
		NSLog(@"L'aplicació està experimentant problemes de connectivitat.");
		//Si s'entra aquí es degut a que hi ha problemes de connectivitat amb el servidor de Vinthink

		if(!hi_ha_alerta_no_connectivitat)
		{
			hi_ha_alerta_no_connectivitat = true;
			
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"L'aplicació està experimentant problemes de connectivitat.\n\nRevisa l'accés a Internet d'aquest dispositiu i torna-ho a intentar.", @"") delegate:self
											  cancelButtonTitle:NSLocalizedString(@"Continuar", @"") otherButtonTitles:nil];	
			[alert setTag:3]; //Tag 3 => Alerta d'error de falta de connectivitat
			[alert show];
			[alert release];
		}
	}	
	else
	{
		//Ara cal assignar la llistat d'estats rebuda al tableViewController
		if(llista_paisos == nil)
		{
			llista_paisos = [[NSMutableDictionary alloc] init];
		}

		[llista_paisos removeAllObjects];

		Pais *all_countries = [[Pais alloc] init];
		[all_countries setName:NSLocalizedString(@"Tots els paisos", @"")];
		[all_countries setCountryId:@"0"];
		[all_countries setCode:@""];
		[llista_paisos setObject:all_countries forKey:@"all"];

		for(int i=0; i<[response.countries count]; i++)
		{
			Pais *country = [response.countries objectAtIndex:i];
			[llista_paisos setObject: country forKey:[country code]];
		}		
	}

	[vinthinkws release];
	
	NSLog(@"Fi: obtenirPaisosAmbVins");
}

- (IBAction)cercarVins
{
	//Crea una vista de tipus UserProfileView i la carrega a la pila de navegació
	NSString *user_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"VinthinkTokenKey"];
	//NSString *user_id = @"ce34382d0d58a241833017d0c42f7b14"; //[[NSUserDefaults standardUserDefaults] objectForKey:@"VinthinkTokenKey"];

	if(search_wines_controller == nil)
	{
		search_wines_controller = [[SearchWinesViewController alloc] init];
		[search_wines_controller assignarControlador:self];
		[search_wines_controller assignarAplicacio:aplicacio];
	}

	NSLog(@"Assignant títol Cercar");
	self.title = NSLocalizedString(@"Filtres", @"");
	NSLog(@" - OK1");

	[search_wines_controller initStartOperations];
	NSLog(@" - OK2");

	[search_wines_controller assignarTextCerca:[search_bar text]];
	NSLog(@" - OK3");
	[search_wines_controller assignarPreus:llista_preus];
	[search_wines_controller assignarTipus:llista_tipus];
	[search_wines_controller assignarDO:llista_dos];
	[search_wines_controller assignarIdPais:id_pais];
	[search_wines_controller assignarIdGrape:id_grape];
	NSLog(@" - OK4");

	[self.navigationController pushViewController:search_wines_controller animated:YES];
	[search_wines_controller amagarBotoNavBarAsc];
	[search_wines_controller mostrarBotoNavBarDesc];

	NSLog(@" - OK5");

	[search_wines_controller startLoadingIndicator];
	[[NSTimer scheduledTimerWithTimeInterval:0.1 target:search_wines_controller selector:@selector(startSearch) userInfo:nil repeats:NO] retain];
	NSLog(@" - OK6");
}

- (IBAction)showSelectorDO
{
	//Crea una vista de tipus UserProfileView i la carrega a la pila de navegació
	NSString *user_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"VinthinkTokenKey"];
	//NSString *user_id = @"ce34382d0d58a241833017d0c42f7b14"; //[[NSUserDefaults standardUserDefaults] objectForKey:@"VinthinkTokenKey"];

	if(choose_do_controller == nil)
	{
		choose_do_controller = [[ChooseDOViewController alloc] init];
		[choose_do_controller setEsMultiple:YES];
		[choose_do_controller assignarControlador:self];
	}

	self.title = @"";
	[choose_do_controller initStartOperations];
	[choose_do_controller assignarPaisosDos:llista_paisos_dos];

	[self.navigationController pushViewController:choose_do_controller animated:YES];	
}

- (IBAction)showSelectorTipusVi
{
	//Crea una vista de tipus UserProfileView i la carrega a la pila de navegació
	NSString *user_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"VinthinkTokenKey"];
	//NSString *user_id = @"ce34382d0d58a241833017d0c42f7b14"; //[[NSUserDefaults standardUserDefaults] objectForKey:@"VinthinkTokenKey"];
	
	if(choose_wine_type_controller == nil)
	{
		choose_wine_type_controller = [[ChooseWineTypeViewController alloc] init];
		[choose_wine_type_controller setEsMultiple:YES];
		[choose_wine_type_controller assignarControlador:self];
	}
	
	self.title = @"";
	[choose_wine_type_controller initStartOperations];
	[self.navigationController pushViewController:choose_wine_type_controller animated:YES];	
}

- (IBAction)showSelectorPreus
{
	//Crea una vista de tipus UserProfileView i la carrega a la pila de navegació
	NSString *user_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"VinthinkTokenKey"];
	//NSString *user_id = @"ce34382d0d58a241833017d0c42f7b14"; //[[NSUserDefaults standardUserDefaults] objectForKey:@"VinthinkTokenKey"];
	
	if(choose_price_controller == nil)
	{
		choose_price_controller = [[ChoosePriceViewController alloc] init];
		[choose_price_controller setEsMultiple:YES];
		[choose_price_controller assignarControlador:self];
	}

	self.title = @"";
	[choose_price_controller initStartOperations];
	[self.navigationController pushViewController:choose_price_controller animated:YES];
	
}

- (IBAction)showSelectorVarietat
{
	//Crea una vista de tipus UserProfileView i la carrega a la pila de navegació
	NSString *user_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"VinthinkTokenKey"];
	//NSString *user_id = @"ce34382d0d58a241833017d0c42f7b14"; //[[NSUserDefaults standardUserDefaults] objectForKey:@"VinthinkTokenKey"];
	
	if(choose_grape_controller == nil)
	{
		choose_grape_controller = [[ChooseGrapeViewController alloc] init];
		[choose_grape_controller setEsMultiple:YES];
		[choose_grape_controller assignarControlador:self];
		[choose_grape_controller assignarGrapes:llista_grapes];
	}
	
	//[selector_country assignarUserId:user_id];		// <= El nostre user_id
	//[selector_country assignarUsernameProfile:u];	// <= Usuari del qual es vol obtenir el profile

	self.title = @""; //NSLocalizedString(@"", @"");
	[choose_grape_controller initStartOperations];
	[self.navigationController pushViewController:choose_grape_controller animated:YES];
	
	//	[[NSTimer scheduledTimerWithTimeInterval:0.001 target:selector_country selector:@selector(initStartOperations) userInfo:nil repeats:NO] retain];	
}

- (IBAction)showSelectorPaisos
{
	//Crea una vista de tipus UserProfileView i la carrega a la pila de navegació
	//NSString *user_id = @"ce34382d0d58a241833017d0c42f7b14"; //[[NSUserDefaults standardUserDefaults] objectForKey:@"VinthinkTokenKey"];
	NSString *user_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"VinthinkTokenKey"];

	if(choose_country_controller == nil)
	{
		choose_country_controller = [[ChooseCountryViewController alloc] init];
		[choose_country_controller setEsMultiple:NO];
		[choose_country_controller assignarControlador:self];
		[choose_country_controller assignarPaisos:llista_paisos];
	}

	//[selector_country assignarUserId:user_id];		// <= El nostre user_id
	//[selector_country assignarUsernameProfile:u];	// <= Usuari del qual es vol obtenir el profile

	self.title = @""; //NSLocalizedString(@"", @"");
	[choose_country_controller initStartOperations];
	[self.navigationController pushViewController:choose_country_controller animated:YES];

//	[[NSTimer scheduledTimerWithTimeInterval:0.001 target:selector_country selector:@selector(initStartOperations) userInfo:nil repeats:NO] retain];
}

- (void)iniciarMostrarMenuAfegirEstat
{
	UIActionSheet *successActionSheet = [[[UIActionSheet alloc] initWithTitle:nil 
																	 delegate:self 
															cancelButtonTitle:NSLocalizedString(@"Cancel·lar", @"")
													   destructiveButtonTitle:nil 
															otherButtonTitles:NSLocalizedString(@"Fer el tast d'un vi", @""), NSLocalizedString(@"Fer un Vink!", @""), NSLocalizedString(@"Publicar una nota", @""), NSLocalizedString(@"Recomanar un vi", @""), nil] autorelease];
	[successActionSheet setOpaque:NO];
	[successActionSheet setAlpha:0.999];
	[successActionSheet setTag:1];
	[successActionSheet showInView:self.view];
	[successActionSheet showFromToolbar:[[self navigationController] toolbar]]; //[[self naviController] toolbar]];	
}

- (void)iniciarMostrarMenuCercador
{
	UIActionSheet *successActionSheet = [[[UIActionSheet alloc] initWithTitle:nil 
																	 delegate:self 
															cancelButtonTitle:NSLocalizedString(@"Cancel·lar", @"")
													   destructiveButtonTitle:nil 
															otherButtonTitles:NSLocalizedString(@"Buscar cerca de mi", @""), NSLocalizedString(@"Buscar en otra ubicación", @""), nil] autorelease];
	[successActionSheet setOpaque:NO];
	[successActionSheet setAlpha:0.999];
	[successActionSheet setTag:2];
	[successActionSheet showInView:self.view];
	[successActionSheet showFromToolbar:[[self navigationController] toolbar]]; //[[self naviController] toolbar]];
}

- (void)iniciarMostrarCercadorUbicacioMapa
{

}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex  
{
	if([alertView tag] == 1)
	{
		//Error de credencials. Cal fer un Logout de la sessió i mostrar la pantalla d'escollir la forma de fer LogIn de Vinthink
		[[NSTimer scheduledTimerWithTimeInterval:0.001 target:aplicacio selector:@selector(ferLogout) userInfo:nil repeats:NO] retain];
	}
	else if([alertView tag] == 3)
	{
		//Aquest cas es dona quan s'han detectat problemes de connectivitat
		hi_ha_alerta_no_connectivitat = false; //Es desactiva el desbloquejador
	}

} 

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{

}

- (void)iniciarMostrarModeLlista
{

}

- (void)iniciarCercaProximaUsuari
{
//	[self desactivarModeCerca];
//	[self centrarMapaPosicioUsuari];
}

- (void)centrarMapaPosicioUsuari
{

}

- (void)centrarMapaPosicioCercaUsuari
{

}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{

}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
	//[mapView removeAnnotations:[mapView annotations]];
}

- (IBAction)subheaderPremut
{
	if(temporitzador != nil)
	{
		//Si el temportizador ja està en marxa s'atura per tornar-lo a arrencar
		[temporitzador invalidate];
	}

	[contenidor_swipe_to_other_views setAlpha:1.0];
	[contenidor_swipe_to_other_views setHidden:NO];

	temporitzador = [[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(iniciarAmagarContenidorSwipe) userInfo:nil repeats:NO] retain];
}

- (void)iniciarAmagarContenidorSwipe
{
	[UIView beginAnimations:@"theSwipeAnimation" context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(contenidorSwipeAmagat)];
	[UIView setAnimationDuration:0.8];
	[contenidor_swipe_to_other_views setAlpha:0.0];
	[UIView commitAnimations];
}

- (void)contenidorSwipeAmagat
{
	[contenidor_swipe_to_other_views setHidden:YES];

	if(temporitzador != nil)
	{
		[temporitzador release];
		temporitzador = nil;
	}
}

- (void)desbloquejarFerTransicio
{
	fent_transicio = false;
}

- (void)bloquejarFerTransicio
{
	fent_transicio = true;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    page = lround(fractionalPage);

	if((scrollView.contentOffset.x <= 0) || (scrollView.contentOffset.x == 320 * 1) || (scrollView.contentOffset.x >= 320 * 2))
	{
		if(fent_transicio)
		{
			[UIView beginAnimations:@"transicioEntreVistesVinthink" context:NULL];
			[UIView setAnimationDelegate:self];
			[UIView setAnimationDidStopSelector:@selector(desbloquejarFerTransicio)];
			[UIView setAnimationDuration:0.15];
			
			CGAffineTransform zooming = CGAffineTransformMakeScale(1.0, 1.0);
			vins_scroll_content.transform = zooming;
			
			[UIView commitAnimations];
			//fent_transicio = false;
		}
	}
	else
	{
		if(!fent_transicio)
		{
			[UIView beginAnimations:@"transicioEntreVistesVinthink" context:NULL];
			[UIView setAnimationDelegate:self];
			[UIView setAnimationDidStopSelector:@selector(bloquejarFerTransicio)];
			[UIView setAnimationDuration:0.15];
			
			CGAffineTransform zooming = CGAffineTransformMakeScale(0.9, 0.9);
			vins_scroll_content.transform = zooming;
			
			[UIView commitAnimations];
			//fent_transicio = true;
		}
	}

    if (previousPage != page)
	{
		//Hi ha canvi de pàgina
		previousPage = page;

		//S'amaguen els corresponents botons de la barra de navegació


		//Es posa el tamany dels textos de la barra subheader a tamany unselected per defecte
		[boto_buscar.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
		[boto_nearby.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
		[boto_featured.titleLabel setFont:[UIFont systemFontOfSize:15.0]];

		UIButton *boto_selected;

		switch(page)
		{
			case 0:		//Vista TimeLine
						boto_selected = boto_buscar;
						//[self mostrarBotoNavBarAddStatus];
						break;

			case 1:		//Vista Nearby
						boto_selected = boto_nearby;
						//[self mostrarBotoNavBarNearby];
						//[self mostrarBotoNavBarSearch];
						break;

			case 2:		//Vista Notificacions
						boto_selected = boto_featured;
						break;

			default:	boto_selected = boto_buscar;
						break;
		}

		[paginador setCurrentPage:page];

		[boto_selected.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
    }
}

- (bool)isReloading
{
	return reloading;
}

- (NSString *)dateInFormat:(NSString*)stringFormat
{
	char buffer[80];
	const char *format = [stringFormat UTF8String];
	time_t rawtime;
	struct tm * timeinfo;
	time(&rawtime);
	timeinfo = localtime(&rawtime);
	strftime(buffer, 80, format, timeinfo);
	return [NSString  stringWithCString:buffer encoding:NSUTF8StringEncoding];
}

- (void)assignarUserId:(NSString *)u
{
	user_id = [[NSString alloc] initWithString:u];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

#pragma mark UIViewController delegate methods

// called after this controller's view was dismissed, covered or otherwise hidden
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[boto_item setTitle:NSLocalizedString(@"Vins", @"")];

	[self amagarBotoAddWine];
}

// called after this controller's view will appear
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	self.title = @" ";
	[boto_item setTitle:NSLocalizedString(@"Vins", @"")];

	[self amagarBotoAddWine];

	switch(page)
	{
		case 0:		//Vista amb els filtres per cercar vins. Mostrar el botó per afegir un nou vi. 
					[self mostrarBotoAddWine];
					break;

		case 1:		//Vista amb els vins propers a l'usuari
					break;

		case 2:		//Vista Notificacions
					break;
	}

}

- (void)dealloc {
    [super dealloc];
}
*/
@end
