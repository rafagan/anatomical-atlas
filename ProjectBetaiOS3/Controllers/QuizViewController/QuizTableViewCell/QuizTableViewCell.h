//
//  QuizTableViewCell.h
//  Unity-iPhone
//
//  Created by Pedro Roberto Nadolny Filho on 11/29/14.
//
//

#import <UIKit/UIKit.h>

@interface QuizTableViewCell : UITableViewCell


@property (retain, nonatomic) IBOutlet UIView *cellView;
@property (retain, nonatomic) IBOutlet UITextView *text;


@property BOOL isAnwser;

@end