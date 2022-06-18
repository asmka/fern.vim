function! fern#internal#drawer#auto_resize#init() abort
  if g:fern#disable_drawer_auto_resize
    return
  endif

  if fern#internal#drawer#is_right_drawer()
    augroup fern_internal_drawer_init_right
      autocmd! * <buffer>
      autocmd BufEnter,WinEnter <buffer> call s:load_width_right()
      autocmd WinLeave <buffer> call s:save_width_right()
    augroup END
  else
    augroup fern_internal_drawer_init
      autocmd! * <buffer>
      autocmd BufEnter,WinEnter <buffer> call s:load_width()
      autocmd WinLeave <buffer> call s:save_width()
    augroup END
  endif
endfunction

if has('nvim')
  function! s:should_ignore() abort
    return nvim_win_get_config(win_getid()).relative !=# ''
  endfunction
else
  function! s:should_ignore() abort
    return 0
  endfunction
endif

function! s:save_width() abort
  echomsg 's:save_width()'
  if s:should_ignore()
    return
  endif
  let t:fern_drawer_auto_resize_width = winwidth(0)
  echomsg 't:fern_drawer_auto_resize_width: ' t:fern_drawer_auto_resize_width
endfunction

function! s:load_width() abort
  echomsg 's:load_width()'
  if s:should_ignore()
    return
  endif
  if !exists('t:fern_drawer_auto_resize_width')
    call fern#internal#drawer#resize()
  else
    " execute 'vertical resize' t:fern_drawer_auto_resize_width
    execute 'vertical resize' g:fern#drawer_width
  endif
endfunction

function! s:save_width_right() abort
  if s:should_ignore()
    return
  endif
  let t:fern_drawer_auto_resize_width_right = winwidth(0)
endfunction

function! s:load_width_right() abort
  if s:should_ignore()
    return
  endif
  if !exists('t:fern_drawer_auto_resize_width_right')
    call fern#internal#drawer#resize()
  else
    execute 'vertical resize' t:fern_drawer_auto_resize_width_right
  endif
endfunction
