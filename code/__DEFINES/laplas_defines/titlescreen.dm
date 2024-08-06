#define DEFAULT_TITLE_MAP_LOADTIME (150 SECONDS)

#define DEFAULT_TITLE_SCREEN_IMAGE 'laplas/icons/skyrat_title_screen.png'
#define DEFAULT_TITLE_LOADING_SCREEN 'laplas/icons/loading_screen.gif'

#define TITLE_PROGRESS_CACHE_FILE "laplas/tools/data/progress_cache.json"
#define TITLE_PROGRESS_CACHE_VERSION "2"

#define DEFAULT_TITLE_HTML {"
<html>
    <head>
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <style type='text/css'>
            @font-face {
                font-family: "Fixedsys";
                src: url("FixedsysExcelsior3.01Regular.ttf");
            }
            body,
            html {
                margin: 0;
                overflow: hidden;
                text-align: center;
                background-color: black;
                padding-top: 5vmin;
                -ms-user-select: none;
                cursor: default;
            }

            img {
                border-style:none;
            }

            .bg {
                position: absolute;
                width: auto;
                height: 100vmin;
                min-width: 100vmin;
                min-height: 100vmin;
                top: 50%;
                left:50%;
                transform: translate(-50%, -50%);
                z-index: 0;
            }

            .container_terminal {
                position: absolute;
                width: 100%;
                height: calc(100% - 7vmin);
                overflow: clip;
                box-sizing: border-box;
                padding: 3vmin 2vmin;
                top: 0%;
                left:0%;
                z-index: 1;
            }

            .terminal_text {
                display: inline-block;
                font-weight: 300;
                text-decoration: none;
                width: 100%;
                text-align: right;
                color:green;
                text-shadow: 1px 1px black;
                margin-right: 0%;
                margin-top: 0px;
                font-size: 1.5vmin;
                line-height: 1.5vmin;
                letter-spacing: 1px;
                font-family: 'Arial', sans-serif;
            }

            .container_progress {
                position: absolute;
                box-sizing: border-box;
                bottom: 3vmin;
                left: 2vmin;
                height: 4vmin;
                width: calc(100% - 4vmin);
                border-left: 2px solid rgba(0, 255, 0, 0.5);
                border-right: 2px solid rgba(0, 255, 0, 0.5);
                padding: 4px;
                background-color: black;
            }

            .progress_bar {
                width: 0%;
                height: 100%;
                background-color: green;
            }

            @keyframes fade_out {
                to {
                    opacity: 0;
                }
            }

            .fade_out {
                animation: fade_out 2s both;
            }

            .container_nav {
                position: absolute;
                box-sizing: border-box;
                width: 80vmin;
                min-height: 10vmin;
                top: calc(50% + 22.5vmin);
                left: 40%;
                transform: translate(-50%, -50%);
                z-index: 1;
            }

            .container_nav hr {
                height: 2px;
                background-color: #cde;
                border: none;
                box-shadow: 2px 2px black;
            }

            .menu_button {
                display: block;
                box-sizing: border-box;
                font-family: 'Arial', sans-serif;
                font-weight: 300;
                text-decoration: none;
                font-size: 2vmin;
                text-shadow: 2px 2px black;
                line-height: 3vmin;
                width: 100%;
                text-align: left;
                color: white;
                height: 3vmin;
                padding-left: 1vmin;
                letter-spacing: 1=px;
                cursor: pointer;
                white-space: nowrap;
                overflow: hidden;
            }

            .menu_button:hover {
                padding-left: 0px;
                color: rgba(255, 255, 102, 1);
            }

            .menu_button:active {
                padding-left: 0px;
                transform: translate(1px, 1px);
            }

            .menu_button:hover::before {
                content: ">";
                text-align: center;
                width: 5vmin;
                display: inline-block;
            }

            @keyframes pulse_button {
                0% {transform: translateX(0px);}
                100% {transform: translateX(2px);}
            }

            .menu_button:active::before {
                content: "☛";
                text-align: center;
                width: 5vmin;
                animation: pulse_button 0.25s infinite alternate;
            }

            @keyframes pollsbox {
                0% {color: #cde;}
                50% {color: #f80;}
            }

            .menu_newpoll {
                animation: pollsbox 2s step-start infinite;
                padding-left: 0px;
            }

            .menu_newpoll::before {
                content: "→";
                text-align: center;
                width: 5vmin;
                display: inline-block;
            }

            .menu_newpoll::after {
                content: "←";
                text-align: center;
                width: 5vmin;
                display: inline-block;
            }

            .container_notice {
                position: absolute;
                box-sizing: border-box;
                width: auto;
                padding-top: 1vmin;
                top: calc(50% - 10vmin);
                left:50%;
                transform: translate(-50%, -50%);
                z-index: 1;
            }

            .menu_notice {
                display: inline-block;
                font-family: "Fixedsys";
                font-weight: lighter;
                text-decoration: none;
                width: 100%;
                text-align: left;
                color: rgba(255, 255, 102, 1);
                text-shadow: 1px 0px black, -1px 0px black, 0px 1px black, 0px -1px black, 2px 0px black, -2px 0px black, 0px 2px black, 0px -2px black;
                margin-right: 0%;
                margin-top: 0px;
                font-size: 3vmin;
                line-height: 2vmin;
            }

            .unchecked {
                color: #F44;
            }

            .checked {
                color: #4F4;
            }
        </style>
    </head>
    <body>
"}
