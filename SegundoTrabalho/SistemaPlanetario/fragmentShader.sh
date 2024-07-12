#version 300 es
precision mediump float;
precision mediump int;

in vec4 vColor;
in vec3 vNormal;
in vec2 vTextureCoordinate;
in vec3 vLightVec;
in vec3 vEyeVec;
in vec3 vFragPos;

out vec4 fragColor;
uniform int uTextureActive;
uniform sampler2D uSampler;

void main(void) {
    vec3 normalVec = normalize(vNormal);
    vec3 lightVec = normalize(vLightVec);
    vec3 eyeVec = normalize(vEyeVec);

    float lambert = dot(normalVec, lightVec);
    vec4 matDiff, matSpec;

    if (uTextureActive == 0) {
        matDiff = vColor;
        matSpec = vColor;
    } else {
        matDiff = vec4(1.0, 1.0, 1.0, 1.0);
        matSpec = vec4(1.0, 1.0, 1.0, 1.0);
    }

    vec3 Ia; // Iluminação ambiental
    vec3 Id; // Iluminação difusa
    vec3 Is; // Iluminação especular
    float Ka = 0.1;
    float Kd = 0.8;
    float Ks = 1.2;
    float ns = 4.0;

    // Cálculo da componente ambiental
    Ia = Ka * vec3(1.0, 1.0, 1.0);

    vec3 halfwayVec = normalize(lightVec + eyeVec);
    float specAngle = max(dot(halfwayVec, normalVec), 0.0);
    float specular = pow(specAngle, ns);
    Id = Kd * vec3(lambert * matDiff);
    Is = Ks * vec3(specular * matSpec);

    vec3 lightColor = Ia + Id + Is;
    vec4 finalColor = vec4(lightColor * matDiff.rgb, 1.0);

    if (uTextureActive == 1) {
        fragColor = finalColor * texture(uSampler, vTextureCoordinate);
    } else {
        fragColor = finalColor;
    }
}
