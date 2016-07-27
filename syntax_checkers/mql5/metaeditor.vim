if exists('g:loaded_syntastic_mql5_metaeditor_cheker')
  finish
endif
let g:loaded_syntastic_mql5_metaeditor_cheker = 1

if !exists('g:syntastic_mql5_metaeditor_exe_path')
  let g:syntastic_mql5_metaeditor_exe_path = ''
endif

let s:save_cpo = &cpo
set cpo&vim

let s:metaeditor_exe_path = expand(g:syntastic_mql5_metaeditor_exe_path)

function! SyntaxCheckers_mql5_metaeditor_IsAvailable() dict
  if syntastic#util#isRunningWindows()
    return executable(self.getExec())
  endif
  return executable(self.getExec()) && filereadable(s:metaeditor_exe_path)
endfunction

function! SyntaxCheckers_mql5_metaeditor_GetLocList() dict
  let fname = expand('%')
  let args = '/s /log /compile:' . syntastic#util#shescape(fname) . ' >' . syntastic#util#DevNull() . ' 2>&1'

  if syntastic#util#isRunningWindows()
    let makeprg = self.getExecEscaped() . ' ' . args
  else
    let makeprg =
          \ self.getExecEscaped() . ' ' . syntastic#util#shescape(s:metaeditor_exe_path) . ' ' . args
  endif

  let errorformat =
        \ '%E%f(%l\,%c) : error %n: %m,' .
        \ '%W%f(%l\,%c) : warning %n: %m,' .
        \ '%-G%.%#'

  let loclist = SyntasticMake({
        \ 'makeprg': makeprg,
        \ 'errorformat': errorformat,
        \ 'Preprocess': 'MetaEditorReadErrorLog',
        \ })
  return loclist
endfunction

function! MetaEditorReadErrorLog(errors) abort
  let logfile = expand('%:r') . '.log'
  execute 'edit ++enc=utf-16le ' . logfile
  let errors = getline(0, '$')
  setlocal bufhidden=wipe
  edit #
  call delete(logfile)
  return errors
endfunction

call g:SyntasticRegistry.CreateAndRegisterChecker({
      \ 'filetype': 'mql5',
      \ 'name': 'metaeditor',
      \ 'exec': syntastic#util#isRunningWindows() ? s:metaeditor_exe_path : 'wine'
      \ })

let &cpo = s:save_cpo
unlet s:save_cpo
