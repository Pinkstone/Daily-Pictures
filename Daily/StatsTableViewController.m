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

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    NSInteger daysLeft = [daysLeftComponents day]+1;
    NSString *picturesLeft = [NSString stringWithFormat:@"%ld", (long)daysLeft];
    self.picturesLeftLabel.text = picturesLeft;
    
    // log file size
    NSPersistentStore *store = [[self.fetchedResultsController.managedObjectContext.persistentStoreCoordinator persistentStores]objectAtIndex:0];
    NSURL *cloudLog = [[store options]objectForKey:NSPersistentStoreUbiquitousContentURLKey];
    NSString *cloudLogFilename = [[store options]objectForKey:NSPersistentStoreUbiquitousContentNameKey];
    cloudLog = [cloudLog URLByAppendingPathComponent:cloudLogFilename];
    NSString *cloudLogPath = [cloudLog path];
    
    unsigned long long logFileSize = [[[NSFileManager defaultManager]attributesOfItemAtPath:cloudLogPath error:NULL]fileSize];
    NSString *logSize = [NSString stringWithFormat:@"%llu", logFileSize];
    
    self.logFileSizeLabel.text = logSize;
    
    // store size / Core Data usage
    NSString *storePath = [store.URL path];
    unsigned long long storeSize = [[[NSFileManager defaultManager]attributesOfItemAtPath:storePath error:nil]fileSize];
    NSString *storeSizeLabel = [NSString stringWithFormat:@"%llu", storeSize];
    
    if (floor(NSFoundationVersionNumber) >= NSFoundationVersionNumber_iOS_6_0) {
        // format the result
        NSByteCountFormatter *formatter = [[NSByteCountFormatter alloc]init];
        storeSizeLabel = [formatter stringFromByteCount:storeSize];
    } else {
        // format the results the old fashioned way
        float sizeMB = storeSize / 1024 / 1024;
        if (sizeMB == 0) {
            sizeMB = storeSize / 1024;
            storeSizeLabel = [NSString stringWithFormat:@"%d KB", (int)sizeMB];
        } else {
            
            storeSizeLabel = [NSString stringWithFormat:@"%d MB", (int)sizeMB];
        }
    }

    self.iCloudSizeLabel.text = storeSizeLabel;
    
}

- (IBAction)dismissButton:(id)sender {
    
    [self dismissModalViewControllerAnimated:YES];
}
@end
