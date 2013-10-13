//
//  SteeringBehaviorAlignment.m
//  boids
//
//  Created by Mike Lyman on 10/12/13.
//  Copyright (c) 2013 Mike Lyman. All rights reserved.
//

#import "SteeringBehaviorAlignment.h"
#import "Boid.h"

@implementation SteeringBehaviorAlignment

- (void)addNeighbor:(Boid*)boid {
    [super addNeighbor:boid];
}

- (GLKVector3)calculateAdjustmentVector {
    GLKVector3 adjustmentVector = GLKVector3Make(0.0f, 0.0f, 0.0f);
    if ( [self.neighbors count] > 0 ) {
        for (Boid *neighbor in self.neighbors) {
            adjustmentVector = GLKVector3Add(adjustmentVector, neighbor.forwardVector);
        }
        adjustmentVector = GLKVector3MultiplyScalar( adjustmentVector, [self.neighbors count] );
        adjustmentVector = GLKVector3Normalize( adjustmentVector );
        adjustmentVector = GLKVector3MultiplyScalar( adjustmentVector, self.weight );
    }
    return adjustmentVector;
}



@end
