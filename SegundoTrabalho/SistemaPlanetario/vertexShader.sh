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
    uniform float uVertexPointSize;
    uniform mat4 uModelViewMatrix;
    uniform mat4 uNormalMatrix;
    uniform mat4 uProjectionMatrix;
    uniform int uTextureActive;
    uniform vec3 uLightPos;
    uniform vec3 uEyePos;


    void main(void) {
        mat3 normalMatrix = transpose(inverse(mat3(uModelViewMatrix)));

        vec4 vertexPos = uModelViewMatrix * vec4(aVertexPos, 1.0);
        vec4 light =  uModelViewMatrix * vec4(2.0,5.0,1.0, 1.0);
        vec3 lightDir = normalize(light.xyz - vertexPos.xyz);
        vec3 normalVec = normalize(normalMatrix * aVertexNormal);
        vec3 viewDir = normalize(uEyePos - vertexPos.xyz);
        float lambert = max(dot(normalVec, lightDir), 0.0);

        vec4 matDiff;
        if (uTextureActive == 0) {
            matDiff = vec4(aVertexColor, 1.0); // Use vertex color if texture is not active
        } else {
            matDiff = vec4(1.0); // Use white color if texture is active
        }

        vec3 Ia = vec3(0.0); // Ambient reflection coefficient
        vec3 Id = vec3(1.8) * lambert; // Diffuse reflection coefficient
        vec3 Is = vec3(1.4); // Specular reflection coefficient

        float shininess = 1.0;

        vec3 reflectDir = reflect(lightDir, normalVec);
        float specular = pow(max(dot(reflectDir, viewDir), 0.0), shininess);

        vec3 lightColor = Ia + Id + Is * specular;
        vColor = vec4(lightColor * matDiff.rgb, 1.0);

        gl_Position = uProjectionMatrix * vertexPos;

        vTextureCoordinate = aTextureCoordinate;
    }