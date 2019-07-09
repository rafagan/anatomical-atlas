//
//  DrawViewController.m
//  Unity-iPhone
//
//  Created by Pedro Roberto Nadolny Filho on 10/2/14.
//
//

#import "DrawViewController.h"

@interface DrawViewController ()

@end

@implementation DrawViewController

-(void)viewDidLoad{
    self.r = 0.3;
    self.g = 0.9;
    self.b = 0.4;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"previewSetColor" object:nil];
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    slider = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 80, 140, 30, 340)];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = slider.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor redColor] CGColor], (id)[[UIColor magentaColor] CGColor], (id)[[UIColor blueColor] CGColor], (id)[[UIColor cyanColor] CGColor], (id)[[UIColor greenColor] CGColor], (id)[[UIColor yellowColor] CGColor], (id)[[UIColor orangeColor] CGColor], (id)[[UIColor redColor] CGColor], nil];
    [slider.layer insertSublayer:gradient atIndex:0];
    slider.layer.borderColor = [UIColor whiteColor].CGColor;
    slider.layer.borderWidth = 2;
    [self.view addSubview:slider];
    
    undo = [[UIView alloc] initWithFrame:CGRectMake(slider.frame.origin.x - 72, 95, 50, 50)];
    undo.layer.cornerRadius = undo.frame.size.width/2;
    undo.layer.borderColor = [UIColor whiteColor].CGColor;
    undo.layer.borderWidth = 2;
    undo.backgroundColor = [UIColor colorWithRed:self.r green:self.g blue:self.b alpha:1];
    
    UIImageView *undoImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"undo.png"]];
    undoImageView.frame = CGRectMake(undo.frame.size.width/2 - undoImageView.frame.size.width/2, undo.frame.size.height/2 - undoImageView.frame.size.height/2, undoImageView.frame.size.width, undoImageView.frame.size.height);
    [undo addSubview:undoImageView];
    
    [self.view addSubview:undo];
    
    UITapGestureRecognizer *undoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(undoTap)];
    [undo addGestureRecognizer:undoTap];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(undoLongPress)];
    [undo addGestureRecognizer:longPress];
    
    images = [[NSMutableArray alloc] init];
    hasTeached = NO;
    undoCount = 0;
}

-(void)undoTap{
    self.mainImage.image = (UIImage *)[images lastObject];
    [images removeLastObject];
    undoCount++;
    
    if(undoCount >= 4 && self.mainImage.image == nil && !hasTeached){
        UIAlertView* teacheClear = [[UIAlertView alloc] initWithTitle:@"Hey!" message:@"Did you know that if you hold the undo button for while, you clear the entire canvas at once?"  delegate:nil cancelButtonTitle:@"Close"  otherButtonTitles: nil];
        [teacheClear show];
        hasTeached = YES;
    }
    
    if(self.mainImage.image == nil){
        undoCount = 0;
    }
}
                                   
-(void)undoLongPress{
    self.mainImage.image = nil;
    [images removeAllObjects];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self.view];
    if(CGRectContainsPoint(slider.frame, p)){
        typeOfTouch = 1;
        undoCount = 0;
    }else if(CGRectContainsPoint(undo.frame, p) || CGRectContainsPoint([DrawViewController previewSingleton].frame, p)){
        typeOfTouch = 2;
    }else{
        typeOfTouch = 0;
        undoCount = 0;
    }
    
    if(typeOfTouch == 0){
        UITouch *touch = [touches anyObject];
        mouseSwiped = NO;
        lastPoint = [touch locationInView:self.view];
        if(self.mainImage.image){
            [images addObject:self.mainImage.image];   
        }
    }else if(typeOfTouch == 1){
        if(p.y >= slider.frame.origin.y && p.y <= slider.frame.origin.y + slider.frame.size.height){
            hue = 1 - ((p.y - slider.frame.origin.y) / slider.frame.size.height);
            color = [UIColor colorWithHue:hue saturation:1 brightness:1 alpha:1];
            const CGFloat* components = CGColorGetComponents(color.CGColor);
            self.r = components[0];
            self.g = components[1];
            self.b = components[2];
            [DrawViewController previewSingleton].backgroundColor = [UIColor colorWithRed:self.r green:self.g blue:self.b alpha:1];
            undo.backgroundColor = color;
        }
    }
}
    
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.view];
    
    if(typeOfTouch == 0){
        mouseSwiped = YES;
        UIGraphicsBeginImageContext(self.view.frame.size);
        [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 7);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), self.r, self.g, self.b, 1.0);
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        [self.tempDrawImage setAlpha:1];
        UIGraphicsEndImageContext();
        
    }else if(typeOfTouch == 1){
        if(lastPoint.y >= slider.frame.origin.y && lastPoint.y <= slider.frame.origin.y + slider.frame.size.height){
            hue = 1 - ((lastPoint.y - slider.frame.origin.y) / slider.frame.size.height);
            color = [UIColor colorWithHue:hue saturation:1 brightness:1 alpha:1];
            const CGFloat* components = CGColorGetComponents(color.CGColor);
            self.r = components[0];
            self.g = components[1];
            self.b = components[2];
            [DrawViewController previewSingleton].backgroundColor = [UIColor colorWithRed:self.r green:self.g blue:self.b alpha:1];
            undo.backgroundColor = color;
        }
    }
    
    lastPoint = currentPoint;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(typeOfTouch == 0){
        if(!mouseSwiped) {
            
            UIGraphicsBeginImageContext(self.view.frame.size);
            [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
            CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 7);
            CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), self.r, self.g, self.b, 1.0);
            CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
            CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
            CGContextStrokePath(UIGraphicsGetCurrentContext());
            CGContextFlush(UIGraphicsGetCurrentContext());
            self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        
        UIGraphicsBeginImageContext(self.mainImage.frame.size);
        [self.mainImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
        [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:1];
        self.mainImage.image = UIGraphicsGetImageFromCurrentImageContext();
        self.tempDrawImage.image = nil;
        UIGraphicsEndImageContext();
    }
}

static UIView *previewSingleton = nil;

+(UIView *)previewSingleton{
    if(!previewSingleton){
        previewSingleton = [[UIView alloc] init];
    }
    
    return previewSingleton;
}

+(void)setPreviewSingleton:(UIView *)v{
    previewSingleton = v;
}

- (void)dealloc {
    [super dealloc];
}

@end
