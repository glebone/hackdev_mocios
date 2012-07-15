//
//  UploadViewController.m
//  hacktaon
//
//  Created by Pavlo Nadolinskyi on 7/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UploadViewController.h"
#import "Constants.h"

@interface UploadViewController ()

@end

@implementation UploadViewController

@synthesize curShowCase;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadSuccess:) name:NOTIFICATION_UPLOAD_COMMENTS_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadFailure:) name:NOTIFICATION_UPLOAD_COMMENTS_FAILURE object:nil];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_activityIndicatorView release];
    _activityIndicatorView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)uploadTouchUpInside:(id)sender {
    NSLog(@"Uploading...");
    [self.curShowCase uploadMedia];
}

- (IBAction)dissmissTouchUpInside:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
- (void)dealloc {
    [_activityIndicatorView release];
    [super dealloc];
}

- (void)uploadSuccess:(NSNotification *)notification
{
}
- (void)uploadFailure:(NSNotification *)notification
{
}
@end
