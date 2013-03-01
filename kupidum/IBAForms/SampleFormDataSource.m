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
#import "SampleFormDataSource.h"
#import "StringToNumberTransformer.h"
#import "ShowcaseButtonStyle.h"

@implementation SampleFormDataSource

- (id)initWithModel:(id)aModel {
	if (self = [super initWithModel:aModel]) {
		// Some basic form fields that accept text input
		IBAFormSection *basicFieldSection = [self addSectionWithHeaderTitle:NSLocalizedString(@"La meva aparença", @"") footerTitle:nil];

		NSArray *eyeColorListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"Prefereixo no dir-ho", @""),
                                                                                     NSLocalizedString(@"Avellana", @""),
																					 NSLocalizedString(@"Blaus", @""),
																					 NSLocalizedString(@"Grisos", @""),
																					 NSLocalizedString(@"Marrons", @""),
																					 NSLocalizedString(@"Negres", @""),
																					 NSLocalizedString(@"Verds", @""),
																					 nil]];

		[basicFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:@"eyeColorPickListItem"
                                                                                title:NSLocalizedString(@"Color d'ulls", @"")
                                                                   valueTransformer:nil
                                                                      selectionMode:IBAPickListSelectionModeSingle
                                                                            options:eyeColorListOptions]];

        NSMutableArray *heightArray = [[NSMutableArray alloc] init];
        [heightArray addObject:NSLocalizedString(@"Prefereixo no dir-ho", @"")];
        for(int h=140; h<200; h++)
            [heightArray addObject:[NSString stringWithFormat:@"%d cm", h]];

		NSArray *heightListOptions = [IBAPickListFormOption pickListOptionsForStrings:heightArray];

		[basicFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:@"heightPickListItem"
                                                                                title:NSLocalizedString(@"Alçada", @"")
                                                                     valueTransformer:nil
                                                                        selectionMode:IBAPickListSelectionModeSingle
                                                                              options:heightListOptions]];

        NSMutableArray *weightArray = [[NSMutableArray alloc] init];
        [weightArray addObject:NSLocalizedString(@"Prefereixo no dir-ho", @"")];
        for(int h=40; h<120; h++)
            [weightArray addObject:[NSString stringWithFormat:@"%d kg", h]];

		NSArray *weightListOptions = [IBAPickListFormOption pickListOptionsForStrings:weightArray];

		[basicFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:@"weightPickListItem"
                                                                                title:NSLocalizedString(@"Pes", @"")
                                                                     valueTransformer:nil
                                                                        selectionMode:IBAPickListSelectionModeSingle
                                                                              options:weightListOptions]];

		NSArray *hairColorListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"Prefereixo no dir-ho", @""),
                                                                                         NSLocalizedString(@"Blanc", @""),
                                                                                         NSLocalizedString(@"Castany", @""),
                                                                                         NSLocalizedString(@"Gris", @""),
                                                                                         NSLocalizedString(@"Moreno", @""),
                                                                                         NSLocalizedString(@"Pèl-roig", @""),
                                                                                         NSLocalizedString(@"Ros", @""),
                                                                                         nil]];
        
		[basicFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:@"hairColorPickListItem"
                                                                                title:NSLocalizedString(@"Color del cabell", @"")
                                                                     valueTransformer:nil
                                                                        selectionMode:IBAPickListSelectionModeSingle
                                                                              options:hairColorListOptions]];

		NSArray *hairSizeListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"Prefereixo no dir-ho", @""),
                                                                                          NSLocalizedString(@"Rapat", @""),
                                                                                          NSLocalizedString(@"Molt curt", @""),
                                                                                          NSLocalizedString(@"Curt", @""),
                                                                                          NSLocalizedString(@"Semillarg", @""),
                                                                                          NSLocalizedString(@"Llarg", @""),
                                                                                          NSLocalizedString(@"Molt llarg", @""),
                                                                                          NSLocalizedString(@"Sense pèl", @""),
                                                                                          nil]];
        
		[basicFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:@"hairSizePickListItem"
                                                                                title:NSLocalizedString(@"Llargada del cabell", @"")
                                                                     valueTransformer:nil
                                                                        selectionMode:IBAPickListSelectionModeSingle
                                                                              options:hairSizeListOptions]];

		NSArray *bodyLookListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"Prefereixo no dir-ho", @""),
                                                                                         NSLocalizedString(@"Explosiu", @""),
                                                                                         NSLocalizedString(@"Molt agradable de veure", @""),
                                                                                         NSLocalizedString(@"Agradable de veure", @""),
                                                                                         NSLocalizedString(@"En la mitjana", @""),
                                                                                         NSLocalizedString(@"No gaire dolent", @""),
                                                                                         NSLocalizedString(@"No ho he de dir jo", @""),
                                                                                         NSLocalizedString(@"El físic no té importància", @""),
                                                                                         nil]];
        
		[basicFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:@"bodyLookListItem"
                                                                                title:NSLocalizedString(@"El meu aspecte", @"")
                                                                     valueTransformer:nil
                                                                        selectionMode:IBAPickListSelectionModeSingle
                                                                              options:bodyLookListOptions]];


		NSArray *myHighlightListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"Prefereixo no dir-ho", @""),
                                                                                         NSLocalizedString(@"La meva boca", @""),
                                                                                         NSLocalizedString(@"El meu cabell", @""),
                                                                                         NSLocalizedString(@"El meu nas", @""),
                                                                                         NSLocalizedString(@"La meva nuca", @""),
                                                                                         NSLocalizedString(@"El meu somriure", @""),
                                                                                         NSLocalizedString(@"El meu cul", @""),
                                                                                         NSLocalizedString(@"Les meves mans", @""),
                                                                                         NSLocalizedString(@"Els meus músculs", @""),
                                                                                         NSLocalizedString(@"Els meus ulls", @""),
                                                                                         NSLocalizedString(@"Els meus pectorals", @""),
                                                                                         NSLocalizedString(@"Les meves cames", @""),
                                                                                         NSLocalizedString(@"El més bonic no està a la llista", @""),
                                                                                         nil]];

		[basicFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:@"myHighlightListItem"
                                                                                title:NSLocalizedString(@"El més atractiu de mi", @"")
                                                                     valueTransformer:nil
                                                                        selectionMode:IBAPickListSelectionModeSingle
                                                                              options:myHighlightListOptions]];



		IBAFormSection *valuesFieldSection = [self addSectionWithHeaderTitle:NSLocalizedString(@"Els meus valors", @"") footerTitle:nil];

		NSArray *nationColorListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"[0]Prefereixo no dir-ho", @""),
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

		[valuesFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:@"nationPickListItem"
                                                                                title:NSLocalizedString(@"La meva nacionalitat", @"")
                                                                     valueTransformer:nil
                                                                        selectionMode:IBAPickListSelectionModeSingle
                                                                              options:nationColorListOptions]];


		NSArray *ethnicalOriginListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"Prefereixo no dir-ho", @""),
                                                                                            NSLocalizedString(@"Europeu", @""),
                                                                                            NSLocalizedString(@"Hispà", @""),
                                                                                            NSLocalizedString(@"Africà", @""),
                                                                                            NSLocalizedString(@"Àrab", @""),
                                                                                            NSLocalizedString(@"Aisàtic", @""),
                                                                                            NSLocalizedString(@"Indi", @""),
                                                                                            NSLocalizedString(@"Un altre", @""),
                                                                                            nil]];
        
		[valuesFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:@"ethnicalOriginListItem"
                                                                                title:NSLocalizedString(@"El meu origen ètnic", @"")
                                                                     valueTransformer:nil
                                                                        selectionMode:IBAPickListSelectionModeSingle
                                                                              options:ethnicalOriginListOptions]];


		NSArray *religionListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"Prefereixo no dir-ho", @""),
                                                                                               NSLocalizedString(@"Agnòstic", @""),
                                                                                               NSLocalizedString(@"Ateu", @""),
                                                                                               NSLocalizedString(@"Budista", @""),
                                                                                               NSLocalizedString(@"Catòlic", @""),
                                                                                               NSLocalizedString(@"Cristià", @""),
                                                                                               NSLocalizedString(@"Hinduista", @""),
                                                                                               NSLocalizedString(@"Jueu", @""),
                                                                                               NSLocalizedString(@"Musulmà", @""),
                                                                                               NSLocalizedString(@"Ortodox", @""),
                                                                                               NSLocalizedString(@"Protestant", @""),
                                                                                               NSLocalizedString(@"Un altre", @""),
                                                                                               nil]];

		[valuesFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:@"religionListItem"
                                                                                title:NSLocalizedString(@"La meva religió", @"")
                                                                     valueTransformer:nil
                                                                        selectionMode:IBAPickListSelectionModeSingle
                                                                              options:religionListOptions]];

        
        
		NSArray *religionLevelListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"Prefereixo no dir-ho", @""),
                                                                                         NSLocalizedString(@"Practicant", @""),
                                                                                         NSLocalizedString(@"Practicant ocasional", @""),
                                                                                         NSLocalizedString(@"No practicant", @""),
                                                                                         nil]];

		[valuesFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:@"religionLevelListItem"
                                                                                title:NSLocalizedString(@"Pràctica religiosa", @"")
                                                                     valueTransformer:nil
                                                                        selectionMode:IBAPickListSelectionModeSingle
                                                                              options:religionLevelListOptions]];


		NSArray *marriageOpinionListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"Prefereixo no dir-ho", @""),
                                                                                              NSLocalizedString(@"Sagrat", @""),
                                                                                              NSLocalizedString(@"Molt important", @""),
                                                                                              NSLocalizedString(@"Important", @""),
                                                                                              NSLocalizedString(@"No és indispensable", @""),
                                                                                              NSLocalizedString(@"Impensable", @""),
                                                                                              NSLocalizedString(@"No em tornaré a casar", @""),
                                                                                              nil]];

		[valuesFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:@"marriageOpinionListItem"
                                                                                title:NSLocalizedString(@"Per mi, el matrimoni és", @"")
                                                                     valueTransformer:nil
                                                                        selectionMode:IBAPickListSelectionModeSingle
                                                                              options:marriageOpinionListOptions]];


		NSArray *romanticismLevelListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"Prefereixo no dir-ho", @""),
                                                                                                NSLocalizedString(@"Molt romàntic", @""),
                                                                                                NSLocalizedString(@"Bastant romàntic", @""),
                                                                                                NSLocalizedString(@"Poc romàntic", @""),
                                                                                                NSLocalizedString(@"Gens romàntic", @""),
                                                                                                nil]];

		[valuesFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:@"romanticismLevelListItem"
                                                                                title:NSLocalizedString(@"Sóc romàntic", @"")
                                                                     valueTransformer:nil
                                                                        selectionMode:IBAPickListSelectionModeSingle
                                                                              options:romanticismLevelListOptions]];


        
		NSArray *iWantChildrensListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"Prefereixo no dir-ho", @""),
                                                                                                 NSLocalizedString(@"No", @""),
                                                                                                 NSLocalizedString(@"Sí, 1", @""),
                                                                                                 NSLocalizedString(@"Sí, 2", @""),
                                                                                                 NSLocalizedString(@"Sí, 3", @""),
                                                                                                 NSLocalizedString(@"Sí, més de 3", @""),
                                                                                                 NSLocalizedString(@"Sí, número no decidit", @""),
                                                                                                 nil]];
        
		[valuesFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:@"iWantChildrensListItem"
                                                                                title:NSLocalizedString(@"Vull tenir fills", @"")
                                                                     valueTransformer:nil
                                                                        selectionMode:IBAPickListSelectionModeSingle
                                                                              options:iWantChildrensListOptions]];



		IBAFormSection *professionalSituationFieldSection = [self addSectionWithHeaderTitle:NSLocalizedString(@"La meva situació professional", @"") footerTitle:nil];

		NSArray *studiesLevelListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"Prefereixo no dir-ho", @""),
                                                                                               NSLocalizedString(@"Institut o inferior", @""),
                                                                                               NSLocalizedString(@"Batxillerat", @""),
                                                                                               NSLocalizedString(@"Mòdul professional", @""),
                                                                                               NSLocalizedString(@"Diplomat", @""),
                                                                                               NSLocalizedString(@"Llicenciat o superior", @""),
                                                                                               NSLocalizedString(@"Altres", @""),
                                                                                               nil]];
        
		[professionalSituationFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:@"studiesLevelListItem"
                                                                                 title:NSLocalizedString(@"El meu nivell d'estudis", @"")
                                                                      valueTransformer:nil
                                                                         selectionMode:IBAPickListSelectionModeSingle
                                                                               options:studiesLevelListOptions]];


		NSArray *languagesListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"Prefereixo no dir-ho", @""),
                                                                                             NSLocalizedString(@"Anglés", @""),
                                                                                             NSLocalizedString(@"Castellà", @""),
                                                                                             NSLocalizedString(@"Català", @""),
                                                                                             NSLocalizedString(@"Francés", @""),
                                                                                             NSLocalizedString(@"Altres", @""),
                                                                                             nil]];

		[professionalSituationFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:@"languagesListItem"
                                                                                                title:NSLocalizedString(@"Idiomes que parlo", @"")
                                                                                     valueTransformer:nil
                                                                                        selectionMode:IBAPickListSelectionModeMultiple
                                                                                              options:languagesListOptions]];


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
        
		[professionalSituationFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:@"myBusinessListItem"
                                                                                                title:NSLocalizedString(@"La meva professió", @"")
                                                                                     valueTransformer:nil
                                                                                        selectionMode:IBAPickListSelectionModeSingle
                                                                                              options:myBusinessListOptions]];


		NSArray *salaryListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"Prefereixo no dir-ho", @""),
                                                                                             NSLocalizedString(@"Menys de 10.000€/any", @""),
                                                                                             NSLocalizedString(@"De 10 a 20.000€/any", @""),
                                                                                             NSLocalizedString(@"De 20 a 30.000€/any", @""),
                                                                                             NSLocalizedString(@"De 30 a 50.000€/any", @""),
                                                                                             NSLocalizedString(@"De 50 a 75.000€/any", @""),
                                                                                             NSLocalizedString(@"De 75 a 100.000€/any", @""),
                                                                                             NSLocalizedString(@"Més de 100.000€/any", @""),
                                                                                             nil]];

		[professionalSituationFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:@"salaryListItem"
                                                                                                title:NSLocalizedString(@"Els meus ingressos", @"")
                                                                                     valueTransformer:nil
                                                                                        selectionMode:IBAPickListSelectionModeSingle
                                                                                              options:salaryListOptions]];



		IBAFormSection *lifestyleFieldSection = [self addSectionWithHeaderTitle:NSLocalizedString(@"El meu estil de vida", @"") footerTitle:nil];

		NSArray *myStyleListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"Prefereixo no dir-ho", @""),
                                                                                             NSLocalizedString(@"A la moda", @""),
                                                                                             NSLocalizedString(@"Bohemi", @""),
                                                                                             NSLocalizedString(@"Clàssic", @""),
                                                                                             NSLocalizedString(@"Esportiu", @""),
                                                                                             NSLocalizedString(@"Despreocupat", @""),
                                                                                             NSLocalizedString(@"Ètnic", @""),
                                                                                             NSLocalizedString(@"Negocis", @""),
                                                                                             NSLocalizedString(@"Pijo", @""),
                                                                                             NSLocalizedString(@"Rock", @""),
                                                                                             NSLocalizedString(@"Altres", @""),
                                                                                             nil]];

		[lifestyleFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:@"myStyleListItem"
                                                                                                title:NSLocalizedString(@"El meu estil", @"")
                                                                                     valueTransformer:nil
                                                                                        selectionMode:IBAPickListSelectionModeSingle
                                                                                              options:myStyleListOptions]];


		NSArray *alimentListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"Prefereixo no dir-ho", @""),
                                                                                        NSLocalizedString(@"A dieta", @""),
                                                                                        NSLocalizedString(@"Casher", @""),
                                                                                        NSLocalizedString(@"Menjo de tot", @""),
                                                                                        NSLocalizedString(@"Halal", @""),
                                                                                        NSLocalizedString(@"Macrobiòtic", @""),
                                                                                        NSLocalizedString(@"Vegà", @""),
                                                                                        NSLocalizedString(@"Vegetarià", @""),
                                                                                        nil]];
        
		[lifestyleFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:@"alimentListItem"
                                                                                    title:NSLocalizedString(@"La meva alimentació", @"")
                                                                         valueTransformer:nil
                                                                            selectionMode:IBAPickListSelectionModeSingle
                                                                                  options:alimentListOptions]];



		NSArray *smokeListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"Prefereixo no dir-ho", @""),
                                                                                        NSLocalizedString(@"No (el fumo no és un problema)", @""),
                                                                                        NSLocalizedString(@"No (no m'agrada el fum)", @""),
                                                                                        NSLocalizedString(@"Sí, ocasionalment", @""),
                                                                                        NSLocalizedString(@"Sí, regularment", @""),
                                                                                        nil]];

		[lifestyleFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:@"smokeListItem"
                                                                                    title:NSLocalizedString(@"Fumo", @"")
                                                                         valueTransformer:nil
                                                                            selectionMode:IBAPickListSelectionModeSingle
                                                                                  options:smokeListOptions]];


		NSArray *animalsListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"Prefereixo no dir-ho", @""),
                                                                                      NSLocalizedString(@"Canari", @""),
                                                                                      NSLocalizedString(@"Gat", @""),
                                                                                      NSLocalizedString(@"Gos", @""),
                                                                                      NSLocalizedString(@"Hamster", @""),
                                                                                      nil]];

		[lifestyleFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:@"animalsListItem"
                                                                                    title:NSLocalizedString(@"Els meus animals", @"")
                                                                         valueTransformer:nil
                                                                            selectionMode:IBAPickListSelectionModeSingle
                                                                                  options:animalsListOptions]];



		IBAFormSection *interestsFieldSection = [self addSectionWithHeaderTitle:NSLocalizedString(@"Els meus interessos", @"") footerTitle:nil];
        
		NSArray *myHobbiesListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"Prefereixo no dir-ho", @""),
                                                                                          NSLocalizedString(@"exposiciones/museos", @""),
                                                                                          NSLocalizedString(@"informática", @""),
                                                                                          NSLocalizedString(@"lectura", @""),
                                                                                          NSLocalizedString(@"teatro", @""),
                                                                                          NSLocalizedString(@"viajes", @""),
                                                                                          NSLocalizedString(@"cocina", @""),
                                                                                          NSLocalizedString(@"compras", @""),
                                                                                          NSLocalizedString(@"deporte", @""),
                                                                                          NSLocalizedString(@"foto", @""),
                                                                                          NSLocalizedString(@"música", @""),
                                                                                          NSLocalizedString(@"animales", @""),
                                                                                          NSLocalizedString(@"pintura", @""),
                                                                                          NSLocalizedString(@"actividad caritativa", @""),
                                                                                          NSLocalizedString(@"ajedrez", @""),
                                                                                          NSLocalizedString(@"automóvil", @""),
                                                                                          NSLocalizedString(@"bricolaje", @""),
                                                                                          NSLocalizedString(@"colección de figuritas", @""),
                                                                                          NSLocalizedString(@"costura/punto", @""),
                                                                                          NSLocalizedString(@"danza", @""),
                                                                                          NSLocalizedString(@"decoración", @""),
                                                                                          NSLocalizedString(@"dibujo", @""),
                                                                                          NSLocalizedString(@"escritura", @""),
                                                                                          NSLocalizedString(@"internet", @""),
                                                                                          NSLocalizedString(@"jardinería", @""),
                                                                                          NSLocalizedString(@"juegos de cartas", @""),
                                                                                          NSLocalizedString(@"juegos de rol", @""),
                                                                                          NSLocalizedString(@"juegos de sociedad", @""),
                                                                                          NSLocalizedString(@"paseos", @""),
                                                                                          NSLocalizedString(@"televisión", @""),
                                                                                          NSLocalizedString(@"videojuegos", @""),
                                                                                          NSLocalizedString(@"Altres", @""),
                                                                                          nil]];

		[interestsFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:@"myHobbiesListItem"
                                                                                    title:NSLocalizedString(@"Les meves aficions", @"")
                                                                         valueTransformer:nil
                                                                            selectionMode:IBAPickListSelectionModeMultiple
                                                                                  options:myHobbiesListOptions]];



		NSArray *mySportsListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"Prefereixo no dir-ho", @""),
                                                                                         NSLocalizedString(@"fútbol", @""),
                                                                                         NSLocalizedString(@"baloncesto", @""),
                                                                                         NSLocalizedString(@"fitness", @""),
                                                                                         NSLocalizedString(@"jogging", @""),
                                                                                         NSLocalizedString(@"natación", @""),
                                                                                         NSLocalizedString(@"vela", @""),
                                                                                         NSLocalizedString(@"windsurf", @""),
                                                                                         NSLocalizedString(@"ciclismo", @""),
                                                                                         NSLocalizedString(@"deportes de riesgo", @""),
                                                                                         NSLocalizedString(@"ski/snowboard", @""),
                                                                                         NSLocalizedString(@"tenis", @""),
                                                                                         NSLocalizedString(@"surf", @""),
                                                                                         NSLocalizedString(@"atletismo", @""),
                                                                                         NSLocalizedString(@"automóvil", @""),
                                                                                         NSLocalizedString(@"bádminton", @""),
                                                                                         NSLocalizedString(@"balonmano", @""),
                                                                                         NSLocalizedString(@"béisbol", @""),
                                                                                         NSLocalizedString(@"boxeo", @""),
                                                                                         NSLocalizedString(@"cricket", @""),
                                                                                         NSLocalizedString(@"danza", @""),
                                                                                         NSLocalizedString(@"deportes de combate", @""),
                                                                                         NSLocalizedString(@"deportes mecánicos", @""),
                                                                                         NSLocalizedString(@"equitación", @""),
                                                                                         NSLocalizedString(@"fútbol americano", @""),
                                                                                         NSLocalizedString(@"gimnasia", @""),
                                                                                         NSLocalizedString(@"golf", @""),
                                                                                         NSLocalizedString(@"hockey", @""),
                                                                                         NSLocalizedString(@"judo", @""),
                                                                                         NSLocalizedString(@"kárate", @""),
                                                                                         NSLocalizedString(@"moto", @""),
                                                                                         NSLocalizedString(@"ninguno", @""),
                                                                                         NSLocalizedString(@"otros deportes acuáticos", @""),
                                                                                         NSLocalizedString(@"roller", @""),
                                                                                         NSLocalizedString(@"rugby", @""),
                                                                                         NSLocalizedString(@"senderismo/trekking", @""),
                                                                                         NSLocalizedString(@"skateboard", @""),
                                                                                         NSLocalizedString(@"skiing", @""),
                                                                                         NSLocalizedString(@"squash", @""),
                                                                                         NSLocalizedString(@"tenis de mesa", @""),
                                                                                         NSLocalizedString(@"volley-ball", @""),
                                                                                         NSLocalizedString(@"Altres", @""),
                                                                                         nil]];

		[interestsFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:@"mySportsListItem"
                                                                                    title:NSLocalizedString(@"Els meus esports", @"")
                                                                         valueTransformer:nil
                                                                            selectionMode:IBAPickListSelectionModeMultiple
                                                                                  options:mySportsListOptions]];



		NSArray *mySparetimeListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"Prefereixo no dir-ho", @""),
                                                                                            NSLocalizedString(@"acontecimiento deportivo", @""),
                                                                                            NSLocalizedString(@"after work", @""),
                                                                                            NSLocalizedString(@"bares / pubs", @""),
                                                                                            NSLocalizedString(@"cine", @""),
                                                                                            NSLocalizedString(@"concierto", @""),
                                                                                            NSLocalizedString(@"discoteca", @""),
                                                                                            NSLocalizedString(@"espectáculos de danza", @""),
                                                                                            NSLocalizedString(@"familia", @""),
                                                                                            NSLocalizedString(@"fiestas entre amigos", @""),
                                                                                            NSLocalizedString(@"ópera", @""),
                                                                                            NSLocalizedString(@"restaurante", @""),
                                                                                            NSLocalizedString(@"teatro", @""),
                                                                                            NSLocalizedString(@"karaoke", @""),
                                                                                            NSLocalizedString(@"leer", @""),
                                                                                            NSLocalizedString(@"Altres", @""),
                                                                                            nil]];

		[interestsFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:@"mySparetimeListItem"
                                                                                    title:NSLocalizedString(@"Les meves sortides", @"")
                                                                         valueTransformer:nil
                                                                            selectionMode:IBAPickListSelectionModeMultiple
                                                                                  options:mySparetimeListOptions]];



		IBAFormSection *preferencesFieldSection = [self addSectionWithHeaderTitle:NSLocalizedString(@"Els meus interessos", @"") footerTitle:nil];

		NSArray *musicListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"Prefereixo no dir-ho", @""),
                                                                                      NSLocalizedString(@"ambiente / de relajación", @""),
                                                                                      NSLocalizedString(@"blues", @""),
                                                                                      NSLocalizedString(@"independiente", @""),
                                                                                      NSLocalizedString(@"latina", @""),
                                                                                      NSLocalizedString(@"ópera", @""),
                                                                                      NSLocalizedString(@"reggae", @""),
                                                                                      NSLocalizedString(@"clásica", @""),
                                                                                      NSLocalizedString(@"electrónca-tecno", @""),
                                                                                      NSLocalizedString(@"funk", @""),
                                                                                      NSLocalizedString(@"jazz", @""),
                                                                                      NSLocalizedString(@"pop-rock", @""),
                                                                                      NSLocalizedString(@"rap", @""),
                                                                                      NSLocalizedString(@"bandas sonoras", @""),
                                                                                      NSLocalizedString(@"country", @""),
                                                                                      NSLocalizedString(@"dance y DJ", @""),
                                                                                      NSLocalizedString(@"disco", @""),
                                                                                      NSLocalizedString(@"folk", @""),
                                                                                      NSLocalizedString(@"gospel", @""),
                                                                                      NSLocalizedString(@"hard rock", @""),
                                                                                      NSLocalizedString(@"música tradicional", @""),
                                                                                      NSLocalizedString(@"r'n'b", @""),
                                                                                      NSLocalizedString(@"soul", @""),
                                                                                      NSLocalizedString(@"trip-hop", @""),
                                                                                      NSLocalizedString(@"variedades", @""),
                                                                                      NSLocalizedString(@"world music", @""),
                                                                                      NSLocalizedString(@"Altres", @""),
                                                                                            nil]];
        
		[preferencesFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:@"musicListItem"
                                                                                    title:NSLocalizedString(@"Gustos musicals", @"")
                                                                         valueTransformer:nil
                                                                            selectionMode:IBAPickListSelectionModeMultiple
                                                                                  options:musicListOptions]];



		NSArray *moviesListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:NSLocalizedString(@"Prefereixo no dir-ho", @""),
                                                                                       NSLocalizedString(@"de acción", @""),
                                                                                       NSLocalizedString(@"de aventuras", @""),
                                                                                       NSLocalizedString(@"de terror", @""),
                                                                                       NSLocalizedString(@"documentales", @""),
                                                                                       NSLocalizedString(@"las comedias sentimentales", @""),
                                                                                       NSLocalizedString(@"ciencia-ficción", @""),
                                                                                       NSLocalizedString(@"cómicas", @""),
                                                                                       NSLocalizedString(@"de autor", @""),
                                                                                       NSLocalizedString(@"dramáticas", @""),
                                                                                       NSLocalizedString(@"fantásticas", @""),
                                                                                       NSLocalizedString(@"las comedias musicales", @""),
                                                                                       NSLocalizedString(@"policíacas", @""),
                                                                                       NSLocalizedString(@"animación", @""),
                                                                                       NSLocalizedString(@"cortometrajes", @""),
                                                                                       NSLocalizedString(@"de guerra", @""),
                                                                                       NSLocalizedString(@"de vaqueros", @""),
                                                                                       NSLocalizedString(@"eróticas", @""),
                                                                                       NSLocalizedString(@"históricas", @""),
                                                                                       NSLocalizedString(@"los dibujos animados", @""),
                                                                                       NSLocalizedString(@"manga", @""),
                                                                                       NSLocalizedString(@"Altres", @""),
                                                                                       nil]];

		[preferencesFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:@"moviesListItem"
                                                                                      title:NSLocalizedString(@"Pel·lícules preferides", @"")
                                                                           valueTransformer:nil
                                                                              selectionMode:IBAPickListSelectionModeMultiple
                                                                                    options:moviesListOptions]];




/*		[basicFieldSection addFormField:[[IBATextFormField alloc] initWithKeyPath:@"text" title:@"Text"]];
		[IBATextFormField passwordTextFormFieldWithSection:basicFieldSection keyPath:@"password" title:@"Password" valueTransformer:nil];
		[basicFieldSection addFormField:[[IBABooleanFormField alloc] initWithKeyPath:@"booleanSwitchValue" title:@"Switch"]];
		[basicFieldSection addFormField:[[IBABooleanFormField alloc] initWithKeyPath:@"booleanCheckValue" title:@"Check" type:IBABooleanFormFieldTypeCheck]];

		
		// Styled form fields
		IBAFormSection *styledFieldSection = [self addSectionWithHeaderTitle:@"Styled Fields" footerTitle:nil];

		IBAFormFieldStyle *style = [[IBAFormFieldStyle alloc] init];
		style.labelTextColor = [UIColor blackColor];
		style.labelFont = [UIFont systemFontOfSize:14];
		style.labelTextAlignment = UITextAlignmentLeft;
		style.valueTextAlignment = UITextAlignmentRight;
		style.valueTextColor = [UIColor darkGrayColor];
		style.activeColor = [UIColor colorWithRed:0.934 green:0.791 blue:0.905 alpha:1.000];

		styledFieldSection.formFieldStyle = style;

		[styledFieldSection addFormField:[[IBATextFormField alloc] initWithKeyPath:@"textStyled" title:@"Text"]];
		[IBATextFormField passwordTextFormFieldWithSection:styledFieldSection keyPath:@"passwordStyled" title:@"Password" valueTransformer:nil];

		// Date fields
		IBAFormSection *dateFieldSection = [self addSectionWithHeaderTitle:@"Dates" footerTitle:nil];

		NSDateFormatter *dateTimeFormatter = [[NSDateFormatter alloc] init];
		[dateTimeFormatter setDateStyle:NSDateFormatterShortStyle];
		[dateTimeFormatter setTimeStyle:NSDateFormatterNoStyle];
		[dateTimeFormatter setDateFormat:@"EEE d MMM  h:mm a"];

		[dateFieldSection addFormField:[[IBADateFormField alloc] initWithKeyPath:@"dateTime"
															 title:@"Date & Time"
													  defaultValue:[NSDate date]
															  type:IBADateFormFieldTypeDateTime
													 dateFormatter:dateTimeFormatter]];

		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
		[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
		[dateFormatter setDateFormat:@"EEE d MMM yyyy"];

		[dateFieldSection addFormField:[[IBADateFormField alloc] initWithKeyPath:@"date"
																			title:@"Date"
																	 defaultValue:[NSDate date]
																			 type:IBADateFormFieldTypeDate
																	dateFormatter:dateFormatter]];

		NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
		[timeFormatter setDateStyle:NSDateFormatterShortStyle];
		[timeFormatter setTimeStyle:NSDateFormatterNoStyle];
		[timeFormatter setDateFormat:@"h:mm a"];

		[dateFieldSection addFormField:[[IBADateFormField alloc] initWithKeyPath:@"time"
																		title:@"Time"
																 defaultValue:[NSDate date]
																		 type:IBADateFormFieldTypeTime
																dateFormatter:timeFormatter]];

		// Picklists
		IBAFormSection *pickListSection = [self addSectionWithHeaderTitle:@"Pick Lists" footerTitle:nil];

		NSArray *pickListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:@"Apples",
																					 @"Bananas",
																					 @"Oranges",
																					 @"Lemons",
																					 nil]];

		[pickListSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:@"singlePickListItem"
																			   title:@"Single"
																	valueTransformer:nil
																	   selectionMode:IBAPickListSelectionModeSingle
																			 options:pickListOptions]];

		NSArray *carListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:@"Honda",
																					  @"BMW",
																					  @"Holden",
																					  @"Ford",
																					  @"Toyota",
																					  @"Mitsubishi",
																					  nil]];

		IBAPickListFormOptionsStringTransformer *transformer = [[IBAPickListFormOptionsStringTransformer alloc] initWithPickListOptions:carListOptions];
		[pickListSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:@"multiplePickListItems"
																			   title:@"Multiple"
																	valueTransformer:transformer
																	   selectionMode:IBAPickListSelectionModeMultiple
																			 options:carListOptions]];

		// An example of modifying the UITextInputTraits of an IBATextFormField and using an NSValueTransformer
		IBAFormSection *textInputTraitsSection = [self addSectionWithHeaderTitle:@"Traits & Transformations" footerTitle:nil];
		IBATextFormField *numberField = [[IBATextFormField alloc] initWithKeyPath:@"number"
																			title:@"Number"
																 valueTransformer:[StringToNumberTransformer instance]];
		[textInputTraitsSection addFormField:numberField];
		numberField.textFormFieldCell.textField.keyboardType = UIKeyboardTypeNumberPad;


		// Read-only fields
		IBAFormFieldStyle *readonlyFieldStyle = [[IBAFormFieldStyle alloc] init];
		readonlyFieldStyle.labelFrame = CGRectMake(IBAFormFieldLabelX, IBAFormFieldLabelY, IBAFormFieldLabelWidth + 100, IBAFormFieldLabelHeight);
		readonlyFieldStyle.labelTextAlignment = UITextAlignmentLeft;
    
		IBAFormSection *readonlyFieldSection = [self addSectionWithHeaderTitle:@"Read-Only Fields" footerTitle:nil];
		
        // IBAReadOnlyTextFormField displays the value the field is bound in a read-only text view. The title is displayed as the field's label.
		[readonlyFieldSection addFormField:[[IBAReadOnlyTextFormField alloc] initWithKeyPath:@"readOnlyText" title:@"Read Only"]];
		
        // IBATitleFormField displays the provided title in the field's label. No value is displayed for the field.
		[readonlyFieldSection addFormField:[[IBATitleFormField alloc] initWithTitle:@"A title"]];
        
		// IBALabelFormField displays the value the field is bound to as the field's label.
		IBALabelFormField *labelField = [[IBALabelFormField alloc] initWithKeyPath:@"readOnlyText"];
		labelField.formFieldStyle = readonlyFieldStyle;
		[readonlyFieldSection addFormField:labelField];



		// Some examples of how you might use the button form field
		IBAFormSection *buttonsSection = [self addSectionWithHeaderTitle:@"Buttons" footerTitle:nil];
		buttonsSection.formFieldStyle = [[ShowcaseButtonStyle alloc] init];

		[buttonsSection addFormField:[[IBAButtonFormField alloc] initWithTitle:@"Go to Google"
																		   icon:nil
																 executionBlock:^{
																	 [[UIApplication sharedApplication]
																	  openURL:[NSURL URLWithString:@"http://www.google.com"]];
																 }]];

		[buttonsSection addFormField:[[IBAButtonFormField alloc] initWithTitle:@"Compose email"
																		   icon:nil
																 executionBlock:^{
																	 [[UIApplication sharedApplication]
																	  openURL:[NSURL URLWithString:@"mailto:info@google.com"]];
																 }]];
*/
    }

    return self;
}

- (void)setModelValue:(id)value forKeyPath:(NSString *)keyPath {
	[super setModelValue:value forKeyPath:keyPath];
	
	NSLog(@"%@", [self.model description]);
}

@end
