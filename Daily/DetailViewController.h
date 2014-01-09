//
//  DetailViewController.h
//  Daily
//
//  Created by Jay Versluis on 06/01/2014.
//  Copyright (c) 2014 Pinkstone Pictures LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@protocol DetailViewDelegate;
@interface DetailViewController : UIViewController <UISplitViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) Event *detailEvent;
@property (weak) id <DetailViewDelegate> delegate;

@end

@protocol DetailViewDelegate

- (void)detailViewDidSave:(Event *)event;
- (void)detailViewDelete:(Event *)event;

@end
