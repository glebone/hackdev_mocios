//
//  ViewController.m
//  hacktaon
//
//  Created by Pavlo Nadolinskyi on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "DataManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)getAlbumsTouchUpInside:(id)sender {
    [[DataManager sharedManager] setUserName:@"dkann@ukr.net" andPassword:@"makito66"];
    [[DataManager sharedManager] getAlbumList];
}

- (IBAction)getPhotosTouchUpInside:(id)sender {
    [[DataManager sharedManager] fetchPhotosFromAlbumAtIndex:0];
}
@end
