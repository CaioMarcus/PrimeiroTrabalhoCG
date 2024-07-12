#version 300 es
precision mediump float;
precision mediump int;

in vec4 vColor;
in vec2 vTextureCoordinate;

out vec4 fragColor;
uniform int uTextureActive;
uniform sampler2D uSampler;

void main(void) {
    vec4 matDiff, matSpec;

    if (uTextureActive == 0) {
        matDiff = vColor;
        matSpec = vColor;
    } else {
        matDiff = vec4(1.0, 1.0, 1.0, 1.0);
        matSpec = vec4(1.0, 1.0, 1.0, 1.0);
    }

    vec3 Ia; // Iluminação ambiental
    float Ka = 1.0;

    // Cálculo da componente ambiental
    Ia = Ka * vec3(1.0, 1.0, 1.0);

    vec3 lightColor = Ia;
    vec4 finalColor = vec4(lightColor * matDiff.rgb, 1.0);

    if (uTextureActive == 1) {
        fragColor = finalColor * texture(uSampler, vTextureCoordinate);
    } else {
        fragColor = finalColor;
    }
}
