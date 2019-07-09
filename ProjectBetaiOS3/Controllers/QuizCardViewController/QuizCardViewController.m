//
//  QuizCardViewController.m
//  Unity-iPhone
//
//  Created by Pedro Roberto Nadolny Filho on 12/2/14.
//
//

#import <RestKit/RestKit.h>

#import "QuizTestDTO.h"
#import "QuizTestCD.h"
#import "QuizTest.h"
#import "QuizCardViewController.h"
#import "QuizLibraryViewController.h"
#import "PlayPopoverViewController.h"
#import "QuizViewController.h"
#import "DownloadPopoverViewController.h"
#import "DataSourceManager.h"
#import "CoreDataManager.h"
#import "QuizIdentifier.h"
#import "QuestionCD.h"

@interface QuizCardViewController ()

@end

@implementation QuizCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.layer.cornerRadius = 6;
    _isDownloaded = NO;
    playPopover = [[PlayPopoverViewController alloc] init];
    downloadPopover = [[DownloadPopoverViewController alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playPopoverOptionSelected) name:@"popoverOptionSelected"  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadQuiz) name:@"downloadQuiz" object:nil];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [QuizCardViewController setLastCardInteracted:self];
    
    if(!_isDownloaded){
        popover = [[UIPopoverController alloc] initWithContentViewController:downloadPopover];
        [popover setPopoverContentSize:downloadPopover.view.frame.size];
    }else{
        popover = [[UIPopoverController alloc] initWithContentViewController:playPopover];
        [popover setPopoverContentSize:playPopover.view.frame.size];
    }
    
    UITouch *touch = touches.allObjects[0];
    CGPoint touchPosition = [touch locationInView:self.view];
    CGRect rectRepresentationOfTouch = CGRectMake(touchPosition.x, touchPosition.y, 1, 1);
    [popover presentPopoverFromRect:rectRepresentationOfTouch inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp | UIPopoverArrowDirectionDown animated:YES];
}

-(void)downloadQuiz{
    if([self isEqual:[QuizCardViewController lastCardInteracted]]){
        
        [self.downloadActivityIndicator startAnimating];
        
        [DATA_SRC downloadQuizTest:self.quiz.idQuizTest withCallback:^(QuizTest *qs) {
            
            QuizIdentifier *quizId = [NSEntityDescription insertNewObjectForEntityForName:@"QuizIdentifier" inManagedObjectContext:CD_MANAGER.managedObjectContext];
            [self setupQuizIdentifier:quizId forQuizTest:qs];
            [CD_MANAGER saveContext];
        
            [self.downloadActivityIndicator stopAnimating];
            _isDownloaded = YES;
            self.statusImage.hidden = NO;
        }];
        
        [popover dismissPopoverAnimated:YES];
    }
}

-(void)setupQuizIdentifier:(QuizIdentifier *)quizIdentifier forQuizTest:(QuizTest *)quizTest{
    
    QuizTestCD *quizTestCD = [NSEntityDescription insertNewObjectForEntityForName:@"QuizTestCD" inManagedObjectContext:CD_MANAGER.managedObjectContext];
    
    QuestionCD *questionsCD = [NSEntityDescription insertNewObjectForEntityForName:@"QuestionCD" inManagedObjectContext:CD_MANAGER.managedObjectContext];
    
    quizTestCD.difficultLevel = [NSNumber numberWithInteger:quiz.difficultLevel];
    quizTestCD.maxQuestions = [NSNumber numberWithInteger:quiz.maxQuestions];
    quizTestCD.title = quizTest.title;
    quizTestCD.author = quizTestCD.author;
    quizTestCD.resolutions = quizTest.resolutions;
    quizTestCD.quziIdentifier = quizIdentifier;
    quizTestCD.questions = questionsCD;
    
    questionsCD.questions = quizTest.questions;
    questionsCD.quizTest = quizTestCD;
    
    quizIdentifier.quizTest = quizTestCD;
    quizIdentifier.idQuizTest = [NSNumber numberWithInteger:quiz.idQuizTest];
}

-(void)playPopoverOptionSelected{
    if(playPopover.optionSelected == 1){
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"QuizIdentifier" inManagedObjectContext:CD_MANAGER.managedObjectContext];
        [fetchRequest setEntity:entity];
        // Specify criteria for filtering which objects to fetch

        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %d", @"idQuizTest", self.quiz.idQuizTest];
        [fetchRequest setPredicate:predicate];
        
        NSError *error = nil;
        NSArray *fetchedObjects = [CD_MANAGER.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        if (fetchedObjects == nil) {
            NSLog(@"FETCHING ERROR :%@", error);
        }else if(fetchedObjects.count == 0){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Problem" message:@"Could not find this quiz" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"Continue" style:UIAlertActionStyleDefault handler:nil];
            
            [alert addAction:alertAction];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            for(QuizIdentifier *qi in fetchedObjects){
                [CD_MANAGER.managedObjectContext deleteObject:qi];
            }
            [CD_MANAGER saveContext];
            self.statusImage.hidden = YES;
            _isDownloaded = NO;
        }
        
    } else if(playPopover.optionSelected == 2){
        QuizViewController *quizView = [QuizViewController quizSingleton];
        [quizView setQuiz:self.quiz];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"startQuiz"  object:nil];
    }
    
    [popover dismissPopoverAnimated:YES];
}

- (void)setQuiz:(QuizTestDTO *)q{
    quiz = q;
    
    [self setTitle:quiz.title];
    [self.titleLabel sizeToFit];
    if(self.titleLabel.frame.size.height > 65){
        CGRect titleLabelNewFrame = CGRectMake(self.titleLabel.frame.origin.x, self.titleLabel.frame.origin.y, self.titleLabel.frame.size.width, 65);
        self.titleLabel.frame = titleLabelNewFrame;
    }
    
    [self setNumberOfQuestions:quiz.maxQuestions];
}

-(QuizTestDTO *)quiz{
    return quiz;
}

-(void)setTitle:(NSString *)title{
    [self viewDidLoad];
    self.titleLabel.text = title;
}

-(void)setNumberOfQuestions:(NSInteger)n{
    self.numberOfQuestionsLabel.text = [NSString stringWithFormat:@"%ld questions", (long)n];
}

- (void)dealloc {
    [_titleLabel release];
    [_authorLabel release];
    [_numberOfQuestionsLabel release];
    [_statusImage release];
    [_downloadActivityIndicator release];
    [super dealloc];
}

static QuizCardViewController* quizCard = nil;

+(QuizCardViewController *)lastCardInteracted{
    if(!quizCard){
        quizCard = [[QuizCardViewController alloc] init];
    }
    return quizCard;
}

+(void)setLastCardInteracted:(QuizCardViewController *)card{
    quizCard = card;
}

@end
