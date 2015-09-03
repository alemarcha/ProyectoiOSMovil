//
//  LoginViewController.h
//  ProyectoMoviliOS
//
//  Created by Alexis Martínez on 14/7/15.
//  Copyright (c) 2015 Alexis Martínez Chacón. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

//Campos de la pantalla que van a ser utilizados en el controller
@property (weak, nonatomic) IBOutlet UITextField *userInput;
@property (weak, nonatomic) IBOutlet UITextField *passwordInput;
@property (weak, nonatomic) IBOutlet UIButton *buttonEntrar;

//Acción al pulsar el boton de login
- (IBAction)onClickLoginButton:(id)sender;

//Método utilizado para realizar la llamada a la api y comprobar que el usuario indicado es correcto
- (void) login:(NSString *) usuario password:(NSString *) password completion:(void (^)(NSDictionary *dictionary, NSError *error))completion;

//Metodo utilizado para cerrar el teclado cuando pulsamos fuera de él en cualquier parte de la pantalla
- (IBAction)touchOutPass:(id)sender;

@end
