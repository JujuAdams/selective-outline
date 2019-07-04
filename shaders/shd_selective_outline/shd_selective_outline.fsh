varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying vec2 v_vSurfaceUV;

uniform sampler2D u_sOutline;
uniform vec2 u_vTexel;
uniform vec2 u_vOutlineColour;

vec4 unpackGMColour(vec2 colourAlpha)
{
    vec4 result = vec4(0.0, 0.0, 0.0, colourAlpha.y*255.0);
    result.b = floor( colourAlpha.x / 65536.0);
    result.g = floor((colourAlpha.x - result.b*65536.0)/256.0);
    result.r = floor( colourAlpha.x - result.b*65536.0 - result.g*256.0);
    return result/255.0;
}

float getBrightness(vec3 colour)
{
    return max(max(colour.r, colour.g), colour.b);
}

void main()
{
    vec4  outlineSampleC = texture2D(u_sOutline, v_vSurfaceUV);
    float outlineAlphaL  = texture2D(u_sOutline, v_vSurfaceUV + vec2(u_vTexel.x, 0.0)).a;
    float outlineAlphaT  = texture2D(u_sOutline, v_vSurfaceUV + vec2(0.0, u_vTexel.y)).a;
    float outlineAlphaR  = texture2D(u_sOutline, v_vSurfaceUV - vec2(u_vTexel.x, 0.0)).a;
    float outlineAlphaB  = texture2D(u_sOutline, v_vSurfaceUV - vec2(0.0, u_vTexel.y)).a;
    
    float appSurfBrightness = getBrightness(texture2D(gm_BaseTexture, v_vTexcoord).rgb);
    
    gl_FragColor = vec4(0.0);
    
    if (outlineSampleC.a < 0.1)
    {
        if ((outlineAlphaL >= 0.1) || (outlineAlphaT >= 0.1) || (outlineAlphaR >= 0.1) || (outlineAlphaB >= 0.1))
        {
            if (appSurfBrightness < 0.5)
            {
                gl_FragColor = unpackGMColour(u_vOutlineColour);
            }
        }
    }
    else
    {
        gl_FragColor = outlineSampleC;
    }
}
