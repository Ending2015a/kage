Shader "Custom/TransparentShadow"
{
    Properties
    {
        _ShadowColor("ShadowColor", Color) = (0.2, 0.2, 0.2, 0.8)
    }
    SubShader
    {

        Pass
        {
            Tags
            {
                "RenderType"="Transparent"
                "Queue"="Transparent"
                "LightMode"="ForwardBase"
            }
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha
            LOD 100

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdbase

            #include "UnityCG.cginc"
            #include "AutoLight.cginc"

            struct v2f
            {
                float4 pos : SV_POSITION;
                LIGHTING_COORDS(0,1)
            };

            float4 _ShadowColor;

            v2f vert (appdata_base v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                TRANSFER_VERTEX_TO_FRAGMENT(o);
                return o;
            }

            fixed4 frag (v2f i) : COLOR
            {
                float atten = LIGHT_ATTENUATION(i);
                return fixed4(_ShadowColor.rgb, _ShadowColor.a * (1-atten));
            }
            ENDCG
        }
    }

    Fallback "VertexLit"
}
