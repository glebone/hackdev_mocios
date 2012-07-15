//
//  AlbumListViewController.h
//  hacktaon
//
//  Created by Pavlo Nadolinskyi on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGalleryViewController.h"
#import "ShowCase.h"




@interface AlbumListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, FGalleryViewControllerDelegate>
{
    IBOutlet UITableView *_tableView;
    NSArray *localCaptions;
    NSArray *localImages;
    NSArray *networkImages;
    NSArray *networkCaptions;
	FGalleryViewController *localGallery;
    FGalleryViewController *networkGallery;
    IBOutlet UIView *_activityIndicatorView;
    NSString *curAlbumId;
    NSString *curAlbumName;
}


@property (nonatomic, retain) NSArray *albums;
@property  (nonatomic, retain) NSArray* localCaptions;
@property (nonatomic, retain) NSArray* localImages;
@property (nonatomic, retain) NSArray* networkImages;
@property (nonatomic, retain) NSArray *networkCaptions;

@property (nonatomic, retain) FGalleryViewController *localGallery;
@property (nonatomic, retain) FGalleryViewController *networkGallery;

@property (nonatomic, retain) NSString *curAlbumId;
@property (nonatomic, retain) NSString *curAlbumName;


- (void) onExtractedLinks:(NSNotification *)n;
- (void)handleTrashButtonTouch:(id)sender;
- (void) cropAlbums;

@end
