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
- (NSMutableDictionary *)retrieveUserProfileModelForUser:(NSString *)username_;

@end

@implementation UserProfileViewController

@synthesize scroll, faceFrontPhotoButton, faceProfilePhotoButton, bodySilouetePhotoButton, faceFrontPhoto, faceProfilePhoto, bodySilouetePhoto, photoPicker, presentationTextView, presentationPencil, containerButtons, containerSegments, formTypeSelector, selectedForm;

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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withUsername:(NSString *)username_
{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        username = username_;
        imgDesiredPictureProfile = nil;
        formTableView = nil;

        NSMutableDictionary *model = [self retrieveUserProfileModelForUser:username];
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

- (NSMutableDictionary *)retrieveUserProfileModelForUser:(NSString *)username_
{
	NSMutableDictionary *model = [[NSMutableDictionary alloc] init];

    // User description
    NSArray *selectedEyeColorListOption = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:6]]];
    NSArray *heightListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:180]]];
    NSArray *weightListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:85]]];
    NSArray *hairColorListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:3]]];
    NSArray *hairSizeListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:3]]];
    NSArray *mainCharacteristicSizeListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:16]]];
    NSArray *bodyLookListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:3]]];
    NSArray *silhouetteListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:5]]];
    NSArray *maritalStatusListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:1]]];
    NSArray *hasChildrensListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:1]]];
    NSArray *whereIsLivingListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:1]]];
    NSArray *myHighlightListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:1]]];
    NSArray *citizenshipListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:56]]];
    NSArray *ethnicalOriginListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:1]]];
    NSArray *religionListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:25]]];
    NSArray *religionLevelListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:2]]];
    NSArray *marriageOpinionListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:5]]];
    NSArray *romanticismLevelListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:2]]];
    NSArray *iWantChildrensListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:3]]];
    NSArray *studiesLevelListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:5]]];
    NSArray *languagesListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObjects:[NSNumber numberWithInt:13], [NSNumber numberWithInt:19], nil]];
    NSArray *myBusinessListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:37]]];
    NSArray *salaryListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:4]]];
    NSArray *myStyleListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:9]]];
    NSArray *alimentListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:1]]];
    NSArray *smokeListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:1]]];
    NSArray *animalsListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:2]]];
    NSArray *myHobbiesListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:20]]];
    NSArray *mySportsListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:9]]];
    NSArray *mySparetimeListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:1]]];
    NSArray *musicListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:11]]];
    NSArray *moviesListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:[NSNumber numberWithInt:11]]];

	[model setObject:selectedEyeColorListOption forKey:kEyeColorUserProfileField];
    [model setObject:heightListOptions forKey:kHeightUserProfileField];
	[model setObject:weightListOptions forKey:kWeightUserProfileField];
	[model setObject:hairColorListOptions forKey:kHairColorUserProfileField];
	[model setObject:hairSizeListOptions forKey:kHairSizeUserProfileField];
	[model setObject:mainCharacteristicSizeListOptions forKey:kMainCharacteristicUserProfileField];
	[model setObject:bodyLookListOptions forKey:kBodyLookUserProfileField];
	[model setObject:silhouetteListOptions forKey:kSilhouetteUserProfileField];
	[model setObject:maritalStatusListOptions forKey:kMaritalStatusUserProfileField];
	[model setObject:hasChildrensListOptions forKey:kHasChildrensUserProfileField];
	[model setObject:whereIsLivingListOptions forKey:kWhereIsLivingUserProfileField];
	[model setObject:myHighlightListOptions forKey:kMyHighlightUserProfileField];
	[model setObject:citizenshipListOptions forKey:kNationUserProfileField];
	[model setObject:ethnicalOriginListOptions forKey:kEthnicalOriginUserProfileField];
	[model setObject:religionListOptions forKey:kReligionUserProfileField];
	[model setObject:religionLevelListOptions forKey:kReligionLevelUserProfileField];
	[model setObject:marriageOpinionListOptions forKey:kMarriageOpinionUserProfileField];
	[model setObject:romanticismLevelListOptions forKey:kRomanticismLevelUserProfileField];
	[model setObject:iWantChildrensListOptions forKey:kIWantChildrensUserProfileField];
	[model setObject:studiesLevelListOptions forKey:kStudiesLevelUserProfileField];
	[model setObject:languagesListOptions forKey:kLanguagesUserProfileField];
	[model setObject:myBusinessListOptions forKey:kMyBusinessUserProfileField];
	[model setObject:salaryListOptions forKey:kSalaryUserProfileField];
	[model setObject:myStyleListOptions forKey:kMyStyleUserProfileField];
	[model setObject:alimentListOptions forKey:kAlimentUserProfileField];
	[model setObject:smokeListOptions forKey:kSmokeUserProfileField];
	[model setObject:animalsListOptions forKey:kAnimalsUserProfileField];
	[model setObject:myHobbiesListOptions forKey:kMyHobbiesUserProfileField];
	[model setObject:mySportsListOptions forKey:kMySportsUserProfileField];
	[model setObject:mySparetimeListOptions forKey:kMySparetimeUserProfileField];
	[model setObject:musicListOptions forKey:kMusicUserProfileField];
	[model setObject:moviesListOptions forKey:kMoviesUserProfileField];


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
