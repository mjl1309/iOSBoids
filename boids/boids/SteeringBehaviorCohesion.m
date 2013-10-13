//
//  SteeringBehaviorCohesion.m
//  boids
//
//  Created by Mike Lyman on 10/12/13.
//  Copyright (c) 2013 Mike Lyman. All rights reserved.
//

#import "SteeringBehaviorCohesion.h"
#import "Boid.h"

@implementation SteeringBehaviorCohesion


- (void)addNeighbor:(Boid*)boid {
    [super addNeighbor:boid];
}

- (GLKVector3)calculateAdjustmentVector {
    GLKVector3 adjustmentVector = GLKVector3Make(0.0f, 0.0f, 0.0f);
    if ( [self.neighbors count] > 0 ) {
        GLKVector3 averageVector = GLKVector3Make(0.0f, 0.0f, 0.0f);
        for (Boid *neighbor in self.neighbors) {
            averageVector = GLKVector3Add( averageVector, neighbor.positionVector );
        }
        averageVector = GLKVector3MultiplyScalar( averageVector, 1.0 / [self.neighbors count] );
        adjustmentVector = GLKVector3Subtract( averageVector, self.owner.positionVector );
        adjustmentVector = GLKVector3Normalize( adjustmentVector );
        adjustmentVector = GLKVector3MultiplyScalar( adjustmentVector, self.weight );
    }
    return adjustmentVector;
}


@end
