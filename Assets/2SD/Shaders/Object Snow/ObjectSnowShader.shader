// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "2SD/ObjectSnowShader"
{
	Properties
	{
		[HideInInspector] __dirty( "", Int ) = 1
		_AlbedorgbsmoothnessA("Albedo(rgb), smoothness(A)", 2D) = "white" {}
		[Normal]_Normal("Normal", 2D) = "bump" {}
		_CombinedMapsMetallicRAOG("Combined Maps(Metallic(R), AO(G))", 2D) = "white" {}
		_Detailstrength("Detail strength", Range( 0 , 1)) = 0
		_DetailAlbedo("Detail Albedo", 2D) = "white" {}
		[Normal]_DetailNormal("Detail Normal", 2D) = "bump" {}
		_detailtiling("detail tiling", Float) = 0
		_MaterialOnTopColor("Material On Top Color", Color) = (0.9423078,0.9615385,1,1)
		_Snowlayeropacity("Snow layer opacity", Range( 0 , 1)) = 0
		_snowstrength("snow strength", Range( 0 , 1)) = 0
		_snownormalcontribution("snow normal contribution", Range( 0 , 3)) = 0
		_min("min", Range( 0 , 1)) = 0
		_max("max", Range( 0 , 1)) = 0
		_snowalbedo("snow albedo", 2D) = "white" {}
		[Normal]_snownormal("snow normal", 2D) = "bump" {}
		_SecondMaterialNormalStrength("Second Material Normal Strength", Range( 0 , 1)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma multi_compile_instancing
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
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
			float2 texcoord_0;
		};

		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform sampler2D _DetailNormal;
		uniform float _detailtiling;
		uniform float _Detailstrength;
		uniform sampler2D _snownormal;
		uniform float _SecondMaterialNormalStrength;
		uniform float _snowstrength;
		uniform float _snownormalcontribution;
		uniform float _min;
		uniform float _max;
		uniform float _Snowlayeropacity;
		uniform sampler2D _AlbedorgbsmoothnessA;
		uniform float4 _AlbedorgbsmoothnessA_ST;
		uniform sampler2D _DetailAlbedo;
		uniform float4 _MaterialOnTopColor;
		uniform sampler2D _snowalbedo;
		uniform sampler2D _CombinedMapsMetallicRAOG;
		uniform float4 _CombinedMapsMetallicRAOG_ST;


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
			float2 temp_cast_0 = (_detailtiling).xx;
			o.texcoord_0.xy = v.texcoord.xy * temp_cast_0 + float2( 0,0 );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			float3 tex2DNode3 = UnpackNormal( tex2D( _Normal, uv_Normal ) );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 localPos = mul( unity_WorldToObject, float4( ase_worldPos, 1 ) );
			float3 localNormal = mul( unity_WorldToObject, float4( ase_worldNormal, 0 ) );
			float4 triplanar91 = TriplanarSampling( _DetailNormal, _DetailNormal, _DetailNormal, localPos, localNormal, 1.0, _detailtiling, 0 );
			float3 temp_output_9_0 = BlendNormals( tex2DNode3 , UnpackScaleNormal( triplanar91 ,_Detailstrength ) );
			float4 triplanar112 = TriplanarSampling( _snownormal, _snownormal, _snownormal, ase_worldPos, ase_worldNormal, 1.0, 0.25, 0 );
			float3 lerpResult182 = lerp( BlendNormals( temp_output_9_0 , UnpackScaleNormal( triplanar112 ,_SecondMaterialNormalStrength ) ) , UnpackScaleNormal( triplanar112 ,_SecondMaterialNormalStrength ) , _SecondMaterialNormalStrength);
			float3 ase_vertexNormal = mul( unity_WorldToObject, float4( ase_worldNormal, 0 ) );
			float4 transform85 = mul(unity_ObjectToWorld,float4( ase_vertexNormal , 0.0 ));
			float temp_output_49_0 = saturate( ( (0.0 + (( _snowstrength * ( transform85.y * ( _snownormalcontribution * tex2DNode3.b ) ) ) - _min) * (1.0 - 0.0) / (_max - _min)) * _Snowlayeropacity ) );
			float snowMask102 = temp_output_49_0;
			float3 lerpResult101 = lerp( temp_output_9_0 , lerpResult182 , snowMask102);
			o.Normal = lerpResult101;
			float2 uv_AlbedorgbsmoothnessA = i.uv_texcoord * _AlbedorgbsmoothnessA_ST.xy + _AlbedorgbsmoothnessA_ST.zw;
			float4 tex2DNode1 = tex2D( _AlbedorgbsmoothnessA, uv_AlbedorgbsmoothnessA );
			float2 detailUV28 = i.texcoord_0;
			float4 lerpResult95 = lerp( tex2DNode1 , ( tex2DNode1 * ( tex2D( _DetailAlbedo, detailUV28 ) * 4.0 ) ) , _Detailstrength);
			float4 triplanar110 = TriplanarSampling( _snowalbedo, _snowalbedo, _snowalbedo, ase_worldPos, ase_worldNormal, 1.0, 0.25, 0 );
			float4 lerpResult19 = lerp( lerpResult95 , ( _MaterialOnTopColor * triplanar110 ) , snowMask102);
			o.Albedo = lerpResult19.rgb;
			float2 uv_CombinedMapsMetallicRAOG = i.uv_texcoord * _CombinedMapsMetallicRAOG_ST.xy + _CombinedMapsMetallicRAOG_ST.zw;
			float4 tex2DNode80 = tex2D( _CombinedMapsMetallicRAOG, uv_CombinedMapsMetallicRAOG );
			o.Metallic = tex2DNode80.r;
			float componentMask139 = lerpResult19.a;
			o.Smoothness = componentMask139;
			o.Occlusion = saturate( ( snowMask102 + tex2DNode80.g ) );
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows vertex:vertexDataFunc 

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
				fixed3 worldNormal = UnityObjectToWorldNormal( v.normal );
				fixed3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				fixed tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				fixed3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.texcoords01 = float4( v.texcoord.xy, v.texcoord1.xy );
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
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
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
Version=13111
-1913;58;1906;1004;2621.728;914.2247;2.107625;True;True
Node;AmplifyShaderEditor.CommentaryNode;34;-992.8741,-940.3057;Float;False;2160.966;519.4407;Comment;14;20;64;102;49;25;62;27;26;85;67;83;175;179;180;Snow;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;3;-1060.92,361.9088;Float;True;Property;_Normal;Normal;1;1;[Normal];None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;180;-954.5972,-520.4625;Float;False;Property;_snownormalcontribution;snow normal contribution;10;0;0;0;3;0;1;FLOAT
Node;AmplifyShaderEditor.NormalVertexDataNode;83;-979.8262,-716.3959;Float;False;0;5;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.CommentaryNode;31;-1949.625,-620.4789;Float;False;883.6521;212.1874;Comment;3;8;7;28;Detail UV;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;179;-581.7973,-518.8623;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;85;-764.428,-721.2164;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;8;-1899.625,-548.9031;Float;False;Property;_detailtiling;detail tiling;6;0;0;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;175;-434.6731,-652.879;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.CommentaryNode;32;-915.1533,-1382.999;Float;False;915.4279;366.0094;Comment;4;5;29;15;16;Detail Albedo;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;67;-552.5284,-809.0958;Float;False;Property;_snowstrength;snow strength;9;0;0;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.TextureCoordinatesNode;7;-1648.917,-564.2914;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RegisterLocalVarNode;28;-1308.974,-570.4788;Float;False;detailUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2
Node;AmplifyShaderEditor.RangedFloatNode;27;-202.0557,-684.9326;Float;False;Property;_min;min;11;0;0;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.TexturePropertyNode;92;-1900.625,116.3048;Float;True;Property;_DetailNormal;Detail Normal;5;1;[Normal];None;True;bump;Auto;0;1;SAMPLER2D
Node;AmplifyShaderEditor.TexturePropertyNode;98;-181.7621,321.4434;Float;True;Property;_snownormal;snow normal;14;1;[Normal];None;True;bump;Auto;0;1;SAMPLER2D
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;62;-186.6296,-801.6969;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0,0,0,0;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;111;-39.22779,79.54623;Float;False;Constant;_snowtiling;snow tiling;15;0;0.25;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.GetLocalVarNode;29;-865.1532,-1301.829;Float;False;28;0;1;FLOAT2
Node;AmplifyShaderEditor.RangedFloatNode;26;-198.0557,-609.9329;Float;False;Property;_max;max;12;0;0;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.RelayNode;155;205.9724,84.64675;Float;False;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.RelayNode;156;148.824,325.0379;Float;False;1;0;SAMPLER2D;0.0;False;1;SAMPLER2D
Node;AmplifyShaderEditor.RangedFloatNode;94;-1525.04,330.2845;Float;False;Property;_Detailstrength;Detail strength;3;0;0;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.TriplanarNode;91;-1599.149,125.7539;Float;True;Spherical;Object;False;Top Texture 0;_TopTexture0;bump;2;None;Mid Texture 0;_MidTexture0;white;-1;None;Bot Texture 0;_BotTexture0;white;-1;None;Triplanar Sampler;5;0;SAMPLER2D;;False;1;SAMPLER2D;;False;2;SAMPLER2D;;False;3;FLOAT;1.0;False;4;FLOAT;1.0;False;5;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;16;-494.9146,-1141.599;Float;False;Constant;_detailalbedoboost;detail albedo boost;7;0;4;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;20;106.4619,-534.1866;Float;False;Property;_Snowlayeropacity;Snow layer opacity;8;0;0;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.TFHCRemap;25;197.2173,-794.0609;Float;False;5;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;3;FLOAT;0.0;False;4;FLOAT;1.0;False;1;FLOAT
Node;AmplifyShaderEditor.TexturePropertyNode;97;83.80675,-117.9961;Float;True;Property;_snowalbedo;snow albedo;13;0;None;False;white;Auto;0;1;SAMPLER2D
Node;AmplifyShaderEditor.SamplerNode;5;-563.5291,-1332.999;Float;True;Property;_DetailAlbedo;Detail Albedo;4;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.TriplanarNode;112;360.8288,320.4363;Float;True;Spherical;World;False;Top Texture 2;_TopTexture2;bump;0;None;Mid Texture 2;_MidTexture2;white;-1;None;Bot Texture 2;_BotTexture2;white;-1;None;Triplanar Sampler;5;0;SAMPLER2D;;False;1;SAMPLER2D;;False;2;SAMPLER2D;;False;3;FLOAT;1.0;False;4;FLOAT;1.0;False;5;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;173;368.0147,507.0049;Float;False;Property;_SecondMaterialNormalStrength;Second Material Normal Strength;15;0;1;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.UnpackScaleNormalNode;93;-1158.425,135.3522;Float;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;1.0;False;4;FLOAT3;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;1;135.3613,-1332.624;Float;True;Property;_AlbedorgbsmoothnessA;Albedo(rgb), smoothness(A);0;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;497.372,-646.996;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.TriplanarNode;110;487.4632,-116.4677;Float;True;Spherical;World;False;Top Texture 1;_TopTexture1;white;1;None;Mid Texture 1;_MidTexture1;white;-1;None;Bot Texture 1;_BotTexture1;white;-1;None;Triplanar Sampler;5;0;SAMPLER2D;;False;1;SAMPLER2D;;False;2;SAMPLER2D;;False;3;FLOAT;1.0;False;4;FLOAT;1.0;False;5;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.ColorNode;18;572.2653,-308.3644;Float;False;Property;_MaterialOnTopColor;Material On Top Color;7;0;0.9423078,0.9615385,1,1;0;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-168.7244,-1152.87;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.BlendNormalsNode;9;-56.35589,169.9688;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3
Node;AmplifyShaderEditor.UnpackScaleNormalNode;143;759.68,331.7824;Float;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;1.0;False;4;FLOAT3;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SaturateNode;49;696.6728,-644.3977;Float;False;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.TexturePropertyNode;81;391.8507,854.0516;Float;True;Property;_CombinedMapsMetallicRAOG;Combined Maps(Metallic(R), AO(G));2;0;None;False;white;Auto;0;1;SAMPLER2D
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;109;919.3836,-143.0707;Float;False;2;2;0;COLOR;0.0,0,0,0;False;1;FLOAT4;0.0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;519.3612,-1172.624;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0.0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.RelayNode;172;1156.147,13.98702;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.BlendNormalsNode;181;1169.725,295.3173;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3
Node;AmplifyShaderEditor.GetLocalVarNode;104;817.3297,244.9362;Float;False;102;0;1;FLOAT
Node;AmplifyShaderEditor.SamplerNode;80;935.8504,854.0516;Float;True;Property;_TextureSample0;Texture Sample 0;9;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.CommentaryNode;130;1676.933,833.4269;Float;False;421.2003;184.9999;Comment;2;129;128;Remove AO from snowy parts;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;95;931.5612,-1201.424;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0.0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.RegisterLocalVarNode;102;931.6738,-647.0959;Float;False;snowMask;-1;True;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.LerpOp;182;1442.209,398.2513;Float;False;3;0;FLOAT3;0.0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0.0,0,0;False;1;FLOAT3
Node;AmplifyShaderEditor.LerpOp;19;1546.276,45.99889;Float;False;3;0;COLOR;0.0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.SimpleAddOpNode;129;1726.933,885.4267;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.ComponentMaskNode;139;1792.674,264.4047;Float;False;False;False;False;True;1;0;COLOR;0,0,0,0;False;1;FLOAT
Node;AmplifyShaderEditor.RelayNode;177;2009.199,443.7606;Float;False;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SaturateNode;128;1923.133,883.4269;Float;False;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.RelayNode;176;978.6404,-362.026;Float;False;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.LerpOp;101;1544.832,183.6365;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0.0,0,0;False;2;FLOAT;0.0,0,0;False;1;FLOAT3
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2208.128,114.5374;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;2SD/ObjectSnowShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;Back;0;0;False;0;0;Opaque;0.5;True;True;0;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;False;0;4;10;25;False;0.5;True;0;SrcAlpha;OneMinusSrcAlpha;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexOffset;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;OBJECT;0.0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;179;0;180;0
WireConnection;179;1;3;3
WireConnection;85;0;83;0
WireConnection;175;0;85;2
WireConnection;175;1;179;0
WireConnection;7;0;8;0
WireConnection;28;0;7;0
WireConnection;62;0;67;0
WireConnection;62;1;175;0
WireConnection;155;0;111;0
WireConnection;156;0;98;0
WireConnection;91;0;92;0
WireConnection;91;3;8;0
WireConnection;25;0;62;0
WireConnection;25;1;27;0
WireConnection;25;2;26;0
WireConnection;5;1;29;0
WireConnection;112;0;156;0
WireConnection;112;3;155;0
WireConnection;93;0;91;0
WireConnection;93;1;94;0
WireConnection;64;0;25;0
WireConnection;64;1;20;0
WireConnection;110;0;97;0
WireConnection;110;3;155;0
WireConnection;15;0;5;0
WireConnection;15;1;16;0
WireConnection;9;0;3;0
WireConnection;9;1;93;0
WireConnection;143;0;112;0
WireConnection;143;1;173;0
WireConnection;49;0;64;0
WireConnection;109;0;18;0
WireConnection;109;1;110;0
WireConnection;11;0;1;0
WireConnection;11;1;15;0
WireConnection;172;0;109;0
WireConnection;181;0;9;0
WireConnection;181;1;143;0
WireConnection;80;0;81;0
WireConnection;95;0;1;0
WireConnection;95;1;11;0
WireConnection;95;2;94;0
WireConnection;102;0;49;0
WireConnection;182;0;181;0
WireConnection;182;1;143;0
WireConnection;182;2;173;0
WireConnection;19;0;95;0
WireConnection;19;1;172;0
WireConnection;19;2;104;0
WireConnection;129;0;104;0
WireConnection;129;1;80;2
WireConnection;139;0;19;0
WireConnection;177;0;176;0
WireConnection;128;0;129;0
WireConnection;176;0;49;0
WireConnection;101;0;9;0
WireConnection;101;1;182;0
WireConnection;101;2;104;0
WireConnection;0;0;19;0
WireConnection;0;1;101;0
WireConnection;0;3;80;1
WireConnection;0;4;139;0
WireConnection;0;5;128;0
ASEEND*/
//CHKSM=4EFAAE85FE8ADED2FA7269EFA1300CF0260FC4CA