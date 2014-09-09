//
//  reportView.h
//  CarLocator
//
//  Created by PPTS on 14/07/14.
//  Copyright (c) 2014 ppts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBManager.h"

@interface reportView : NSObject

@property (nonatomic, copy) NSString *uniqueId;
@property (nonatomic, copy) NSString *carDate;
@property (nonatomic, copy) NSString *carArea;
@property (nonatomic, copy) NSString *carLatitude;
@property (nonatomic, copy) NSString *carLongitude;
@property (nonatomic, copy) NSString *sourceDate;
@property (nonatomic, copy) NSString *sourceArea;
@property (nonatomic, copy) NSString *sourceLati;
@property (nonatomic, copy) NSString *sourceLongi;



@end
