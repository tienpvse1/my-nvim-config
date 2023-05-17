lua require("tienpvse")
:set ignorecase
:set smartcase

let g:prettier#autoformat = 1
let g:prettier#autoformat_require_pragma = 0
nmap <S-A-f> <Plug>(Prettier)

nnoremap <leader>ff<CR> <cmd>Telescope find_files<cr>
nnoremap <leader>fg<CR> <cmd>Telescope live_grep<cr>

nnoremap <leader>t<CR> :ToggleTerm<CR>
nmap <leader>rn <Plug>(coc-rename)
tnoremap <Esc> <C-\><C-n>


"ToggleTerm config
autocmd TermEnter term://*toggleterm#*
      \ tnoremap <silent><c-t> <Cmd>exe v:count1 . "ToggleTerm"<CR>
nnoremap <silent><c-t> <Cmd>exe v:count1 . "ToggleTerm"<CR>
inoremap <silent><c-t> <Esc><Cmd>exe v:count1 . "ToggleTerm"<CR>
