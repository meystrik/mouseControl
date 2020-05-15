//
//  mouseControl.h
//  mouseControl
//
//  Created by Meystrik, Chris on 4/23/20.
//  Copyright © 2020 C. Chris Meystrik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ApplicationServices/ApplicationServices.h>
#import <unistd.h>

#define MAX_DISPLAYS            32

@interface MADisplayDetails : NSObject
{
    CGDirectDisplayID   ID;
    size_t              pHigh;
    size_t              pWide;
    size_t              mHigh;
    size_t              mWide;
    bool                isBuiltIn;
    bool                isMirrorSet;
    bool                isMain;
    double              rotation;
    uint32_t            modelNum;
    uint32_t            logicalNum;
}
@property   CGDirectDisplayID ID;
@property   size_t pHigh;
@property   size_t pWide;
@property   size_t mHigh;
@property   size_t mWide;
@property   bool isBuiltIn;
@property   bool isMirrorSet;
@property   bool isMain;
@property   double rotation;
@property   uint32_t modelNum;
@property   uint32_t logicalNum;

@end

@interface MAMouseControl : NSObject
{
    uint32_t            nDisplays;
    NSMutableArray      *displayDetails;
    int                 defaultDelay;
}
@property int defaultDelay;
@property NSMutableArray *displayDetails;
@property uint32_t nDisplays;

- (int32_t) getDisplayList;
- (int) mouseEvent: (CGPoint) p withEventType:(CGEventType) e;

- (int) moveSmoothBetweenPoints: (int) x1
                      andPointY: (int) y1
                             x2: (int) x2
                     andPointY2: (int) y2;

- (int) moveSmoothBetweenPoints: (int) x1
                      andPointY: (int) y1
                             x2: (int) x2
                     andPointY2: (int) y2
                      withDelay: (int)delay;

- (int) moveToCoordinates: (int) x andPointY: (int) y;

- (int) leftDown;
- (int) leftUp;
- (int) leftClick;
- (int) leftClick: (int) delay
                    withDoubleClick: (bool) isDouble;
- (int) leftClick: (int) delay
                    withDoubleClick: (bool) isDouble
                    onPointX: (int) x
                    andPointY: (int) y;

- (int) rightDown;
- (int) rightUp;
- (int) rightClick;
- (int) rightClick: (int) delay
                    withDoubleClick: (bool) isDouble;
- (int) rightClick: (int) delay
                    withDoubleClick: (bool) isDouble
                    onPointX: (int) x
                    andPointY: (int) y;




@end
