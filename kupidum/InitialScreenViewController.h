//
//  FirstViewController.h
//  kupidum
//
//  Created by Albert Nadal Garriga on 18/11/12.
//  Copyright (c) 2012 laFruitera.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InitialScreenViewController : UIViewController
{
	IBOutlet UILabel *labelTextEscull;
	IBOutlet UIButton *buttonIniciarSessio;
	IBOutlet UIButton *buttonRegistrat;
	IBOutlet UIButton *buttonEntrarViaFacebook;

	//Contenidor indicador rotatori
	UIView *contenidor_indicador;
	UIActivityIndicatorView *indicador;
	UIImageView *bg_indicador;

//	IBOutlet TermsConditionsViewController *termes;
}

- (IBAction)showLogin;
- (IBAction)showRegister;
- (IBAction)showLoginFacebook;
- (void)restartData;

@end
