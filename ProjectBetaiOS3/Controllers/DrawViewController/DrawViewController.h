//
//  DrawViewController.h
//  Unity-iPhone
//
//  Created by Pedro Roberto Nadolny Filho on 10/2/14.
//
//

#import <UIKit/UIKit.h>

@interface DrawViewController : UIViewController
{
    CGPoint lastPoint;
    CGFloat hue;
    UIColor *color;
    BOOL mouseSwiped, hasTeached;
    int typeOfTouch, undoCount;
    UIView *slider, *undo;
    NSMutableArray *images;
    NSTimeInterval undoCounter, lastTime, currentTime;
}

@property (retain, nonatomic) IBOutlet UIImageView *mainImage;
@property (retain, nonatomic) IBOutlet UIImageView *tempDrawImage;
@property CGFloat r;
@property CGFloat g;
@property CGFloat b;

+(UIView *)previewSingleton;
+(void)setPreviewSingleton:(UIView *)v;

@end
