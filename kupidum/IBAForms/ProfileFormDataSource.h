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

static const NSString *kEyeColorUserProfileField = @"kEyeColor";
#pragma unused(kEyeColorUserProfileField)
static const NSString *kHeightUserProfileField = @"kHeight";
#pragma unused(kHeightUserProfileField)
static const NSString *kWeightUserProfileField = @"kWeight";
#pragma unused(kWeightUserProfileField)
static const NSString *kHairColorUserProfileField = @"kHairColor";
#pragma unused(kHairColorUserProfileField)
static const NSString *kHairSizeUserProfileField = @"kHairSize";
#pragma unused(kHairSizeUserProfileField)
static const NSString *kBodyLookUserProfileField = @"kBodyLook";
#pragma unused(kBodyLookUserProfileField)
static const NSString *kMyHighlightUserProfileField = @"kMyHighlight";
#pragma unused(kMyHighlightUserProfileField)
static const NSString *kNationUserProfileField = @"kNation";
#pragma unused(kNationUserProfileField)
static const NSString *kEthnicalOriginUserProfileField = @"kEthnicalOrigin";
#pragma unused(kEthnicalOriginUserProfileField)
static const NSString *kReligionUserProfileField = @"kReligion";
#pragma unused(kReligionUserProfileField)
static const NSString *kReligionLevelUserProfileField = @"kReligionLevel";
#pragma unused(kReligionLevelUserProfileField)
static const NSString *kMarriageOpinionUserProfileField = @"kMarriageOpinion";
#pragma unused(kMarriageOpinionUserProfileField)
static const NSString *kRomanticismLevelUserProfileField = @"kRomanticismLevel";
#pragma unused(kRomanticismLevelUserProfileField)
static const NSString *kIWantChildrensUserProfileField = @"kIWantChildren";
#pragma unused(kIWantChildrensUserProfileField)
static const NSString *kStudiesLevelUserProfileField = @"kStudiesLevel";
#pragma unused(kStudiesLevelUserProfileField)
static const NSString *kLanguagesUserProfileField = @"kLanguages";
#pragma unused(kLanguagesUserProfileField)
static const NSString *kMyBusinessUserProfileField = @"kMyBusiness";
#pragma unused(kMyBusinessUserProfileField)
static const NSString *kSalaryUserProfileField = @"kSalary";
#pragma unused(kSalaryUserProfileField)
static const NSString *kMyStyleUserProfileField = @"kMyStyle";
#pragma unused(kMyStyleUserProfileField)
static const NSString *kAlimentUserProfileField = @"kAliment";
#pragma unused(kAlimentUserProfileField)
static const NSString *kSmokeUserProfileField = @"kSmoke";
#pragma unused(kSmokeUserProfileField)
static const NSString *kAnimalsUserProfileField = @"kAnimals";
#pragma unused(kAnimalsUserProfileField)
static const NSString *kMyHobbiesUserProfileField = @"kMyHobbies";
#pragma unused(kMyHobbiesUserProfileField)
static const NSString *kMySportsUserProfileField = @"kMySports";
#pragma unused(kMySportsUserProfileField)
static const NSString *kMySparetimeUserProfileField = @"kMySparetime";
#pragma unused(kMySparetimeUserProfileField)
static const NSString *kMusicUserProfileField = @"kMusic";
#pragma unused(kMusicUserProfileField)
static const NSString *kMoviesUserProfileField = @"kMovies";
#pragma unused(kMoviesUserProfileField)

@interface ProfileFormDataSource : IBAFormDataSource {
    bool isReadOnly;
	IBAFormFieldStyle *readOnlyStyle;
	IBAFormFieldStyle *readWriteStyle;
}

@property (atomic) bool isReadOnly;

- (id)initWithModel:(id)aModel isReadOnly:(bool)readOnly;
- (void)loadStyles;
- (void)reloadData;
- (NSDictionary *)getModelWithValues;
- (void)setReadOnly:(bool)readOnly;

@end
