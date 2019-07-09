//
//  TrueOrFalse.h
//  ProjectModel
//
//  Created by Rafagan Abreu on 26/11/14.
//  Copyright (c) 2014 Rafagan Abreu. All rights reserved.
//

#import "Question.h"
#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface TrueOrFalse : Question <NSCoding>

+ (RKObjectMapping *)trueOrFalseMapping;

@property (nonatomic) BOOL correctAnswer;

@end
