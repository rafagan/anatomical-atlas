//
//  Questions.h
//  Unity-iPhone
//
//  Created by Pedro on 3/13/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@class QuizTestCD;

@interface QuestionCD : NSManagedObject

@property (nonatomic, retain) id questions;
@property (nonatomic, retain) QuizTestCD *quizTest;

@end
