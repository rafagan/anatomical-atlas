//
//  QuizViewController.m
//  Unity-iPhone
//
//  Created by Pedro Roberto Nadolny Filho on 11/29/14.
//
//

#import "QuizViewController.h"
#import "QuizTableViewCell.h"
#import "Categories.h"

@interface QuizViewController ()

@end

@implementation QuizViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rightAnwser) name:@ "right" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wrongAnwser) name:@"wrong"  object:nil];
    wrongAnwser = [[UIAlertView alloc] initWithTitle:@"Wrong Anwser"  message:nil delegate:self cancelButtonTitle:@"See Anwser" otherButtonTitles:@"Get more info",  nil];
    self.isQuizEnabled = YES;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 96;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"cellId";
    
    QuizTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if(!cell){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"QuizTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }

#pragma warning nescessario DTO
//    QuestionsMultipleChoise *question = [self.quiz.questions objectAtIndex:questionNumber];
//    cell.text.text = [question.alternatives objectAtIndex:indexPath.row];
//    cell.text.font = [UIFont fontWithName:@"HelveticaNeue"  size: 14];
//    cell.text.textColor = [UIColor whiteColor];
//    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
//    
//    if(indexPath.row == question.anwser){
//        cell.isAnwser = YES;
//    }else{
//        cell.isAnwser = NO;
//    }
    
    return cell;
}

-(void)loadQuiz{
    score = 0;
    questionNumber = 0;
    [self loadQuestion];
    self.authorLabel.hidden = YES;
}

-(void)loadQuestion{
    [self.textView setFont:[UIFont fontWithName:@"HelveticaNeue-Bold"  size:18]];
    [self.textView setTextColor:[UIColor whiteColor]];
    [self.quizTableView reloadData];
}
     
- (IBAction)nextQuestionButtonAction:(id)sender {
    questionNumber++;
    
    [UIView animateWithDuration:0.17 delay:0 usingSpringWithDamping:1 initialSpringVelocity:15 options:UIViewAnimationCurveLinear animations:^{
        self.quizTableView.frame = CGRectMake(self.quizTableView.frame.origin.x, self.quizTableView.frame.origin.y, self.quizTableView.frame.size.width, self.quizTableView.frame.size.height + self.nextQuestionButton.frame.size.height);
    } completion:nil];
    
    self.isQuizEnabled = YES;
    
#warning nescessario melhoramento de model WS
//    if(questionNumber >= self.quiz.questions.count){
//        quizCompleted = [[UIAlertView alloc] initWithTitle:@"Test is over" message:[NSString stringWithFormat:@"You've got %d/%lu correct anwsers", score, (unsigned long)self.quiz.questions.count]  delegate:self cancelButtonTitle:@"Do it again"  otherButtonTitles:@"Close", nil];
//        [quizCompleted show];
//    }else{
//        [self.quizTableView reloadData];
//        [self.textView setText:((QuestionsMultipleChoise *)[self.quiz.questions objectAtIndex:questionNumber]).enunciate];
//        self.textView.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
//        self.textView.textColor = [UIColor whiteColor];
//    }
}

-(void)setQuiz:(QuizTestDTO *)quiz{
    _quiz = quiz;
    [self loadQuiz];
}

-(void)rightAnwser{
    questionNumber++;
    score++;
#warning nescessario melhoramento de model WS
    //    if(questionNumber >= self.quiz.questions.count){
//        quizCompleted = [[UIAlertView alloc] initWithTitle:@"Test is over" message:[NSString stringWithFormat:@"You've got %d/%lu correct anwsers", score, (unsigned long)self.quiz.questions.count]  delegate:self cancelButtonTitle:@"Do it again"  otherButtonTitles:@"Close", nil];
//        [quizCompleted show];
//    }else{
//        [self.quizTableView reloadData];
//        [self.textView setText:((QuestionsMultipleChoise *)[self.quiz.questions objectAtIndex:questionNumber]).enunciate];
//        self.textView.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
//        self.textView.textColor = [UIColor whiteColor];
//    }
}

-(void)wrongAnwser{
    [wrongAnwser show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if([alertView isEqual:wrongAnwser]){
        if(buttonIndex == 1){
            questionNumber++;
            
#warning nescessario melhoramento de model WS
//            if(questionNumber >= self.quiz.questions.count){
//                quizCompleted = [[UIAlertView alloc] initWithTitle:@"Test is over" message:[NSString stringWithFormat:@"You've got %d out of %lu correct anwsers", score, (unsigned long)self.quiz.questions.count]  delegate:self cancelButtonTitle:@"Do it again"  otherButtonTitles:@"Close", nil];
//                [quizCompleted show];
//            }else{
//                [self.quizTableView reloadData];
//                [self.textView setText:((QuestionsMultipleChoise *)[self.quiz.questions objectAtIndex:questionNumber]).enunciate];
//                self.textView.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
//                self.textView.textColor = [UIColor whiteColor];
//            }
        }else{
#warning nescessario melhoramento de model WS
//            QuizTableViewCell* cell = (QuizTableViewCell *)[self.quizTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:((QuestionsMultipleChoise *)[self.quiz.questions objectAtIndex:questionNumber]).anwser inSection:0]];
//            
//            [UIView animateWithDuration:0.17 delay:0 usingSpringWithDamping:1 initialSpringVelocity:15 options:UIViewAnimationCurveLinear animations:^{
//                cell.cellView.backgroundColor = [UIColor atlasLightGreen];
//                self.quizTableView.frame = CGRectMake(self.quizTableView.frame.origin.x, self.quizTableView.frame.origin.y, self.quizTableView.frame.size.width, self.quizTableView.frame.size.height - self.nextQuestionButton.frame.size.height);
//                
//            } completion:nil];
            
            self.isQuizEnabled = NO;
        }
    }else if([alertView isEqual:quizCompleted]){
        if(buttonIndex == 1){
            [[NSNotificationCenter defaultCenter] postNotificationName:@ "closeQuiz" object:nil];
        }else{
            [self loadQuiz];
        }
    }
    
}

- (void)dealloc {
    [_textView release];
    [_authorLabel release];
    [_nextQuestionButton release];
    [super dealloc];
}

static QuizViewController *quizViewController = nil;

+(QuizViewController *)quizSingleton{
    
    if(!quizViewController){
        quizViewController = [[QuizViewController alloc] init];
    }
    
    return quizViewController;
}

+(void)setQuizSingleton:(QuizViewController *)q{
    quizViewController = q;
}

@end
