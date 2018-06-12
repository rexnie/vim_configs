let cfg_expandtab= 0

" common config {{
set nocompatible "不兼容vi
set number "显示行号
"syntax on "语法高亮支持
"syntax enable
if cfg_expandtab
    set tabstop=4 "一个tab键所占的列数,默认为8
    set shiftwidth=4 "reindent操作(<<和>>)时缩进的列数(这里的一列相当于一个空格),默认为8
    set expandtab " 设置tab键扩展为softtabstop个空格，默认noexpandtab
    "当expandtab设置时，输入一个tab键，扩展为softtabstop个空格

    "当noexpandtab设置时,
    	"如softtabstop=12,tabstop=8时,那么当输入一个tab时(softtabstop,12列),最后会变成一个tab(tabstop)加4个空格(8+4),
            "当输入两个tab(2个softtabstop,24列),会变成3个tab(tabstop)
        "如softtabstop=4,tabstop=8时,那么当输入一个tab时(softtabstop,4列),最后会变成4个空格(因为不够一个tabstop),
            "当输入两个tab(2个softtabstop,8列),会变成1个tab(tabstop)
	"如softtabstop等于tabstop时，两者没区别
	"默认softtabstop为8
    set softtabstop=4
endif
set showmatch "当键入括号时，光标会跳转到匹配的括号处闪烁下，然后跳回来，起提示作用
set incsearch "开启边输入边匹配
set guifont=Monaco:h14 "给gui版的vim设置字体
colorscheme molokai
set smartindent "当输入newlines时根据C-like语法智能缩进
set cindent "起用C缩进，当设置了这个，smartindent失效
set autoindent "采用上一行的缩进
set hlsearch "高亮显示查找的内容
set cursorline "为光标所在行加下划线
"colorscheme desert "加载配色方案,保存在$VIMRUNTIME/colors/desert.vim,:echo $VIMRUNTIME 查看该值
set cmdheight=1 "给command mode设置行数
"set fileencodings=uft-8,gbk "使用utf-8或gbk打开文件

set noignorecase "查找时大小匹配
"set ignorecase "查找时忽略大小匹配

"set foldmethod=syntax "指定折叠代码方式，按语法
"set foldmethod=indent "指定折叠代码方式，按缩进

set laststatus=2 "总是显示状态行
set backspace=2 "插入模式时，退格键可删除任意字符，
		"0/1 只可删除刚刚输入的字符 
" }}

" tabpages config {{
" ctl-h/l 切换上/下一个tabpage
nnoremap <C-l> gt
nnoremap <C-h> gT

"在正常模式下，输入,t即执行:tabedit
let mapleader=','
nnoremap <leader>t : tabe<CR>
" }}

" plugins
set t_Co=256
let g:Powerline_symbols = 'fancy'

" pathogen config {{
" pathogen 是管理插件的插件
call pathogen#infect()
" }}

" NERDTree config {{
" NERDTree 是显示目录和文件结构的插件
nnoremap <C-n> :NERDTree<CR> "配置ctrl+n呼出NERDTree
" }}


" lookupfile config {{
" lookupfile 快速查找插件,支持正则表达式
" 指定插件的查找的tag file, 未指定的话使用tags文件，会很慢
" ./.vim/bundle/lookupfile/mk_tags4_lookupfile.sh
if filereadable("./filenametags")                "设置tag文件的名字
let g:LookupFile_TagExpr = '"./filenametags"'
endif
let g:LookupFile_MinPatLength = 2               "最少输入2个字符才开始查找
let g:LookupFile_PreserveLastPattern = 0        "不保存上次查找的字符串
let g:LookupFile_PreservePatternHistory = 1     "保存查找历史
let g:LookupFile_AlwaysAcceptFirst = 1          "回车打开第一个匹配项目
let g:LookupFile_AllowNewFiles = 0              "不允许创建不存在的文件
"映射LookupFile为,lt
nmap <silent> <leader>lt :LUTags<cr>
"映射LUBufs为,lb
nmap <silent> <leader>lb :LUBufs<cr>
"映射LUWalk为,lw
nmap <silent> <leader>lw :LUWalk<cr>

" lookup file with ignore case
function! LookupFile_IgnoreCaseFunc(pattern)
	let _tags = &tags
	try
		let &tags = eval(g:LookupFile_TagExpr)
		let newpattern = '\c' . a:pattern
		let tags = taglist(newpattern)
	catch
		echohl ErrorMsg | echo "Exception: " . v:exception | echohl NONE
		return ""
	finally
		let &tags = _tags
	endtry

	" Show the matches for what is typed so far.
	let files = map(tags, 'v:val["filename"]')
	return files
endfunction
let g:LookupFile_LookupFunc = 'LookupFile_IgnoreCaseFunc'
" }}

" taglist plugin config {{
" taglist 提供了代码的结构预览
let Tlist_Show_One_File = 1 "只显示当前文件的taglist，默认是显示多个
let Tlist_Exit_OnlyWindow = 1 "如果taglist是最后一个窗口，则退出vim
let Tlist_Use_Right_Window = 1 "在右侧窗口中显示taglist
let Tlist_GainFocus_On_ToggleOpen = 1 "打开taglist时，光标保留在taglist窗口
"let Tlist_Auto_Open = 1 "在启动VIM后自动打开taglist窗口
let Tlist_File_Fold_Auto_Close = 1
"let Tlist_Sort_Type = 'order' "默认按tag在文件中出现的顺序进行排序(=order)
				"设置为"name"，taglist将以tag名字进行排序
let Tlist_Ctags_Cmd='ctags' "设置ctags命令的位置
nnoremap <silent> <F6> :Tlist<CR>
nnoremap <leader>tl : Tlist<CR> ",tl呼出taglist 
" }}

" visualmark plugin 设置bookmark功能
" mm 设置一个bookmark, F2切换到下一个bookmark

" WinManager {{
" 窗口管理器
let g:winManagerWindowLayout='FileExplorer|TagList'
nmap wm :WMToggle<cr>
" }}

" cscope config {{
" cd src_dir; cscope -Rbq 生成cscope数据库
set cscopequickfix=s-,c-,d-,i-,t-,e- "设定是否使用 quickfix 窗口来显示 cscope 结果
" }}

" netrw {{
" 文件管理器插件
let g:netrw_winsize = 30
nmap <silent> <leader>fe :Sexplore!<cr>
" }}

" bufExplorer {{
" buffer 管理插件
let g:bufExplorerDefaultHelp=0       " Do not show default help.
let g:bufExplorerShowRelativePath=1  " Show relative paths.
let g:bufExplorerSortBy='mru'        " Sort by most recently used.
let g:bufExplorerSplitRight=0        " Split left.
let g:bufExplorerSplitVertical=1     " Split vertically.
let g:bufExplorerSplitVertSize = 30  " Split width
let g:bufExplorerUseCurrentWindow=1  " Open in new window.
autocmd BufWinEnter \[Buf\ List\] setl nonumber
" }}

" A {{
" A 切换 .c <--> .h
" :A 在当前buffer切换.c/.h
" :AS 新建一个水平窗口来放.c/.h
" :AV 新建一个垂直窗口来放.c/.h
" :AT 新建一个tab来放.c/.h
nnoremap <silent> <F12> :A<CR>
" }}

" grep {{
nnoremap <silent> <F3> :Grep<CR>
let Grep_Skip_Dirs = '.svn .git'
let Grep_Skip_Files = '*.bak *~ *.o *.map *.out'
" }}

" compl-omni-filetypes {{
" vim 补全方式汇总
" 全能补全			  CTRL-X CTRL-O
" 整行补全                        CTRL-X CTRL-L
" 根据当前文件里关键字补全        CTRL-X CTRL-N
" 根据字典补全                    CTRL-X CTRL-K
" 根据同义词字典补全              CTRL-X CTRL-T
" 根据头文件内关键字补全          CTRL-X CTRL-I
" 根据标签补全                    CTRL-X CTRL-]
" 补全文件名                      CTRL-X CTRL-F
" 补全宏定义                      CTRL-X CTRL-D
" 补全vim命令                     CTRL-X CTRL-V
" 用户自定义补全方式              CTRL-X CTRL-U
" 拼写建议                        CTRL-X CTRL-S 
"
" 在当前缓冲区、其它缓冲区，以及当前文件所包含的头文件中查找以光标前关键字开始的单词
" 向上查找			  CTRL-X CTRL-P
" 向下查找			  CTRL-X CTRL-N
"
"
" 当补全处于激活状态时
" 可以用”CTRL-E“停止补全并回到原来录入的文字
" 可以用”CTRL-Y“可以停止补全，并接受当前所选的项目
" }}

" OmniCppComplete {{
filetype plugin indent on 

" 在下拉菜单中显示匹配项目,不显示预览窗口
" 并且会自动插入所有匹配项目的相同文本
set completeopt=longest,menu 

"如果下拉菜单弹出，回车映射为接受当前所选项目，否则，仍映射为回车；
inoremap <expr> <CR>  pumvisible()?"\<C-Y>":"\<CR>"

"如果下拉菜单弹出，CTRL-J映射为在下拉菜单中向下翻页。否则映射为CTRL-X CTRL-O；
inoremap <expr> <C-J> pumvisible()?"\<PageDown>\<C-N>\<C-P>":"\<C-X><C-O>"

"如果下拉菜单弹出，CTRL-K映射为在下拉菜单中向上翻页，否则仍映射为CTRL-K；
inoremap <expr> <C-K> pumvisible()?"\<PageUp>\<C-P>\<C-N>":"\<C-K>"

"如果下拉菜单弹出，CTRL-U映射为CTRL-E，即停止补全，否则，仍映射为CTRL-U；
inoremap <expr> <C-U> pumvisible()?"\<C-E>":"\<C-U>" 
" }}

" SuperTab {{
" 补全方式:
" 0 : 不记录上次的补全方式
" 1 : 记住你上次的补全方式，直到使用其它的补全命令改变它
" 2 : 记住上次的补全方式，直到按ESC退出插入模式为止
let g:SuperTabRetainCompletionType = 2
" 设置缺省的补全方式，默认为CTRL-P
let g:SuperTabDefaultCompletionType = "<C-X><C-O>"
" }}

" command-t
" nnoremap <silent> <F7> :CommandT<CR>

" ctags {
set tags=tags
" ctags -R --fields=+iaS --extra=+q /usr/include/
" 用上面的命令生成tags文件重命名为systags即可跳转到标准头文件
" 当不想跳转到标准头文件时，可注释下面行
set tags+=~/.vim/systags
" }

vmap <C-y> "+y
