//
//  QuizLibraryViewController.h
//  Unity-iPhone
//
//  Created by Pedro Roberto Nadolny Filho on 10/12/14.
//
//

#import <UIKit/UIKit.h>

@class QuizViewController;
@class QuizTest;
@class Arvore;

@interface QuizLibraryViewController : UIViewController<UIAlertViewDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
{
    QuizTest *selectedQuiz;
    UIAlertView *cancelQuizAlertView;
    Arvore *arvore;
    NSMutableArray *treeNavigationStack;
}

@property (retain, nonatomic) IBOutlet UIScrollView *scroll;
@property (retain, nonatomic) IBOutlet UIView *serachView;
@property (retain, nonatomic) IBOutlet UIButton *cancelQuizButton;
@property (strong, nonatomic) QuizViewController *quizView;
@property (retain, nonatomic) IBOutlet UISegmentedControl *quizTypeSegmentControl;
@property (retain, nonatomic) IBOutlet UISearchBar *quizSearchBar;
@property (retain, nonatomic) IBOutlet UITableView *filtroTable;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (retain, nonatomic) IBOutlet UILabel *loadingMapLabel;

- (IBAction)cancelQuizAction:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *refreshQuizLibrary;
-(IBAction)loadQuizes;
@end
