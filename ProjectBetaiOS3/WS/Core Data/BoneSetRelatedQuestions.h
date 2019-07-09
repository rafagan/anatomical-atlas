//
//  BoneSetRelatedQuestions.h
//  Unity-iPhone
//
//  Created by Pedro on 3/11/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BoneSetCD;

@interface BoneSetRelatedQuestions : NSManagedObject

@property (nonatomic, retain) id relatedQuestions;
@property (nonatomic, retain) BoneSetCD *boneSetCD;

@end
