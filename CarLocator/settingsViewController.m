//
//  settingsViewController.m
//  CarLocator
//
//  Created by PPTS on 25/06/14.
//  Copyright (c) 2014 ppts. All rights reserved.
//

#import "settingsViewController.h"
#import "reportView.h"




@interface settingsViewController ()

@end

@implementation settingsViewController
@synthesize mapView, sourceArea,sourceLat,sourceLong,destinationArea,destinationLat,destinationLong,uniqueId;


double latitude;
double longitude;

MKPlacemark *destinationPlacemark;
MKMapItem *destination;
MKPlacemark *sourcePlacemark;
MKMapItem *source;
CLLocation *currentLocation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    sourceAreaText.text = sourceArea;
    sourceLatText.text = sourceLat;
    sourceLongText.text =sourceLong;
    destinationAreaText.text =destinationArea ;
    destinationLatText.text =destinationLat;
    destinationLongText.text =destinationLong;

    
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    
   
mapView:nil;
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
   
    self.mapView.delegate = self;
 [self sourceAndDestination];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}








-(void)sourceAndDestination
{

    
    
    MKCoordinateRegion region = [self.mapView regionThatFits:MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 1000, 1000)];
    region.span.latitudeDelta = 0.01;
    region.span.longitudeDelta = 0.01;
    [self.mapView setRegion:region animated:YES];

    
    
    
    
    
    
  
    // Make the destination
    NSString *x = destinationLatText.text;
    NSLog(@"value at x : %@",x);
    NSScanner *scanner1 = [NSScanner scannerWithString:x];
    
    BOOL success1 = [scanner1 scanDouble:&latitude];
    NSLog(@"%d", success1);
    
    NSString *y = destinationLongText.text;
    NSLog(@"value at y : %@",y);
    NSScanner *scanner2 = [NSScanner scannerWithString:y];
    
    BOOL success2 = [scanner2 scanDouble:&longitude];
    NSLog(@"%d", success2);
    
    
    CLLocationCoordinate2D destinationCoords = CLLocationCoordinate2DMake(latitude, longitude);
    destinationPlacemark = [[MKPlacemark alloc] initWithCoordinate:destinationCoords addressDictionary:nil];
    destination = [[MKMapItem alloc] initWithPlacemark:destinationPlacemark];
  //[mapView addAnnotation:destinationPlacemark];
    
    // Add an annotation
    MKPointAnnotation *destpoint = [[MKPointAnnotation alloc] init];
    destpoint.coordinate = destinationPlacemark.coordinate;
    destpoint.title = @"Destination";
   
    
    [mapView addAnnotation:destpoint];
    
    
    // Make the source
    NSString *m = sourceLatText.text;
    NSLog(@"value at x : %@",x);
    NSScanner *scanner3 = [NSScanner scannerWithString:m];
    
    BOOL success3 = [scanner3 scanDouble:&latitude];
    NSLog(@"%d", success3);
    
    NSString *n = sourceLongText.text;
    NSLog(@"value at y : %@",y);
    NSScanner *scanner4 = [NSScanner scannerWithString:n];
    
    BOOL success4 = [scanner4 scanDouble:&longitude];
    NSLog(@"%d", success4);
    
    
    CLLocationCoordinate2D sourceCoords = CLLocationCoordinate2DMake(latitude, longitude);
    sourcePlacemark = [[MKPlacemark alloc] initWithCoordinate:sourceCoords addressDictionary:nil];
    source = [[MKMapItem alloc] initWithPlacemark:sourcePlacemark];
  //  [mapView addAnnotation:sourcePlacemark];
    
    // Add an annotation
    MKPointAnnotation *sourcepoint = [[MKPointAnnotation alloc] init];
    sourcepoint.coordinate = sourcePlacemark.coordinate;
    sourcepoint.title = @"Source Location";
    
    [mapView addAnnotation:sourcepoint];
    
    
    
    [self getDirections];
    
}




- (void)getDirections
{
    MKDirectionsRequest *request =
    [[MKDirectionsRequest alloc] init];
    
    request.source = source;
    
    request.destination = destination;
    request.requestsAlternateRoutes = YES;
    MKDirections *directions =
    [[MKDirections alloc] initWithRequest:request];
    
    [directions calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *response, NSError *error) {
         if (error) {
             // Handle error
         } else {
             [self showRoute:response];
         }
     }];
}



-(void)showRoute:(MKDirectionsResponse *)response
{
    for (MKRoute *route in response.routes)
    {
        
        NSLog(@"drawing for route");
        
        [mapView addOverlay:route.polyline level:MKOverlayLevelAboveLabels];
        
        
        for (MKRouteStep *step in route.steps)
        {
            NSLog(@"%@", step.instructions);
        }
    }
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    NSLog(@"drawing polyline for route");
    
    MKPolylineRenderer *renderer =
    [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor blueColor];
    renderer.lineWidth = 4.0;
    return renderer;
}







/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
