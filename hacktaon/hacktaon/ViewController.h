//
//  ViewController.h
//  hacktaon
//
//  Created by Pavlo Nadolinskyi on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    
    IBOutlet UITextField *_loginTextField;
    IBOutlet UITextField *_passwordTextField;
}

- (IBAction)getAlbumsTouchUpInside:(id)sender;
- (IBAction)getPhotosTouchUpInside:(id)sender;

@end
