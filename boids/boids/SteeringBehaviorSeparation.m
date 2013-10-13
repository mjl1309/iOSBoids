//
//  SteeringBehaviorSeparation.m
//  boids
//
//  Created by Mike Lyman on 10/12/13.
//  Copyright (c) 2013 Mike Lyman. All rights reserved.
//

#import "SteeringBehaviorSeparation.h"

@implementation SteeringBehaviorSeparation

- (void)addNeighbor:(Boid*)boid {
    [super addNeighbor:boid];
}

- (GLKVector3)calculateAdjustmentVector {
    GLKVector3 adjustmentVector = GLKVector3Make(0.0f, 0.0f, 0.0f);
    GLKVector3 toNeighborVector = GLKVector3Make(0.0f, 0.0f, 0.0f);
    float distance;
    if ( [self.neighbors count] > 0 ) {
        for (Boid *neighbor in self.neighbors) {
            toNeighborVector = GLKVector3Subtract( self.owner.positionVector, neighbor.positionVector );
            distance = GLKVector3Length( toNeighborVector );
            toNeighborVector = GLKVector3Normalize( toNeighborVector );
            toNeighborVector = GLKVector3MultiplyScalar( toNeighborVector, 1.0 / distance );
            adjustmentVector = GLKVector3Add( adjustmentVector, toNeighborVector );
        }
        adjustmentVector = GLKVector3Normalize( adjustmentVector );
        adjustmentVector = GLKVector3MultiplyScalar( adjustmentVector, self.weight );
    }
    return adjustmentVector;
}


@end
