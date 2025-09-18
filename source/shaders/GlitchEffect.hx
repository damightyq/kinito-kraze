package shaders;

import flixel.system.FlxAssets.FlxShader;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.math.FlxAngle;
import flixel.graphics.frames.FlxFrame;
import openfl.display.BitmapData;

class GlitchEffect {
	public var shader(default, null):GlitchShader = new GlitchShader();

	public function new():Void {
		shader.iTime.value = [0];
	}

	public function update(elapsed:Float):Void {
		shader.iTime.value[0] += elapsed;
	}
		public function updateFrameInfo(frame:FlxFrame)
		{
			// NOTE: uv.width is actually the right pos and uv.height is the bottom pos
			shader.uFrameBounds.value = [frame.uv.x, frame.uv.y, frame.uv.width, frame.uv.height];
		}
	}

class GlitchShader extends FlxShader {
@:glFragmentSource('
#pragma header

#define iResolution vec3(openfl_TextureSize, 0.)
uniform float iTime;
uniform vec4 uFrameBounds; // (left, top, right, bottom)

#define iChannel0 bitmap
#define texture flixel_texture2D

float random(float seed) {
    return fract(543.2543 * sin(dot(vec2(seed, seed), vec2(3525.46, -54.3415))));
}

bool isWithinFrameBounds(vec2 uv) {
    return uv.x > uFrameBounds.x && uv.y > uFrameBounds.y && uv.x < uFrameBounds.z && uv.y < uFrameBounds.w;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord.xy / iResolution.xy;

    vec4 pixel_color = texture(iChannel0, uv);

    if (isWithinFrameBounds(uv)) {
			float shake_power = 0.025;
			float shake_rate = 1.0; // Adjusted
			float shake_speed = 1.0;
			float shake_block_size = 16.0;
			float shake_color_rate = 0.005;


        float enable_shift = float(
            random(floor(iTime * shake_speed)) < shake_rate
        );

        vec2 fixed_uv = uv;
        fixed_uv.x += (
            random(
                (floor(uv.y * shake_block_size) / shake_block_size)
            +   iTime
            ) - 0.5
        ) * shake_power * enable_shift;

        pixel_color = texture(iChannel0, fixed_uv);

        pixel_color.r = mix(
            pixel_color.r,
            texture(iChannel0, fixed_uv + vec2(shake_color_rate, 0.0)).r,
            enable_shift
        );

        pixel_color.b = mix(
            pixel_color.b,
            texture(iChannel0, fixed_uv + vec2(-shake_color_rate, 0.0)).b,
            enable_shift
        );
    }

    fragColor = pixel_color;
}

void main() {
	mainImage(gl_FragColor, openfl_TextureCoordv * openfl_TextureSize);
}
')

	public function new() {
		super();
	}
}

