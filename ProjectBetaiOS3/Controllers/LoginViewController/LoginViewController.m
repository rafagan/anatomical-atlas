//
//  LoginViewController.m
//  Unity-iPhone
//
//  Created by Pedro Roberto Nadolny Filho on 9/19/14.
//
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

int aux = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.alertView.hidden = YES;
    self.sucessAlertView.layer.cornerRadius = 6;
    self.loadingAlertView.layer.cornerRadius = 6;
    self.loginButton.layer.cornerRadius = 6;
    self.emailTextField.delegate = self;
    self.passwordTextField.delegate = self;
}

- (IBAction)loginButton:(id)sender {
    if(aux == 0){
        self.sucessAlertView.hidden = YES;
        self.loadingAlertView.hidden = NO;
        self.alertView.hidden = NO;
        aux++;
    }else if(aux == 1){
        self.sucessAlertView.hidden = NO;
        self.loadingAlertView.hidden = YES;
        aux++;
    }else if(aux == 2){
        self.alertView.hidden = YES;
        aux = 0;
        [UIView animateWithDuration:0.17 animations:^{
            if(self.view.alpha == 0){
                self.view.alpha = 1;
            }else{
                self.view.alpha = 0;
            }
        }];
    }
    
    [_emailTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}

- (void)dealloc {
    [_touchView release];
    [_alertView release];
    [_sucessAlertView release];
    [_loadingAlertView release];
    [_forgotButton release];
    [_loginLabel release];
    [_emailLabel release];
    [_passwordLabel release];
    [_emailTextField release];
    [_passwordTextField release];
    [_loginButton release];
    [super dealloc];
}
- (IBAction)forgotPassword:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Recovery Password" message:@"Enter your email to receive a new password."  delegate:nil cancelButtonTitle:@"Cancel"  otherButtonTitles:@"OK" , nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alert show];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:15 options:nil animations:^{
        
        self.loginLabel.frame = CGRectMake(self.loginLabel.frame.origin.x, self.loginLabel.frame.origin.y - 100, self.loginLabel.frame.size.width, self.loginLabel.frame.size.height);
        
        self.emailLabel.frame = CGRectMake(self.emailLabel.frame.origin.x, self.emailLabel.frame.origin.y - 200, self.emailLabel.frame.size.width, self.emailLabel.frame.size.height);
        
        self.emailTextField.frame = CGRectMake(self.emailTextField.frame.origin.x, self.emailTextField.frame.origin.y - 200, self.emailTextField.frame.size.width, self.emailTextField.frame.size.height) ;
        
        self.passwordLabel.frame = CGRectMake(self.passwordLabel.frame.origin.x, self.passwordLabel.frame.origin.y - 200, self.passwordLabel.frame.size.width, self.passwordLabel.frame.size.height);
        
        self.passwordTextField.frame = CGRectMake(self.passwordTextField.frame.origin.x, self.passwordTextField.frame.origin.y - 200, self.passwordTextField.frame.size.width, self.passwordTextField.frame.size.height);
        
        self.forgotButton.frame = CGRectMake(self.forgotButton.frame.origin.x, self.forgotButton.frame.origin.y - 200, self.forgotButton.frame.size.width, self.forgotButton.frame.size.height);
        
        self.loginButton.frame = CGRectMake(self.loginButton.frame.origin.x, self.loginButton.frame.origin.y - 200, self.loginButton.frame.size.width, self.loginButton.frame.size.height);

        
    } completion:nil];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:15 options:nil animations:^{
        self.loginLabel.frame = CGRectMake(self.loginLabel.frame.origin.x, self.loginLabel.frame.origin.y + 100, self.loginLabel.frame.size.width, self.loginLabel.frame.size.height);
        
        self.emailLabel.frame = CGRectMake(self.emailLabel.frame.origin.x, self.emailLabel.frame.origin.y + 200, self.emailLabel.frame.size.width, self.emailLabel.frame.size.height);
        
        self.emailTextField.frame = CGRectMake(self.emailTextField.frame.origin.x, self.emailTextField.frame.origin.y + 200, self.emailTextField.frame.size.width, self.emailTextField.frame.size.height) ;
        
        self.passwordLabel.frame = CGRectMake(self.passwordLabel.frame.origin.x, self.passwordLabel.frame.origin.y + 200, self.passwordLabel.frame.size.width, self.passwordLabel.frame.size.height);
        
        self.passwordTextField.frame = CGRectMake(self.passwordTextField.frame.origin.x, self.passwordTextField.frame.origin.y + 200, self.passwordTextField.frame.size.width, self.passwordTextField.frame.size.height);

        self.forgotButton.frame = CGRectMake(self.forgotButton.frame.origin.x, self.forgotButton.frame.origin.y + 200, self.forgotButton.frame.size.width, self.forgotButton.frame.size.height);

        self.loginButton.frame = CGRectMake(self.loginButton.frame.origin.x, self.loginButton.frame.origin.y + 200, self.loginButton.frame.size.width, self.loginButton.frame.size.height);
        
    } completion:nil];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    // não apague
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    // não apague
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    // não apague
}

@end
