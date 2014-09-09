//
//  reportView.m
//  CarLocator
//
//  Created by PPTS on 14/07/14.
//  Copyright (c) 2014 ppts. All rights reserved.
//

#import "reportView.h"

@implementation reportView


@synthesize carArea, carLatitude, carLongitude, uniqueId, carDate, sourceDate, sourceArea, sourceLati, sourceLongi;

-(void)dealloc
{
    self.carArea = nil;
    self.carLatitude = nil;
    self.carLongitude = nil;
     self.uniqueId = nil;
    self.carDate = nil;
    self.sourceDate = nil;
    self.sourceArea = nil;
    self.sourceLati = nil;
    self.sourceLongi = nil;
}


@end
