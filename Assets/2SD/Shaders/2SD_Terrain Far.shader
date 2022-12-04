// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "2SD/2SD_Terrain_Far"
{
	Properties
	{
		[Header(BlendTextureArrayFunction)]
		[Header(BlendTextureArrayNormalFunction)]
		_AlbedoArray("Albedo Array", 2DArray) = "white" {}
		_NormalArray("Normal Array", 2DArray) = "white" {}
		_HeightArray("Height Array", 2DArray) = "white" {}
		_normalScale("normalScale", Range( 0 , 1)) = 1
		_normalscalefar("normal scale far", Range( 0 , 1)) = 1
		_Control("Control", 2D) = "white" {}
		[Normal]_globalnormal("global normal", 2D) = "bump" {}
		_globalnormalstrength("global normal strength", Range( -1 , 1)) = 0
		_closeglobalnormal("close global normal", Range( 0 , 1)) = 1
		_globalcolor("global color", 2D) = "white" {}
		_GlobalColorMultiplier("Global Color Multiplier", Range( 0 , 1)) = 0.85
		_GlobalColorDetail0("GlobalColorDetail0", Range( 0 , 1)) = 1
		_GlobalColorDetail1("GlobalColorDetail1", Range( 0 , 1)) = 1
		_GlobalColorDetail2("GlobalColorDetail2", Range( 0 , 1)) = 1
		_GlobalColorDetail3("GlobalColorDetail3", Range( 0 , 1)) = 1
		_grungemap("grunge map", 2D) = "white" {}
		_Tiling("Tiling", Range( 1 , 256)) = 128
		_uvmultiplier("uv multiplier", Float) = 2
		_smoothness("smoothness", Range( 0 , 1)) = 1
		_globalColorFarMultiplier("globalColorFarMultiplier", Range( 0 , 1)) = 0.9
		_smoothnessmin("smoothness min", Range( 0 , 1)) = 0
		_smoothnessmax("smoothness max", Range( 0 , 1)) = 1
		_combined("combined", 2D) = "bump" {}
		_AOStrength("AO Strength", Range( 0 , 1)) = 1
		_Snowfakeedgestrength("Snow fake edge strength", Range( 0 , 3)) = 1
		_heightstrength("height strength", Range( 0 , 0.999)) = 0.536
		_heightBoost("heightBoost", Range( 1 , 10)) = 4.26
		_colormapuvextra("colormap uv extra", Range( 0 , 0.01)) = 0
		_CameraDistanceVeryClose("Camera Distance Very Close", Float) = 30
		_CameraDistanceClose("Camera Distance Close", Float) = 50
		_CameraDistanceMid("Camera Distance Mid", Float) = 80
		_CameraDistanceTransition("Camera Distance Transition", Float) = 30
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#pragma target 3.5
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows noforwardadd vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float eyeDepth;
		};

		uniform sampler2D _Control;
		uniform float4 _Control_ST;
		uniform UNITY_DECLARE_TEX2DARRAY( _HeightArray );
		uniform float _Tiling;
		uniform float _CameraDistanceVeryClose;
		uniform float _CameraDistanceClose;
		uniform float _CameraDistanceTransition;
		uniform float _CameraDistanceMid;
		uniform float _heightBoost;
		uniform float _heightstrength;
		uniform sampler2D _combined;
		uniform float _Snowfakeedgestrength;
		uniform UNITY_DECLARE_TEX2DARRAY( _NormalArray );
		uniform float _uvmultiplier;
		uniform float _normalScale;
		uniform float _normalscalefar;
		uniform float _globalnormalstrength;
		uniform sampler2D _globalnormal;
		uniform float4 _globalnormal_ST;
		uniform float _closeglobalnormal;
		uniform sampler2D _grungemap;
		uniform UNITY_DECLARE_TEX2DARRAY( _AlbedoArray );
		uniform sampler2D _globalcolor;
		uniform float _colormapuvextra;
		uniform float _GlobalColorDetail0;
		uniform float _GlobalColorDetail1;
		uniform float _GlobalColorDetail2;
		uniform float _GlobalColorDetail3;
		uniform float _GlobalColorMultiplier;
		uniform float _globalColorFarMultiplier;
		uniform float _smoothness;
		uniform float _smoothnessmin;
		uniform float _smoothnessmax;
		uniform float _AOStrength;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			o.eyeDepth = -UnityObjectToViewPos( v.vertex.xyz ).z;
			float3 localTangentHack20922092 = ( float3( 0,0,0 ) );
			v.tangent.xyz = cross(v.normal, float3(0,0,1));
						v.tangent.w = -1  ;
			v.vertex.xyz += localTangentHack20922092;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Control = i.uv_texcoord * _Control_ST.xy + _Control_ST.zw;
			float4 tex2DNode2 = tex2D( _Control, uv_Control );
			float4 splats1250 = tex2DNode2;
			float temp_output_5_0_g1717 = 0.0;
			float baseuvtiling400 = _Tiling;
			float2 temp_cast_0 = (baseuvtiling400).xx;
			float2 uv_TexCoord2451 = i.uv_texcoord * temp_cast_0 + float2( 0,0 );
			int temp_output_2_0_g1716 = 0;
			float4 texArray7_g1716 = UNITY_SAMPLE_TEX2DARRAY(_HeightArray, float3(uv_TexCoord2451, (float)temp_output_2_0_g1716)  );
			float4 texArray8_g1716 = UNITY_SAMPLE_TEX2DARRAY(_HeightArray, float3(uv_TexCoord2451, (float)temp_output_2_0_g1716)  );
			float temp_output_14_0_g1633 = i.eyeDepth;
			float camDistanceVeryClose2341 = _CameraDistanceVeryClose;
			float camDistanceClose2342 = _CameraDistanceClose;
			float camDistanceTransition2340 = _CameraDistanceTransition;
			float temp_output_70_0_g1631 = camDistanceTransition2340;
			float camDistanceMid2343 = _CameraDistanceMid;
			float temp_output_69_0_g1631 = camDistanceMid2343;
			float temp_output_12_0_g1633 = ( camDistanceVeryClose2341 + camDistanceClose2342 + ( temp_output_70_0_g1631 * (0.0 + (i.eyeDepth - 0.0) * (1.0 - 0.0) / (( temp_output_69_0_g1631 + temp_output_70_0_g1631 ) - 0.0)) ) );
			float temp_output_11_0_g1633 = ( temp_output_70_0_g1631 * (0.0 + (i.eyeDepth - 0.0) * (1.0 - 0.0) / (( temp_output_69_0_g1631 + temp_output_70_0_g1631 ) - 0.0)) );
			float temp_output_5_0_g1633 = ( temp_output_12_0_g1633 + temp_output_11_0_g1633 );
			float temp_output_7_0_g1633 = (1.5 + (temp_output_14_0_g1633 - temp_output_12_0_g1633) * (0.0 - 1.5) / (temp_output_5_0_g1633 - temp_output_12_0_g1633));
			float temp_output_14_0_g1634 = i.eyeDepth;
			float temp_output_12_0_g1634 = camDistanceVeryClose2341;
			float temp_output_11_0_g1634 = ( temp_output_70_0_g1631 * (0.0 + (i.eyeDepth - 0.0) * (1.0 - 0.0) / (( temp_output_69_0_g1631 + temp_output_70_0_g1631 ) - 0.0)) );
			float temp_output_5_0_g1634 = ( temp_output_12_0_g1634 + temp_output_11_0_g1634 );
			float temp_output_7_0_g1634 = (1.5 + (temp_output_14_0_g1634 - temp_output_12_0_g1634) * (0.0 - 1.5) / (temp_output_5_0_g1634 - temp_output_12_0_g1634));
			float temp_output_14_0_g1632 = i.eyeDepth;
			float temp_output_12_0_g1632 = ( camDistanceVeryClose2341 + camDistanceClose2342 + temp_output_69_0_g1631 + ( temp_output_70_0_g1631 * (0.0 + (i.eyeDepth - 0.0) * (1.0 - 0.0) / (( temp_output_69_0_g1631 + temp_output_70_0_g1631 ) - 0.0)) ) + ( temp_output_70_0_g1631 * (0.0 + (i.eyeDepth - 0.0) * (1.0 - 0.0) / (( temp_output_69_0_g1631 + temp_output_70_0_g1631 ) - 0.0)) ) );
			float temp_output_11_0_g1632 = ( temp_output_70_0_g1631 * (0.0 + (i.eyeDepth - 0.0) * (1.0 - 0.0) / (( temp_output_69_0_g1631 + temp_output_70_0_g1631 ) - 0.0)) );
			float temp_output_5_0_g1632 = ( temp_output_12_0_g1632 + temp_output_11_0_g1632 );
			float temp_output_7_0_g1632 = (1.5 + (temp_output_14_0_g1632 - temp_output_12_0_g1632) * (0.0 - 1.5) / (temp_output_5_0_g1632 - temp_output_12_0_g1632));
			float UV_t2408 = ( saturate( ( temp_output_7_0_g1633 * (0.0 + (temp_output_14_0_g1633 - ( temp_output_12_0_g1633 - temp_output_11_0_g1633 )) * (1.5 - 0.0) / (temp_output_5_0_g1633 - ( temp_output_12_0_g1633 - temp_output_11_0_g1633 ))) ) ) + saturate( ( temp_output_7_0_g1634 * (0.0 + (temp_output_14_0_g1634 - ( temp_output_12_0_g1634 - temp_output_11_0_g1634 )) * (1.5 - 0.0) / (temp_output_5_0_g1634 - ( temp_output_12_0_g1634 - temp_output_11_0_g1634 ))) ) ) + saturate( ( temp_output_7_0_g1632 * (0.0 + (temp_output_14_0_g1632 - ( temp_output_12_0_g1632 - temp_output_11_0_g1632 )) * (1.5 - 0.0) / (temp_output_5_0_g1632 - ( temp_output_12_0_g1632 - temp_output_11_0_g1632 ))) ) ) );
			float4 lerpResult4_g1716 = lerp( texArray7_g1716 , texArray8_g1716 , UV_t2408);
			int temp_output_2_0_g1713 = 1;
			float4 texArray7_g1713 = UNITY_SAMPLE_TEX2DARRAY(_HeightArray, float3(uv_TexCoord2451, (float)temp_output_2_0_g1713)  );
			float4 texArray8_g1713 = UNITY_SAMPLE_TEX2DARRAY(_HeightArray, float3(uv_TexCoord2451, (float)temp_output_2_0_g1713)  );
			float4 lerpResult4_g1713 = lerp( texArray7_g1713 , texArray8_g1713 , UV_t2408);
			int temp_output_2_0_g1715 = 2;
			float4 texArray7_g1715 = UNITY_SAMPLE_TEX2DARRAY(_HeightArray, float3(uv_TexCoord2451, (float)temp_output_2_0_g1715)  );
			float4 texArray8_g1715 = UNITY_SAMPLE_TEX2DARRAY(_HeightArray, float3(uv_TexCoord2451, (float)temp_output_2_0_g1715)  );
			float4 lerpResult4_g1715 = lerp( texArray7_g1715 , texArray8_g1715 , UV_t2408);
			int temp_output_2_0_g1714 = 3;
			float4 texArray7_g1714 = UNITY_SAMPLE_TEX2DARRAY(_HeightArray, float3(uv_TexCoord2451, (float)temp_output_2_0_g1714)  );
			float4 texArray8_g1714 = UNITY_SAMPLE_TEX2DARRAY(_HeightArray, float3(uv_TexCoord2451, (float)temp_output_2_0_g1714)  );
			float4 lerpResult4_g1714 = lerp( texArray7_g1714 , texArray8_g1714 , UV_t2408);
			float4 appendResult2161 = (float4(lerpResult4_g1716.a , lerpResult4_g1713.a , lerpResult4_g1715.a , lerpResult4_g1714.a));
			float4 temp_cast_9 = (_heightBoost).xxxx;
			float temp_output_4_0_g1717 = ( 1.0 - ( splats1250 * ( pow( appendResult2161 , temp_cast_9 ) * _heightBoost ) ).r );
			float temp_output_14_0_g1717 = _heightstrength;
			float temp_output_2320_21 = saturate( ( ( saturate( ( ( splats1250.r - min( temp_output_5_0_g1717 , temp_output_4_0_g1717 ) ) / max( abs( ( temp_output_5_0_g1717 - temp_output_4_0_g1717 ) ) , 0.001 ) ) ) - temp_output_14_0_g1717 ) / max( 0.001 , ( 1.0 - temp_output_14_0_g1717 ) ) ) );
			float temp_output_5_0_g1718 = ( temp_output_2320_21 * splats1250.r );
			float4 temp_cast_11 = (_heightBoost).xxxx;
			float temp_output_4_0_g1718 = ( 1.0 - ( splats1250 * ( pow( appendResult2161 , temp_cast_11 ) * _heightBoost ) ).g );
			float temp_output_14_0_g1718 = _heightstrength;
			float temp_output_2318_21 = saturate( ( ( saturate( ( ( splats1250.g - min( temp_output_5_0_g1718 , temp_output_4_0_g1718 ) ) / max( abs( ( temp_output_5_0_g1718 - temp_output_4_0_g1718 ) ) , 0.001 ) ) ) - temp_output_14_0_g1718 ) / max( 0.001 , ( 1.0 - temp_output_14_0_g1718 ) ) ) );
			float temp_output_5_0_g1719 = ( temp_output_2318_21 * splats1250.g );
			float4 temp_cast_13 = (_heightBoost).xxxx;
			float temp_output_4_0_g1719 = ( 1.0 - ( splats1250 * ( pow( appendResult2161 , temp_cast_13 ) * _heightBoost ) ).b );
			float temp_output_14_0_g1719 = _heightstrength;
			float temp_output_2319_21 = saturate( ( ( saturate( ( ( splats1250.b - min( temp_output_5_0_g1719 , temp_output_4_0_g1719 ) ) / max( abs( ( temp_output_5_0_g1719 - temp_output_4_0_g1719 ) ) , 0.001 ) ) ) - temp_output_14_0_g1719 ) / max( 0.001 , ( 1.0 - temp_output_14_0_g1719 ) ) ) );
			float temp_output_1796_0 = ( 1.0 - max( temp_output_2319_21 , max( temp_output_2320_21 , temp_output_2318_21 ) ) );
			float temp_output_5_0_g1720 = ( temp_output_2319_21 * splats1250.b );
			float4 temp_cast_15 = (_heightBoost).xxxx;
			float temp_output_4_0_g1720 = ( 1.0 - ( splats1250 * ( pow( appendResult2161 , temp_cast_15 ) * _heightBoost ) ).a );
			float temp_output_14_0_g1720 = _heightstrength;
			float4 appendResult2079 = (float4(max( temp_output_2320_21 , ( splats1250.r * temp_output_1796_0 ) ) , max( temp_output_2318_21 , ( splats1250.g * temp_output_1796_0 ) ) , max( temp_output_2319_21 , ( splats1250.b * temp_output_1796_0 ) ) , max( saturate( ( ( saturate( ( ( splats1250.a - min( temp_output_5_0_g1720 , temp_output_4_0_g1720 ) ) / max( abs( ( temp_output_5_0_g1720 - temp_output_4_0_g1720 ) ) , 0.001 ) ) ) - temp_output_14_0_g1720 ) / max( 0.001 , ( 1.0 - temp_output_14_0_g1720 ) ) ) ) , ( splats1250.a * temp_output_1796_0 ) )));
			float4 heightMask1375 = saturate( appendResult2079 );
			float2 uv_TexCoord777 = i.uv_texcoord * float2( 20,20 ) + float2( 0,0 );
			float3 localUnpackNormal1818 = UnpackScaleNormal( tex2D( _combined, uv_TexCoord777 ) ,1.0 );
			float temp_output_1292_0 = ( localUnpackNormal1818.y * _Snowfakeedgestrength );
			float2 temp_cast_18 = (saturate( temp_output_1292_0 )).xx;
			float4 appendResult2080 = (float4(heightMask1375.x , heightMask1375.y , heightMask1375.z , saturate( ( heightMask1375.w + ( heightMask1375.w * ( temp_cast_18 - (heightMask1375).yz ) ) ) ).x));
			float4 modifiedWeights618 = appendResult2080;
			float closeUV529 = ( baseuvtiling400 / _uvmultiplier );
			float lerpResult95_g1631 = lerp( baseuvtiling400 , closeUV529 , saturate( (0.0 + (temp_output_14_0_g1634 - temp_output_12_0_g1634) * (1.5 - 0.0) / (temp_output_12_0_g1634 - temp_output_12_0_g1634)) ));
			float temp_output_1689_0 = ( _uvmultiplier * 2.0 );
			float midUV577 = ( baseuvtiling400 / temp_output_1689_0 );
			float lerpResult50_g1631 = lerp( lerpResult95_g1631 , midUV577 , saturate( (0.0 + (temp_output_14_0_g1633 - temp_output_12_0_g1633) * (1.5 - 0.0) / (temp_output_12_0_g1633 - temp_output_12_0_g1633)) ));
			float farUV578 = ( baseuvtiling400 / ( temp_output_1689_0 * 2.0 ) );
			float temp_output_67_0_g1631 = farUV578;
			float temp_output_136_19_g1631 = saturate( (0.0 + (temp_output_14_0_g1632 - temp_output_12_0_g1632) * (1.5 - 0.0) / (temp_output_12_0_g1632 - temp_output_12_0_g1632)) );
			float lerpResult55_g1631 = lerp( lerpResult50_g1631 , temp_output_67_0_g1631 , temp_output_136_19_g1631);
			float2 temp_cast_20 = (lerpResult55_g1631).xx;
			float2 uv_TexCoord59_g1631 = i.uv_texcoord * temp_cast_20 + float2( 0,0 );
			float2 UV_A2406 = uv_TexCoord59_g1631;
			int temp_output_2_0_g1755 = 0;
			float temp_output_10_0_g1755 = ( _normalScale * _normalscalefar );
			float3 texArray9_g1755 = UnpackScaleNormal( UNITY_SAMPLE_TEX2DARRAY(_NormalArray, float3(UV_A2406, (float)temp_output_2_0_g1755)  ) ,temp_output_10_0_g1755 );
			float temp_output_134_13_g1631 = ceil( saturate( temp_output_7_0_g1634 ) );
			float lerpResult114_g1631 = lerp( baseuvtiling400 , closeUV529 , temp_output_134_13_g1631);
			float temp_output_135_13_g1631 = ceil( saturate( temp_output_7_0_g1633 ) );
			float lerpResult109_g1631 = lerp( lerpResult114_g1631 , midUV577 , ( temp_output_135_13_g1631 - temp_output_134_13_g1631 ));
			float lerpResult110_g1631 = lerp( lerpResult109_g1631 , temp_output_67_0_g1631 , ( saturate( ( ceil( saturate( temp_output_7_0_g1632 ) ) + temp_output_136_19_g1631 ) ) - temp_output_135_13_g1631 ));
			float2 temp_cast_22 = (lerpResult110_g1631).xx;
			float2 uv_TexCoord60_g1631 = i.uv_texcoord * temp_cast_22 + float2( 0,0 );
			float2 UV_B2407 = uv_TexCoord60_g1631;
			float3 texArray6_g1755 = UnpackScaleNormal( UNITY_SAMPLE_TEX2DARRAY(_NormalArray, float3(UV_B2407, (float)temp_output_2_0_g1755)  ) ,temp_output_10_0_g1755 );
			float3 lerpResult5_g1755 = lerp( texArray9_g1755 , texArray6_g1755 , UV_t2408);
			int temp_output_2_0_g1752 = 1;
			float temp_output_10_0_g1752 = ( _normalScale * _normalscalefar );
			float3 texArray9_g1752 = UnpackScaleNormal( UNITY_SAMPLE_TEX2DARRAY(_NormalArray, float3(UV_A2406, (float)temp_output_2_0_g1752)  ) ,temp_output_10_0_g1752 );
			float3 texArray6_g1752 = UnpackScaleNormal( UNITY_SAMPLE_TEX2DARRAY(_NormalArray, float3(UV_B2407, (float)temp_output_2_0_g1752)  ) ,temp_output_10_0_g1752 );
			float3 lerpResult5_g1752 = lerp( texArray9_g1752 , texArray6_g1752 , UV_t2408);
			int temp_output_2_0_g1753 = 2;
			float temp_output_10_0_g1753 = ( _normalScale * _normalscalefar );
			float3 texArray9_g1753 = UnpackScaleNormal( UNITY_SAMPLE_TEX2DARRAY(_NormalArray, float3(UV_A2406, (float)temp_output_2_0_g1753)  ) ,temp_output_10_0_g1753 );
			float3 texArray6_g1753 = UnpackScaleNormal( UNITY_SAMPLE_TEX2DARRAY(_NormalArray, float3(UV_B2407, (float)temp_output_2_0_g1753)  ) ,temp_output_10_0_g1753 );
			float3 lerpResult5_g1753 = lerp( texArray9_g1753 , texArray6_g1753 , UV_t2408);
			int temp_output_2_0_g1754 = 3;
			float temp_output_10_0_g1754 = ( _normalScale * _normalscalefar );
			float3 texArray9_g1754 = UnpackScaleNormal( UNITY_SAMPLE_TEX2DARRAY(_NormalArray, float3(UV_A2406, (float)temp_output_2_0_g1754)  ) ,temp_output_10_0_g1754 );
			float3 texArray6_g1754 = UnpackScaleNormal( UNITY_SAMPLE_TEX2DARRAY(_NormalArray, float3(UV_B2407, (float)temp_output_2_0_g1754)  ) ,temp_output_10_0_g1754 );
			float3 lerpResult5_g1754 = lerp( texArray9_g1754 , texArray6_g1754 , UV_t2408);
			float4 weightedBlendVar1978 = modifiedWeights618;
			float3 weightedAvg1978 = ( ( weightedBlendVar1978.x*lerpResult5_g1755 + weightedBlendVar1978.y*lerpResult5_g1752 + weightedBlendVar1978.z*lerpResult5_g1753 + weightedBlendVar1978.w*lerpResult5_g1754 )/( weightedBlendVar1978.x + weightedBlendVar1978.y + weightedBlendVar1978.z + weightedBlendVar1978.w ) );
			float2 uv_globalnormal = i.uv_texcoord * _globalnormal_ST.xy + _globalnormal_ST.zw;
			float temp_output_17_0_g1747 = camDistanceClose2342;
			float temp_output_1_0_g1747 = camDistanceTransition2340;
			float cameraMidDepth279 = saturate( (0.0 + (i.eyeDepth - temp_output_17_0_g1747) * (1.0 - 0.0) / (( temp_output_1_0_g1747 + temp_output_17_0_g1747 ) - temp_output_17_0_g1747)) );
			float3 lerpResult1109 = lerp( weightedAvg1978 , BlendNormals( UnpackScaleNormal( tex2D( _globalnormal, uv_globalnormal ) ,_globalnormalstrength ) , weightedAvg1978 ) , saturate( ( cameraMidDepth279 + _closeglobalnormal ) ));
			float3 normalizeResult209 = normalize( lerpResult1109 );
			float3 endNormal192 = normalizeResult209;
			o.Normal = endNormal192;
			float2 temp_cast_30 = (farUV578).xx;
			float4 tex2DNode1989 = tex2D( _grungemap, temp_cast_30 );
			int temp_output_2_0_g1725 = 0;
			float4 texArray7_g1725 = UNITY_SAMPLE_TEX2DARRAY(_AlbedoArray, float3(UV_A2406, (float)temp_output_2_0_g1725)  );
			float4 texArray8_g1725 = UNITY_SAMPLE_TEX2DARRAY(_AlbedoArray, float3(UV_B2407, (float)temp_output_2_0_g1725)  );
			float4 lerpResult4_g1725 = lerp( texArray7_g1725 , texArray8_g1725 , UV_t2408);
			float4 temp_output_2428_43 = lerpResult4_g1725;
			float4 lerpResult1997 = lerp( ( tex2DNode1989.r * temp_output_2428_43 ) , temp_output_2428_43 , 0.25);
			int temp_output_2_0_g1722 = 1;
			float4 texArray7_g1722 = UNITY_SAMPLE_TEX2DARRAY(_AlbedoArray, float3(UV_A2406, (float)temp_output_2_0_g1722)  );
			float4 texArray8_g1722 = UNITY_SAMPLE_TEX2DARRAY(_AlbedoArray, float3(UV_B2407, (float)temp_output_2_0_g1722)  );
			float4 lerpResult4_g1722 = lerp( texArray7_g1722 , texArray8_g1722 , UV_t2408);
			float4 temp_output_2428_44 = lerpResult4_g1722;
			float4 lerpResult1999 = lerp( ( ( ( tex2DNode1989.r - tex2DNode1989.g ) + tex2DNode1989.g ) * temp_output_2428_44 ) , temp_output_2428_44 , 0.25);
			int temp_output_2_0_g1724 = 2;
			float4 texArray7_g1724 = UNITY_SAMPLE_TEX2DARRAY(_AlbedoArray, float3(UV_A2406, (float)temp_output_2_0_g1724)  );
			float4 texArray8_g1724 = UNITY_SAMPLE_TEX2DARRAY(_AlbedoArray, float3(UV_B2407, (float)temp_output_2_0_g1724)  );
			float4 lerpResult4_g1724 = lerp( texArray7_g1724 , texArray8_g1724 , UV_t2408);
			float4 temp_output_2428_46 = lerpResult4_g1724;
			float4 lerpResult2000 = lerp( ( tex2DNode1989.b * temp_output_2428_46 ) , temp_output_2428_46 , 0.25);
			int temp_output_2_0_g1723 = 3;
			float4 texArray7_g1723 = UNITY_SAMPLE_TEX2DARRAY(_AlbedoArray, float3(UV_A2406, (float)temp_output_2_0_g1723)  );
			float4 texArray8_g1723 = UNITY_SAMPLE_TEX2DARRAY(_AlbedoArray, float3(UV_B2407, (float)temp_output_2_0_g1723)  );
			float4 lerpResult4_g1723 = lerp( texArray7_g1723 , texArray8_g1723 , UV_t2408);
			float4 temp_output_2428_48 = lerpResult4_g1723;
			float4 lerpResult2001 = lerp( ( tex2DNode1989.a * temp_output_2428_48 ) , temp_output_2428_48 , 0.25);
			float4 weightedBlendVar1945 = modifiedWeights618;
			float4 weightedAvg1945 = ( ( weightedBlendVar1945.x*lerpResult1997 + weightedBlendVar1945.y*lerpResult1999 + weightedBlendVar1945.z*lerpResult2000 + weightedBlendVar1945.w*lerpResult2001 )/( weightedBlendVar1945.x + weightedBlendVar1945.y + weightedBlendVar1945.z + weightedBlendVar1945.w ) );
			float2 uv_TexCoord1323 = i.uv_texcoord * float2( 1,1 ) + float2( 0,0 );
			float temp_output_1327_0 = ( ( localUnpackNormal1818.x + localUnpackNormal1818.z ) * _colormapuvextra );
			float2 temp_cast_41 = (temp_output_1327_0).xx;
			float2 lerpResult1336 = lerp( ( uv_TexCoord1323 - temp_cast_41 ) , ( uv_TexCoord1323 + temp_output_1327_0 ) , ( localUnpackNormal1818.x + localUnpackNormal1818.z ));
			float4 tex2DNode4 = tex2D( _globalcolor, lerpResult1336 );
			float4 weightedBlendVar748 = modifiedWeights618;
			float weightedAvg748 = ( ( weightedBlendVar748.x*_GlobalColorDetail0 + weightedBlendVar748.y*_GlobalColorDetail1 + weightedBlendVar748.z*_GlobalColorDetail2 + weightedBlendVar748.w*_GlobalColorDetail3 )/( weightedBlendVar748.x + weightedBlendVar748.y + weightedBlendVar748.z + weightedBlendVar748.w ) );
			float temp_output_19_0_g1747 = camDistanceMid2343;
			float cameraFarDepth281 = saturate( (0.0 + (i.eyeDepth - temp_output_19_0_g1747) * (1.0 - 0.0) / (( temp_output_19_0_g1747 + temp_output_1_0_g1747 ) - temp_output_19_0_g1747)) );
			float4 lerpResult26 = lerp( weightedAvg1945 , ( weightedAvg1945 * tex2DNode4 ) , saturate( ( weightedAvg748 * ( _GlobalColorMultiplier * _globalColorFarMultiplier * cameraFarDepth281 ) ) ));
			float4 endAlbedo2165 = lerpResult26;
			o.Albedo = endAlbedo2165.rgb;
			float temp_output_16_0_g1747 = camDistanceVeryClose2341;
			float cameraCloseDepth273 = saturate( (0.0 + (i.eyeDepth - temp_output_16_0_g1747) * (1.0 - 0.0) / (( temp_output_1_0_g1747 + temp_output_16_0_g1747 ) - temp_output_16_0_g1747)) );
			float lerpResult145 = lerp( weightedAvg1945.a , tex2DNode4.a , ( 1.0 * cameraCloseDepth273 ));
			float2 _Vector0 = float2(0,1);
			float endSmoothness2083 = (_smoothnessmin + (( lerpResult145 * _smoothness ) - _Vector0.x) * (_smoothnessmax - _smoothnessmin) / (_Vector0.y - _Vector0.x));
			o.Smoothness = endSmoothness2083;
			float4 weightedBlendVar2162 = modifiedWeights618;
			float weightedAvg2162 = ( ( weightedBlendVar2162.x*lerpResult4_g1716.r + weightedBlendVar2162.y*lerpResult4_g1713.r + weightedBlendVar2162.z*lerpResult4_g1715.r + weightedBlendVar2162.w*lerpResult4_g1714.r )/( weightedBlendVar2162.x + weightedBlendVar2162.y + weightedBlendVar2162.z + weightedBlendVar2162.w ) );
			float detailAOoutput978 = saturate( ( weightedAvg2162 + ( 1.0 - _AOStrength ) ) );
			o.Occlusion = detailAOoutput978;
			o.Alpha = 1;
		}

		ENDCG
	}

	Dependency "BaseMapShader"="2SD/2SD_Terrain_Base"
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14201
-1913;70;1906;1004;-3342.822;-253.3195;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;321;-4715,-140;Float;False;1492.627;418.8007;   ;11;318;319;1691;1689;1690;320;1511;304;577;529;578;Distance Based Tiling;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;304;-4637.702,28.49999;Float;False;Property;_uvmultiplier;uv multiplier;30;0;Create;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1690;-4366.262,189.9003;Float;False;Constant;_Float3;Float 3;41;0;Create;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;236;-4500.271,-1168.073;Float;False;1035.472;178.8496;Comment;2;400;21;Base Tiling;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1689;-4105.066,85.39848;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-4450.271,-1114.536;Float;False;Property;_Tiling;Tiling;29;0;Create;128;128;1;256;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1691;-3867.856,161.2005;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;2358;-6406.12,-1825.063;Float;False;782.7996;382.3958;Comment;8;2331;2340;2330;2343;2341;2342;2328;2329;Camera Distance Variables;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;400;-3713.831,-1126.768;Float;False;baseuvtiling;-1;True;1;0;FLOAT;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1511;-4638.357,-97.01839;Float;False;400;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2331;-6354.12,-1772.667;Float;False;Property;_CameraDistanceTransition;Camera Distance Transition;51;0;Create;30;30;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2329;-6319.636,-1610.481;Float;False;Property;_CameraDistanceClose;Camera Distance Close;49;0;Create;50;50;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2330;-6302.449,-1527.58;Float;False;Property;_CameraDistanceMid;Camera Distance Mid;50;0;Create;80;80;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;319;-3925.999,-51.09169;Float;False;2;0;FLOAT;0,0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;320;-4375.699,7;Float;False;2;0;FLOAT;0,0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2328;-6361.504,-1696.063;Float;False;Property;_CameraDistanceVeryClose;Camera Distance Very Close;48;0;Create;30;30;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;318;-3652.677,42.1019;Float;False;2;0;FLOAT;0,0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;2452;-6541.484,3382.306;Float;False;709;125;We use the same UV through the whole terrain to hide the blending in the distance;1;2450;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;1527;-6323.165,-1218.299;Float;False;529;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1526;-6355.165,-1298.3;Float;False;400;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;577;-3743.656,-86.87183;Float;False;midUV;-1;True;1;0;FLOAT;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1528;-6323.165,-1138.299;Float;False;577;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2342;-5904.32,-1618.58;Float;False;camDistanceClose;-1;True;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2357;-6395.206,-674.0532;Float;False;2340;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;578;-3456.397,-36.57393;Float;False;farUV;-1;True;1;0;FLOAT;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2340;-5936.32,-1774.579;Float;False;camDistanceTransition;-1;True;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2355;-6385.683,-855.6555;Float;False;2342;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;529;-4175.285,-98.1942;Float;False;closeUV;-1;True;1;0;FLOAT;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2354;-6417.683,-941.6548;Float;False;2341;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2341;-5935.32,-1693.58;Float;False;camDistanceVeryClose;-1;True;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1529;-6325.618,-1030.031;Float;False;578;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2356;-6373.683,-779.6563;Float;False;2343;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2343;-5890.32,-1530.579;Float;False;camDistanceMid;-1;True;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;2398;-6010.487,-1043.822;Float;False;DepthBasedUVFunction;-1;;1631;bb53ce8f7e6ec484bb3fb671bad36bcf;8;72;FLOAT;32.0;False;65;FLOAT;32.0;False;66;FLOAT;16.0;False;67;FLOAT;4.0;False;73;FLOAT;30.0;False;68;FLOAT;30.0;False;69;FLOAT;20.0;False;70;FLOAT;10.0;False;3;FLOAT2;0;FLOAT2;64;FLOAT;71
Node;AmplifyShaderEditor.CommentaryNode;234;-5800.778,2918.264;Float;False;3361.984;1018.444;Comment;27;2451;2415;2417;2416;2427;2317;1772;2319;1771;2318;1770;2320;1722;41;1632;1633;1716;1628;1670;1782;1608;2161;2157;2159;2160;2158;2156;Height blend;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;2450;-6303.484,3425.306;Float;False;400;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2408;-5578.522,-938.8751;Float;False;UV_t;-1;True;1;0;FLOAT;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;2156;-5453.891,3184.842;Float;True;Property;_HeightArray;Height Array;2;0;Create;None;f5c180a2400f79c429abc6f044b2a469;False;white;LockedToTexture2DArray;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;2451;-5456.309,3407.075;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;2415;-5211.086,3644.658;Float;False;2408;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;2427;-4994.669,3401.641;Float;False;TextureArrayDistanceLerp4Textures;-1;;1712;aefb61c81df35c143bffe9e803d17738;4;141;FLOAT2;0,0;False;142;FLOAT2;0,0;False;145;FLOAT;0.0;False;24;SAMPLER2D;0,0,0,0;False;4;COLOR;43;COLOR;44;COLOR;46;COLOR;48
Node;AmplifyShaderEditor.BreakToComponentsNode;2157;-4413.891,3188.038;Float;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.BreakToComponentsNode;2159;-4415.488,3472.838;Float;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.BreakToComponentsNode;2160;-4423.489,3626.438;Float;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.BreakToComponentsNode;2158;-4417.088,3332.036;Float;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;1608;-4000.56,3521.266;Float;False;Property;_heightBoost;heightBoost;40;0;Create;4.26;4.26;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;2161;-4064.691,3319.64;Float;False;FLOAT4;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;237;-6368.294,-401.8;Float;False;1060.533;421.5055;Comment;7;1250;39;50;48;49;763;2;Splatmap;1,1,1,1;0;0
Node;AmplifyShaderEditor.PowerNode;1782;-3844.653,3344.969;Float;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0.0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;2;-6324.869,-281.4873;Float;True;Property;_Control;Control;8;0;Create;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;0.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;1250;-5888.434,-343.989;Float;False;splats;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1670;-3677.493,3336.378;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0.0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;1628;-3835.962,3035.362;Float;False;1250;0;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1716;-3543.66,3229.059;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;1633;-3522.86,3025.466;Float;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.BreakToComponentsNode;1632;-3407.16,3323.663;Float;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;41;-3441.731,3473.808;Float;False;Property;_heightstrength;height strength;39;0;Create;0.536;0.536;0;0.999;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1722;-3211.557,2964.36;Float;False;Constant;_Float0;Float 0;41;0;Create;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;2320;-2769.621,3081.336;Float;False;HeightBlendFunction;-1;;1717;31570aaae7e29904498342c8c3bdad00;4;5;FLOAT;0.0;False;3;FLOAT;0.0;False;10;FLOAT;0.0;False;14;FLOAT;0.0;False;1;FLOAT;21
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1770;-2959.702,3129.291;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;2318;-2758.128,3258.32;Float;False;HeightBlendFunction;-1;;1718;31570aaae7e29904498342c8c3bdad00;4;5;FLOAT;0.0;False;3;FLOAT;0.0;False;10;FLOAT;0.0;False;14;FLOAT;0.0;False;1;FLOAT;21
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1771;-2998.402,3284.488;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;1794;-2329.134,3422.713;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;2319;-2754.728,3426.818;Float;False;HeightBlendFunction;-1;;1719;31570aaae7e29904498342c8c3bdad00;4;5;FLOAT;0.0;False;3;FLOAT;0.0;False;10;FLOAT;0.0;False;14;FLOAT;0.0;False;1;FLOAT;21
Node;AmplifyShaderEditor.SimpleMaxOpNode;1795;-2098.33,3440.714;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1772;-2980.303,3477.491;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;1796;-1928.33,3448.714;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1802;-1634.757,3429.048;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1800;-1650.757,3221.049;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1798;-1650.757,3125.049;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1801;-1634.757,3333.048;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;2317;-2757.428,3674.016;Float;False;HeightBlendFunction;-1;;1720;31570aaae7e29904498342c8c3bdad00;4;5;FLOAT;0.0;False;3;FLOAT;0.0;False;10;FLOAT;0.0;False;14;FLOAT;0.0;False;1;FLOAT;21
Node;AmplifyShaderEditor.SimpleMaxOpNode;1803;-1426.757,3205.049;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;1805;-1410.757,3413.048;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;777;-2087.997,1875.988;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;20,20;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMaxOpNode;1799;-1419.051,3092.709;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;1804;-1426.757,3317.048;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;623;-84.26407,3072.176;Float;False;2074.442;602.9313;Comment;13;618;1294;935;1292;1377;1376;2080;2177;2178;2180;2186;2189;2199;Modified Weights;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;773;-1817.996,1846.988;Float;True;Property;_TextureSample1;Texture Sample 1;44;0;Create;None;None;True;0;False;bump;Auto;False;Instance;1961;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;928;-1801.996,2038.988;Float;False;Constant;_edgeScale;edgeScale;71;0;Create;1;0;1;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;2079;-1120.768,3251.412;Float;False;FLOAT4;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.UnpackScaleNormalNode;1818;-1433.996,1990.988;Float;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;1.0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SaturateNode;1944;-861.7568,3263.049;Float;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;935;198.444,3168.717;Float;False;Property;_Snowfakeedgestrength;Snow fake edge strength;38;0;Create;1;1;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1376;-54.63837,3250.929;Float;False;1375;0;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1292;558.285,3117.149;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;2090;-2652.398,-1813.798;Float;False;2375.998;1012.998;Albedo;23;1990;1992;1989;1996;1995;1994;1993;1998;2001;2000;1999;1941;1997;1945;1697;1923;2309;2311;2310;2409;2410;2411;2428;Albedo;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1375;-678.7222,3301.695;Float;False;heightMask;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TexturePropertyNode;1990;-2382.398,-1763.798;Float;True;Property;_grungemap;grunge map;28;0;Create;None;87109a999d4d5104fa85d68e6877523e;False;white;Auto;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.GetLocalVarNode;1992;-2286.398,-1571.798;Float;False;578;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;2180;723.1216,3103.698;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;2186;208.6215,3577.899;Float;False;False;True;True;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;1989;-2014.399,-1587.798;Float;True;Property;_TextureSample2;Texture Sample 2;53;0;Create;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;2189;904.6213,3576.899;Float;False;2;0;FLOAT;0.0;False;1;FLOAT2;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;1377;213.1612,3252.429;Float;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2199;917.4194,3424.602;Float;False;2;2;0;FLOAT;0,0;False;1;FLOAT2;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;2310;-1665.935,-1674.284;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2407;-5578.522,-1019.875;Float;False;UV_B;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;2410;-2387.128,-1291.3;Float;False;2407;0;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;2178;1090.023,3353.299;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT2;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;2411;-2380.128,-1211.3;Float;False;2408;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;1923;-2584.398,-1600.798;Float;True;Property;_AlbedoArray;Albedo Array;0;0;Create;None;23ab5189e9c018841b03ae2324aef14b;False;white;LockedToTexture2DArray;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleAddOpNode;2311;-1455.935,-1669.284;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2409;-2379.856,-1362.478;Float;False;2406;0;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2406;-5581.259,-1097.574;Float;False;UV_A;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;2177;1276.023,3345.299;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;2428;-2078.397,-1395.799;Float;False;TextureArrayDistanceLerp4Textures;-1;;1721;aefb61c81df35c143bffe9e803d17738;4;141;FLOAT2;0,0;False;142;FLOAT2;0,0;False;145;FLOAT;0.0;False;24;SAMPLER2D;0,0,0,0;False;4;COLOR;43;COLOR;44;COLOR;46;COLOR;48
Node;AmplifyShaderEditor.RelayNode;2309;-1367.935,-1771.284;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1995;-1470.4,-1443.799;Float;False;2;2;0;FLOAT;0.0;False;1;COLOR;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1994;-1454.4,-1235.799;Float;False;2;2;0;FLOAT;0.0;False;1;COLOR;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1996;-1454.4,-1347.798;Float;False;2;2;0;FLOAT;0,0,0,0;False;1;COLOR;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;2080;1479.31,3244.503;Float;False;FLOAT4;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1993;-1470.4,-1539.798;Float;False;2;2;0;FLOAT;0.0;False;1;COLOR;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1998;-1465.4,-1116.799;Float;False;Constant;_Float2;Float 2;53;0;Create;0.25;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1941;-894.4003,-1651.798;Float;False;618;0;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;2000;-1214.4,-1315.798;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;2191;-991.8976,2022.444;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;618;1711.861,3242.532;Float;False;modifiedWeights;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;1999;-1214.4,-1443.799;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;2001;-1213.4,-1197.799;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;1997;-1230.4,-1555.798;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0.0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RelayNode;1328;-825.996,2022.988;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WeightedBlendNode;1945;-638.4004,-1363.799;Float;False;5;0;FLOAT4;0,0,0,0;False;1;COLOR;0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RelayNode;1321;-674.442,-151.096;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2258;-2846.427,1025.4;Float;False;Property;_normalscalefar;normal scale far;7;0;Create;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1980;-2852.739,736.1055;Float;False;Property;_normalScale;normalScale;3;0;Create;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1333;-647.2414,102.4028;Float;False;Property;_colormapuvextra;colormap uv extra;47;0;Create;0;0;0;0.01;0;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;1697;-430.4003,-1363.799;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2453;-2249.605,723.0341;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2414;-1765.184,1056.188;Float;False;2406;0;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;1968;-1954.198,857.9;Float;True;Property;_NormalArray;Normal Array;1;0;Create;None;985d1b7c541e9844d893967bdff908cb;False;white;LockedToTexture2DArray;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.GetLocalVarNode;2412;-1765.456,1207.366;Float;False;2408;0;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;1446;-273.0574,-522.4181;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1323;-509.0423,-232.7966;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1327;-288.1424,-20.99653;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2413;-1772.456,1127.366;Float;False;2407;0;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1335;-116.7423,-233.7975;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1325;-27.74232,-40.99651;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0.0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;2441;-5516.981,-1748.261;Float;False;CameraDepthMasks;-1;;1747;32c378a12ba127b42a065aeca32fbb55;4;1;FLOAT;0.0;False;16;FLOAT;0.0;False;17;FLOAT;0.0;False;19;FLOAT;0.0;False;3;FLOAT;0;FLOAT;18;FLOAT;20
Node;AmplifyShaderEditor.CommentaryNode;1510;-5595.066,-1825.814;Float;False;917.7;380.5005;Comment;3;281;279;273;Camera Distance;1,1,1,1;0;0
Node;AmplifyShaderEditor.RelayNode;617;589.4381,-523.0148;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1979;-1392.399,884.5001;Float;False;618;0;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode;2403;-1496.5,977.3998;Float;False;TextureArrayDistanceLerp4TexturesNormal;-1;;1751;ddc78be429ca7e549afa78ee1c166e18;5;97;FLOAT2;0,0;False;98;FLOAT2;0,0;False;99;FLOAT;0.0;False;50;FLOAT;1.0;False;24;SAMPLER2D;0,0,0,0;False;4;FLOAT3;43;FLOAT3;44;FLOAT3;46;FLOAT3;48
Node;AmplifyShaderEditor.RangedFloatNode;195;-17.86369,1106.485;Float;False;Property;_globalnormalstrength;global normal strength;10;0;Create;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;2167;1562.646,-1664.731;Float;False;3075.19;748.0726;Smoothness;23;2280;2283;2279;2281;2284;2282;1820;2083;1151;1589;1153;1152;65;35;145;1826;984;2091;1821;64;1366;1819;1813;Smoothness;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;1112;198,1373;Float;False;Property;_closeglobalnormal;close global normal;11;0;Create;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1110;232,1300;Float;False;279;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;279;-4953.266,-1655.115;Float;False;cameraMidDepth;-1;True;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WeightedBlendNode;1978;-1011.2,952.1995;Float;False;5;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;18;687.8279,265.8681;Float;False;Property;_GlobalColorMultiplier;Global Color Multiplier;20;0;Create;0.85;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;749;153.9904,78.84909;Float;False;618;0;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;753;135.9904,337.849;Float;False;Property;_GlobalColorDetail2;GlobalColorDetail2;26;0;Create;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;754;135.9904,420.849;Float;False;Property;_GlobalColorDetail3;GlobalColorDetail3;27;0;Create;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;750;128.9904,164.8491;Float;False;Property;_GlobalColorDetail0;GlobalColorDetail0;24;0;Create;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;281;-4961.166,-1571.215;Float;False;cameraFarDepth;-1;True;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1336;176.2577,-196.7975;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.0,0;False;2;FLOAT;0.0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;723;682.5818,580.0234;Float;False;Property;_globalColorFarMultiplier;globalColorFarMultiplier;32;0;Create;0.9;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;2088;873.3889,-485.7374;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;752;134.9904,243.8491;Float;False;Property;_GlobalColorDetail1;GlobalColorDetail1;25;0;Create;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;285;713.8545,827.8395;Float;False;281;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;3;329.5015,1064.39;Float;True;Property;_globalnormal;global normal;9;1;[Normal];Create;None;244b860a354f3db4f815dfed646337c4;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;1366;2604.645,-1197.666;Float;False;273;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;273;-4965.365,-1723.915;Float;False;cameraCloseDepth;-1;True;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1821;2716.645,-1293.666;Float;False;Constant;_Float6;Float 6;41;0;Create;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1845;680,1284;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;1858;533.8,953.8001;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;1140;-3756.989,2155.055;Float;False;1581.4;304.7029;Comment;7;978;1949;1841;1835;741;977;2162;Detail AO;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;4;441.798,-221.0263;Float;True;Property;_globalcolor;global color;19;0;Create;None;a45242d38b85db84fbfd4788148600d3;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;0.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WeightedBlendNode;748;478.9906,178.8491;Float;False;5;0;FLOAT4;0,0,0,0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;2085;895.1901,-454.1376;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2454;1181.694,299.4547;Float;False;3;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;2091;1631.846,-1396.001;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendNormalsNode;32;840,1028;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;984;2908.645,-1261.666;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;741;-3354.978,2379.286;Float;False;Property;_AOStrength;AO Strength;36;0;Create;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;1943;925.4775,1277.762;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;755;1394.814,184.6151;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;64;1634.292,-1614.731;Float;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.WireNode;2089;897.9889,27.66248;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;977;-3732.989,2208.257;Float;False;618;0;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;35;3264.209,-1348.234;Float;False;Property;_smoothness;smoothness;31;0;Create;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;1835;-3010.978,2384.286;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1109;1164,960;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0.0,0,0;False;2;FLOAT;0.0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;145;3068.645,-1453.666;Float;False;3;0;FLOAT;0,0,0,0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2210;1224.545,-477.4672;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;2087;934.7897,66.06245;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WeightedBlendNode;2162;-3364.37,2207.75;Float;False;5;0;FLOAT4;0,0,0,0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;2431;1550.041,182.7306;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1153;3777.928,-1148.458;Float;False;Property;_smoothnessmax;smoothness max;34;0;Create;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;1021;1384,1140;Float;False;1;0;FLOAT3;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;1152;3767.928,-1244.458;Float;False;Property;_smoothnessmin;smoothness min;33;0;Create;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1841;-2809.478,2210.287;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;26;1740.361,53.53231;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0.0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;1589;3869.979,-1378.778;Float;False;Constant;_Vector0;Vector 0;41;0;Create;0,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;3606.195,-1451.831;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;1949;-2637.676,2210.687;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;1983;1938.192,54.96503;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;2179;870.6826,3736.741;Float;False;341;181;Not sure if this looks better or not;1;1293;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1810;1049.844,2545.995;Float;False;515.0001;186;Comment;2;1812;1809;Speckle;1,1,1,1;0;0
Node;AmplifyShaderEditor.NormalizeNode;209;2415.699,1138.7;Float;False;1;0;FLOAT3;0.0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TFHCRemapNode;1151;4100.128,-1453.458;Float;False;5;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;3;FLOAT;0.0;False;4;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;1144;-4602.661,-1861.022;Float;False;1119.248;439.902;Comment;10;676;674;663;672;1347;720;721;719;718;2082;Texture Indexes;1,1,1,1;0;0
Node;AmplifyShaderEditor.FunctionNode;2449;1042.72,472.6083;Float;False;Distance Based Mask Multiplier;-1;;1749;799ac193d9a7f7a4bae908a42e277362;8;23;FLOAT;1.0;False;19;FLOAT;1.0;False;20;FLOAT;1.0;False;21;FLOAT;1.0;False;22;FLOAT;1.0;False;24;FLOAT;1.0;False;25;FLOAT;1.0;False;26;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1826;2828.645,-1549.666;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;739;519.1246,2121.21;Float;False;273;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1961;1370.684,1426.766;Float;True;Property;_TextureSample0;Texture Sample 0;44;1;[HideInInspector];Create;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;48;-5580.748,-262.0316;Float;False;splatG;-1;True;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;2443;4034.502,1018.674;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;50;-5563.749,-88.5324;Float;False;splatA;-1;True;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2259;-2809.393,1271.12;Float;False;281;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;2448;-2317.601,942.0929;Float;False;Distance Based Mask Multiplier;-1;;1750;799ac193d9a7f7a4bae908a42e277362;8;23;FLOAT;1.0;False;19;FLOAT;1.0;False;20;FLOAT;1.0;False;21;FLOAT;1.0;False;22;FLOAT;1.0;False;24;FLOAT;1.0;False;25;FLOAT;1.0;False;26;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;2435;3486.106,1163.876;Float;False;5;0;FLOAT;0.0;False;1;FLOAT;10.0;False;2;FLOAT;15.0;False;3;FLOAT;0.0;False;4;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;153;2051.407,1213.999;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0.0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;2282;1994.369,-1339.003;Float;False;618;0;1;FLOAT4;0
Node;AmplifyShaderEditor.SaturateNode;1955;1110.88,2120.964;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;2212;1161.17,-264.3297;Float;False;Overlay;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;2279;1975.369,-1174.003;Float;False;Property;_snowspecklestrengthdetail1;snow speckle strength detail 1;44;0;Create;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1347;-3720.943,-1719.398;Float;False;detail_indexes;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;39;-5582.351,-335.2351;Float;False;splatR;-1;True;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;2440;3669.041,1091.432;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1166;1556.377,2013.308;Float;False;3;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;193;3966.635,696.9847;Float;False;192;0;1;FLOAT3;0
Node;AmplifyShaderEditor.RelayNode;1817;1549.8,1909;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;1812;1428.444,2601.395;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2416;-5218.086,3564.658;Float;False;2407;0;1;FLOAT2;0
Node;AmplifyShaderEditor.IntNode;721;-4548.661,-1586.022;Float;False;Constant;_Int3;Int 3;34;0;Create;3;0;0;1;INT;0
Node;AmplifyShaderEditor.IntNode;719;-4552.661,-1736.022;Float;False;Constant;_Int1;Int 1;34;0;Create;1;0;0;1;INT;0
Node;AmplifyShaderEditor.IntNode;720;-4550.661,-1660.022;Float;False;Constant;_Int2;Int 2;34;0;Create;2;0;0;1;INT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;49;-5573.249,-163.9333;Float;False;splatB;-1;True;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2417;-5210.814,3493.48;Float;False;2406;0;1;FLOAT2;0
Node;AmplifyShaderEditor.IntNode;718;-4550.661,-1811.022;Float;False;Constant;_Int0;Int 0;35;0;Create;0;0;0;1;INT;0
Node;AmplifyShaderEditor.GetLocalVarNode;980;3943.3,852.2002;Float;False;978;0;1;FLOAT;0
Node;AmplifyShaderEditor.SurfaceDepthNode;2434;3213.106,1145.876;Float;False;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;663;-4292.662,-1809.42;Float;False;detail_index_0;-1;True;1;0;INT;0;False;1;INT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1816;1802,1832;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2084;3933.789,776.9629;Float;False;2083;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;1180;753.6788,2391.406;Float;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleAddOpNode;1809;1099.844,2595.995;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;676;-4288.413,-1585.12;Float;False;detail_index_3;-1;True;1;0;INT;0;False;1;INT;0
Node;AmplifyShaderEditor.CustomExpressionNode;2092;4007.594,934.141;Float;False;v.tangent.xyz = cross(v.normal, float3(0,0,1))@$			v.tangent.w = -1  @;1;True;0;TangentHack;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2083;4366.836,-1460.404;Float;False;endSmoothness;-1;True;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;674;-4289.713,-1658.919;Float;False;detail_index_2;-1;True;1;0;INT;0;False;1;INT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;978;-2423.887,2206.155;Float;False;detailAOoutput;-1;True;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2256;-2850.855,881.4374;Float;False;Property;_normalscaleclose;normal scale close;5;0;Create;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1962;950.3845,1799.466;Float;True;Property;_snowSpeckle;snowSpeckle;37;0;Create;None;0b4c3187d7b0af44fbe4e891f85fd895;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;2257;-2848.427,955.3995;Float;False;Property;_normalscalemid;normal scale mid;6;0;Create;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WeightedBlendNode;2284;2319.366,-1239.003;Float;False;5;0;FLOAT4;0,0,0,0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2302;-1.976745,2203.046;Float;False;Property;_closedetailDetail2;close detail Detail 2;17;0;Create;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2275;-2851.389,807.1862;Float;False;Property;_normalscaleveryclose;normal scale very close;4;0;Create;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1175;457.4777,1654.207;Float;False;2;2;0;FLOAT;0;False;1;INT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1167;1054.776,1641.908;Float;False;Property;_closenoisenormalscale;close noise normal scale;13;0;Create;1;1;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;150;697.1349,1430.183;Float;True;Property;_combined;combined;35;0;Create;None;cf088036e20a02142ad4eaa7883b3e3c;True;bump;Auto;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SaturateNode;1954;1806.18,2014.664;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2280;1980.369,-1026.003;Float;False;Property;_snowspecklestrengthdetail3;snow speckle strength detail 3;46;0;Create;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2260;-2822.995,1127.82;Float;False;273;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;672;-4294.113,-1734.12;Float;False;detail_index_1;-1;True;1;0;INT;0;False;1;INT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1179;469.5795,2386.807;Float;False;618;0;1;FLOAT4;0
Node;AmplifyShaderEditor.RelayNode;1813;2069.246,-1504.566;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;2082;-3940.114,-1717.539;Float;False;FLOAT4;4;0;INT;0;False;1;INT;0;False;2;INT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1181;1254.879,2418.606;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendNormalsNode;152;1671.342,1287.283;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;154;182.4356,1559.084;Float;False;Property;_closesmalldetailscale;close small detail scale;14;0;Create;128;128;0;200;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2166;3968.301,622.5605;Float;False;2165;0;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;2303;-1.976745,2286.046;Float;False;Property;_closedetailDetail3;close detail Detail 3;18;0;Create;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2283;1977.369,-1102.003;Float;False;Property;_snowspecklestrengthdetail2;snow speckle strength detail 2;45;0;Create;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;284;717.1949,746.7367;Float;False;279;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;2286;1400.63,1716.974;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;1165;843.5747,2123.609;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2165;2366.737,37.6525;Float;False;endAlbedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1294;621.485,3422.549;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2436;3859.106,1229.876;Float;False;273;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;283;707.5933,664.2099;Float;False;273;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;192;2672.6,1134.8;Float;False;endNormal;-1;True;1;0;FLOAT3;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BlendOpsNode;1293;920.6826,3786.741;Float;False;Overlay;True;2;0;FLOAT;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;545;681.5449,423.9904;Float;False;Property;_globalColorCloseMultiplier;globalColorCloseMultiplier;22;0;Create;1;0.278;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;2442;1618.656,458.643;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;2285;1668.512,1702.083;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;1177;277.4776,1702.207;Float;False;Constant;_Int4;Int 4;36;0;Create;4;0;0;1;INT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;763;-5903.964,-253.0239;Float;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;2306;16.02327,1944.047;Float;False;618;0;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;2305;-8.976697,2030.047;Float;False;Property;_closedetailDetail0;close detail Detail 0;15;0;Create;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2304;-2.976743,2109.047;Float;False;Property;_closedetailDetail1;close detail Detail 1;16;0;Create;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2287;1177.63,1971.974;Float;False;Property;_specklecontrast;speckle contrast;41;0;Create;1;1;1;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1820;2140.646,-1437.666;Float;False;Property;_snowspecklestrength;snow speckle strength;42;0;Create;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1819;2492.645,-1501.666;Float;False;3;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;157;696.5347,2001.284;Float;False;Property;_closedetailglobalstrength;close detail global strength;12;0;Create;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2281;1969.369,-1253.003;Float;False;Property;_snowspecklestrengthdetail0;snow speckle strength detail 0;43;0;Create;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WeightedBlendNode;2307;341.0235,2044.047;Float;False;5;0;FLOAT4;0,0,0,0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;557;692.6015,503.0116;Float;False;Property;_globalColorMidMultiplier;globalColorMidMultiplier;23;0;Create;0;0.592;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;155;673.4355,1632.084;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;744;655.2245,345.1195;Float;False;Property;_globalColorVeryCloseMultiplier;globalColorVeryCloseMultiplier;21;0;Create;0;0.077;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2261;-2810.393,1198.121;Float;False;279;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;4286.427,609.3609;Float;False;True;3;Float;ASEMaterialInspector;0;0;Standard;2SD/2SD_Terrain_Far;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;0;False;0;0;Opaque;0.5;True;True;0;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;0;4;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;1;BaseMapShader=2SD/2SD_Terrain_Base;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.CommentaryNode;1948;3884.976,1436.348;Float;False;292;197;Copy this ;0;If its a terrain shader(not a mesh) connect this to the VertexOffset output;1,1,1,1;0;0
WireConnection;1689;0;304;0
WireConnection;1689;1;1690;0
WireConnection;1691;0;1689;0
WireConnection;1691;1;1690;0
WireConnection;400;0;21;0
WireConnection;319;0;1511;0
WireConnection;319;1;1689;0
WireConnection;320;0;1511;0
WireConnection;320;1;304;0
WireConnection;318;0;1511;0
WireConnection;318;1;1691;0
WireConnection;577;0;319;0
WireConnection;2342;0;2329;0
WireConnection;578;0;318;0
WireConnection;2340;0;2331;0
WireConnection;529;0;320;0
WireConnection;2341;0;2328;0
WireConnection;2343;0;2330;0
WireConnection;2398;72;1526;0
WireConnection;2398;65;1527;0
WireConnection;2398;66;1528;0
WireConnection;2398;67;1529;0
WireConnection;2398;73;2354;0
WireConnection;2398;68;2355;0
WireConnection;2398;69;2356;0
WireConnection;2398;70;2357;0
WireConnection;2408;0;2398;71
WireConnection;2451;0;2450;0
WireConnection;2427;141;2451;0
WireConnection;2427;142;2451;0
WireConnection;2427;145;2415;0
WireConnection;2427;24;2156;0
WireConnection;2157;0;2427;43
WireConnection;2159;0;2427;46
WireConnection;2160;0;2427;48
WireConnection;2158;0;2427;44
WireConnection;2161;0;2157;3
WireConnection;2161;1;2158;3
WireConnection;2161;2;2159;3
WireConnection;2161;3;2160;3
WireConnection;1782;0;2161;0
WireConnection;1782;1;1608;0
WireConnection;1250;0;2;0
WireConnection;1670;0;1782;0
WireConnection;1670;1;1608;0
WireConnection;1716;0;1628;0
WireConnection;1716;1;1670;0
WireConnection;1633;0;1628;0
WireConnection;1632;0;1716;0
WireConnection;2320;5;1722;0
WireConnection;2320;3;1632;0
WireConnection;2320;10;1633;0
WireConnection;2320;14;41;0
WireConnection;1770;0;2320;21
WireConnection;1770;1;1633;0
WireConnection;2318;5;1770;0
WireConnection;2318;3;1632;1
WireConnection;2318;10;1633;1
WireConnection;2318;14;41;0
WireConnection;1771;0;2318;21
WireConnection;1771;1;1633;1
WireConnection;1794;0;2320;21
WireConnection;1794;1;2318;21
WireConnection;2319;5;1771;0
WireConnection;2319;3;1632;2
WireConnection;2319;10;1633;2
WireConnection;2319;14;41;0
WireConnection;1795;0;2319;21
WireConnection;1795;1;1794;0
WireConnection;1772;0;2319;21
WireConnection;1772;1;1633;2
WireConnection;1796;0;1795;0
WireConnection;1802;0;1633;3
WireConnection;1802;1;1796;0
WireConnection;1800;0;1633;1
WireConnection;1800;1;1796;0
WireConnection;1798;0;1633;0
WireConnection;1798;1;1796;0
WireConnection;1801;0;1633;2
WireConnection;1801;1;1796;0
WireConnection;2317;5;1772;0
WireConnection;2317;3;1632;3
WireConnection;2317;10;1633;3
WireConnection;2317;14;41;0
WireConnection;1803;0;2318;21
WireConnection;1803;1;1800;0
WireConnection;1805;0;2317;21
WireConnection;1805;1;1802;0
WireConnection;1799;0;2320;21
WireConnection;1799;1;1798;0
WireConnection;1804;0;2319;21
WireConnection;1804;1;1801;0
WireConnection;773;1;777;0
WireConnection;2079;0;1799;0
WireConnection;2079;1;1803;0
WireConnection;2079;2;1804;0
WireConnection;2079;3;1805;0
WireConnection;1818;0;773;0
WireConnection;1818;1;928;0
WireConnection;1944;0;2079;0
WireConnection;1292;0;1818;2
WireConnection;1292;1;935;0
WireConnection;1375;0;1944;0
WireConnection;2180;0;1292;0
WireConnection;2186;0;1376;0
WireConnection;1989;0;1990;0
WireConnection;1989;1;1992;0
WireConnection;2189;0;2180;0
WireConnection;2189;1;2186;0
WireConnection;1377;0;1376;0
WireConnection;2199;0;1377;3
WireConnection;2199;1;2189;0
WireConnection;2310;0;1989;1
WireConnection;2310;1;1989;2
WireConnection;2407;0;2398;64
WireConnection;2178;0;1377;3
WireConnection;2178;1;2199;0
WireConnection;2311;0;2310;0
WireConnection;2311;1;1989;2
WireConnection;2406;0;2398;0
WireConnection;2177;0;2178;0
WireConnection;2428;141;2409;0
WireConnection;2428;142;2410;0
WireConnection;2428;145;2411;0
WireConnection;2428;24;1923;0
WireConnection;2309;0;2311;0
WireConnection;1995;0;2309;0
WireConnection;1995;1;2428;44
WireConnection;1994;0;1989;4
WireConnection;1994;1;2428;48
WireConnection;1996;0;1989;3
WireConnection;1996;1;2428;46
WireConnection;2080;0;1377;0
WireConnection;2080;1;1377;1
WireConnection;2080;2;1377;2
WireConnection;2080;3;2177;0
WireConnection;1993;0;1989;1
WireConnection;1993;1;2428;43
WireConnection;2000;0;1996;0
WireConnection;2000;1;2428;46
WireConnection;2000;2;1998;0
WireConnection;2191;0;1818;1
WireConnection;2191;1;1818;3
WireConnection;618;0;2080;0
WireConnection;1999;0;1995;0
WireConnection;1999;1;2428;44
WireConnection;1999;2;1998;0
WireConnection;2001;0;1994;0
WireConnection;2001;1;2428;48
WireConnection;2001;2;1998;0
WireConnection;1997;0;1993;0
WireConnection;1997;1;2428;43
WireConnection;1997;2;1998;0
WireConnection;1328;0;2191;0
WireConnection;1945;0;1941;0
WireConnection;1945;1;1997;0
WireConnection;1945;2;1999;0
WireConnection;1945;3;2000;0
WireConnection;1945;4;2001;0
WireConnection;1321;0;1328;0
WireConnection;1697;0;1945;0
WireConnection;2453;0;1980;0
WireConnection;2453;1;2258;0
WireConnection;1446;0;1697;0
WireConnection;1327;0;1321;0
WireConnection;1327;1;1333;0
WireConnection;1335;0;1323;0
WireConnection;1335;1;1327;0
WireConnection;1325;0;1323;0
WireConnection;1325;1;1327;0
WireConnection;2441;1;2340;0
WireConnection;2441;16;2341;0
WireConnection;2441;17;2342;0
WireConnection;2441;19;2343;0
WireConnection;617;0;1446;0
WireConnection;2403;97;2414;0
WireConnection;2403;98;2413;0
WireConnection;2403;99;2412;0
WireConnection;2403;50;2453;0
WireConnection;2403;24;1968;0
WireConnection;279;0;2441;18
WireConnection;1978;0;1979;0
WireConnection;1978;1;2403;43
WireConnection;1978;2;2403;44
WireConnection;1978;3;2403;46
WireConnection;1978;4;2403;48
WireConnection;281;0;2441;20
WireConnection;1336;0;1335;0
WireConnection;1336;1;1325;0
WireConnection;1336;2;1321;0
WireConnection;2088;0;617;0
WireConnection;3;5;195;0
WireConnection;273;0;2441;0
WireConnection;1845;0;1110;0
WireConnection;1845;1;1112;0
WireConnection;1858;0;1978;0
WireConnection;4;1;1336;0
WireConnection;748;0;749;0
WireConnection;748;1;750;0
WireConnection;748;2;752;0
WireConnection;748;3;753;0
WireConnection;748;4;754;0
WireConnection;2085;0;2088;0
WireConnection;2454;0;18;0
WireConnection;2454;1;723;0
WireConnection;2454;2;285;0
WireConnection;2091;0;4;4
WireConnection;32;0;3;0
WireConnection;32;1;1858;0
WireConnection;984;0;1821;0
WireConnection;984;1;1366;0
WireConnection;1943;0;1845;0
WireConnection;755;0;748;0
WireConnection;755;1;2454;0
WireConnection;64;0;617;0
WireConnection;2089;0;2085;0
WireConnection;1835;0;741;0
WireConnection;1109;0;1858;0
WireConnection;1109;1;32;0
WireConnection;1109;2;1943;0
WireConnection;145;0;64;3
WireConnection;145;1;2091;0
WireConnection;145;2;984;0
WireConnection;2210;0;617;0
WireConnection;2210;1;4;0
WireConnection;2087;0;2089;0
WireConnection;2162;0;977;0
WireConnection;2162;1;2157;0
WireConnection;2162;2;2158;0
WireConnection;2162;3;2159;0
WireConnection;2162;4;2160;0
WireConnection;2431;0;755;0
WireConnection;1021;0;1109;0
WireConnection;1841;0;2162;0
WireConnection;1841;1;1835;0
WireConnection;26;0;2087;0
WireConnection;26;1;2210;0
WireConnection;26;2;2431;0
WireConnection;65;0;145;0
WireConnection;65;1;35;0
WireConnection;1949;0;1841;0
WireConnection;1983;0;26;0
WireConnection;209;0;1021;0
WireConnection;1151;0;65;0
WireConnection;1151;1;1589;1
WireConnection;1151;2;1589;2
WireConnection;1151;3;1152;0
WireConnection;1151;4;1153;0
WireConnection;2449;23;18;0
WireConnection;2449;19;744;0
WireConnection;2449;20;545;0
WireConnection;2449;21;557;0
WireConnection;2449;22;723;0
WireConnection;2449;24;283;0
WireConnection;2449;25;284;0
WireConnection;2449;26;285;0
WireConnection;1826;0;64;3
WireConnection;1826;1;1819;0
WireConnection;1961;0;150;0
WireConnection;1961;1;155;0
WireConnection;1961;5;1167;0
WireConnection;48;0;763;1
WireConnection;2443;0;2442;0
WireConnection;50;0;763;3
WireConnection;2448;23;1980;0
WireConnection;2448;19;2275;0
WireConnection;2448;20;2256;0
WireConnection;2448;21;2257;0
WireConnection;2448;22;2258;0
WireConnection;2448;24;2260;0
WireConnection;2448;25;2261;0
WireConnection;2448;26;2259;0
WireConnection;2435;0;2434;0
WireConnection;153;0;1021;0
WireConnection;153;1;152;0
WireConnection;153;2;1954;0
WireConnection;1955;0;1165;0
WireConnection;2212;0;4;0
WireConnection;2212;1;617;0
WireConnection;1347;0;2082;0
WireConnection;39;0;763;0
WireConnection;2440;0;2435;0
WireConnection;1166;0;157;0
WireConnection;1166;1;1955;0
WireConnection;1166;2;2307;0
WireConnection;1817;0;1812;0
WireConnection;1812;0;1809;0
WireConnection;49;0;763;2
WireConnection;663;0;718;0
WireConnection;1816;0;1962;1
WireConnection;1816;1;1817;0
WireConnection;1180;0;1179;0
WireConnection;1809;0;1180;0
WireConnection;1809;1;1180;3
WireConnection;676;0;721;0
WireConnection;2083;0;1151;0
WireConnection;674;0;720;0
WireConnection;978;0;1949;0
WireConnection;1962;1;155;0
WireConnection;2284;0;2282;0
WireConnection;2284;1;2281;0
WireConnection;2284;2;2279;0
WireConnection;2284;3;2283;0
WireConnection;2284;4;2280;0
WireConnection;1175;0;154;0
WireConnection;1175;1;1177;0
WireConnection;1954;0;1166;0
WireConnection;672;0;719;0
WireConnection;1813;0;2285;0
WireConnection;2082;0;663;0
WireConnection;2082;1;672;0
WireConnection;2082;2;674;0
WireConnection;2082;3;676;0
WireConnection;1181;0;1180;1
WireConnection;1181;1;1180;2
WireConnection;152;0;1021;0
WireConnection;152;1;1961;0
WireConnection;2286;0;1962;4
WireConnection;2286;1;2287;0
WireConnection;1165;0;739;0
WireConnection;2165;0;1983;0
WireConnection;1294;0;1292;0
WireConnection;1294;1;1377;3
WireConnection;192;0;209;0
WireConnection;1293;0;1294;0
WireConnection;1293;1;1377;3
WireConnection;2442;0;2449;0
WireConnection;2285;0;2286;0
WireConnection;763;0;2;0
WireConnection;1819;0;1813;0
WireConnection;1819;1;1820;0
WireConnection;1819;2;2284;0
WireConnection;2307;0;2306;0
WireConnection;2307;1;2305;0
WireConnection;2307;2;2304;0
WireConnection;2307;3;2302;0
WireConnection;2307;4;2303;0
WireConnection;155;0;1175;0
WireConnection;0;0;2166;0
WireConnection;0;1;193;0
WireConnection;0;4;2084;0
WireConnection;0;5;980;0
WireConnection;0;11;2092;0
ASEEND*/
//CHKSM=226D8496CB3A8EAE4D37D129E0B0C49C2C24335E