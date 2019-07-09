//
//  BallonViewController.h
//  Unity-iPhone
//
//  Created by Pedro Roberto Nadolny Filho on 11/29/14.
//
//

#import <UIKit/UIKit.h>

@interface BallonViewController : UIViewController
{
    NSTimeInterval lastTime;
}

@property (retain, nonatomic) IBOutlet UIView *ballonView;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (retain, nonatomic) IBOutlet UIButton *leftButton;
@property (retain, nonatomic) IBOutlet UIButton *rightButton;
@property (retain, nonatomic) IBOutlet UIButton *othersButton;
@property (retain, nonatomic) IBOutlet UIButton *opacityButton;
//@property (retain, nonatomic) NSString *nameOfImage;

- (IBAction)panGesture:(id)sender;
- (IBAction)leftButton:(UIButton *)sender;
- (IBAction)rightButton:(UIButton *)sender;
+(BallonViewController *)ballonSingleton;
+(void)setBallonSingleton:(BallonViewController *)ballon;
-(void)resetBallon;

- (IBAction)btnOpacityClicked:(id)sender;
- (IBAction)btnOthersClicked:(id)sender;

@property int selectedBoneOpacityLevel;
@property int otherBonesOpacityLevel;
@property BOOL stillShowing;

@end
