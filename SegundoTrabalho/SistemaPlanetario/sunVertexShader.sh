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
        vec4 pos = vec4(aVertexPos,1.0);
        vec4 newPos = uProjectionMatrix * uModelViewMatrix * pos;

        vec4 matDiff,matSpec;

        //Se houver textura, o material da superficie e definido pela cor dos vertices
        if (uTextureActive==0){
            matDiff = vColor;
            matSpec = vColor;
        }
        else{// se nao é um cor branca
            matDiff = vec4(1.0,1.0,1.0,1.0);
            matSpec = vec4(1.0,1.0,1.0,1.0);
        }

        vec3 Ia; //Iluminacao ambiental
        float Ka = 3.0;

        //Calculo da compoenente ambiental
        Ia = Ka*vec3(1.0,1.0,1.0);   

        vec3 lightColor = Ia;
        vColor = vec4(lightColor * matDiff.rgb, 1.0);

        gl_Position = newPos;
        vTextureCoordinate = aTextureCoordinate;
    }