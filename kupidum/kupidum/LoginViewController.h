//
//  LoginViewController.h
//  kupidum
//
//  Created by Albert Nadal Garriga on 18/11/12.
//  Copyright (c) 2012 laFruitera.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>
{
	IBOutlet UILabel *labelTextEtsMembre;
	IBOutlet UILabel *labelTextUsuari;
	IBOutlet UILabel *labelTextPassword;
	IBOutlet UIButton *buttonAccedir;

	IBOutlet UITextField *usuari;
	IBOutlet UITextField *contrassenya;

	//Contenidor indicador rotatori
	UIView *contenidor_indicador;
	UIActivityIndicatorView *indicador;
	UIImageView *bg_indicador;	
}

- (IBAction)iniciarFerLogin;
- (IBAction)desfocalitzarLabels;

@end
