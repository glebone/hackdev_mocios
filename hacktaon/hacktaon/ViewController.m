//
//  ViewController.m
//  hacktaon
//
//  Created by Pavlo Nadolinskyi on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "DataManager.h"
#import "Constants.h"

#import "AlbumListViewController.h"
#import "GData.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(albumListFetchOk:) name:NOTIFICATION_FETCH_ALBUM_LIST_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestFailure:) name:NOTIFICATION_REQUEST_ERROR object:nil];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_loginTextField release];
    _loginTextField = nil;
    [_passwordTextField release];
    _passwordTextField = nil;
    [_activityIndicatorView release];
    _activityIndicatorView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)getAlbumsTouchUpInside:(id)sender {
    [[DataManager sharedManager] setUserName:_loginTextField.text andPassword:_passwordTextField.text];
//    [self performSegueWithIdentifier:@"showAlbumList" sender:self];
    [[DataManager sharedManager] getAlbumList];
    _activityIndicatorView.hidden = NO;
}

- (IBAction)getPhotosTouchUpInside:(id)sender {
//    [[DataManager sharedManager] getPhotosFromAlbumAtIndex:0];
    
}

- (void)dealloc {
    [_loginTextField release];
    [_passwordTextField release];
    [_activityIndicatorView release];
    [super dealloc];
}

- (void)albumListFetchOk:(NSNotification *)notification
{
    _activityIndicatorView.hidden = YES;

    NSDictionary *d = [notification object];
    if (![d isKindOfClass:[NSDictionary class]]) return;
    
    GDataFeedPhotoUser *album = [d objectForKey:ALBUMS_KEY];
    NSArray *entries = [album entries];
    
    AlbumListViewController *a = [[self storyboard] instantiateViewControllerWithIdentifier:@"AlbumListViewController"];
    a.albums = entries;
    [self presentModalViewController:a animated:YES];
    
}

- (void)requestFailure:(NSNotification *)notification
{
    _activityIndicatorView.hidden = YES;

    NSDictionary *d = [notification object];
    if (![d isKindOfClass:[NSDictionary class]]) return;
    
    NSError *error = [d objectForKey:ERROR_KEY];
    NSString *errorDescription = [error.userInfo objectForKey:@"Error"];
    
    [[[[UIAlertView alloc] initWithTitle:@"Error" 
                                 message:errorDescription 
                                delegate:nil 
                       cancelButtonTitle:@"ok" 
                       otherButtonTitles: nil] autorelease] show];
    
}
@end
