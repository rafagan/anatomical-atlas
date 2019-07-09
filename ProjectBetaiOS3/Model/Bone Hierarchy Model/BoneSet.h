//
//  BoneSet.h
//  ProjectModel
//
//  Created by Rafagan Abreu on 26/11/14.
//  Copyright (c) 2014 Rafagan Abreu. All rights reserved.
//

#ifndef ProjectModel_BoneSet_h
#define ProjectModel_BoneSet_h

#import <RestKit/RestKit.h>

@interface BoneSet : NSObject <NSCoding>

+ (RKMapping *)boneSetMapping;

@property (nonatomic) NSInteger idBoneSet;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *descript;
@property (nonatomic, strong) NSString *synonimous;
@property (nonatomic) NSInteger totalBones;

@property (nonatomic, strong) NSArray *boneChildren;
@property (nonatomic, strong) NSArray *boneSetChildren;
@property (nonatomic, strong) BoneSet* parentBoneSet;
@property (nonatomic, strong) NSArray* relatedQuestions;

@end

#endif
