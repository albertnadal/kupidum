//
//  UserProfileViewController.m
//  kupidum
//
//  Created by Albert Nadal Garriga on 10/01/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import "UserProfileViewController.h"
#import "KPDUIUtilities.h"
#import <IBAForms/IBAForms.h>

@interface UserProfileViewController ()
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
}

@property (nonatomic, retain) UIImagePickerController *photoPicker;

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
- (NSMutableDictionary *)retrieveUserProfileModelFromUserProfile:(KPDUserProfile *)user_profile;
- (void)assignDefaultObject:(id)object toModel:(NSMutableDictionary *)model forKey:(NSString *)key;
- (NSArray *)pickListFormOptionWithObject:(id)object;
- (id)retrieveSelectedValuesInModel:(NSDictionary *)model_ forKey:(NSString *)key_ isMultiple:(bool)is_multiple;
- (void)updateUserProfile;
- (bool)imageIsEmpty:(UIImage *)image;
- (void)loadAgeAndCity;

@end

@implementation UserProfileViewController

@synthesize scroll, faceFrontPhotoButton, faceProfilePhotoButton, bodySilouetePhotoButton, faceFrontPhoto, faceProfilePhoto, bodySilouetePhoto, photoPicker, presentationTextView, presentationPencil, containerButtons, containerSegments, formTypeSelector, selectedForm, userProfile, ageLabel, yearsOldLabel, fromLabel, cityLabel;

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
    }

    return self;
}

- (id)initWithUsername:(NSString *)username_ isEditable:(bool)editable
{
    if(self = [super initWithNibName:@"UserProfileViewController" bundle:nil])
    {
        username = username_;
        userProfile = [[KPDUserProfile alloc] initWithUsername:username_];

        imgDesiredPictureProfile = nil;
        formTableView = nil;

        NSMutableDictionary *model = [self retrieveUserProfileModelFromUserProfile:userProfile];
        profileIsEditable = editable;
        editMode = false;
        selectedForm = kUserProfileFormMyDescription;

        bool showEmptyFields = NO;
        ProfileFormDataSource *profileFormDataSource = [[ProfileFormDataSource alloc] initWithModel:model isReadOnly:YES showEmptyFields:showEmptyFields withFormType:selectedForm];
        self.formDataSource = profileFormDataSource;
    }

    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withUsername:(NSString *)username_
{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        username = username_;
        userProfile = [[KPDUserProfile alloc] initWithUsername:username_];
        imgDesiredPictureProfile = nil;
        formTableView = nil;

        NSMutableDictionary *model = [self retrieveUserProfileModelFromUserProfile:userProfile];
        profileIsEditable = true; //This must be set after load user profile from DB or web service //!isReadOnly;
        editMode = false;
        selectedForm = kUserProfileFormMyDescription;

        bool showEmptyFields = NO;
        ProfileFormDataSource *profileFormDataSource = [[ProfileFormDataSource alloc] initWithModel:model isReadOnly:YES showEmptyFields:showEmptyFields withFormType:selectedForm];
        self.formDataSource = profileFormDataSource;

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

- (NSMutableDictionary *)retrieveUserProfileModelFromUserProfile:(KPDUserProfile *)user_profile
{
	NSMutableDictionary *model = [[NSMutableDictionary alloc] init];

    // User description
    [self assignDefaultObject:user_profile.eyeColorId toModel:model forKey:kEyeColorUserProfileField];
    [self assignDefaultObject:user_profile.height toModel:model forKey:kHeightUserProfileField];
    [self assignDefaultObject:user_profile.weight toModel:model forKey:kWeightUserProfileField];
    [self assignDefaultObject:user_profile.hairColorId toModel:model forKey:kHairColorUserProfileField];
    [self assignDefaultObject:user_profile.hairSizeId toModel:model forKey:kHairSizeUserProfileField];
    [self assignDefaultObject:user_profile.personalityId toModel:model forKey:kMainCharacteristicUserProfileField];
    [self assignDefaultObject:user_profile.appearanceId toModel:model forKey:kBodyLookUserProfileField];
    [self assignDefaultObject:user_profile.silhouetteId toModel:model forKey:kSilhouetteUserProfileField];
    [self assignDefaultObject:user_profile.maritalStatusId toModel:model forKey:kMaritalStatusUserProfileField];
    [self assignDefaultObject:user_profile.hasChildrensId toModel:model forKey:kHasChildrensUserProfileField];
    [self assignDefaultObject:user_profile.liveWithId toModel:model forKey:kWhereIsLivingUserProfileField];
    [self assignDefaultObject:user_profile.bodyHighlightId toModel:model forKey:kMyHighlightUserProfileField];
    [self assignDefaultObject:user_profile.citizenshipId toModel:model forKey:kNationUserProfileField];
    [self assignDefaultObject:user_profile.ethnicalOriginId toModel:model forKey:kEthnicalOriginUserProfileField];
    [self assignDefaultObject:user_profile.religionId toModel:model forKey:kReligionUserProfileField];
    [self assignDefaultObject:user_profile.religionLevelId toModel:model forKey:kReligionLevelUserProfileField];
    [self assignDefaultObject:user_profile.marriageOpinionId toModel:model forKey:kMarriageOpinionUserProfileField];
    [self assignDefaultObject:user_profile.romanticismId toModel:model forKey:kRomanticismLevelUserProfileField];
    [self assignDefaultObject:user_profile.wantChildrensId toModel:model forKey:kIWantChildrensUserProfileField];
    [self assignDefaultObject:user_profile.studiesId toModel:model forKey:kStudiesLevelUserProfileField];
    [self assignDefaultObject:user_profile.languagesId toModel:model forKey:kLanguagesUserProfileField];
    [self assignDefaultObject:user_profile.professionId toModel:model forKey:kMyBusinessUserProfileField];
    [self assignDefaultObject:user_profile.salaryId toModel:model forKey:kSalaryUserProfileField];
    [self assignDefaultObject:user_profile.styleId toModel:model forKey:kMyStyleUserProfileField];
    [self assignDefaultObject:user_profile.dietId toModel:model forKey:kAlimentUserProfileField];
    [self assignDefaultObject:user_profile.smokeId toModel:model forKey:kSmokeUserProfileField];
    [self assignDefaultObject:user_profile.animalsId toModel:model forKey:kAnimalsUserProfileField];
    [self assignDefaultObject:user_profile.hobbiesId toModel:model forKey:kMyHobbiesUserProfileField];
    [self assignDefaultObject:user_profile.sportsId toModel:model forKey:kMySportsUserProfileField];
    [self assignDefaultObject:user_profile.sparetimeId toModel:model forKey:kMySparetimeUserProfileField];
    [self assignDefaultObject:user_profile.musicId toModel:model forKey:kMusicUserProfileField];
    [self assignDefaultObject:user_profile.moviesId toModel:model forKey:kMoviesUserProfileField];


    // User candidate preferences
    [self assignDefaultObject:user_profile.candidateProfile.minAge toModel:model forKey:kMinAgeCandidateProfileField];
    [self assignDefaultObject:user_profile.candidateProfile.maxAge toModel:model forKey:kMaxAgeCandidateProfileField];
    [self assignDefaultObject:user_profile.candidateProfile.minHeight toModel:model forKey:kMinHeightCandidateProfileField];
    [self assignDefaultObject:user_profile.candidateProfile.maxHeight toModel:model forKey:kMaxHeightCandidateProfileField];
    [self assignDefaultObject:user_profile.candidateProfile.minWeight toModel:model forKey:kMinWeightCandidateProfileField];
    [self assignDefaultObject:user_profile.candidateProfile.maxWeight toModel:model forKey:kMaxWeightCandidateProfileField];
    [self assignDefaultObject:user_profile.candidateProfile.maritalStatusId toModel:model forKey:kMaritalStatusCandidateProfileField];
    [self assignDefaultObject:user_profile.candidateProfile.whereIsLivingId toModel:model forKey:kWhereIsLivingCandidateProfileField];
    [self assignDefaultObject:user_profile.candidateProfile.wantChildrensId toModel:model forKey:kWantChildrensCandidateProfileField];
    [self assignDefaultObject:user_profile.candidateProfile.hasChildrensId toModel:model forKey:kHasChildrensCandidateProfileField];
    [self assignDefaultObject:user_profile.candidateProfile.silhouetteID toModel:model forKey:kSilhouetteCandidateProfileField];
    [self assignDefaultObject:user_profile.candidateProfile.mainCharacteristicId toModel:model forKey:kMainCharacteristicCandidateProfileField];
    [self assignDefaultObject:user_profile.candidateProfile.isRomanticId toModel:model forKey:kIsRomanticCandidateProfileField];
    [self assignDefaultObject:user_profile.candidateProfile.marriageIsId toModel:model forKey:kMarriageIsCandidateProfileField];
    [self assignDefaultObject:user_profile.candidateProfile.smokesId toModel:model forKey:kSmokesCandidateProfileField];
    [self assignDefaultObject:user_profile.candidateProfile.dietId toModel:model forKey:kDietCandidateProfileField];
    [self assignDefaultObject:user_profile.candidateProfile.nationId toModel:model forKey:kNationCandidateProfileField];
    [self assignDefaultObject:user_profile.candidateProfile.ethnicalOriginId toModel:model forKey:kEthnicalOriginCandidateProfileField];
    [self assignDefaultObject:user_profile.candidateProfile.bodyLookId toModel:model forKey:kBodyLookCandidateProfileField];
    [self assignDefaultObject:user_profile.candidateProfile.hairSizeId toModel:model forKey:kHairSizeCandidateProfileField];
    [self assignDefaultObject:user_profile.candidateProfile.hairColorId toModel:model forKey:kHairColorCandidateProfileField];
    [self assignDefaultObject:user_profile.candidateProfile.eyeColorId toModel:model forKey:kEyeColorCandidateProfileField];
    [self assignDefaultObject:user_profile.candidateProfile.styleId toModel:model forKey:kStyleCandidateProfileField];
    [self assignDefaultObject:user_profile.candidateProfile.highlightId toModel:model forKey:kHighlightCandidateProfileField];
    [self assignDefaultObject:user_profile.candidateProfile.studiesMinLevelId toModel:model forKey:kStudiesMinLevelCandidateProfileField];
    [self assignDefaultObject:user_profile.candidateProfile.studiesMaxLevelId toModel:model forKey:kStudiesMaxLevelCandidateProfileField];
    [self assignDefaultObject:user_profile.candidateProfile.languagesId toModel:model forKey:kLanguagesCandidateProfileField];
    [self assignDefaultObject:user_profile.candidateProfile.religionId toModel:model forKey:kReligionCandidateProfileField];
    [self assignDefaultObject:user_profile.candidateProfile.religionLevelId toModel:model forKey:kReligionLevelCandidateProfileField];
    [self assignDefaultObject:user_profile.candidateProfile.hobbiesId toModel:model forKey:kHobbiesCandidateProfileField];
    [self assignDefaultObject:user_profile.candidateProfile.sparetimeId toModel:model forKey:kSparetimeCandidateProfileField];
    [self assignDefaultObject:user_profile.candidateProfile.musicId toModel:model forKey:kMusicCandidateProfileField];
    [self assignDefaultObject:user_profile.candidateProfile.moviesId toModel:model forKey:kMoviesCandidateProfileField];
    [self assignDefaultObject:user_profile.candidateProfile.animalsId toModel:model forKey:kAnimalsCandidateProfileField];
    [self assignDefaultObject:user_profile.candidateProfile.sportsId toModel:model forKey:kSportsCandidateProfileField];
    [self assignDefaultObject:user_profile.candidateProfile.businessId toModel:model forKey:kBusinessCandidateProfileField];
    [self assignDefaultObject:user_profile.candidateProfile.minSalaryId toModel:model forKey:kMinSalaryCandidateProfileField];
    [self assignDefaultObject:user_profile.candidateProfile.maxSalaryId toModel:model forKey:kMaxSalaryCandidateProfileField];

    return model;
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
    [self.presentationTextView setText:self.userProfile.presentation];
}

- (bool)imageIsEmpty:(UIImage *)image
{
    return ((!image.size.width) && (!image.size.height));
}

- (void)loadUserPictures
{
    // Head front picture
    if((self.userProfile.faceFrontImage) && (![self imageIsEmpty:self.userProfile.faceFrontImage]))
    {
        [self.faceFrontPhoto setImage:self.userProfile.faceFrontImage];
    }
    else
    {
        switch (self.userProfile.gender.intValue)
        {
            case kMale:     [self.faceFrontPhoto setImage:[UIImage imageNamed:@"img_user_default_front_woman.png"]];
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
            case kMale:     [self.faceProfilePhoto setImage:[UIImage imageNamed:@"img_user_default_profile_woman.png"]];
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
            case kMale:     [self.bodySilouetePhoto setImage:[UIImage imageNamed:@"img_user_default_body_woman.png"]];
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

- (void)viewDidLoad
{
    [super viewDidLoad];

    imgDesiredPictureProfile = nil;
    self.title = username;

    [self registerSelector:@selector(showFormField:) withNotification:IBAInputRequestorShowFormField];
    [self registerSelector:@selector(restoreOriginalProfileScrollSize:) withNotification:IBAInputRequestorRestoreOriginalProfileSize];

    [self loadAgeAndCity];
    [self loadUserPresentation];
    [self loadUserPictures];
    [self showNavigationBarButtons];
    [self updateTakePhotoButtonsVisibility];

    [containerButtons setHidden:profileIsEditable];

    [self setSelectedForm:kUserProfileFormMyDescription];
    [self reloadFormTableView];

    [scroll setContentSize:CGSizeMake(320, basicInformationPanelHeight + segmentsPanelHeight + formTableView.frame.size.height + bottomMarginHeight)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [presentationTextView setEditable:YES];
    [presentationTextView setUserInteractionEnabled:YES];

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

    NSMutableDictionary *model = [self retrieveUserProfileModelFromUserProfile:userProfile];

    bool showEmptyFields = NO;
    ProfileFormDataSource *profileFormDataSource = [[ProfileFormDataSource alloc] initWithModel:model isReadOnly:YES showEmptyFields:showEmptyFields withFormType:selectedForm];
    self.formDataSource = profileFormDataSource;

    editMode = false;
    [self.navigationItem setRightBarButtonItem:editButton];

    [presentationPencil setHidden:YES];
    [presentationTextView setEditable:NO];
    [presentationTextView setUserInteractionEnabled:NO];

    [self updateTakePhotoButtonsVisibility];
    [self reloadFormTableView];
}

- (void)backPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
