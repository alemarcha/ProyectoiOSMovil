//
//  RegisterViewController.h
//  ProyectoMoviliOS
//
//  Created by Alexis Martínez on 6/8/15.
//  Copyright (c) 2015 Alexis Martínez Chacón. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *inputUsuario;
- (IBAction)registrar:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *inputPassword;
@property (weak, nonatomic) IBOutlet UISwitch *aceptaLosTerminps;
- (void) addUser:(NSString *) usuario password:(NSString *) password completion:(void (^)(NSDictionary *res, NSError *error))completion;
@end
