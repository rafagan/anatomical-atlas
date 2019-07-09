//
//  QuizTableViewCell.m
//  Unity-iPhone
//
//  Created by Pedro Roberto Nadolny Filho on 11/29/14.
//
//

#import "QuizTableViewCell.h"
#import "Categories.h"
#import "QuizViewController.h"

@implementation QuizTableViewCell

- (void)awakeFromNib {
    self.cellView.layer.cornerRadius = 20;
    self.contentView.backgroundColor = [UIColor blackColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.cellView addGestureRecognizer:tap];
}

-(void)tap{
    if([QuizViewController quizSingleton].isQuizEnabled){
        if(self.isAnwser){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"right" object:nil];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"wrong"  object:nil];
            self.cellView.backgroundColor = [UIColor colorForHexCode:@"DD1B0C"];
        }
    }
}

- (void)dealloc {
    [_text release];
    [super dealloc];
}
@end
