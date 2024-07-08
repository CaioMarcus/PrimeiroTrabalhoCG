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
      // Calculate normal matrix (transpose of the inverse of the modelview matrix)
    mat3 normalMatrix = transpose(inverse(mat3(uModelViewMatrix)));

    // Transform vertex position to eye coordinates
    vec4 vertexPos = uModelViewMatrix * vec4(aVertexPos, 1.0);

    vec4 light =  uModelViewMatrix * vec4(uLightPos,1.0);

    // Calculate light direction in eye coordinates
    vec3 lightDir = normalize(light.xyz - vertexPos.xyz);

    // Calculate normal vector in eye coordinates
    vec3 normalVec = normalize(normalMatrix * aVertexNormal);

    // Calculate view direction in eye coordinates
    vec3 viewDir = normalize(uEyePos - vertexPos.xyz);

    // Calculate Lambertian diffuse reflection (cosine of angle between light direction and normal vector)
    float lambert = max(dot(normalVec, lightDir), 0.0);

    // Material properties
    vec4 matDiff;
    if (uTextureActive == 0) {
        matDiff = vec4(aVertexColor, 1.0); // Use vertex color if texture is not active
    } else {
        matDiff = vec4(1.0); // Use white color if texture is active
    }

    // Ambient, Diffuse, and Specular reflection coefficients
    vec3 Ia = vec3(0.0); // Ambient reflection coefficient
    vec3 Id = vec3(1.8) * lambert; // Diffuse reflection coefficient
    vec3 Is = vec3(1.4); // Specular reflection coefficient

    // Specular exponent (shininess)
    float shininess = 1.0;

    // Calculate specular reflection using Phong model
    vec3 reflectDir = reflect(lightDir, normalVec);
    float specular = pow(max(dot(reflectDir, viewDir), 0.0), shininess);

    // Final color calculation
    vec3 lightColor = Ia + Id + Is * specular;
    vColor = vec4(lightColor * matDiff.rgb, 1.0);

    // Set gl_Position for vertex shader
    gl_Position = uProjectionMatrix * vertexPos;

    // Pass texture coordinate to fragment shader
    vTextureCoordinate = aTextureCoordinate;
    }