//
//  Clazz.h
//  ProjectModel
//
//  Created by Rafagan Abreu on 26/11/14.
//  Copyright (c) 2014 Rafagan Abreu. All rights reserved.
//

#ifndef ProjectModel_Clazz_h
#define ProjectModel_Clazz_h

#import <RestKit/RestKit.h>

@interface Clazz : NSObject <NSCoding>

@property (nonatomic) NSInteger idClass;
@property (nonatomic, strong) NSString *name;
@property (nonatomic) NSInteger classSize;

@property (nonatomic, strong) NSArray *monitors;
@property (nonatomic, strong) NSArray *classStudents;

@end

#endif
