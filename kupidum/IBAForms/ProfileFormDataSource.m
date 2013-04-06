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

#import <IBAForms/IBAForms.h>
#import "ProfileFormDataSource.h"

static const int kUserProfileFormCellHeight = 44;
static const int kUserProfileFormHeaderCellHeight = 48;

@implementation ProfileFormDataSource

@synthesize isReadOnly;
@synthesize height;
@synthesize selectedForm;

- (id)initWithModel:(id)aModel isReadOnly:(bool)readOnly showEmptyFields:(bool)showEmpty withFormType:(UserProfileFormType)formType
{
	if (self = [super initWithModel:aModel]) {

        isReadOnly = readOnly;
        showEmptyFields = showEmpty;
        height = 0;

        numberOfFieldsInAppearanceSection = 0;
        numberOfFieldsInValuesSection = 0;
        numberOfFieldsInProfessionalSection = 0;
        numberOfFieldsInLifestyleSection = 0;
        numberOfFieldsInInterestsSection = 0;
        numberOfFieldsInCultureSection = 0;

        selectedForm = formType;

        [self loadStyles];
        [self reloadData];
    }

    return self;
}

- (int)getFormHeightToIndex:(NSIndexPath *)indexPath withCellHeight:(float)fieldCellHeight
{
    int numberOfFieldsInSection[7] = {  numberOfFieldsInAppearanceSection + 1,
                                        numberOfFieldsInSituationSection + 1,
                                        numberOfFieldsInValuesSection + 1,
                                        numberOfFieldsInProfessionalSection + 1,
                                        numberOfFieldsInLifestyleSection + 1,
                                        numberOfFieldsInInterestsSection + 1,
                                        numberOfFieldsInCultureSection + 1 };

    float previousSectionsHeight = 0;
    for(int i=0; i <indexPath.section; i++)
        previousSectionsHeight += (numberOfFieldsInSection[i] * fieldCellHeight);

    return previousSectionsHeight + (indexPath.row * fieldCellHeight);
}

- (void)reloadData
{
    switch(selectedForm)
    {
        case kUserProfileFormMyDescription:
                                            [self reloadMyDescriptionForm];
                                            break;

        case kUserProfileFormLookingFor:
                                            [self reloadLookingForForm];
                                            break;
    }
}

- (void)reloadLookingForForm
{
    height = 0;

    numberOfFieldsInAppearanceSection = 0;
    numberOfFieldsInSituationSection = 0;
    numberOfFieldsInValuesSection = 0;
    numberOfFieldsInProfessionalSection = 0;
    numberOfFieldsInLifestyleSection = 0;
    numberOfFieldsInInterestsSection = 0;
    numberOfFieldsInCultureSection = 0;


    IBAFormFieldStyle *selectedStyle = isReadOnly ? readOnlyStyle:readWriteStyle;


    IBAFormSection *basicFieldSection = [self addSectionWithHeaderTitle:NSLocalizedString(@"La seva aparença", @"") footerTitle:nil];
    [basicFieldSection setFormFieldStyle:selectedStyle];


    NSMutableArray *minAgeArray = [[NSMutableArray alloc] init];
    [minAgeArray addObject:NSLocalizedString(@"[0]Sense especificar", @"")];
    for(int e=18; e<99; e++)
        [minAgeArray addObject:[NSString stringWithFormat:@"[%d]%d anys", e, e]];
    
    NSArray *minAgeListOptions = [IBAPickListFormOption pickListOptionsForStrings:minAgeArray];
    
    if(([self userSelectedIdentifierForKeyPath:kMinAgeCandidateProfileField]) || (showEmptyFields))
        [basicFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:kMinAgeCandidateProfileField
                                                                                title:NSLocalizedString(@"Edat mínima", @"")
                                                                     valueTransformer:nil
                                                                        selectionMode:IBAPickListSelectionModeSingle
                                                                              options:minAgeListOptions
                                                                           isReadOnly:isReadOnly]];


    NSMutableArray *maxAgeArray = [[NSMutableArray alloc] init];
    [maxAgeArray addObject:NSLocalizedString(@"[0]Sense especificar", @"")];
    for(int e=18; e<99; e++)
        [maxAgeArray addObject:[NSString stringWithFormat:@"[%d]%d anys", e, e]];
    
    NSArray *maxAgeListOptions = [IBAPickListFormOption pickListOptionsForStrings:maxAgeArray];
    
    if(([self userSelectedIdentifierForKeyPath:kMaxAgeCandidateProfileField]) || (showEmptyFields))
        [basicFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:kMaxAgeCandidateProfileField
                                                                                title:NSLocalizedString(@"Edat màxima", @"")
                                                                     valueTransformer:nil
                                                                        selectionMode:IBAPickListSelectionModeSingle
                                                                              options:maxAgeListOptions
                                                                           isReadOnly:isReadOnly]];




    NSMutableArray *minHeightArray = [[NSMutableArray alloc] init];
    [minHeightArray addObject:NSLocalizedString(@"[0]Sense especificar", @"")];
    for(int e=140; e<200; e++)
        [minHeightArray addObject:[NSString stringWithFormat:@"[%d]%d cm", e, e]];
    
    NSArray *minHeightListOptions = [IBAPickListFormOption pickListOptionsForStrings:minHeightArray];
    
    if(([self userSelectedIdentifierForKeyPath:kMinHeightCandidateProfileField]) || (showEmptyFields))
        [basicFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:kMinHeightCandidateProfileField
                                                                                title:NSLocalizedString(@"Alçada mínima", @"")
                                                                     valueTransformer:nil
                                                                        selectionMode:IBAPickListSelectionModeSingle
                                                                              options:minHeightListOptions
                                                                           isReadOnly:isReadOnly]];
    
    
    NSMutableArray *maxHeightArray = [[NSMutableArray alloc] init];
    [maxHeightArray addObject:NSLocalizedString(@"[0]Sense especificar", @"")];
    for(int e=140; e<200; e++)
        [maxHeightArray addObject:[NSString stringWithFormat:@"[%d]%d cm", e, e]];
    
    NSArray *maxHeightListOptions = [IBAPickListFormOption pickListOptionsForStrings:maxHeightArray];
    
    if(([self userSelectedIdentifierForKeyPath:kMaxHeightCandidateProfileField]) || (showEmptyFields))
        [basicFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:kMaxHeightCandidateProfileField
                                                                                title:NSLocalizedString(@"Alçada màxima", @"")
                                                                     valueTransformer:nil
                                                                        selectionMode:IBAPickListSelectionModeSingle
                                                                              options:maxHeightListOptions
                                                                           isReadOnly:isReadOnly]];



    NSMutableArray *minWeightArray = [[NSMutableArray alloc] init];
    [minWeightArray addObject:NSLocalizedString(@"[0]Sense especificar", @"")];
    for(int e=40; e<120; e++)
        [minWeightArray addObject:[NSString stringWithFormat:@"[%d]%d kg", e, e]];
    
    NSArray *minWeightListOptions = [IBAPickListFormOption pickListOptionsForStrings:minWeightArray];
    
    if(([self userSelectedIdentifierForKeyPath:kMinWeightCandidateProfileField]) || (showEmptyFields))
        [basicFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:kMinWeightCandidateProfileField
                                                                                title:NSLocalizedString(@"Pes mínim", @"")
                                                                     valueTransformer:nil
                                                                        selectionMode:IBAPickListSelectionModeSingle
                                                                              options:minWeightListOptions
                                                                           isReadOnly:isReadOnly]];


    NSMutableArray *maxWeightArray = [[NSMutableArray alloc] init];
    [maxWeightArray addObject:NSLocalizedString(@"[0]Sense especificar", @"")];
    for(int e=40; e<120; e++)
        [maxWeightArray addObject:[NSString stringWithFormat:@"[%d]%d kg", e, e]];
    
    NSArray *maxWeightListOptions = [IBAPickListFormOption pickListOptionsForStrings:maxWeightArray];
    
    if(([self userSelectedIdentifierForKeyPath:kMaxWeightCandidateProfileField]) || (showEmptyFields))
        [basicFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:kMaxWeightCandidateProfileField
                                                                                title:NSLocalizedString(@"Pes màxim", @"")
                                                                     valueTransformer:nil
                                                                        selectionMode:IBAPickListSelectionModeSingle
                                                                              options:maxWeightListOptions
                                                                           isReadOnly:isReadOnly]];



    NSArray *hairColorListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Sense especificar", @""),
                                                                                      NSLocalizedString(@"[1]Blanc", @""),
                                                                                      NSLocalizedString(@"[4]Castany", @""),
                                                                                      NSLocalizedString(@"[5]Gris", @""),
                                                                                      NSLocalizedString(@"[3]Moreno", @""),
                                                                                      NSLocalizedString(@"[7]Pèl-roig", @""),
                                                                                      NSLocalizedString(@"[2]Ros", @""),
                                                                                      nil]];
    
    if(([self userSelectedIdentifierForKeyPath:kHairColorCandidateProfileField]) || (showEmptyFields))
        [basicFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:kHairColorCandidateProfileField
                                                                                title:NSLocalizedString(@"Color del seu cabell", @"")
                                                                     valueTransformer:nil
                                                                        selectionMode:IBAPickListSelectionModeMultiple
                                                                              options:hairColorListOptions
                                                                           isReadOnly:isReadOnly]];


    NSArray *hairSizeListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Sense especificar", @""),
                                                                                     NSLocalizedString(@"[1]Rapat", @""),
                                                                                     NSLocalizedString(@"[2]Molt curt", @""),
                                                                                     NSLocalizedString(@"[3]Curt", @""),
                                                                                     NSLocalizedString(@"[4]Semillarg", @""),
                                                                                     NSLocalizedString(@"[5]Llarg", @""),
                                                                                     NSLocalizedString(@"[6]Molt llarg", @""),
                                                                                     NSLocalizedString(@"[7]Sense pèl", @""),
                                                                                     nil]];
    
    if(([self userSelectedIdentifierForKeyPath:kHairSizeCandidateProfileField]) || (showEmptyFields))
        [basicFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:kHairSizeCandidateProfileField
                                                                                title:NSLocalizedString(@"Llargada del seu cabell", @"")
                                                                     valueTransformer:nil
                                                                        selectionMode:IBAPickListSelectionModeMultiple
                                                                              options:hairSizeListOptions
                                                                           isReadOnly:isReadOnly]];



    NSArray *eyeColorListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Sense especificar", @""),
                                                                                     NSLocalizedString(@"[4]Avellana", @""),
																					 NSLocalizedString(@"[1]Blaus", @""),
																					 NSLocalizedString(@"[2]Grisos", @""),
																					 NSLocalizedString(@"[3]Marrons", @""),
																					 NSLocalizedString(@"[6]Negres", @""),
																					 NSLocalizedString(@"[5]Verds", @""),
																					 nil]];
    
    IBAPickListFormField *eyeColorPickFormField = [[IBAPickListFormField alloc] initWithKeyPath:kEyeColorCandidateProfileField
                                                                                          title:NSLocalizedString(@"Color d'ulls", @"")
                                                                               valueTransformer:nil
                                                                                  selectionMode:IBAPickListSelectionModeMultiple
                                                                                        options:eyeColorListOptions
                                                                                     isReadOnly:isReadOnly];
    
    if(([self userSelectedIdentifierForKeyPath:kEyeColorCandidateProfileField]) || (showEmptyFields))
        [basicFieldSection addFormField:eyeColorPickFormField];




    NSArray *mainCharacteristicListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Sense especificar", @""),
                                                                                               NSLocalizedString(@"[14]Atenta", @""),
                                                                                               NSLocalizedString(@"[7]Aventurera", @""),
                                                                                               NSLocalizedString(@"[21]Benhumorada", @""),
                                                                                               NSLocalizedString(@"[15]Despreocupada", @""),
                                                                                               NSLocalizedString(@"[15]Espontania", @""),
                                                                                               NSLocalizedString(@"[10]Generosa", @""),
                                                                                               NSLocalizedString(@"[3]Inquieta", @""),
                                                                                               NSLocalizedString(@"[2]Reservada", @""),
                                                                                               NSLocalizedString(@"[18]Sensible", @""),
                                                                                               NSLocalizedString(@"[16]Sociable", @""),
                                                                                               NSLocalizedString(@"[20]Tímida", @""),
                                                                                               NSLocalizedString(@"[1]Tranquila", @""),
                                                                                               NSLocalizedString(@"[9]Conciliadora", @""),
                                                                                               NSLocalizedString(@"[17]Exigent", @""),
                                                                                               NSLocalizedString(@"[6]Expansiva", @""),
                                                                                               NSLocalizedString(@"[12]Orgullosa", @""),
                                                                                               NSLocalizedString(@"[19]Posesiva", @""),
                                                                                               NSLocalizedString(@"[8]Solitaria", @""),
                                                                                               NSLocalizedString(@"[13]Supersticiosa", @""),
                                                                                               NSLocalizedString(@"[4]Tenaç", @""),
                                                                                               NSLocalizedString(@"[5]Viva", @""),
                                                                                               NSLocalizedString(@"[26]Altre", @""),
                                                                                               nil]];
    
    IBAPickListFormField *mainCharacteristicPickFormField = [[IBAPickListFormField alloc] initWithKeyPath:kMainCharacteristicCandidateProfileField
                                                                                                    title:NSLocalizedString(@"El seu caràcter", @"")
                                                                                         valueTransformer:nil
                                                                                            selectionMode:IBAPickListSelectionModeMultiple
                                                                                                  options:mainCharacteristicListOptions
                                                                                               isReadOnly:isReadOnly];
    
    if(([self userSelectedIdentifierForKeyPath:kMainCharacteristicCandidateProfileField]) || (showEmptyFields))
        [basicFieldSection addFormField:mainCharacteristicPickFormField];




    NSArray *bodyLookListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Sense especificar", @""),
                                                                                     NSLocalizedString(@"[1]Explosiu", @""),
                                                                                     NSLocalizedString(@"[2]Molt agradable de veure", @""),
                                                                                     NSLocalizedString(@"[3]Agradable de veure", @""),
                                                                                     NSLocalizedString(@"[4]En la mitjana", @""),
                                                                                     NSLocalizedString(@"[5]No gaire dolent", @""),
                                                                                     NSLocalizedString(@"[6]No ho he de dir jo", @""),
                                                                                     NSLocalizedString(@"[7]El físic no té importància", @""),
                                                                                     nil]];
    
    if(([self userSelectedIdentifierForKeyPath:kBodyLookCandidateProfileField]) || (showEmptyFields))
        [basicFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:kBodyLookCandidateProfileField
                                                                                title:NSLocalizedString(@"El seu aspecte", @"")
                                                                     valueTransformer:nil
                                                                        selectionMode:IBAPickListSelectionModeMultiple
                                                                              options:bodyLookListOptions
                                                                           isReadOnly:isReadOnly]];




    NSArray *silhouetteListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Sense especificar", @""),
                                                                                       NSLocalizedString(@"[1]Prim", @""),
                                                                                       NSLocalizedString(@"[2]Esportiva", @""),
                                                                                       NSLocalizedString(@"[3]Normal", @""),
                                                                                       NSLocalizedString(@"[4]Alguns quilos de més", @""),
                                                                                       NSLocalizedString(@"[5]Rodona", @""),
                                                                                       nil]];
    
    IBAPickListFormField *silhouettePickFormField = [[IBAPickListFormField alloc] initWithKeyPath:kSilhouetteCandidateProfileField
                                                                                            title:NSLocalizedString(@"La seva silueta", @"")
                                                                                 valueTransformer:nil
                                                                                    selectionMode:IBAPickListSelectionModeMultiple
                                                                                          options:silhouetteListOptions
                                                                                       isReadOnly:isReadOnly];
    
    if(([self userSelectedIdentifierForKeyPath:kSilhouetteCandidateProfileField]) || (showEmptyFields))
        [basicFieldSection addFormField:silhouettePickFormField];



    

    NSArray *highlightListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Sense especificar", @""),
                                                                                      NSLocalizedString(@"[3]La seva boca", @""),
                                                                                      NSLocalizedString(@"[4]El seu cabell", @""),
                                                                                      NSLocalizedString(@"[13]El seu nas", @""),
                                                                                      NSLocalizedString(@"[10]La seva nuca", @""),
                                                                                      NSLocalizedString(@"[2]El seu somriure", @""),
                                                                                      NSLocalizedString(@"[5]El seu cul", @""),
                                                                                      NSLocalizedString(@"[6]Les seves mans", @""),
                                                                                      NSLocalizedString(@"[11]Els seus músculs", @""),
                                                                                      NSLocalizedString(@"[1]Els seus ulls", @""),
                                                                                      NSLocalizedString(@"[7]Els seus pectorals", @""),
                                                                                      NSLocalizedString(@"[8]Les seves cames", @""),
                                                                                      NSLocalizedString(@"[9]Els seus peus", @""),
                                                                                      NSLocalizedString(@"[10]El més bonic no està a la llista", @""),
                                                                                      nil]];
    
    if(([self userSelectedIdentifierForKeyPath:kHighlightCandidateProfileField]) || (showEmptyFields))
        [basicFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:kHighlightCandidateProfileField
                                                                                title:NSLocalizedString(@"El més atractiu d'ell/ella", @"")
                                                                     valueTransformer:nil
                                                                        selectionMode:IBAPickListSelectionModeMultiple
                                                                              options:highlightListOptions
                                                                           isReadOnly:isReadOnly]];



    //Remove section if is empty and update form height
    for(int i=0; i<[[self sections] count]; i++)
    {
        IBAFormSection *section = [[self sections] objectAtIndex:i];
        if((section == basicFieldSection) && (![[section formFields] count]))
        {
            [[self sections] removeObjectAtIndex:i];
        }
        else if(section == basicFieldSection)
        {
            height+=kUserProfileFormHeaderCellHeight;
            height+=(kUserProfileFormCellHeight * [[section formFields] count]);
            
            numberOfFieldsInAppearanceSection = [[section formFields] count];
        }
    }

/****************/

    IBAFormSection *situationFieldSection = [self addSectionWithHeaderTitle:NSLocalizedString(@"La seva situació personal", @"") footerTitle:nil];
    [situationFieldSection setFormFieldStyle:selectedStyle];


    

    NSArray *maritalStatusListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Sense especificar", @""),
                                                                                          NSLocalizedString(@"[1]No casat mai", @""),
                                                                                          NSLocalizedString(@"[2]Casat/Casada", @""),
                                                                                          NSLocalizedString(@"[3]Separat/Separada", @""),
                                                                                          NSLocalizedString(@"[4]Divorciat/Divorciada", @""),
                                                                                          NSLocalizedString(@"[5]Vidu/Vidua", @""),
                                                                                          nil]];
    
    IBAPickListFormField *maritalStatusPickFormField = [[IBAPickListFormField alloc] initWithKeyPath:kMaritalStatusCandidateProfileField
                                                                                               title:NSLocalizedString(@"El seu estat civil", @"")
                                                                                    valueTransformer:nil
                                                                                       selectionMode:IBAPickListSelectionModeMultiple
                                                                                             options:maritalStatusListOptions
                                                                                          isReadOnly:isReadOnly];
    
    if(([self userSelectedIdentifierForKeyPath:kMaritalStatusCandidateProfileField]) || (showEmptyFields))
        [situationFieldSection addFormField:maritalStatusPickFormField];
    
    
    
    
    NSArray *hasChildrensListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Sense especificar", @""),
                                                                                         NSLocalizedString(@"[1]Cap", @""),
                                                                                         NSLocalizedString(@"[11]Sí", @""),
                                                                                         NSLocalizedString(@"[2]Sí, 1", @""),
                                                                                         NSLocalizedString(@"[3]Sí, 2", @""),
                                                                                         NSLocalizedString(@"[4]Sí, 3", @""),
                                                                                         NSLocalizedString(@"[5]Sí, 4", @""),
                                                                                         NSLocalizedString(@"[6]Sí, 5", @""),
                                                                                         NSLocalizedString(@"[7]Sí, més de 5", @""),
                                                                                         nil]];
    
    IBAPickListFormField *hasChildrensPickFormField = [[IBAPickListFormField alloc] initWithKeyPath:kHasChildrensCandidateProfileField
                                                                                              title:NSLocalizedString(@"Ell/ella te fills", @"")
                                                                                   valueTransformer:nil
                                                                                      selectionMode:IBAPickListSelectionModeMultiple
                                                                                            options:hasChildrensListOptions
                                                                                         isReadOnly:isReadOnly];
    
    if(([self userSelectedIdentifierForKeyPath:kHasChildrensCandidateProfileField]) || (showEmptyFields))
        [situationFieldSection addFormField:hasChildrensPickFormField];
    
    
    
    
    NSArray *whereIsLivingListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Sense especificar", @""),
                                                                                          NSLocalizedString(@"[1]Sol/Sola", @""),
                                                                                          NSLocalizedString(@"[3]Amb els seus fills", @""),
                                                                                          NSLocalizedString(@"[4]Amb els seus pares", @""),
                                                                                          NSLocalizedString(@"[5]En un pis compartit", @""),
                                                                                          NSLocalizedString(@"[6]Amb els seus fills part del temps", @""),
                                                                                          nil]];
    
    IBAPickListFormField *whereIsLivingPickFormField = [[IBAPickListFormField alloc] initWithKeyPath:kWhereIsLivingCandidateProfileField
                                                                                               title:NSLocalizedString(@"Ell/ella viu", @"")
                                                                                    valueTransformer:nil
                                                                                       selectionMode:IBAPickListSelectionModeMultiple
                                                                                             options:whereIsLivingListOptions
                                                                                          isReadOnly:isReadOnly];
    
    if(([self userSelectedIdentifierForKeyPath:kWhereIsLivingCandidateProfileField]) || (showEmptyFields))
        [situationFieldSection addFormField:whereIsLivingPickFormField];





    

    //Remove section if is empty and update form height
    for(int i=0; i<[[self sections] count]; i++)
    {
        IBAFormSection *section = [[self sections] objectAtIndex:i];
        if((section == situationFieldSection) && (![[section formFields] count]))
        {
            [[self sections] removeObjectAtIndex:i];
        }
        else if(section == situationFieldSection)
        {
            height+=kUserProfileFormHeaderCellHeight;
            height+=(kUserProfileFormCellHeight * [[section formFields] count]);
            
            numberOfFieldsInSituationSection = [[section formFields] count];
        }
    }



/****************/

    
    IBAFormSection *valuesFieldSection = [self addSectionWithHeaderTitle:NSLocalizedString(@"Els seus valors", @"") footerTitle:nil];
    [valuesFieldSection setFormFieldStyle:selectedStyle];

    

    
    NSArray *citizenshipListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Prefereixo no dir-ho", @""),
                                                                                        NSLocalizedString(@"[56]Espanyola", @""),
                                                                                        NSLocalizedString(@"[5]Alemana", @""),
                                                                                        NSLocalizedString(@"[10]Argentina", @""),
                                                                                        NSLocalizedString(@"[152]Britànica", @""),
                                                                                        NSLocalizedString(@"[39]Colombiana", @""),
                                                                                        NSLocalizedString(@"[58]Estadounidense", @""),
                                                                                        NSLocalizedString(@"[62]Francesa", @""),
                                                                                        NSLocalizedString(@"[88]Italiana", @""),
                                                                                        NSLocalizedString(@"[141]Peruana", @""),
                                                                                        NSLocalizedString(@"[144]Portuguesa", @""),
                                                                                        NSLocalizedString(@"[151]Rumana", @""),
                                                                                        NSLocalizedString(@"[191]Venezolana", @""),
                                                                                        NSLocalizedString(@"[1]Afgana", @""),
                                                                                        NSLocalizedString(@"[3]Albanesa", @""),
                                                                                        NSLocalizedString(@"[6]Andorrana", @""),
                                                                                        NSLocalizedString(@"[7]Angolenya", @""),
                                                                                        NSLocalizedString(@"[4]Argelina", @""),
                                                                                        NSLocalizedString(@"[11]Armenia", @""),
                                                                                        NSLocalizedString(@"[12]Australiana", @""),
                                                                                        NSLocalizedString(@"[13]Austríaca", @""),
                                                                                        NSLocalizedString(@"[14]Azerbaiyana", @""),
                                                                                        NSLocalizedString(@"[15]Bahamenya", @""),
                                                                                        NSLocalizedString(@"[16]Bahriní", @""),
                                                                                        NSLocalizedString(@"[17]Bangladeshí", @""),
                                                                                        NSLocalizedString(@"[18]Barbadense", @""),
                                                                                        NSLocalizedString(@"[20]Belga", @""),
                                                                                        NSLocalizedString(@"[21]Belicenya", @""),
                                                                                        NSLocalizedString(@"[22]Beninés", @""),
                                                                                        NSLocalizedString(@"[19]Bielorrusa", @""),
                                                                                        NSLocalizedString(@"[123]Birmana", @""),
                                                                                        NSLocalizedString(@"[24]Boliviana", @""),
                                                                                        NSLocalizedString(@"[25]Bosnia", @""),
                                                                                        NSLocalizedString(@"[26]Botsuanesa", @""),
                                                                                        NSLocalizedString(@"[27]Brasilenya", @""),
                                                                                        NSLocalizedString(@"[29]Búlgara", @""),
                                                                                        NSLocalizedString(@"[30]Burkinesa", @""),
                                                                                        NSLocalizedString(@"[31]Burundesa", @""),
                                                                                        NSLocalizedString(@"[23]Butanesa", @""),
                                                                                        NSLocalizedString(@"[35]Caboverdiana", @""),
                                                                                        NSLocalizedString(@"[32]Camboyana", @""),
                                                                                        NSLocalizedString(@"[33]Camerunesa", @""),
                                                                                        NSLocalizedString(@"[34]Canadiense", @""),
                                                                                        NSLocalizedString(@"[147]Centroafricana", @""),
                                                                                        NSLocalizedString(@"[178]Chadiana", @""),
                                                                                        NSLocalizedString(@"[150]Checa", @""),
                                                                                        NSLocalizedString(@"[36]Chilena", @""),
                                                                                        NSLocalizedString(@"[37]China", @""),
                                                                                        NSLocalizedString(@"[38]Chipriota", @""),
                                                                                        NSLocalizedString(@"[40]Comorana", @""),
                                                                                        NSLocalizedString(@"[41]Congolenya (Congo)", @""),
                                                                                        NSLocalizedString(@"[146]Congolenya (Rep. Dem. Congo)", @""),
                                                                                        NSLocalizedString(@"[44]Costarricense", @""),
                                                                                        NSLocalizedString(@"[46]Croata", @""),
                                                                                        NSLocalizedString(@"[47]Cubana", @""),
                                                                                        NSLocalizedString(@"[48]Danesa", @""),
                                                                                        NSLocalizedString(@"[8]de Antigua y Barbuda", @""),
                                                                                        NSLocalizedString(@"[28]de Brunei Darussalam", @""),
                                                                                        NSLocalizedString(@"[49]de Djibouti", @""),
                                                                                        NSLocalizedString(@"[50]de Dominica", @""),
                                                                                        NSLocalizedString(@"[53]de Emiratos Árabes Unidos", @""),
                                                                                        NSLocalizedString(@"[78]de las Islas Marshall", @""),
                                                                                        NSLocalizedString(@"[79]de las Islas Salomón", @""),
                                                                                        NSLocalizedString(@"[80]de las Islas Spratly", @""),
                                                                                        NSLocalizedString(@"[98]de Lesoto", @""),
                                                                                        NSLocalizedString(@"[103]de Liechtenstein", @""),
                                                                                        NSLocalizedString(@"[106]de Macao", @""),
                                                                                        NSLocalizedString(@"[136]de Palau", @""),
                                                                                        NSLocalizedString(@"[157]de Saint Kitts y Nevis", @""),
                                                                                        NSLocalizedString(@"[158]de San Vicente y las Granadinas", @""),
                                                                                        NSLocalizedString(@"[161]de Santo Tomé y Príncipe", @""),
                                                                                        NSLocalizedString(@"[163]de Seychelles", @""),
                                                                                        NSLocalizedString(@"[169]de Sri Lanka", @""),
                                                                                        NSLocalizedString(@"[183]de Trinidad y Tobago", @""),
                                                                                        NSLocalizedString(@"[190]de Vanuatu", @""),
                                                                                        NSLocalizedString(@"[148]Dominicana", @""),
                                                                                        NSLocalizedString(@"[71]Ecuatoguineana", @""),
                                                                                        NSLocalizedString(@"[54]Ecuatoriana", @""),
                                                                                        NSLocalizedString(@"[51]Egipcia", @""),
                                                                                        NSLocalizedString(@"[55]Eritrea", @""),
                                                                                        NSLocalizedString(@"[149]Eslovaca", @""),
                                                                                        NSLocalizedString(@"[166]Eslovena", @""),
                                                                                        NSLocalizedString(@"[57]Estonia", @""),
                                                                                        NSLocalizedString(@"[59]Etíope", @""),
                                                                                        NSLocalizedString(@"[142]Filipina", @""),
                                                                                        NSLocalizedString(@"[61]Finlandesa", @""),
                                                                                        NSLocalizedString(@"[60]Fiyiana", @""),
                                                                                        NSLocalizedString(@"[63]Gabonesa", @""),
                                                                                        NSLocalizedString(@"[64]Gambiana", @""),
                                                                                        NSLocalizedString(@"[65]Georgiana", @""),
                                                                                        NSLocalizedString(@"[66]Ghanesa", @""),
                                                                                        NSLocalizedString(@"[68]Granadina", @""),
                                                                                        NSLocalizedString(@"[67]Griega", @""),
                                                                                        NSLocalizedString(@"[69]Guatemalteca", @""),
                                                                                        NSLocalizedString(@"[70]Guineana (Guinea)", @""),
                                                                                        NSLocalizedString(@"[72]Guineana (Guinea-Bissáu)", @""),
                                                                                        NSLocalizedString(@"[73]Guyanesa", @""),
                                                                                        NSLocalizedString(@"[74]Haitiana", @""),
                                                                                        NSLocalizedString(@"[140]Holandesa", @""),
                                                                                        NSLocalizedString(@"[75]Hondurenya", @""),
                                                                                        NSLocalizedString(@"[76]Hongkonesa", @""),
                                                                                        NSLocalizedString(@"[77]Húngara", @""),
                                                                                        NSLocalizedString(@"[81]India", @""),
                                                                                        NSLocalizedString(@"[82]Indonesia", @""),
                                                                                        NSLocalizedString(@"[83]Iraní", @""),
                                                                                        NSLocalizedString(@"[84]Iraquí", @""),
                                                                                        NSLocalizedString(@"[85]Irlandesa", @""),
                                                                                        NSLocalizedString(@"[86]Islandesa", @""),
                                                                                        NSLocalizedString(@"[87]Israelí", @""),
                                                                                        NSLocalizedString(@"[89]Jamaicana", @""),
                                                                                        NSLocalizedString(@"[90]Japonesa", @""),
                                                                                        NSLocalizedString(@"[91]Jordana", @""),
                                                                                        NSLocalizedString(@"[92]Kazaja", @""),
                                                                                        NSLocalizedString(@"[93]Keniata", @""),
                                                                                        NSLocalizedString(@"[94]Kirguiza", @""),
                                                                                        NSLocalizedString(@"[95]Kiribatiana", @""),
                                                                                        NSLocalizedString(@"[96]Kuwaití", @""),
                                                                                        NSLocalizedString(@"[97]Laosiana", @""),
                                                                                        NSLocalizedString(@"[99]Letona", @""),
                                                                                        NSLocalizedString(@"[100]Libanesa", @""),
                                                                                        NSLocalizedString(@"[101]Liberiana", @""),
                                                                                        NSLocalizedString(@"[102]Libia", @""),
                                                                                        NSLocalizedString(@"[104]Lituana", @""),
                                                                                        NSLocalizedString(@"[105]Luxemburguesa", @""),
                                                                                        NSLocalizedString(@"[107]Macedonia", @""),
                                                                                        NSLocalizedString(@"[109]Malasia", @""),
                                                                                        NSLocalizedString(@"[110]Malaui", @""),
                                                                                        NSLocalizedString(@"[111]Maldiva", @""),
                                                                                        NSLocalizedString(@"[108]Malgache", @""),
                                                                                        NSLocalizedString(@"[112]Maliense", @""),
                                                                                        NSLocalizedString(@"[113]Maltesa", @""),
                                                                                        NSLocalizedString(@"[45]Marfilenya", @""),
                                                                                        NSLocalizedString(@"[114]Marroquí", @""),
                                                                                        NSLocalizedString(@"[115]Mauriciana", @""),
                                                                                        NSLocalizedString(@"[116]Mauritana", @""),
                                                                                        NSLocalizedString(@"[117]Mexicana", @""),
                                                                                        NSLocalizedString(@"[118]Micronesia", @""),
                                                                                        NSLocalizedString(@"[119]Moldava", @""),
                                                                                        NSLocalizedString(@"[120]Monegasca", @""),
                                                                                        NSLocalizedString(@"[121]Mongola", @""),
                                                                                        NSLocalizedString(@"[199]Montenegrina", @""),
                                                                                        NSLocalizedString(@"[122]Mozambiquenya", @""),
                                                                                        NSLocalizedString(@"[124]Namibia", @""),
                                                                                        NSLocalizedString(@"[125]Nauruana", @""),
                                                                                        NSLocalizedString(@"[131]Neozelandesa", @""),
                                                                                        NSLocalizedString(@"[126]Nepalesa", @""),
                                                                                        NSLocalizedString(@"[127]Nicaragüense", @""),
                                                                                        NSLocalizedString(@"[129]Nigeriana", @""),
                                                                                        NSLocalizedString(@"[128]Nigerina", @""),
                                                                                        NSLocalizedString(@"[42]Norcoreana", @""),
                                                                                        NSLocalizedString(@"[130]Noruega", @""),
                                                                                        NSLocalizedString(@"[132]Omaní", @""),
                                                                                        NSLocalizedString(@"[135]Pakistaní", @""),
                                                                                        NSLocalizedString(@"[137]Palestina", @""),
                                                                                        NSLocalizedString(@"[198]Panamenya", @""),
                                                                                        NSLocalizedString(@"[138]Papú-Neoguineana", @""),
                                                                                        NSLocalizedString(@"[139]Paraguaya", @""),
                                                                                        NSLocalizedString(@"[143]Polaca", @""),
                                                                                        NSLocalizedString(@"[197]Portorriquenyo", @""),
                                                                                        NSLocalizedString(@"[145]Qatarí", @""),
                                                                                        NSLocalizedString(@"[154]Ruandesa", @""),
                                                                                        NSLocalizedString(@"[153]Rusa", @""),
                                                                                        NSLocalizedString(@"[155]Saharahui", @""),
                                                                                        NSLocalizedString(@"[52]Salvadorenya", @""),
                                                                                        NSLocalizedString(@"[159]Samoana", @""),
                                                                                        NSLocalizedString(@"[160]Sanmarinense", @""),
                                                                                        NSLocalizedString(@"[156]Santalucense", @""),
                                                                                        NSLocalizedString(@"[9]Saudí", @""),
                                                                                        NSLocalizedString(@"[162]Senegalesa", @""),
                                                                                        NSLocalizedString(@"[194]Serbia", @""),
                                                                                        NSLocalizedString(@"[164]Sierraleonesa", @""),
                                                                                        NSLocalizedString(@"[165]Singapurense", @""),
                                                                                        NSLocalizedString(@"[174]Siria", @""),
                                                                                        NSLocalizedString(@"[167]Somalí", @""),
                                                                                        NSLocalizedString(@"[173]Suazi", @""),
                                                                                        NSLocalizedString(@"[2]Sudafricana", @""),
                                                                                        NSLocalizedString(@"[168]Sudanesa", @""),
                                                                                        NSLocalizedString(@"[170]Sueca", @""),
                                                                                        NSLocalizedString(@"[171]Suiza", @""),
                                                                                        NSLocalizedString(@"[43]Surcoreana", @""),
                                                                                        NSLocalizedString(@"[172]Surinamesa", @""),
                                                                                        NSLocalizedString(@"[179]Tailandesa", @""),
                                                                                        NSLocalizedString(@"[176]Taiwanesa", @""),
                                                                                        NSLocalizedString(@"[177]Tanzana", @""),
                                                                                        NSLocalizedString(@"[175]Tayika", @""),
                                                                                        NSLocalizedString(@"[180]Timorense", @""),
                                                                                        NSLocalizedString(@"[181]Togolesa", @""),
                                                                                        NSLocalizedString(@"[182]Tongana", @""),
                                                                                        NSLocalizedString(@"[184]Tunecina", @""),
                                                                                        NSLocalizedString(@"[186]Turca", @""),
                                                                                        NSLocalizedString(@"[185]Turcomana", @""),
                                                                                        NSLocalizedString(@"[187]Tuvaluana", @""),
                                                                                        NSLocalizedString(@"[188]Ucraniana", @""),
                                                                                        NSLocalizedString(@"[133]Ugandesa", @""),
                                                                                        NSLocalizedString(@"[189]Uruguaya", @""),
                                                                                        NSLocalizedString(@"[134]Uzbeka", @""),
                                                                                        NSLocalizedString(@"[192]Vietnamita", @""),
                                                                                        NSLocalizedString(@"[193]Yemení", @""),
                                                                                        NSLocalizedString(@"[195]Zambiana", @""),
                                                                                        NSLocalizedString(@"[196]Zimbabuense", @""),
                                                                                        nil]];
    
    IBAPickListFormField *nationPickFormField = [[IBAPickListFormField alloc] initWithKeyPath:kNationCandidateProfileField
                                                                                        title:NSLocalizedString(@"La seva nacionalitat", @"")
                                                                             valueTransformer:nil
                                                                                selectionMode:IBAPickListSelectionModeMultiple
                                                                                      options:citizenshipListOptions
                                                                                   isReadOnly:isReadOnly];
    
    if(([self userSelectedIdentifierForKeyPath:kNationCandidateProfileField]) || (showEmptyFields))
        [valuesFieldSection addFormField:nationPickFormField];
    
    
    
    
    
    NSArray *ethnicalOriginListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Sense especificar", @""),
                                                                                           NSLocalizedString(@"[1]Europeu", @""),
                                                                                           NSLocalizedString(@"[5]Hispà", @""),
                                                                                           NSLocalizedString(@"[2]Africà", @""),
                                                                                           NSLocalizedString(@"[3]Àrab", @""),
                                                                                           NSLocalizedString(@"[4]Asiàtic", @""),
                                                                                           NSLocalizedString(@"[7]Indi", @""),
                                                                                           NSLocalizedString(@"[6]Un altre", @""),
                                                                                           nil]];
    
    IBAPickListFormField *ethnicalOrigiPickFormField = [[IBAPickListFormField alloc] initWithKeyPath:kEthnicalOriginCandidateProfileField
                                                                                               title:NSLocalizedString(@"El seu origen ètnic", @"")
                                                                                    valueTransformer:nil
                                                                                       selectionMode:IBAPickListSelectionModeMultiple
                                                                                             options:ethnicalOriginListOptions
                                                                                          isReadOnly:isReadOnly];
    
    if(([self userSelectedIdentifierForKeyPath:kEthnicalOriginCandidateProfileField]) || (showEmptyFields))
        [valuesFieldSection addFormField:ethnicalOrigiPickFormField];
    
    


    NSArray *religionListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Sense especificar", @""),
                                                                                     NSLocalizedString(@"[12]Agnòstic", @""),
                                                                                     NSLocalizedString(@"[11]Ateu", @""),
                                                                                     NSLocalizedString(@"[22]Budista", @""),
                                                                                     NSLocalizedString(@"[18]Catòlic", @""),
                                                                                     NSLocalizedString(@"[25]Cristià", @""),
                                                                                     NSLocalizedString(@"[23]Hinduista", @""),
                                                                                     NSLocalizedString(@"[20]Jueu", @""),
                                                                                     NSLocalizedString(@"[21]Musulmà", @""),
                                                                                     NSLocalizedString(@"[24]Ortodox", @""),
                                                                                     NSLocalizedString(@"[19]Protestant", @""),
                                                                                     NSLocalizedString(@"[13]Un altre", @""),
                                                                                     nil]];
    
    if(([self userSelectedIdentifierForKeyPath:kReligionCandidateProfileField]) || (showEmptyFields))
        [valuesFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:kReligionCandidateProfileField
                                                                                title:NSLocalizedString(@"La seva religió", @"")
                                                                     valueTransformer:nil
                                                                        selectionMode:IBAPickListSelectionModeMultiple
                                                                              options:religionListOptions
                                                                           isReadOnly:isReadOnly]];
    
    
    
    NSArray *religionLevelListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Sense especificar", @""),
                                                                                          NSLocalizedString(@"[1]Practicant", @""),
                                                                                          NSLocalizedString(@"[2]Practicant ocasional", @""),
                                                                                          NSLocalizedString(@"[3]No practicant", @""),
                                                                                          nil]];
    
    if(([self userSelectedIdentifierForKeyPath:kReligionLevelCandidateProfileField]) || (showEmptyFields))
        [valuesFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:kReligionLevelCandidateProfileField
                                                                                title:NSLocalizedString(@"Pràctica religiosa", @"")
                                                                     valueTransformer:nil
                                                                        selectionMode:IBAPickListSelectionModeMultiple
                                                                              options:religionLevelListOptions
                                                                           isReadOnly:isReadOnly]];


    NSArray *marriageIsListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Sense especificar", @""),
                                                                                       NSLocalizedString(@"[1]Sagrat", @""),
                                                                                       NSLocalizedString(@"[2]Molt important", @""),
                                                                                       NSLocalizedString(@"[3]Important", @""),
                                                                                       NSLocalizedString(@"[4]No és indispensable", @""),
                                                                                       NSLocalizedString(@"[5]Impensable", @""),
                                                                                       NSLocalizedString(@"[6]No em tornaran a enganyar", @""),
                                                                                       nil]];
    
    IBAPickListFormField *marriageIsPickFormField = [[IBAPickListFormField alloc] initWithKeyPath:kMarriageIsCandidateProfileField
                                                                                            title:NSLocalizedString(@"Per ell/ella el matrimoni és", @"")
                                                                                 valueTransformer:nil
                                                                                    selectionMode:IBAPickListSelectionModeMultiple
                                                                                          options:marriageIsListOptions
                                                                                       isReadOnly:isReadOnly];
    
    if(([self userSelectedIdentifierForKeyPath:kMarriageIsCandidateProfileField]) || (showEmptyFields))
        [valuesFieldSection addFormField:marriageIsPickFormField];
    


    NSArray *isRomanticListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Sense especificar", @""),
                                                                                       NSLocalizedString(@"[1]Molt romàntic", @""),
                                                                                       NSLocalizedString(@"[2]Bastant romàntic", @""),
                                                                                       NSLocalizedString(@"[3]Poc romàntic", @""),
                                                                                       NSLocalizedString(@"[4]Gens romàntic", @""),
                                                                                       nil]];
    
    IBAPickListFormField *isRomanticPickFormField = [[IBAPickListFormField alloc] initWithKeyPath:kIsRomanticCandidateProfileField
                                                                                            title:NSLocalizedString(@"Ell/ella és romàntic", @"")
                                                                                 valueTransformer:nil
                                                                                    selectionMode:IBAPickListSelectionModeMultiple
                                                                                          options:isRomanticListOptions
                                                                                       isReadOnly:isReadOnly];
    
    if(([self userSelectedIdentifierForKeyPath:kIsRomanticCandidateProfileField]) || (showEmptyFields))
        [valuesFieldSection addFormField:isRomanticPickFormField];
    



    NSArray *wantChildrensListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Sense especificar", @""),
                                                                                          NSLocalizedString(@"[1]No", @""),
                                                                                          NSLocalizedString(@"[2]Sí, 1", @""),
                                                                                          NSLocalizedString(@"[3]Sí, 2", @""),
                                                                                          NSLocalizedString(@"[4]Sí, 3", @""),
                                                                                          NSLocalizedString(@"[5]Sí, més de 3", @""),
                                                                                          NSLocalizedString(@"[6]Sí, nombre encara no decidit", @""),
                                                                                          nil]];
    
    IBAPickListFormField *wantChildrensPickFormField = [[IBAPickListFormField alloc] initWithKeyPath:kWantChildrensCandidateProfileField
                                                                                               title:NSLocalizedString(@"Ell/ella vol tenir fills", @"")
                                                                                    valueTransformer:nil
                                                                                       selectionMode:IBAPickListSelectionModeMultiple
                                                                                             options:wantChildrensListOptions
                                                                                          isReadOnly:isReadOnly];
    
    if(([self userSelectedIdentifierForKeyPath:kWantChildrensCandidateProfileField]) || (showEmptyFields))
        [valuesFieldSection addFormField:wantChildrensPickFormField];



    //Remove section if is empty and update form height
    for(int i=0; i<[[self sections] count]; i++)
    {
        IBAFormSection *section = [[self sections] objectAtIndex:i];
        if((section == valuesFieldSection) && (![[section formFields] count]))
        {
            [[self sections] removeObjectAtIndex:i];
        }
        else if(section == valuesFieldSection)
        {
            height+=kUserProfileFormHeaderCellHeight;
            height+=(kUserProfileFormCellHeight * [[section formFields] count]);
            
            numberOfFieldsInValuesSection = [[section formFields] count];
        }
    }
    
    /****************/
    
    

    IBAFormSection *professionalSituationFieldSection = [self addSectionWithHeaderTitle:NSLocalizedString(@"La seva situació professional", @"") footerTitle:nil];
    [professionalSituationFieldSection setFormFieldStyle:selectedStyle];
    
    

    NSArray *studiesMinLevelListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Sense especificar", @""),
                                                                                            NSLocalizedString(@"[1]Institut o inferior", @""),
                                                                                            NSLocalizedString(@"[2]Batxillerat", @""),
                                                                                            NSLocalizedString(@"[3]Mòdul professional", @""),
                                                                                            NSLocalizedString(@"[4]Diplomat", @""),
                                                                                            NSLocalizedString(@"[5]Llicenciat o superior", @""),
                                                                                            NSLocalizedString(@"[6]Altres", @""),
                                                                                            nil]];
    
    if(([self userSelectedIdentifierForKeyPath:kStudiesMinLevelCandidateProfileField]) || (showEmptyFields))
        [professionalSituationFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:kStudiesMinLevelCandidateProfileField
                                                                                title:NSLocalizedString(@"Mínim nivell d'estudis", @"")
                                                                     valueTransformer:nil
                                                                        selectionMode:IBAPickListSelectionModeSingle
                                                                              options:studiesMinLevelListOptions
                                                                           isReadOnly:isReadOnly]];
    
    
    
    NSArray *studiesMaxLevelListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Sense especificar", @""),
                                                                                            NSLocalizedString(@"[1]Institut o inferior", @""),
                                                                                            NSLocalizedString(@"[2]Batxillerat", @""),
                                                                                            NSLocalizedString(@"[3]Mòdul professional", @""),
                                                                                            NSLocalizedString(@"[4]Diplomat", @""),
                                                                                            NSLocalizedString(@"[5]Llicenciat o superior", @""),
                                                                                            NSLocalizedString(@"[6]Altres", @""),
                                                                                            nil]];
    
    if(([self userSelectedIdentifierForKeyPath:kStudiesMaxLevelCandidateProfileField]) || (showEmptyFields))
        [professionalSituationFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:kStudiesMaxLevelCandidateProfileField
                                                                                title:NSLocalizedString(@"Màxim nivell d'estudis", @"")
                                                                     valueTransformer:nil
                                                                        selectionMode:IBAPickListSelectionModeSingle
                                                                              options:studiesMaxLevelListOptions
                                                                           isReadOnly:isReadOnly]];
    
    
    
    
    
    
    NSArray *languagesListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Sense especificar", @""),
                                                                                      NSLocalizedString(@"[4]inglés", @""),
                                                                                      NSLocalizedString(@"[22]francés", @""),
                                                                                      NSLocalizedString(@"[3]alemán", @""),
                                                                                      NSLocalizedString(@"[30]italiano", @""),
                                                                                      NSLocalizedString(@"[46]portugués", @""),
                                                                                      NSLocalizedString(@"[5]árabe", @""),
                                                                                      NSLocalizedString(@"[48]ruso", @""),
                                                                                      NSLocalizedString(@"[47]rumano", @""),
                                                                                      NSLocalizedString(@"[45]polaco", @""),
                                                                                      NSLocalizedString(@"[52]sueco", @""),
                                                                                      NSLocalizedString(@"[24]griego", @""),
                                                                                      NSLocalizedString(@"[39]holandés", @""),
                                                                                      NSLocalizedString(@"[1]afrikaner", @""),
                                                                                      NSLocalizedString(@"[2]albanés", @""),
                                                                                      NSLocalizedString(@"[6]armenio", @""),
                                                                                      NSLocalizedString(@"[7]azerbaiyano", @""),
                                                                                      NSLocalizedString(@"[8]bengalí", @""),
                                                                                      NSLocalizedString(@"[9]bielorruso", @""),
                                                                                      NSLocalizedString(@"[10]birmano", @""),
                                                                                      NSLocalizedString(@"[11]bosnio", @""),
                                                                                      NSLocalizedString(@"[12]búlgaro", @""),
                                                                                      NSLocalizedString(@"[32]canadiense", @""),
                                                                                      NSLocalizedString(@"[13]catalán", @""),
                                                                                      NSLocalizedString(@"[56]checo", @""),
                                                                                      NSLocalizedString(@"[14]chino (cantonés)", @""),
                                                                                      NSLocalizedString(@"[15]chino (mandarín)", @""),
                                                                                      NSLocalizedString(@"[16]coreano", @""),
                                                                                      NSLocalizedString(@"[17]croata", @""),
                                                                                      NSLocalizedString(@"[18]danés", @""),
                                                                                      NSLocalizedString(@"[50]eslovaco", @""),
                                                                                      NSLocalizedString(@"[51]esloveno", @""),
                                                                                      NSLocalizedString(@"[19]español", @""),
                                                                                      NSLocalizedString(@"[20]estonio", @""),
                                                                                      NSLocalizedString(@"[21]finlandés", @""),
                                                                                      NSLocalizedString(@"[23]georgiano", @""),
                                                                                      NSLocalizedString(@"[25]hebreo", @""),
                                                                                      NSLocalizedString(@"[26]hindi", @""),
                                                                                      NSLocalizedString(@"[27]húngaro", @""),
                                                                                      NSLocalizedString(@"[28]indonesio", @""),
                                                                                      NSLocalizedString(@"[29]iraní", @""),
                                                                                      NSLocalizedString(@"[31]japonés", @""),
                                                                                      NSLocalizedString(@"[33]kazajo", @""),
                                                                                      NSLocalizedString(@"[34]letón", @""),
                                                                                      NSLocalizedString(@"[35]lituano", @""),
                                                                                      NSLocalizedString(@"[36]macedonio", @""),
                                                                                      NSLocalizedString(@"[37]malasio", @""),
                                                                                      NSLocalizedString(@"[38]moldavo", @""),
                                                                                      NSLocalizedString(@"[40]nepalés", @""),
                                                                                      NSLocalizedString(@"[41]noruego", @""),
                                                                                      NSLocalizedString(@"[64]otro", @""),
                                                                                      NSLocalizedString(@"[44]pashto", @""),
                                                                                      NSLocalizedString(@"[49]serbio", @""),
                                                                                      NSLocalizedString(@"[53]suahili", @""),
                                                                                      NSLocalizedString(@"[58]tailandés", @""),
                                                                                      NSLocalizedString(@"[55]tamil", @""),
                                                                                      NSLocalizedString(@"[54]tayiko", @""),
                                                                                      NSLocalizedString(@"[57]telugu", @""),
                                                                                      NSLocalizedString(@"[59]turcomeno", @""),
                                                                                      NSLocalizedString(@"[60]turco", @""),
                                                                                      NSLocalizedString(@"[61]ucraniano", @""),
                                                                                      NSLocalizedString(@"[42]urdu", @""),
                                                                                      NSLocalizedString(@"[43]uzbeko", @""),
                                                                                      NSLocalizedString(@"[62]vietnamita", @""),
                                                                                      nil]];
    
    if(([self userSelectedIdentifierForKeyPath:kLanguagesCandidateProfileField]) || (showEmptyFields))
        [professionalSituationFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:kLanguagesCandidateProfileField
                                                                                title:NSLocalizedString(@"Idiomes que ell/ella parla", @"")
                                                                     valueTransformer:nil
                                                                        selectionMode:IBAPickListSelectionModeMultiple
                                                                              options:languagesListOptions
                                                                           isReadOnly:isReadOnly]];

    
    NSArray *businessListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Sense especificar", @""),
                                                                                     NSLocalizedString(@"[10]abogado", @""),
                                                                                     NSLocalizedString(@"[1]actor", @""),
                                                                                     NSLocalizedString(@"[2]agente de seguros", @""),
                                                                                     NSLocalizedString(@"[3]agente de viajes", @""),
                                                                                     NSLocalizedString(@"[4]agente hospitalario", @""),
                                                                                     NSLocalizedString(@"[5]agente inmobiliario", @""),
                                                                                     NSLocalizedString(@"[6]agricultor", @""),
                                                                                     NSLocalizedString(@"[11]aibliotecario, librero", @""),
                                                                                     NSLocalizedString(@"[58]arquitecto", @""),
                                                                                     NSLocalizedString(@"[92]artesano", @""),
                                                                                     NSLocalizedString(@"[8]asistente social", @""),
                                                                                     NSLocalizedString(@"[9]asistente/secretario", @""),
                                                                                     NSLocalizedString(@"[29]atención al cliente", @""),
                                                                                     NSLocalizedString(@"[48]bombero", @""),
                                                                                     NSLocalizedString(@"[54]camarero", @""),
                                                                                     NSLocalizedString(@"[20]camionero", @""),
                                                                                     NSLocalizedString(@"[19]cazatalentos", @""),
                                                                                     NSLocalizedString(@"[25]cocinero", @""),
                                                                                     NSLocalizedString(@"[22]comerciante", @""),
                                                                                     NSLocalizedString(@"[24]consultor", @""),
                                                                                     NSLocalizedString(@"[23]contable", @""),
                                                                                     NSLocalizedString(@"[26]dentista", @""),
                                                                                     NSLocalizedString(@"[55]deportista", @""),
                                                                                     NSLocalizedString(@"[17]directivo/ejecutivo superior", @""),
                                                                                     NSLocalizedString(@"[30]docente", @""),
                                                                                     NSLocalizedString(@"[65]doctor", @""),
                                                                                     NSLocalizedString(@"[28]editor", @""),
                                                                                     NSLocalizedString(@"[60]educador", @""),
                                                                                     NSLocalizedString(@"[12]ejecutivo administrativo", @""),
                                                                                     NSLocalizedString(@"[13]ejecutivo bancario", @""),
                                                                                     NSLocalizedString(@"[14]ejecutivo comercial", @""),
                                                                                     NSLocalizedString(@"[15]ejecutivo financiero", @""),
                                                                                     NSLocalizedString(@"[16]ejecutivo recursos humanos", @""),
                                                                                     NSLocalizedString(@"[52]empleado de asociación", @""),
                                                                                     NSLocalizedString(@"[61]empresario", @""),
                                                                                     NSLocalizedString(@"[36]enfermero", @""),
                                                                                     NSLocalizedString(@"[27]escritor", @""),
                                                                                     NSLocalizedString(@"[31]especialista de belleza", @""),
                                                                                     NSLocalizedString(@"[32]estudiante", @""),
                                                                                     NSLocalizedString(@"[33]florista", @""),
                                                                                     NSLocalizedString(@"[34]funcionario", @""),
                                                                                     NSLocalizedString(@"[35]grafista", @""),
                                                                                     NSLocalizedString(@"[37]ingeniero informático", @""),
                                                                                     NSLocalizedString(@"[38]ingeniero no informático", @""),
                                                                                     NSLocalizedString(@"[62]intérprete", @""),
                                                                                     NSLocalizedString(@"[51]jubilado", @""),
                                                                                     NSLocalizedString(@"[40]jurista", @""),
                                                                                     NSLocalizedString(@"[41]masajista", @""),
                                                                                     NSLocalizedString(@"[42]médico", @""),
                                                                                     NSLocalizedString(@"[43]militar", @""),
                                                                                     NSLocalizedString(@"[44]músico", @""),
                                                                                     NSLocalizedString(@"[59]notario", @""),
                                                                                     NSLocalizedString(@"[45]obrero", @""),
                                                                                     NSLocalizedString(@"[18]otros ejecutivos", @""),
                                                                                     NSLocalizedString(@"[93]panadero", @""),
                                                                                     NSLocalizedString(@"[21]peluquero", @""),
                                                                                     NSLocalizedString(@"[39]periodista", @""),
                                                                                     NSLocalizedString(@"[46]personal aéreo", @""),
                                                                                     NSLocalizedString(@"[7]pintor artístico", @""),
                                                                                     NSLocalizedString(@"[47]policía", @""),
                                                                                     NSLocalizedString(@"[49]publicista", @""),
                                                                                     NSLocalizedString(@"[50]restaurador", @""),
                                                                                     NSLocalizedString(@"[53]sin empleo", @""),
                                                                                     NSLocalizedString(@"[56]técnico", @""),
                                                                                     NSLocalizedString(@"[57]otros", @""),
                                                                                     nil]];
    
    if(([self userSelectedIdentifierForKeyPath:kBusinessCandidateProfileField]) || (showEmptyFields))
        [professionalSituationFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:kBusinessCandidateProfileField
                                                                                title:NSLocalizedString(@"La seva professió", @"")
                                                                     valueTransformer:nil
                                                                        selectionMode:IBAPickListSelectionModeMultiple
                                                                              options:businessListOptions
                                                                           isReadOnly:isReadOnly]];
    
    
    
    
    
    NSArray *minSalaryListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Sense especificar", @""),
                                                                                      NSLocalizedString(@"[1]Menys de 10.000€/any", @""),
                                                                                      NSLocalizedString(@"[2]De 10 a 20.000€/any", @""),
                                                                                      NSLocalizedString(@"[3]De 20 a 30.000€/any", @""),
                                                                                      NSLocalizedString(@"[4]De 30 a 50.000€/any", @""),
                                                                                      NSLocalizedString(@"[5]De 50 a 75.000€/any", @""),
                                                                                      NSLocalizedString(@"[6]De 75 a 100.000€/any", @""),
                                                                                      NSLocalizedString(@"[7]Més de 100.000€/any", @""),
                                                                                      nil]];
    
    if(([self userSelectedIdentifierForKeyPath:kMinSalaryCandidateProfileField]) || (showEmptyFields))
        [professionalSituationFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:kMinSalaryCandidateProfileField
                                                                                title:NSLocalizedString(@"Ingressos mínims", @"")
                                                                     valueTransformer:nil
                                                                        selectionMode:IBAPickListSelectionModeSingle
                                                                              options:minSalaryListOptions
                                                                           isReadOnly:isReadOnly]];
    
    
    NSArray *maxSalaryListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Sense especificar", @""),
                                                                                      NSLocalizedString(@"[1]Menys de 10.000€/any", @""),
                                                                                      NSLocalizedString(@"[2]De 10 a 20.000€/any", @""),
                                                                                      NSLocalizedString(@"[3]De 20 a 30.000€/any", @""),
                                                                                      NSLocalizedString(@"[4]De 30 a 50.000€/any", @""),
                                                                                      NSLocalizedString(@"[5]De 50 a 75.000€/any", @""),
                                                                                      NSLocalizedString(@"[6]De 75 a 100.000€/any", @""),
                                                                                      NSLocalizedString(@"[7]Més de 100.000€/any", @""),
                                                                                      nil]];
    
    if(([self userSelectedIdentifierForKeyPath:kMaxSalaryCandidateProfileField]) || (showEmptyFields))
        [professionalSituationFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:kMaxSalaryCandidateProfileField
                                                                                title:NSLocalizedString(@"Ingressos màxims", @"")
                                                                     valueTransformer:nil
                                                                        selectionMode:IBAPickListSelectionModeSingle
                                                                              options:maxSalaryListOptions
                                                                           isReadOnly:isReadOnly]];
    
    
    
    
    
    //Remove section if is empty and update form height
    for(int i=0; i<[[self sections] count]; i++)
    {
        IBAFormSection *section = [[self sections] objectAtIndex:i];
        if((section == professionalSituationFieldSection) && (![[section formFields] count]))
        {
            [[self sections] removeObjectAtIndex:i];
        }
        else if(section == professionalSituationFieldSection)
        {
            height+=kUserProfileFormHeaderCellHeight;
            height+=(kUserProfileFormCellHeight * [[section formFields] count]);
            
            numberOfFieldsInProfessionalSection = [[section formFields] count];
        }
    }
    

    /****************/



    IBAFormSection *lifestyleFieldSection = [self addSectionWithHeaderTitle:NSLocalizedString(@"El seu estil de vida", @"") footerTitle:nil];
    [lifestyleFieldSection setFormFieldStyle:selectedStyle];
    
    

    NSArray *myStyleListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Sense especificar", @""),
                                                                                    NSLocalizedString(@"[3]A la moda", @""),
                                                                                    NSLocalizedString(@"[8]Bohemi", @""),
                                                                                    NSLocalizedString(@"[2]Clàssic", @""),
                                                                                    NSLocalizedString(@"[6]Esportiu", @""),
                                                                                    NSLocalizedString(@"[5]Despreocupat", @""),
                                                                                    NSLocalizedString(@"[7]Ètnic", @""),
                                                                                    NSLocalizedString(@"[4]Negocis", @""),
                                                                                    NSLocalizedString(@"[1]Pijo", @""),
                                                                                    NSLocalizedString(@"[9]Rock", @""),
                                                                                    NSLocalizedString(@"[11]Altres", @""),
                                                                                    nil]];
    
    if(([self userSelectedIdentifierForKeyPath:kStyleCandidateProfileField]) || (showEmptyFields))
        [lifestyleFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:kStyleCandidateProfileField
                                                                                title:NSLocalizedString(@"El seu estil", @"")
                                                                     valueTransformer:nil
                                                                        selectionMode:IBAPickListSelectionModeMultiple
                                                                              options:myStyleListOptions
                                                                           isReadOnly:isReadOnly]];
    
    
    
    NSArray *dietListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Sense especificar", @""),
                                                                                 NSLocalizedString(@"[6]A dieta", @""),
                                                                                 NSLocalizedString(@"[4]Casher", @""),
                                                                                 NSLocalizedString(@"[1]Menja de tot", @""),
                                                                                 NSLocalizedString(@"[5]Halal", @""),
                                                                                 NSLocalizedString(@"[7]Macrobiòtic", @""),
                                                                                 NSLocalizedString(@"[3]Vegà", @""),
                                                                                 NSLocalizedString(@"[2]Vegetarià", @""),
                                                                                 nil]];
    
    IBAPickListFormField *dietPickFormField = [[IBAPickListFormField alloc] initWithKeyPath:kDietCandidateProfileField
                                                                                      title:NSLocalizedString(@"La seva dieta", @"")
                                                                           valueTransformer:nil
                                                                              selectionMode:IBAPickListSelectionModeMultiple
                                                                                    options:dietListOptions
                                                                                 isReadOnly:isReadOnly];
    
    if(([self userSelectedIdentifierForKeyPath:kDietCandidateProfileField]) || (showEmptyFields))
        [lifestyleFieldSection addFormField:dietPickFormField];
    
    
    
    
    NSArray *smokesListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Sense especificar", @""),
                                                                                   NSLocalizedString(@"[3]No (el fum no és un problema)", @""),
                                                                                   NSLocalizedString(@"[4]No (no m'agrada el fum)", @""),
                                                                                   NSLocalizedString(@"[1]Sí, ocasionalment", @""),
                                                                                   NSLocalizedString(@"[2]Sí, regularment", @""),
                                                                                   nil]];
    
    IBAPickListFormField *smokesPickFormField = [[IBAPickListFormField alloc] initWithKeyPath:kSmokesCandidateProfileField
                                                                                        title:NSLocalizedString(@"Ell/ella fuma", @"")
                                                                             valueTransformer:nil
                                                                                selectionMode:IBAPickListSelectionModeMultiple
                                                                                      options:smokesListOptions
                                                                                   isReadOnly:isReadOnly];
    
    if(([self userSelectedIdentifierForKeyPath:kSmokesCandidateProfileField]) || (showEmptyFields))
        [lifestyleFieldSection addFormField:smokesPickFormField];
    
    
    
    NSArray *animalsListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Sense especificar", @""),
                                                                                    NSLocalizedString(@"[3]Animal exòtic", @""),
                                                                                    NSLocalizedString(@"[8]Cavall/poni", @""),
                                                                                    NSLocalizedString(@"[9]Conill", @""),
                                                                                    NSLocalizedString(@"[1]Gats", @""),
                                                                                    NSLocalizedString(@"[7]Hàmster/ratolí", @""),
                                                                                    NSLocalizedString(@"[5]Insectes", @""),
                                                                                    NSLocalizedString(@"[2]Gos", @""),
                                                                                    NSLocalizedString(@"[4]Peix", @""),
                                                                                    NSLocalizedString(@"[6]Ocell", @""),
                                                                                    NSLocalizedString(@"[10]Rèptil", @""),
                                                                                    NSLocalizedString(@"[11]Altre animal", @""),
                                                                                    NSLocalizedString(@"[12]No te animals", @""),
                                                                                    nil]];
    
    if(([self userSelectedIdentifierForKeyPath:kAnimalsCandidateProfileField]) || (showEmptyFields))
        [lifestyleFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:kAnimalsCandidateProfileField
                                                                                title:NSLocalizedString(@"Els seus animals", @"")
                                                                     valueTransformer:nil
                                                                        selectionMode:IBAPickListSelectionModeMultiple
                                                                              options:animalsListOptions
                                                                           isReadOnly:isReadOnly]];
    
    

    //Remove section if is empty and update form height
    for(int i=0; i<[[self sections] count]; i++)
    {
        IBAFormSection *section = [[self sections] objectAtIndex:i];
        if((section == lifestyleFieldSection) && (![[section formFields] count]))
        {
            [[self sections] removeObjectAtIndex:i];
        }
        else if(section == lifestyleFieldSection)
        {
            height+=kUserProfileFormHeaderCellHeight;
            height+=(kUserProfileFormCellHeight * [[section formFields] count]);
            
            numberOfFieldsInLifestyleSection = [[section formFields] count];
        }
    }
    
    
    /****************/

    
    
    IBAFormSection *interestsFieldSection = [self addSectionWithHeaderTitle:NSLocalizedString(@"Els seus interessos", @"") footerTitle:nil];
    [interestsFieldSection setFormFieldStyle:selectedStyle];
    
    
    
    
    
    NSArray *myHobbiesListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Sense especificar", @""),
                                                                                      NSLocalizedString(@"[6]exposiciones/museos", @""),
                                                                                      NSLocalizedString(@"[14]informática", @""),
                                                                                      NSLocalizedString(@"[10]lectura", @""),
                                                                                      NSLocalizedString(@"[1]teatro", @""),
                                                                                      NSLocalizedString(@"[16]viajes", @""),
                                                                                      NSLocalizedString(@"[9]cocina", @""),
                                                                                      NSLocalizedString(@"[2]compras", @""),
                                                                                      NSLocalizedString(@"[15]deporte", @""),
                                                                                      NSLocalizedString(@"[22]foto", @""),
                                                                                      NSLocalizedString(@"[7]música", @""),
                                                                                      NSLocalizedString(@"[21]animales", @""),
                                                                                      NSLocalizedString(@"[12]pintura", @""),
                                                                                      NSLocalizedString(@"[24]actividad caritativa", @""),
                                                                                      NSLocalizedString(@"[27]ajedrez", @""),
                                                                                      NSLocalizedString(@"[20]automóvil", @""),
                                                                                      NSLocalizedString(@"[3]bricolaje", @""),
                                                                                      NSLocalizedString(@"[44]colección de figuritas", @""),
                                                                                      NSLocalizedString(@"[25]costura/punto", @""),
                                                                                      NSLocalizedString(@"[5]danza", @""),
                                                                                      NSLocalizedString(@"[26]decoración", @""),
                                                                                      NSLocalizedString(@"[13]dibujo", @""),
                                                                                      NSLocalizedString(@"[8]escritura", @""),
                                                                                      NSLocalizedString(@"[19]internet", @""),
                                                                                      NSLocalizedString(@"[4]jardinería", @""),
                                                                                      NSLocalizedString(@"[28]juegos de cartas", @""),
                                                                                      NSLocalizedString(@"[29]juegos de rol", @""),
                                                                                      NSLocalizedString(@"[30]juegos de sociedad", @""),
                                                                                      NSLocalizedString(@"[17]paseos", @""),
                                                                                      NSLocalizedString(@"[11]televisión", @""),
                                                                                      NSLocalizedString(@"[18]videojuegos", @""),
                                                                                      NSLocalizedString(@"[23]Altres", @""),
                                                                                      nil]];
    
    if(([self userSelectedIdentifierForKeyPath:kMyHobbiesCandidateProfileField]) || (showEmptyFields))
        [interestsFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:kMyHobbiesCandidateProfileField
                                                                                title:NSLocalizedString(@"Les seves aficions", @"")
                                                                     valueTransformer:nil
                                                                        selectionMode:IBAPickListSelectionModeMultiple
                                                                              options:myHobbiesListOptions
                                                                           isReadOnly:isReadOnly]];
    
    
    
    
    NSArray *mySportsListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Sense especificar", @""),
                                                                                     NSLocalizedString(@"[9]fútbol", @""),
                                                                                     NSLocalizedString(@"[4]baloncesto", @""),
                                                                                     NSLocalizedString(@"[41]fitness", @""),
                                                                                     NSLocalizedString(@"[34]jogging", @""),
                                                                                     NSLocalizedString(@"[17]natación", @""),
                                                                                     NSLocalizedString(@"[26]vela", @""),
                                                                                     NSLocalizedString(@"[18]windsurf", @""),
                                                                                     NSLocalizedString(@"[7]ciclismo", @""),
                                                                                     NSLocalizedString(@"[38]deportes de riesgo", @""),
                                                                                     NSLocalizedString(@"[22]ski/snowboard", @""),
                                                                                     NSLocalizedString(@"[25]tenis", @""),
                                                                                     NSLocalizedString(@"[19]surf", @""),
                                                                                     NSLocalizedString(@"[1]atletismo", @""),
                                                                                     NSLocalizedString(@"[2]automóvil", @""),
                                                                                     NSLocalizedString(@"[30]bádminton", @""),
                                                                                     NSLocalizedString(@"[12]balonmano", @""),
                                                                                     NSLocalizedString(@"[3]béisbol", @""),
                                                                                     NSLocalizedString(@"[5]boxeo", @""),
                                                                                     NSLocalizedString(@"[31]cricket", @""),
                                                                                     NSLocalizedString(@"[8]danza", @""),
                                                                                     NSLocalizedString(@"[37]deportes de combate", @""),
                                                                                     NSLocalizedString(@"[39]deportes mecánicos", @""),
                                                                                     NSLocalizedString(@"[32]equitación", @""),
                                                                                     NSLocalizedString(@"[33]fútbol americano", @""),
                                                                                     NSLocalizedString(@"[11]gimnasia", @""),
                                                                                     NSLocalizedString(@"[10]golf", @""),
                                                                                     NSLocalizedString(@"[13]hockey", @""),
                                                                                     NSLocalizedString(@"[14]judo", @""),
                                                                                     NSLocalizedString(@"[15]kárate", @""),
                                                                                     NSLocalizedString(@"[16]moto", @""),
                                                                                     NSLocalizedString(@"[29]ninguno", @""),
                                                                                     NSLocalizedString(@"[20]otros deportes acuáticos", @""),
                                                                                     NSLocalizedString(@"[36]roller", @""),
                                                                                     NSLocalizedString(@"[21]rugby", @""),
                                                                                     NSLocalizedString(@"[35]senderismo/trekking", @""),
                                                                                     NSLocalizedString(@"[24]skateboard", @""),
                                                                                     NSLocalizedString(@"[46]skiing", @""),
                                                                                     NSLocalizedString(@"[23]squash", @""),
                                                                                     NSLocalizedString(@"[40]tenis de mesa", @""),
                                                                                     NSLocalizedString(@"[27]volley-ball", @""),
                                                                                     NSLocalizedString(@"[28]Altres", @""),
                                                                                     nil]];
    
    if(([self userSelectedIdentifierForKeyPath:kSportsCandidateProfileField]) || (showEmptyFields))
        [interestsFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:kSportsCandidateProfileField
                                                                                title:NSLocalizedString(@"Els seus esports", @"")
                                                                     valueTransformer:nil
                                                                        selectionMode:IBAPickListSelectionModeMultiple
                                                                              options:mySportsListOptions
                                                                           isReadOnly:isReadOnly]];
    
    
    
    
    
    NSArray *mySparetimeListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Sense especificar", @""),
                                                                                        NSLocalizedString(@"[13]acontecimiento deportivo", @""),
                                                                                        NSLocalizedString(@"[6]after work", @""),
                                                                                        NSLocalizedString(@"[4]bares / pubs", @""),
                                                                                        NSLocalizedString(@"[9]cine", @""),
                                                                                        NSLocalizedString(@"[7]concierto", @""),
                                                                                        NSLocalizedString(@"[8]discoteca", @""),
                                                                                        NSLocalizedString(@"[10]espectáculos de danza", @""),
                                                                                        NSLocalizedString(@"[2]familia", @""),
                                                                                        NSLocalizedString(@"[11]fiestas entre amigos", @""),
                                                                                        NSLocalizedString(@"[5]ópera", @""),
                                                                                        NSLocalizedString(@"[1]restaurante", @""),
                                                                                        NSLocalizedString(@"[3]teatro", @""),
                                                                                        NSLocalizedString(@"[14]karaoke", @""),
                                                                                        NSLocalizedString(@"[15]leer", @""),
                                                                                        NSLocalizedString(@"[12]Altres", @""),
                                                                                        nil]];
    
    if(([self userSelectedIdentifierForKeyPath:kMySparetimeCandidateProfileField]) || (showEmptyFields))
        [interestsFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:kMySparetimeCandidateProfileField
                                                                                title:NSLocalizedString(@"Les seves sortides", @"")
                                                                     valueTransformer:nil
                                                                        selectionMode:IBAPickListSelectionModeMultiple
                                                                              options:mySparetimeListOptions
                                                                           isReadOnly:isReadOnly]];
    
    

    //Remove section if is empty and update form height
    for(int i=0; i<[[self sections] count]; i++)
    {
        IBAFormSection *section = [[self sections] objectAtIndex:i];
        if((section == interestsFieldSection) && (![[section formFields] count]))
        {
            [[self sections] removeObjectAtIndex:i];
        }
        else if(section == interestsFieldSection)
        {
            height+=kUserProfileFormHeaderCellHeight;
            height+=(kUserProfileFormCellHeight * [[section formFields] count]);
            
            numberOfFieldsInInterestsSection = [[section formFields] count];
        }
    }
    
    
    /****************/
    
    
    
    IBAFormSection *preferencesFieldSection = [self addSectionWithHeaderTitle:NSLocalizedString(@"Els seus gustos culturals", @"") footerTitle:nil];
    [preferencesFieldSection setFormFieldStyle:selectedStyle];
    
    

    NSArray *musicListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Sense especificar", @""),
                                                                                  NSLocalizedString(@"[24]ambiente / de relajación", @""),
                                                                                  NSLocalizedString(@"[1]blues", @""),
                                                                                  NSLocalizedString(@"[7]independiente", @""),
                                                                                  NSLocalizedString(@"[19]latina", @""),
                                                                                  NSLocalizedString(@"[20]ópera", @""),
                                                                                  NSLocalizedString(@"[23]reggae", @""),
                                                                                  NSLocalizedString(@"[2]clásica", @""),
                                                                                  NSLocalizedString(@"[4]electrónca-tecno", @""),
                                                                                  NSLocalizedString(@"[25]funk", @""),
                                                                                  NSLocalizedString(@"[8]jazz", @""),
                                                                                  NSLocalizedString(@"[11]pop-rock", @""),
                                                                                  NSLocalizedString(@"[12]rap", @""),
                                                                                  NSLocalizedString(@"[9]bandas sonoras", @""),
                                                                                  NSLocalizedString(@"[3]country", @""),
                                                                                  NSLocalizedString(@"[18]dance y DJ", @""),
                                                                                  NSLocalizedString(@"[26]disco", @""),
                                                                                  NSLocalizedString(@"[21]folk", @""),
                                                                                  NSLocalizedString(@"[22]gospel", @""),
                                                                                  NSLocalizedString(@"[6]hard rock", @""),
                                                                                  NSLocalizedString(@"[5]música tradicional", @""),
                                                                                  NSLocalizedString(@"[13]r'n'b", @""),
                                                                                  NSLocalizedString(@"[14]soul", @""),
                                                                                  NSLocalizedString(@"[15]trip-hop", @""),
                                                                                  NSLocalizedString(@"[16]variedades", @""),
                                                                                  NSLocalizedString(@"[10]world music", @""),
                                                                                  NSLocalizedString(@"[17]Altres", @""),
                                                                                  nil]];
    
    if(([self userSelectedIdentifierForKeyPath:kMusicCandidateProfileField]) || (showEmptyFields))
        [preferencesFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:kMusicCandidateProfileField
                                                                                title:NSLocalizedString(@"Els gustos musicals", @"")
                                                                     valueTransformer:nil
                                                                        selectionMode:IBAPickListSelectionModeMultiple
                                                                              options:musicListOptions
                                                                           isReadOnly:isReadOnly]];
    
    
    
    
    
    NSArray *moviesListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Sense especificar", @""),
                                                                                   NSLocalizedString(@"[2]de acción", @""),
                                                                                   NSLocalizedString(@"[4]de aventuras", @""),
                                                                                   NSLocalizedString(@"[6]de terror", @""),
                                                                                   NSLocalizedString(@"[7]documentales", @""),
                                                                                   NSLocalizedString(@"[15]las comedias sentimentales", @""),
                                                                                   NSLocalizedString(@"[11]ciencia-ficción", @""),
                                                                                   NSLocalizedString(@"[9]cómicas", @""),
                                                                                   NSLocalizedString(@"[3]de autor", @""),
                                                                                   NSLocalizedString(@"[8]dramáticas", @""),
                                                                                   NSLocalizedString(@"[12]fantásticas", @""),
                                                                                   NSLocalizedString(@"[14]las comedias musicales", @""),
                                                                                   NSLocalizedString(@"[17]policíacas", @""),
                                                                                   NSLocalizedString(@"[21]animación", @""),
                                                                                   NSLocalizedString(@"[1]cortometrajes", @""),
                                                                                   NSLocalizedString(@"[5]de guerra", @""),
                                                                                   NSLocalizedString(@"[18]de vaqueros", @""),
                                                                                   NSLocalizedString(@"[10]eróticas", @""),
                                                                                   NSLocalizedString(@"[13]históricas", @""),
                                                                                   NSLocalizedString(@"[16]los dibujos animados", @""),
                                                                                   NSLocalizedString(@"[20]manga", @""),
                                                                                   NSLocalizedString(@"[19]Altres", @""),
                                                                                   nil]];
    
    if(([self userSelectedIdentifierForKeyPath:kMoviesCandidateProfileField]) || (showEmptyFields))
        [preferencesFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:kMoviesCandidateProfileField
                                                                                title:NSLocalizedString(@"Pel·lícules preferides", @"")
                                                                     valueTransformer:nil
                                                                        selectionMode:IBAPickListSelectionModeMultiple
                                                                              options:moviesListOptions
                                         
                                                                           isReadOnly:isReadOnly]];
    
    
    //Remove section if is empty and update form height
    for(int i=0; i<[[self sections] count]; i++)
    {
        IBAFormSection *section = [[self sections] objectAtIndex:i];
        if((section == preferencesFieldSection) && (![[section formFields] count]))
        {
            [[self sections] removeObjectAtIndex:i];
        }
        else if(section == preferencesFieldSection)
        {
            height+=kUserProfileFormHeaderCellHeight;
            height+=(kUserProfileFormCellHeight * [[section formFields] count]);
            
            numberOfFieldsInCultureSection = [[section formFields] count];
        }
    }

}

- (void)reloadMyDescriptionForm
{
        height = 0;

        numberOfFieldsInAppearanceSection = 0;
        numberOfFieldsInSituationSection = 0;
        numberOfFieldsInValuesSection = 0;
        numberOfFieldsInProfessionalSection = 0;
        numberOfFieldsInLifestyleSection = 0;
        numberOfFieldsInInterestsSection = 0;
        numberOfFieldsInCultureSection = 0;


        IBAFormFieldStyle *selectedStyle = isReadOnly ? readOnlyStyle:readWriteStyle;

		// Some basic form fields that accept text input
		IBAFormSection *basicFieldSection = [self addSectionWithHeaderTitle:NSLocalizedString(@"La meva aparença", @"") footerTitle:nil];
        [basicFieldSection setFormFieldStyle:selectedStyle];


        NSMutableArray *heightArray = [[NSMutableArray alloc] init];
        [heightArray addObject:NSLocalizedString(@"[0]Prefereixo no dir-ho", @"")];
        for(int h=140; h<200; h++)
            [heightArray addObject:[NSString stringWithFormat:@"[%d]%d cm", h, h]];

		NSArray *heightListOptions = [IBAPickListFormOption pickListOptionsForStrings:heightArray];

        if(([self userSelectedIdentifierForKeyPath:kHeightUserProfileField]) || (showEmptyFields))
            [basicFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:kHeightUserProfileField
                                                                                    title:NSLocalizedString(@"Alçada", @"")
                                                                         valueTransformer:nil
                                                                            selectionMode:IBAPickListSelectionModeSingle
                                                                                  options:heightListOptions
                                                                               isReadOnly:isReadOnly]];

        NSMutableArray *weightArray = [[NSMutableArray alloc] init];
        [weightArray addObject:NSLocalizedString(@"[0]Prefereixo no dir-ho", @"")];
        for(int h=40; h<120; h++)
            [weightArray addObject:[NSString stringWithFormat:@"[%d]%d kg", h, h]];

		NSArray *weightListOptions = [IBAPickListFormOption pickListOptionsForStrings:weightArray];

        if(([self userSelectedIdentifierForKeyPath:kWeightUserProfileField]) || (showEmptyFields))
            [basicFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:kWeightUserProfileField
                                                                                    title:NSLocalizedString(@"Pes", @"")
                                                                         valueTransformer:nil
                                                                            selectionMode:IBAPickListSelectionModeSingle
                                                                                  options:weightListOptions
                                                                               isReadOnly:isReadOnly]];

		NSArray *hairColorListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Prefereixo no dir-ho", @""),
                                                                                         NSLocalizedString(@"[1]Blanc", @""),
                                                                                         NSLocalizedString(@"[4]Castany", @""),
                                                                                         NSLocalizedString(@"[5]Gris", @""),
                                                                                         NSLocalizedString(@"[3]Moreno", @""),
                                                                                         NSLocalizedString(@"[7]Pèl-roig", @""),
                                                                                         NSLocalizedString(@"[2]Ros", @""),
                                                                                         nil]];

        if(([self userSelectedIdentifierForKeyPath:kHairColorUserProfileField]) || (showEmptyFields))
            [basicFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:kHairColorUserProfileField
                                                                                    title:NSLocalizedString(@"Color del cabell", @"")
                                                                         valueTransformer:nil
                                                                            selectionMode:IBAPickListSelectionModeSingle
                                                                                  options:hairColorListOptions
                                                                               isReadOnly:isReadOnly]];

		NSArray *hairSizeListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Prefereixo no dir-ho", @""),
                                                                                          NSLocalizedString(@"[1]Rapat", @""),
                                                                                          NSLocalizedString(@"[2]Molt curt", @""),
                                                                                          NSLocalizedString(@"[3]Curt", @""),
                                                                                          NSLocalizedString(@"[4]Semillarg", @""),
                                                                                          NSLocalizedString(@"[5]Llarg", @""),
                                                                                          NSLocalizedString(@"[6]Molt llarg", @""),
                                                                                          NSLocalizedString(@"[7]Sense pèl", @""),
                                                                                          nil]];

        if(([self userSelectedIdentifierForKeyPath:kHairSizeUserProfileField]) || (showEmptyFields))
            [basicFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:kHairSizeUserProfileField
                                                                                    title:NSLocalizedString(@"Llargada del cabell", @"")
                                                                         valueTransformer:nil
                                                                            selectionMode:IBAPickListSelectionModeSingle
                                                                                  options:hairSizeListOptions
                                                                               isReadOnly:isReadOnly]];


    NSArray *eyeColorListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Prefereixo no dir-ho", @""),
                                                                                     NSLocalizedString(@"[4]Avellana", @""),
																					 NSLocalizedString(@"[1]Blaus", @""),
																					 NSLocalizedString(@"[2]Grisos", @""),
																					 NSLocalizedString(@"[3]Marrons", @""),
																					 NSLocalizedString(@"[6]Negres", @""),
																					 NSLocalizedString(@"[5]Verds", @""),
																					 nil]];
    
    IBAPickListFormField *eyeColorPickFormField = [[IBAPickListFormField alloc] initWithKeyPath:kEyeColorUserProfileField
                                                                                          title:NSLocalizedString(@"Color d'ulls", @"")
                                                                               valueTransformer:nil
                                                                                  selectionMode:IBAPickListSelectionModeSingle
                                                                                        options:eyeColorListOptions
                                                                                     isReadOnly:isReadOnly];
    
    if(([self userSelectedIdentifierForKeyPath:kEyeColorUserProfileField]) || (showEmptyFields))
        [basicFieldSection addFormField:eyeColorPickFormField];




    NSArray *mainCharacteristicListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Sense especificar", @""),
                                                                                               NSLocalizedString(@"[14]Atenta", @""),
                                                                                               NSLocalizedString(@"[7]Aventurera", @""),
                                                                                               NSLocalizedString(@"[21]Benhumorada", @""),
                                                                                               NSLocalizedString(@"[15]Despreocupada", @""),
                                                                                               NSLocalizedString(@"[15]Espontania", @""),
                                                                                               NSLocalizedString(@"[10]Generosa", @""),
                                                                                               NSLocalizedString(@"[3]Inquieta", @""),
                                                                                               NSLocalizedString(@"[2]Reservada", @""),
                                                                                               NSLocalizedString(@"[18]Sensible", @""),
                                                                                               NSLocalizedString(@"[16]Sociable", @""),
                                                                                               NSLocalizedString(@"[20]Tímida", @""),
                                                                                               NSLocalizedString(@"[1]Tranquila", @""),
                                                                                               NSLocalizedString(@"[9]Conciliadora", @""),
                                                                                               NSLocalizedString(@"[17]Exigent", @""),
                                                                                               NSLocalizedString(@"[6]Expansiva", @""),
                                                                                               NSLocalizedString(@"[12]Orgullosa", @""),
                                                                                               NSLocalizedString(@"[19]Posesiva", @""),
                                                                                               NSLocalizedString(@"[8]Solitaria", @""),
                                                                                               NSLocalizedString(@"[13]Supersticiosa", @""),
                                                                                               NSLocalizedString(@"[4]Tenaç", @""),
                                                                                               NSLocalizedString(@"[5]Viva", @""),
                                                                                               NSLocalizedString(@"[26]Altre", @""),
                                                                                               nil]];
    
    IBAPickListFormField *mainCharacteristicPickFormField = [[IBAPickListFormField alloc] initWithKeyPath:kMainCharacteristicUserProfileField
                                                                                                    title:NSLocalizedString(@"El meu caràcter", @"")
                                                                                         valueTransformer:nil
                                                                                            selectionMode:IBAPickListSelectionModeSingle
                                                                                                  options:mainCharacteristicListOptions
                                                                                               isReadOnly:isReadOnly];
    
    if(([self userSelectedIdentifierForKeyPath:kMainCharacteristicUserProfileField]) || (showEmptyFields))
        [basicFieldSection addFormField:mainCharacteristicPickFormField];



		NSArray *bodyLookListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Prefereixo no dir-ho", @""),
                                                                                         NSLocalizedString(@"[1]Explosiu", @""),
                                                                                         NSLocalizedString(@"[2]Molt agradable de veure", @""),
                                                                                         NSLocalizedString(@"[3]Agradable de veure", @""),
                                                                                         NSLocalizedString(@"[4]En la mitjana", @""),
                                                                                         NSLocalizedString(@"[5]No gaire dolent", @""),
                                                                                         NSLocalizedString(@"[6]No ho he de dir jo", @""),
                                                                                         NSLocalizedString(@"[7]El físic no té importància", @""),
                                                                                         nil]];

        if(([self userSelectedIdentifierForKeyPath:kBodyLookUserProfileField]) || (showEmptyFields))
            [basicFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:kBodyLookUserProfileField
                                                                                    title:NSLocalizedString(@"El meu aspecte", @"")
                                                                         valueTransformer:nil
                                                                            selectionMode:IBAPickListSelectionModeSingle
                                                                                  options:bodyLookListOptions
                                                                               isReadOnly:isReadOnly]];


    NSArray *silhouetteListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Prefereixo no dir-ho", @""),
                                                                                       NSLocalizedString(@"[1]Prim", @""),
                                                                                       NSLocalizedString(@"[2]Esportiva", @""),
                                                                                       NSLocalizedString(@"[3]Normal", @""),
                                                                                       NSLocalizedString(@"[4]Alguns quilos de més", @""),
                                                                                       NSLocalizedString(@"[5]Rodona", @""),
                                                                                       nil]];
    
    IBAPickListFormField *silhouettePickFormField = [[IBAPickListFormField alloc] initWithKeyPath:kSilhouetteUserProfileField
                                                                                            title:NSLocalizedString(@"La meva silueta", @"")
                                                                                 valueTransformer:nil
                                                                                    selectionMode:IBAPickListSelectionModeSingle
                                                                                          options:silhouetteListOptions
                                                                                       isReadOnly:isReadOnly];
    
    if(([self userSelectedIdentifierForKeyPath:kSilhouetteUserProfileField]) || (showEmptyFields))
        [basicFieldSection addFormField:silhouettePickFormField];





		NSArray *myHighlightListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Prefereixo no dir-ho", @""),
                                                                                         NSLocalizedString(@"[3]La meva boca", @""),
                                                                                         NSLocalizedString(@"[4]El meu cabell", @""),
                                                                                         NSLocalizedString(@"[13]El meu nas", @""),
                                                                                         NSLocalizedString(@"[10]La meva nuca", @""),
                                                                                         NSLocalizedString(@"[2]El meu somriure", @""),
                                                                                         NSLocalizedString(@"[5]El meu cul", @""),
                                                                                         NSLocalizedString(@"[6]Les meves mans", @""),
                                                                                         NSLocalizedString(@"[11]Els meus músculs", @""),
                                                                                         NSLocalizedString(@"[1]Els meus ulls", @""),
                                                                                         NSLocalizedString(@"[7]Els meus pectorals", @""),
                                                                                         NSLocalizedString(@"[8]Les meves cames", @""),
                                                                                         NSLocalizedString(@"[9]Els meus peus", @""),
                                                                                         NSLocalizedString(@"[10]El més bonic no està a la llista", @""),
                                                                                         nil]];

        if(([self userSelectedIdentifierForKeyPath:kMyHighlightUserProfileField]) || (showEmptyFields))
            [basicFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:kMyHighlightUserProfileField
                                                                                    title:NSLocalizedString(@"El més atractiu de mi", @"")
                                                                         valueTransformer:nil
                                                                            selectionMode:IBAPickListSelectionModeSingle
                                                                                  options:myHighlightListOptions
                                                                               isReadOnly:isReadOnly]];

        //Remove section if is empty and update form height
        for(int i=0; i<[[self sections] count]; i++)
        {
            IBAFormSection *section = [[self sections] objectAtIndex:i];
            if((section == basicFieldSection) && (![[section formFields] count]))
            {
                [[self sections] removeObjectAtIndex:i];
            }
            else if(section == basicFieldSection)
            {
                height+=kUserProfileFormHeaderCellHeight;
                height+=(kUserProfileFormCellHeight * [[section formFields] count]);

                numberOfFieldsInAppearanceSection = [[section formFields] count];
            }
        }

    
    
    IBAFormSection *situationFieldSection = [self addSectionWithHeaderTitle:NSLocalizedString(@"La meva situació personal", @"") footerTitle:nil];
    [situationFieldSection setFormFieldStyle:selectedStyle];
    
    
    
    
    NSArray *maritalStatusListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Prefereixo no dir-ho", @""),
                                                                                          NSLocalizedString(@"[1]No casat mai", @""),
                                                                                          NSLocalizedString(@"[2]Casat/Casada", @""),
                                                                                          NSLocalizedString(@"[3]Separat/Separada", @""),
                                                                                          NSLocalizedString(@"[4]Divorciat/Divorciada", @""),
                                                                                          NSLocalizedString(@"[5]Vidu/Vidua", @""),
                                                                                          nil]];
    
    IBAPickListFormField *maritalStatusPickFormField = [[IBAPickListFormField alloc] initWithKeyPath:kMaritalStatusUserProfileField
                                                                                               title:NSLocalizedString(@"El meu estat civil", @"")
                                                                                    valueTransformer:nil
                                                                                       selectionMode:IBAPickListSelectionModeSingle
                                                                                             options:maritalStatusListOptions
                                                                                          isReadOnly:isReadOnly];
    
    if(([self userSelectedIdentifierForKeyPath:kMaritalStatusUserProfileField]) || (showEmptyFields))
        [situationFieldSection addFormField:maritalStatusPickFormField];
    
    
    
    
    NSArray *hasChildrensListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Prefereixo no dir-ho", @""),
                                                                                         NSLocalizedString(@"[1]Cap", @""),
                                                                                         NSLocalizedString(@"[11]Sí", @""),
                                                                                         NSLocalizedString(@"[2]Sí, 1", @""),
                                                                                         NSLocalizedString(@"[3]Sí, 2", @""),
                                                                                         NSLocalizedString(@"[4]Sí, 3", @""),
                                                                                         NSLocalizedString(@"[5]Sí, 4", @""),
                                                                                         NSLocalizedString(@"[6]Sí, 5", @""),
                                                                                         NSLocalizedString(@"[7]Sí, més de 5", @""),
                                                                                         nil]];
    
    IBAPickListFormField *hasChildrensPickFormField = [[IBAPickListFormField alloc] initWithKeyPath:kHasChildrensUserProfileField
                                                                                              title:NSLocalizedString(@"Tinc fills", @"")
                                                                                   valueTransformer:nil
                                                                                      selectionMode:IBAPickListSelectionModeSingle
                                                                                            options:hasChildrensListOptions
                                                                                         isReadOnly:isReadOnly];
    
    if(([self userSelectedIdentifierForKeyPath:kHasChildrensUserProfileField]) || (showEmptyFields))
        [situationFieldSection addFormField:hasChildrensPickFormField];
    
    
    
    
    NSArray *whereIsLivingListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Prefereixo no dir-ho", @""),
                                                                                          NSLocalizedString(@"[1]Sol/Sola", @""),
                                                                                          NSLocalizedString(@"[3]Amb els seus fills", @""),
                                                                                          NSLocalizedString(@"[4]Amb els seus pares", @""),
                                                                                          NSLocalizedString(@"[5]En un pis compartit", @""),
                                                                                          NSLocalizedString(@"[6]Amb els seus fills part del temps", @""),
                                                                                          nil]];
    
    IBAPickListFormField *whereIsLivingPickFormField = [[IBAPickListFormField alloc] initWithKeyPath:kWhereIsLivingUserProfileField
                                                                                               title:NSLocalizedString(@"Visc", @"")
                                                                                    valueTransformer:nil
                                                                                       selectionMode:IBAPickListSelectionModeSingle
                                                                                             options:whereIsLivingListOptions
                                                                                          isReadOnly:isReadOnly];
    
    if(([self userSelectedIdentifierForKeyPath:kWhereIsLivingUserProfileField]) || (showEmptyFields))
        [situationFieldSection addFormField:whereIsLivingPickFormField];
    
    
    
    
    
    
    
    //Remove section if is empty and update form height
    for(int i=0; i<[[self sections] count]; i++)
    {
        IBAFormSection *section = [[self sections] objectAtIndex:i];
        if((section == situationFieldSection) && (![[section formFields] count]))
        {
            [[self sections] removeObjectAtIndex:i];
        }
        else if(section == situationFieldSection)
        {
            height+=kUserProfileFormHeaderCellHeight;
            height+=(kUserProfileFormCellHeight * [[section formFields] count]);
            
            numberOfFieldsInSituationSection = [[section formFields] count];
        }
    }

    
		IBAFormSection *valuesFieldSection = [self addSectionWithHeaderTitle:NSLocalizedString(@"Els meus valors", @"") footerTitle:nil];
        [valuesFieldSection setFormFieldStyle:selectedStyle];

		NSArray *citizenshipListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Prefereixo no dir-ho", @""),
                                                                                                 NSLocalizedString(@"[56]Espanyola", @""),
                                                                                                 NSLocalizedString(@"[5]Alemana", @""),
                                                                                                 NSLocalizedString(@"[10]Argentina", @""),
                                                                                                 NSLocalizedString(@"[152]Britànica", @""),
                                                                                                 NSLocalizedString(@"[39]Colombiana", @""),
                                                                                                 NSLocalizedString(@"[58]Estadounidense", @""),
                                                                                                 NSLocalizedString(@"[62]Francesa", @""),
                                                                                                 NSLocalizedString(@"[88]Italiana", @""),
                                                                                                 NSLocalizedString(@"[141]Peruana", @""),
                                                                                                 NSLocalizedString(@"[144]Portuguesa", @""),
                                                                                                 NSLocalizedString(@"[151]Rumana", @""),
                                                                                                 NSLocalizedString(@"[191]Venezolana", @""),
                                                                                                 NSLocalizedString(@"[1]Afgana", @""),
                                                                                                 NSLocalizedString(@"[3]Albanesa", @""),
                                                                                                 NSLocalizedString(@"[6]Andorrana", @""),
                                                                                                 NSLocalizedString(@"[7]Angolenya", @""),
                                                                                                 NSLocalizedString(@"[4]Argelina", @""),
                                                                                                 NSLocalizedString(@"[11]Armenia", @""),
                                                                                                 NSLocalizedString(@"[12]Australiana", @""),
                                                                                                 NSLocalizedString(@"[13]Austríaca", @""),
                                                                                                 NSLocalizedString(@"[14]Azerbaiyana", @""),
                                                                                                 NSLocalizedString(@"[15]Bahamenya", @""),
                                                                                                 NSLocalizedString(@"[16]Bahriní", @""),
                                                                                                 NSLocalizedString(@"[17]Bangladeshí", @""),
                                                                                                 NSLocalizedString(@"[18]Barbadense", @""),
                                                                                                 NSLocalizedString(@"[20]Belga", @""),
                                                                                                 NSLocalizedString(@"[21]Belicenya", @""),
                                                                                                 NSLocalizedString(@"[22]Beninés", @""),
                                                                                                 NSLocalizedString(@"[19]Bielorrusa", @""),
                                                                                                 NSLocalizedString(@"[123]Birmana", @""),
                                                                                                 NSLocalizedString(@"[24]Boliviana", @""),
                                                                                                 NSLocalizedString(@"[25]Bosnia", @""),
                                                                                                 NSLocalizedString(@"[26]Botsuanesa", @""),
                                                                                                 NSLocalizedString(@"[27]Brasilenya", @""),
                                                                                                 NSLocalizedString(@"[29]Búlgara", @""),
                                                                                                 NSLocalizedString(@"[30]Burkinesa", @""),
                                                                                                 NSLocalizedString(@"[31]Burundesa", @""),
                                                                                                 NSLocalizedString(@"[23]Butanesa", @""),
                                                                                                 NSLocalizedString(@"[35]Caboverdiana", @""),
                                                                                                 NSLocalizedString(@"[32]Camboyana", @""),
                                                                                                 NSLocalizedString(@"[33]Camerunesa", @""),
                                                                                                 NSLocalizedString(@"[34]Canadiense", @""),
                                                                                                 NSLocalizedString(@"[147]Centroafricana", @""),
                                                                                                 NSLocalizedString(@"[178]Chadiana", @""),
                                                                                                 NSLocalizedString(@"[150]Checa", @""),
                                                                                                 NSLocalizedString(@"[36]Chilena", @""),
                                                                                                 NSLocalizedString(@"[37]China", @""),
                                                                                                 NSLocalizedString(@"[38]Chipriota", @""),
                                                                                                 NSLocalizedString(@"[40]Comorana", @""),
                                                                                                 NSLocalizedString(@"[41]Congolenya (Congo)", @""),
                                                                                                 NSLocalizedString(@"[146]Congolenya (Rep. Dem. Congo)", @""),
                                                                                                 NSLocalizedString(@"[44]Costarricense", @""),
                                                                                                 NSLocalizedString(@"[46]Croata", @""),
                                                                                                 NSLocalizedString(@"[47]Cubana", @""),
                                                                                                 NSLocalizedString(@"[48]Danesa", @""),
                                                                                                 NSLocalizedString(@"[8]de Antigua y Barbuda", @""),
                                                                                                 NSLocalizedString(@"[28]de Brunei Darussalam", @""),
                                                                                                 NSLocalizedString(@"[49]de Djibouti", @""),
                                                                                                 NSLocalizedString(@"[50]de Dominica", @""),
                                                                                                 NSLocalizedString(@"[53]de Emiratos Árabes Unidos", @""),
                                                                                                 NSLocalizedString(@"[78]de las Islas Marshall", @""),
                                                                                                 NSLocalizedString(@"[79]de las Islas Salomón", @""),
                                                                                                 NSLocalizedString(@"[80]de las Islas Spratly", @""),
                                                                                                 NSLocalizedString(@"[98]de Lesoto", @""),
                                                                                                 NSLocalizedString(@"[103]de Liechtenstein", @""),
                                                                                                 NSLocalizedString(@"[106]de Macao", @""),
                                                                                                 NSLocalizedString(@"[136]de Palau", @""),
                                                                                                 NSLocalizedString(@"[157]de Saint Kitts y Nevis", @""),
                                                                                                 NSLocalizedString(@"[158]de San Vicente y las Granadinas", @""),
                                                                                                 NSLocalizedString(@"[161]de Santo Tomé y Príncipe", @""),
                                                                                                 NSLocalizedString(@"[163]de Seychelles", @""),
                                                                                                 NSLocalizedString(@"[169]de Sri Lanka", @""),
                                                                                                 NSLocalizedString(@"[183]de Trinidad y Tobago", @""),
                                                                                                 NSLocalizedString(@"[190]de Vanuatu", @""),
                                                                                                 NSLocalizedString(@"[148]Dominicana", @""),
                                                                                                 NSLocalizedString(@"[71]Ecuatoguineana", @""),
                                                                                                 NSLocalizedString(@"[54]Ecuatoriana", @""),
                                                                                                 NSLocalizedString(@"[51]Egipcia", @""),
                                                                                                 NSLocalizedString(@"[55]Eritrea", @""),
                                                                                                 NSLocalizedString(@"[149]Eslovaca", @""),
                                                                                                 NSLocalizedString(@"[166]Eslovena", @""),
                                                                                                 NSLocalizedString(@"[57]Estonia", @""),
                                                                                                 NSLocalizedString(@"[59]Etíope", @""),
                                                                                                 NSLocalizedString(@"[142]Filipina", @""),
                                                                                                 NSLocalizedString(@"[61]Finlandesa", @""),
                                                                                                 NSLocalizedString(@"[60]Fiyiana", @""),
                                                                                                 NSLocalizedString(@"[63]Gabonesa", @""),
                                                                                                 NSLocalizedString(@"[64]Gambiana", @""),
                                                                                                 NSLocalizedString(@"[65]Georgiana", @""),
                                                                                                 NSLocalizedString(@"[66]Ghanesa", @""),
                                                                                                 NSLocalizedString(@"[68]Granadina", @""),
                                                                                                 NSLocalizedString(@"[67]Griega", @""),
                                                                                                 NSLocalizedString(@"[69]Guatemalteca", @""),
                                                                                                 NSLocalizedString(@"[70]Guineana (Guinea)", @""),
                                                                                                 NSLocalizedString(@"[72]Guineana (Guinea-Bissáu)", @""),
                                                                                                 NSLocalizedString(@"[73]Guyanesa", @""),
                                                                                                 NSLocalizedString(@"[74]Haitiana", @""),
                                                                                                 NSLocalizedString(@"[140]Holandesa", @""),
                                                                                                 NSLocalizedString(@"[75]Hondurenya", @""),
                                                                                                 NSLocalizedString(@"[76]Hongkonesa", @""),
                                                                                                 NSLocalizedString(@"[77]Húngara", @""),
                                                                                                 NSLocalizedString(@"[81]India", @""),
                                                                                                 NSLocalizedString(@"[82]Indonesia", @""),
                                                                                                 NSLocalizedString(@"[83]Iraní", @""),
                                                                                                 NSLocalizedString(@"[84]Iraquí", @""),
                                                                                                 NSLocalizedString(@"[85]Irlandesa", @""),
                                                                                                 NSLocalizedString(@"[86]Islandesa", @""),
                                                                                                 NSLocalizedString(@"[87]Israelí", @""),
                                                                                                 NSLocalizedString(@"[89]Jamaicana", @""),
                                                                                                 NSLocalizedString(@"[90]Japonesa", @""),
                                                                                                 NSLocalizedString(@"[91]Jordana", @""),
                                                                                                 NSLocalizedString(@"[92]Kazaja", @""),
                                                                                                 NSLocalizedString(@"[93]Keniata", @""),
                                                                                                 NSLocalizedString(@"[94]Kirguiza", @""),
                                                                                                 NSLocalizedString(@"[95]Kiribatiana", @""),
                                                                                                 NSLocalizedString(@"[96]Kuwaití", @""),
                                                                                                 NSLocalizedString(@"[97]Laosiana", @""),
                                                                                                 NSLocalizedString(@"[99]Letona", @""),
                                                                                                 NSLocalizedString(@"[100]Libanesa", @""),
                                                                                                 NSLocalizedString(@"[101]Liberiana", @""),
                                                                                                 NSLocalizedString(@"[102]Libia", @""),
                                                                                                 NSLocalizedString(@"[104]Lituana", @""),
                                                                                                 NSLocalizedString(@"[105]Luxemburguesa", @""),
                                                                                                 NSLocalizedString(@"[107]Macedonia", @""),
                                                                                                 NSLocalizedString(@"[109]Malasia", @""),
                                                                                                 NSLocalizedString(@"[110]Malaui", @""),
                                                                                                 NSLocalizedString(@"[111]Maldiva", @""),
                                                                                                 NSLocalizedString(@"[108]Malgache", @""),
                                                                                                 NSLocalizedString(@"[112]Maliense", @""),
                                                                                                 NSLocalizedString(@"[113]Maltesa", @""),
                                                                                                 NSLocalizedString(@"[45]Marfilenya", @""),
                                                                                                 NSLocalizedString(@"[114]Marroquí", @""),
                                                                                                 NSLocalizedString(@"[115]Mauriciana", @""),
                                                                                                 NSLocalizedString(@"[116]Mauritana", @""),
                                                                                                 NSLocalizedString(@"[117]Mexicana", @""),
                                                                                                 NSLocalizedString(@"[118]Micronesia", @""),
                                                                                                 NSLocalizedString(@"[119]Moldava", @""),
                                                                                                 NSLocalizedString(@"[120]Monegasca", @""),
                                                                                                 NSLocalizedString(@"[121]Mongola", @""),
                                                                                                 NSLocalizedString(@"[199]Montenegrina", @""),
                                                                                                 NSLocalizedString(@"[122]Mozambiquenya", @""),
                                                                                                 NSLocalizedString(@"[124]Namibia", @""),
                                                                                                 NSLocalizedString(@"[125]Nauruana", @""),
                                                                                                 NSLocalizedString(@"[131]Neozelandesa", @""),
                                                                                                 NSLocalizedString(@"[126]Nepalesa", @""),
                                                                                                 NSLocalizedString(@"[127]Nicaragüense", @""),
                                                                                                 NSLocalizedString(@"[129]Nigeriana", @""),
                                                                                                 NSLocalizedString(@"[128]Nigerina", @""),
                                                                                                 NSLocalizedString(@"[42]Norcoreana", @""),
                                                                                                 NSLocalizedString(@"[130]Noruega", @""),
                                                                                                 NSLocalizedString(@"[132]Omaní", @""),
                                                                                                 NSLocalizedString(@"[135]Pakistaní", @""),
                                                                                                 NSLocalizedString(@"[137]Palestina", @""),
                                                                                                 NSLocalizedString(@"[198]Panamenya", @""),
                                                                                                 NSLocalizedString(@"[138]Papú-Neoguineana", @""),
                                                                                                 NSLocalizedString(@"[139]Paraguaya", @""),
                                                                                                 NSLocalizedString(@"[143]Polaca", @""),
                                                                                                 NSLocalizedString(@"[197]Portorriquenyo", @""),
                                                                                                 NSLocalizedString(@"[145]Qatarí", @""),
                                                                                                 NSLocalizedString(@"[154]Ruandesa", @""),
                                                                                                 NSLocalizedString(@"[153]Rusa", @""),
                                                                                                 NSLocalizedString(@"[155]Saharahui", @""),
                                                                                                 NSLocalizedString(@"[52]Salvadorenya", @""),
                                                                                                 NSLocalizedString(@"[159]Samoana", @""),
                                                                                                 NSLocalizedString(@"[160]Sanmarinense", @""),
                                                                                                 NSLocalizedString(@"[156]Santalucense", @""),
                                                                                                 NSLocalizedString(@"[9]Saudí", @""),
                                                                                                 NSLocalizedString(@"[162]Senegalesa", @""),
                                                                                                 NSLocalizedString(@"[194]Serbia", @""),
                                                                                                 NSLocalizedString(@"[164]Sierraleonesa", @""),
                                                                                                 NSLocalizedString(@"[165]Singapurense", @""),
                                                                                                 NSLocalizedString(@"[174]Siria", @""),
                                                                                                 NSLocalizedString(@"[167]Somalí", @""),
                                                                                                 NSLocalizedString(@"[173]Suazi", @""),
                                                                                                 NSLocalizedString(@"[2]Sudafricana", @""),
                                                                                                 NSLocalizedString(@"[168]Sudanesa", @""),
                                                                                                 NSLocalizedString(@"[170]Sueca", @""),
                                                                                                 NSLocalizedString(@"[171]Suiza", @""),
                                                                                                 NSLocalizedString(@"[43]Surcoreana", @""),
                                                                                                 NSLocalizedString(@"[172]Surinamesa", @""),
                                                                                                 NSLocalizedString(@"[179]Tailandesa", @""),
                                                                                                 NSLocalizedString(@"[176]Taiwanesa", @""),
                                                                                                 NSLocalizedString(@"[177]Tanzana", @""),
                                                                                                 NSLocalizedString(@"[175]Tayika", @""),
                                                                                                 NSLocalizedString(@"[180]Timorense", @""),
                                                                                                 NSLocalizedString(@"[181]Togolesa", @""),
                                                                                                 NSLocalizedString(@"[182]Tongana", @""),
                                                                                                 NSLocalizedString(@"[184]Tunecina", @""),
                                                                                                 NSLocalizedString(@"[186]Turca", @""),
                                                                                                 NSLocalizedString(@"[185]Turcomana", @""),
                                                                                                 NSLocalizedString(@"[187]Tuvaluana", @""),
                                                                                                 NSLocalizedString(@"[188]Ucraniana", @""),
                                                                                                 NSLocalizedString(@"[133]Ugandesa", @""),
                                                                                                 NSLocalizedString(@"[189]Uruguaya", @""),
                                                                                                 NSLocalizedString(@"[134]Uzbeka", @""), 
                                                                                                 NSLocalizedString(@"[192]Vietnamita", @""), 
                                                                                                 NSLocalizedString(@"[193]Yemení", @""), 
                                                                                                 NSLocalizedString(@"[195]Zambiana", @""), 
                                                                                                 NSLocalizedString(@"[196]Zimbabuense", @""),
                                                                                                 nil]];

        if(([self userSelectedIdentifierForKeyPath:kNationUserProfileField]) || (showEmptyFields))
            [valuesFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:kNationUserProfileField
                                                                                     title:NSLocalizedString(@"La meva nacionalitat", @"")
                                                                          valueTransformer:nil
                                                                             selectionMode:IBAPickListSelectionModeSingle
                                                                                   options:citizenshipListOptions
                                                                                isReadOnly:isReadOnly]];


		NSArray *ethnicalOriginListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Prefereixo no dir-ho", @""),
                                                                                            NSLocalizedString(@"[1]Europeu", @""),
                                                                                            NSLocalizedString(@"[5]Hispà", @""),
                                                                                            NSLocalizedString(@"[2]Africà", @""),
                                                                                            NSLocalizedString(@"[3]Àrab", @""),
                                                                                            NSLocalizedString(@"[4]Asiàtic", @""),
                                                                                            NSLocalizedString(@"[7]Indi", @""),
                                                                                            NSLocalizedString(@"[6]Un altre", @""),
                                                                                            nil]];

        if(([self userSelectedIdentifierForKeyPath:kEthnicalOriginUserProfileField]) || (showEmptyFields))
            [valuesFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:kEthnicalOriginUserProfileField
                                                                                     title:NSLocalizedString(@"El meu origen ètnic", @"")
                                                                          valueTransformer:nil
                                                                             selectionMode:IBAPickListSelectionModeSingle
                                                                                   options:ethnicalOriginListOptions
                                                                                isReadOnly:isReadOnly]];


		NSArray *religionListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Prefereixo no dir-ho", @""),
                                                                                               NSLocalizedString(@"[12]Agnòstic", @""),
                                                                                               NSLocalizedString(@"[11]Ateu", @""),
                                                                                               NSLocalizedString(@"[22]Budista", @""),
                                                                                               NSLocalizedString(@"[18]Catòlic", @""),
                                                                                               NSLocalizedString(@"[25]Cristià", @""),
                                                                                               NSLocalizedString(@"[23]Hinduista", @""),
                                                                                               NSLocalizedString(@"[20]Jueu", @""),
                                                                                               NSLocalizedString(@"[21]Musulmà", @""),
                                                                                               NSLocalizedString(@"[24]Ortodox", @""),
                                                                                               NSLocalizedString(@"[19]Protestant", @""),
                                                                                               NSLocalizedString(@"[13]Un altre", @""),
                                                                                               nil]];

        if(([self userSelectedIdentifierForKeyPath:kReligionUserProfileField]) || (showEmptyFields))
            [valuesFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:kReligionUserProfileField
                                                                                     title:NSLocalizedString(@"La meva religió", @"")
                                                                          valueTransformer:nil
                                                                             selectionMode:IBAPickListSelectionModeSingle
                                                                                   options:religionListOptions
                                                                                isReadOnly:isReadOnly]];

        
        
		NSArray *religionLevelListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Prefereixo no dir-ho", @""),
                                                                                         NSLocalizedString(@"[1]Practicant", @""),
                                                                                         NSLocalizedString(@"[2]Practicant ocasional", @""),
                                                                                         NSLocalizedString(@"[3]No practicant", @""),
                                                                                         nil]];

        if(([self userSelectedIdentifierForKeyPath:kReligionLevelUserProfileField]) || (showEmptyFields))
            [valuesFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:kReligionLevelUserProfileField
                                                                                     title:NSLocalizedString(@"Pràctica religiosa", @"")
                                                                          valueTransformer:nil
                                                                             selectionMode:IBAPickListSelectionModeSingle
                                                                                   options:religionLevelListOptions
                                                                                isReadOnly:isReadOnly]];


		NSArray *marriageOpinionListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Prefereixo no dir-ho", @""),
                                                                                              NSLocalizedString(@"[1]Sagrat", @""),
                                                                                              NSLocalizedString(@"[2]Molt important", @""),
                                                                                              NSLocalizedString(@"[3]Important", @""),
                                                                                              NSLocalizedString(@"[4]No és indispensable", @""),
                                                                                              NSLocalizedString(@"[5]Impensable", @""),
                                                                                              NSLocalizedString(@"[6]No em tornaré a casar", @""),
                                                                                              nil]];

        if(([self userSelectedIdentifierForKeyPath:kMarriageOpinionUserProfileField]) || (showEmptyFields))
            [valuesFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:kMarriageOpinionUserProfileField
                                                                                     title:NSLocalizedString(@"Per mi, el matrimoni és", @"")
                                                                          valueTransformer:nil
                                                                             selectionMode:IBAPickListSelectionModeSingle
                                                                                   options:marriageOpinionListOptions
                                                                                isReadOnly:isReadOnly]];


		NSArray *romanticismLevelListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Prefereixo no dir-ho", @""),
                                                                                                NSLocalizedString(@"[1]Molt romàntic", @""),
                                                                                                NSLocalizedString(@"[2]Bastant romàntic", @""),
                                                                                                NSLocalizedString(@"[3]Poc romàntic", @""),
                                                                                                NSLocalizedString(@"[4]Gens romàntic", @""),
                                                                                                nil]];

        if(([self userSelectedIdentifierForKeyPath:kRomanticismLevelUserProfileField]) || (showEmptyFields))
            [valuesFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:kRomanticismLevelUserProfileField
                                                                                     title:NSLocalizedString(@"Sóc romàntic", @"")
                                                                          valueTransformer:nil
                                                                             selectionMode:IBAPickListSelectionModeSingle
                                                                                   options:romanticismLevelListOptions
                                                                                isReadOnly:isReadOnly]];


        
		NSArray *iWantChildrensListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Prefereixo no dir-ho", @""),
                                                                                                 NSLocalizedString(@"[1]No", @""),
                                                                                                 NSLocalizedString(@"[2]Sí, 1", @""),
                                                                                                 NSLocalizedString(@"[3]Sí, 2", @""),
                                                                                                 NSLocalizedString(@"[4]Sí, 3", @""),
                                                                                                 NSLocalizedString(@"[5]Sí, més de 3", @""),
                                                                                                 NSLocalizedString(@"[6]Sí, número no decidit", @""),
                                                                                                 nil]];

        if(([self userSelectedIdentifierForKeyPath:kIWantChildrensUserProfileField]) || (showEmptyFields))
            [valuesFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:kIWantChildrensUserProfileField
                                                                                     title:NSLocalizedString(@"Vull tenir fills", @"")
                                                                          valueTransformer:nil
                                                                             selectionMode:IBAPickListSelectionModeSingle
                                                                                   options:iWantChildrensListOptions
                                                                                isReadOnly:isReadOnly]];

        //Remove section if is empty and update form height
        for(int i=0; i<[[self sections] count]; i++)
        {
            IBAFormSection *section = [[self sections] objectAtIndex:i];
            if((section == valuesFieldSection) && (![[section formFields] count]))
            {
                [[self sections] removeObjectAtIndex:i];
            }
            else if(section == valuesFieldSection)
            {
                height+=kUserProfileFormHeaderCellHeight;
                height+=(kUserProfileFormCellHeight * [[section formFields] count]);

                numberOfFieldsInValuesSection = [[section formFields] count];
            }
        }


		IBAFormSection *professionalSituationFieldSection = [self addSectionWithHeaderTitle:NSLocalizedString(@"La meva situació professional", @"") footerTitle:nil];
        [professionalSituationFieldSection setFormFieldStyle:selectedStyle];

		NSArray *studiesLevelListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Prefereixo no dir-ho", @""),
                                                                                               NSLocalizedString(@"[1]Institut o inferior", @""),
                                                                                               NSLocalizedString(@"[2]Batxillerat", @""),
                                                                                               NSLocalizedString(@"[3]Mòdul professional", @""),
                                                                                               NSLocalizedString(@"[4]Diplomat", @""),
                                                                                               NSLocalizedString(@"[5]Llicenciat o superior", @""),
                                                                                               NSLocalizedString(@"[6]Altres", @""),
                                                                                               nil]];

        if(([self userSelectedIdentifierForKeyPath:kStudiesLevelUserProfileField]) || (showEmptyFields))
            [professionalSituationFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:kStudiesLevelUserProfileField
                                                                                                    title:NSLocalizedString(@"El meu nivell d'estudis", @"")
                                                                                         valueTransformer:nil
                                                                                            selectionMode:IBAPickListSelectionModeSingle
                                                                                                  options:studiesLevelListOptions
                                                                                               isReadOnly:isReadOnly]];


		NSArray *languagesListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Prefereixo no dir-ho", @""),
                                                                                          NSLocalizedString(@"[4]inglés", @""),
                                                                                          NSLocalizedString(@"[22]francés", @""),
                                                                                          NSLocalizedString(@"[3]alemán", @""),
                                                                                          NSLocalizedString(@"[30]italiano", @""),
                                                                                          NSLocalizedString(@"[46]portugués", @""),
                                                                                          NSLocalizedString(@"[5]árabe", @""),
                                                                                          NSLocalizedString(@"[48]ruso", @""),
                                                                                          NSLocalizedString(@"[47]rumano", @""),
                                                                                          NSLocalizedString(@"[45]polaco", @""),
                                                                                          NSLocalizedString(@"[52]sueco", @""),
                                                                                          NSLocalizedString(@"[24]griego", @""),
                                                                                          NSLocalizedString(@"[39]holandés", @""),
                                                                                          NSLocalizedString(@"[1]afrikaner", @""),
                                                                                          NSLocalizedString(@"[2]albanés", @""),
                                                                                          NSLocalizedString(@"[6]armenio", @""),
                                                                                          NSLocalizedString(@"[7]azerbaiyano", @""),
                                                                                          NSLocalizedString(@"[8]bengalí", @""),
                                                                                          NSLocalizedString(@"[9]bielorruso", @""),
                                                                                          NSLocalizedString(@"[10]birmano", @""),
                                                                                          NSLocalizedString(@"[11]bosnio", @""),
                                                                                          NSLocalizedString(@"[12]búlgaro", @""),
                                                                                          NSLocalizedString(@"[32]canadiense", @""),
                                                                                          NSLocalizedString(@"[13]catalán", @""),
                                                                                          NSLocalizedString(@"[56]checo", @""),
                                                                                          NSLocalizedString(@"[14]chino (cantonés)", @""),
                                                                                          NSLocalizedString(@"[15]chino (mandarín)", @""),
                                                                                          NSLocalizedString(@"[16]coreano", @""),
                                                                                          NSLocalizedString(@"[17]croata", @""),
                                                                                          NSLocalizedString(@"[18]danés", @""),
                                                                                          NSLocalizedString(@"[50]eslovaco", @""),
                                                                                          NSLocalizedString(@"[51]esloveno", @""),
                                                                                          NSLocalizedString(@"[19]español", @""),
                                                                                          NSLocalizedString(@"[20]estonio", @""),
                                                                                          NSLocalizedString(@"[21]finlandés", @""),
                                                                                          NSLocalizedString(@"[23]georgiano", @""),
                                                                                          NSLocalizedString(@"[25]hebreo", @""),
                                                                                          NSLocalizedString(@"[26]hindi", @""),
                                                                                          NSLocalizedString(@"[27]húngaro", @""),
                                                                                          NSLocalizedString(@"[28]indonesio", @""),
                                                                                          NSLocalizedString(@"[29]iraní", @""),
                                                                                          NSLocalizedString(@"[31]japonés", @""),
                                                                                          NSLocalizedString(@"[33]kazajo", @""),
                                                                                          NSLocalizedString(@"[34]letón", @""),
                                                                                          NSLocalizedString(@"[35]lituano", @""),
                                                                                          NSLocalizedString(@"[36]macedonio", @""),
                                                                                          NSLocalizedString(@"[37]malasio", @""),
                                                                                          NSLocalizedString(@"[38]moldavo", @""),
                                                                                          NSLocalizedString(@"[40]nepalés", @""),
                                                                                          NSLocalizedString(@"[41]noruego", @""),
                                                                                          NSLocalizedString(@"[64]otro", @""),
                                                                                          NSLocalizedString(@"[44]pashto", @""),
                                                                                          NSLocalizedString(@"[49]serbio", @""),
                                                                                          NSLocalizedString(@"[53]suahili", @""),
                                                                                          NSLocalizedString(@"[58]tailandés", @""),
                                                                                          NSLocalizedString(@"[55]tamil", @""),
                                                                                          NSLocalizedString(@"[54]tayiko", @""),
                                                                                          NSLocalizedString(@"[57]telugu", @""),
                                                                                          NSLocalizedString(@"[59]turcomeno", @""),
                                                                                          NSLocalizedString(@"[60]turco", @""),
                                                                                          NSLocalizedString(@"[61]ucraniano", @""),
                                                                                          NSLocalizedString(@"[42]urdu", @""),
                                                                                          NSLocalizedString(@"[43]uzbeko", @""),
                                                                                          NSLocalizedString(@"[62]vietnamita", @""),
                                                                                          nil]];

        if(([self userSelectedIdentifierForKeyPath:kLanguagesUserProfileField]) || (showEmptyFields))
            [professionalSituationFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:kLanguagesUserProfileField
                                                                                                    title:NSLocalizedString(@"Idiomes que parlo", @"")
                                                                                         valueTransformer:nil
                                                                                            selectionMode:IBAPickListSelectionModeMultiple
                                                                                                  options:languagesListOptions
                                                                                               isReadOnly:isReadOnly]];


		NSArray *myBusinessListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Prefereixo no dir-ho", @""),
                                                                                           NSLocalizedString(@"[10]abogado", @""),
                                                                                           NSLocalizedString(@"[1]actor", @""),
                                                                                           NSLocalizedString(@"[2]agente de seguros", @""),
                                                                                           NSLocalizedString(@"[3]agente de viajes", @""),
                                                                                           NSLocalizedString(@"[4]agente hospitalario", @""),
                                                                                           NSLocalizedString(@"[5]agente inmobiliario", @""),
                                                                                           NSLocalizedString(@"[6]agricultor", @""),
                                                                                           NSLocalizedString(@"[11]aibliotecario, librero", @""),
                                                                                           NSLocalizedString(@"[58]arquitecto", @""),
                                                                                           NSLocalizedString(@"[92]artesano", @""),
                                                                                           NSLocalizedString(@"[8]asistente social", @""),
                                                                                           NSLocalizedString(@"[9]asistente/secretario", @""),
                                                                                           NSLocalizedString(@"[29]atención al cliente", @""),
                                                                                           NSLocalizedString(@"[48]bombero", @""),
                                                                                           NSLocalizedString(@"[54]camarero", @""),
                                                                                           NSLocalizedString(@"[20]camionero", @""),
                                                                                           NSLocalizedString(@"[19]cazatalentos", @""),
                                                                                           NSLocalizedString(@"[25]cocinero", @""),
                                                                                           NSLocalizedString(@"[22]comerciante", @""),
                                                                                           NSLocalizedString(@"[24]consultor", @""),
                                                                                           NSLocalizedString(@"[23]contable", @""),
                                                                                           NSLocalizedString(@"[26]dentista", @""),
                                                                                           NSLocalizedString(@"[55]deportista", @""),
                                                                                           NSLocalizedString(@"[17]directivo/ejecutivo superior", @""),
                                                                                           NSLocalizedString(@"[30]docente", @""),
                                                                                           NSLocalizedString(@"[65]doctor", @""),
                                                                                           NSLocalizedString(@"[28]editor", @""),
                                                                                           NSLocalizedString(@"[60]educador", @""),
                                                                                           NSLocalizedString(@"[12]ejecutivo administrativo", @""),
                                                                                           NSLocalizedString(@"[13]ejecutivo bancario", @""),
                                                                                           NSLocalizedString(@"[14]ejecutivo comercial", @""),
                                                                                           NSLocalizedString(@"[15]ejecutivo financiero", @""),
                                                                                           NSLocalizedString(@"[16]ejecutivo recursos humanos", @""),
                                                                                           NSLocalizedString(@"[52]empleado de asociación", @""),
                                                                                           NSLocalizedString(@"[61]empresario", @""),
                                                                                           NSLocalizedString(@"[36]enfermero", @""),
                                                                                           NSLocalizedString(@"[27]escritor", @""),
                                                                                           NSLocalizedString(@"[31]especialista de belleza", @""),
                                                                                           NSLocalizedString(@"[32]estudiante", @""),
                                                                                           NSLocalizedString(@"[33]florista", @""),
                                                                                           NSLocalizedString(@"[34]funcionario", @""),
                                                                                           NSLocalizedString(@"[35]grafista", @""),
                                                                                           NSLocalizedString(@"[37]ingeniero informático", @""),
                                                                                           NSLocalizedString(@"[38]ingeniero no informático", @""),
                                                                                           NSLocalizedString(@"[62]intérprete", @""),
                                                                                           NSLocalizedString(@"[51]jubilado", @""),
                                                                                           NSLocalizedString(@"[40]jurista", @""),
                                                                                           NSLocalizedString(@"[41]masajista", @""),
                                                                                           NSLocalizedString(@"[42]médico", @""),
                                                                                           NSLocalizedString(@"[43]militar", @""),
                                                                                           NSLocalizedString(@"[44]músico", @""),
                                                                                           NSLocalizedString(@"[59]notario", @""),
                                                                                           NSLocalizedString(@"[45]obrero", @""),
                                                                                           NSLocalizedString(@"[18]otros ejecutivos", @""),
                                                                                           NSLocalizedString(@"[93]panadero", @""),
                                                                                           NSLocalizedString(@"[21]peluquero", @""),
                                                                                           NSLocalizedString(@"[39]periodista", @""),
                                                                                           NSLocalizedString(@"[46]personal aéreo", @""),
                                                                                           NSLocalizedString(@"[7]pintor artístico", @""),
                                                                                           NSLocalizedString(@"[47]policía", @""),
                                                                                           NSLocalizedString(@"[49]publicista", @""),
                                                                                           NSLocalizedString(@"[50]restaurador", @""),
                                                                                           NSLocalizedString(@"[53]sin empleo", @""),
                                                                                           NSLocalizedString(@"[56]técnico", @""),
                                                                                           NSLocalizedString(@"[57]otros", @""),
                                                                                             nil]];

        if(([self userSelectedIdentifierForKeyPath:kMyBusinessUserProfileField]) || (showEmptyFields))
            [professionalSituationFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:kMyBusinessUserProfileField
                                                                                                    title:NSLocalizedString(@"La meva professió", @"")
                                                                                         valueTransformer:nil
                                                                                            selectionMode:IBAPickListSelectionModeSingle
                                                                                                  options:myBusinessListOptions
                                                                                               isReadOnly:isReadOnly]];


		NSArray *salaryListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Prefereixo no dir-ho", @""),
                                                                                             NSLocalizedString(@"[1]Menys de 10.000€/any", @""),
                                                                                             NSLocalizedString(@"[2]De 10 a 20.000€/any", @""),
                                                                                             NSLocalizedString(@"[3]De 20 a 30.000€/any", @""),
                                                                                             NSLocalizedString(@"[4]De 30 a 50.000€/any", @""),
                                                                                             NSLocalizedString(@"[5]De 50 a 75.000€/any", @""),
                                                                                             NSLocalizedString(@"[6]De 75 a 100.000€/any", @""),
                                                                                             NSLocalizedString(@"[7]Més de 100.000€/any", @""),
                                                                                             nil]];

        if(([self userSelectedIdentifierForKeyPath:kSalaryUserProfileField]) || (showEmptyFields))
            [professionalSituationFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:kSalaryUserProfileField
                                                                                                    title:NSLocalizedString(@"Els meus ingressos", @"")
                                                                                         valueTransformer:nil
                                                                                            selectionMode:IBAPickListSelectionModeSingle
                                                                                                  options:salaryListOptions
                                                                                               isReadOnly:isReadOnly]];

        //Remove section if is empty
        for(int i=0; i<[[self sections] count]; i++)
        {
            IBAFormSection *section = [[self sections] objectAtIndex:i];
            if((section == professionalSituationFieldSection) && (![[section formFields] count]))
            {
                [[self sections] removeObjectAtIndex:i];
            }
            else if(section == professionalSituationFieldSection)
            {
                height+=kUserProfileFormHeaderCellHeight;
                height+=(kUserProfileFormCellHeight * [[section formFields] count]);

                numberOfFieldsInProfessionalSection = [[section formFields] count];
            }
        }


		IBAFormSection *lifestyleFieldSection = [self addSectionWithHeaderTitle:NSLocalizedString(@"El meu estil de vida", @"") footerTitle:nil];
        [lifestyleFieldSection setFormFieldStyle:selectedStyle];

		NSArray *myStyleListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Prefereixo no dir-ho", @""),
                                                                                             NSLocalizedString(@"[3]A la moda", @""),
                                                                                             NSLocalizedString(@"[8]Bohemi", @""),
                                                                                             NSLocalizedString(@"[2]Clàssic", @""),
                                                                                             NSLocalizedString(@"[6]Esportiu", @""),
                                                                                             NSLocalizedString(@"[5]Despreocupat", @""),
                                                                                             NSLocalizedString(@"[7]Ètnic", @""),
                                                                                             NSLocalizedString(@"[4]Negocis", @""),
                                                                                             NSLocalizedString(@"[1]Pijo", @""),
                                                                                             NSLocalizedString(@"[9]Rock", @""),
                                                                                             NSLocalizedString(@"[11]Altres", @""),
                                                                                             nil]];

        if(([self userSelectedIdentifierForKeyPath:kMyStyleUserProfileField]) || (showEmptyFields))
            [lifestyleFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:kMyStyleUserProfileField
                                                                                                    title:NSLocalizedString(@"El meu estil", @"")
                                                                                        valueTransformer:nil
                                                                                            selectionMode:IBAPickListSelectionModeSingle
                                                                                                options:myStyleListOptions
                                                                                            isReadOnly:isReadOnly]];

		NSArray *alimentListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Prefereixo no dir-ho", @""),
                                                                                        NSLocalizedString(@"[6]A dieta", @""),
                                                                                        NSLocalizedString(@"[4]Casher", @""),
                                                                                        NSLocalizedString(@"[1]Menjo de tot", @""),
                                                                                        NSLocalizedString(@"[5]Halal", @""),
                                                                                        NSLocalizedString(@"[7]Macrobiòtic", @""),
                                                                                        NSLocalizedString(@"[3]Vegà", @""),
                                                                                        NSLocalizedString(@"[2]Vegetarià", @""),
                                                                                        nil]];

        if(([self userSelectedIdentifierForKeyPath:kAlimentUserProfileField]) || (showEmptyFields))
            [lifestyleFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:kAlimentUserProfileField
                                                                                        title:NSLocalizedString(@"La meva alimentació", @"")
                                                                             valueTransformer:nil
                                                                                selectionMode:IBAPickListSelectionModeSingle
                                                                                      options:alimentListOptions
                                                                                   isReadOnly:isReadOnly]];



		NSArray *smokeListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Prefereixo no dir-ho", @""),
                                                                                        NSLocalizedString(@"[3]No (el fumo no és un problema)", @""),
                                                                                        NSLocalizedString(@"[4]No (no m'agrada el fum)", @""),
                                                                                        NSLocalizedString(@"[1]Sí, ocasionalment", @""),
                                                                                        NSLocalizedString(@"[2]Sí, regularment", @""),
                                                                                        nil]];

        if(([self userSelectedIdentifierForKeyPath:kSmokeUserProfileField]) || (showEmptyFields))
            [lifestyleFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:kSmokeUserProfileField
                                                                                        title:NSLocalizedString(@"Fumo", @"")
                                                                             valueTransformer:nil
                                                                                selectionMode:IBAPickListSelectionModeSingle
                                                                                      options:smokeListOptions
                                                                                   isReadOnly:isReadOnly]];


		NSArray *animalsListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Prefereixo no dir-ho", @""),
                                                                                      NSLocalizedString(@"[3]Animal exòtic", @""),
                                                                                      NSLocalizedString(@"[8]Cavall/poni", @""),
                                                                                      NSLocalizedString(@"[9]Conill", @""),
                                                                                      NSLocalizedString(@"[1]Gats", @""),
                                                                                      NSLocalizedString(@"[7]Hàmster/ratolí", @""),
                                                                                      NSLocalizedString(@"[5]Insectes", @""),
                                                                                      NSLocalizedString(@"[2]Gos", @""),
                                                                                      NSLocalizedString(@"[4]Peix", @""),
                                                                                      NSLocalizedString(@"[6]Ocell", @""),
                                                                                      NSLocalizedString(@"[10]Rèptil", @""),
                                                                                      NSLocalizedString(@"[11]Altre animal", @""),
                                                                                      NSLocalizedString(@"[12]No tinc animals", @""),
                                                                                      nil]];

        if(([self userSelectedIdentifierForKeyPath:kAnimalsUserProfileField]) || (showEmptyFields))
            [lifestyleFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:kAnimalsUserProfileField
                                                                                        title:NSLocalizedString(@"Els meus animals", @"")
                                                                             valueTransformer:nil
                                                                                selectionMode:IBAPickListSelectionModeSingle
                                                                                      options:animalsListOptions
                                                                                   isReadOnly:isReadOnly]];

        //Remove section if is empty
        for(int i=0; i<[[self sections] count]; i++)
        {
            IBAFormSection *section = [[self sections] objectAtIndex:i];
            if((section == lifestyleFieldSection) && (![[section formFields] count]))
            {
                [[self sections] removeObjectAtIndex:i];
            }
            else if(section == lifestyleFieldSection)
            {
                height+=kUserProfileFormHeaderCellHeight;
                height+=(kUserProfileFormCellHeight * [[section formFields] count]);

                numberOfFieldsInLifestyleSection = [[section formFields] count];
            }
        }


		IBAFormSection *interestsFieldSection = [self addSectionWithHeaderTitle:NSLocalizedString(@"Els meus interessos", @"") footerTitle:nil];
        [interestsFieldSection setFormFieldStyle:selectedStyle];
        
		NSArray *myHobbiesListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Prefereixo no dir-ho", @""),
                                                                                          NSLocalizedString(@"[6]exposiciones/museos", @""),
                                                                                          NSLocalizedString(@"[14]informática", @""),
                                                                                          NSLocalizedString(@"[10]lectura", @""),
                                                                                          NSLocalizedString(@"[1]teatro", @""),
                                                                                          NSLocalizedString(@"[16]viajes", @""),
                                                                                          NSLocalizedString(@"[9]cocina", @""),
                                                                                          NSLocalizedString(@"[2]compras", @""),
                                                                                          NSLocalizedString(@"[15]deporte", @""),
                                                                                          NSLocalizedString(@"[22]foto", @""),
                                                                                          NSLocalizedString(@"[7]música", @""),
                                                                                          NSLocalizedString(@"[21]animales", @""),
                                                                                          NSLocalizedString(@"[12]pintura", @""),
                                                                                          NSLocalizedString(@"[24]actividad caritativa", @""),
                                                                                          NSLocalizedString(@"[27]ajedrez", @""),
                                                                                          NSLocalizedString(@"[20]automóvil", @""),
                                                                                          NSLocalizedString(@"[3]bricolaje", @""),
                                                                                          NSLocalizedString(@"[44]colección de figuritas", @""),
                                                                                          NSLocalizedString(@"[25]costura/punto", @""),
                                                                                          NSLocalizedString(@"[5]danza", @""),
                                                                                          NSLocalizedString(@"[26]decoración", @""),
                                                                                          NSLocalizedString(@"[13]dibujo", @""),
                                                                                          NSLocalizedString(@"[8]escritura", @""),
                                                                                          NSLocalizedString(@"[19]internet", @""),
                                                                                          NSLocalizedString(@"[4]jardinería", @""),
                                                                                          NSLocalizedString(@"[28]juegos de cartas", @""),
                                                                                          NSLocalizedString(@"[29]juegos de rol", @""),
                                                                                          NSLocalizedString(@"[30]juegos de sociedad", @""),
                                                                                          NSLocalizedString(@"[17]paseos", @""),
                                                                                          NSLocalizedString(@"[11]televisión", @""),
                                                                                          NSLocalizedString(@"[18]videojuegos", @""),
                                                                                          NSLocalizedString(@"[23]Altres", @""),
                                                                                          nil]];

        if(([self userSelectedIdentifierForKeyPath:kMyHobbiesUserProfileField]) || (showEmptyFields))
            [interestsFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:kMyHobbiesUserProfileField
                                                                                        title:NSLocalizedString(@"Les meves aficions", @"")
                                                                             valueTransformer:nil
                                                                                selectionMode:IBAPickListSelectionModeMultiple
                                                                                      options:myHobbiesListOptions
                                                                                   isReadOnly:isReadOnly]];



		NSArray *mySportsListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Prefereixo no dir-ho", @""),
                                                                                         NSLocalizedString(@"[9]fútbol", @""),
                                                                                         NSLocalizedString(@"[4]baloncesto", @""),
                                                                                         NSLocalizedString(@"[41]fitness", @""),
                                                                                         NSLocalizedString(@"[34]jogging", @""),
                                                                                         NSLocalizedString(@"[17]natación", @""),
                                                                                         NSLocalizedString(@"[26]vela", @""),
                                                                                         NSLocalizedString(@"[18]windsurf", @""),
                                                                                         NSLocalizedString(@"[7]ciclismo", @""),
                                                                                         NSLocalizedString(@"[38]deportes de riesgo", @""),
                                                                                         NSLocalizedString(@"[22]ski/snowboard", @""),
                                                                                         NSLocalizedString(@"[25]tenis", @""),
                                                                                         NSLocalizedString(@"[19]surf", @""),
                                                                                         NSLocalizedString(@"[1]atletismo", @""),
                                                                                         NSLocalizedString(@"[2]automóvil", @""),
                                                                                         NSLocalizedString(@"[30]bádminton", @""),
                                                                                         NSLocalizedString(@"[12]balonmano", @""),
                                                                                         NSLocalizedString(@"[3]béisbol", @""),
                                                                                         NSLocalizedString(@"[5]boxeo", @""),
                                                                                         NSLocalizedString(@"[31]cricket", @""),
                                                                                         NSLocalizedString(@"[8]danza", @""),
                                                                                         NSLocalizedString(@"[37]deportes de combate", @""),
                                                                                         NSLocalizedString(@"[39]deportes mecánicos", @""),
                                                                                         NSLocalizedString(@"[32]equitación", @""),
                                                                                         NSLocalizedString(@"[33]fútbol americano", @""),
                                                                                         NSLocalizedString(@"[11]gimnasia", @""),
                                                                                         NSLocalizedString(@"[10]golf", @""),
                                                                                         NSLocalizedString(@"[13]hockey", @""),
                                                                                         NSLocalizedString(@"[14]judo", @""),
                                                                                         NSLocalizedString(@"[15]kárate", @""),
                                                                                         NSLocalizedString(@"[16]moto", @""),
                                                                                         NSLocalizedString(@"[29]ninguno", @""),
                                                                                         NSLocalizedString(@"[20]otros deportes acuáticos", @""),
                                                                                         NSLocalizedString(@"[36]roller", @""),
                                                                                         NSLocalizedString(@"[21]rugby", @""),
                                                                                         NSLocalizedString(@"[35]senderismo/trekking", @""),
                                                                                         NSLocalizedString(@"[24]skateboard", @""),
                                                                                         NSLocalizedString(@"[46]skiing", @""),
                                                                                         NSLocalizedString(@"[23]squash", @""),
                                                                                         NSLocalizedString(@"[40]tenis de mesa", @""),
                                                                                         NSLocalizedString(@"[27]volley-ball", @""),
                                                                                         NSLocalizedString(@"[28]Altres", @""),
                                                                                         nil]];

        if(([self userSelectedIdentifierForKeyPath:kMySportsUserProfileField]) || (showEmptyFields))
            [interestsFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:kMySportsUserProfileField
                                                                                        title:NSLocalizedString(@"Els meus esports", @"")
                                                                             valueTransformer:nil
                                                                                selectionMode:IBAPickListSelectionModeMultiple
                                                                                      options:mySportsListOptions
                                                                                   isReadOnly:isReadOnly]];



		NSArray *mySparetimeListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Prefereixo no dir-ho", @""),
                                                                                            NSLocalizedString(@"[13]acontecimiento deportivo", @""),
                                                                                            NSLocalizedString(@"[6]after work", @""),
                                                                                            NSLocalizedString(@"[4]bares / pubs", @""),
                                                                                            NSLocalizedString(@"[9]cine", @""),
                                                                                            NSLocalizedString(@"[7]concierto", @""),
                                                                                            NSLocalizedString(@"[8]discoteca", @""),
                                                                                            NSLocalizedString(@"[10]espectáculos de danza", @""),
                                                                                            NSLocalizedString(@"[2]familia", @""),
                                                                                            NSLocalizedString(@"[11]fiestas entre amigos", @""),
                                                                                            NSLocalizedString(@"[5]ópera", @""),
                                                                                            NSLocalizedString(@"[1]restaurante", @""),
                                                                                            NSLocalizedString(@"[3]teatro", @""),
                                                                                            NSLocalizedString(@"[14]karaoke", @""),
                                                                                            NSLocalizedString(@"[15]leer", @""),
                                                                                            NSLocalizedString(@"[12]Altres", @""),
                                                                                            nil]];

        if(([self userSelectedIdentifierForKeyPath:kMySparetimeUserProfileField]) || (showEmptyFields))
            [interestsFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:kMySparetimeUserProfileField
                                                                                        title:NSLocalizedString(@"Les meves sortides", @"")
                                                                             valueTransformer:nil
                                                                                selectionMode:IBAPickListSelectionModeMultiple
                                                                                      options:mySparetimeListOptions
                                                                                   isReadOnly:isReadOnly]];

        //Remove section if is empty
        for(int i=0; i<[[self sections] count]; i++)
        {
            IBAFormSection *section = [[self sections] objectAtIndex:i];
            if((section == interestsFieldSection) && (![[section formFields] count]))
            {
                [[self sections] removeObjectAtIndex:i];
            }
            else if(section == interestsFieldSection)
            {
                height+=kUserProfileFormHeaderCellHeight;
                height+=(kUserProfileFormCellHeight * [[section formFields] count]);

                numberOfFieldsInInterestsSection = [[section formFields] count];
            }
        }


		IBAFormSection *preferencesFieldSection = [self addSectionWithHeaderTitle:NSLocalizedString(@"Els meus gustos culturals", @"") footerTitle:nil];
        [preferencesFieldSection setFormFieldStyle:selectedStyle];

		NSArray *musicListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Prefereixo no dir-ho", @""),
                                                                                      NSLocalizedString(@"[24]ambiente / de relajación", @""),
                                                                                      NSLocalizedString(@"[1]blues", @""),
                                                                                      NSLocalizedString(@"[7]independiente", @""),
                                                                                      NSLocalizedString(@"[19]latina", @""),
                                                                                      NSLocalizedString(@"[20]ópera", @""),
                                                                                      NSLocalizedString(@"[23]reggae", @""),
                                                                                      NSLocalizedString(@"[2]clásica", @""),
                                                                                      NSLocalizedString(@"[4]electrónca-tecno", @""),
                                                                                      NSLocalizedString(@"[25]funk", @""),
                                                                                      NSLocalizedString(@"[8]jazz", @""),
                                                                                      NSLocalizedString(@"[11]pop-rock", @""),
                                                                                      NSLocalizedString(@"[12]rap", @""),
                                                                                      NSLocalizedString(@"[9]bandas sonoras", @""),
                                                                                      NSLocalizedString(@"[3]country", @""),
                                                                                      NSLocalizedString(@"[18]dance y DJ", @""),
                                                                                      NSLocalizedString(@"[26]disco", @""),
                                                                                      NSLocalizedString(@"[21]folk", @""),
                                                                                      NSLocalizedString(@"[22]gospel", @""),
                                                                                      NSLocalizedString(@"[6]hard rock", @""),
                                                                                      NSLocalizedString(@"[5]música tradicional", @""),
                                                                                      NSLocalizedString(@"[13]r'n'b", @""),
                                                                                      NSLocalizedString(@"[14]soul", @""),
                                                                                      NSLocalizedString(@"[15]trip-hop", @""),
                                                                                      NSLocalizedString(@"[16]variedades", @""),
                                                                                      NSLocalizedString(@"[10]world music", @""),
                                                                                      NSLocalizedString(@"[17]Altres", @""),
                                                                                            nil]];

        if(([self userSelectedIdentifierForKeyPath:kMusicUserProfileField]) || (showEmptyFields))
            [preferencesFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:kMusicUserProfileField
                                                                                          title:NSLocalizedString(@"Gustos musicals", @"")
                                                                               valueTransformer:nil
                                                                                  selectionMode:IBAPickListSelectionModeMultiple
                                                                                        options:musicListOptions
                                                                                     isReadOnly:isReadOnly]];



		NSArray *moviesListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Prefereixo no dir-ho", @""),
                                                                                       NSLocalizedString(@"[2]de acción", @""),
                                                                                       NSLocalizedString(@"[4]de aventuras", @""),
                                                                                       NSLocalizedString(@"[6]de terror", @""),
                                                                                       NSLocalizedString(@"[7]documentales", @""),
                                                                                       NSLocalizedString(@"[15]las comedias sentimentales", @""),
                                                                                       NSLocalizedString(@"[11]ciencia-ficción", @""),
                                                                                       NSLocalizedString(@"[9]cómicas", @""),
                                                                                       NSLocalizedString(@"[3]de autor", @""),
                                                                                       NSLocalizedString(@"[8]dramáticas", @""),
                                                                                       NSLocalizedString(@"[12]fantásticas", @""),
                                                                                       NSLocalizedString(@"[14]las comedias musicales", @""),
                                                                                       NSLocalizedString(@"[17]policíacas", @""),
                                                                                       NSLocalizedString(@"[21]animación", @""),
                                                                                       NSLocalizedString(@"[1]cortometrajes", @""),
                                                                                       NSLocalizedString(@"[5]de guerra", @""),
                                                                                       NSLocalizedString(@"[18]de vaqueros", @""),
                                                                                       NSLocalizedString(@"[10]eróticas", @""),
                                                                                       NSLocalizedString(@"[13]históricas", @""),
                                                                                       NSLocalizedString(@"[16]los dibujos animados", @""),
                                                                                       NSLocalizedString(@"[20]manga", @""),
                                                                                       NSLocalizedString(@"[19]Altres", @""),
                                                                                       nil]];

        if(([self userSelectedIdentifierForKeyPath:kMoviesUserProfileField]) || (showEmptyFields))
            [preferencesFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:kMoviesUserProfileField
                                                                                          title:NSLocalizedString(@"Pel·lícules preferides", @"")
                                                                               valueTransformer:nil
                                                                                  selectionMode:IBAPickListSelectionModeMultiple
                                                                                        options:moviesListOptions

                                                                                     isReadOnly:isReadOnly]];
    
        //Remove section if is empty
        for(int i=0; i<[[self sections] count]; i++)
        {
            IBAFormSection *section = [[self sections] objectAtIndex:i];
            if((section == preferencesFieldSection) && (![[section formFields] count]))
            {
                [[self sections] removeObjectAtIndex:i];
            }
            else if(section == preferencesFieldSection)
            {
                height+=kUserProfileFormHeaderCellHeight;
                height+=(kUserProfileFormCellHeight * [[section formFields] count]);

                numberOfFieldsInCultureSection = [[section formFields] count];
            }
        }
}

- (int)userSelectedIdentifierForKeyPath:(NSString *)keyPath
{
    NSArray *selectedListOption = [self.model objectForKey:keyPath];

    if(![selectedListOption count])
        return 0;

    IBAPickListFormOption *firstSelectedOption = [selectedListOption objectAtIndex:0];
    NSString *itemNameWithValue = [firstSelectedOption name];
    NSString *itemValue = @"0";

    NSRange range_open_clautador = [itemNameWithValue rangeOfString:@"["];
    NSRange range_close_clautador = [itemNameWithValue rangeOfString:@"]"];
    if(range_open_clautador.location < range_close_clautador.location)
    {
        int range_length = range_close_clautador.location - (range_open_clautador.location + 1);
        itemValue = [itemNameWithValue substringWithRange:NSMakeRange(range_open_clautador.location + 1, range_length)];
    }
    
    return [itemValue intValue];
}

- (NSDictionary *)getModelWithValues
{
    NSMutableDictionary *modelWithValues = [[NSMutableDictionary alloc] init];

    for (NSString* key in self.model)
    {
        NSArray *items = [self.model objectForKey:key];

        if([[self.model objectForKey:key] isKindOfClass:[NSSet class]])
            items = [[self.model objectForKey:key] allObjects];

        NSMutableArray *itemsWithValues = [[NSMutableArray alloc] init];

        for(int i=0; i<[items count]; i++)
        {
            NSString *itemNameWithValue = ((IBAPickListFormOption *)[items objectAtIndex:i]).name;
            NSString *itemName = itemNameWithValue;
            NSString *itemValue = @"";

            NSRange range_open_clautador = [itemNameWithValue rangeOfString:@"["];
            NSRange range_close_clautador = [itemNameWithValue rangeOfString:@"]"];
            if(range_open_clautador.location < range_close_clautador.location)
            {
                int range_length = range_close_clautador.location - (range_open_clautador.location + 1);
                itemValue = [itemNameWithValue substringWithRange:NSMakeRange(range_open_clautador.location + 1, range_length)];
                itemName = [itemNameWithValue stringByReplacingCharactersInRange:NSMakeRange(range_open_clautador.location, range_length + 2) withString:@""];
            }

            NSDictionary *pairValueName = @{ itemValue : itemName };
            [itemsWithValues addObject:pairValueName];
        }

        [modelWithValues setObject:itemsWithValues forKey:key];
    }

    return [NSDictionary dictionaryWithDictionary:modelWithValues];
}

- (void)setReadOnly:(bool)readOnly
{
    isReadOnly = readOnly;

    IBAFormFieldStyle *selectedStyle = readOnly ? readOnlyStyle:readWriteStyle;
    [self setFormFieldStyle:selectedStyle];
    [self reloadData];
}

- (void)loadStyles
{
    readOnlyStyle = [[IBAFormFieldStyle alloc] init];
    [readOnlyStyle setIsReadOnly:YES];

    readWriteStyle = [[IBAFormFieldStyle alloc] init];
    [readWriteStyle setIsReadOnly:NO];
}

- (void)setModelValue:(id)value forKeyPath:(NSString *)keyPath {
	[super setModelValue:value forKeyPath:keyPath];
	
	NSLog(@"%@", [self.model description]);
}

@end
