//
//  QuizCardPopoverViewController.h
//  Unity-iPhone
//
//  Created by Pedro Roberto Nadolny Filho on 12/3/14.
//
//

#import <UIKit/UIKit.h>

@interface PlayPopoverViewController : UIViewController<UIAlertViewDelegate>
{
    UIAlertView *deleteAlert;
}
@property int optionSelected;

- (IBAction)deleteButton:(id)sender;
- (IBAction)startButton:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *redButton;
@property (retain, nonatomic) IBOutlet UIButton *blueButton;

@end
