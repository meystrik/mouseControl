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

@interface MADisplayDetails : NSObject
{
    size_t      pHigh;
    size_t      pWide;
    size_t      iHigh;
    size_t      iWide;
    bool        isBuiltIn;
    bool        isMirrorSet;
    bool        isMain;
    double      rotation;
    uint32_t    modelNum;
    uint32_t    logicalNum;
}
@property   size_t pHigh;
@property   size_t pWide;
@property   size_t iHigh;
@property   size_t iWide;
@property   bool isBuiltIn;
@property   bool isMirrorSet;
@property   bool isMain;
@property   double rotation;
@property   uint32_t modelNum;
@property   uint32_t logicalNum;

@end

@interface MAMouseControl : NSObject

@end
