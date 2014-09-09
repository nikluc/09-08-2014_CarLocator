//
//  tapViewController.h
//  CarLocator
//
//  Created by PPTS on 25/06/14.
//  Copyright (c) 2014 ppts. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "DBManager.h"



@interface tapViewController : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate>


{
  NSMutableArray *data;
    
    IBOutlet UILabel *areaLabel;
    IBOutlet UILabel *latitudeLabel;
    IBOutlet UILabel *longitudeLabel;
    
    IBOutlet UITextField *dateChange;
    IBOutlet UIDatePicker *datePicker;
}

- (IBAction)saveLocation:(id)sender;



-(IBAction)pickerDateChanged:(UIDatePicker *)sender;



@property (strong, nonatomic) IBOutlet MKMapView *mapView;


@end




