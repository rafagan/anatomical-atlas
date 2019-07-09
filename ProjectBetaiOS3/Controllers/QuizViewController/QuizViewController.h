//
//  QuizViewController.h
//  Unity-iPhone
//
//  Created by Pedro Roberto Nadolny Filho on 11/29/14.
//
//

#import <UIKit/UIKit.h>

@class QuizTestDTO;

@interface QuizViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    int questionNumber, score;
    UIAlertView *wrongAnwser, *quizCompleted;
}
@property (retain, nonatomic) IBOutlet UITableView *quizTableView;
@property (strong, nonatomic) QuizTestDTO *quiz;
@property (retain, nonatomic) IBOutlet UITextView *textView;
@property (retain, nonatomic) IBOutlet UILabel *authorLabel;
@property (retain, nonatomic) IBOutlet UIButton *nextQuestionButton;
@property BOOL isQuizEnabled;

- (IBAction)nextQuestionButtonAction:(id)sender;
-(void)setQuiz:(QuizTestDTO *)quiz;
+(QuizViewController *)quizSingleton;
+(void)setQuizSingleton:(QuizViewController *)q;
@end
