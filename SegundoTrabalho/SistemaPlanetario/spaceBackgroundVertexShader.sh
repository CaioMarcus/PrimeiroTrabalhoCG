#version 300 es
precision mediump float;
precision mediump int;

in vec3 aVertexPos;
in vec3 aVertexColor;
in vec3 aVertexNormal;
in vec2 aTextureCoordinate;

smooth out vec4 vColor;
smooth out vec3 vNormal;
out vec2 vTextureCoordinate;
out vec3 vLightVec;
out vec3 vEyeVec;
out vec3 vFragPos;

uniform float uVertexPointSize;
uniform mat4 uModelViewMatrix;
uniform mat4 uNormalMatrix;
uniform mat4 uProjectionMatrix;
uniform int uTextureActive;
uniform vec3 uLightPos;
uniform vec3 uEyePos;

void main(void) {
    vec4 pos = vec4(aVertexPos,1.0);
    vec4 newPos = uProjectionMatrix * uModelViewMatrix * pos;

    vColor = vec4(aVertexColor,1.0);

    gl_Position = newPos;
    vTextureCoordinate = aTextureCoordinate;
}
