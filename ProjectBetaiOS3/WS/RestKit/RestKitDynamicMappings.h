//
//  RestKitDynamicMappings.h
//  Unity-iPhone
//
//  Created by Rafagan Abreu on 19/02/15.
//
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface RestKitDynamicMappings : NSObject

+ (RKDynamicMapping*)classDynamicMapping;
+ (RKDynamicMapping*)questionDynamicMapping;

@end
