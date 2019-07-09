//
//  BottomMenuViewController.h
//  Unity-iPhone
//
//  Created by Pedro Roberto Nadolny Filho on 10/2/14.
//
//

#import <UIKit/UIKit.h>

@interface BottomMenuViewController : UIViewController
- (IBAction)loginButtonAction:(id)sender;
- (IBAction)quizLibraryViewController:(id)sender;
- (IBAction)atlasButtonAction:(id)sender;

@property (retain, nonatomic) IBOutlet UIButton *quizButton;
@property (retain, nonatomic) IBOutlet UIButton *settingsButton;
@property (retain, nonatomic) IBOutlet UIButton *profileButton;
@property (retain, nonatomic) IBOutlet UIButton *atlasButton;

+(BottomMenuViewController *)bottomMenuViewControllerSingleton;
+(void)setBottomMenuSingleton:(BottomMenuViewController *)bottomMenu;

@end
