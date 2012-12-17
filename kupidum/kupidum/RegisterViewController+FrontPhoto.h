//
//  RegisterViewController+FrontPhoto.h
//  kupidum
//
//  Created by Albert Nadal Garriga on 24/11/12.
//  Copyright (c) 2012 laFruitera.com. All rights reserved.
//

#import "RegisterViewController.h"
#import "Base64.h"

@interface RegisterViewController (AliasPasswordEmail)
{

}

- (IBAction)choosePhoto;
- (void)takePhoto:(UIImagePickerControllerSourceType)sourceType;

@end
