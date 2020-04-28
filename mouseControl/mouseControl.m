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

@synthesize delay;

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
    return [self leftClick: self.delay];
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
    return [self rightClick: self.delay];
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
