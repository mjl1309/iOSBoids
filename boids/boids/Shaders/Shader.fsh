//
//  Shader.fsh
//  boids
//
//  Created by Mike Lyman on 9/30/13.
//  Copyright (c) 2013 Mike Lyman. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
