package shaders;

import flixel.system.FlxAssets.FlxShader;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.math.FlxAngle;
import flixel.graphics.frames.FlxFrame;
import openfl.display.BitmapData;

class GPUdeadEffect {
	public var shader(default, null):GPUdead = new GPUdead();

	public function new():Void {
		shader.iTime.value = [0];
	}

	public function update(elapsed:Float):Void {
		shader.iTime.value[0] += elapsed;
	}
	}

class GPUdead extends FlxShader {
@:glFragmentSource('
// Automatically converted with https://github.com/TheLeerName/ShadertoyToFlixel

#pragma header

#define iResolution vec3(openfl_TextureSize, 0.)
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D

// end of ShadertoyToFlixel header

#define R iResolution.xy

//Morton Code by Suslik
//https://www.shadertoy.com/view/NtVcDm

//0b0000dcba -> 0b0d0c0b0a
uint SpreadBits(uint x)
{
  x &= 0x0000ffffu;                   // x = ---- ---- ---- ---- fedc ba98 7654 3210
  x = (x ^ (x <<  8u)) & 0x00ff00ffu; // x = ---- ---- fedc ba98 ---- ---- 7654 3210
  x = (x ^ (x <<  4u)) & 0x0f0f0f0fu; // x = ---- fedc ---- ba98 ---- 7654 ---- 3210
  x = (x ^ (x <<  2u)) & 0x33333333u; // x = --fe --dc --ba --98 --76 --54 --32 --10
  x = (x ^ (x <<  1u)) & 0x55555555u; // x = -f-e -d-c -b-a -9-8 -7-6 -5-4 -3-2 -1-0
  return x;
}

//0b0d0c0b0a -> 0b0000dcba
uint GatherBits(uint x)
{
  x &= 0x55555555u;                   // x = -f-e -d-c -b-a -9-8 -7-6 -5-4 -3-2 -1-0
  x = (x ^ (x >>  1u)) & 0x33333333u; // x = --fe --dc --ba --98 --76 --54 --32 --10
  x = (x ^ (x >>  2u)) & 0x0f0f0f0fu; // x = ---- fedc ---- ba98 ---- 7654 ---- 3210
  x = (x ^ (x >>  4u)) & 0x00ff00ffu; // x = ---- ---- fedc ba98 ---- ---- 7654 3210
  x = (x ^ (x >>  8u)) & 0x0000ffffu; // x = ---- ---- ---- ---- fedc ba98 7654 3210
  return x;
}

//0bhgfedcba -> (0b0000geca, 0b0000hfdb)
uvec2 MortonToVec2(uint morton)
{

    uvec2 res;
    res.x = GatherBits(morton >> 0);
    res.y = GatherBits(morton >> 1);
    return res;
}

//(0b0000dcba, 0b0000hgfe) -> 0bhdgcfbea
uint Vec2ToMorton(uvec2 vec)
{
  return SpreadBits(vec.x) | (SpreadBits(vec.y) << 1);
}


float hash11(float u, float seed)
{
    return fract(sin(u)*999999.9999 + seed * 1.61803398875);
}

//Hash without Sine by Dave_Hoskins
//https://www.shadertoy.com/view/4djSRW
vec3 hash31(float p)
{
   vec3 p3 = fract(vec3(p) * vec3(.1031, .1030, .0973));
   p3 += dot(p3, p3.yzx+33.33);
   return fract((p3.xxy+p3.yzz)*p3.zyx); 
}

float noise(float u, float size, float seed)
{
    float zoom = u * size;
    float index = floor(zoom);
    float progress = fract(zoom);
    progress = smoothstep(0.0, 1.0, progress);
    float value = mix(hash11(index, seed), hash11(index + 1.0, seed), progress);
    return value;
}

float posterize(float u, float steps)
{
    return floor(u*steps + 0.5)/steps;
}

float threshold(float u, float edge)
{
    return u * step(edge, u);
}

void mainImage( out vec4 O, in vec2 fragCoord )
{   
    
    float i = float(Vec2ToMorton(uvec2(fragCoord)));
    
    float n1 = noise(i, 1e-3, floor(iTime*0.1619));
    n1 = posterize(n1, 4.0);
    n1 = threshold(n1, 0.7);
    
    float n2 = noise(i, 1e-5, floor(iTime*3.12349));
    n2 = posterize(n2, 20.0);
    n2 = threshold(n2, 0.9);
    
    float n3 = noise(i, 1e3, floor(iTime*0.12349));
    n3 = threshold(n3, 0.90);
    
    float n4 = noise(i, 0.01, floor(iTime*0.029)) * 1.0;
    
    i += n1 * 40.0 + n2 * 1000.0 + n3 * 100.0;
    
    vec2 uv = vec2(MortonToVec2(uint(i)))/R;
    vec3 col = mix(texture(iChannel0, uv).rgb, hash31(i), step(hash11(floor(iTime), 1.0) * 0.1 + 0.88, n4));
    
    vec4 tex = texture(iChannel0, uv);
    float alpha = tex.a;

    O = vec4(col, alpha);
}

void main() {
	mainImage(gl_FragColor, openfl_TextureCoordv*openfl_TextureSize);
}')

	public function new() {
		super();
	}
}

