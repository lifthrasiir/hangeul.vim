"" hangeul.vim -- vim implementation of Hangeul input method
"" Copyright (c) 2007, Kang Seonghoon aka lifthrasiir.
""
"" This program is free software: you can redistribute it and/or modify
"" it under the terms of the GNU General Public License as published by
"" the Free Software Foundation, either version 2 of the License, or
"" (at your option) any later version.
""
"" This program is distributed in the hope that it will be useful,
"" but WITHOUT ANY WARRANTY; without even the implied warranty of
"" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
"" GNU General Public License for more details.

scripte utf-8

if exists('loaded_hangeul')
	finish
endif
let loaded_hangeul = 1

if !exists('g:hangeul_enabled')
	finish
endif
if !has('autocmd') || !has('iconv')
	echoerr 'hangeul.vim: This plugin requires +autocmd and +iconv.'
	finish
endif

if !exists('g:hangeul_default_mode')
	let g:hangeul_default_mode = '2s'
endif

let s:cpo_save = &cpo
set cpo&vim

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let s:TABLEI0  = 'ㄱ' | let s:TABLEI1  = 'ㄲ' | let s:TABLEI2  = 'ㄴ'
let s:TABLEI3  = 'ㄷ' | let s:TABLEI4  = 'ㄸ' | let s:TABLEI5  = 'ㄹ'
let s:TABLEI6  = 'ㅁ' | let s:TABLEI7  = 'ㅂ' | let s:TABLEI8  = 'ㅃ'
let s:TABLEI9  = 'ㅅ' | let s:TABLEI10 = 'ㅆ' | let s:TABLEI11 = 'ㅇ'
let s:TABLEI12 = 'ㅈ' | let s:TABLEI13 = 'ㅉ' | let s:TABLEI14 = 'ㅊ'
let s:TABLEI15 = 'ㅋ' | let s:TABLEI16 = 'ㅌ' | let s:TABLEI17 = 'ㅍ'
let s:TABLEI18 = 'ㅎ' | let s:TABLEM0  = 'ㅏ' | let s:TABLEM1  = 'ㅐ'
let s:TABLEM2  = 'ㅑ' | let s:TABLEM3  = 'ㅒ' | let s:TABLEM4  = 'ㅓ'
let s:TABLEM5  = 'ㅔ' | let s:TABLEM6  = 'ㅕ' | let s:TABLEM7  = 'ㅖ'
let s:TABLEM8  = 'ㅗ' | let s:TABLEM9  = 'ㅘ' | let s:TABLEM10 = 'ㅙ'
let s:TABLEM11 = 'ㅚ' | let s:TABLEM12 = 'ㅛ' | let s:TABLEM13 = 'ㅜ'
let s:TABLEM14 = 'ㅝ' | let s:TABLEM15 = 'ㅞ' | let s:TABLEM16 = 'ㅟ'
let s:TABLEM17 = 'ㅠ' | let s:TABLEM18 = 'ㅡ' | let s:TABLEM19 = 'ㅢ'
let s:TABLEM20 = 'ㅣ' | let s:TABLEF0  = 'ㄱ' | let s:TABLEF1  = 'ㄲ'
let s:TABLEF2  = 'ㄳ' | let s:TABLEF3  = 'ㄴ' | let s:TABLEF4  = 'ㄵ'
let s:TABLEF5  = 'ㄶ' | let s:TABLEF6  = 'ㄷ' | let s:TABLEF7  = 'ㄹ'
let s:TABLEF8  = 'ㄺ' | let s:TABLEF9  = 'ㄻ' | let s:TABLEF10 = 'ㄼ'
let s:TABLEF11 = 'ㄽ' | let s:TABLEF12 = 'ㄾ' | let s:TABLEF13 = 'ㄿ'
let s:TABLEF14 = 'ㅀ' | let s:TABLEF15 = 'ㅁ' | let s:TABLEF16 = 'ㅂ'
let s:TABLEF17 = 'ㅄ' | let s:TABLEF18 = 'ㅅ' | let s:TABLEF19 = 'ㅆ'
let s:TABLEF20 = 'ㅇ' | let s:TABLEF21 = 'ㅈ' | let s:TABLEF22 = 'ㅊ'
let s:TABLEF23 = 'ㅋ' | let s:TABLEF24 = 'ㅌ' | let s:TABLEF25 = 'ㅍ'
let s:TABLEF26 = 'ㅎ'

let s:TABLEFC0  = 99000 | let s:TABLEFC1  =     0 | let s:TABLEFC2  =    99
let s:TABLEFC3  = 99021 | let s:TABLEFC4  =  3125 | let s:TABLEFC5  =  3185
let s:TABLEFC6  = 99033 | let s:TABLEFC7  = 99052 | let s:TABLEFC8  =  7005
let s:TABLEFC9  =  7065 | let s:TABLEFC10 =  7075 | let s:TABLEFC11 =  7095
let s:TABLEFC12 =  7165 | let s:TABLEFC13 =  7175 | let s:TABLEFC14 =  7185
let s:TABLEFC15 = 99069 | let s:TABLEFC16 = 99079 | let s:TABLEFC17 = 16095
let s:TABLEFC18 = 99099 | let s:TABLEFC19 = 18099 | let s:TABLEFC20 = 99119
let s:TABLEFC21 = 99129 | let s:TABLEFC22 = 99138 | let s:TABLEFC23 = 99148
let s:TABLEFC24 = 99158 | let s:TABLEFC25 = 99168 | let s:TABLEFC26 = 99178

if &enc ==? 'utf-8'
	function s:GetSyllable(serial)
		return nr2char(44033 + a:serial)
	endfunction
else
	function s:GetSyllable(serial)
		let code = 44033 + a:serial
		let s = nr2char(224 + code/4096) . nr2char(128 + code/64%64)
				\ . nr2char(128 + code%64)
		return iconv(s, 'utf-8', &enc)
	endfunction
endif

function s:Update(init, med, fin)
	let keys = ''
	if !(s:init < 0 && s:med < 0 && s:fin < 0)
		let keys = keys . "\<C-H>"
		if ((s:init < 0) + (s:med < 0) == 1) && s:fin >= 0
			let keys = keys . "\<C-H>"
		endif
	endif
	let s:init = a:init | let s:med = a:med | let s:fin = a:fin
	if s:init < 0
		let keys = keys . (s:med < 0 ? '' : s:TABLEM{s:med})
		let keys = keys . (s:fin < 0 ? '' : s:TABLEF{s:fin})
	elseif s:med < 0
		let keys = keys . s:TABLEI{s:init}
		let keys = keys . (s:fin < 0 ? '' : s:TABLEF{s:fin})
	else
		let keys = keys . s:GetSyllable(s:init * 588 + s:med * 28 + s:fin)
	endif
	return keys
endfunction

" 1991 final three-layered keyboard scheme (Sebeolsik final)
" - supports order-independent input of syllable.

let s:MAP3F_33  =   1 | let s:MAP3F_34  = '·' | let s:MAP3F_35  =  21
let s:MAP3F_36  =  13 | let s:MAP3F_37  =  12 | let s:MAP3F_38  = '“'
let s:MAP3F_39  = 216 | let s:MAP3F_40  = "'" | let s:MAP3F_41  = '~'
let s:MAP3F_42  = '”' | let s:MAP3F_43  = '+' | let s:MAP3F_44  = ','
let s:MAP3F_45  = ')' | let s:MAP3F_46  = '.' | let s:MAP3F_47  =-108
let s:MAP3F_48  = 215 | let s:MAP3F_49  =  26 | let s:MAP3F_50  =  19
let s:MAP3F_51  =  16 | let s:MAP3F_52  = 112 | let s:MAP3F_53  = 117
let s:MAP3F_54  = 102 | let s:MAP3F_55  = 107 | let s:MAP3F_56  = 119
let s:MAP3F_57  =-113 | let s:MAP3F_58  = '4' | let s:MAP3F_59  =-207
let s:MAP3F_60  = ',' | let s:MAP3F_61  = '>' | let s:MAP3F_62  = '.'
let s:MAP3F_63  = '!' | let s:MAP3F_64  =   8 | let s:MAP3F_65  =   6
let s:MAP3F_66  = '?' | let s:MAP3F_67  =  23 | let s:MAP3F_68  =  10
let s:MAP3F_69  =   4 | let s:MAP3F_70  =   9 | let s:MAP3F_71  = 103
let s:MAP3F_72  = '0' | let s:MAP3F_73  = '7' | let s:MAP3F_74  = '1'
let s:MAP3F_75  = '2' | let s:MAP3F_76  = '3' | let s:MAP3F_77  = '"'
let s:MAP3F_78  = '-' | let s:MAP3F_79  = '8' | let s:MAP3F_80  = '9'
let s:MAP3F_81  =  25 | let s:MAP3F_82  =  14 | let s:MAP3F_83  =   5
let s:MAP3F_84  =  11 | let s:MAP3F_85  = '6' | let s:MAP3F_86  =   2
let s:MAP3F_87  =  24 | let s:MAP3F_88  =  17 | let s:MAP3F_89  = '5'
let s:MAP3F_90  =  22 | let s:MAP3F_91  = '(' | let s:MAP3F_92  = ':'
let s:MAP3F_93  = '<' | let s:MAP3F_94  = '=' | let s:MAP3F_95  = ';'
let s:MAP3F_96  = '*' | let s:MAP3F_97  =  20 | let s:MAP3F_98  = 113
let s:MAP3F_99  = 105 | let s:MAP3F_100 = 120 | let s:MAP3F_101 = 106
let s:MAP3F_102 = 100 | let s:MAP3F_103 = 118 | let s:MAP3F_104 = 202
let s:MAP3F_105 = 206 | let s:MAP3F_106 = 211 | let s:MAP3F_107 =-200
let s:MAP3F_108 =-212 | let s:MAP3F_109 = 218 | let s:MAP3F_110 =-209
let s:MAP3F_111 = 214 | let s:MAP3F_112 = 217 | let s:MAP3F_113 =  18
let s:MAP3F_114 = 101 | let s:MAP3F_115 =   3 | let s:MAP3F_116 = 104
let s:MAP3F_117 =-203 | let s:MAP3F_118 = 108 | let s:MAP3F_119 =   7
let s:MAP3F_120 =   0 | let s:MAP3F_121 = 205 | let s:MAP3F_122 =  15
let s:MAP3F_123 = '%' | let s:MAP3F_124 = '\' | let s:MAP3F_125 = '/'
let s:MAP3F_126 = '※'

function s:Begin3f()
	let s:init = -1 | let s:med = -1 | let s:fin = -1
	let s:state = 0
endfunction

function s:Compose3f(key)
	let value = s:MAP3F_{a:key}
	if type(value) == type('')
		call s:Finish3f()
		return value
	endif
	let conjoining = 0
	if value < 0
		let value = -value
		let conjoining = 1
	endif

	if s:state == 1 && value == s:init + 200
		" for initial jamo can be doubled
		let s:state = 0
		return s:Update(s:init + 1, s:med, s:fin)
	elseif s:state == 2 && value >= 100 && value < 200
		" for conjoining medial jamo
		let s:state = 0
		if s:med == 8
			if value == 100 | return s:Update(s:init, 9, s:fin)
			elseif value == 101 | return s:Update(s:init, 10, s:fin)
			elseif value == 120 | return s:Update(s:init, 11, s:fin)
			endif
		elseif s:med == 13
			if value == 104 | return s:Update(s:init, 14, s:fin)
			elseif value == 105 | return s:Update(s:init, 15, s:fin)
			elseif value == 120 | return s:Update(s:init, 16, s:fin)
			endif
		endif
	endif

	if value < 100  " -- final jamo
		if s:fin >= 0 | call s:Finish3f() | endif
		let s:state = 0
		return s:Update(s:init, s:med, value)
	elseif value < 200  " -- medial jamo
		if s:med >= 0 | call s:Finish3f() | endif
		let s:state = (conjoining ? 2 : 0)
		return s:Update(s:init, value - 100, s:fin)
	else  " -- initial jamo
		if s:init >= 0 | call s:Finish3f() | endif
		let s:state = (conjoining ? 1 : 0)
		return s:Update(value - 200, s:med, s:fin)
	endif
endfunction

function s:Revert3f()
	let s:state = 0
	if s:fin >= 0
		return s:Update(s:init, s:med, -1)
	endif
	if s:med >= 0
		return s:Update(s:init, -1, -1)
	endif
	if s:init >= 0
		return s:Update(-1, -1, -1)
	endif
	return "\<C-H>"
endfunction

function s:Finish3f()
	let s:init = -1 | let s:med = -1 | let s:fin = -1
	let s:state = 0
endfunction

" KS X 5002 two-layered scheme (Dubeolsik standard)

let s:MAP2S_65  =  615 | let s:MAP2S_66  = 9917 | let s:MAP2S_67  = 1422
let s:MAP2S_68  = 1120 | let s:MAP2S_69  =  499 | let s:MAP2S_70  =  507
let s:MAP2S_71  = 1826 | let s:MAP2S_72  = 9908 | let s:MAP2S_73  = 9902
let s:MAP2S_74  = 9904 | let s:MAP2S_75  = 9900 | let s:MAP2S_76  = 9920
let s:MAP2S_77  = 9918 | let s:MAP2S_78  = 9913 | let s:MAP2S_79  = 9903
let s:MAP2S_80  = 9907 | let s:MAP2S_81  =  899 | let s:MAP2S_82  =  101
let s:MAP2S_83  =  203 | let s:MAP2S_84  = 1019 | let s:MAP2S_85  = 9906
let s:MAP2S_86  = 1725 | let s:MAP2S_87  = 1399 | let s:MAP2S_88  = 1624
let s:MAP2S_89  = 9912 | let s:MAP2S_90  = 1523 | let s:MAP2S_97  =  615
let s:MAP2S_98  = 9917 | let s:MAP2S_99  = 1422 | let s:MAP2S_100 = 1120
let s:MAP2S_101 =  306 | let s:MAP2S_102 =  507 | let s:MAP2S_103 = 1826
let s:MAP2S_104 = 9908 | let s:MAP2S_105 = 9902 | let s:MAP2S_106 = 9904
let s:MAP2S_107 = 9900 | let s:MAP2S_108 = 9920 | let s:MAP2S_109 = 9918
let s:MAP2S_110 = 9913 | let s:MAP2S_111 = 9901 | let s:MAP2S_112 = 9905
let s:MAP2S_113 =  716 | let s:MAP2S_114 =    0 | let s:MAP2S_115 =  203
let s:MAP2S_116 =  918 | let s:MAP2S_117 = 9906 | let s:MAP2S_118 = 1725
let s:MAP2S_119 = 1221 | let s:MAP2S_120 = 1624 | let s:MAP2S_121 = 9912
let s:MAP2S_122 = 1523

function s:Begin2s()
	let s:init = -1 | let s:med = -1 | let s:fin = -1
	let s:state = 0
endfunction

function s:Compose2s(key)
	if a:key < 65 || (a:key - 1) % 32 > 25
		call s:Finish2s()
		return nr2char(a:key)
	endif
	let value1 = s:MAP2S_{a:key} / 100
	let value2 = s:MAP2S_{a:key} % 100
	let isvowel = (value1 == 99)

	if s:state == 1  " -- initial jamo is present
		if isvowel
			let s:state = 2
			return s:Update(s:init, value2, -1)
		elseif 697015 % (value1 * 2 + 5) == 0 && value1 == s:init
			return s:Update(s:init + 1, -1, -1)
		endif
	elseif s:state == 2 || s:state == 5  " -- medial jamo is present
		if isvowel
			if s:med == 8
				if value2 == 0 | return s:Update(s:init, 9, -1)
				elseif value2 == 1 | return s:Update(s:init, 10, -1)
				elseif value2 == 20 | return s:Update(s:init, 11, -1)
				endif
			elseif s:med == 13
				if value2 == 4 | return s:Update(s:init, 14, -1)
				elseif value2 == 5 | return s:Update(s:init, 15, -1)
				elseif value2 == 20 | return s:Update(s:init, 16, -1)
				endif
			endif
		elseif s:state == 2 && value2 != 99
			let s:state = 3
			return s:Update(s:init, s:med, value2)
		endif
	elseif s:state == 3 || s:state == 4  " -- all jamo are present
		if isvowel
			if s:state == 3
				let prevfinal = -1
				let nextinitial = s:fin - s:TABLEFC{s:fin} % 10
			else
				let prevfinal = s:TABLEFC{s:fin} / 1000
				let nextinitial = s:TABLEFC{s:fin} / 10 % 100
			endif
			let iresult = s:Update(s:init, s:med, prevfinal)
			call s:Finish2s()
			let s:state = 2
			return iresult . s:Update(nextinitial, value2, -1)
		else
			let s:state = 4
			if s:fin == 0
				if value2 == 0 | return s:Update(s:init, s:med, 1)
				elseif value2 == 18 | return s:Update(s:init, s:med, 2)
				endif
			elseif s:fin == 3
				if value2 == 21 | return s:Update(s:init, s:med, 4)
				elseif value2 == 26 | return s:Update(s:init, s:med, 5)
				endif
			elseif s:fin == 7
				if value2 == 0 | return s:Update(s:init, s:med, 8)
				elseif value2 == 15 | return s:Update(s:init, s:med, 9)
				elseif value2 == 16 | return s:Update(s:init, s:med, 10)
				elseif value2 == 18 | return s:Update(s:init, s:med, 11)
				elseif value2 == 24 | return s:Update(s:init, s:med, 12)
				elseif value2 == 25 | return s:Update(s:init, s:med, 13)
				elseif value2 == 26 | return s:Update(s:init, s:med, 14)
				endif
			elseif s:fin == 16
				if value2 == 18 | return s:Update(s:init, s:med, 17) | endif
			elseif s:fin == 18
				if value2 == 18 | return s:Update(s:init, s:med, 19) | endif
			endif
		endif
	endif

	call s:Finish2s()
	if value1 == 99
		let s:state = 5
		return s:Update(-1, value2, -1)
	else
		let s:state = 1
		return s:Update(value1, -1, -1)
	endif
endfunction

function s:Revert2s()
	let s:state = 0
	if s:fin >= 0
		return s:Update(s:init, s:med, -1)
	endif
	if s:med >= 0
		return s:Update(s:init, -1, -1)
	endif
	if s:init >= 0
		return s:Update(-1, -1, -1)
	endif
	return "\<C-H>"
endfunction

function s:Finish2s()
	let s:init = -1 | let s:med = -1 | let s:fin = -1
	let s:state = 0
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let s:internal = 0

function s:Begin(reset)
	if a:reset
		let s:internal = 0
		let s:mode = s:prevmode
	endif
	if s:mode != 'en'
		call s:Begin{s:mode}()
	endif
endfunction

function s:Compose(key)
	let s:internal = s:internal + 1
	if s:mode == 'en'
		return nr2char(a:key)
	else
		return s:Compose{s:mode}(a:key)
	endif
endfunction

function s:Revert()
	let s:internal = s:internal + 1
	if s:mode == 'en'
		return "\<C-H>"
	else
		return s:Revert{s:mode}()
	endif
endfunction

function s:Finish(reset)
	if s:mode != 'en'
		call s:Finish{s:mode}()
	endif
	if a:reset
		let s:internal = 0
		let s:prevmode = s:mode
		let s:mode = 'en'
	endif
endfunction

function s:ChangeMode()
	call s:Finish(0)
	let s:mode = (s:mode == 'en' ? g:hangeul_default_mode : 'en')
	call s:Begin(0)
	return ''
endfunction

function s:Refresh()
	if s:internal
		let s:internal = s:internal - 1
		return
	endif
	call s:Finish(0)
	call s:Begin(0)
	let &ro = &ro   " -- force updating of status line
endfunction

function s:ModeString()
	if s:mode == 'en' | return '영문'
	elseif s:mode == '3f' | return '최종'
	elseif s:mode == '39' | return '세90'
	elseif s:mode == '2s' | return '두벌'
	else | return '????'
	endif
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function s:InitMapping(cmdline)
	if a:cmdline
		let map = 'map!' | let noremap = 'noremap!'
	else
		let map = 'imap' | let noremap = 'inoremap'
	endif

	let key = 33
	while key < 127
		exe noremap '<silent> <Char-'.key.'> <C-R>=<SID>Compose('.key.')<CR>'
		let key = key + 1
	endwhile

	exe noremap '<silent> <Plug>HanRevert <C-R>=<SID>Revert()<CR>'
	exe noremap '<silent> <Plug>HanMode <C-R>=<SID>ChangeMode()<CR>'

	exe map '<silent> <BS> <Plug>HanRevert'
	exe map '<silent> <C-H> <Plug>HanRevert'
	if !hasmapto('<Plug>HanMode', 'i')
		exe map '<silent> <C-\><Space> <Plug>HanMode'
	endif
endfunction

function s:InitAutocmd()
	aug Hangeul
		au!
		au CursorMovedI * call <SID>Refresh()
		au InsertEnter * call <SID>Begin(1)
		au InsertLeave * call <SID>Finish(1)
	aug END
endfunction

function s:Init()
	let s:mode = 'en'
	let s:prevmode = s:mode
	let s:prefix = substitute(expand('<sfile>'), '^.*\(<SNR>\d\+_\).*$', '\1', '')

	call s:InitMapping(exists('g:hangeul_cmdline'))
	call s:InitAutocmd()

	if !strlen(&stl)
		set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
	endif
	let &stl = &stl . '  {%{' . s:prefix . 'ModeString()}} '

	"echomsg "hangeul.vim is initialized."
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

call s:Init()

let &cpo = s:cpo_save
finish

" vim: ts=4 sw=4 noet list

