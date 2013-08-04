// geometry outline GLSL shader

#include "include/uniforms.glsl"
#ifdef APPLY_FOG
#include "include/fog.glsl"
#endif

#ifdef VERTEX_SHADER

#include "include/attributes.glsl"
#include "include/vtransform.glsl"

uniform float u_OutlineHeight;

void main(void)
{
	vec4 Position = a_Position;
	vec3 Normal = a_Normal;
	vec2 TexCoord = a_TexCoord;
	myhalf4 inColor = myhalf4(a_Color);

	TransformVerts(Position, Normal, TexCoord);

	Position += vec4(Normal * u_OutlineHeight, 0.0);
	gl_Position = u_ModelViewProjectionMatrix * Position;

	myhalf4 outColor = inColor;

#ifdef APPLY_FOG
	myhalf4 tempColor = myhalf4(1.0);
	FogGen(Position, tempColor, myhalf2(0.0, 1.0));
	outColor.rgb = mix(u_Fog.Color, outColor.rgb, tempColor.a);
#endif

	gl_FrontColor = vec4(outColor);
}

#endif // VERTEX_SHADER


#ifdef FRAGMENT_SHADER
// Fragment shader

uniform float u_OutlineCutOff;

void main(void)
{
#ifdef APPLY_OUTLINES_CUTOFF
	if (u_OutlineCutOff > 0.0 && (gl_FragCoord.z / gl_FragCoord.w > u_OutlineCutOff))
	discard;
#endif
	gl_FragColor = vec4(gl_Color);
}

#endif // FRAGMENT_SHADER

