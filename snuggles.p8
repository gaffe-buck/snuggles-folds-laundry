pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
#include color_wipe.lua
#include fancy_text.lua

#include attention_span.lua
#include title_scene.lua
#include game_scene.lua
#include main.lua
__gfx__
0000000000000000044aa4400000000000e222e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000099999900000600000eeeee00000000000000000000000000000000000000000000000000000000000000000000dd00000000000ddd00000
00000000000000000999999000067707000eee00000000000000000000000000000000000000000000000000000000000000000000d77d000000000d777d0000
66677666077767700949949000007777000eee00000000000000000000000000000000000000000000000000000000000000000000d777d0000000d77779d000
776666770076770009900990060007700002220000000000000000000000000000000000000000000000000000000000000000000d97777d00000d777777d000
0066660000077000099009906770700000eeeee000000000000000000000000000000000000000000000000000000000000000000d777722999aabcc77779d00
006666000000000009900990077770000eeeeeee00000000000000000000000000000000000000000000000000000000000000000d97722999aaabbcc7777d00
006666000000000009900990007700000e2e2e2e0000000000000000000000000000000000000000000000000000000000000000d77222999aaaabbccc777d00
00000000000000000000000001000100a990099a0000000000000000000000000000000000000000000000006666666600000001d72229999aaaabbbcc77d000
022222200dd00dd001111110010001000a9009a00000000000000000000000000000000000000000000000007777777600000011d72229999aaaabbbcc77d000
02eee920066006600d1111d00d111d00009999000000000000000000000000000000000000000000000000000006700600000111222229999aaaaabbcc77d000
02eeee20066006600d1111d00d111d000099990000000000000000000000000000000000000000000000000077667760000011112222991977711abbbccd2000
02e9ee900660066001d11d100111110000999900000000000000000000000000000000000000000000000000007700600001111122277177777771777ccd2200
2ee2eee206d006d00110011001111100099999900000000000000000000000000000000000000000000000007766760000111111277171717771717177c22200
292e9ee96660666001100110011011009a9a9a9a0000000000000000000000000000000000000000000000000770070001111111677711717771711777622220
2e2e2e2e66006600000000000110110000000000000000000000000000000000000000000000000000000000666770000111111677777777eee7777777762222
00aaaa000000000000000000000000000011100000000000000000000000000000000000000000000000000055555550011111116777e7777e7777e777622222
0aaaaaa0000000000c00c0c000000000001a1000000000000000000000000000000000000000000000000000444444500111111116777e7575757e7776222222
aa5aa5aa008888000c00c0c000c0c0c0111aa1000000000000000000000000000000000000000000000000005555545001111111106777775557777762222222
aaaaaaaa08999980000000000c0c0c001aaaaa11000000000000000000000000000000000000000000000000a444545001111111000667777777776602222222
a5aaaa5a89abba9800000000000000001aaaaaa10000000000000000000000000000000000000000000000005555545001111111000006777777760002222222
aa5555aa8abccba8c000c00000c0c0c01aaaaaa1000000000000000000000000000000000000000000000000444444500111111000022eeeeeeee22002222222
0aaaaaa08ac00ca8c0c0c0cc0c0c0c0001aaaa110000000000000000000000000000000000000000000000005555545000111110002eeeeeeeeeeee202222222
00aaaa0000000000000000000000000000111100000000000000000000000000000000000000000000000000a44454500011110006666eeeeeeee66660222220
0000030000000000000000030000b000000000000000000000000000000000000000000000000000000000005555545000010000677776eeeeee677776022200
00000300000000000000033000bbbb00005000000000000000000000000000000000000000000000000000004444445000000006777771111111177779602000
000033000000a00000001130008bb80005a500000000000000000000000000000000000000000000000000005555545000000067777778888188877777760000
00030300000a9a0000161130087878700aa90000000000000000000000000000000000000000000000000000a444545000000067a7766e888188e66777760000
088008800000a00001611100088888800aaa99900000000000000000000000000000000000000000000000005555545000000067776eeee8181eeee677760000
878887880000bb00011111000087870000aaaaaa000000000000000000000000000000000000000000000000444444500000000666eeeee1888eeeee66600000
88888888000bb0000111100000088000000aaaa0000000000000000000000000000000000000000000000000555555500000000002eeeeeeeeeeeeee20000000
088008800000b000001100000000000000000000000000000000000000000000000000000000000000000000000004400000000002eeeeeeeeeeeeee20000000
__map__
0000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
