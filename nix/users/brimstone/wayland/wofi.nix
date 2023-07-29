{ custom, ... }:
{
    home.file.".config/wofi/style.css".text = ''
        *{
        font-family: ${custom.font},monospace;
        }

        window {
        margin: 0px;
        border: 2px solid #${custom.accent};
        background-color: #${custom.background};
        border-radius: 20px;
        }

        #input {
        margin: 5px;
        border: none;
        color: #F5F5F5;
        background-color: #${custom.background};
        border: 2px solid #${custom.accent};
        border-radius: 10px;
        margin: 10px;
        }

        #inner-box {
        margin: 5px;
        border: none;
        background-color: #${custom.background};
        border-radius: 20px;
        }

        #outer-box {
        margin: 5px;
        border: none;
        background-color: #${custom.background};
        border-radius: 20px;
        }

        #scroll {
        margin: 0px;
        border: none;
        }

        #text {
        margin: 5px;
        border: none;
        color: #${custom.accent};
        } 
        #text:selected{
        color:#F5F5F5;
        }

        #entry:selected {
        background-color: #${custom.accent};
        }
        '';
}
