//
//  LoginViewController.h
//  ProyectoMoviliOS
//
//  Created by Alexis Martínez on 14/7/15.
//  Copyright (c) 2015 Alexis Martínez Chacón. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *userInput;
@property (weak, nonatomic) IBOutlet UITextField *passwordInput;
@property (weak, nonatomic) IBOutlet UIButton *buttonEntrar;
@property bool *existeUsuario;
- (IBAction)onClickLoginButton:(id)sender;
- (void) login:(NSString *) usuario password:(NSString *) password completion:(void (^)(NSDictionary *dictionary, NSError *error))completion;
- (IBAction)touchOutPass:(id)sender;

@end
