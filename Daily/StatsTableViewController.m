//
//  StatsTableViewController.m
//  Daily
//
//  Created by Jay Versluis on 07/01/2014.
//  Copyright (c) 2014 Pinkstone Pictures LLC. All rights reserved.
//

#import "StatsTableViewController.h"

@interface StatsTableViewController ()

// statistics section
@property (strong, nonatomic) IBOutlet UILabel *picturesTakenLabel;
@property (strong, nonatomic) IBOutlet UILabel *picturesLeftLabel;
@property (strong, nonatomic) IBOutlet UILabel *logFileSizeLabel;
@property (strong, nonatomic) IBOutlet UILabel *iCloudSizeLabel;

// about section
@property (strong, nonatomic) IBOutlet UILabel *versionLabel;
@property (strong, nonatomic) IBOutlet UILabel *buildLabel;
- (IBAction)dismissButton:(id)sender;

@end

@implementation StatsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self displayVersion];
    [self displayStatistics];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)displayVersion {
    
    // set version and build fields from bundle
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    // display in your own labels
    self.versionLabel.text = version;
    self.buildLabel.text = build;
}

- (void)displayStatistics {
    
    // number of pictures
    int numberOfPictures = (int)self.fetchedResultsController.fetchedObjects.count;
    NSString *picturesLabel = [NSString stringWithFormat:@"%i", numberOfPictures];
    self.picturesTakenLabel.text = picturesLabel;
    
    // pictures left to take this year
    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSYearCalendarUnit fromDate:today];
    [components setDay:31];
    [components setMonth:12];
    NSDate *newYearsEve = [gregorian dateFromComponents:components];
    NSDateComponents *daysLeftComponents = [gregorian components:NSDayCalendarUnit fromDate:today toDate:newYearsEve options:0];
    NSInteger daysLeft = [daysLeftComponents day];
    NSString *picturesLeft = [NSString stringWithFormat:@"%ld", (long)daysLeft];
    self.picturesLeftLabel.text = picturesLeft;
    
}

- (IBAction)dismissButton:(id)sender {
    
    [self dismissModalViewControllerAnimated:YES];
}
@end
