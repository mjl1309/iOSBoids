//
//  SteeringBehavior.h
//  boids
//
//  Created by Mike Lyman on 10/12/13.
//  Copyright (c) 2013 Mike Lyman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "Boid.h"

@interface SteeringBehavior : NSObject {
    
}

@property (nonatomic, retain) NSMutableArray *neighbors;

@property (nonatomic, retain) Boid *owner;

@property (nonatomic, assign) float weight;\

@property (nonatomic, assign) float awarenessRadius;

@property (nonatomic, assign) float viewConeAngle;


- (id)initWithOwner:(Boid*)owner
             weight:(float)weight
    awarenessRadius:(float)awarenessRadius
      viewConeAngle:(float)viewConeAngle;

- (void)addNeighbor:(Boid*)boid;

//- (void)clear:(Boid*)boid;

- (GLKVector3)calculateAdjustmentVector;



@end
