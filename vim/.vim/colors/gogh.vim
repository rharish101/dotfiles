"  GOGH CUSTOM VIM COLORSCHEME BASED ON:
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
"     Red          #c0392b      1       |      brRed        #e74c3c      9       |
"     Green        #27ae60      2       |      brGreen      #2ecc71      10      |
"     Yellow       #f39c12      3       |      brYellow     #f1c40f      11      |
"     Blue         #2980b9      4       |      brBlue       #3498db      12      |
"     Magenta      #8e44ad      5       |      brMagenta    #9b59b6      13      |
"     Cyan         #16a085      6       |      brCyan       #2aa198      14      |
"     White        #bdc3c7      7       |      brWhite      #d3dae3      15      |
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

let g:colors_name="gogh"

"=======================================================================================================================
" ARC DARK HIGHLIGHTING:
"=======================================================================================================================
highlight! Normal                 guifg=#bdc3c7  guibg=#2f343f  gui=NONE       ctermfg=7     ctermbg=0     cterm=NONE
highlight! TabLineSel             guifg=#2f343f  guibg=#2980b9  gui=NONE       ctermfg=0     ctermbg=4     cterm=NONE
highlight! Visual                 guifg=#2980b9  guibg=NONE     gui=reverse    ctermfg=4     ctermbg=NONE  cterm=reverse
highlight! StatusLine             guifg=#bdc3c7  guibg=#505666  gui=NONE       ctermfg=7     ctermbg=8     cterm=NONE
highlight! StatusLineNC           guifg=#2f343f  guibg=#505666  gui=NONE       ctermfg=0     ctermbg=8     cterm=NONE
highlight! MatchParen             guifg=#bdc3c7  guibg=#e74c3c  gui=NONE       ctermfg=7     ctermbg=9     cterm=NONE
highlight! PmenuSbar              guifg=NONE     guibg=NONE     gui=NONE       ctermfg=NONE  ctermbg=NONE  cterm=NONE
highlight! String                 guifg=#27ae60  guibg=NONE     gui=NONE       ctermfg=2     ctermbg=NONE  cterm=NONE
highlight! PreProc                guifg=#e74c3c  guibg=NONE     gui=NONE       ctermfg=9     ctermbg=NONE  cterm=NONE
highlight! Comment                guifg=#505666  guibg=NONE     gui=NONE       ctermfg=8     ctermbg=NONE  cterm=NONE
highlight! Function               guifg=#2980b9  guibg=NONE     gui=NONE       ctermfg=4     ctermbg=NONE  cterm=NONE
highlight! SpecialKey             guifg=#f39c12  guibg=NONE     gui=NONE       ctermfg=3     ctermbg=NONE  cterm=NONE
highlight! CursorLine             guifg=NONE     guibg=#505666  gui=NONE       ctermfg=NONE  ctermbg=8     cterm=NONE
highlight! CursorColumn           guifg=NONE     guibg=#2f343f  gui=NONE       ctermfg=NONE  ctermbg=0     cterm=NONE
highlight! LineNr                 guifg=#505666  guibg=NONE     gui=NONE       ctermfg=8     ctermbg=NONE  cterm=NONE
highlight! Underlined             guifg=#8e44ad  guibg=NONE     gui=NONE       ctermfg=5     ctermbg=NONE  cterm=NONE
highlight! TabLineFill            guifg=#505666  guibg=NONE     gui=underline  ctermfg=8     ctermbg=NONE  cterm=underline
highlight! TabLine                guifg=#2f343f  guibg=#505666  gui=NONE       ctermfg=0     ctermbg=8     cterm=NONE
highlight! SpecialComment         guifg=#505666  guibg=NONE     gui=reverse    ctermfg=8     ctermbg=NONE  cterm=reverse
highlight! Todo                   guifg=#f39c12  guibg=NONE     gui=reverse    ctermfg=3     ctermbg=NONE  cterm=reverse
highlight! Search                 guifg=#27ae60  guibg=NONE     gui=reverse    ctermfg=2     ctermbg=NONE  cterm=reverse
highlight! Error                  guifg=#c0392b  guibg=NONE     gui=reverse    ctermfg=1     ctermbg=NONE  cterm=reverse
highlight! DiffAdd                guifg=#d3dae3  guibg=NONE     gui=reverse    ctermfg=7     ctermbg=NONE  cterm=reverse
highlight! DiffChange             guifg=#8e44ad  guibg=NONE     gui=reverse    ctermfg=5     ctermbg=NONE  cterm=reverse
highlight! SpellBad               guifg=#c0392b  guibg=NONE     gui=undercurl  ctermfg=1     ctermbg=NONE  cterm=undercurl
highlight! SpellLocal             guifg=#9b59b6  guibg=NONE     gui=undercurl  ctermfg=8     ctermbg=NONE  cterm=undercurl
highlight! SpellCap               guifg=#f39c12  guibg=NONE     gui=undercurl  ctermfg=3     ctermbg=NONE  cterm=undercurl

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
