//
//  FinderViewController.h
//  kupidum
//
//  Created by Albert Nadal Garriga on 08/12/12.
//  Copyright 2012 Albert Nadal Garriga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "vinthinkAppDelegate.h"
#import "VinthinkWS.h"
#import "UserStatusTimeLine.h"
#import "UserProfileViewController.h"
#import "PlaceProfileViewController.h"
#import "StatusCommentsViewController.h"
#import "NearbyTableViewController.h"
#import "ChooseCountryViewController.h"
#import "ChoosePriceViewController.h"
#import "ChooseWineTypeViewController.h"
#import "ChooseDOViewController.h"
#import "ChooseGrapeViewController.h"
#import "SearchWinesViewController.h"
#import "WineSearchTableViewController.h"
#import "PlacesWithWinesSearchTableViewController.h"


@interface VinsViewController : UIViewController <CLLocationManagerDelegate, UIScrollViewDelegate, UIAlertViewDelegate, UISearchBarDelegate, UIActionSheetDelegate>
{
	IBOutlet vinthinkAppDelegate *aplicacio;

	IBOutlet UISearchBar *search_bar;

	IBOutlet UIPageControl *paginador;

	//Scroll horitzontal amb les seccions Timeline, Nearby i Notifications
	IBOutlet UIScrollView *scroll;
	IBOutlet UIView *vins_scroll_content;
	int previousPage;
	int page;

	//Botons del Subheader
	IBOutlet UIButton *boto_buscar;
	IBOutlet UIButton *boto_nearby;
	IBOutlet UIButton *boto_featured;


	//Boto per afegir un nou vi
	UIButton *boto_add_wine;

	//Taula on es mostren els contactes trobats
//	IBOutlet UITableView *tableView;
//	IBOutlet UITableViewController *tableViewController;

	//Dades de la sessió d'usuari
	NSString *user_id; //Id de l'usuari al sistema

	//Bloquejadors
	bool reloading;
	bool hi_ha_alertes_visibles;
	bool hi_ha_alerta_no_connectivitat;
	bool fent_transicio;

	//Contenidor "Swipe to other views"
	NSTimer *temporitzador;
	IBOutlet UIView *contenidor_swipe_to_other_views;

	//Boto Item inferior
	IBOutlet UITabBarItem *boto_item;

	//Selector de tipus de vi
	ChooseWineTypeViewController *choose_wine_type_controller;

	//Selector de preu
	ChoosePriceViewController *choose_price_controller;

	//Selector de pais
	ChooseCountryViewController *choose_country_controller;
	NSMutableDictionary *llista_paisos;

	//Selector de denominacio d'origen
	ChooseDOViewController *choose_do_controller;
	NSMutableArray *llista_paisos_dos;

	//Selector de varietats de raïm
	ChooseGrapeViewController *choose_grape_controller;
	NSMutableArray *llista_grapes;

	//Cercador de vins | Mostrador de resultats
	SearchWinesViewController *search_wines_controller;

	//Botons camps filtres
	IBOutlet UIButton *boto_pais;
	IBOutlet UIButton *boto_tipus_vi;
	IBOutlet UIButton *boto_preu;
	IBOutlet UIButton *boto_do;
	IBOutlet UIButton *boto_varietat;

	//Textos filtres
	IBOutlet UILabel *text_pais_escollit;
	IBOutlet UILabel *text_tipus_vi;
	IBOutlet UILabel *text_preu;
	IBOutlet UILabel *text_do;
	IBOutlet UILabel *text_varietat;

	//Filtres definits
	int id_pais;
	int id_grape;
	NSMutableArray *llista_preus;
	NSMutableArray *llista_tipus;
	NSMutableArray *llista_dos;

	//Llista de vins destacats (featured wines)
	UITableView *tableView;
	WineSearchTableViewController *tableViewController;
	NSMutableArray *llista_vins_featured;

	//Llista de vins propers
	CLLocationManager *locationManager;
	int intents_centrat;
	float usuari_latitude;
	float usuari_longitude;
	UITableView *placesTableView;
	PlacesWithWinesSearchTableViewController *placesTableViewController;
	NSMutableArray *llista_places_with_wines;

	//Contenidor indicador rotatori
	UIView *contenidor_indicador;
	UIActivityIndicatorView *indicador;
	UIImageView *bg_indicador;
}

- (void)initStartOperations;
- (NSString *)dateInFormat:(NSString*)stringFormat;
- (IBAction)showSelectorPaisos;
- (IBAction)showSelectorPreus;
- (IBAction)showSelectorTipusVi;
- (IBAction)showSelectorDO;
- (IBAction)showSelectorVarietat;
- (IBAction)subheaderPremut;
- (void)iniciarAmagarContenidorSwipe;
- (void)contenidorSwipeAmagat;
- (void)obtenirVinsDestacats;
- (void)obtenirPaisosAmbVins;
- (void)obtenirDenominacionsOrigen;
- (void)obtenirVarietatsDeRaim;
- (void)definirFiltreTipus:(NSMutableArray *)tipus:(NSString *)text_tipus;
- (void)definirFiltrePais:(int)i:(NSString *)nom;
- (void)definirFiltrePreus:(NSMutableArray *)preus:(NSString *)text_preus;
- (void)definirFiltreDO:(NSMutableArray *)dos:(NSString *)text_dos;
- (void)definirFiltreGrape:(int)i:(NSString *)nom;
- (void)mostrarResultatsVinsDestacats;
- (IBAction)cercarVins;
- (void)habilitarBotonsFiltre;
- (void)deshabilitarBotonsFiltre;
- (void)startLoadingIndicator;
- (void)stopLoadingIndicator;
- (void)restartData;
- (void)showWine:(NSString *)id_wine;
- (IBAction)ferReset;
- (NSMutableDictionary *)paisosAmbVins;
- (void)assignarPaisosAmbVins:(NSMutableDictionary *)paisos;
- (NSMutableArray *)paisosDO;
- (NSMutableArray *)llistaGrapes;
- (void)desbloquejarFerTransicio;
- (void)bloquejarFerTransicio;

@end
