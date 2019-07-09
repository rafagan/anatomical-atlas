//
//  LoginViewController.h
//  Unity-iPhone
//
//  Created by Pedro Roberto Nadolny Filho on 9/19/14.
//
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate>

@property (retain, nonatomic) IBOutlet UIView *touchView;
@property (retain, nonatomic) IBOutlet UIView *alertView;
@property (retain, nonatomic) IBOutlet UIView *sucessAlertView;
@property (retain, nonatomic) IBOutlet UIView *loadingAlertView;
@property (retain, nonatomic) IBOutlet UIButton *forgotButton;
- (IBAction)forgotPassword:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *loginLabel;
@property (retain, nonatomic) IBOutlet UILabel *emailLabel;
@property (retain, nonatomic) IBOutlet UILabel *passwordLabel;
@property (retain, nonatomic) IBOutlet UITextField *emailTextField;
@property (retain, nonatomic) IBOutlet UITextField *passwordTextField;
@property (retain, nonatomic) IBOutlet UIButton *loginButton;

@end
