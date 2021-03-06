//
//  DetailViewController.h
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
