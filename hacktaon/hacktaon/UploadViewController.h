//
//  UploadViewController.h
//  hacktaon
//
//  Created by Pavlo Nadolinskyi on 7/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ShowCase.h"



@interface UploadViewController : UIViewController
{
    IBOutlet UIView *_activityIndicatorView;
    ShowCase *curShowCase;
}

@property (nonatomic, retain) ShowCase *curShowCase;

- (IBAction)uploadTouchUpInside:(id)sender;
- (IBAction)dissmissTouchUpInside:(id)sender;

@end
