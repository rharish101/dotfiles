"  ARC DARK CUSTOM VIM COLORSCHEME BASED ON:
"
"  ________  ___  ________  ________  ________   ___  ________
" |\   ____\|\  \|\   ___ \|\   __  \|\   ___  \|\  \|\   __  \
" \ \  \___|\ \  \ \  \_|\ \ \  \|\  \ \  \\ \  \ \  \ \  \|\  \
"  \ \_____  \ \  \ \  \ \\ \ \  \\\  \ \  \\ \  \ \  \ \   __  \
"   \|____|\  \ \  \ \  \_\\ \ \  \\\  \ \  \\ \  \ \  \ \  \ \  \
"     ____\_\  \ \__\ \_______\ \_______\ \__\\ \__\ \__\ \__\ \__\
"    |\_________\|__|\|_______|\|_______|\|__| \|__|\|__|\|__|\|__|
"    \|_________|


" A Terminal && Vim colorscheme
" Author:       Alessandro Yorba
" Script URL:   https://github.com/AlessandroYorba/Sidonia
" License:      MIT

"=================================================================================
" ANSI COLORS:
"=================================================================================
"     Foreground   #d3dae3                                                       |
"     Background   #2f343f                                                       |
"     CursorColor  #d3dae3                                                       |
"---------------------------------------|-----------------------------------------
"     NORMAL       Hex          xterm   |      "BRIGHT      Hex          xterm   |
"---------------------------------------|-----------------------------------------
"     Black        #2f343f      0       |      brBlack      #505666      8       |
"     Red          #be3841      1       |      brRed        #fc4138      9       |
"     Green        #4e9a06      2       |      brGreen      #73d216      10      |
"     Yellow       #c4a000      3       |      brYellow     #fce94f      11      |
"     Blue         #3b84de      4       |      brBlue       #5294e2      12      |
"     Magenta      #75507b      5       |      brMagenta    #ad7fa8      13      |
"     Cyan         #06989a      6       |      brCyan       #34e2e2      14      |
"     White        #d3dae3      7       |      brWhite      #d3dae3      15      |
"---------------------------------------|-----------------------------------------

"=================================================================================
" SETUP:
"=================================================================================

set background=dark

highlight clear
if exists("syntax_on")
    syntax reset
endif

"=======================================================================================================================
" LOAD DEFAULT PARAMETERS:
"=======================================================================================================================

let g:colors_name="arcdark"

"=======================================================================================================================
" ARC DARK HIGHLIGHTING:
"=======================================================================================================================
highlight! Normal                 guifg=#d3dae3  guibg=#2f343f  gui=NONE       ctermfg=7     ctermbg=0     cterm=NONE
highlight! TabLineSel             guifg=#2f343f  guibg=#3b84de  gui=NONE       ctermfg=0     ctermbg=4     cterm=NONE
highlight! Visual                 guifg=#3b84de  guibg=NONE     gui=reverse    ctermfg=4     ctermbg=NONE  cterm=reverse
highlight! StatusLine             guifg=#d3dae3  guibg=#505666  gui=NONE       ctermfg=7     ctermbg=8     cterm=NONE
highlight! StatusLineNC           guifg=#2f343f  guibg=#505666  gui=NONE       ctermfg=0     ctermbg=8     cterm=NONE
highlight! MatchParen             guifg=#d3dae3  guibg=#fc4138  gui=NONE       ctermfg=7     ctermbg=9     cterm=NONE
highlight! PmenuSbar              guifg=NONE     guibg=NONE     gui=NONE       ctermfg=NONE  ctermbg=NONE  cterm=NONE
highlight! String                 guifg=#4e9a06  guibg=NONE     gui=NONE       ctermfg=2     ctermbg=NONE  cterm=NONE
highlight! PreProc                guifg=#fc4138  guibg=NONE     gui=NONE       ctermfg=9     ctermbg=NONE  cterm=NONE
highlight! Comment                guifg=#505666  guibg=NONE     gui=NONE       ctermfg=8     ctermbg=NONE  cterm=NONE
highlight! Function               guifg=#3b84de  guibg=NONE     gui=NONE       ctermfg=4     ctermbg=NONE  cterm=NONE
highlight! SpecialKey             guifg=#c4a000  guibg=NONE     gui=NONE       ctermfg=3     ctermbg=NONE  cterm=NONE
highlight! CursorLine             guifg=NONE     guibg=#505666  gui=NONE       ctermfg=NONE  ctermbg=8     cterm=NONE
highlight! CursorColumn           guifg=NONE     guibg=#2f343f  gui=NONE       ctermfg=NONE  ctermbg=0     cterm=NONE
highlight! LineNr                 guifg=#505666  guibg=NONE     gui=NONE       ctermfg=8     ctermbg=NONE  cterm=NONE
highlight! Underlined             guifg=#75507b  guibg=NONE     gui=NONE       ctermfg=5     ctermbg=NONE  cterm=NONE
highlight! TabLineFill            guifg=#505666  guibg=NONE     gui=underline  ctermfg=8     ctermbg=NONE  cterm=underline
highlight! TabLine                guifg=#2f343f  guibg=#505666  gui=NONE       ctermfg=0     ctermbg=8     cterm=NONE
highlight! SpecialComment         guifg=#505666  guibg=NONE     gui=reverse    ctermfg=8     ctermbg=NONE  cterm=reverse
highlight! Todo                   guifg=#c4a000  guibg=NONE     gui=reverse    ctermfg=3     ctermbg=NONE  cterm=reverse
highlight! Search                 guifg=#4e9a06  guibg=NONE     gui=reverse    ctermfg=2     ctermbg=NONE  cterm=reverse
highlight! Error                  guifg=#be3841  guibg=NONE     gui=reverse    ctermfg=1     ctermbg=NONE  cterm=reverse
highlight! DiffAdd                guifg=#d3dae3  guibg=NONE     gui=reverse    ctermfg=7     ctermbg=NONE  cterm=reverse
highlight! DiffChange             guifg=#75507b  guibg=NONE     gui=reverse    ctermfg=5     ctermbg=NONE  cterm=reverse
highlight! SpellBad               guifg=#be3841  guibg=NONE     gui=undercurl  ctermfg=1     ctermbg=NONE  cterm=undercurl
highlight! SpellLocal             guifg=#ad7fa8  guibg=NONE     gui=undercurl  ctermfg=8     ctermbg=NONE  cterm=undercurl
highlight! SpellCap               guifg=#c4a000  guibg=NONE     gui=undercurl  ctermfg=3     ctermbg=NONE  cterm=undercurl

highlight! link WildMenu          Visual
highlight! link ModeMsg           Visual
highlight! link PmenuThumb        PmenuSbar
highlight! link CursorLineNr      StatusLine
highlight! link StatusLineNC      SpecialComment
highlight! link PmenuSel          StatusLine
highlight! link Pmenu             StatusLineNC
highlight! link Folded            LineNr
highlight! link ErrorMsg          Error
highlight! link DiffDelete        Error
highlight! link ColorColumn       CursorLine
highlight! link SignColumn        String
highlight! link MoreMsg           String
highlight! link Directory         String
highlight! link markdownLinkText  String
highlight! link WarningMsg        String
highlight! link Operator          Function
highlight! link Special           Function
highlight! link Identifier        Function
highlight! link Statement         Function
highlight! link Type              Function
highlight! link Constant          Function
highlight! link htmlEndTag        Function
highlight! link Number            PreProc
highlight! link Title             PreProc
highlight! link FoldColumn        PreProc
highlight! link phpVarSelector      PreProc
highlight! link StorageClass      Normal
highlight! link DiffText          DiffAdd
highlight! link Question          SpecialKey
highlight! link markdownUrl       Underlined
highlight! link SpellRare         SpellLocal
highlight! link NonText           Comment
highlight! link VertSplit         Comment
highlight! link VimCommentTitle   SpecialComment
