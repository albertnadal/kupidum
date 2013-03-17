//
//  UserProfileViewController.h
//  kupidum
//
//  Created by Albert Nadal Garriga on 10/01/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IBAForms/IBAFormViewController.h>
#import <IBAforms/IBAFormConstants.h>

typedef enum {
	kFaceFrontPhoto = 1,
	kFaceProfilePhoto = 2,
	kBodySilouette = 3
} KPDUserProfilePhoto;

@interface UserProfileViewController : IBAFormViewController<UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate>
{
    IBOutlet UIScrollView *scroll;
    IBOutlet UIButton *faceFrontPhotoButton;
    IBOutlet UIButton *faceProfilePhotoButton;
    IBOutlet UIButton *bodySilouetePhotoButton;
    IBOutlet UIImageView *faceFrontPhoto;
    IBOutlet UIImageView *faceProfilePhoto;
    IBOutlet UIImageView *bodySilouetePhoto;
    KPDUserProfilePhoto photoTypeSelected;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scroll;
@property (strong, nonatomic) IBOutlet UIButton *faceFrontPhotoButton;
@property (strong, nonatomic) IBOutlet UIButton *faceProfilePhotoButton;
@property (strong, nonatomic) IBOutlet UIButton *bodySilouetePhotoButton;
@property (strong, nonatomic) IBOutlet UIImageView *faceFrontPhoto;
@property (strong, nonatomic) IBOutlet UIImageView *faceProfilePhoto;
@property (strong, nonatomic) IBOutlet UIImageView *bodySilouetePhoto;

- (IBAction)showMenuSelectPhotoOrTakePhoto:(id)sender;

@end
