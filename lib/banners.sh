#!/bin/bash

# Colorsh and tuiutils library required must be sourced

banners:rabbit() {
    case "${1}" in
        [oO][nN][eE]|--[oO][nN][eE]|1)
            __randomcolor simple
            echo -e "   /gg\           /gg\ 
  /g.gg\         /gg.g\ 
 |gg..gg\       /gg..gg| 
 |gg...g|       |g...gg| 
 |gg...g|       |g...gg| 
  \gg..g/       \g..gg/ 
   |gg.gvgggggggvg.gg| 
  /ggggggggggggggggggg\ 
 /gggg(((ggggggg)))gggg\ 
|ggggg....ggggg....ggggg| 
|ggggg....ggggg....ggggg| 
|ggcccgggg\___/ggggcccgg| 
|ggcccccgggg|ggggcccccgg| 
  \gcccggg\---/gggcccg/ 
     \ggggggggggggg/
${reset}"
        ;;
    esac
}

banners:hera() {
    case "${1}" in
        [cC][rR][aA][wW][fF][oO][rR][dD]2|--[cC][rR][aA][wW][fF][oO][rR][dD]2|-[cC][wW]2)
            [[ "${2}" = "rainbow" ]] && __randomcolor simple
            echo -e " __ __    ___  ____    ____ 
|  |  |  /  _]|    \  /    |
|  |  | /  [_ |  D  )|  o  |
|  _  ||    _]|    / |     |
|  |  ||   [_ |    \ |  _  |
|  |  ||     ||  .  \|  |  |
|__|__||_____||__|\_||__|__|
${reset}"
        ;;
        [fF][iI][rR][eE]|--[fF][iI][rR][eE]|-[fF])
            [[ "${2}" = "rainbow" ]] && __randomcolor simple
            echo -e "    )                   
 ( /(    (   (       )  
 )\())  ))\  )(   ( /(  
((_)\  /((_)(()\  )(_)) 
| |(_)(_))   ((_)((_)_  
| ' \ / -_) | '_|/ _' | 
|_||_|\___| |_|  \__,_| 
${reset}"
        ;;
        [gG][rR][aA][fF][fF][iI][tT][iI]|--[gG][rR][aA][fF][fF][iI][tT][iI]|-[gG])
            [[ "${2}" = "rainbow" ]] && __randomcolor simple
            echo -e ".__                         
|  |__   ________________   
|  |  \_/ __ \_  __ \__  \  
|   Y  \  ___/|  | \// __ \_
|___|  /\___  >__|  (____  /
     \/     \/           \/
${reset}"
        ;;
    esac
}

banners:anime() {
    case "${1}" in
        [pP][iI][kK][aA]|--[pP][iI][kK][aA]|-[pP])
            echo -e "${yellow}⢀⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⣠⣤⣶⣶
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⢰⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⣀⣀⣾⣿⣿⣿⣿
⣿⣿⣿⣿⣿⡏⠉⠛⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⣿
⣿⣿⣿⣿⣿⣿⠀⠀⠀⠈⠛⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠛⠉⠁⠀⣿
⣿⣿⣿⣿⣿⣿⣧⡀⠀⠀⠀⠀⠙⠿⠿⠿⠻⠿⠿⠟⠿⠛⠉⠀⠀⠀⠀⠀⣸⣿
⣿⣿⣿⣿⣿⣿⣿⣷⣄⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⣴⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⡟⠀⠀⢰⣹⡆⠀⠀⠀⠀⠀⠀⣭⣷⠀⠀⠀⠸⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⠃⠀⠀⠈⠉⠀⠀⠤⠄⠀⠀⠀⠉⠁⠀⠀⠀⠀⢿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⢾⣿⣷⠀⠀⠀⠀⡠⠤⢄⠀⠀⠀⠠⣿⣿⣷⠀⢸⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⡀⠉⠀⠀⠀⠀⠀⢄⠀⢀⠀⠀⠀⠀⠉⠉⠁⠀⠀⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿
${reset}"
        ;;
        [sS][aA][iI][tT][aA][mM][aA]|--[sS][aA][iI][tT][aA][mM][aA]|-[sS])
            echo -e "⠀⠀⠀⠀⣠⣶⡾⠏⠉⠙⠳⢦⡀⠀⠀⠀⢠⠞⠉⠙⠲⡀⠀
⠀⠀⠀⣴⠿⠏⠀⠀⠀⠀⠀⠀⢳⡀⠀⡏⠀⠀⠀⠀⠀⢷
⠀⠀⢠⣟⣋⡀⢀⣀⣀⡀⠀⣀⡀⣧⠀⢸⠀⠀⠀⠀⠀ ⡇
⠀⠀⢸⣯⡭⠁⠸⣛⣟⠆⡴⣻⡲⣿⠀⣸⠀⠀OK⠀ ⡇
⠀⠀⣟⣿⡭⠀⠀⠀⠀⠀⢱⠀⠀⣿⠀⢹⠀⠀⠀⠀⠀ ⡇
⠀⠀⠙⢿⣯⠄⠀⠀⠀⢀⡀⠀⠀⡿⠀⠀⡇⠀⠀⠀⠀⡼
⠀⠀⠀⠀⠹⣶⠆⠀⠀⠀⠀⠀⡴⠃⠀⠀⠘⠤⣄⣠⠞⠀
⠀⠀⠀⠀⠀⢸⣷⡦⢤⡤⢤⣞⣁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⢀⣤⣴⣿⣏⠁⠀⠀⠸⣏⢯⣷⣖⣦⡀⠀⠀⠀⠀⠀⠀
⢀⣾⣽⣿⣿⣿⣿⠛⢲⣶⣾⢉⡷⣿⣿⠵⣿⠀⠀⠀⠀⠀⠀
⣼⣿⠍⠉⣿⡭⠉⠙⢺⣇⣼⡏⠀⠀⠀⣄⢸⠀⠀⠀⠀⠀⠀
⣿⣿⣧⣀⣿………⣀⣰⣏⣘⣆⣀⠀⠀
${reset}"
        ;;
        [cC][uU][tT][eE]|--[cC][uU][tT][eE]|-[cC])
            [[ "${2}" = "rainbow" ]] && __randomcolor simple
<<<<<<< HEAD
            echo -e "░░░░█▐▄▒▒▒▌▌▒▒▌░▌▒▐▐▐▒▒▐▒▒▌▒▀▄▀▄░
░░░█▐▒▒▀▀▌░▀▀▀░░▀▀▀░░▀▀▄▌▌▐▒▒▒▌▐░
░░▐▒▒▀▀▄▐░▀▀▄▄░░░░░░░░░░░▐▒▌▒▒▐░▌
░░▐▒▌▒▒▒▌░▄▄▄▄█▄░░░░░░░▄▄▄▐▐▄▄▀░░
░░▌▐▒▒▒▐░░░░░░░░░░░░░▀█▄░░░░▌▌░░░
▄▀▒▒▌▒▒▐░░░░░░░▄░░▄░░░░░▀▀░░▌▌░░░
▄▄▀▒▐▒▒▐░░░░░░░▐▀▀▀▄▄▀░░░░░░▌▌░░░
░░░░█▌▒▒▌░░░░░▐▒▒▒▒▒▌░░░░░░▐▐▒▀▀▄
░░▄▀▒▒▒▒▐░░░░░▐▒▒▒▒▐░░░░░▄█▄▒▐▒▒▒
▄▀▒▒▒▒▒▄██▀▄▄░░▀▄▄▀░░▄▄▀█▄░█▀▒▒▒▒
=======
            echo -e "
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
░░░████▌█████▌█░████████▐▀██▀
░▄█████░█████▌░█░▀██████▌█▄▄▀▄
░▌███▌█░▐███▌▌░░▄▄░▌█▌███▐███░▀
▐░▐██░░▄▄▐▀█░░░▐▄█▀▌█▐███▐█
░░███░▌▄█▌░░▀░░▀██░░▀██████▌
░░░▀█▌▀██▀░▄░░░░░░░░░███▐███
░░░░██▌░░░░░░░░░░░░░▐███████▌
░░░░███░░░░░▀█▀░░░░░▐██▐███▀▌
░░░░▌█▌█▄░░░░░░░░░▄▄████▀░▀
░░░░░░█▀██▄▄▄░▄▄▀▀▒█▀█░
>>>>>>> 508a5b562490875ad3c709fbc4e6d232cd3c36fe
${reset}"
        ;;
    esac
}
