//
// Copyright 2010 Itty Bitty Apps Pty Ltd
// 
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this 
// file except in compliance with the License. You may obtain a copy of the License at 
// 
// http://www.apache.org/licenses/LICENSE-2.0 
// 
// Unless required by applicable law or agreed to in writing, software distributed under
// the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
// ANY KIND, either express or implied. See the License for the specific language governing
// permissions and limitations under the License.
//

#import <IBAForms/IBAFormDataSource.h>

static NSString *const kEyeColorUserProfileField = @"kEyeColor";
static NSString *const kHeightUserProfileField = @"kHeight";
static NSString *const kWeightUserProfileField = @"kWeight";
static NSString *const kHairColorUserProfileField = @"kHairColor";
static NSString *const kHairSizeUserProfileField = @"kHairSize";
static NSString *const kBodyLookUserProfileField = @"kBodyLook";
static NSString *const kMainCharacteristicUserProfileField = @"kMainCharacteristic";
static NSString *const kSilhouetteUserProfileField = @"kSilhouette";
static NSString *const kMyHighlightUserProfileField = @"kMyHighlight";
static NSString *const kMaritalStatusUserProfileField = @"kMaritalStatus";
static NSString *const kHasChildrensUserProfileField = @"kHasChildrens";
static NSString *const kWhereIsLivingUserProfileField = @"kWhereIsLiving";
static NSString *const kNationUserProfileField = @"kNation";
static NSString *const kEthnicalOriginUserProfileField = @"kEthnicalOrigin";
static NSString *const kReligionUserProfileField = @"kReligion";
static NSString *const kReligionLevelUserProfileField = @"kReligionLevel";
static NSString *const kMarriageOpinionUserProfileField = @"kMarriageOpinion";
static NSString *const kRomanticismLevelUserProfileField = @"kRomanticismLevel";
static NSString *const kIWantChildrensUserProfileField = @"kIWantChildren";
static NSString *const kStudiesLevelUserProfileField = @"kStudiesLevel";
static NSString *const kLanguagesUserProfileField = @"kLanguages";
static NSString *const kMyBusinessUserProfileField = @"kMyBusiness";
static NSString *const kSalaryUserProfileField = @"kSalary";
static NSString *const kMyStyleUserProfileField = @"kMyStyle";
static NSString *const kAlimentUserProfileField = @"kAliment";
static NSString *const kSmokeUserProfileField = @"kSmoke";
static NSString *const kAnimalsUserProfileField = @"kAnimals";
static NSString *const kMyHobbiesUserProfileField = @"kMyHobbies";
static NSString *const kMySportsUserProfileField = @"kMySports";
static NSString *const kMySparetimeUserProfileField = @"kMySparetime";
static NSString *const kMusicUserProfileField = @"kMusic";
static NSString *const kMoviesUserProfileField = @"kMovies";

static NSString *const kMinAgeCandidateProfileField = @"kMinAgeCandidate";
static NSString *const kMaxAgeCandidateProfileField = @"kMaxAgeCandidate";
static NSString *const kMinHeightCandidateProfileField = @"kMinHeightCandidate";
static NSString *const kMaxHeightCandidateProfileField = @"kMaxHeightCandidate";
static NSString *const kMinWeightCandidateProfileField = @"kMinWeightCandidate";
static NSString *const kMaxWeightCandidateProfileField = @"kMaxWeightCandidate";
static NSString *const kMaritalStatusCandidateProfileField = @"kMaritalStatusCandidate";
static NSString *const kWhereIsLivingCandidateProfileField = @"kWhereIsLivingCandidate";
static NSString *const kWantChildrensCandidateProfileField = @"kWantChildrensCandidate";
static NSString *const kHasChildrensCandidateProfileField = @"kHasChildrensCandidate";
static NSString *const kSilhouetteCandidateProfileField = @"kSilhouetteCandidate";
static NSString *const kMainCharacteristicCandidateProfileField = @"kMainCharacteristicCandidate";
static NSString *const kIsRomanticCandidateProfileField = @"kIsRomanticCandidate";
static NSString *const kMarriageIsCandidateProfileField = @"kMarriageIsCandidate";
static NSString *const kSmokesCandidateProfileField = @"kSmokesCandidate";
static NSString *const kDietCandidateProfileField = @"kDietCandidate";
static NSString *const kNationCandidateProfileField = @"kNationCandidate";
static NSString *const kEthnicalOriginCandidateProfileField = @"kEthnicalOriginCandidate";
static NSString *const kBodyLookCandidateProfileField = @"kBodyLookCandidate";
static NSString *const kHairSizeCandidateProfileField = @"kHairSizeCandidate";
static NSString *const kHairColorCandidateProfileField = @"kHairColorCandidate";
static NSString *const kEyeColorCandidateProfileField = @"kEyeColorCandidate";
static NSString *const kStyleCandidateProfileField = @"kStyleCandidate";
static NSString *const kHighlightCandidateProfileField = @"kHighlightCandidate";
static NSString *const kStudiesMinLevelCandidateProfileField = @"kStudiesMinLevelCandidate";
static NSString *const kStudiesMaxLevelCandidateProfileField = @"kStudiesMaxLevelCandidate";
static NSString *const kLanguagesCandidateProfileField = @"kLanguagesCandidate";
static NSString *const kReligionCandidateProfileField = @"kReligionCandidate";
static NSString *const kReligionLevelCandidateProfileField = @"kReligionLevelCandidate";
static NSString *const kHobbiesCandidateProfileField = @"kMyHobbiesCandidate";
static NSString *const kSparetimeCandidateProfileField = @"kMySparetimeCandidate";
static NSString *const kMusicCandidateProfileField = @"kMusicCandidate";
static NSString *const kMoviesCandidateProfileField = @"kMoviesCandidate";
static NSString *const kAnimalsCandidateProfileField = @"kAnimalsCandidate";
static NSString *const kSportsCandidateProfileField = @"kSportsCandidate";
static NSString *const kBusinessCandidateProfileField = @"kBusinessCandidate";
static NSString *const kMinSalaryCandidateProfileField = @"kMinSalaryCandidate";
static NSString *const kMaxSalaryCandidateProfileField = @"kMaxSalaryCandidate";


typedef enum UserProfileFormType
{
    kUserProfileFormMyDescription,
    kUserProfileFormLookingFor
}UserProfileFormType;

@interface ProfileFormDataSource : IBAFormDataSource {
    bool isReadOnly;
    bool showEmptyFields;
	IBAFormFieldStyle *readOnlyStyle;
	IBAFormFieldStyle *readWriteStyle;
    int height;

    int numberOfFieldsInAppearanceSection;
    int numberOfFieldsInSituationSection;
    int numberOfFieldsInValuesSection;
    int numberOfFieldsInProfessionalSection;
    int numberOfFieldsInLifestyleSection;
    int numberOfFieldsInInterestsSection;
    int numberOfFieldsInCultureSection;

    UserProfileFormType selectedForm;
}

@property (atomic) bool isReadOnly;
@property (atomic) int height;
@property (atomic) UserProfileFormType selectedForm;

- (id)initWithModel:(id)aModel isReadOnly:(bool)readOnly showEmptyFields:(bool)showEmpty withFormType:(UserProfileFormType)formType;
- (void)loadStyles;
- (void)reloadData;
- (void)reloadLookingForForm;
- (void)reloadMyDescriptionForm;
- (NSDictionary *)getModelWithValues;
- (void)setReadOnly:(bool)readOnly;
- (int)userSelectedIdentifierForKeyPath:(NSString *)keyPath;
- (int)getFormHeightToIndex:(NSIndexPath *)indexPath withCellHeight:(float)fieldCellHeight;
- (void)processSelectedValueForKeyPath:(NSString *)formKey withKeyValuesInArray:(NSArray *)listOptions;

@end
