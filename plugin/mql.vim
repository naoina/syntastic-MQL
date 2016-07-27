if exists('g:syntastic_extra_filetypes')
  call add(g:syntastic_extra_filetypes, 'mql4')
  call add(g:syntastic_extra_filetypes, 'mql5')
else
  let g:syntastic_extra_filetypes = ['mql4', 'mql5']
endif
