//
//  MultipleChoice.h
//  ProjectModel
//
//  Created by Rafagan Abreu on 26/11/14.
//  Copyright (c) 2014 Rafagan Abreu. All rights reserved.
//

#import "Question.h"
#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface MultipleChoice : Question <NSCoding>

+ (RKObjectMapping *)multipleChoiceMapping;

@property (nonatomic, strong) NSString *correctAnswer;
@property (nonatomic, strong) NSString *answerA;
@property (nonatomic, strong) NSString *answerB;
@property (nonatomic, strong) NSString *answerC;
@property (nonatomic, strong) NSString *answerD;
@property (nonatomic, strong) NSString *answerE;

@end
