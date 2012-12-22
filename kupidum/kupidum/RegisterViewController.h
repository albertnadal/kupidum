//
//  RegisterViewController.h
//  kupidum
//
//  Created by Albert Nadal Garriga on 18/11/12.
//  Copyright (c) 2012 laFruitera.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KPDRegisterData.h"

@interface RegisterViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>
{
    int currentStep;
    int totalSteps;

    IBOutlet UIImageView *logo;

	IBOutlet UILabel *labelTextEtsNou;
	IBOutlet UILabel *labelTextSoc;
	IBOutlet UILabel *labelTextEdatEntre;
	IBOutlet UILabel *labelTextDataNaixement;
	IBOutlet UILabel *labelTextPais;

	IBOutlet UILabel *labelTextEsConfidencial;
	IBOutlet UILabel *labelTextCodiPostal;
	IBOutlet UILabel *labelTextSobrenom;
	IBOutlet UILabel *labelTextContrassenya;
	IBOutlet UILabel *labelTextEmail;

	IBOutlet UIButton *buttonSeguent;
	IBOutlet UIButton *buttonAccedir;

	IBOutlet UIView *contenidorFormulari;

	IBOutlet UILabel *selectedLabelTextSoc;
	IBOutlet UILabel *selectedLabelTextEdat;
	IBOutlet UILabel *selectedLabelDataNaixement;
	IBOutlet UILabel *selectedLabelTextPais;

	IBOutlet UITextField *codiPostal;
	IBOutlet UITextField *sobrenom;
	IBOutlet UITextField *contrassenya;
	IBOutlet UITextField *email;

    IBOutlet UIPickerView *selectorSoc;
    IBOutlet UIPickerView *selectorEdat;
    IBOutlet UIDatePicker *selectorDataNaixement;
    IBOutlet UIPickerView *selectorPais;

	IBOutlet UILabel *labelTextLaTevaFoto;
	IBOutlet UILabel *labelTextAfegirFoto;
	IBOutlet UIImageView *photo;

	UIImage *photoImatge;
	UIImagePickerController *photoPicker;

    int indexSelectorSoc;

    int edatMinima;
    int edatMaxima;

    int diaNaixement;
    int mesNaixement;
    int anyNaixement;

    int indexSelectorPais;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil step:(int)theStep;
- (IBAction)goToNext;
- (IBAction)validarCamps;
- (IBAction)iniciarFerRegistre;
- (void)ferRegistre;
- (IBAction)focalitzarLabel:(id)sender;
- (IBAction)focalitzarSelector:(id)sender;
- (IBAction)desfocalitzarCamps;
- (IBAction)desfocalitzarLabels;
- (IBAction)desfocalitzarSelectors;
- (IBAction)actualitzarCampDataNaixement;
- (NSString *)getTextForSelectorSocAtIndex:(int)index;
- (NSString *)getTextForSelectorDataNaixement;
- (NSString *)getTextForSelectorPaisAtIndex:(int)index;
- (void)restartData;

@end
