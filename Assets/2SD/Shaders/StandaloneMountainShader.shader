// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "2SD/Standalone Mountain"
{
	Properties
	{
		_AlbedoRGBSmoothnessA("Albedo(RGB) Smoothness(A)", 2D) = "white" {}
		_SmoothnessMin("Smoothness Min", Range( 0 , 1)) = 0
		_SmoothnessMax("Smoothness Max", Range( 0 , 1)) = 1
		_HeightRAOGSnowmaskB("Height(R) AO(G) Snow mask(B)", 2D) = "white" {}
		[Normal]_Normal("Normal", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform sampler2D _AlbedoRGBSmoothnessA;
		uniform float4 _AlbedoRGBSmoothnessA_ST;
		uniform float _SmoothnessMin;
		uniform float _SmoothnessMax;
		uniform sampler2D _HeightRAOGSnowmaskB;
		uniform float4 _HeightRAOGSnowmaskB_ST;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			o.Normal = UnpackNormal( tex2D( _Normal, uv_Normal ) );
			float2 uv_AlbedoRGBSmoothnessA = i.uv_texcoord * _AlbedoRGBSmoothnessA_ST.xy + _AlbedoRGBSmoothnessA_ST.zw;
			float4 tex2DNode1 = tex2D( _AlbedoRGBSmoothnessA, uv_AlbedoRGBSmoothnessA );
			o.Albedo = tex2DNode1.rgb;
			float2 _Vector0 = float2(0,1);
			o.Smoothness = (_SmoothnessMin + (tex2DNode1.a - _Vector0.x) * (_SmoothnessMax - _SmoothnessMin) / (_Vector0.y - _Vector0.x));
			float2 uv_HeightRAOGSnowmaskB = i.uv_texcoord * _HeightRAOGSnowmaskB_ST.xy + _HeightRAOGSnowmaskB_ST.zw;
			o.Occlusion = tex2D( _HeightRAOGSnowmaskB, uv_HeightRAOGSnowmaskB ).g;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14201
-1913;70;1906;1004;1673.875;468.6502;1.3;True;True
Node;AmplifyShaderEditor.RangedFloatNode;16;-902.7003,225.6006;Float;False;Property;_SmoothnessMax;Smoothness Max;2;0;Create;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-974.798,-287.5999;Float;True;Property;_AlbedoRGBSmoothnessA;Albedo(RGB) Smoothness(A);0;0;Create;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;14;-794.4,-24.29939;Float;False;Constant;_Vector0;Vector 0;3;0;Create;0,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;15;-901.5004,146.7005;Float;False;Property;_SmoothnessMin;Smoothness Min;1;0;Create;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;10;-973.8771,546.9542;Float;False;664.7999;247.2;Height(R) AO(G) Snow mask(B);1;2;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;3;-932.0006,342.5;Float;True;Property;_Normal;Normal;4;1;[Normal];Create;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;13;-501.6016,-5.799459;Float;False;5;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;3;FLOAT;0.0;False;4;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-924.8785,591.8532;Float;True;Property;_HeightRAOGSnowmaskB;Height(R) AO(G) Snow mask(B);3;0;Create;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-1,0;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;2SD/Standalone Mountain;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Opaque;0.5;True;True;0;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;0;4;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;13;0;1;4
WireConnection;13;1;14;1
WireConnection;13;2;14;2
WireConnection;13;3;15;0
WireConnection;13;4;16;0
WireConnection;0;0;1;0
WireConnection;0;1;3;0
WireConnection;0;4;13;0
WireConnection;0;5;2;2
ASEEND*/
//CHKSM=AB00781C8B5618EFFABCC9F26A9575E568DB0371