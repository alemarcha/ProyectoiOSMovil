//
//  DetailsViewController.h
//  ProyectoMoviliOS
//
//  Created by Alexis Martínez on 28/7/15.
//  Copyright (c) 2015 Alexis Martínez Chacón. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface DetailsViewController : UIViewController

@property (nonatomic) MKAnnotationView *detallesAnotacion;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelDescription;


@end
