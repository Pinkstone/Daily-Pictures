//
//  EditDateViewController.m
//  Daily
//
//  Created by Jay Versluis on 06/01/2014.
//  Copyright (c) 2014 Pinkstone Pictures LLC. All rights reserved.
//

/* 
    This file is part of Daily Pictures.

    This programme is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This programme is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Daily Pictures.  If not, see <http://www.gnu.org/licenses/>.
*/

#import "EditDateViewController.h"

@interface EditDateViewController ()

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UITextField *textField;

- (IBAction)changeDate:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;


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
    if (self.editEvent.title) {
        self.textField.text = self.editEvent.title;
    }
    
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

- (IBAction)dismissKeyboard:(id)sender {
    
    [self.textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.textField resignFirstResponder];
    self.editEvent.title = self.textField.text;
    
    return YES;
}

@end
