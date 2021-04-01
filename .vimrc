" subdirectory specific vimrc 사용을 위해서는 
" ~/.vimrc에 'set exrc' 설정이 필요하다.
"
"
augroup foo
  autocmd!
  autocmd BufWritePost */*.md call BuildAndPreview(@%) " @% = current file name
augroup END


" 아래 localhost:300은 brwoser_sync.sh 가 정상 실행된것을 가정하는 코드이다
fu! BuildAndPreview(fnameMd)
  let fnameHtml = substitute(a:fnameMd, ".md", ".html", "g")
  execute '!sh build.sh && $BROWSER http://localhost:3000/' . fnameHtml
endfunction
