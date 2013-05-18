//
//  UserProfileViewController.m
//  kupidum
//
//  Created by Albert Nadal Garriga on 10/01/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import "UserProfileViewController.h"
#import "KPDUIUtilities.h"
#import "RNSwipeBar.h"
#import "MBProgressHUD.h"
#import <IBAForms/IBAForms.h>
#import <QuartzCore/QuartzCore.h>

typedef void(^userProfileCompletionBlock)(bool success, NSMutableDictionary *model);

@interface UserProfileViewController () <RNSwipeBarDelegate, UIScrollViewDelegate>
{
    NSString *username;
    bool isReadOnly;
    bool editMode;
    bool profileIsEditable;
    UIBarButtonItem *editButton;
    UIBarButtonItem *doneButton;
    UITableView *formTableView;
    UIImagePickerController *photoPicker;
    UIImageView *imgDesiredPictureProfile;
    RNSwipeBar *swipeBar;
    IBOutlet UIView *userPictures;
    IBOutlet UIView *presentationView;
    MBProgressHUD *hud;
    float bottomScrollPadding;
    bool hiddenTabBar;
    int lastContentOffset;
}

@property (nonatomic, strong) UIImagePickerController *photoPicker;
@property (nonatomic, strong) UIView *userPictures;
@property (nonatomic, strong) UIView *presentationView;
@property (strong) RNSwipeBar *swipeBar;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (atomic) float bottomScrollPadding;
@property (atomic) bool hiddenTabBar;
@property (atomic) int lastContentOffset;

- (void)beginEditMode;
- (void)saveUserProfile;
- (void)restoreOriginalProfileScrollSize:(NSNotification *)notification;
- (void)registerSelector:(SEL)selector withNotification:(NSString *)notificationKey;
- (void)showFormField:(NSNotification *)notification;
- (void)showNavigationBarButtons;
- (void)backPressed;
- (void)reloadFormTableView;
- (void)updateTakePhotoButtonsVisibility;
- (void)loadTableView;
- (void)loadUserPresentation;
- (void)loadUserPictures;
- (UIImage *)cropSilouettePicture:(UIImage *)image;
- (void)retrieveUserProfileModelFromUsername:(NSString *)theUsername withCompletionBlock:(userProfileCompletionBlock)completionBlock;
- (void)assignDefaultObject:(id)object toModel:(NSMutableDictionary *)model forKey:(NSString *)key;
- (NSArray *)pickListFormOptionWithObject:(id)object;
- (id)retrieveSelectedValuesInModel:(NSDictionary *)model_ forKey:(NSString *)key_ isMultiple:(bool)is_multiple;
- (void)updateUserProfile;
- (bool)imageIsEmpty:(UIImage *)image;
- (void)loadAgeAndCity;
- (void)reloadProfileView;
- (void)showTabBar;
- (void)hideTabBar;

@end

@implementation UserProfileViewController

@synthesize scroll, faceFrontPhotoButton, faceProfilePhotoButton, bodySilouetePhotoButton, faceFrontPhoto, faceProfilePhoto, bodySilouetePhoto, photoPicker, presentationTextView, presentationPencil, containerButtons, containerSegments, formTypeSelector, selectedForm, userProfile, ageLabel, yearsOldLabel, fromLabel, cityLabel, onlineIndicatorHeaderImage, swipeBar, userPictures, presentationView, hud, bottomScrollPadding, hiddenTabBar, lastContentOffset;

const float basicInformationPanelHeight = 495.0f;
const float buttonsPanelHeight = 120.0f;
const float segmentsPanelHeight = 70.0f;
const float detailedInformationPanelHeight = 1500.0;
const float fieldCellHeight = 44.0;
const float bottomMarginHeight = 20.0;

- (id)init
{
    if(self = [super init])
    {
        username = @"";
        imgDesiredPictureProfile = nil;
        ageLabel = nil;
        yearsOldLabel = nil;
        fromLabel = nil;
        cityLabel = nil;
        profileIsEditable = false;
        editMode = false;
        selectedForm = kUserProfileFormMyDescription;
        bottomScrollPadding = 0.0f;
        hiddenTabBar = false;
        lastContentOffset = 0;
    }

    return self;
}

- (id)initWithUsername:(NSString *)username_ isEditable:(bool)editable
{
    if(self = [super initWithNibName:@"UserProfileViewController" bundle:nil])
    {
        username = username_;

        profileIsEditable = editable;
        imgDesiredPictureProfile = nil;
        formTableView = nil;
        hiddenTabBar = false;
        lastContentOffset = 0;

        if(profileIsEditable)   bottomScrollPadding = 0.0f;
        else                    bottomScrollPadding = 35.0f;
    }

    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withUsername:(NSString *)username_
{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        username = username_;
        imgDesiredPictureProfile = nil;
        formTableView = nil;
        bottomScrollPadding = 0.0f;
        hiddenTabBar = false;
        lastContentOffset = 0;

        [self retrieveUserProfileModelFromUsername:username
                               withCompletionBlock:^(bool success, NSMutableDictionary *theModel)
         {
             NSMutableDictionary *model = theModel;
             profileIsEditable = true; //This must be set after load user profile from DB or web service //!isReadOnly;
             editMode = false;
             selectedForm = kUserProfileFormMyDescription;
             
             bool showEmptyFields = NO;
             ProfileFormDataSource *profileFormDataSource = [[ProfileFormDataSource alloc] initWithModel:model isReadOnly:YES showEmptyFields:showEmptyFields withFormType:selectedForm];
             self.formDataSource = profileFormDataSource;
         }];
    }

    return self;
}

- (IBAction)changeUserProfileForm:(id)sender
{
    switch(self.formTypeSelector.selectedSegmentIndex)
    {
        case kUserProfileFormMyDescription: [self setSelectedForm:kUserProfileFormMyDescription];
                                            break;

        case kUserProfileFormLookingFor:    [self setSelectedForm:kUserProfileFormLookingFor];
                                            break;
    }

    [self reloadFormTableView];
}

- (void)assignDefaultObject:(id)object toModel:(NSMutableDictionary *)model forKey:(NSString *)key
{
    if(object)
        [model setObject:[self pickListFormOptionWithObject:object] forKey:key];
}

- (NSArray *)pickListFormOptionWithObject:(id)object
{
    if([object isKindOfClass:[NSSet class]])
    {
        return [IBAPickListFormOption pickListOptionsForStrings:object];
    }
    else
    {
        return [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:(NSNumber *)object]];
    }
}

- (void)retrieveUserProfileModelFromUsername:(NSString *)theUsername
                         withCompletionBlock:(userProfileCompletionBlock)completionBlock
{
    dispatch_queue_t request_queue = dispatch_queue_create("com.kupidum.profile", NULL);

    dispatch_async(request_queue, ^{

        self.userProfile = [[KPDUserProfile alloc] initWithUsername:theUsername];
        NSMutableDictionary *model = [[NSMutableDictionary alloc] init];

        // User description
        [self assignDefaultObject:userProfile.eyeColorId toModel:model forKey:kEyeColorUserProfileField];
        [self assignDefaultObject:userProfile.height toModel:model forKey:kHeightUserProfileField];
        [self assignDefaultObject:userProfile.weight toModel:model forKey:kWeightUserProfileField];
        [self assignDefaultObject:userProfile.hairColorId toModel:model forKey:kHairColorUserProfileField];
        [self assignDefaultObject:userProfile.hairSizeId toModel:model forKey:kHairSizeUserProfileField];
        [self assignDefaultObject:userProfile.personalityId toModel:model forKey:kMainCharacteristicUserProfileField];
        [self assignDefaultObject:userProfile.appearanceId toModel:model forKey:kBodyLookUserProfileField];
        [self assignDefaultObject:userProfile.silhouetteId toModel:model forKey:kSilhouetteUserProfileField];
        [self assignDefaultObject:userProfile.maritalStatusId toModel:model forKey:kMaritalStatusUserProfileField];
        [self assignDefaultObject:userProfile.hasChildrensId toModel:model forKey:kHasChildrensUserProfileField];
        [self assignDefaultObject:userProfile.liveWithId toModel:model forKey:kWhereIsLivingUserProfileField];
        [self assignDefaultObject:userProfile.bodyHighlightId toModel:model forKey:kMyHighlightUserProfileField];
        [self assignDefaultObject:userProfile.citizenshipId toModel:model forKey:kNationUserProfileField];
        [self assignDefaultObject:userProfile.ethnicalOriginId toModel:model forKey:kEthnicalOriginUserProfileField];
        [self assignDefaultObject:userProfile.religionId toModel:model forKey:kReligionUserProfileField];
        [self assignDefaultObject:userProfile.religionLevelId toModel:model forKey:kReligionLevelUserProfileField];
        [self assignDefaultObject:userProfile.marriageOpinionId toModel:model forKey:kMarriageOpinionUserProfileField];
        [self assignDefaultObject:userProfile.romanticismId toModel:model forKey:kRomanticismLevelUserProfileField];
        [self assignDefaultObject:userProfile.wantChildrensId toModel:model forKey:kIWantChildrensUserProfileField];
        [self assignDefaultObject:userProfile.studiesId toModel:model forKey:kStudiesLevelUserProfileField];
        [self assignDefaultObject:userProfile.languagesId toModel:model forKey:kLanguagesUserProfileField];
        [self assignDefaultObject:userProfile.professionId toModel:model forKey:kMyBusinessUserProfileField];
        [self assignDefaultObject:userProfile.salaryId toModel:model forKey:kSalaryUserProfileField];
        [self assignDefaultObject:userProfile.styleId toModel:model forKey:kMyStyleUserProfileField];
        [self assignDefaultObject:userProfile.dietId toModel:model forKey:kAlimentUserProfileField];
        [self assignDefaultObject:userProfile.smokeId toModel:model forKey:kSmokeUserProfileField];
        [self assignDefaultObject:userProfile.animalsId toModel:model forKey:kAnimalsUserProfileField];
        [self assignDefaultObject:userProfile.hobbiesId toModel:model forKey:kMyHobbiesUserProfileField];
        [self assignDefaultObject:userProfile.sportsId toModel:model forKey:kMySportsUserProfileField];
        [self assignDefaultObject:userProfile.sparetimeId toModel:model forKey:kMySparetimeUserProfileField];
        [self assignDefaultObject:userProfile.musicId toModel:model forKey:kMusicUserProfileField];
        [self assignDefaultObject:userProfile.moviesId toModel:model forKey:kMoviesUserProfileField];

        // User candidate preferences
        [self assignDefaultObject:userProfile.candidateProfile.minAge toModel:model forKey:kMinAgeCandidateProfileField];
        [self assignDefaultObject:userProfile.candidateProfile.maxAge toModel:model forKey:kMaxAgeCandidateProfileField];
        [self assignDefaultObject:userProfile.candidateProfile.minHeight toModel:model forKey:kMinHeightCandidateProfileField];
        [self assignDefaultObject:userProfile.candidateProfile.maxHeight toModel:model forKey:kMaxHeightCandidateProfileField];
        [self assignDefaultObject:userProfile.candidateProfile.minWeight toModel:model forKey:kMinWeightCandidateProfileField];
        [self assignDefaultObject:userProfile.candidateProfile.maxWeight toModel:model forKey:kMaxWeightCandidateProfileField];
        [self assignDefaultObject:userProfile.candidateProfile.maritalStatusId toModel:model forKey:kMaritalStatusCandidateProfileField];
        [self assignDefaultObject:userProfile.candidateProfile.whereIsLivingId toModel:model forKey:kWhereIsLivingCandidateProfileField];
        [self assignDefaultObject:userProfile.candidateProfile.wantChildrensId toModel:model forKey:kWantChildrensCandidateProfileField];
        [self assignDefaultObject:userProfile.candidateProfile.hasChildrensId toModel:model forKey:kHasChildrensCandidateProfileField];
        [self assignDefaultObject:userProfile.candidateProfile.silhouetteID toModel:model forKey:kSilhouetteCandidateProfileField];
        [self assignDefaultObject:userProfile.candidateProfile.mainCharacteristicId toModel:model forKey:kMainCharacteristicCandidateProfileField];
        [self assignDefaultObject:userProfile.candidateProfile.isRomanticId toModel:model forKey:kIsRomanticCandidateProfileField];
        [self assignDefaultObject:userProfile.candidateProfile.marriageIsId toModel:model forKey:kMarriageIsCandidateProfileField];
        [self assignDefaultObject:userProfile.candidateProfile.smokesId toModel:model forKey:kSmokesCandidateProfileField];
        [self assignDefaultObject:userProfile.candidateProfile.dietId toModel:model forKey:kDietCandidateProfileField];
        [self assignDefaultObject:userProfile.candidateProfile.nationId toModel:model forKey:kNationCandidateProfileField];
        [self assignDefaultObject:userProfile.candidateProfile.ethnicalOriginId toModel:model forKey:kEthnicalOriginCandidateProfileField];
        [self assignDefaultObject:userProfile.candidateProfile.bodyLookId toModel:model forKey:kBodyLookCandidateProfileField];
        [self assignDefaultObject:userProfile.candidateProfile.hairSizeId toModel:model forKey:kHairSizeCandidateProfileField];
        [self assignDefaultObject:userProfile.candidateProfile.hairColorId toModel:model forKey:kHairColorCandidateProfileField];
        [self assignDefaultObject:userProfile.candidateProfile.eyeColorId toModel:model forKey:kEyeColorCandidateProfileField];
        [self assignDefaultObject:userProfile.candidateProfile.styleId toModel:model forKey:kStyleCandidateProfileField];
        [self assignDefaultObject:userProfile.candidateProfile.highlightId toModel:model forKey:kHighlightCandidateProfileField];
        [self assignDefaultObject:userProfile.candidateProfile.studiesMinLevelId toModel:model forKey:kStudiesMinLevelCandidateProfileField];
        [self assignDefaultObject:userProfile.candidateProfile.studiesMaxLevelId toModel:model forKey:kStudiesMaxLevelCandidateProfileField];
        [self assignDefaultObject:userProfile.candidateProfile.languagesId toModel:model forKey:kLanguagesCandidateProfileField];
        [self assignDefaultObject:userProfile.candidateProfile.religionId toModel:model forKey:kReligionCandidateProfileField];
        [self assignDefaultObject:userProfile.candidateProfile.religionLevelId toModel:model forKey:kReligionLevelCandidateProfileField];
        [self assignDefaultObject:userProfile.candidateProfile.hobbiesId toModel:model forKey:kHobbiesCandidateProfileField];
        [self assignDefaultObject:userProfile.candidateProfile.sparetimeId toModel:model forKey:kSparetimeCandidateProfileField];
        [self assignDefaultObject:userProfile.candidateProfile.musicId toModel:model forKey:kMusicCandidateProfileField];
        [self assignDefaultObject:userProfile.candidateProfile.moviesId toModel:model forKey:kMoviesCandidateProfileField];
        [self assignDefaultObject:userProfile.candidateProfile.animalsId toModel:model forKey:kAnimalsCandidateProfileField];
        [self assignDefaultObject:userProfile.candidateProfile.sportsId toModel:model forKey:kSportsCandidateProfileField];
        [self assignDefaultObject:userProfile.candidateProfile.businessId toModel:model forKey:kBusinessCandidateProfileField];
        [self assignDefaultObject:userProfile.candidateProfile.minSalaryId toModel:model forKey:kMinSalaryCandidateProfileField];
        [self assignDefaultObject:userProfile.candidateProfile.maxSalaryId toModel:model forKey:kMaxSalaryCandidateProfileField];

        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(true, model);
        });
    });
}

- (void)registerSelector:(SEL)selector withNotification:(NSString *)notificationKey
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:selector name:notificationKey object:nil];
}

- (void)restoreOriginalProfileScrollSize:(NSNotification *)notification
{
    [UIView beginAnimations:@"restoreProfileContentSize" context:nil];
    [UIView setAnimationDuration:0.3];

    if(profileIsEditable)
    {
        CGRect scrollFrame = self.scroll.frame;
        scrollFrame.size.height = self.view.frame.size.height;
        [scroll setFrame:scrollFrame];    
    }

    [scroll setContentSize:CGSizeMake(320, basicInformationPanelHeight + segmentsPanelHeight + formTableView.frame.size.height + bottomMarginHeight)];
    [UIView commitAnimations];
}

- (IBAction)showMenuSelectPhotoOrTakePhoto:(id)sender
{
    photoTypeSelected = [sender tag];

	// open a dialog with two custom buttons
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil
													otherButtonTitles:NSLocalizedString(@"Fer-me una foto", @""), NSLocalizedString(@"Escollir una foto", @""), NSLocalizedString(@"Cancel·lar", @""), nil];
	actionSheet.destructiveButtonIndex = 2;
	[actionSheet showInView:self.parentViewController.tabBarController.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(self.photoPicker == nil)
	{
		self.photoPicker = [[UIImagePickerController alloc] init];
        [self.photoPicker setAllowsEditing:YES];
        [self.photoPicker setDelegate:self];
	}

    [imgDesiredPictureProfile removeFromSuperview];

	if(buttonIndex == 0)
	{
		//Take a picture
        self.photoPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imgDesiredPictureProfile = [[UIImageView alloc] initWithFrame:CGRectMake(0, 72, 320, 320)];
        switch(photoTypeSelected)
        {
            case kFaceFrontPhoto:   [imgDesiredPictureProfile setImage:[UIImage imageNamed:@"img_face_front_image_picker_woman.png"]];
                                    break;
            case kFaceProfilePhoto: [imgDesiredPictureProfile setImage:[UIImage imageNamed:@"img_face_profile_image_picker_woman.png"]];
                                    break;
            case kBodySilouette:    [imgDesiredPictureProfile setImage:[UIImage imageNamed:@"img_body_silhouette_image_picker_woman.png"]];
                                    break;
        }
        [self.photoPicker.view addSubview:imgDesiredPictureProfile];
	}
	else if(buttonIndex == 1)
	{
		//Choose photoroll
        self.photoPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	}
    else
    {
        //Cancel pressed
        return;
    }

    self.photoPicker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:self.photoPicker animated:YES completion:nil];
}

- (UIImage *)cropSilouettePicture:(UIImage *)image
{
    float finalWidth = image.size.height * 0.4918f;
    float finalHeight = image.size.height;
    
    CGRect cropArea = CGRectMake((image.size.width/2.0f) - (finalWidth/2.0f), 0, finalWidth, finalHeight);
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, cropArea);
    UIImage *imageCropped = [UIImage imageWithCGImage:imageRef scale:1.0f orientation:image.imageOrientation];
    CGImageRelease(imageRef);
    return imageCropped;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    switch(photoTypeSelected)
    {
        case kFaceFrontPhoto:   [faceFrontPhoto setImage:image];
                                break;

        case kFaceProfilePhoto: [faceProfilePhoto setImage:image];
                                break;

        case kBodySilouette:    [bodySilouetePhoto setImage:[self cropSilouettePicture:image]];
                                break;
    }

    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)showFormField:(NSNotification *)notification
{
    [scroll setContentSize:CGSizeMake(320, basicInformationPanelHeight + segmentsPanelHeight + detailedInformationPanelHeight + scroll.frame.size.height)];

	NSIndexPath *indexPath = [[notification userInfo] objectForKey:@"indexPath"];

    int formHeightToIndex = [(ProfileFormDataSource *)self.formDataSource getFormHeightToIndex:indexPath withCellHeight:fieldCellHeight];

    CGRect scrollToArea = CGRectMake(0, basicInformationPanelHeight + formHeightToIndex, 320, scroll.frame.size.height);

    [self.scroll scrollRectToVisible:scrollToArea animated:YES];
}

- (void)loadTableView
{
    if(formTableView)
        [formTableView removeFromSuperview];

	formTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, basicInformationPanelHeight + segmentsPanelHeight, 320, detailedInformationPanelHeight) style:UITableViewStyleGrouped];
	[formTableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[self setTableView:formTableView];
    [formTableView setScrollEnabled:NO];

    // update the form height after load the model
    CGRect formTableViewFrame = formTableView.frame;
    formTableViewFrame.size.height = [(ProfileFormDataSource *)self.formDataSource height];
    [formTableView setFrame:formTableViewFrame];

    // update scroll content size
    [scroll setContentSize:CGSizeMake(320, basicInformationPanelHeight + segmentsPanelHeight + formTableView.frame.size.height + bottomMarginHeight)];

    [self.scroll addSubview:formTableView];    
}

- (void)loadView
{
	[super loadView];
    [self loadTableView];
}

- (void)loadUserPresentation
{
    self.presentationView.layer.borderColor = [UIColor colorWithRed:171.0f/255.0f green:171.0f/255.0f blue:171.0f/255.0f alpha:1.0f].CGColor; //[UIColor redColor].CGColor;
    self.presentationView.layer.borderWidth = 1.0f;
    self.presentationView.layer.cornerRadius = 10;
    self.presentationView.layer.masksToBounds = YES;

    [self.presentationTextView setText:self.userProfile.presentation];
}

- (bool)imageIsEmpty:(UIImage *)image
{
    return ((!image.size.width) && (!image.size.height));
}

- (void)loadUserPictures
{
    self.userPictures.layer.borderColor = [UIColor colorWithRed:171.0f/255.0f green:171.0f/255.0f blue:171.0f/255.0f alpha:1.0f].CGColor; //[UIColor redColor].CGColor;
    self.userPictures.layer.borderWidth = 1.0f;
    self.userPictures.layer.cornerRadius = 10;
    self.userPictures.layer.masksToBounds = YES;

    // Head front picture
    if((self.userProfile.faceFrontImage) && (![self imageIsEmpty:self.userProfile.faceFrontImage]))
    {
        [self.faceFrontPhoto setImage:self.userProfile.faceFrontImage];
    }
    else
    {
        switch (self.userProfile.gender.intValue)
        {
            case kMale:     [self.faceFrontPhoto setImage:[UIImage imageNamed:@"img_user_default_front_man.png"]];
                            break;

            case kFemale:   [self.faceFrontPhoto setImage:[UIImage imageNamed:@"img_user_default_front_woman.png"]];
                            break;
        }
    }

    // Head profile picture
    if((self.userProfile.faceProfileImage) && (![self imageIsEmpty:self.userProfile.faceProfileImage]))
    {
        [self.faceProfilePhoto setImage:self.userProfile.faceProfileImage];
    }
    else
    {
        switch (self.userProfile.gender.intValue)
        {
            case kMale:     [self.faceProfilePhoto setImage:[UIImage imageNamed:@"img_user_default_profile_man.png"]];
                break;
                
            case kFemale:   [self.faceProfilePhoto setImage:[UIImage imageNamed:@"img_user_default_profile_woman.png"]];
                break;
        }
    }

    // Body silhouette picture
    if((self.userProfile.bodyImage) && (![self imageIsEmpty:self.userProfile.bodyImage]))
    {
        [self.bodySilouetePhoto setImage:self.userProfile.bodyImage];
    }
    else
    {
        switch (self.userProfile.gender.intValue)
        {
            case kMale:     [self.bodySilouetePhoto setImage:[UIImage imageNamed:@"img_user_default_body_man.png"]];
                break;
                
            case kFemale:   [self.bodySilouetePhoto setImage:[UIImage imageNamed:@"img_user_default_body_woman.png"]];
                break;
        }
    }
}

- (void)loadAgeAndCity
{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.userProfile.dateOfBirth];
    int secondsPerYear = 60*60*24*365;
    int totalYears = floor(timeInterval/secondsPerYear);

    [self.ageLabel setText:[NSString stringWithFormat:@"%d", totalYears]];
    [self.yearsOldLabel setText:NSLocalizedString(@"years old", @"")];
    [self.fromLabel setText:NSLocalizedString(@"from", @"")];
    [self.fromLabel sizeToFit];

    CGFloat cityLabelRightMargin = [[UIScreen mainScreen] bounds].size.width - CGRectGetMaxX(self.cityLabel.frame);
    [self.cityLabel setText:self.userProfile.city];
    [self.cityLabel sizeToFit];

    CGRect cityLabelFrame = self.cityLabel.frame;
    cityLabelFrame.origin.x = [[UIScreen mainScreen] bounds].size.width - cityLabelRightMargin - cityLabelFrame.size.width;
    [self.cityLabel setFrame:cityLabelFrame];

    CGRect fromLabelFrame = self.fromLabel.frame;
    fromLabelFrame.origin.x = cityLabelFrame.origin.x - fromLabelFrame.size.width - 5.0f;
    [self.fromLabel setFrame:fromLabelFrame];
}

- (void)reloadProfileView
{
    imgDesiredPictureProfile = nil;
    
    [self registerSelector:@selector(showFormField:) withNotification:IBAInputRequestorShowFormField];
    [self registerSelector:@selector(restoreOriginalProfileScrollSize:) withNotification:IBAInputRequestorRestoreOriginalProfileSize];
    
    [self.onlineIndicatorHeaderImage.image resizableImageWithCapInsets:UIEdgeInsetsMake(20.0f, 20.0f, 20.0f, 20.0f)],
    
    [self loadAgeAndCity];
    [self loadUserPresentation];
    [self loadUserPictures];
    [self updateTakePhotoButtonsVisibility];
    
    [self.containerButtons setHidden:profileIsEditable];
    
    if(!profileIsEditable)
    {
        [self.containerButtons.layer setMasksToBounds:NO];
        self.containerButtons.layer.shadowColor = [UIColor blackColor].CGColor;
        self.containerButtons.layer.shadowOpacity = 0.85;
        self.containerButtons.layer.shadowRadius = 3;
        self.containerButtons.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        self.containerButtons.layer.shouldRasterize = YES;
        self.containerButtons.layer.rasterizationScale = [[UIScreen mainScreen] scale];
        
        self.swipeBar = [[RNSwipeBar alloc] initWithMainView:self.view];
        [self.swipeBar setPadding:35.0f];
        [self.swipeBar setDelegate:self];
        [self.view addSubview:self.swipeBar];
        [self.swipeBar setBarView:self.containerButtons];
        [self.swipeBar show:YES];
    }
    
    [self setSelectedForm:kUserProfileFormMyDescription];
    [self reloadFormTableView];
    
    [scroll setContentSize:CGSizeMake(320, basicInformationPanelHeight + segmentsPanelHeight + formTableView.frame.size.height + bottomMarginHeight)];
    [self.scroll setHidden:NO];
}

- (void)showTabBar
{
    if(!self.hiddenTabBar) return;

    self.hiddenTabBar = false;

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.15];
    for(UIView *view in self.tabBarController.view.subviews)
    {
        CGRect _rect = view.frame;
        if([view isKindOfClass:[UITabBar class]])
        {
            _rect.origin.y = 519.0f; //CGRectGetMaxY(_rect) - _rect.size.height;
            [view setFrame:_rect];
        } else {
            _rect.size.height = 519.0f;
            [view setFrame:_rect];
        }
    }
    [UIView commitAnimations];
}

- (void)hideTabBar
{
    if(self.hiddenTabBar) return;

    self.hiddenTabBar = true;

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.15];
    for(UIView *view in self.tabBarController.view.subviews)
    {
        CGRect _rect = view.frame;
        if([view isKindOfClass:[UITabBar class]])
        {
            _rect.origin.y = 519.0f + 49.0f; //CGRectGetMaxY(_rect) + _rect.size.height;
            [view setFrame:_rect];
        } else {
            _rect.size.height = 519.0f + 49.0f;
            [view setFrame:_rect];
        }
    }
    [UIView commitAnimations];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Adjust the scroll size in order to avoid overlap the bottom swipeBar
    CGRect scrollFrame = self.scroll.frame;
    scrollFrame.size.height = scrollFrame.size.height - self.bottomScrollPadding;
    [self.scroll setFrame:scrollFrame];

    // While downloading the data the scroll must be hidden
    [self.scroll setHidden:YES];

    [self showNavigationBarButtons];

    self.title = username;

    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDAnimationFade;
    self.hud.labelText = NSLocalizedString(@"Loading data...", @"");

    [self retrieveUserProfileModelFromUsername:username
                           withCompletionBlock:^(bool success, NSMutableDictionary *theModel)
     {
         NSMutableDictionary *model = theModel;
//         profileIsEditable = editable;
         editMode = false;
         selectedForm = kUserProfileFormMyDescription;
         
         bool showEmptyFields = NO;
         ProfileFormDataSource *profileFormDataSource = [[ProfileFormDataSource alloc] initWithModel:model isReadOnly:YES showEmptyFields:showEmptyFields withFormType:selectedForm];
         self.formDataSource = profileFormDataSource;
         
         [self reloadProfileView];
         [self.hud performSelector:@selector(hide:) withObject:[NSNumber numberWithBool:YES] afterDelay:0.7f];
     }];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [self showTabBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if((scrollView.contentOffset.y >= 0) && (scrollView.contentOffset.y <= ([self.scroll contentSize].height - self.scroll.frame.size.height)))
    {
        if(![self.swipeBar isHidden])
        {
            [self.swipeBar hide:YES];
        }

        bool scrollDown = (self.lastContentOffset < scrollView.contentOffset.y) ? true : false;

        self.lastContentOffset = scrollView.contentOffset.y;

        if((scrollDown) && (!hiddenTabBar))         [self hideTabBar];
        else if((!scrollDown) && (hiddenTabBar))    [self showTabBar];
    }
}

- (void)swipeBarDidAppear:(id)sender
{
    
}

- (void)swipeBarDidDisappear:(id)sender
{
    
}

- (void)swipebarWasSwiped:(id)sender
{
    
}

- (void)showNavigationBarButtons
{
    UIButton *backButton = [KPDUIUtilities customCircleBarButtonWithImage:@"nav_black_circle_button.png"
                                                           andInsideImage:@"nav_arrow_back_button.png"
                                                              andSelector:@selector(backPressed)
                                                                andTarget:self];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:backButton]];


    if(profileIsEditable)
    {
        // Edit button
        editButton = [[UIBarButtonItem alloc] initWithTitle: NSLocalizedString(@"Edit", @"")
                                                      style: UIBarButtonItemStyleDone
                                                     target: self
                                                     action: @selector(beginEditMode)];
        [editButton setEnabled:TRUE];
        [self.navigationItem setRightBarButtonItem:editButton];

        // Done button
        doneButton = [[UIBarButtonItem alloc] initWithTitle: NSLocalizedString(@"Done", @"")
                                                      style: UIBarButtonItemStyleDone
                                                     target: self
                                                     action: @selector(saveUserProfile)];
    }
}

- (void)reloadFormTableView
{
    bool isReadOnly_ = editMode ? false : true;
    bool showEmptyFields = NO;
	ProfileFormDataSource *profileFormDataSource = [[ProfileFormDataSource alloc] initWithModel:self.formDataSource.model isReadOnly:isReadOnly_ showEmptyFields:showEmptyFields withFormType:selectedForm];
    self.formDataSource = profileFormDataSource;
    
    [formTableView removeFromSuperview];
	formTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, basicInformationPanelHeight + segmentsPanelHeight, 320, detailedInformationPanelHeight) style:UITableViewStyleGrouped];
	[formTableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[self setTableView:formTableView];
    [formTableView setScrollEnabled:NO];

    // update the form height after load the model
    CGRect formTableViewFrame = formTableView.frame;
    formTableViewFrame.size.height = [(ProfileFormDataSource *)self.formDataSource height];
    [formTableView setFrame:formTableViewFrame];

    // update scroll content size
    [scroll setContentSize:CGSizeMake(320, basicInformationPanelHeight + segmentsPanelHeight + formTableView.frame.size.height + bottomMarginHeight)];

    [self.scroll addSubview:formTableView];
    [super viewDidLoad];
}

- (void)updateTakePhotoButtonsVisibility
{
    bool stayHidden = editMode ? false : true;

    [faceFrontPhotoButton setHidden:stayHidden];
    [faceProfilePhotoButton setHidden:stayHidden];
    [bodySilouetePhotoButton setHidden:stayHidden];
}

- (void)beginEditMode
{
    editMode = true;
    [self.navigationItem setRightBarButtonItem:doneButton];

    [presentationPencil setHidden:NO];
    //[presentationTextView setEditable:YES];
    //[presentationTextView setUserInteractionEnabled:YES];

    [self updateTakePhotoButtonsVisibility];
    [self reloadFormTableView];
}

- (id)retrieveSelectedValuesInModel:(NSDictionary *)model_ forKey:(NSString *)key_ isMultiple:(bool)is_multiple
{
    NSMutableArray *selectedValues = [[NSMutableArray alloc] init];
    
    NSDictionary *dictionaryOfValues;
    if((dictionaryOfValues = [model_ valueForKey:key_]))
    {
        for(id keyValue in dictionaryOfValues)
        {
            for(id value in keyValue)
            {
                [selectedValues addObject:[NSNumber numberWithInt:[value integerValue]]];
            }
        }
    }

    if(([selectedValues count]>=1) && (is_multiple))    return [NSSet setWithArray:selectedValues];
    else if([selectedValues count] == 1)                return [selectedValues objectAtIndex:0];
    else                                                return nil;
}

- (void)updateUserProfile
{
    if([self.formDataSource respondsToSelector:@selector(getModelWithValues)])
    {
        NSDictionary *model = [(ProfileFormDataSource *)self.formDataSource getModelWithValues];
        NSLog(@"Model: %@", model);

        // User images
        self.userProfile.faceFrontImage = self.faceFrontPhoto.image;
        self.userProfile.faceProfileImage = self.faceProfilePhoto.image;
        self.userProfile.bodyImage = self.bodySilouetePhoto.image;

        // User description
        self.userProfile.eyeColorId = [self retrieveSelectedValuesInModel:model forKey:kEyeColorUserProfileField isMultiple:NO];
        self.userProfile.height = [self retrieveSelectedValuesInModel:model forKey:kHeightUserProfileField isMultiple:NO];
        self.userProfile.weight = [self retrieveSelectedValuesInModel:model forKey:kWeightUserProfileField isMultiple:NO];
        self.userProfile.hairColorId = [self retrieveSelectedValuesInModel:model forKey:kHairColorUserProfileField isMultiple:NO];
        self.userProfile.hairSizeId = [self retrieveSelectedValuesInModel:model forKey:kHairSizeUserProfileField isMultiple:NO];
        self.userProfile.personalityId = [self retrieveSelectedValuesInModel:model forKey:kMainCharacteristicUserProfileField isMultiple:NO];
        self.userProfile.appearanceId = [self retrieveSelectedValuesInModel:model forKey:kBodyLookUserProfileField isMultiple:NO];
        self.userProfile.silhouetteId = [self retrieveSelectedValuesInModel:model forKey:kSilhouetteUserProfileField isMultiple:NO];
        self.userProfile.maritalStatusId = [self retrieveSelectedValuesInModel:model forKey:kMaritalStatusUserProfileField isMultiple:NO];
        self.userProfile.hasChildrensId = [self retrieveSelectedValuesInModel:model forKey:kHasChildrensUserProfileField isMultiple:NO];
        self.userProfile.liveWithId = [self retrieveSelectedValuesInModel:model forKey:kWhereIsLivingUserProfileField isMultiple:NO];
        self.userProfile.bodyHighlightId = [self retrieveSelectedValuesInModel:model forKey:kMyHighlightUserProfileField isMultiple:NO];
        self.userProfile.citizenshipId = [self retrieveSelectedValuesInModel:model forKey:kNationUserProfileField isMultiple:NO];
        self.userProfile.ethnicalOriginId = [self retrieveSelectedValuesInModel:model forKey:kEthnicalOriginUserProfileField isMultiple:NO];
        self.userProfile.religionId = [self retrieveSelectedValuesInModel:model forKey:kReligionUserProfileField isMultiple:NO];
        self.userProfile.religionLevelId = [self retrieveSelectedValuesInModel:model forKey:kReligionLevelUserProfileField isMultiple:NO];
        self.userProfile.marriageOpinionId = [self retrieveSelectedValuesInModel:model forKey:kMarriageOpinionUserProfileField isMultiple:NO];
        self.userProfile.romanticismId = [self retrieveSelectedValuesInModel:model forKey:kRomanticismLevelUserProfileField isMultiple:NO];
        self.userProfile.wantChildrensId = [self retrieveSelectedValuesInModel:model forKey:kIWantChildrensUserProfileField isMultiple:NO];
        self.userProfile.studiesId = [self retrieveSelectedValuesInModel:model forKey:kStudiesLevelUserProfileField isMultiple:NO];
        self.userProfile.languagesId = [self retrieveSelectedValuesInModel:model forKey:kLanguagesUserProfileField isMultiple:YES];
        self.userProfile.professionId = [self retrieveSelectedValuesInModel:model forKey:kMyBusinessUserProfileField isMultiple:NO];
        self.userProfile.salaryId = [self retrieveSelectedValuesInModel:model forKey:kSalaryUserProfileField isMultiple:NO];
        self.userProfile.styleId = [self retrieveSelectedValuesInModel:model forKey:kMyStyleUserProfileField isMultiple:NO];
        self.userProfile.dietId = [self retrieveSelectedValuesInModel:model forKey:kAlimentUserProfileField isMultiple:NO];
        self.userProfile.smokeId = [self retrieveSelectedValuesInModel:model forKey:kSmokeUserProfileField isMultiple:NO];
        self.userProfile.animalsId = [self retrieveSelectedValuesInModel:model forKey:kAnimalsUserProfileField isMultiple:YES];
        self.userProfile.hobbiesId = [self retrieveSelectedValuesInModel:model forKey:kMyHobbiesUserProfileField isMultiple:YES];
        self.userProfile.sportsId = [self retrieveSelectedValuesInModel:model forKey:kMySportsUserProfileField isMultiple:YES];
        self.userProfile.sparetimeId = [self retrieveSelectedValuesInModel:model forKey:kMySparetimeUserProfileField isMultiple:YES];
        self.userProfile.musicId = [self retrieveSelectedValuesInModel:model forKey:kMusicUserProfileField isMultiple:YES];
        self.userProfile.moviesId = [self retrieveSelectedValuesInModel:model forKey:kMoviesUserProfileField isMultiple:YES];

        self.userProfile.candidateProfile.minAge = [self retrieveSelectedValuesInModel:model forKey:kMinAgeCandidateProfileField isMultiple:NO];
        self.userProfile.candidateProfile.maxAge = [self retrieveSelectedValuesInModel:model forKey:kMaxAgeCandidateProfileField isMultiple:NO];
        self.userProfile.candidateProfile.minHeight = [self retrieveSelectedValuesInModel:model forKey:kMinHeightCandidateProfileField isMultiple:NO];
        self.userProfile.candidateProfile.maxHeight = [self retrieveSelectedValuesInModel:model forKey:kMaxHeightCandidateProfileField isMultiple:NO];
        self.userProfile.candidateProfile.minWeight = [self retrieveSelectedValuesInModel:model forKey:kMinWeightCandidateProfileField isMultiple:NO];
        self.userProfile.candidateProfile.maxWeight = [self retrieveSelectedValuesInModel:model forKey:kMaxWeightCandidateProfileField isMultiple:NO];

        self.userProfile.candidateProfile.maritalStatusId = [self retrieveSelectedValuesInModel:model forKey:kMaritalStatusCandidateProfileField isMultiple:YES];
        self.userProfile.candidateProfile.whereIsLivingId = [self retrieveSelectedValuesInModel:model forKey:kWhereIsLivingCandidateProfileField isMultiple:YES];
        self.userProfile.candidateProfile.wantChildrensId = [self retrieveSelectedValuesInModel:model forKey:kWantChildrensCandidateProfileField isMultiple:YES];
        self.userProfile.candidateProfile.hasChildrensId = [self retrieveSelectedValuesInModel:model forKey:kHasChildrensCandidateProfileField isMultiple:YES];
        self.userProfile.candidateProfile.silhouetteID = [self retrieveSelectedValuesInModel:model forKey:kSilhouetteCandidateProfileField isMultiple:YES];
        self.userProfile.candidateProfile.mainCharacteristicId = [self retrieveSelectedValuesInModel:model forKey:kMainCharacteristicCandidateProfileField isMultiple:YES];
        self.userProfile.candidateProfile.isRomanticId = [self retrieveSelectedValuesInModel:model forKey:kIsRomanticCandidateProfileField isMultiple:YES];
        self.userProfile.candidateProfile.marriageIsId = [self retrieveSelectedValuesInModel:model forKey:kMarriageIsCandidateProfileField isMultiple:YES];
        self.userProfile.candidateProfile.smokesId = [self retrieveSelectedValuesInModel:model forKey:kSmokesCandidateProfileField isMultiple:YES];
        self.userProfile.candidateProfile.dietId = [self retrieveSelectedValuesInModel:model forKey:kDietCandidateProfileField isMultiple:YES];
        self.userProfile.candidateProfile.nationId = [self retrieveSelectedValuesInModel:model forKey:kNationCandidateProfileField isMultiple:YES];
        self.userProfile.candidateProfile.ethnicalOriginId = [self retrieveSelectedValuesInModel:model forKey:kEthnicalOriginCandidateProfileField isMultiple:YES];
        self.userProfile.candidateProfile.bodyLookId = [self retrieveSelectedValuesInModel:model forKey:kBodyLookCandidateProfileField isMultiple:YES];
        self.userProfile.candidateProfile.hairSizeId = [self retrieveSelectedValuesInModel:model forKey:kHairSizeCandidateProfileField isMultiple:YES];
        self.userProfile.candidateProfile.hairColorId = [self retrieveSelectedValuesInModel:model forKey:kHairColorCandidateProfileField isMultiple:YES];
        self.userProfile.candidateProfile.eyeColorId = [self retrieveSelectedValuesInModel:model forKey:kEyeColorCandidateProfileField isMultiple:YES];
        self.userProfile.candidateProfile.styleId = [self retrieveSelectedValuesInModel:model forKey:kStyleCandidateProfileField isMultiple:YES];
        self.userProfile.candidateProfile.highlightId = [self retrieveSelectedValuesInModel:model forKey:kHighlightCandidateProfileField isMultiple:YES];
        self.userProfile.candidateProfile.studiesMinLevelId = [self retrieveSelectedValuesInModel:model forKey:kStudiesMinLevelCandidateProfileField isMultiple:NO];
        self.userProfile.candidateProfile.studiesMaxLevelId = [self retrieveSelectedValuesInModel:model forKey:kStudiesMaxLevelCandidateProfileField isMultiple:NO];
        self.userProfile.candidateProfile.languagesId = [self retrieveSelectedValuesInModel:model forKey:kLanguagesCandidateProfileField isMultiple:YES];
        self.userProfile.candidateProfile.religionId = [self retrieveSelectedValuesInModel:model forKey:kReligionCandidateProfileField isMultiple:YES];
        self.userProfile.candidateProfile.religionLevelId = [self retrieveSelectedValuesInModel:model forKey:kReligionLevelCandidateProfileField isMultiple:YES];
        self.userProfile.candidateProfile.hobbiesId = [self retrieveSelectedValuesInModel:model forKey:kHobbiesCandidateProfileField isMultiple:YES];
        self.userProfile.candidateProfile.sparetimeId = [self retrieveSelectedValuesInModel:model forKey:kSparetimeCandidateProfileField isMultiple:YES];
        self.userProfile.candidateProfile.musicId = [self retrieveSelectedValuesInModel:model forKey:kMusicCandidateProfileField isMultiple:YES];
        self.userProfile.candidateProfile.moviesId = [self retrieveSelectedValuesInModel:model forKey:kMoviesCandidateProfileField isMultiple:YES];
        self.userProfile.candidateProfile.animalsId = [self retrieveSelectedValuesInModel:model forKey:kAnimalsCandidateProfileField isMultiple:YES];
        self.userProfile.candidateProfile.sportsId = [self retrieveSelectedValuesInModel:model forKey:kSportsCandidateProfileField isMultiple:YES];
        self.userProfile.candidateProfile.businessId = [self retrieveSelectedValuesInModel:model forKey:kBusinessCandidateProfileField isMultiple:YES];
        self.userProfile.candidateProfile.businessId = [self retrieveSelectedValuesInModel:model forKey:kBusinessCandidateProfileField isMultiple:YES];
        self.userProfile.candidateProfile.minSalaryId = [self retrieveSelectedValuesInModel:model forKey:kMinSalaryCandidateProfileField isMultiple:NO];
        self.userProfile.candidateProfile.maxSalaryId = [self retrieveSelectedValuesInModel:model forKey:kMaxSalaryCandidateProfileField isMultiple:NO];

        // Updates the information stored in local database
        [self.userProfile saveToDatabase];
    }
}

- (void)saveUserProfile
{
    [self updateUserProfile];

    [self retrieveUserProfileModelFromUsername:username
                           withCompletionBlock:^(bool success, NSMutableDictionary *theModel)
     {
         NSMutableDictionary *model = theModel;
         bool showEmptyFields = NO;
         ProfileFormDataSource *profileFormDataSource = [[ProfileFormDataSource alloc] initWithModel:model isReadOnly:YES showEmptyFields:showEmptyFields withFormType:selectedForm];
         self.formDataSource = profileFormDataSource;

         editMode = false;
         [self.navigationItem setRightBarButtonItem:editButton];

         [presentationPencil setHidden:YES];
         //[presentationTextView setEditable:NO];
         //[presentationTextView setUserInteractionEnabled:NO];

         [self updateTakePhotoButtonsVisibility];
         [self reloadFormTableView];
     }];
}

- (void)backPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
