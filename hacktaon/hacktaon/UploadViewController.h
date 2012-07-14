//
//  UploadViewController.h
//  hacktaon
//
//  Created by Pavlo Nadolinskyi on 7/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UploadViewController : UIViewController
{
    IBOutlet UIView *_activityIndicatorView;
}
- (IBAction)uploadTouchUpInside:(id)sender;
- (IBAction)dissmissTouchUpInside:(id)sender;

@end
