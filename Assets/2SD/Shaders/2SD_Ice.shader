// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "2SD/Ice"
{
	Properties
	{
		[HideInInspector] __dirty( "", Int ) = 1
		[Header(Translucency)]
		_Translucency("Strength", Range( 0 , 50)) = 1
		_TransNormalDistortion("Normal Distortion", Range( 0 , 1)) = 0.1
		_TransScattering("Scaterring Falloff", Range( 1 , 50)) = 2
		_TransDirect("Direct", Range( 0 , 1)) = 1
		_TransAmbient("Ambient", Range( 0 , 1)) = 0.2
		_TransShadow("Shadow", Range( 0 , 1)) = 0.9
		_RimDensity("Rim Density", Range( 0.01 , 10)) = 0
		_rimmultiply("rim multiply", Float) = 0
		_normalbias("normal bias", Float) = 0
		_TransmissionMultiplier("Transmission Multiplier", Range( 0 , 5)) = 0
		_TransmissionColor("Transmission Color", Color) = (0,0,0,0)
		_snow_normal("snow_normal", 2D) = "bump" {}
		_normalstrength("normal strength", Range( 0 , 3)) = 1
		_smoothness("smoothness", Range( 0 , 1)) = 0
		_albedo("albedo", 2D) = "white" {}
		_Tint("Tint", Color) = (0,0,0,0)
		_Ice_01_metallic("Ice_01_metallic", 2D) = "white" {}
		_fresnelpower("fresnel power", Range( 0 , 3)) = 0
		_fresnelbias("fresnel bias", Range( 0 , 3)) = 0
		_noisescale("noise scale", Range( 1 , 10)) = 0
		_fresnelcolor("fresnel color", Color) = (0,0,0,0)
		_shardcontrasttranscluency("shard contrast transcluency", Range( 0 , 10)) = 0
		_shardcontrast_("shard contrast_", Range( 0 , 10)) = 0
		_shardopacity_("shard opacity_", Range( 0 , 1)) = 0
		_shardtranscluency("shard transcluency", Range( 0 , 1)) = 0
		_bubbletiling("bubble tiling", Range( 0 , 100)) = 10
		_ice_bubble_normal("ice_bubble_normal", 2D) = "bump" {}
		_BubbleStrength("Bubble Strength", Range( 0 , 3)) = 0
		_fresnelscale("fresnel scale", Range( 0 , 5)) = 0
		_fresnelmultiplier("fresnel multiplier", Range( 0 , 3)) = 0
		_mastertint("master tint", Color) = (1,1,1,0)
		_BubbleDepth("Bubble Depth", Range( 0 , 4)) = 0
		_Shardmask("Shard mask", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		GrabPass{ "GrabScreen0" }
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.5
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) fixed3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float2 texcoord_0;
			float3 viewDir;
			INTERNAL_DATA
			float4 screenPos;
			float3 worldPos;
			float3 worldNormal;
		};

		struct SurfaceOutputStandardCustom
		{
			fixed3 Albedo;
			fixed3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			fixed Alpha;
			fixed3 Transmission;
			fixed3 Translucency;
		};

		uniform float _normalstrength;
		uniform sampler2D _snow_normal;
		uniform float4 _snow_normal_ST;
		uniform float _BubbleStrength;
		uniform sampler2D _ice_bubble_normal;
		uniform float _bubbletiling;
		uniform float _BubbleDepth;
		uniform float _noisescale;
		uniform sampler2D GrabScreen0;
		uniform sampler2D _albedo;
		uniform float4 _albedo_ST;
		uniform float4 _Tint;
		uniform sampler2D _Shardmask;
		uniform float _shardopacity_;
		uniform float _shardcontrast_;
		uniform float4 _fresnelcolor;
		uniform float _fresnelbias;
		uniform float _fresnelscale;
		uniform float _fresnelpower;
		uniform float _fresnelmultiplier;
		uniform sampler2D _Ice_01_metallic;
		uniform float4 _Ice_01_metallic_ST;
		uniform float _RimDensity;
		uniform float _rimmultiply;
		uniform float _normalbias;
		uniform float4 _mastertint;
		uniform float _smoothness;
		uniform float4 _TransmissionColor;
		uniform float _TransmissionMultiplier;
		uniform half _Translucency;
		uniform half _TransNormalDistortion;
		uniform half _TransScattering;
		uniform half _TransDirect;
		uniform half _TransAmbient;
		uniform half _TransShadow;
		uniform float _shardcontrasttranscluency;
		uniform float _shardtranscluency;


		float3 mod289( float3 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 mod289( float4 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 permute( float4 x ) { return mod289( ( x * 34.0 + 1.0 ) * x ); }

		float4 taylorInvSqrt( float4 r ) { return 1.79284291400159 - r * 0.85373472095314; }

		float snoise( float3 v )
		{
			const float2 C = float2( 1.0 / 6.0, 1.0 / 3.0 );
			float3 i = floor( v + dot( v, C.yyy ) );
			float3 x0 = v - i + dot( i, C.xxx );
			float3 g = step( x0.yzx, x0.xyz );
			float3 l = 1.0 - g;
			float3 i1 = min( g.xyz, l.zxy );
			float3 i2 = max( g.xyz, l.zxy );
			float3 x1 = x0 - i1 + C.xxx;
			float3 x2 = x0 - i2 + C.yyy;
			float3 x3 = x0 - 0.5;
			i = mod289( i);
			float4 p = permute( permute( permute( i.z + float4( 0.0, i1.z, i2.z, 1.0 ) ) + i.y + float4( 0.0, i1.y, i2.y, 1.0 ) ) + i.x + float4( 0.0, i1.x, i2.x, 1.0 ) );
			float4 j = p - 49.0 * floor( p / 49.0 );  // mod(p,7*7)
			float4 x_ = floor( j / 7.0 );
			float4 y_ = floor( j - 7.0 * x_ );  // mod(j,N)
			float4 x = ( x_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 y = ( y_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 h = 1.0 - abs( x ) - abs( y );
			float4 b0 = float4( x.xy, y.xy );
			float4 b1 = float4( x.zw, y.zw );
			float4 s0 = floor( b0 ) * 2.0 + 1.0;
			float4 s1 = floor( b1 ) * 2.0 + 1.0;
			float4 sh = -step( h, 0.0 );
			float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
			float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;
			float3 g0 = float3( a0.xy, h.x );
			float3 g1 = float3( a0.zw, h.y );
			float3 g2 = float3( a1.xy, h.z );
			float3 g3 = float3( a1.zw, h.w );
			float4 norm = taylorInvSqrt( float4( dot( g0, g0 ), dot( g1, g1 ), dot( g2, g2 ), dot( g3, g3 ) ) );
			g0 *= norm.x;
			g1 *= norm.y;
			g2 *= norm.z;
			g3 *= norm.w;
			float4 m = max( 0.6 - float4( dot( x0, x0 ), dot( x1, x1 ), dot( x2, x2 ), dot( x3, x3 ) ), 0.0 );
			m = m* m;
			m = m* m;
			float4 px = float4( dot( x0, g0 ), dot( x1, g1 ), dot( x2, g2 ), dot( x3, g3 ) );
			return 42.0 * dot( m, px);
		}


		inline float4 TriplanarSampling( sampler2D topTexMap, sampler2D midTexMap, sampler2D botTexMap, float3 worldPos, float3 worldNormal, float falloff, float tilling, float vertex )
		{
			float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
			projNormal /= projNormal.x + projNormal.y + projNormal.z;
			float3 nsign = sign( worldNormal );
			half4 xNorm; half4 yNorm; half4 zNorm;
			if(vertex == 1){
			xNorm = ( tex2Dlod( topTexMap, float4((tilling * worldPos.zy * float2( nsign.x, 1.0 )).xy,0,0) ) );
			yNorm = ( tex2Dlod( topTexMap, float4((tilling * worldPos.zx).xy,0,0) ) );
			zNorm = ( tex2Dlod( topTexMap, float4((tilling * worldPos.xy * float2( -nsign.z, 1.0 )).xy,0,0) ) );
			} else {
			xNorm = ( tex2D( topTexMap, tilling * worldPos.zy * float2( nsign.x, 1.0 ) ) );
			yNorm = ( tex2D( topTexMap, tilling * worldPos.zx ) );
			zNorm = ( tex2D( topTexMap, tilling * worldPos.xy * float2( -nsign.z, 1.0 ) ) );
			}
			return xNorm* projNormal.x + yNorm* projNormal.y + zNorm* projNormal.z;
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 temp_cast_0 = (_bubbletiling).xx;
			o.texcoord_0.xy = v.texcoord.xy * temp_cast_0 + float2( 0,0 );
		}

		inline half4 LightingStandardCustom(SurfaceOutputStandardCustom s, half3 viewDir, UnityGI gi )
		{
			#if !DIRECTIONAL
			float3 lightAtten = gi.light.color;
			#else
			float3 lightAtten = lerp( _LightColor0, gi.light.color, _TransShadow );
			#endif
			half3 lightDir = gi.light.dir + s.Normal * _TransNormalDistortion;
			half transVdotL = pow( saturate( dot( viewDir, -lightDir ) ), _TransScattering );
			half3 translucency = lightAtten * (transVdotL * _TransDirect + gi.indirect.diffuse * _TransAmbient) * s.Translucency;
			half4 c = half4( s.Albedo * translucency * _Translucency, 0 );

			half3 transmission = max(0 , -dot(s.Normal, gi.light.dir)) * gi.light.color * s.Transmission;
			half4 d = half4(s.Albedo * transmission , 0);

			SurfaceOutputStandard r;
			r.Albedo = s.Albedo;
			r.Normal = s.Normal;
			r.Emission = s.Emission;
			r.Metallic = s.Metallic;
			r.Smoothness = s.Smoothness;
			r.Occlusion = s.Occlusion;
			r.Alpha = s.Alpha;
			return LightingStandard (r, viewDir, gi) + c + d;
		}

		inline void LightingStandardCustom_GI(SurfaceOutputStandardCustom s, UnityGIInput data, inout UnityGI gi )
		{
			UNITY_GI(gi, s, data);
		}

		void surf( Input i , inout SurfaceOutputStandardCustom o )
		{
			float2 uv_snow_normal = i.uv_texcoord * _snow_normal_ST.xy + _snow_normal_ST.zw;
			float3 tex2DNode6 = UnpackScaleNormal( tex2D( _snow_normal, uv_snow_normal ) ,_normalstrength );
			float3 tangentViewDir347 = i.viewDir;
			float2 Offset286 = ( ( 0.0 - 1.0 ) * tangentViewDir347.xy * _BubbleDepth ) + i.texcoord_0;
			float simplePerlin3D294 = snoise( float3( ( i.uv_texcoord * _noisescale ) ,  0.0 ) );
			float3 lerpResult293 = lerp( tex2DNode6 , BlendNormals( UnpackScaleNormal( tex2D( _ice_bubble_normal, Offset286 ) ,_BubbleStrength ) , tex2DNode6 ) , simplePerlin3D294);
			float3 normalizeResult419 = normalize( lerpResult293 );
			float3 endNormal428 = normalizeResult419;
			o.Normal = endNormal428;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPos461 = ase_screenPos;
			#if UNITY_UV_STARTS_AT_TOP
			float scale461 = -1.0;
			#else
			float scale461 = 1.0;
			#endif
			float halfPosW461 = ase_screenPos461.w * 0.5;
			ase_screenPos461.y = ( ase_screenPos461.y - halfPosW461 ) * _ProjectionParams.x* scale461 + halfPosW461;
			#ifdef UNITY_SINGLE_PASS_STEREO
			ase_screenPos461.xy = TransformStereoScreenSpaceTex(ase_screenPos461.xy, ase_screenPos461.w);
			#endif
			ase_screenPos461.xyzw /= ase_screenPos461.w;
			float2 componentMask462 = ase_screenPos461.xy;
			float3 baseNormal307 = tex2DNode6;
			float4 screenColor409 = tex2D( GrabScreen0, ( float3( componentMask462 ,  0.0 ) + ( baseNormal307 * 0.4 ) ).xy );
			float2 uv_albedo = i.uv_texcoord * _albedo_ST.xy + _albedo_ST.zw;
			float4 tex2DNode13 = tex2D( _albedo, uv_albedo );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float4 triplanar403 = TriplanarSampling( _Shardmask, _Shardmask, _Shardmask, ase_worldPos, ase_worldNormal, 1.0, 0.1, 0 );
			float2 _Vector0 = float2(0,0.5);
			float clampResult346 = clamp( pow( ( triplanar403.w * _shardopacity_ ) , _shardcontrast_ ) , _Vector0.x , _Vector0.y );
			float4 lerpResult261 = lerp( ( tex2DNode13 * _Tint ) , float4(1,1,1,0) , clampResult346);
			float3 worldViewDir = normalize( UnityWorldSpaceViewDir( i.worldPos ) );
			float3 normalizeResult362 = normalize( WorldNormalVector( i , baseNormal307 ) );
			float fresnelFinalVal269 = (_fresnelbias + _fresnelscale*pow( 1.0 - dot( normalizeResult362, worldViewDir ) , _fresnelpower));
			float4 lerpResult276 = lerp( lerpResult261 , _fresnelcolor , ( fresnelFinalVal269 * _fresnelmultiplier ));
			float2 uv_Ice_01_metallic = i.uv_texcoord * _Ice_01_metallic_ST.xy + _Ice_01_metallic_ST.zw;
			float4 tex2DNode61 = tex2D( _Ice_01_metallic, uv_Ice_01_metallic );
			float thickness360 = tex2DNode61.g;
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 transform282 = mul(unity_ObjectToWorld,float4( ase_vertex3Pos , 0.0 ));
			float3 componentMask435 = transform282.xyz;
			float dotResult228 = dot( BlendNormals( tex2DNode6 , componentMask435 ) , worldViewDir );
			float endViewMask246 = saturate( ( 1.0 - (0.0 + (( 1.0 - pow( ( dotResult228 * _rimmultiply ) , _normalbias ) ) - 0.0) * (1.0 - 0.0) / (0.2 - 0.0)) ) );
			float4 lerpResult372 = lerp( lerpResult276 , _fresnelcolor , saturate( ( thickness360 - ( _RimDensity * endViewMask246 ) ) ));
			float clampResult358 = clamp( ( clampResult346 + saturate( ( _RimDensity * endViewMask246 ) ) ) , 0.6 , 1.0 );
			float4 lerpResult391 = lerp( ( lerpResult372 * (0.9 + (clampResult358 - 0.6) * (1.0 - 0.9) / (1.0 - 0.6)) ) , float4(1,1,1,0) , ( 1.0 - ( clampResult346 + saturate( ( _RimDensity * endViewMask246 ) ) ) ));
			float finalOpacity407 = saturate( clampResult358 );
			float4 lerpResult410 = lerp( screenColor409 , ( lerpResult391 * _mastertint ) , finalOpacity407);
			float4 endAlbedo430 = lerpResult410;
			o.Albedo = endAlbedo430.rgb;
			o.Metallic = tex2DNode61.r;
			float endSmoothness376 = ( tex2DNode61.a * _smoothness );
			o.Smoothness = ( endSmoothness376 - clampResult346 );
			float endAO425 = tex2DNode13.a;
			o.Occlusion = endAO425;
			float4 endTransmission399 = ( _TransmissionColor * _TransmissionMultiplier );
			o.Transmission = endTransmission399.rgb;
			float lerpResult327 = lerp( thickness360 , ( thickness360 - pow( triplanar403.w , _shardcontrasttranscluency ) ) , _shardtranscluency);
			float endTranscluency400 = lerpResult327;
			float3 temp_cast_8 = (endTranscluency400).xxx;
			o.Translucency = temp_cast_8;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma only_renderers d3d9 d3d11 glcore gles gles3 d3d11_9x 
		#pragma surface surf StandardCustom keepalpha fullforwardshadows exclude_path:deferred vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			# include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float3 worldPos : TEXCOORD6;
				float4 tSpace0 : TEXCOORD1;
				float4 tSpace1 : TEXCOORD2;
				float4 tSpace2 : TEXCOORD3;
				float4 texcoords01 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				fixed3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				fixed tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				fixed3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.texcoords01 = float4( v.texcoord.xy, v.texcoord1.xy );
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			fixed4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord.xy = IN.texcoords01.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				fixed3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.viewDir = IN.tSpace0.xyz * worldViewDir.x + IN.tSpace1.xyz * worldViewDir.y + IN.tSpace2.xyz * worldViewDir.z;
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandardCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandardCustom, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=12101
-1913;58;1906;1004;3028.35;3079.846;5.8;True;True
Node;AmplifyShaderEditor.CommentaryNode;253;-1229.757,1166.993;Float;False;2681.93;700.3283;Rim;16;282;227;230;150;246;252;244;243;233;242;234;232;228;245;435;436;;1,1,1,1;0;0
Node;AmplifyShaderEditor.PosVertexDataNode;230;-1200.731,1388.192;Float;False;0;0;5;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;8;-1711.3,346.1;Float;False;Property;_normalstrength;normal strength;14;0;1;0;3;0;1;FLOAT
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;282;-911.6226,1380.292;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.ComponentMaskNode;435;-681.8517,1399.75;Float;False;True;True;True;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT3
Node;AmplifyShaderEditor.SamplerNode;6;-1309.299,296.0999;Float;True;Property;_snow_normal;snow_normal;13;0;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;227;-1095.331,1586.593;Float;False;World;0;4;FLOAT3;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.BlendNormalsNode;245;-438.6259,1378.49;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3
Node;AmplifyShaderEditor.DotProductOpNode;228;-194.5267,1423.593;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;232;-73.42488,1522.592;Float;False;Property;_rimmultiply;rim multiply;9;0;0;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;242;137.672,1420.391;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;234;135.774,1548.692;Float;False;Property;_normalbias;normal bias;10;0;0;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.PowerNode;233;332.0737,1421.793;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.OneMinusNode;243;537.6719,1432.793;Float;False;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.TFHCRemap;244;757.6731,1421.892;Float;False;5;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.2;False;3;FLOAT;0.0;False;4;FLOAT;1.0;False;1;FLOAT
Node;AmplifyShaderEditor.TexturePropertyNode;404;696.7424,-1239.543;Float;True;Property;_Shardmask;Shard mask;35;0;None;False;white;Auto;0;1;SAMPLER2D
Node;AmplifyShaderEditor.OneMinusNode;252;953.277,1467.589;Float;False;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;405;743.7429,-1047.743;Float;False;Constant;_Float1;Float 1;38;0;0.1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SaturateNode;436;1080.748,1336.15;Float;False;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;311;1377.084,-963.4078;Float;False;Property;_shardopacity_;shard opacity_;26;0;0;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.RegisterLocalVarNode;307;-423.8998,304.9001;Float;False;baseNormal;-1;True;1;0;FLOAT3;0.0;False;1;FLOAT3
Node;AmplifyShaderEditor.GetLocalVarNode;308;2232.086,-1003.407;Float;False;307;0;1;FLOAT3
Node;AmplifyShaderEditor.TriplanarNode;403;1014.242,-1232.243;Float;True;Spherical;World;False;Top Texture 0;_TopTexture0;white;0;None;Mid Texture 0;_MidTexture0;white;-1;None;Bot Texture 0;_BotTexture0;white;-1;None;Triplanar Sampler;5;0;SAMPLER2D;;False;1;SAMPLER2D;;False;2;SAMPLER2D;;False;3;FLOAT;1.0;False;4;FLOAT;1.0;False;5;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;310;1626.184,-1194.308;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;21;1847.201,-648.9997;Float;False;Property;_RimDensity;Rim Density;8;0;0;0.01;10;0;1;FLOAT
Node;AmplifyShaderEditor.GetLocalVarNode;247;1904.801,-522.6;Float;False;246;0;1;FLOAT
Node;AmplifyShaderEditor.RegisterLocalVarNode;246;1197.175,1409.791;Float;False;endViewMask;-1;True;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.WorldNormalVector;338;2482.587,-998.4115;Float;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;332;1516.488,-878.6104;Float;False;Property;_shardcontrast_;shard contrast_;25;0;0;0;10;0;1;FLOAT
Node;AmplifyShaderEditor.Vector2Node;421;1993.745,-1155.546;Float;False;Constant;_Vector0;Vector 0;30;0;0,0.5;0;3;FLOAT2;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;13;1479.198,-1687.001;Float;True;Property;_albedo;albedo;16;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;2247.201,-648.9997;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;1.0;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;279;2572.283,-700.3082;Float;False;Property;_fresnelpower;fresnel power;20;0;0;0;3;0;1;FLOAT
Node;AmplifyShaderEditor.ColorNode;62;1530.499,-1486.101;Float;False;Property;_Tint;Tint;17;0;0,0,0,0;0;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.PowerNode;333;1824.488,-1206.61;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;335;2599.589,-771.5119;Float;False;Property;_fresnelscale;fresnel scale;31;0;0;0;5;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;273;2608.283,-858.7093;Float;False;Property;_fresnelbias;fresnel bias;21;0;0;0;3;0;1;FLOAT
Node;AmplifyShaderEditor.SamplerNode;61;702.2001,160.201;Float;True;Property;_Ice_01_metallic;Ice_01_metallic;18;0;Assets/2SD/Terrain Textures/Mountain Range/Ice 01/Ice_01_metallic.png;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.NormalizeNode;362;2701.284,-933.6099;Float;False;1;0;FLOAT3;0.0,0,0,0;False;1;FLOAT3
Node;AmplifyShaderEditor.ColorNode;359;2114.986,-1361.109;Float;False;Constant;_Color0;Color 0;35;0;1,1,1,0;0;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.ClampOpNode;346;2236.589,-1153.31;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.5;False;1;FLOAT
Node;AmplifyShaderEditor.GetLocalVarNode;383;3479.139,-937.545;Float;False;360;0;1;FLOAT
Node;AmplifyShaderEditor.SaturateNode;416;3710.646,-621.3464;Float;False;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;340;2898.389,-691.8113;Float;False;Property;_fresnelmultiplier;fresnel multiplier;32;0;0;0;3;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;2110.701,-1617.8;Float;False;2;2;0;FLOAT4;0.0;False;1;COLOR;0.0,0,0,0;False;1;FLOAT4
Node;AmplifyShaderEditor.RegisterLocalVarNode;360;1399.085,246.5909;Float;False;thickness;-1;True;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.FresnelNode;269;2961.282,-854.3107;Float;False;4;0;FLOAT3;0,0,0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;3;FLOAT;1.0;False;1;FLOAT
Node;AmplifyShaderEditor.LerpOp;261;2413.082,-1281.01;Float;False;3;0;FLOAT4;0,0,0,0;False;1;COLOR;0.0,0,0,0;False;2;FLOAT;0.0;False;1;COLOR
Node;AmplifyShaderEditor.SimpleSubtractOpNode;384;3718.24,-906.6448;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;343;3209.789,-852.1113;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.ColorNode;275;3170.881,-1057.909;Float;False;Property;_fresnelcolor;fresnel color;23;0;0,0,0,0;0;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;355;3963.485,-681.4084;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;289;-2322.1,-119.9;Float;False;Property;_bubbletiling;bubble tiling;28;0;10;0;100;0;1;FLOAT
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;291;-2040.4,886.6002;Float;False;Tangent;0;4;FLOAT3;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.ClampOpNode;358;4209.891,-828.0081;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.6;False;2;FLOAT;1.0;False;1;FLOAT
Node;AmplifyShaderEditor.RegisterLocalVarNode;347;-1832.4,886.6002;Float;False;tangentViewDir;-1;True;1;0;FLOAT3;0.0;False;1;FLOAT3
Node;AmplifyShaderEditor.LerpOp;276;3682.782,-1106.609;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.0;False;1;COLOR
Node;AmplifyShaderEditor.SaturateNode;417;3889.544,-907.3472;Float;False;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.TextureCoordinatesNode;290;-1997.299,-135.9;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.CommentaryNode;463;5040.349,-1627.646;Float;False;889.6924;430.5002;Refraction;7;461;438;443;442;441;409;462;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;348;-1997.299,200.0999;Float;False;347;0;1;FLOAT3
Node;AmplifyShaderEditor.RangedFloatNode;350;-2029.299,24.1;Float;False;Property;_BubbleDepth;Bubble Depth;34;0;0;0;4;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;443;5132.349,-1316.549;Float;False;Constant;_Float2;Float 2;30;0;0.4;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.GrabScreenPosition;461;5106.95,-1577.646;Float;False;0;0;5;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.GetLocalVarNode;438;5090.349,-1399.549;Float;False;307;0;1;FLOAT3
Node;AmplifyShaderEditor.TFHCRemap;387;4566.739,-834.2446;Float;False;5;0;FLOAT;0.0;False;1;FLOAT;0.6;False;2;FLOAT;1.0;False;3;FLOAT;0.9;False;4;FLOAT;1.0;False;1;FLOAT
Node;AmplifyShaderEditor.LerpOp;372;4049.385,-1039.109;Float;False;3;0;COLOR;0.0;False;1;COLOR;0.0,0,0,0;False;2;FLOAT;0.0;False;1;COLOR
Node;AmplifyShaderEditor.RangedFloatNode;288;-1693.3,120.0999;Float;False;Property;_BubbleStrength;Bubble Strength;30;0;0;0;3;0;1;FLOAT
Node;AmplifyShaderEditor.ParallaxMappingNode;286;-1661.299,-55.89999;Float;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT3;0,0,0;False;1;FLOAT2
Node;AmplifyShaderEditor.TexCoordVertexDataNode;295;-1416.899,537.9;Float;False;0;2;0;5;FLOAT2;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;306;-1416.899,681.9;Float;False;Property;_noisescale;noise scale;22;0;0;1;10;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;322;1782.088,820.2911;Float;False;Property;_shardcontrasttranscluency;shard contrast transcluency;24;0;0;0;10;0;1;FLOAT
Node;AmplifyShaderEditor.ComponentMaskNode;462;5334.852,-1575.047;Float;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;442;5354.349,-1358.549;Float;False;2;2;0;FLOAT3;0.0;False;1;FLOAT;0,0;False;1;FLOAT3
Node;AmplifyShaderEditor.SamplerNode;284;-1341.299,-7.900011;Float;True;Property;_ice_bubble_normal;ice_bubble_normal;29;0;Assets/2SD/Terrain Textures/Mountain Range/Ice 01/ice_bubble_normal.png;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;379;4867.033,-1035.745;Float;False;2;2;0;COLOR;0.0;False;1;FLOAT;0.0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.ColorNode;389;4870.03,-933.1447;Float;False;Constant;_Color1;Color 1;34;0;1,1,1,0;0;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.OneMinusNode;388;4567.543,-661.345;Float;False;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;305;-1118.899,594.9;Float;False;2;2;0;FLOAT2;0.0;False;1;FLOAT;0.0,0;False;1;FLOAT2
Node;AmplifyShaderEditor.PowerNode;321;2135.487,722.8912;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.GetLocalVarNode;432;2096.15,625.2489;Float;False;360;0;1;FLOAT
Node;AmplifyShaderEditor.LerpOp;391;5339.536,-920.4448;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0.0,0,0,0;False;2;FLOAT;0.0;False;1;COLOR
Node;AmplifyShaderEditor.CommentaryNode;397;3304.701,528.9553;Float;False;871.001;358.4448;Comment;4;399;4;375;1;Transmission;1,1,1,1;0;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;294;-929.9001,601.9;Float;False;Simplex3D;1;0;FLOAT3;0,0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;441;5520.349,-1405.549;Float;False;2;2;0;FLOAT2;0.0,0;False;1;FLOAT3;0.0;False;1;FLOAT3
Node;AmplifyShaderEditor.CommentaryNode;398;2338.39,531.1907;Float;False;888.9985;354.6002;Comment;5;400;327;328;325;361;Transcluency;1,1,1,1;0;0
Node;AmplifyShaderEditor.SaturateNode;424;4334.85,-952.6456;Float;False;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.ColorNode;395;5273.541,-781.2435;Float;False;Property;_mastertint;master tint;33;0;1,1,1,0;0;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.BlendNormalsNode;287;-956.8999,109.1;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3
Node;AmplifyShaderEditor.RangedFloatNode;10;739.7996,399.5001;Float;False;Property;_smoothness;smoothness;15;0;0;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;1;3354.701,785.4001;Float;False;Property;_TransmissionMultiplier;Transmission Multiplier;11;0;0;0;5;0;1;FLOAT
Node;AmplifyShaderEditor.ScreenColorNode;409;5721.042,-1404.146;Float;False;Global;GrabScreen0;Grab Screen 0;33;0;Object;-1;1;0;FLOAT2;0,0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;328;2388.39,765.791;Float;False;Property;_shardtranscluency;shard transcluency;27;0;0;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;1102,364.2007;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.GetLocalVarNode;361;2503.085,581.1908;Float;False;360;0;1;FLOAT
Node;AmplifyShaderEditor.ColorNode;375;3417.94,578.9553;Float;False;Property;_TransmissionColor;Transmission Color;12;0;0,0,0,0;0;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.LerpOp;293;-664.5001,112.1;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0.0,0,0;False;2;FLOAT;0,0,0;False;1;FLOAT3
Node;AmplifyShaderEditor.RegisterLocalVarNode;407;4533.744,-962.3438;Float;False;finalOpacity;-1;True;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;396;5633.942,-783.1443;Float;False;2;2;0;COLOR;0.0;False;1;COLOR;0.0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.SimpleSubtractOpNode;325;2486.29,652.4911;Float;False;2;0;FLOAT;0,0,0,0;False;1;FLOAT;0.0,0,0,0;False;1;FLOAT
Node;AmplifyShaderEditor.GetLocalVarNode;408;5588.148,-665.3433;Float;False;407;0;1;FLOAT
Node;AmplifyShaderEditor.RegisterLocalVarNode;376;1377.539,363.8552;Float;False;endSmoothness;-1;True;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.LerpOp;410;5897.443,-821.8459;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0.0,0,0,0;False;2;FLOAT;0.0;False;1;COLOR
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;3713.702,693.0002;Float;False;2;2;0;COLOR;0.0;False;1;FLOAT;0.0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.CommentaryNode;270;995.4811,-2494.911;Float;False;1093.26;378.1803;Parallax;6;257;256;349;268;258;345;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;427;2110.048,-1792.149;Float;False;293.0001;165;Ambient Occlusion;1;425;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;377;4044.735,180.355;Float;False;376;0;1;FLOAT
Node;AmplifyShaderEditor.LerpOp;327;2747.388,620.991;Float;False;3;0;FLOAT;0,0,0,0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.NormalizeNode;419;-401.3557,112.0533;Float;False;1;0;FLOAT3;0,0,0,0;False;1;FLOAT3
Node;AmplifyShaderEditor.ParallaxMappingNode;256;1534.179,-2434.109;Float;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT3;0,0,0;False;1;FLOAT2
Node;AmplifyShaderEditor.RegisterLocalVarNode;399;3933.642,703.2565;Float;False;endTransmission;-1;True;1;0;COLOR;0.0;False;1;COLOR
Node;AmplifyShaderEditor.RegisterLocalVarNode;428;-133.0518,113.9509;Float;False;endNormal;-1;True;1;0;FLOAT3;0.0;False;1;FLOAT3
Node;AmplifyShaderEditor.RegisterLocalVarNode;345;1859.788,-2443.409;Float;False;paralaxUV;-1;True;1;0;FLOAT2;0.0;False;1;FLOAT2
Node;AmplifyShaderEditor.GetLocalVarNode;349;1232.789,-2209.508;Float;False;347;0;1;FLOAT3
Node;AmplifyShaderEditor.RegisterLocalVarNode;400;2983.442,641.0562;Float;False;endTranscluency;-1;True;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleSubtractOpNode;381;4396.444,191.7535;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.RegisterLocalVarNode;430;6143.247,-822.9489;Float;False;endAlbedo;-1;True;1;0;COLOR;0.0;False;1;COLOR
Node;AmplifyShaderEditor.RangedFloatNode;258;1193.079,-2316.109;Float;False;Property;_shardscale;shard scale;19;0;1.290659;0;3;0;1;FLOAT
Node;AmplifyShaderEditor.TextureCoordinatesNode;257;1198.479,-2451.01;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.GetLocalVarNode;426;5397.549,214.8516;Float;False;425;0;1;FLOAT
Node;AmplifyShaderEditor.RegisterLocalVarNode;425;2160.048,-1742.149;Float;False;endAO;-1;True;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.RegisterLocalVarNode;150;1190.266,1232.993;Float;False;mydebug;-1;True;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.GetLocalVarNode;429;5374.448,60.75107;Float;False;428;0;1;FLOAT3
Node;AmplifyShaderEditor.GetLocalVarNode;402;5333.942,390.4561;Float;False;400;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;268;1037.281,-2442.31;Float;False;Constant;_Float0;Float 0;30;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.GetLocalVarNode;431;5366.948,-38.34888;Float;False;430;0;1;COLOR
Node;AmplifyShaderEditor.GetLocalVarNode;401;5327.942,305.9563;Float;False;399;0;1;COLOR
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;5752.099,52.59998;Float;False;True;3;Float;ASEMaterialInspector;0;Standard;2SD/Ice;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;5;1;Opaque;0.5;True;True;0;False;Opaque;Geometry;ForwardOnly;True;True;True;True;True;False;True;False;False;False;False;False;False;True;True;True;True;False;0;255;255;0;0;0;0;False;0;4;10;25;False;0.5;True;0;SrcAlpha;OneMinusSrcAlpha;0;SrcAlpha;OneMinusSrcAlpha;Add;Add;0;False;0;0,0,0,0;VertexOffset;False;Cylindrical;False;Relative;0;;-1;1;-1;-1;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;OBJECT;0.0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;282;0;230;0
WireConnection;435;0;282;0
WireConnection;6;5;8;0
WireConnection;245;0;6;0
WireConnection;245;1;435;0
WireConnection;228;0;245;0
WireConnection;228;1;227;0
WireConnection;242;0;228;0
WireConnection;242;1;232;0
WireConnection;233;0;242;0
WireConnection;233;1;234;0
WireConnection;243;0;233;0
WireConnection;244;0;243;0
WireConnection;252;0;244;0
WireConnection;436;0;252;0
WireConnection;307;0;6;0
WireConnection;403;0;404;0
WireConnection;403;3;405;0
WireConnection;310;0;403;4
WireConnection;310;1;311;0
WireConnection;246;0;436;0
WireConnection;338;0;308;0
WireConnection;20;0;21;0
WireConnection;20;1;247;0
WireConnection;333;0;310;0
WireConnection;333;1;332;0
WireConnection;362;0;338;0
WireConnection;346;0;333;0
WireConnection;346;1;421;1
WireConnection;346;2;421;2
WireConnection;416;0;20;0
WireConnection;60;0;13;0
WireConnection;60;1;62;0
WireConnection;360;0;61;2
WireConnection;269;0;362;0
WireConnection;269;1;273;0
WireConnection;269;2;335;0
WireConnection;269;3;279;0
WireConnection;261;0;60;0
WireConnection;261;1;359;0
WireConnection;261;2;346;0
WireConnection;384;0;383;0
WireConnection;384;1;20;0
WireConnection;343;0;269;0
WireConnection;343;1;340;0
WireConnection;355;0;346;0
WireConnection;355;1;416;0
WireConnection;358;0;355;0
WireConnection;347;0;291;0
WireConnection;276;0;261;0
WireConnection;276;1;275;0
WireConnection;276;2;343;0
WireConnection;417;0;384;0
WireConnection;290;0;289;0
WireConnection;387;0;358;0
WireConnection;372;0;276;0
WireConnection;372;1;275;0
WireConnection;372;2;417;0
WireConnection;286;0;290;0
WireConnection;286;2;350;0
WireConnection;286;3;348;0
WireConnection;462;0;461;0
WireConnection;442;0;438;0
WireConnection;442;1;443;0
WireConnection;284;1;286;0
WireConnection;284;5;288;0
WireConnection;379;0;372;0
WireConnection;379;1;387;0
WireConnection;388;0;355;0
WireConnection;305;0;295;0
WireConnection;305;1;306;0
WireConnection;321;0;403;4
WireConnection;321;1;322;0
WireConnection;391;0;379;0
WireConnection;391;1;389;0
WireConnection;391;2;388;0
WireConnection;294;0;305;0
WireConnection;441;0;462;0
WireConnection;441;1;442;0
WireConnection;424;0;358;0
WireConnection;287;0;284;0
WireConnection;287;1;6;0
WireConnection;409;0;441;0
WireConnection;9;0;61;4
WireConnection;9;1;10;0
WireConnection;293;0;6;0
WireConnection;293;1;287;0
WireConnection;293;2;294;0
WireConnection;407;0;424;0
WireConnection;396;0;391;0
WireConnection;396;1;395;0
WireConnection;325;0;432;0
WireConnection;325;1;321;0
WireConnection;376;0;9;0
WireConnection;410;0;409;0
WireConnection;410;1;396;0
WireConnection;410;2;408;0
WireConnection;4;0;375;0
WireConnection;4;1;1;0
WireConnection;327;0;361;0
WireConnection;327;1;325;0
WireConnection;327;2;328;0
WireConnection;419;0;293;0
WireConnection;256;0;257;0
WireConnection;256;2;258;0
WireConnection;256;3;349;0
WireConnection;399;0;4;0
WireConnection;428;0;419;0
WireConnection;345;0;256;0
WireConnection;400;0;327;0
WireConnection;381;0;377;0
WireConnection;381;1;346;0
WireConnection;430;0;410;0
WireConnection;257;0;268;0
WireConnection;425;0;13;4
WireConnection;150;0;436;0
WireConnection;0;0;431;0
WireConnection;0;1;429;0
WireConnection;0;3;61;1
WireConnection;0;4;381;0
WireConnection;0;5;426;0
WireConnection;0;6;401;0
WireConnection;0;7;402;0
ASEEND*/
//CHKSM=F09997290FC85A36B27A85CDD4471289A09D5F16