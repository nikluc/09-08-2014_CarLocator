//
//  DBmanager.m
//  CarLocator
//
//  Created by PPTS on 14/07/14.
//  Copyright (c) 2014 ppts. All rights reserved.
//


#import "DBManager.h"
#import "reportView.h"


NSString *carId;

static DBmanager *sharedInstance = nil;
static sqlite3 *database = nil;


@implementation DBmanager
@synthesize reminders;
+(DBmanager*)getSharedInstance{
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance createDB];
    }
    return sharedInstance;
}

-(BOOL)createDB{
    NSString *docsDir;
    NSArray *dirPaths;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString:
                    [docsDir stringByAppendingPathComponent: @"carLocator.db"]];
    BOOL isSuccess = YES;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt ="create table if not exists parkingLocations (_id INTEGER PRIMARY KEY AUTOINCREMENT, spotdateid text, spotAddr text, spotLat text, spotLong text, sourcedateid text, sourceAddr text, sourceLat text, sourceLong text)";
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to create table");
            }
            sqlite3_close(database);
            return  isSuccess;
        }
        else {
            isSuccess = NO;
            NSLog(@"Failed to open/create database");
        }
    }
    return isSuccess;
}




-(NSString*) saveLocation:(NSString*)dateChange areaLocation:(NSString*)areaAddr lati:(NSString*)latitudeAddr
               longi:(NSString*)longitudeAddr;
{
    NSString *rowId ;
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"insert into parkingLocations (spotdateid, spotAddr, spotLat, spotLong) values (\"%@\", \"%@\", \"%@\", \"%@\")", dateChange, areaAddr, latitudeAddr, longitudeAddr];
        
        NSLog(@"insertion of destination %@",insertSQL);
        
        
                                const char *insert_stmt = [insertSQL UTF8String];
                                sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
                                if (sqlite3_step(statement) == SQLITE_DONE)
                                {
                                    long long lastRowId = sqlite3_last_insert_rowid(database);
                                    
                                    rowId = [NSString stringWithFormat:@"%d",(int)lastRowId];
                                
                                    
                                    return rowId;
                                }
                                else {
                                    return rowId;
                                }
                                sqlite3_finalize(statement);
                                sqlite3_reset(statement);
                                }
                                return rowId;
                                }



-(BOOL) findSaveLocation:(NSString*)sourceDateChange sourceAreaLocation:(NSString*)SourceAreaAddr sourceLati:(NSString*)sourceLatitudeAddr
               sourceLongi:(NSString*)sourceLongitudeAddr;
{
    sqlite3_stmt *statementFind;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"UPDATE  parkingLocations SET sourcedateid=\"%@\", sourceAddr=\"%@\", sourceLat=\"%@\", sourceLong=\"%@\" WHERE _id=(select MAX(_id) from  parkingLocations)", sourceDateChange, SourceAreaAddr, sourceLatitudeAddr, sourceLongitudeAddr];
  
        NSLog(@"SDFGJSJGJG%@",insertSQL);
        
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statementFind, NULL);
        if (sqlite3_step(statementFind) == SQLITE_DONE)
        {
            return YES;
        }
        else {
            return NO;
        }
        sqlite3_finalize(statementFind);
        sqlite3_reset(statementFind);
    }
    return NO;
}

- (BOOL)findByDelete: ( NSString * )value;
{
   // NSMutableArray* tmpArray;
    
    
    int aValue = [[value stringByReplacingOccurrencesOfString:@" " withString:@""] intValue];
    NSLog(@"%d", aValue);
    
    
    
    
    
    BOOL success= NO;
    NSString *deleteValue;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
     
        sqlite3_stmt *statement;
       deleteValue = [NSString stringWithFormat:@"DELETE FROM parkingLocations WHERE _id=%d",aValue];
        NSLog(@"delete query  %@",deleteValue);
        const char *del_stmt = [deleteValue UTF8String];
        sqlite3_prepare_v2(database, del_stmt,-1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
  //  tmpArray = [[deleteValue propertyList] mutableCopy];
            
            success=YES;
  
            
        }
       
        sqlite3_reset(statement);
        sqlite3_finalize(statement);
        
    }
    NSLog(@"sucessssss %hhd",success);
    return success;
}



- (BOOL) updateLocation:(NSString*)dateChange areaLocation:(NSString*)areaAddr lati:(NSString*)latitudeAddr longi:(NSString*)longitudeAddr
                 ;


{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *alertSuccess2 = @"Location Updation successful";
        NSString *alertFields2 = @"Location Updation Failed";
        sqlite3_stmt *statement;
        
        NSString *insertSQL = [NSString stringWithFormat:@"UPDATE parkingLocations SET spotdateid=\"%@\", spotAddr=\"%@\", spotLat=\"%@\", spotLong=\"%@\" WHERE _id=(select MAX(_id) from  parkingLocations)", dateChange, areaAddr, latitudeAddr, longitudeAddr];
        NSLog(@"updation query  %@",insertSQL);
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            
            UIAlertView *alertupdate1 = [[UIAlertView alloc]initWithTitle:alertSuccess2 message:@"Location updated" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertupdate1 show];        }
        else {
            
            UIAlertView *alertupdate2 = [[UIAlertView alloc]initWithTitle:alertFields2 message:@"Updation failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertupdate2 show];
            
        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);
        
    }
    return NO;
}



-(NSString *) findByDateId;

{
    NSString *stringLat = nil;
    NSString *stringLong = nil;
    
    
    NSMutableString *concatenateStrings;
    NSString *depositQuery  = [NSString stringWithFormat:
                               @"select spotLat, spotLong from parkingLocations WHERE _id = (select MAX(_id) from  parkingLocations)"] ;
    
    const char *dbpath_retrieve = [databasePath UTF8String];
    if(sqlite3_open(dbpath_retrieve, &database) == SQLITE_OK)
    {
        
        sqlite3_stmt *satatement_retrieve;
        if (sqlite3_prepare_v2(database, [depositQuery UTF8String], -1, &satatement_retrieve, nil)==SQLITE_OK)
        {
            if (sqlite3_step(satatement_retrieve)==SQLITE_ROW)
            {
                
                char* valsReturnLat = (char*) sqlite3_column_text(satatement_retrieve, 0);
               
                
              if (valsReturnLat != NULL )  {
                    stringLat =  [NSString stringWithUTF8String:valsReturnLat];
                
             
                    NSLog(@"yes : %@" ,stringLat);
               }
                
                
                char* valsReturnLong = (char*) sqlite3_column_text(satatement_retrieve, 1);
              if (valsReturnLong != NULL )  {
                    stringLong = [NSString stringWithUTF8String:valsReturnLong];
                    NSLog(@"yes : %@" ,stringLong);
              }
                
               concatenateStrings = [NSMutableString stringWithString:stringLat];
             //   [concatenateStrings appendString:stringLong];
                [concatenateStrings appendFormat:@",%@", stringLong];
                
            }
            else
            {
                NSLog(@"Error in Retrieve : '%s'",sqlite3_errmsg(database));
            }
            sqlite3_reset(satatement_retrieve);
            sqlite3_finalize(satatement_retrieve);
            
            
        }
        // sqlite3_close(database);
    }
    
    return concatenateStrings;
}



-(NSMutableArray*)  findByDate:(NSString*)dateChange;
        {
            self.reminders	= nil;
            self.reminders = [[NSMutableArray alloc] init];
            
           
            
            const char *dbpath = [databasePath UTF8String];
            
            reportView *reportRemainder;
            if (sqlite3_open(dbpath, &database) == SQLITE_OK)
            {
                 sqlite3_stmt *statement_history;
                NSString *historySQL = [NSString stringWithFormat:
                                      @"select _id, spotdateid, spotAddr, spotLat, spotLong, sourcedateid, sourceAddr, sourceLat, sourceLong from parkingLocations where spotdateid=\"%@\"",dateChange];
                NSLog(@"select query  %@",historySQL);
                
                const char *query_stmt = [historySQL UTF8String];
              
                NSInteger retVals =sqlite3_prepare_v2(database, query_stmt, -1, &statement_history, NULL);
                
                if ( retVals== SQLITE_OK)
                {
                    NSLog(@"inside ifffff");
                    while(sqlite3_step(statement_history) == SQLITE_ROW)
                    {
                       
                        
                         NSLog(@"inside whileeeeee");
                        reportRemainder = [[reportView alloc] init];

                        
                         
                        
                        
                        
                        
                        NSString *carId = [[NSString alloc] initWithUTF8String:(const char *)
                                                sqlite3_column_text(statement_history, 0)];
                        
                        NSLog(@"car id number %@",carId);
                      
                        reportRemainder.uniqueId = carId;
                        NSLog(@"uniqueeee iddddd %@",reportRemainder.uniqueId);
                        
                        
                        NSString *carDate = [[NSString alloc] initWithUTF8String:(const char *)
                                            sqlite3_column_text(statement_history, 1)];
                     
                         reportRemainder.carDate = carDate;
                      
                       
                        
                        NSString *carAddr = [[NSString alloc] initWithUTF8String:(const char *)
                                            sqlite3_column_text(statement_history, 2)];
                       
                        reportRemainder.carArea = carAddr;
                        
                        NSString *carLat = [[NSString alloc] initWithUTF8String:(const char *)
                                             sqlite3_column_text(statement_history, 3)];
                       
                        reportRemainder.carLatitude = carLat;
                        NSLog(@"car latitude %@",carLat);
                        
                        NSString *carLong = [[NSString alloc] initWithUTF8String:(const char *)
                                            sqlite3_column_text(statement_history, 4)];
                       
                         reportRemainder.carLongitude = carLong;
                        
                        
                        
                        NSString *carSourceDate ;
                       char *tmp = sqlite3_column_text(statement_history, 5);
                        if (tmp == NULL){
                            carSourceDate = nil;
                        }
                        else{
                            carSourceDate = [[NSString alloc] initWithUTF8String:tmp];

                        reportRemainder.sourceDate = carSourceDate;
                        }
                        
                        
                        NSString *carSourceAddr;
                      char *tmp1 = sqlite3_column_text(statement_history, 6);
                                  NSLog(@"car lsource addr %@",carSourceAddr);
                        if (tmp1 ==NULL) {
                            carSourceAddr = nil;
                        }
                        else{
                              carSourceAddr = [[NSString alloc] initWithUTF8String:tmp1];
                        reportRemainder.sourceArea = carSourceAddr;
                        }
                        
                         NSLog(@"source addr%@",carSourceAddr);
                        
                        
                        
                        NSString *carSourceLat;
                      char *tmp2= sqlite3_column_text(statement_history, 7);
                        if (tmp2==NULL) {
                            carSourceLat = nil;
                        }
                        else{
                            carSourceLat = [[NSString alloc] initWithUTF8String:tmp2];

                     
                        reportRemainder.sourceLati = carSourceLat;
                        }
                        NSLog(@"source latitude%@",carSourceLat);
                        
                        NSString *carSourceLong ;
                      char *tmp3= sqlite3_column_text(statement_history, 8);
                        if (tmp3==NULL) {
                            carSourceLong = nil;
                        }
                        else{
                            
                            carSourceLong = [[NSString alloc] initWithUTF8String:tmp3];

                        reportRemainder.sourceLongi = carSourceLong;
                        
                        } NSLog(@"source longitude%@",carSourceLong);
                        
                        [reminders addObject:reportRemainder];
                            
                       
                        
                    } sqlite3_finalize(statement_history);
                }
                else{
                        NSLog(@"Not found");
                    return nil;
                }
                statement_history = nil;
            }
            return reminders;
        }







@end
