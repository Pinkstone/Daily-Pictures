//
//  DailyValueTransformer.m
//  Daily
//
//  Created by Jay Versluis on 06/01/2014.
//  Copyright (c) 2014 Pinkstone Pictures LLC. All rights reserved.
//

#import "DailyValueTransformer.h"

@implementation DailyValueTransformer

+(BOOL)allowsReverseTransformation {
    
    return YES;
}

+(Class)transformedValueClass {
    
    return [NSData class];
}

- (id)transformedValue:(id)value {
    
    // turns the UIImage into data and returns it
    NSData *imageData = UIImagePNGRepresentation((UIImage *)value);
    return imageData;
    
}

- (id)reverseTransformedValue:(id)value {
    
    // takes data and returns it as a UIImage
    UIImage *image = [[UIImage alloc]initWithData:value];
    return image;
}

@end
