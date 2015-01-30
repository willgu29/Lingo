//
//  ConvertDiningHallNumberToString.m
//  Lingo
//
//  Created by William Gu on 1/30/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import "ConvertDiningHallNumberToString.h"

@implementation ConvertDiningHallNumberToString



enum diningHall {
    DEACTIVATED = -1,
    DeNeve = 0,
    BPlate = 1,
    Feast = 2,
    Covel = 3,
    Rende = 4,
    Cafe1919 = 5,
    BCafe = 6
};
typedef int fratType;



+(NSString *)returnDiningHallStringFromInt:(int)diningHallNumber
{
    NSString *diningHall = nil;
    
    if (diningHallNumber == DeNeve)
    {
        diningHall = @"De Neve";
    }
    else if (diningHallNumber == BPlate)
    {
        diningHall = @"B Plate";

    }
    else if (diningHallNumber == Feast)
    {
        diningHall = @"Feast";

    }
    else if (diningHallNumber == Covel)
    {
        diningHall = @"Covel";

    }
    else if (diningHallNumber == Rende)
    {
        diningHall = @"Rendezvous";

    }
    else if (diningHallNumber == Cafe1919)
    {
        diningHall = @"Cafe 1919";

    }
    else if (diningHallNumber == BCafe)
    {
        diningHall = @"B Cafe";

    }
    else
    {
        //FATAL ERROR
    }
    
    
    return diningHall;
}

@end
