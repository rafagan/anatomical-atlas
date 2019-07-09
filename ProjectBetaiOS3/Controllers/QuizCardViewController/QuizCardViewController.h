//
//  QuizCardViewController.h
//  Unity-iPhone
//
//  Created by Pedro Roberto Nadolny Filho on 12/2/14.
//
//

#import <UIKit/UIKit.h>

@class QuizTestDTO;
@class PlayPopoverViewController;
@class DownloadPopoverViewController;

@interface QuizCardViewController : UIViewController<UIPopoverControllerDelegate>
{
    QuizTestDTO *quiz;
    PlayPopoverViewController *playPopover;
    DownloadPopoverViewController *downloadPopover;
    UIPopoverController *popover;
}

@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *authorLabel;
@property (retain, nonatomic) IBOutlet UILabel *numberOfQuestionsLabel;
@property (retain, nonatomic) IBOutlet UIImageView *statusImage;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *downloadActivityIndicator;
@property BOOL isDownloaded;

- (void)setQuiz:(QuizTestDTO *)quiz;
- (QuizTestDTO *)quiz;
+(QuizCardViewController *)lastCardInteracted;
+(void)setLastCardInteracted:(QuizCardViewController *)card;

@end
