//
//  QuizTestDTO.h
//  Unity-iPhone
//
//  Created by Pedro on 3/7/15.
//
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface QuizTestDTO : NSObject

+ (RKMapping *)quizTestMapping;

@property (nonatomic) NSInteger idQuizTest;
@property (nonatomic) NSInteger difficultLevel;
@property (nonatomic) NSInteger maxQuestions;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSSet* categories;

@end
