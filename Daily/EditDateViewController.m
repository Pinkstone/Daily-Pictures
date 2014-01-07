//
//  EditDateViewController.m
//  Daily
//
//  Created by Jay Versluis on 06/01/2014.
//  Copyright (c) 2014 Pinkstone Pictures LLC. All rights reserved.
//

#import "EditDateViewController.h"

@interface EditDateViewController ()

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)changeDate:(id)sender;


@end

@implementation EditDateViewController

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
    self.datePicker.date = self.editEvent.timeStamp;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    // before we leave, save object (if necessary)
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)changeDate:(id)sender {
    
    self.editEvent.timeStamp = self.datePicker.date;
}
@end