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
static const NSString *kHeightUserProfileField = @"kHeight";
static const NSString *kWeightUserProfileField = @"kWeight";
static const NSString *kHairColorUserProfileField = @"kHairColor";
static const NSString *kHairSizeUserProfileField = @"kHairSize";
static const NSString *kBodyLookUserProfileField = @"kBodyLook";
static const NSString *kMyHighlightUserProfileField = @"kMyHighlight";
static const NSString *kNationUserProfileField = @"kNation";
static const NSString *kEthnicalOriginUserProfileField = @"kEthnicalOrigin";
static const NSString *kReligionUserProfileField = @"kReligion";
static const NSString *kReligionLevelUserProfileField = @"kReligionLevel";
static const NSString *kMarriageOpinionUserProfileField = @"kMarriageOpinion";
static const NSString *kRomanticismLevelUserProfileField = @"kRomanticismLevel";
static const NSString *kIWantChildrensUserProfileField = @"kIWantChildren";
static const NSString *kStudiesLevelUserProfileField = @"kStudiesLevel";
static const NSString *kLanguagesUserProfileField = @"kLanguages";
static const NSString *kMyBusinessUserProfileField = @"kMyBusiness";
static const NSString *kSalaryUserProfileField = @"kSalary";
static const NSString *kMyStyleUserProfileField = @"kMyStyle";
static const NSString *kAlimentUserProfileField = @"kAliment";
static const NSString *kSmokeUserProfileField = @"kSmoke";
static const NSString *kAnimalsUserProfileField = @"kAnimals";
static const NSString *kMyHobbiesUserProfileField = @"kMyHobbies";
static const NSString *kMySportsUserProfileField = @"kMySports";
static const NSString *kMySparetimeUserProfileField = @"kMySparetime";
static const NSString *kMusicUserProfileField = @"kMusic";
static const NSString *kMoviesUserProfileField = @"kMovies";

@interface ProfileFormDataSource : IBAFormDataSource {
	IBAFormFieldStyle *readOnlyStyle;
	IBAFormFieldStyle *readWriteStyle;
}

- (id)initWithModel:(id)aModel isReadOnly:(bool)readOnly;
- (void)loadStyles;
- (NSDictionary *)getModelWithValues;

@end
