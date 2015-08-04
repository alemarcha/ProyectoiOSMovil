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
@property (weak, nonatomic) IBOutlet UILabel *labelHour;
@property (weak, nonatomic) IBOutlet UILabel *valoracion;
@property (weak, nonatomic) IBOutlet UILabel *especialidad;
@property (weak, nonatomic) IBOutlet UILabel *mesasLibres;
@property (weak, nonatomic) IBOutlet UILabel *telefono;


@end
