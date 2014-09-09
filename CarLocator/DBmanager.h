//
//  DBmanager.h
//  CarLocator
//
//  Created by PPTS on 14/07/14.
//  Copyright (c) 2014 ppts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBmanager : NSObject


{
    NSString *databasePath;
}

+(DBmanager*)getSharedInstance;
-(BOOL)createDB;
-(NSString *) saveLocation:(NSString*)dateChange areaLocation:(NSString*)areaAddr lati:(NSString*)latitudeAddr
               longi:(NSString*)longitudeAddr;

-(BOOL) findSaveLocation:(NSString*)sourceDateChange sourceAreaLocation:(NSString*)SourceAreaAddr sourceLati:(NSString*)sourceLatitudeAddr
             sourceLongi:(NSString*)sourceLongitudeAddr;



- (BOOL)findByDelete: ( NSString * )value;

- (BOOL) updateLocation:(NSString*)dateChange areaLocation:(NSString*)areaAddr lati:(NSString*)latitudeAddr
                  longi:(NSString*)longitudeAddr;

-(NSMutableArray*)findByDate:(NSString*)dateChange;
//-(NSMutableArray*)findByDateId;
-(NSString *) findByDateId;
@property (nonatomic, retain) NSMutableArray *reminders;

@end
