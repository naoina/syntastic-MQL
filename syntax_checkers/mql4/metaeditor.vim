if exists('g:loaded_syntastic_mql4_metaeditor_cheker')
  finish
endif
g:loaded_syntastic_mql4_metaeditor_cheker = 1

call g:SyntasticRegistry.CreateAndRegisterChecker({
      \ 'filetype': 'mql4',
      \ 'name': 'metaeditor',
      \ 'redirect': 'mql5/metaeditor',
      \ })
