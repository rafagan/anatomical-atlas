//
//  QuizTestCD.h
//  Unity-iPhone
//
//  Created by Pedro on 3/13/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class QuestionCD, QuizIdentifier;

@interface QuizTestCD : NSManagedObject

@property (nonatomic, retain) NSNumber * difficultLevel;
@property (nonatomic, retain) NSNumber * maxQuestions;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) id author;
@property (nonatomic, retain) id resolutions;
@property (nonatomic, retain) QuizIdentifier *quziIdentifier;
@property (nonatomic, retain) QuestionCD *questions;

@end
