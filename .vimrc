set nocompatible                                      "禁用 Vi 兼容模式
filetype off                                          "禁用文件类型侦测

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'Shougo/neocomplcache.vim'
Bundle 'OmniCppComplete'
Bundle 'gmarik/vundle'
Bundle 'taglist.vim'
Bundle 'Trinity'
Bundle 'SrcExpl'

" Open and close all the three plugins on the same time
nmap <F8>   :TrinityToggleAll<CR>

" Open and close the srcexpl.vim separately
nmap <F9>   :TrinityToggleSourceExplorer<CR>

" Open and close the taglist.vim separately
nmap <F10>  :TrinityToggleTagList<CR>

" Open and close the NERD_tree.vim separately
nmap <F7>  :TrinityToggleNERDTree<CR>

" // The switch of the Source Explorer 
" nmap <F8> :SrcExplToggle<CR> 

" // Set the height of Source Explorer window 
let g:SrcExpl_winHeight = 8 

" // Set 100 ms for refreshing the Source Explorer 
let g:SrcExpl_refreshTime = 100 

" // Set "Enter" key to jump into the exact definition context 
" let g:SrcExpl_jumpKey = "<ENTER>" 
" // Set "Space" key for back from the definition context 
" let g:SrcExpl_gobackKey = "<SPACE>" 

" // In order to Avoid conflicts, the Source Explorer should know what plugins 
" // are using buffers. And you need add their bufname into the list below 
" // according to the command ":buffers!" 
" let g:SrcExpl_pluginList = [ 
" 	\ "__Tag_List__", 
" 	\ "_NERD_tree_", 
" 	\ "Source_Explorer" 
" 	\ ] 

" // Set "<F12>" key for updating the tags file artificially 
let g:SrcExpl_updateTagsKey = "<F12>"  

set encoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,gbk,cp936,latin-1

set fileformat=unix
set fileformats=unix,dos,mac
set mouse=a
set number                 

if has("autocmd")
	au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") |exe("norm '\"")|else|exe "normal! g'\"" |endif
endif

" 启用每行超过80列的字符提示（字体变蓝并加下划线），不启用就注释掉
au BufWinEnter * let w:m2=matchadd('Underlined', '\%>' . 80 . 'v.\+', -1)

set tabstop=4                                         "设置Tab键的宽度，可以更改，如：宽度为2
set smartindent                                       "启用智能对齐方式
set shiftwidth=4                                      "换行时自动缩进宽度，可更改（宽度同tabstop）
set smarttab                                          "指定按一次backspace就删除shiftwidth宽度为
set hlsearch
set expandtab

" let g:neocomplcache_enable_at_startup = 1     "vim 启动时启用插件

" 当文件在外部被修改，自动更新该文件
" set autoread

" 常规模式下输入 cS 清除行尾空格
nmap cS :%s/\s\+$//g<CR>:noh<CR>

" 常规模式下输入 cM 清除行尾 ^M 符号
nmap cM :%s/\r$//g<CR>:noh<CR>

set writebackup                             "保存文件前建立备份，保存成功后删除该备份
set nobackup                                "设置无备份文件

set ignorecase                                        "搜索模式里忽略大小写
set smartcase                                         "如果搜索模式包含大写字符，不使用 'ignorecase' 选项，只有在输入搜索模式并且打开 'ignorecase' 选项时才会使用

" 高亮括号与运算符等
" au! BufRead,BufNewFile,BufEnter *.{c,cpp,h,java,javascript} call CSyntaxAfter()

" 用于文本文件生成标签与与语法高亮（调用TagList插件生成标签，如果可以）
au BufRead,BufNewFile *.txt setlocal ft=txt

"语法高亮        
if has("syntax")
	syntax on
endif

" 用Cscope自己的话说 - "你可以把它当做是超过频的ctags"
if has("cscope")
	"设定可以使用 quickfix 窗口来查看 cscope 结果
	"set cscopequickfix=s+,c+,d+,i+,t+,e+
	set cscopequickfix=""
	set csto=0
	set cst
	" add any database in current directory
	if filereadable("cscope.out")
		cs add cscope.out
	" else add database pointed to by environment
	elseif $CSCOPE_DB != ""
		cs add $CSCOPE_DB
	endif
	set csverb
	nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
	nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
	nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
	nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
	nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
	nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
	nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
	nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>
endif

" 对浏览代码非常的方便,可以在函数,变量之间跳转等
set tags=./tags;                            "向上级目录递归查找tags文件（好像只有在Windows下才有用）

function! UpdateCtags()
	let curdir=getcwd()
	while !filereadable("./tags")
		cd ..
		if getcwd() == "/"
			break
		endif
	endwhile
	if filewritable("./tags")
		!ctags -R --file-scope=yes --langmap=c:+.h --languages=c,c++ --links=yes --c-kinds=+p --c++-kinds=+p --fields=+iaS --extra=+q
		TlistUpdate
	endif
	execute ":cd " . curdir
endfunction
"autocmd BufWritePost *.c,*.h,*.cpp call UpdateCtags()
set guifont=Menlo\ Regular:h18
