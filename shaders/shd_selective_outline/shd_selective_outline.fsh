const float ALPHA_THRESHOLD      = 1.0/255.0;
const float BRIGHTNESS_THRESHOLD = 0.5;

varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying vec2 v_vSurfaceUV;

uniform sampler2D u_sSpriteSurface;
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
    vec4  spriteSample = texture2D(u_sSpriteSurface, v_vSurfaceUV);
    float spriteAlphaL = texture2D(u_sSpriteSurface, v_vSurfaceUV + vec2(u_vTexel.x, 0.0)).a;
    float spriteAlphaT = texture2D(u_sSpriteSurface, v_vSurfaceUV + vec2(0.0, u_vTexel.y)).a;
    float spriteAlphaR = texture2D(u_sSpriteSurface, v_vSurfaceUV - vec2(u_vTexel.x, 0.0)).a;
    float spriteAlphaB = texture2D(u_sSpriteSurface, v_vSurfaceUV - vec2(0.0, u_vTexel.y)).a;
    
    float appSurfBrightness = getBrightness(texture2D(gm_BaseTexture, v_vTexcoord).rgb);
    
    gl_FragColor = vec4(0.0);
    
    if (spriteSample.a < ALPHA_THRESHOLD)
    {
        if ((spriteAlphaL >= ALPHA_THRESHOLD)
        ||  (spriteAlphaT >= ALPHA_THRESHOLD)
        ||  (spriteAlphaR >= ALPHA_THRESHOLD)
        ||  (spriteAlphaB >= ALPHA_THRESHOLD))
        {
            if (appSurfBrightness < BRIGHTNESS_THRESHOLD)
            {
                gl_FragColor = unpackGMColour(u_vOutlineColour);
            }
        }
    }
    else
    {
        gl_FragColor = spriteSample;
    }
}
