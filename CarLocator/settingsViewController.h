//
//  settingsViewController.h
//  CarLocator
//
//  Created by PPTS on 25/06/14.
//  Copyright (c) 2014 ppts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@interface settingsViewController : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate>


{
    IBOutlet UILabel *sourceAreaText;
     IBOutlet UILabel *destinationAreaText;
     IBOutlet UILabel *sourceLatText;
    IBOutlet UILabel *sourceLongText;
     IBOutlet UILabel *destinationLatText;
     IBOutlet UILabel *destinationLongText;
}

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic, strong) NSString *sourceArea;
@property (nonatomic, strong) NSString *destinationArea;
@property (nonatomic, strong) NSString *sourceLat;
@property (nonatomic, strong) NSString *sourceLong;
@property (nonatomic, strong) NSString *destinationLat;
@property (nonatomic, strong) NSString *destinationLong;
@property (nonatomic, strong) NSString *uniqueId;


@end
