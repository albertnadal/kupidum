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
    float containerButtonsHeight;
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
- (UIImage *)cropSilouettePicture:(UIImage *)image;
- (NSMutableDictionary *)retrieveUserProfileModelFromUserProfile:(KPDUserProfile *)user_profile;
- (void)assignDefaultObject:(id)object toModel:(NSMutableDictionary *)model forKey:(NSString *)key;
- (NSArray *)pickListFormOptionWithObject:(id)object;

@end

@implementation UserProfileViewController

@synthesize scroll, faceFrontPhotoButton, faceProfilePhotoButton, bodySilouetePhotoButton, faceFrontPhoto, faceProfilePhoto, bodySilouetePhoto, photoPicker, presentationTextView, presentationPencil, containerButtons, containerSegments, formTypeSelector, selectedForm, userProfile;

const float basicInformationPanelHeight = 435.0;
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
        profileIsEditable = false;
        editMode = false;
        selectedForm = kUserProfileFormMyDescription;
    }

    return self;
}

- (id)initWithUsername:(NSString *)username_
{
    if(self = [super initWithNibName:@"UserProfileViewController" bundle:nil])
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

        containerButtonsHeight = profileIsEditable ? 0.0f : buttonsPanelHeight;
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

        containerButtonsHeight = profileIsEditable ? 0.0f : buttonsPanelHeight;
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
        return [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:object]];
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
    NSArray *candidateMinAgeListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:25]]];
    NSArray *candidateMaxAgeListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:40]]];
    NSArray *candidateMinHeightListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:150]]];
    NSArray *candidateMaxHeightListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:185]]];
    NSArray *candidateMinWeightListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:55]]];
    NSArray *candidateMaxWeightListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:85]]];
    NSArray *candidateMaritalStatusListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:1]]];
    NSArray *candidateWhereIsLivingListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:3]]];
    NSArray *candidateWantChildrensListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:3]]];
    NSArray *candidateHasChildrensListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:1]]];
    NSArray *candidateSilhouetteListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:2]]];
    NSArray *candidateMainCharacteristicListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:2]]];
    NSArray *candidateIsRomanticListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:2]]];
    NSArray *candidateMarriageIsListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:5]]];
    NSArray *candidateSmokesListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:4]]];
    NSArray *candidateDietListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:1]]];
    NSArray *candidateNationListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:88]]];
    NSArray *candidateEthnicalOriginListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:1]]];
    NSArray *candidateBodyLookListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:2]]];
    NSArray *candidateHairSizeListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:3]]];
    NSArray *candidateHairColorListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:3]]];
    NSArray *candidateEyeColorListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:3]]];
    NSArray *candidateStyleListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:6]]];
    NSArray *candidateHighlightListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:13]]];
    NSArray *candidateStudiesMinLevelListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:2]]];
    NSArray *candidateStudiesMaxLevelListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:4]]];
    NSArray *candidateLanguagesListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:13]]];
    NSArray *candidateReligionListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:11]]];
    NSArray *candidateReligionLevelListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:1]]];
    NSArray *candidateHobbiesListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:10]]];
    NSArray *candidateSparetimeListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:9]]];
    NSArray *candidateMusicListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:21]]];
    NSArray *candidateMoviesListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:5]]];
    NSArray *candidateAnimalsListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:9]]];
    NSArray *candidateSportsListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:25]]];
    NSArray *candidateBusinessListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:43]]];
    NSArray *candidateMinSalaryListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:3]]];
    NSArray *candidateMaxSalaryListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:4]]];


	[model setObject:candidateMinAgeListOptions forKey:kMinAgeCandidateProfileField];
	[model setObject:candidateMaxAgeListOptions forKey:kMaxAgeCandidateProfileField];
	[model setObject:candidateMinHeightListOptions forKey:kMinHeightCandidateProfileField];
	[model setObject:candidateMaxHeightListOptions forKey:kMaxHeightCandidateProfileField];
	[model setObject:candidateMinWeightListOptions forKey:kMinWeightCandidateProfileField];
	[model setObject:candidateMaxWeightListOptions forKey:kMaxWeightCandidateProfileField];
	[model setObject:candidateMaritalStatusListOptions forKey:kMaritalStatusCandidateProfileField];
	[model setObject:candidateWhereIsLivingListOptions forKey:kWhereIsLivingCandidateProfileField];
	[model setObject:candidateWantChildrensListOptions forKey:kWantChildrensCandidateProfileField];
	[model setObject:candidateHasChildrensListOptions forKey:kHasChildrensCandidateProfileField];
	[model setObject:candidateSilhouetteListOptions forKey:kSilhouetteCandidateProfileField];
	[model setObject:candidateMainCharacteristicListOptions forKey:kMainCharacteristicCandidateProfileField];
	[model setObject:candidateIsRomanticListOptions forKey:kIsRomanticCandidateProfileField];
	[model setObject:candidateMarriageIsListOptions forKey:kMarriageIsCandidateProfileField];
	[model setObject:candidateSmokesListOptions forKey:kSmokesCandidateProfileField];
	[model setObject:candidateDietListOptions forKey:kDietCandidateProfileField];
	[model setObject:candidateNationListOptions forKey:kNationCandidateProfileField];
	[model setObject:candidateEthnicalOriginListOptions forKey:kEthnicalOriginCandidateProfileField];
	[model setObject:candidateBodyLookListOptions forKey:kBodyLookCandidateProfileField];
	[model setObject:candidateHairSizeListOptions forKey:kHairSizeCandidateProfileField];
	[model setObject:candidateHairColorListOptions forKey:kHairColorCandidateProfileField];
	[model setObject:candidateEyeColorListOptions forKey:kEyeColorCandidateProfileField];
	[model setObject:candidateStyleListOptions forKey:kStyleCandidateProfileField];
	[model setObject:candidateHighlightListOptions forKey:kHighlightCandidateProfileField];
	[model setObject:candidateStudiesMinLevelListOptions forKey:kStudiesMinLevelCandidateProfileField];
	[model setObject:candidateStudiesMaxLevelListOptions forKey:kStudiesMaxLevelCandidateProfileField];
	[model setObject:candidateLanguagesListOptions forKey:kLanguagesCandidateProfileField];
	[model setObject:candidateReligionListOptions forKey:kReligionCandidateProfileField];
	[model setObject:candidateReligionLevelListOptions forKey:kReligionLevelCandidateProfileField];
	[model setObject:candidateHobbiesListOptions forKey:kMyHobbiesCandidateProfileField];
	[model setObject:candidateSparetimeListOptions forKey:kMySparetimeCandidateProfileField];
	[model setObject:candidateMusicListOptions forKey:kMusicCandidateProfileField];
	[model setObject:candidateMoviesListOptions forKey:kMoviesCandidateProfileField];
	[model setObject:candidateAnimalsListOptions forKey:kAnimalsCandidateProfileField];    
	[model setObject:candidateSportsListOptions forKey:kSportsCandidateProfileField];
	[model setObject:candidateBusinessListOptions forKey:kBusinessCandidateProfileField];
	[model setObject:candidateMinSalaryListOptions forKey:kMinSalaryCandidateProfileField];
	[model setObject:candidateMaxSalaryListOptions forKey:kMaxSalaryCandidateProfileField];

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
    [scroll setContentSize:CGSizeMake(320, basicInformationPanelHeight + containerButtonsHeight + segmentsPanelHeight + formTableView.frame.size.height + bottomMarginHeight)];
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
    [scroll setContentSize:CGSizeMake(320, basicInformationPanelHeight + containerButtonsHeight + segmentsPanelHeight + detailedInformationPanelHeight + scroll.frame.size.height)];

	NSIndexPath *indexPath = [[notification userInfo] objectForKey:@"indexPath"];

    int formHeightToIndex = [(ProfileFormDataSource *)self.formDataSource getFormHeightToIndex:indexPath withCellHeight:fieldCellHeight];

    CGRect scrollToArea = CGRectMake(0, basicInformationPanelHeight + formHeightToIndex, 320, scroll.frame.size.height);

    [self.scroll scrollRectToVisible:scrollToArea animated:YES];
}

- (void)loadTableView
{
    if(formTableView)
        [formTableView removeFromSuperview];

	formTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, basicInformationPanelHeight + containerButtonsHeight + segmentsPanelHeight, 320, detailedInformationPanelHeight) style:UITableViewStyleGrouped];
	[formTableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[self setTableView:formTableView];
    [formTableView setScrollEnabled:NO];

    // update the form height after load the model
    CGRect formTableViewFrame = formTableView.frame;
    formTableViewFrame.size.height = [(ProfileFormDataSource *)self.formDataSource height];
    [formTableView setFrame:formTableViewFrame];

    // set container segments position
    if(profileIsEditable)
    {
        CGRect containerSegmentsFrame = containerSegments.frame;
        containerSegmentsFrame.origin.y = containerButtons.frame.origin.y;
        [containerSegments setFrame:containerSegmentsFrame];
    }

    // update scroll content size
    [scroll setContentSize:CGSizeMake(320, basicInformationPanelHeight + containerButtonsHeight + segmentsPanelHeight + formTableView.frame.size.height + bottomMarginHeight)];

    [self.scroll addSubview:formTableView];    
}

- (void)loadView
{
	[super loadView];
    [self loadTableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    imgDesiredPictureProfile = nil;
    self.title = username;

    [self registerSelector:@selector(showFormField:) withNotification:IBAInputRequestorShowFormField];
    [self registerSelector:@selector(restoreOriginalProfileScrollSize:) withNotification:IBAInputRequestorRestoreOriginalProfileSize];

    [self showNavigationBarButtons];
    [self updateTakePhotoButtonsVisibility];

    [containerButtons setHidden:profileIsEditable];

    [scroll setContentSize:CGSizeMake(320, basicInformationPanelHeight + containerButtonsHeight + segmentsPanelHeight + formTableView.frame.size.height + bottomMarginHeight)];
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
    [scroll setContentSize:CGSizeMake(320, basicInformationPanelHeight + containerButtonsHeight + segmentsPanelHeight + formTableView.frame.size.height + bottomMarginHeight)];
    
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

- (void)saveUserProfile
{
    if([self.formDataSource respondsToSelector:@selector(getModelWithValues)])
        NSLog(@"Model: %@", [(ProfileFormDataSource *)self.formDataSource getModelWithValues]);

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
