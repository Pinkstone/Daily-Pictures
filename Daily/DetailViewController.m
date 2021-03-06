//
//  DetailViewController.m
//  Daily Pictures
//
//  Created by Jay Versluis on 06/01/2014.
//  Copyright (c) 2014 Pinkstone Pictures LLC. All rights reserved. http://pinkstonepictures.com
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

#import "DetailViewController.h"
#import "Event.h"
#import "EditDateViewController.h"

@interface DetailViewController ()

@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *uploadButton;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *shareThisButton;

- (void)configureView;
- (IBAction)uploadImage:(id)sender;
- (IBAction)shareThisPressed:(id)sender;


@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)setDetailEvent:(Event *)detailEvent {
    
    if (!_detailEvent) {
        _detailEvent = detailEvent;
        
        // Update the view
        [self configureView];
    }
    
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    self.title = [self grabEventDate];
    self.imageView.image = [UIImage imageWithData:self.detailEvent.picture];
    self.titleLabel.text = self.detailEvent.title;
    
    // hide and disable Share This button when we have no picture
    if (!self.detailEvent.picture) {
        self.shareThisButton.hidden = YES;
        self.shareThisButton.enabled = NO;
    } else {
        self.shareThisButton.hidden = NO;
        self.shareThisButton.enabled = YES;
    }
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_5_1) {
        // iOS 5 users can only save to Camera Roll
        [self.shareThisButton setTitle:@"Save to Camera Roll" forState:UIControlStateNormal];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    // update title with potential new date
    self.title = [self grabEventDate];
    self.titleLabel.text = self.detailEvent.title;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        
        // back button pressed, let's tell our delegate
        if (!self.detailEvent.picture) {
            // delete the event because we dont' have a picture
            [self.delegate detailViewDelete:self.detailEvent];
        } else {
            [self.delegate detailViewDidSave:self.detailItem];
        }
    }
    [super viewWillDisappear:animated];
}

- (NSString *)grabEventDate {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.timeStyle = NSDateFormatterNoStyle;
    formatter.dateStyle = NSDateFormatterMediumStyle;
    
    return [formatter stringFromDate:self.detailEvent.timeStamp];
}

#pragma mark - Image Picker

- (IBAction)uploadImage:(id)sender {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.allowsEditing = NO;
    imagePicker.delegate = self;
    
    [self presentModalViewController:imagePicker animated:YES];
    
}

- (IBAction)shareThisPressed:(id)sender {
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_5_1) {
        
        // share to Camera Roll (iOS 5)
        UIImage *image = [UIImage imageWithData:self.detailEvent.picture];
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        
    } else {
        
        // bring up a UIActivityViewController (iOS 6 and higher)
        NSArray *items = @[[UIImage imageWithData:self.detailEvent.picture]];
        UIActivityViewController *controller = [[UIActivityViewController alloc]initWithActivityItems:items applicationActivities:nil];
        
        [self presentViewController:controller animated:YES completion:nil];
        
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    // called when the image was saved to the camera roll (iOS 5 only)
    if (error.localizedDescription == NULL) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Your image was saved to the Camera Roll." delegate:self cancelButtonTitle:@"Thanks!" otherButtonTitles:nil, nil];
        [alertView show];
    
    } else {
        
        // display error message
        NSString *errorMessage = [NSString stringWithFormat:@"The image could not be saved today. %@.", error.localizedDescription];
        UIAlertView *errorView = [[UIAlertView alloc]initWithTitle:@"Houston, we have a problem!" message:errorMessage delegate:self cancelButtonTitle:@"I'll try later" otherButtonTitles:nil, nil];
        [errorView show];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [self dismissModalViewControllerAnimated:YES];
    UIImage *chosenImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.imageView.image = chosenImage;
    
    // add the image the current event
    self.detailEvent.picture = UIImageJPEGRepresentation(chosenImage, 1);
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"editDate"]) {
        
        EditDateViewController *controller = [[EditDateViewController alloc]init];
        controller = segue.destinationViewController;
        controller.editEvent = self.detailEvent;
    }
}

@end
