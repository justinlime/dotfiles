{ ... }:
{
  virtualisation.oci-containers.containers = {
    wyoming-openai = {
     autoStart = true; 
     image = "ghcr.io/roryeckel/wyoming_openai:latest";
     ports = [ "10301:10300" ];
     environment = {
       # LOG_LEVEL = "DEBUG";
       # TTS_OPENAI_URL = "http://10.69.42.200:/v1";
       # TTS_MODELS = "kokoro";
       # TTS_BACKEND = "KOKORO_FASTAPI";
       # TTS_VOICES = "am_santa";
       # WYOMING_URI = "tcp://0.0.0.0:10300";

       LOG_LEVEL = "DEBUG";
       TTS_OPENAI_URL = "http://10.69.42.200:1314/v1";
       TTS_MODELS = "tts-1";
       TTS_STREAMING_MODELS = "tts-1";
       TTS_BACKEND = "OPENAI";
       TTS_VOICES = "alloy";
       TTS_SPEED= "1.0";
       WYOMING_URI = "tcp://0.0.0.0:10300";
     };
   };  
  };
}
