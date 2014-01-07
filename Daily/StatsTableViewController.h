//
//  StatsTableViewController.h
//  Daily
//
//  Created by Jay Versluis on 07/01/2014.
//  Copyright (c) 2014 Pinkstone Pictures LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreData;

@interface StatsTableViewController : UITableViewController

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end
