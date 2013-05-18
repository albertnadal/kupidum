//
//  UserProfileViewController.h
//  kupidum
//
//  Created by Albert Nadal Garriga on 10/01/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileFormDataSource.h"
#import "KPDUserProfile.h"
#import <IBAForms/IBAFormViewController.h>
#import <IBAforms/IBAFormConstants.h>

typedef enum {
	kFaceFrontPhoto = 1,
	kFaceProfilePhoto = 2,
	kBodySilouette = 3
} KPDUserProfilePhoto;

@interface UserProfileViewController : IBAFormViewController<UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, KPDUserProfileDelegate>
{
    IBOutlet UIScrollView *scroll;
    IBOutlet UILabel *ageLabel;
    IBOutlet UILabel *yearsOldLabel;
    IBOutlet UILabel *fromLabel;
    IBOutlet UILabel *cityLabel;
    IBOutlet UIButton *faceFrontPhotoButton;
    IBOutlet UIButton *faceProfilePhotoButton;
    IBOutlet UIButton *bodySilouetePhotoButton;
    IBOutlet UIImageView *faceFrontPhoto;
    IBOutlet UIImageView *faceProfilePhoto;
    IBOutlet UIImageView *bodySilouetePhoto;
    IBOutlet UILabel *presentationTextView;
    IBOutlet UIImageView *presentationPencil;
    IBOutlet UIView *containerButtons;
    IBOutlet UIView *containerSegments;
    IBOutlet UISegmentedControl *formTypeSelector;

    IBOutlet UIImageView *onlineIndicatorHeaderImage;

    KPDUserProfilePhoto photoTypeSelected;
    UserProfileFormType selectedForm;
    KPDUserProfile *userProfile;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scroll;
@property (strong, nonatomic) IBOutlet UILabel *ageLabel;
@property (strong, nonatomic) IBOutlet UILabel *yearsOldLabel;
@property (strong, nonatomic) IBOutlet UILabel *fromLabel;
@property (strong, nonatomic) IBOutlet UILabel *cityLabel;
@property (strong, nonatomic) IBOutlet UIButton *faceFrontPhotoButton;
@property (strong, nonatomic) IBOutlet UIButton *faceProfilePhotoButton;
@property (strong, nonatomic) IBOutlet UIButton *bodySilouetePhotoButton;
@property (strong, nonatomic) IBOutlet UIImageView *faceFrontPhoto;
@property (strong, nonatomic) IBOutlet UIImageView *faceProfilePhoto;
@property (strong, nonatomic) IBOutlet UIImageView *bodySilouetePhoto;
@property (strong, nonatomic) IBOutlet UILabel *presentationTextView;
@property (strong, nonatomic) IBOutlet UIImageView *presentationPencil;
@property (strong, nonatomic) IBOutlet UIView *containerButtons;
@property (strong, nonatomic) IBOutlet UIView *containerSegments;
@property (strong, nonatomic) IBOutlet UISegmentedControl *formTypeSelector;
@property (strong, nonatomic) IBOutlet UIImageView *onlineIndicatorHeaderImage;
@property (atomic) UserProfileFormType selectedForm;
@property (strong, nonatomic) KPDUserProfile *userProfile;

- (id)initWithUsername:(NSString *)username_ isEditable:(bool)editable;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withUsername:(NSString *)username_;
- (IBAction)showMenuSelectPhotoOrTakePhoto:(id)sender;
- (IBAction)changeUserProfileForm:(id)sender;

@end

@protocol KPDUserProfileViewControllerDelegate

- (void)showUserProfile:(NSString *)username;

@end
