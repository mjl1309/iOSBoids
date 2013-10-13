//
//  SteeringBehavior.m
//  boids
//
//  Created by Mike Lyman on 10/12/13.
//  Copyright (c) 2013 Mike Lyman. All rights reserved.
//

#import "SteeringBehavior.h"
#import "Boid.h"

@implementation SteeringBehavior

- (id)initWithOwner:(Boid*)owner
             weight:(float)weight {
    self = [super init];
    if ( self ) {
        self.owner = owner;
        self.weight = weight;
        self.neighbors = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addNeighbor:(Boid*)boid {
    // do stuff for vision cone here
    if ( boid != self.owner ) {
        [self.neighbors addObject:boid];
    }
}

- (GLKVector3)calculateAdjustmentVector {
    return GLKVector3Make(0.0f, 0.0f, 0.0f);
}

@end
