//
//  QuizIdentifier.h
//  Unity-iPhone
//
//  Created by Pedro on 3/13/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class QuizTestCD;

@interface QuizIdentifier : NSManagedObject

@property (nonatomic, retain) NSNumber * idQuizTest;
@property (nonatomic, retain) QuizTestCD *quizTest;

@end
