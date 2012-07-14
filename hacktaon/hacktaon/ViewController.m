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
    [_loginTextField release];
    _loginTextField = nil;
    [_passwordTextField release];
    _passwordTextField = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)getAlbumsTouchUpInside:(id)sender {
    [[DataManager sharedManager] setUserName:_loginTextField.text andPassword:_passwordTextField.text];
    [self performSegueWithIdentifier:@"showAlbumList" sender:self];
}

- (IBAction)getPhotosTouchUpInside:(id)sender {
//    [[DataManager sharedManager] getPhotosFromAlbumAtIndex:0];
    
}

- (void)dealloc {
    [_loginTextField release];
    [_passwordTextField release];
    [super dealloc];
}
@end
