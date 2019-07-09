//
//  ModelCD.h
//  Unity-iPhone
//
//  Created by Pedro on 3/11/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BoneSetRelatedQuestions;

@interface BoneSetCD : NSManagedObject

@property (nonatomic, retain) NSNumber * totalBones;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * descript;
@property (nonatomic, retain) id boneChildren;
@property (nonatomic, retain) id boneSetChildren;
@property (nonatomic, retain) BoneSetRelatedQuestions *relatedQuestions;
@property (nonatomic, retain) id parentBoneSet;
@property (nonatomic, retain) NSNumber * idBoneSet;
@property (nonatomic, retain) NSString * synonimous;

@end
