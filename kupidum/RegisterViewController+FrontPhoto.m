//
//  RegisterViewController+FrontPhoto.m
//  kupidum
//
//  Created by Albert Nadal Garriga on 24/11/12.
//  Copyright (c) 2012 laFruitera.com. All rights reserved.
//

#import "RegisterViewController+AliasPasswordEmail.h"

#define AVATAR_QUALITY  0.75;

@implementation RegisterViewController (AliasPasswordEmail)

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:	//Escollir una foto del carret
                [self takePhoto:UIImagePickerControllerSourceTypePhotoLibrary];
                break;

        case 1: //Fer una foto amb la càmara
                [self takePhoto:UIImagePickerControllerSourceTypeCamera];
                break;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
	float photo_quality = AVATAR_QUALITY;
	photoImatge = [[UIImage alloc] initWithData:UIImageJPEGRepresentation(image, photo_quality)];
	[[picker parentViewController] dismissModalViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];

    [photo setImage:photoImatge];
}

- (void)takePhoto:(UIImagePickerControllerSourceType)sourceType
{
	if(photoPicker == nil)
	{
		photoPicker = [[UIImagePickerController alloc] init];
        [photoPicker setAllowsEditing:YES];
        [photoPicker setDelegate:self];
	}

    photoPicker.sourceType = sourceType;

	UIImageView *img_prova = [[UIImageView alloc] initWithFrame:CGRectMake(0, 58, 320, 320)];
	[img_prova setImage:[UIImage imageNamed:@"perfil_ampolla_foto.png"]];

	[photoPicker.view addSubview:img_prova];
    [self presentViewController:photoPicker animated:YES completion:nil];
}

- (IBAction)choosePhoto
{
	UIActionSheet *successActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                    delegate:self
                                                           cancelButtonTitle:NSLocalizedString(@"Cancel·lar", @"")
                                                      destructiveButtonTitle:nil
                                                           otherButtonTitles:NSLocalizedString(@"Escollir foto del carret", @""), NSLocalizedString(@"Fer una nova foto", @""), nil];
	[successActionSheet setOpaque:NO];
	[successActionSheet showInView:self.view];
	[successActionSheet showFromToolbar:[[self navigationController] toolbar]];
}

@end
