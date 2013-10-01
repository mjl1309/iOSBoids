//
//  Boid.m
//  boids
//
//  Created by Mike Lyman on 9/30/13.
//  Copyright (c) 2013 Mike Lyman. All rights reserved.
//

#import "Boid.h"
#import "boidsViewController.h"
#import "GameConstants.h"

@implementation Boid

- (id)init {
    self = [super init];
    if (self) {
        self.positionVector = GLKVector3Make( ((float)arc4random() / ARC4RANDOM_MAX * 5) - 2.5,
                                              ((float)arc4random() / ARC4RANDOM_MAX * 5) - 2.5,
                                              ((float)arc4random() / ARC4RANDOM_MAX * 10) - 5 );

        self.velocityVector = GLKVector3Make( ((float)arc4random() / ARC4RANDOM_MAX * 2) - 1,
                                             ((float)arc4random() / ARC4RANDOM_MAX * 2) - 1,
                                             ((float)arc4random() / ARC4RANDOM_MAX * 2) - 1 );
    }
    return self;
}

- (void)updateWithTime:(NSTimeInterval)dt {
    
//    temporary!
    GLKVector3 worldSize = GLKVector3Make(5.0f, 5.0f, 5.0f);
    
    
    GLKVector3 displacementVector = GLKVector3MultiplyScalar(self.velocityVector, dt);
    self.positionVector = GLKVector3Add(self.positionVector, displacementVector);
    
//    screen wrapping
    float newX = self.positionVector.x;
    float newY = self.positionVector.y;
    float newZ = self.positionVector.z;
//    wrap X
    if (self.positionVector.x > worldSize.x) {
        newX = -worldSize.x;
    }
    else if (self.positionVector.x < -worldSize.x) {
        newX = worldSize.x;
    }
//    wrap Y
    if (self.positionVector.y > worldSize.y) {
        newY = -worldSize.y;
    }
    else if (self.positionVector.y < -worldSize.y) {
        newY = worldSize.y;
    }
//    wrap Z
    if (self.positionVector.z > worldSize.z) {
        newZ = -worldSize.z;
    }
    else if (self.positionVector.z < -worldSize.z) {
        newZ = worldSize.z;
    }
    self.positionVector = GLKVector3Make(newX, newY, newZ);
    
    NSLog(@"Position: %f, %f, %f", self.positionVector.x, self.positionVector.y, self.positionVector.z);
}


@end
