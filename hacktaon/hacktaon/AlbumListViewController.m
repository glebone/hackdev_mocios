//
//  AlbumListViewController.m
//  hacktaon
//
//  Created by Pavlo Nadolinskyi on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AlbumListViewController.h"
#import "DataManager.h"
#import "Constants.h"

#import "GData.h"
#import "GDataFeedPhotoAlbum.h"
#import "GDataFeedPhoto.h"

#import "AlbumListCell.h"
#import "UploadViewController.h"

@interface AlbumListViewController ()
{
    NSArray *_albums;
    NSMutableDictionary *_thumbs;
}

@end

@implementation AlbumListViewController 
@synthesize albums = _albums;
@synthesize localGallery, networkGallery, localCaptions, localImages, networkImages, networkCaptions;

- (void)dealloc {
    [_tableView release];
    [_albums release];
    [_thumbs release];
    [_activityIndicatorView release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateThumbnails:) name:NOTIFICATION_THUMBNAIL_UPDATE_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(convertionEnded:) name:NOTIFICATION_CONVERTION_ENDED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onExtractedLinks:) name:@"GlinksExtracted" object:nil];
//    [[DataManager sharedManager] getAlbumList];
}


- (int)numberOfPhotosForPhotoGallery:(FGalleryViewController *)gallery
{
    int num;
    if( gallery == localGallery ) {
        num = [localImages count];
    }
    else if( gallery == networkGallery ) {
        num = [networkImages count];
    }
	return num;
}


- (FGalleryPhotoSourceType)photoGallery:(FGalleryViewController *)gallery sourceTypeForPhotoAtIndex:(NSUInteger)index
{
	if( gallery == localGallery ) {
		return FGalleryPhotoSourceTypeLocal;
	}
	else return FGalleryPhotoSourceTypeNetwork;
}


- (NSString*)photoGallery:(FGalleryViewController *)gallery captionForPhotoAtIndex:(NSUInteger)index
{
    NSString *caption;
    if( gallery == localGallery ) {
        caption = [localCaptions objectAtIndex:index];
    }
    else if( gallery == networkGallery ) {
        caption = [networkCaptions objectAtIndex:index];
    }
	return caption;
}


- (NSString*)photoGallery:(FGalleryViewController*)gallery filePathForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index {
    return [localImages objectAtIndex:index];
}

- (NSString*)photoGallery:(FGalleryViewController *)gallery urlForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index {
    return [networkImages objectAtIndex:index];
}










- (void)viewDidUnload
{
    [_tableView release];
    _tableView = nil;
    [_activityIndicatorView release];
    _activityIndicatorView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [_albums count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"albumCellIdentifier";
    AlbumListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    GDataEntryPhotoAlbum *album = [_albums objectAtIndex:indexPath.row];
    GDataTextConstruct *titleTextConstruct = [album title];
    GDataMediaDescription *description = [[album mediaGroup] mediaDescription];
    cell.descriptionLabel.text = [description contentStringValue];
    
    NSString *title = [titleTextConstruct stringValue];
    cell.titleLabel.text = title;
    
    NSArray *thumbnails = [[album mediaGroup] mediaThumbnails];
    if ([thumbnails count] <= 0) return cell;
    GDataMediaThumbnail *t = [thumbnails objectAtIndex:0];
    UIImage *img = [_thumbs objectForKey:t.URLString];
    cell.thumbnailImageView.image = img;
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _activityIndicatorView.hidden = NO;
    [[DataManager sharedManager] getPhotosFromAlbumAtIndex:indexPath.row];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

}

- (void)albumListFetchOk:(NSNotification *)notification
{
    NSDictionary *d = [notification object];
    if (![d isKindOfClass:[NSDictionary class]]) return;

    [_albums release];
    GDataFeedPhotoUser *album = [d objectForKey:ALBUMS_KEY];
    _albums = [[album entries] copy];
    
    [_tableView reloadData];
}

- (void)requestFailure:(NSNotification *)notification
{
    NSString *d = [notification object];
    if (![d isKindOfClass:[NSString class]]) return;
}


- (void)handleTrashButtonTouch:(id)sender {
    _activityIndicatorView.hidden = NO;
    
    [self.networkGallery endSession];
    //dissmiss modalViewController
    //starting to convert caf to mp3
    
    NSLog(@"Stopped");
}




- (void) onExtractedLinks:(NSNotification *)n
{
    _activityIndicatorView.hidden = YES;
    NSLog(@"Extracted links");
    NSMutableArray *tmpImages = [[NSMutableArray alloc] initWithObjects:nil];
    for (id curObj in [[DataManager sharedManager] photoLinks])
    {
        [tmpImages addObject:[NSString stringWithFormat:@"%@",curObj]];
    }
    NSLog(@"%@", tmpImages);
    self.networkImages = [[NSArray alloc] initWithArray:tmpImages]; 
    self.networkCaptions = [[DataManager sharedManager] photoLinks];
    NSLog(@"%@", self.networkImages);

    self.localCaptions = [[NSArray alloc] initWithObjects:@"Lava", @"Hawaii", @"Audi", @"Happy New Year!",@"Frosty Web",nil];
    self.localImages = [[NSArray alloc] initWithObjects: @"lava.jpeg", @"hawaii.jpeg", @"audi.jpg",nil];
   
    [tmpImages release];
    
    self.networkCaptions = self.networkImages;
    //self.networkImages = [[NSArray alloc] initWithObjects:@"https://lh3.googleusercontent.com/-rGXkEbSEJCk/Tto1pbCnX7I/AAAAAAAAA-w/eAo5neHNm1w/2011-12-03-203900.jpg", @"https://lh5.googleusercontent.com/-Pl6GVB4AMjE/Tto1t-wLFaI/AAAAAAAAA-M/4RpdZbdVMS0/2011-12-03-203942.jpg",nil];
    
    NSLog(@"%@", self.networkImages);
   
    
    UIImage *trashIcon = [UIImage imageNamed:@"photo-gallery-trashcan.png"];
    UIImage *captionIcon = [UIImage imageNamed:@"photo-gallery-edit-caption.png"];
    UIBarButtonItem *trashButton = [[[UIBarButtonItem alloc] initWithImage:trashIcon style:UIBarButtonItemStylePlain target:self action:@selector(handleTrashButtonTouch:)] autorelease];
    UIBarButtonItem *editCaptionButton = [[[UIBarButtonItem alloc] initWithImage:captionIcon style:UIBarButtonItemStylePlain target:self action:@selector(handleEditCaptionButtonTouch:)] autorelease];
    NSArray *barItems = [NSArray arrayWithObjects:editCaptionButton, trashButton, nil];
    

    
    
    self.networkGallery = [[FGalleryViewController alloc] initWithPhotoSource:self barItems:barItems];
    
    
    
    
    [self presentModalViewController:self.networkGallery animated:YES];

    //[self.navigationController pushViewController:networkGallery animated:YES];
    [networkGallery release]; 
}

- (void)updateThumbnails:(NSNotification *)notification
{
    NSDictionary *d = [notification object];
    if (![d isKindOfClass:[NSDictionary class]]) return;
    
    NSMutableDictionary *thumbs = [d objectForKey:THUMBNAILS_KEY];
    [_thumbs release];
    _thumbs = [thumbs copy];
    
    [_tableView reloadData];
}

- (void)convertionEnded:(NSNotification *)notification
{
    _activityIndicatorView.hidden = YES;
    
    UploadViewController *u = [[self storyboard] instantiateViewControllerWithIdentifier:@"UploadViewController"];
    [self presentModalViewController:u animated:YES];
}

@end
