//
//  mouseControl.m
//  mouseControl
//
//  Created by Meystrik, Chris on 4/23/20.
//  Copyright © 2020 C. Chris Meystrik. All rights reserved.
//

#import "mouseControl.h"

@implementation MADisplayDetails

@synthesize ID;
@synthesize pHigh;
@synthesize pWide;
@synthesize mHigh;
@synthesize mWide;
@synthesize isBuiltIn;
@synthesize isMirrorSet;
@synthesize isMain;
@synthesize rotation;
@synthesize modelNum;
@synthesize logicalNum;

@end

@implementation MAMouseControl

@synthesize defaultDelay;
@synthesize displayDetails;
@synthesize nDisplays;


- (id) init
{
    displayDetails = [[NSMutableArray alloc] init];
    defaultDelay = 4000;
    
    [self getDisplayList];
    return [super init];
}

- (int32_t) getDisplayList

{
    uint32_t count = 0;
    int i;
    MADisplayDetails *d;
    CGSize s;
    CGDirectDisplayID displayIDs[MAX_DISPLAYS];
    
    
    memset(displayIDs, 0, sizeof(CGDirectDisplayID) * MAX_DISPLAYS );
    CGGetOnlineDisplayList(nDisplays, displayIDs, &count);
    
    self->nDisplays = count;
    [self->displayDetails removeAllObjects];
    
    for(i = 0; i < count; i++)  {
        d = [[MADisplayDetails alloc]init];
        
        d.ID = displayIDs[i];
        d.pWide = CGDisplayPixelsWide(displayIDs[i]);
        d.pHigh = CGDisplayPixelsHigh(displayIDs[i]);
        
        s = CGDisplayScreenSize(displayIDs[i]);
        d.mHigh = s.height;
        d.mWide = s.width;
        
        d.isBuiltIn = CGDisplayIsBuiltin(displayIDs[i]);
        d.isMirrorSet = CGDisplayIsInMirrorSet(displayIDs[i]);
        d.isMain = CGDisplayIsMain(displayIDs[i]);
        
        d.rotation = CGDisplayRotation(displayIDs[i]);
        d.modelNum = CGDisplayModelNumber(displayIDs[i]);
        d.logicalNum = CGDisplayUnitNumber(displayIDs[i]);
        
        [self->displayDetails addObject:d];
    }
    
    
    return count;
}


- (int) mouseEvent: (CGPoint) p
                   withEventType: (CGEventType) e
{
    
    /*
     *  Establish the Events
     */
    CGEventRef mouseevent = CGEventCreateMouseEvent(
                                                    NULL,
                                                    e,
                                                    p,
                                                    (CGMouseButton)e);
    if(mouseevent == NULL)  {
        return 1;
    }
    /*
     * Execute the Events defined above
     */
    CGEventPost(kCGHIDEventTap, mouseevent);
    
    
    /*
     * Release the Events
     */
    CFRelease(mouseevent);

    return 0;
}

- (int) moveSmoothBetweenPoints: (int) x1
                      andPointY: (int) y1
                            x2: (int) x2
                     andPointY2: (int) y2
{
    return [self moveSmoothBetweenPoints:x1 andPointY:y1 x2:x2 andPointY2:y2 withDelay: defaultDelay];
}

- (int) moveSmoothBetweenPoints: (int) x1
                      andPointY: (int) y1
                            x2: (int) x2
                     andPointY2: (int) y2
                      withDelay: (int) delay
{
    double m, b;
    int x = x1;
    int y = y1;
    int retval;
    
    NSLog(@"(moveSmoothBetweenPoints) Moving between: %d, %d  and  %d, %d\n", x1, y1, x2, y2);
    
    /*
     * Calculate the line equation to move the cursor
     */
    if( x1 != x2 )  {
        /*
          * Normal linear case with two known points, calculate the slope and y-intercept.  Vary
          * X in the defined direction and calculate Y along the way.
         */
        m = (double)(y2 - y1) / (double)(x2 - x1);
        b = (double)y1 - m * (double)x1;
        NSLog(@"Linear Slope = %4.2f  Y-Intercept = %4.2f\n", m, b);
        
        while( x != x2 )  {

            usleep(delay);
            
            if((retval = [self moveToCoordinates:x andPointY:y]))  {
                return retval;
            }
            
            y = m * (double)x + b;
            x += x1 < x2 ? 1 : -1;
            //NSLog(@"Moving to: %d, %d\n", x, y);
        }
        
    }
    else {
        /*
          * Special case where x1 == x2 and the slope is not defined, simply vary Y properly
         */
        NSLog(@"Special case: x1 == x2, %d\n", x1);
        while( y != y2 )  {
            
            if((retval = [self moveToCoordinates:x andPointY:y]))  {
                return retval;
            }
            
            usleep(delay);
            
            y += y1 < y2 ? 1 : -1;
        }
    }

    /*
     * Move to the final x2,y2 location
     */
    if((retval = [self moveToCoordinates:x andPointY:y]))  {
        return retval;
    }
    
    return 0;
}

- (int) moveToCoordinates: (int) x andPointY: (int) y
{
    CGPoint p = CGPointMake( x, y);
    return [self mouseEvent: p withEventType: kCGEventMouseMoved];
}

- (int) leftDown
{
    CGEventRef event = CGEventCreate(NULL);
    CGPoint p = CGEventGetLocation(event);
    CFRelease(event);
    
    return [self mouseEvent:p withEventType:kCGEventLeftMouseDown];
}

- (int) leftUp
{
    CGEventRef event = CGEventCreate(NULL);
    CGPoint p = CGEventGetLocation(event);
    CFRelease(event);
    
    return [self mouseEvent:p withEventType:kCGEventLeftMouseUp];
}



- (int) leftClick
{
    return [self leftClick: self.defaultDelay];
}

- (int) leftClick: (int) delay
{
    return [self leftClick: delay
                    withDoubleClick: false];

}

- (int) leftClick:  (int) delay
                    withDoubleClick: (bool) isDouble
{
    
    CGEventRef event = CGEventCreate(NULL);
    CGPoint p = CGEventGetLocation(event);
    CFRelease(event);
    
    
    return [self leftClick: delay
                    withDoubleClick: isDouble
                    onPointX: p.x
                    andPointY: p.y];
}

- (int) leftClick: (int) delay
                  withDoubleClick: (bool) isDouble
                  onPointX: (int) x
                  andPointY: (int) y
{
    CGPoint p;
    int clicks = isDouble ? 2 : 1;
    
    p = CGPointMake(x, y);
    
    for(int i = 0; i < clicks; i++)  {
        [self mouseEvent: p withEventType: kCGEventLeftMouseDown];
        usleep(delay);
        [self mouseEvent: p withEventType: kCGEventLeftMouseUp];
    }
    
    return 0;
}

- (int) rightDown
{
    CGEventRef event = CGEventCreate(NULL);
    CGPoint p = CGEventGetLocation(event);
    CFRelease(event);
    
    return [self mouseEvent:p withEventType:kCGEventRightMouseDown];
}

- (int) rightUp
{
    CGEventRef event = CGEventCreate(NULL);
    CGPoint p = CGEventGetLocation(event);
    CFRelease(event);
    
    return [self mouseEvent:p withEventType:kCGEventRightMouseUp];
}



- (int) rightClick
{
    return [self rightClick: self.defaultDelay];
}

- (int) rightClick: (int) delay
{
    return [self rightClick: delay
                    withDoubleClick: false];

}

- (int) rightClick:  (int) delay
                    withDoubleClick: (bool) isDouble
{
    
    CGEventRef event = CGEventCreate(NULL);
    CGPoint p = CGEventGetLocation(event);
    CFRelease(event);
    
    
    return [self rightClick: delay
                    withDoubleClick: isDouble
                    onPointX: p.x
                    andPointY: p.y];
}

- (int) rightClick: (int) delay
                  withDoubleClick: (bool) isDouble
                  onPointX: (int) x
                  andPointY: (int) y
{
    CGPoint p;
    int clicks = isDouble ? 2 : 1;
    
    p = CGPointMake(x, y);
    
    for(int i = 0; i < clicks; i++)  {
        [self mouseEvent: p withEventType: kCGEventRightMouseDown];
        usleep(delay);
        [self mouseEvent: p withEventType: kCGEventRightMouseUp];
    }
    
    return 0;
}


@end
