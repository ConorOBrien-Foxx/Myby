# Introduction

TLDR, Current Verdict: Myby is decently competitive, sometimes even winning against popular golfing languages, but doesn't consistently beat them, more often losing than winning. There's room for improvement, but it is already well-situated to at least be generally competitive. As of 1/3/2023 (win-loss-tie / total | win%):

```
                     W -  L - T /  Σ |     W%
Myby vs. 05AB1E:    21 - 24 - 4 / 49 | 42.86%
Myby vs. MATL:      20 -  3 - 1 / 24 | 83.33%
Myby vs. Jelly:     12 - 27 - 8 / 47 | 25.53%
Myby vs. Vyxal:     11 - 20 - 7 / 38 | 28.95%
Myby vs. Husk:      11 - 10 - 2 / 23 | 47.83%
Myby vs. Fig:        4 - 14 - 0 / 18 | 22.22%
Myby vs. Nibbles:    2 -  6 - 1 /  9 | 22.22%
```

Disclaimer: Results are not definitive, as it is a form of self-selection.

# Comparison Explorer

{COMPARE}

_Do not post any of the Myby solutions contained herein._

# Problem Listing

{TOC}

## [xor-multiplication](https://codegolf.stackexchange.com/questions/50240/xor-multiplication)

| language | rank | bytes | code |
|----------|------|-------|------|
| [Jelly](https://codegolf.stackexchange.com/questions/50240/xor-multiplication/252199#252199) | | 6b | <code>Bæc/ḂḄ</code> |
| Myby | | 7b | <code>&#126;:&#92;/.&#42;&#92;@.&.&#35;:</code> |
| [05AB1E](https://codegolf.stackexchange.com/questions/50240/xor-multiplication/252208#252208) | | 8b | <code>Îbv·yI&#42;^</code> |
| [Vyxal](https://codegolf.stackexchange.com/questions/50240/xor-multiplication/256279#256279) | | 9b | <code>₌0b&#40;dn⁰&#42;꘍</code> |

## [reconstruct-matrix-from-its-diagonals](https://codegolf.stackexchange.com/questions/252082/reconstruct-matrix-from-its-diagonals)

| language | rank | bytes | code |
|----------|------|-------|------|
| Myby | | 3.5b | <code>&#35;/:!.</code> |
| [Jelly](https://codegolf.stackexchange.com/questions/252082/reconstruct-matrix-from-its-diagonals/252099#252099) | | 8b | <code>ṙLHĊƊṚŒḌ</code> |
| [Vyxal](https://codegolf.stackexchange.com/questions/252082/reconstruct-matrix-from-its-diagonals/252087#252087) | | 12b | <code>Ṗ'L√ẇÞDf?⁼;h</code> |
| [05AB1E](https://codegolf.stackexchange.com/questions/252082/reconstruct-matrix-from-its-diagonals/252085#252085) | | 18b | <code>g;ÝDδ&#45;Z+èεNUεNX‚ßè</code> |
| [Charcoal](https://codegolf.stackexchange.com/questions/252082/reconstruct-matrix-from-its-diagonals/252406#252406) | | 18b | <code>Ｉ⮌Ｅ⊘⊕ＬθＥ⊘⊕Ｌθ⊟§θ⁺ιλ</code> |
| [J](https://codegolf.stackexchange.com/questions/252082/reconstruct-matrix-from-its-diagonals/252092#252092) | | 20b | <code>/:&amp;;&lt;/.@i.@&#40;,&#45;&#41;@%:@&#35;</code> |
| [MathGolf](https://codegolf.stackexchange.com/questions/252082/reconstruct-matrix-from-its-diagonals/252091#252091) | | 21b | <code>h½&#41;r■&#95;@mÅε&#45;&#95;╙+§&#92;mÄ╓m§</code> |
| [APL (Dyalog Unicode)](https://codegolf.stackexchange.com/questions/252082/reconstruct-matrix-from-its-diagonals/252090#252090) | | 22b | <code>⊖w↑i⊖↑⌽⍨≢↑⍥&#45;i←⍳w←≢∘⍉∘↑</code> |
| [Pip `-x`](https://codegolf.stackexchange.com/questions/252082/reconstruct-matrix-from-its-diagonals/252114#252114) | | 22b | <code>Fi,YMX&#35;&#42;aFki+R,yPPOa@k</code> |

## [find-the-sum-of-the-divisors-of-n](https://codegolf.stackexchange.com/questions/142071/find-the-sum-of-the-divisors-of-n)

| language | rank | bytes | code |
|----------|------|-------|------|
| [Vyxal `s`](https://codegolf.stackexchange.com/questions/142071/find-the-sum-of-the-divisors-of-n/238215#238215) | | 1b | <code>K</code> |
| [05AB1E](https://codegolf.stackexchange.com/questions/142071/find-the-sum-of-the-divisors-of-n/142074#142074) | | 2b | <code>ÑO</code> |
| [Brachylog](https://codegolf.stackexchange.com/questions/142071/find-the-sum-of-the-divisors-of-n/142111#142111) | | 2b | <code>f+</code> |
| [Gaia](https://codegolf.stackexchange.com/questions/142071/find-the-sum-of-the-divisors-of-n/142140#142140) | | 2b | <code>dΣ</code> |
| [Husk](https://codegolf.stackexchange.com/questions/142071/find-the-sum-of-the-divisors-of-n/240589#240589) | | 2b | <code>ΣḊ</code> |
| [Jelly](https://codegolf.stackexchange.com/questions/142071/find-the-sum-of-the-divisors-of-n/142076#142076) | | 2b | <code>Æs</code> |
| [MathGolf](https://codegolf.stackexchange.com/questions/142071/find-the-sum-of-the-divisors-of-n/252235#252235) | | 2b | <code>─Σ</code> |
| [Neim](https://codegolf.stackexchange.com/questions/142071/find-the-sum-of-the-divisors-of-n/142147#142147) | | 2b | <code>𝐅𝐬</code> |
| [Ohm v2](https://codegolf.stackexchange.com/questions/142071/find-the-sum-of-the-divisors-of-n/142121#142121) | | 2b | <code>VΣ</code> |
| [RProgN 2](https://codegolf.stackexchange.com/questions/142071/find-the-sum-of-the-divisors-of-n/142090#142090) | | 2b | <code>ƒ+</code> |
| [Fig](https://codegolf.stackexchange.com/questions/142071/find-the-sum-of-the-divisors-of-n/252241#252241) | | 2.469b | <code>+Sk</code> |
| Myby | | 2.5b | <code>+&#92; D</code> |
| [Japt](https://codegolf.stackexchange.com/questions/142071/find-the-sum-of-the-divisors-of-n/142081#142081) | | 3b | <code>â&#41;x</code> |
| [Risky](https://codegolf.stackexchange.com/questions/142071/find-the-sum-of-the-divisors-of-n/241963#241963) | | 3b | <code>+/?+??</code> |
| [cQuents](https://codegolf.stackexchange.com/questions/142071/find-the-sum-of-the-divisors-of-n/254530#254530) | | 3b | <code>Uz$</code> |
| [MY](https://codegolf.stackexchange.com/questions/142071/find-the-sum-of-the-divisors-of-n/142355#142355) | | 4b | <code>ωḊΣ↵</code> |
| [MATL](https://codegolf.stackexchange.com/questions/142071/find-the-sum-of-the-divisors-of-n/142149#142149) | | 6b | <code>t:&#92;&#126;fs</code> |
| [Pyth](https://codegolf.stackexchange.com/questions/142071/find-the-sum-of-the-divisors-of-n/142116#142116) | | 6b | <code>s&#42;M{yP</code> |
| [APL](https://codegolf.stackexchange.com/questions/142071/find-the-sum-of-the-divisors-of-n/142356#142356) | | 9b | <code>+/⍳×0=⍳&#124;⊢</code> |
| [K (ngn/k)](https://codegolf.stackexchange.com/questions/142071/find-the-sum-of-the-divisors-of-n/242041#242041) | | 14b | <code>{+/&amp;&#126;1!x%!1+x}</code> |
| [GolfScript](https://codegolf.stackexchange.com/questions/142071/find-the-sum-of-the-divisors-of-n/211111#211111) | | 15b | <code>&#126;.,{.3$&#92;%!&#42;+}&#42;+</code> |
| [CJam](https://codegolf.stackexchange.com/questions/142071/find-the-sum-of-the-divisors-of-n/142153#142153) | | 16b | <code>ri:X{&#41;&#95;X&#92;%!&#42;}%:+</code> |
| [J](https://codegolf.stackexchange.com/questions/142071/find-the-sum-of-the-divisors-of-n/142109#142109) | | 23b | <code>&#91;:+/&#93;&#40;&#40;&#91;:=&amp;0&#93;&#124;&#91;&#41;&#35;&#93;&#41;1+i.</code> |

## [fibonacci-function-or-sequence](https://codegolf.stackexchange.com/questions/85/fibonacci-function-or-sequence)

| language | rank | bytes | code |
|----------|------|-------|------|
| [MathGolf](https://codegolf.stackexchange.com/questions/85/fibonacci-function-or-sequence/248434#248434) | | 1b | <code>f</code> |
| [Pyt](https://codegolf.stackexchange.com/questions/85/fibonacci-function-or-sequence/151903#151903) | | 1b | <code>Ḟ</code> |
| [05AB1E](https://codegolf.stackexchange.com/questions/85/fibonacci-function-or-sequence/170744#170744) | | 2b | <code>Åf</code> |
| [Husk](https://codegolf.stackexchange.com/questions/85/fibonacci-function-or-sequence/137143#137143) | | 2b | <code>İf</code> |
| [Oasis](https://codegolf.stackexchange.com/questions/85/fibonacci-function-or-sequence/191443#191443) | | 2b | <code>+T</code> |
| [Stax](https://codegolf.stackexchange.com/questions/85/fibonacci-function-or-sequence/158186#158186) | | 2b | <code>&#124;5</code> |
| [Vyxal](https://codegolf.stackexchange.com/questions/85/fibonacci-function-or-sequence/223094#223094) | | 2b | <code>ÞF</code> |
| [Japt](https://codegolf.stackexchange.com/questions/85/fibonacci-function-or-sequence/154481#154481) | | 3b | <code>MgU</code> |
| [Jelly](https://codegolf.stackexchange.com/questions/85/fibonacci-function-or-sequence/66839#66839) | | 3b | <code>+¡1</code> |
| [flax](https://codegolf.stackexchange.com/questions/85/fibonacci-function-or-sequence/243108#243108) | | 3b | <code>1+ⁿ</code> |
| [Fig](https://codegolf.stackexchange.com/questions/85/fibonacci-function-or-sequence/248952#248952) | | 3.292b | <code>G:1'+</code> |
| [Chocolate](https://codegolf.stackexchange.com/questions/85/fibonacci-function-or-sequence/249230#249230) | | 4b | <code>G+c1</code> |
| [TeaScript](https://codegolf.stackexchange.com/questions/85/fibonacci-function-or-sequence/62019#62019) | | 4b | <code>F&#40;x&#41;</code> <br/> <code></code> <br/> <code>F&#40;x&#41; //Find the Fibonacci number at the input</code> |
| Myby | | 4.5b | <code>+&#92;&#35;!"&R&#45;</code> |
| [Nibbles](https://codegolf.stackexchange.com/questions/85/fibonacci-function-or-sequence/254601#254601) | | 4.5b | <code>.&#126;&#126;1+&lt;2</code> |
| [Alpax](https://codegolf.stackexchange.com/questions/85/fibonacci-function-or-sequence/76324#76324) | | 5b | <code>⇇+</code> <br/> <code>1¹</code> |
| [Arn](https://codegolf.stackexchange.com/questions/85/fibonacci-function-or-sequence/209583#209583) | | 5b | <code>╔Tò”7</code> |
| [Duocentehexaquinquagesimal](https://codegolf.stackexchange.com/questions/85/fibonacci-function-or-sequence/223675#223675) | | 5b | <code>±∊YO$</code> |
| [Halfwit](https://codegolf.stackexchange.com/questions/85/fibonacci-function-or-sequence/243112#243112) | | 5.5b | <code>n&gt;&lt;?&#40;:}+</code> |
| [Gaia](https://codegolf.stackexchange.com/questions/85/fibonacci-function-or-sequence/133552#133552) | | 6b | <code>0₁@+₌ₓ</code> |
| [J-uby](https://codegolf.stackexchange.com/questions/85/fibonacci-function-or-sequence/110149#110149) | | 6b | <code>:++2.&#42;</code> |
| [cQuents](https://codegolf.stackexchange.com/questions/85/fibonacci-function-or-sequence/128238#128238) | | 6b | <code>=1:z+y</code> |
| [tq](https://codegolf.stackexchange.com/questions/85/fibonacci-function-or-sequence/197601#197601) | | 6b | <code>01p+r&#41;</code> |
| [𝔼𝕊𝕄𝕚𝕟](https://codegolf.stackexchange.com/questions/85/fibonacci-function-or-sequence/69915#69915) | | 6b | <code>Мȫï</code> |
| [Thunno `Y`](https://codegolf.stackexchange.com/questions/85/fibonacci-function-or-sequence/256271#256271) | | 6.58b | <code>R{xyAx+Y</code> |
| [APL (Dyalog Unicode)](https://codegolf.stackexchange.com/questions/85/fibonacci-function-or-sequence/223225#223225) | | 7b | <code>+.!∘⌽⍨⍳</code> |
| [Gol&#62;&#60;&#62;](https://codegolf.stackexchange.com/questions/85/fibonacci-function-or-sequence/193582#193582) | | 7b | <code>12K+:N!</code> |
| [K](https://codegolf.stackexchange.com/questions/85/fibonacci-function-or-sequence/253768#253768) | | 8b | <code>+/&#91;;1;0&#93;</code> |
| [J](https://codegolf.stackexchange.com/questions/85/fibonacci-function-or-sequence/87107#87107) | | 9b | <code>+/@:!&amp;i.&#45;</code> |
| [Pip](https://codegolf.stackexchange.com/questions/85/fibonacci-function-or-sequence/62707#62707) | | 9b | <code>W1o:y+YPo</code> |
| [&#92;/&#92;/&#62;](https://codegolf.stackexchange.com/questions/85/fibonacci-function-or-sequence/188277#188277) | | 9b | <code>:@+1}:nau</code> |
| [Brachylog](https://codegolf.stackexchange.com/questions/85/fibonacci-function-or-sequence/190928#190928) | | 10b | <code>0;1⟨t≡+⟩ⁱh</code> |
| [Gogh](https://codegolf.stackexchange.com/questions/85/fibonacci-function-or-sequence/75719#75719) | | 10b | <code>¹Ƥ{Ƥ÷®+Ø}x</code> |
| [Keg](https://codegolf.stackexchange.com/questions/85/fibonacci-function-or-sequence/189656#189656) | | 10b | <code>01{:. ,:"+</code> |
| [CJam](https://codegolf.stackexchange.com/questions/85/fibonacci-function-or-sequence/74634#74634) | | 11b | <code>0X{&#95;@+}q&#126;&#42;;</code> |
| [Fuzzy Octo Guacamole](https://codegolf.stackexchange.com/questions/85/fibonacci-function-or-sequence/77521#77521) | | 11b | <code>01&#40;!aZrZo;&#41;</code> |
| [Sesos](https://codegolf.stackexchange.com/questions/85/fibonacci-function-or-sequence/86447#86447) | | 11b | <code>0000000: ae8583 ef6bc7 045fe7 b907                         ....k..&#95;...</code> <br/> <code></code> <br/> <code>Size   : 11 byte&#40;s&#41;</code> |
| [BQN](https://codegolf.stackexchange.com/questions/85/fibonacci-function-or-sequence/240265#240265) | | 13b | <code>{⊑+´⊸∾⟜⊏⍟𝕩↕2}</code> |
| [Pylons](https://codegolf.stackexchange.com/questions/85/fibonacci-function-or-sequence/71126#71126) | | 13b | <code>11fA..+@{A,i}</code> |
| [Pyth](https://codegolf.stackexchange.com/questions/85/fibonacci-function-or-sequence/202953#202953) | | 13b | <code>A&#40;Z1&#41;&#35;HA&#40;H+HG</code> |
| [Actually](https://codegolf.stackexchange.com/questions/85/fibonacci-function-or-sequence/206943#206943) | | 16b | <code>&quot;1,&quot;◙01W;a+;◙',◙</code> |

## [minimum-excluded-number](https://codegolf.stackexchange.com/questions/38325/minimum-excluded-number)

| language | rank | bytes | code |
|----------|------|-------|------|
| [Brachylog](https://codegolf.stackexchange.com/questions/38325/minimum-excluded-number/252022#252022) | | 3b | <code>≡ⁿℕ</code> |
| [Jelly](https://codegolf.stackexchange.com/questions/38325/minimum-excluded-number/252204#252204) | | 4b | <code>0ḟ1&#35;</code> |
| [MathGolf](https://codegolf.stackexchange.com/questions/38325/minimum-excluded-number/173768#173768) | | 4b | <code>Jr,╓</code> |
| [Vyxal `r`](https://codegolf.stackexchange.com/questions/38325/minimum-excluded-number/252020#252020) | | 4b | <code>₇ʀFg</code> |
| [Fig](https://codegolf.stackexchange.com/questions/38325/minimum-excluded-number/252196#252196) | | 4.116b | <code>&#91;FxmN</code> |
| Myby | | 4.5b | <code>{ R@100&&#45;</code> |
| [05AB1E](https://codegolf.stackexchange.com/questions/38325/minimum-excluded-number/252023#252023) | | 5b | <code>₂ÝIKн</code> |
| [Japt](https://codegolf.stackexchange.com/questions/38325/minimum-excluded-number/252024#252024) | | 5b | <code>@øX}f</code> |
| [Stax](https://codegolf.stackexchange.com/questions/38325/minimum-excluded-number/173759#173759) | | 5b | <code>wiix&#35;</code> |
| [Pyth](https://codegolf.stackexchange.com/questions/38325/minimum-excluded-number/164343#164343) | | 6b | <code>f!}TQZ</code> |
| [K](https://codegolf.stackexchange.com/questions/38325/minimum-excluded-number/173828#173828) | | 7b | <code>&#42;&#40;!22&#41;^</code> |
| [Pip](https://codegolf.stackexchange.com/questions/38325/minimum-excluded-number/252201#252201) | | 7b | <code>WiNgUii</code> |
| [APL (Dyalog Classic)](https://codegolf.stackexchange.com/questions/38325/minimum-excluded-number/164377#164377) | | 11b | <code>f←⊃⊢&#126;⍨0,⍳∘⍴</code> |
| [J](https://codegolf.stackexchange.com/questions/38325/minimum-excluded-number/38344#38344) | | 13b | <code>f=:0{i.@21&amp;&#45;.</code> |
| [APL (Dyalog)](https://codegolf.stackexchange.com/questions/38325/minimum-excluded-number/118303#118303) | | 19b | <code>&#40;0⍳⍨⊢=⍳∘⍴&#41;∘&#40;⊂∘⍋⌷⊢&#41;∪</code> |

## [compute-the-median](https://codegolf.stackexchange.com/questions/106149/compute-the-median)

| language | rank | bytes | code |
|----------|------|-------|------|
| [Actually](https://codegolf.stackexchange.com/questions/106149/compute-the-median/106163#106163) | | 1b | <code>║</code> |
| [05AB1E](https://codegolf.stackexchange.com/questions/106149/compute-the-median/173091#173091) | | 2b | <code>Åm</code> |
| [Jelly](https://codegolf.stackexchange.com/questions/106149/compute-the-median/145877#145877) | | 2b | <code>Æṁ</code> |
| [MATL](https://codegolf.stackexchange.com/questions/106149/compute-the-median/106150#106150) | | 4b | <code>.5Xq</code> |
| [Julia 0.6.0  ()](https://codegolf.stackexchange.com/questions/106149/compute-the-median/138621#138621) | | 6b | <code>median&#40;a&#41;</code> |
| [Matlab/Octave](https://codegolf.stackexchange.com/questions/106149/compute-the-median/106152#106152) | | 6b | <code>median</code> |
| [Vyxal](https://codegolf.stackexchange.com/questions/106149/compute-the-median/252202#252202) | | 6b | <code>s∆ṁwfṁ</code> |
| Myby | | 8.5b | <code>&#126;:+{2!&#45;@%+"%</code> |
| [Fig](https://codegolf.stackexchange.com/questions/106149/compute-the-median/252194#252194) | | 9.054b | <code>KY</code> <br/> <code>HSt2s{HL</code> |
| [Husk](https://codegolf.stackexchange.com/questions/106149/compute-the-median/173080#173080) | | 10b | <code>½ΣF&#126;e→←½OD</code> |
| [Pyth](https://codegolf.stackexchange.com/questions/106149/compute-the-median/106157#106157) | | 11b | <code>.O@R/lQ2&#95;BS</code> |
| [Arn](https://codegolf.stackexchange.com/questions/106149/compute-the-median/224855#224855) | | 12b | <code>Iõå&#41;n├┼U■¨Mõ</code> |
| [APL (Dyalog Unicode)](https://codegolf.stackexchange.com/questions/106149/compute-the-median/173131#173131) | | 14b | <code>≢⊃2+/2/⊂∘⍋⌷÷∘2</code> |
| [J](https://codegolf.stackexchange.com/questions/106149/compute-the-median/173140#173140) | | 14b | <code>2%&#126;&#35;{2&#35;/:&#126;+&#92;:&#126;</code> |
| [Pip](https://codegolf.stackexchange.com/questions/106149/compute-the-median/253792#253792) | | 16b | <code>SN:g&#40;CHg+Rgoi&#41;/2</code> |
| [GolfScript](https://codegolf.stackexchange.com/questions/106149/compute-the-median/173066#173066) | | 17b | <code>&#126;..+$&#92;,&#40;&gt;2&lt;&#126;+"/2"</code> |
| [BQN](https://codegolf.stackexchange.com/questions/106149/compute-the-median/224462#224462) | | 20b | <code>{2÷˜&#40;≠𝕩&#41;⊑»+˝˘2↕2/∧𝕩}</code> |
| [Japt](https://codegolf.stackexchange.com/questions/106149/compute-the-median/106405#106405) | | 20b | <code>n gV=0&#124;½&#42;Ul&#41;+Ug&#126;V&#41;/2</code> |
| [CJAM](https://codegolf.stackexchange.com/questions/106149/compute-the-median/106280#106280) | | 21b | <code>q&#126;&#93;$&#95;&#95;,2/=&#92;&#95;,&#40;2/=+2d/</code> |
| [K](https://codegolf.stackexchange.com/questions/106149/compute-the-median/139469#139469) | | 23b | <code>{avg x&#40;&lt;x&#41;@&#95;.5&#42;&#45;1 0+&#35;x}</code> |
| [APL](https://codegolf.stackexchange.com/questions/106149/compute-the-median/138636#138636) | | 26b | <code>{3&gt;≢⍵:&#40;+/÷≢&#41;⍵⋄∇1↓¯1↓⍵&#91;⍋⍵&#93;}</code> |
| [APL (NARS)](https://codegolf.stackexchange.com/questions/106149/compute-the-median/173142#173142) | | 62b | <code>{2÷⍨x&#91;⌊k&#93;+&#40;⌈k←2÷⍨1+≢⍵&#41;⌷x←⍵&#91;⍋⍵&#93;}</code> |

## [find-the-nth-mersenne-prime](https://codegolf.stackexchange.com/questions/251594/find-the-nth-mersenne-prime)

| language | rank | bytes | code |
|----------|------|-------|------|
| [05AB1E](https://codegolf.stackexchange.com/questions/251594/find-the-nth-mersenne-prime/251671#251671) | | 5b | <code>∞o&lt;ʒp</code> |
| [Fig](https://codegolf.stackexchange.com/questions/251594/find-the-nth-mersenne-prime/252306#252306) | | 6.585b | <code>F@p{^2mC</code> |
| [Husk](https://codegolf.stackexchange.com/questions/251594/find-the-nth-mersenne-prime/251607#251607) | | 7b | <code>!fṗm←İ2</code> |
| [Jelly](https://codegolf.stackexchange.com/questions/251594/find-the-nth-mersenne-prime/251627#251627) | | 7b | <code>&amp;‘&lt;Ẓø&#35;Ṫ</code> |
| Myby | | 7b | <code>&#40;e.@&#35;: &#42; primq&#41; G</code> |
| [Vyxal `G`](https://codegolf.stackexchange.com/questions/251594/find-the-nth-mersenne-prime/251598#251598) | | 7b | <code>Þ∞E‹&#126;æẎ</code> |
| [Brachylog](https://codegolf.stackexchange.com/questions/251594/find-the-nth-mersenne-prime/251623#251623) | | 14b | <code>;2{;X≜^&#45;₁ṗ}ᶠ⁽t</code> |
| [Japt](https://codegolf.stackexchange.com/questions/251594/find-the-nth-mersenne-prime/251684#251684) | | 14b | <code>Èõ!²mÉ øX&#42;j}iU</code> |
| [Charcoal](https://codegolf.stackexchange.com/questions/251594/find-the-nth-mersenne-prime/251601#251601) | | 26b | <code>Ｎθ≔¹ηＷθ«≔⊕⊗ηη≧⁻﹪±Π…¹ηηθ»Ｉη</code> |

## [product-of-divisors](https://codegolf.stackexchange.com/questions/130454/product-of-divisors)

| language | rank | bytes | code |
|----------|------|-------|------|
| [05AB1E](https://codegolf.stackexchange.com/questions/130454/product-of-divisors/130465#130465) | | 2b | <code>ÑP</code> |
| [Husk](https://codegolf.stackexchange.com/questions/130454/product-of-divisors/215651#215651) | | 2b | <code>ΠḊ</code> |
| [Neim](https://codegolf.stackexchange.com/questions/130454/product-of-divisors/130479#130479) | | 2b | <code>𝐅𝐩</code> |
| [RProgN 2](https://codegolf.stackexchange.com/questions/130454/product-of-divisors/143051#143051) | | 2b | <code>ƒ&#42;</code> |
| [Vyxal](https://codegolf.stackexchange.com/questions/130454/product-of-divisors/252247#252247) | | 2b | <code>KΠ</code> |
| [Fig](https://codegolf.stackexchange.com/questions/130454/product-of-divisors/252242#252242) | | 2.469b | <code>&#42;rk</code> |
| Myby | | 2.5b | <code>&#42;&#92; D</code> |
| [Arn](https://codegolf.stackexchange.com/questions/130454/product-of-divisors/215593#215593) | | 3b | <code>Þ┤â</code> |
| [Japt](https://codegolf.stackexchange.com/questions/130454/product-of-divisors/130460#130460) | | 3b | <code>â ×</code> |
| [Jelly](https://codegolf.stackexchange.com/questions/130454/product-of-divisors/130455#130455) | | 3b | <code>ÆDP</code> |
| [MATL](https://codegolf.stackexchange.com/questions/130454/product-of-divisors/130459#130459) | | 3b | <code>Z&#92;p</code> |
| [MathGolf](https://codegolf.stackexchange.com/questions/130454/product-of-divisors/215601#215601) | | 3b | <code>─ε&#42;</code> |
| [MY](https://codegolf.stackexchange.com/questions/130454/product-of-divisors/131632#131632) | | 4b | <code>1A 3A 54 27</code> |
| [Pyth](https://codegolf.stackexchange.com/questions/130454/product-of-divisors/130456#130456) | | 6b | <code>&#42;Fs{yP</code> |
| [APL (Dyalog Unicode)](https://codegolf.stackexchange.com/questions/130454/product-of-divisors/216672#216672) | | 7b | <code>f←×/∘∪⊢∨⍳</code> |
| [J](https://codegolf.stackexchange.com/questions/130454/product-of-divisors/130474#130474) | | 19b | <code>&#42;/}.I.&#40;=&lt;.&#41;&#40;%i.@&gt;:&#41;</code> |

## [antisymmetry-of-a-matrix](https://codegolf.stackexchange.com/questions/208982/antisymmetry-of-a-matrix)

| language | rank | bytes | code |
|----------|------|-------|------|
| [05AB1E](https://codegolf.stackexchange.com/questions/208982/antisymmetry-of-a-matrix/213921#213921) | | 3b | <code>ø&#40;Q</code> |
| [APL (Dyalog Unicode)](https://codegolf.stackexchange.com/questions/208982/antisymmetry-of-a-matrix/208985#208985) | | 3b | <code>&#45;≡⍉</code> |
| [Jelly](https://codegolf.stackexchange.com/questions/208982/antisymmetry-of-a-matrix/213919#213919) | | 3b | <code>N⁼Z</code> |
| Myby | | 3b | <code>&#45;V=^</code> |
| [Brachylog](https://codegolf.stackexchange.com/questions/208982/antisymmetry-of-a-matrix/208997#208997) | | 5b | <code>&#92;ṅᵐ²?</code> |
| [Husk](https://codegolf.stackexchange.com/questions/208982/antisymmetry-of-a-matrix/213918#213918) | | 5b | <code>§=T†&#95;</code> |
| [Japt](https://codegolf.stackexchange.com/questions/208982/antisymmetry-of-a-matrix/208988#208988) | | 5b | <code>eUy®n</code> |
| [MATL](https://codegolf.stackexchange.com/questions/208982/antisymmetry-of-a-matrix/208992#208992) | | 5b | <code>!&#95;GX=</code> |
| [Pip](https://codegolf.stackexchange.com/questions/208982/antisymmetry-of-a-matrix/208996#208996) | | 5b | <code>Z&#95;=&#45;&#95;</code> |
| [Pyth](https://codegolf.stackexchange.com/questions/208982/antisymmetry-of-a-matrix/208995#208995) | | 5b | <code>qC&#95;MM</code> |
| [K](https://codegolf.stackexchange.com/questions/208982/antisymmetry-of-a-matrix/254630#254630) | | 7b | <code>{x&#126;&#45;+x}</code> |
| [Charcoal](https://codegolf.stackexchange.com/questions/208982/antisymmetry-of-a-matrix/209014#209014) | | 10b | <code>⁼θＥθＥθ±§λκ</code> |
| [J-uby](https://codegolf.stackexchange.com/questions/208982/antisymmetry-of-a-matrix/254622#254622) | | 28b | <code>:=&#126; &amp; &#40;:transpose &#124; :&#42; &amp; &#40;:&#42; &amp; :&#45;@&#41;&#41;</code> <br/> <code></code> <br/> <code>       :transpose &#124;                   &#35; Transpose input, then</code> <br/> <code>                    :&#42; &amp; &#40;        &#41;   &#35; Map with</code> <br/> <code>                          :&#42; &amp; :&#45;@    &#35;   Map with negate</code> <br/> <code>:=&#126; &amp; &#40;                            &#41;  &#35; Equal to input</code> |

## [list-of-primes-under-a-million](https://codegolf.stackexchange.com/questions/5977/list-of-primes-under-a-million)

| language | rank | bytes | code |
|----------|------|-------|------|
| [Ohm](https://codegolf.stackexchange.com/questions/5977/list-of-primes-under-a-million/111911#111911) | | 3b | <code>6°P</code> |
| Myby | | 3.5b | <code>primb 1000000</code> |
| [Vyxal](https://codegolf.stackexchange.com/questions/5977/list-of-primes-under-a-million/239947#239947) | | 4b | <code>k4'æ</code> |
| [MATL](https://codegolf.stackexchange.com/questions/5977/list-of-primes-under-a-million/96174#96174) | | 5b | <code>1e6Zq</code> |
| [MathGolf](https://codegolf.stackexchange.com/questions/5977/list-of-primes-under-a-million/252152#252152) | | 5b | <code>►rg¶n</code> |
| [gs2](https://codegolf.stackexchange.com/questions/5977/list-of-primes-under-a-million/55868#55868) | | 5b | <code>∟&#41;◄lT</code> |
| [05AB1E](https://codegolf.stackexchange.com/questions/5977/list-of-primes-under-a-million/164545#164545) | | 6b | <code>6°ÅPε,</code> |
| [Japt `-R`](https://codegolf.stackexchange.com/questions/5977/list-of-primes-under-a-million/211901#211901) | | 6b | <code>L³õ fj</code> |
| [APL (NARS)](https://codegolf.stackexchange.com/questions/5977/list-of-primes-under-a-million/58785#58785) | | 7b | <code>⍸0π⍳1e6</code> |
| [Jelly](https://codegolf.stackexchange.com/questions/5977/list-of-primes-under-a-million/128312#128312) | | 7b | <code>10&#42;6ÆRY</code> |
| [Stax](https://codegolf.stackexchange.com/questions/5977/list-of-primes-under-a-million/157056#157056) | | 7b | <code>ç►╪&#40;Æ;Ç</code> |
| [Pyt](https://codegolf.stackexchange.com/questions/5977/list-of-primes-under-a-million/157210#157210) | | 8b | <code>6ᴇřĐṗ&#42;žÁ</code> |
| [Pyth](https://codegolf.stackexchange.com/questions/5977/list-of-primes-under-a-million/80877#80877) | | 9b | <code>V^T6IP&#95;NN</code> |
| [APL](https://codegolf.stackexchange.com/questions/5977/list-of-primes-under-a-million/13030#13030) | | 15b | <code>p&#126;,p∘.×p←1↓⍳1e6</code> |
| [APL (Dyalog)](https://codegolf.stackexchange.com/questions/5977/list-of-primes-under-a-million/55962#55962) | | 15b | <code>⍪&#40;⊢&#126;∘.×⍨&#41;1↓⍳1E6</code> |

## [mathematical-combination](https://codegolf.stackexchange.com/questions/1744/mathematical-combination)

| language | rank | bytes | code |
|----------|------|-------|------|
| [05AB1E](https://codegolf.stackexchange.com/questions/1744/mathematical-combination/206489#206489) | | 1b | <code>c</code> |
| [Jelly](https://codegolf.stackexchange.com/questions/1744/mathematical-combination/219534#219534) | | 1b | <code>c</code> |
| [Japt](https://codegolf.stackexchange.com/questions/1744/mathematical-combination/252296#252296) | | 2b | <code>àV</code> |
| [APL](https://codegolf.stackexchange.com/questions/1744/mathematical-combination/1746#1746) | | 3b | <code>⎕!⎕</code> |
| Myby | | 3.5b | <code>!&#126;&#92;,</code> |
| [CJam](https://codegolf.stackexchange.com/questions/1744/mathematical-combination/206509#206509) | | 19b | <code>l&#126;&#92;&#95;m!@@&#92;&#95;m!@@&#45;m!&#42;/</code> |

## [pwas-eht-tirsf-dna-tasl-setterl-fo-hace-dorw](https://codegolf.stackexchange.com/questions/185674/pwas-eht-tirsf-dna-tasl-setterl-fo-hace-dorw)

| language | rank | bytes | code |
|----------|------|-------|------|
| [Nibbles](https://codegolf.stackexchange.com/questions/185674/pwas-eht-tirsf-dna-tasl-setterl-fo-hace-dorw/252370#252370) | | 5b | <code>:&#96;&#40;&#92;@:&#96;&#41;&#92;$</code> |
| [Stax](https://codegolf.stackexchange.com/questions/185674/pwas-eht-tirsf-dna-tasl-setterl-fo-hace-dorw/248343#248343) | | 6b | <code>╡à⌂≤¬&#41;</code> |
| [Japt `-S`](https://codegolf.stackexchange.com/questions/185674/pwas-eht-tirsf-dna-tasl-setterl-fo-hace-dorw/185743#185743) | | 7b | <code>¸®ÎiZÅé</code> |
| [Vyxal](https://codegolf.stackexchange.com/questions/185674/pwas-eht-tirsf-dna-tasl-setterl-fo-hace-dorw/247990#247990) | | 7b | <code>⌈ƛḣǔp;Ṅ</code> |
| [Vyxal `S`](https://codegolf.stackexchange.com/questions/185674/pwas-eht-tirsf-dna-tasl-setterl-fo-hace-dorw/236099#236099) | | 7b | <code>⌈ƛḣṫ∇p+</code> |
| [Jelly](https://codegolf.stackexchange.com/questions/185674/pwas-eht-tirsf-dna-tasl-setterl-fo-hace-dorw/185707#185707) | | 9b | <code>ḲṪ;ṙ1$Ɗ€K</code> |
| Myby | | 9.5b | <code>&#40;}+1&#62;.&#60;:&#41;"&.&#40;/&' '&#41;</code> |
| [05AB1E](https://codegolf.stackexchange.com/questions/185674/pwas-eht-tirsf-dna-tasl-setterl-fo-hace-dorw/185675#185675) | | 10b | <code>&#35;vyRćsRćðJ</code> |
| [Husk](https://codegolf.stackexchange.com/questions/185674/pwas-eht-tirsf-dna-tasl-setterl-fo-hace-dorw/252369#252369) | | 10b | <code>wm§:→oṙ1hw</code> |
| [Pip](https://codegolf.stackexchange.com/questions/185674/pwas-eht-tirsf-dna-tasl-setterl-fo-hace-dorw/236088#236088) | | 15b | <code>aR+XW{@a::a@va}</code> |
| [J](https://codegolf.stackexchange.com/questions/185674/pwas-eht-tirsf-dna-tasl-setterl-fo-hace-dorw/185718#185718) | | 17b | <code>&#40;{:,1&#124;.}:&#41;&amp;.&gt;&amp;.;:</code> |
| [QuadR](https://codegolf.stackexchange.com/questions/185674/pwas-eht-tirsf-dna-tasl-setterl-fo-hace-dorw/185681#185681) | | 20b | <code>&#40;&#92;w&#41;&#40;&#92;w&#42;&#41;&#40;&#92;w&#41;</code> <br/> <code>&#92;3&#92;2&#92;1</code> |
| [Z80Golf](https://codegolf.stackexchange.com/questions/185674/pwas-eht-tirsf-dna-tasl-setterl-fo-hace-dorw/185773#185773) | | 43b | <code>00000000: 2100 c0cd 0380 3822 5745 cd03 8038 09fe  !.....8"WE...8..</code> <br/> <code>00000010: 2028 0570 4723 18f2 736b 707e 23a7 2803   &#40;.pG&#35;..skp&#126;&#35;.&#40;.</code> <br/> <code>00000020: ff18 f87a ff3e 20ff 18d6 76              ...z.&gt; ...v</code> |
| [APL+WIN](https://codegolf.stackexchange.com/questions/185674/pwas-eht-tirsf-dna-tasl-setterl-fo-hace-dorw/185713#185713) | | 50b | <code>&#40;∊¯1↑¨s&#41;,¨1↓¨&#40;¯1↓¨s&#41;,¨↑¨s←&#40;&#40;+&#92;s=' '&#41;⊂s←' ',⎕&#41;&#126;¨' '</code> |

## [carryless-factors](https://codegolf.stackexchange.com/questions/252189/carryless-factors)

| language | rank | bytes | code |
|----------|------|-------|------|
| [Jelly](https://codegolf.stackexchange.com/questions/252189/carryless-factors/252200#252200) | | 11b | <code>B€æcþ&#96;Ḃċ€BT</code> |
| Myby | | 14.5b | <code>^ &#35; &#35; e." &#40;&#126;:&#92;/. &#42;&#92; @.&.&#35;:&#41;&#96;:&#92;&#126;@^</code> |
| [05AB1E](https://codegolf.stackexchange.com/questions/252189/carryless-factors/252209#252209) | | 18b | <code>LʒULε0sbv·yX&#42;^}Q}à</code> |
| [Vyxal](https://codegolf.stackexchange.com/questions/252189/carryless-factors/252213#252213) | | 18b | <code>'£?ƛ0$b&#40;dn¥&#42;꘍&#41;?=;a</code> |
| [Charcoal](https://codegolf.stackexchange.com/questions/252189/carryless-factors/252210#252210) | | 48b | <code>ＮθＦθ«≔θηＦ⮌×⊕ιＸ²…·⁰⁻Ｌ↨θ²Ｌ↨⊕ι²≔⌊⟦η⁻｜ηκ＆ηκ⟧η¿¬η⟦Ｉ⊕ι</code> |

## [scan-a-ragged-list](https://codegolf.stackexchange.com/questions/240612/scan-a-ragged-list)

| language | rank | bytes | code |
|----------|------|-------|------|
| Myby | | 3b | <code>+&#92;..0</code> |
| [Japt](https://codegolf.stackexchange.com/questions/240612/scan-a-ragged-list/240693#240693) | | 25b | <code>W=Uv&#41;?&#91;W¶Ô?ßWÔ:V±W&#93;cßUV:U</code> |
| [Pip `-xp`](https://codegolf.stackexchange.com/questions/240612/scan-a-ragged-list/240629#240629) | | 27b | <code>b&#124;:0FdacPB:xNd?b+:d&#40;fdb&#41;c&#124;l</code> |
| [05AB1E](https://codegolf.stackexchange.com/questions/240612/scan-a-ragged-list/240666#240666) | | 29b | <code>0U&quot;εdiXćy+š¬ëXD¬šUy®.V}sU&quot;©.V</code> |
| [BQN](https://codegolf.stackexchange.com/questions/240612/scan-a-ragged-list/240620#240620) | | 34b | <code>{×≠𝕩?&#40;⊑𝕩&#41;𝕤{=𝕨?𝕩∾˜⋈𝔽𝕨;𝕨+0∾𝕩}𝕊1↓𝕩;𝕩} &#35; Function taking a nested list as 𝕩</code> <br/> <code> ×≠𝕩?                          ;𝕩  &#35; If the list is empty, return it</code> <br/> <code>                            1↓𝕩    &#35; Tail of 𝕩</code> <br/> <code>                           𝕊       &#35; Recursive call on the tail</code> <br/> <code>                                   &#35; If that fails, return the tail &#40;for the base case&#41;</code> <br/> <code>      ⊑𝕩                           &#35; The first element of the list</code> <br/> <code>        𝕤{      ...      }         &#35; Call the inner function with parameters</code> <br/> <code>                                   &#35;  &#45; 𝕩: result of recursive call</code> <br/> <code>                                   &#35;  &#45; 𝕨: first element</code> <br/> <code>                                   &#35;  &#45; 𝔽: a reference to the outer function</code> <br/> <code>          =𝕨?&lt;list&gt;;&lt;int&gt;          &#35;   Conditional, the rank of 𝕨 is 0 for ints and 1 for lists</code> <br/> <code>                 𝔽𝕨                &#35;   If 𝕨 is a list, call 𝔽 on that </code> <br/> <code>             𝕩∾˜⋈                  &#35;   And insert the result in the front of 𝕩</code> <br/> <code>                      0∾𝕩          &#35;   If 𝕨 is an integer, prepend 0 to the list 𝕩</code> <br/> <code>                    𝕨+             &#35;   And add 𝕨 to each integer in the resulting nested list</code> |
| [Charcoal](https://codegolf.stackexchange.com/questions/240612/scan-a-ragged-list/240632#240632) | | 51b | <code>⊞υ⊞Ｏθ⁰Ｆυ«≔⊟ιηＦＬι«≔§ικζ¿⁼ζ⁺ζ⟦⟧⊞υ⊞Ｏζη«≧⁺ζη§≔ικη»»»⭆¹θ</code> |

## [find-the-first-duplicated-element](https://codegolf.stackexchange.com/questions/136713/find-the-first-duplicated-element)

| language | rank | bytes | code |
|----------|------|-------|------|
| Myby | | 3b | <code>{&#35;}/</code> |
| [Husk](https://codegolf.stackexchange.com/questions/136713/find-the-first-duplicated-element/149578#149578) | | 4b | <code>←Ṡ&#45;u</code> |
| [Jelly](https://codegolf.stackexchange.com/questions/136713/find-the-first-duplicated-element/149484#149484) | | 4b | <code>ŒQi0</code> |
| [Vyxal](https://codegolf.stackexchange.com/questions/136713/find-the-first-duplicated-element/252735#252735) | | 4b | <code>UÞ⊍h</code> |
| [Brachylog](https://codegolf.stackexchange.com/questions/136713/find-the-first-duplicated-element/149546#149546) | | 5b | <code>a⊇=bh</code> |
| [Japt `-æ`](https://codegolf.stackexchange.com/questions/136713/find-the-first-duplicated-element/235629#235629) | | 5b | <code>VaWbU</code> |
| [Pyth](https://codegolf.stackexchange.com/questions/136713/find-the-first-duplicated-element/136745#136745) | | 5b | <code>h.&#45;Q{</code> |
| [Japt](https://codegolf.stackexchange.com/questions/136713/find-the-first-duplicated-element/136730#136730) | | 7b | <code>æ@bX ¦Y</code> |
| [MATL](https://codegolf.stackexchange.com/questions/136713/find-the-first-duplicated-element/136722#136722) | | 8b | <code>&amp;=Rsqf1&#41;</code> |
| [APL (Dyalog)](https://codegolf.stackexchange.com/questions/136713/find-the-first-duplicated-element/137497#137497) | | 11b | <code>⊢⊃⍨⍬⍴⍳∘≢&#126;⍳⍨</code> |
| [J](https://codegolf.stackexchange.com/questions/136713/find-the-first-duplicated-element/136992#136992) | | 12b | <code>,&amp;&#95;1{&#126;&#126;:i.0:</code> |
| [K4](https://codegolf.stackexchange.com/questions/136713/find-the-first-duplicated-element/149564#149564) | | 12b | <code>&#42;&lt;0W^&#42;:'1&#95;'=</code> |
| [Pip](https://codegolf.stackexchange.com/questions/136713/find-the-first-duplicated-element/235631#235631) | | 13b | <code>Tg@iNgHiUig@i</code> |
| [APL](https://codegolf.stackexchange.com/questions/136713/find-the-first-duplicated-element/137189#137189) | | 15b | <code>{⊃⍵&#91;&#40;⍳⍴⍵&#41;&#126;⍵⍳⍵&#93;}</code> |
| [05AB1E](https://codegolf.stackexchange.com/questions/136713/find-the-first-duplicated-element/137412#137412) | | 16b | <code>ε¹SsQƶ0K1è}W&lt;¹sè</code> |
| [APL (Dyalog Classic)](https://codegolf.stackexchange.com/questions/136713/find-the-first-duplicated-element/137174#137174) | | 18b | <code>w&#91;⊃&#40;⍳∘≢&#126;⍳⍨&#41;w←¯1,⎕&#93;</code> |
| [K (ngn/k)](https://codegolf.stackexchange.com/questions/136713/find-the-first-duplicated-element/252753#252753) | | 18b | <code>{x@&#40;{+/y=x}':x&#41;?1}</code> |
| [APL (NARS)](https://codegolf.stackexchange.com/questions/136713/find-the-first-duplicated-element/149477#149477) | | 104b | <code>f←{1≠⍴⍴⍵:¯1⋄v←&#40;⍵⍳⍵&#41;&#45;⍳⍴⍵⋄m←v⍳&#40;v&lt;0&#41;/v⋄m≡⍬:¯1⋄&#40;1⌷m&#41;⌷⍵}</code> |

## [number-to-string-in-aaaaa-way](https://codegolf.stackexchange.com/questions/252758/number-to-string-in-aaaaa-way)

| language | rank | bytes | code |
|----------|------|-------|------|
| [Nibbles](https://codegolf.stackexchange.com/questions/252758/number-to-string-in-aaaaa-way/252776#252776) | | 5b | <code>&amp;&quot;A&quot;5+'&#96;'</code> |
| Myby | | 8b | <code>5&P {" &#40;'A' + L&#41;</code> |
| [Vyxal](https://codegolf.stackexchange.com/questions/252758/number-to-string-in-aaaaa-way/252763#252763) | | 8b | <code>øA∑&#92;A5ø↳</code> |
| [Japt](https://codegolf.stackexchange.com/questions/252758/number-to-string-in-aaaaa-way/252760#252760) | | 9b | <code>c+48 ù'A5</code> |
| [Pyth](https://codegolf.stackexchange.com/questions/252758/number-to-string-in-aaaaa-way/252835#252835) | | 9b | <code>.&#91;&#92;A5m@Gt</code> |
| [05AB1E](https://codegolf.stackexchange.com/questions/252758/number-to-string-in-aaaaa-way/252771#252771) | | 11b | <code>₃+&gt;çΔ'Aš5.£</code> |
| [Fig](https://codegolf.stackexchange.com/questions/252758/number-to-string-in-aaaaa-way/252880#252880) | | 11.524b | <code>$t5$J&#42;/A5OC+96</code> |
| [MathGolf](https://codegolf.stackexchange.com/questions/252758/number-to-string-in-aaaaa-way/252775#252775) | | 12b | <code>&#40;h5,'A&#42;&#92;É▄&#92;§</code> |
| [APL (Dyalog Extended)](https://codegolf.stackexchange.com/questions/252758/number-to-string-in-aaaaa-way/252759#252759) | | 13b | <code>'A'@=¯5↑⎕⊇⌊⎕A</code> |
| [Charcoal](https://codegolf.stackexchange.com/questions/252758/number-to-string-in-aaaaa-way/252780#252780) | | 13b | <code>✂⁺×⁴A⭆Ｓ§β⊖ι±⁵</code> |
| [K (ngn/k)](https://codegolf.stackexchange.com/questions/252758/number-to-string-in-aaaaa-way/252844#252844) | | 13b | <code>&quot;A&quot;^&#45;5$&#96;c$96+</code> |
| [BQN](https://codegolf.stackexchange.com/questions/252758/number-to-string-in-aaaaa-way/252792#252792) | | 15b | <code>¯5↑&quot;AAAA&quot;∾+⟜'&#96;'</code> |
| [Jelly](https://codegolf.stackexchange.com/questions/252758/number-to-string-in-aaaaa-way/252854#252854) | | 15b | <code>DịØa;@”Ax5¤Uḣ5U</code> |
| [K](https://codegolf.stackexchange.com/questions/252758/number-to-string-in-aaaaa-way/254596#254596) | | 18b | <code>&quot;A&quot;^&#45;5$10h$96+10&#92;:</code> |
| [J](https://codegolf.stackexchange.com/questions/252758/number-to-string-in-aaaaa-way/252876#252876) | | 29b | <code>'Aabcdefghi'{&#126;&#93;,&#126;&#91;:0&quot;0&#91;:i.5&#45;&#35;</code> |
| [J-uby](https://codegolf.stackexchange.com/questions/252758/number-to-string-in-aaaaa-way/252798#252798) | | 34b | <code>:&#42;&amp;&#40;:+&amp;96&#124;:chr&#41;&#124;:join&#124;&#126;:rjust&amp;?A&amp;5</code> |

## [appending-string-lengths](https://codegolf.stackexchange.com/questions/103377/appending-string-lengths)

| language | rank | bytes | code |
|----------|------|-------|------|
| [05AB1E](https://codegolf.stackexchange.com/questions/103377/appending-string-lengths/255215#255215) | | 4b | <code>3Fg«</code> |
| Myby | | 5.5b | <code>&#35;+&#35;+@+&#35;+@++</code> |
| [Vyxal](https://codegolf.stackexchange.com/questions/103377/appending-string-lengths/252736#252736) | | 6b | <code>LJL+LJ</code> |
| [Pyth](https://codegolf.stackexchange.com/questions/103377/appending-string-lengths/103398#103398) | | 7b | <code>+Qfql+Q</code> |
| [Pip](https://codegolf.stackexchange.com/questions/103377/appending-string-lengths/252744#252744) | | 8b | <code>L3Ya.&#35;yy</code> |
| [Pyke](https://codegolf.stackexchange.com/questions/103377/appending-string-lengths/103382#103382) | | 8b | <code>.f+liq&#41;+</code> |
| [MATL](https://codegolf.stackexchange.com/questions/103377/appending-string-lengths/103379#103379) | | 11b | <code>&#96;G@Vhtn@&gt;&#93;&amp;</code> |
| [Jelly](https://codegolf.stackexchange.com/questions/103377/appending-string-lengths/104527#104527) | | 12b | <code>D;³L=</code> <br/> <code>LÇ1&#35;;@</code> |
| [Brachylog](https://codegolf.stackexchange.com/questions/103377/appending-string-lengths/103444#103444) | | 13b | <code>l&lt;L$@:?rc.lL,</code> |
| [K (ngn/k)](https://codegolf.stackexchange.com/questions/103377/appending-string-lengths/252756#252756) | | 31b | <code>{$&#91;9&gt;t:&#35;x;x,$1+t;x,$&#35;x,&#40;$1+t&#41;&#93;}</code> |

## [concatenating-n-with-n-1](https://codegolf.stackexchange.com/questions/167818/concatenating-n-with-n-1)

| language | rank | bytes | code |
|----------|------|-------|------|
| [Jelly](https://codegolf.stackexchange.com/questions/167818/concatenating-n-with-n-1/167946#167946) | | 3b | <code>ŻVƝ</code> |
| [MathGolf](https://codegolf.stackexchange.com/questions/167818/concatenating-n-with-n-1/172668#172668) | | 4b | <code>{└§p</code> |
| Myby | | 4b | <code>R +&.&#60;" ^</code> |
| [Vyxal](https://codegolf.stackexchange.com/questions/167818/concatenating-n-with-n-1/252871#252871) | | 4b | <code>ƛ‹p⌊</code> |
| [Japt](https://codegolf.stackexchange.com/questions/167818/concatenating-n-with-n-1/167920#167920) | | 5b | <code>õÈsiY</code> |
| [Japt `-m`](https://codegolf.stackexchange.com/questions/167818/concatenating-n-with-n-1/167840#167840) | | 5b | <code>ó2 ¬n</code> |
| [05AB1E](https://codegolf.stackexchange.com/questions/167818/concatenating-n-with-n-1/167856#167856) | | 6b | <code>&gt;GNJ,N</code> |
| [Brachylog](https://codegolf.stackexchange.com/questions/167818/concatenating-n-with-n-1/167859#167859) | | 6b | <code>⟦s₂ᶠcᵐ</code> |
| [Canvas](https://codegolf.stackexchange.com/questions/167818/concatenating-n-with-n-1/167821#167821) | | 6b | <code>ŗ²；＋┤］</code> |
| [Panacea](https://codegolf.stackexchange.com/questions/167818/concatenating-n-with-n-1/167919#167919) | | 6b | <code>re</code> <br/> <code>D&gt;j</code> |
| [Pyth](https://codegolf.stackexchange.com/questions/167818/concatenating-n-with-n-1/168040#168040) | | 6b | <code>ms+&#96;dh</code> |
| [Fig](https://codegolf.stackexchange.com/questions/167818/concatenating-n-with-n-1/252878#252878) | | 6.585b | <code>Mrx'&#95;Jx}</code> |
| [APL (Dyalog Classic)](https://codegolf.stackexchange.com/questions/167818/concatenating-n-with-n-1/167860#167860) | | 9b | <code>1,2,/⍕¨∘⍳</code> |
| [Husk](https://codegolf.stackexchange.com/questions/167818/concatenating-n-with-n-1/167869#167869) | | 9b | <code>mSöd+d←dḣ</code> |
| [MATL](https://codegolf.stackexchange.com/questions/167818/concatenating-n-with-n-1/167907#167907) | | 9b | <code>:"@qV@VhU</code> |
{% raw %}| [CJam](https://codegolf.stackexchange.com/questions/167818/concatenating-n-with-n-1/167849#167849) | | 11b | <code>{{&#95;&#41;s+si}%}</code> |{% endraw %}
| [Gol&#62;&#60;&#62;](https://codegolf.stackexchange.com/questions/167818/concatenating-n-with-n-1/173507#173507) | | 11b | <code>IFLL?nLPN&#124;;</code> |
| [cQuents](https://codegolf.stackexchange.com/questions/167818/concatenating-n-with-n-1/167824#167824) | | 11b | <code>=1::&#40;$&#45;1&#41;&#126;$</code> |
| [APL (Dyalog)](https://codegolf.stackexchange.com/questions/167818/concatenating-n-with-n-1/167825#167825) | | 12b | <code>&#40;⍎⍕,∘⍕1∘+&#41;¨⍳</code> |
| [K (oK)](https://codegolf.stackexchange.com/questions/167818/concatenating-n-with-n-1/168077#168077) | | 12b | <code>,/'$1,2':1+!</code> |
| [K (ngn/k)](https://codegolf.stackexchange.com/questions/167818/concatenating-n-with-n-1/167819#167819) | | 13b | <code>{.,/$x+!2}'!:</code> |
| [J](https://codegolf.stackexchange.com/questions/167818/concatenating-n-with-n-1/167959#167959) | | 14b | <code>&#40;,&amp;.":&gt;:&#41;"0@i.</code> |
| [J-uby](https://codegolf.stackexchange.com/questions/167818/concatenating-n-with-n-1/252873#252873) | | 25b | <code>:&#42;&#124;:&#42;&amp;&#40;&#45;&#91;I,:+&amp;1&#93;&#124;:join&#124;Z&#41;</code> |

## [repeat-values-in-array](https://codegolf.stackexchange.com/questions/252442/repeat-values-in-array)

| language | rank | bytes | code |
|----------|------|-------|------|
| Myby | | 0.5b | <code>&#35;</code> |
| [APL (Dyalog Unicode)](https://codegolf.stackexchange.com/questions/252442/repeat-values-in-array/252446#252446) | | 1b | <code>/</code> |
| [BQN](https://codegolf.stackexchange.com/questions/252442/repeat-values-in-array/252489#252489) | | 1b | <code>/</code> |
| [Husk](https://codegolf.stackexchange.com/questions/252442/repeat-values-in-array/252485#252485) | | 1b | <code>Ṙ</code> |
| [I](https://codegolf.stackexchange.com/questions/252442/repeat-values-in-array/252632#252632) | | 1b | <code>&#92;</code> |
| [J](https://codegolf.stackexchange.com/questions/252442/repeat-values-in-array/252466#252466) | | 1b | <code>&#35;</code> |
| [Jelly](https://codegolf.stackexchange.com/questions/252442/repeat-values-in-array/252443#252443) | | 1b | <code>x</code> |
| [05AB1E](https://codegolf.stackexchange.com/questions/252442/repeat-values-in-array/252468#252468) | | 2b | <code>ÅΓ</code> |
| [MATL](https://codegolf.stackexchange.com/questions/252442/repeat-values-in-array/252449#252449) | | 2b | <code>Y&quot;</code> |
| [Pyth](https://codegolf.stackexchange.com/questions/252442/repeat-values-in-array/252455#252455) | | 3b | <code>r9C</code> |
| [K (ngn/k)](https://codegolf.stackexchange.com/questions/252442/repeat-values-in-array/252469#252469) | | 4b | <code>,/&#35;'</code> |
| [Vyxal](https://codegolf.stackexchange.com/questions/252442/repeat-values-in-array/252445#252445) | | 4b | <code>¨£ẋf</code> |
| [Nibbles](https://codegolf.stackexchange.com/questions/252442/repeat-values-in-array/252559#252559) | | 4.5b | <code>+!$&#95;&#126;.,$&#95;</code> |
| [Q](https://codegolf.stackexchange.com/questions/252442/repeat-values-in-array/254775#254775) | | 5b | <code>where</code> |
| [Japt](https://codegolf.stackexchange.com/questions/252442/repeat-values-in-array/252453#252453) | | 6b | <code>cÈÇYgV</code> |
| [MathGolf](https://codegolf.stackexchange.com/questions/252442/repeat-values-in-array/252481#252481) | | 7b | <code>mÅaam&#42;─</code> |
| [Brachylog](https://codegolf.stackexchange.com/questions/252442/repeat-values-in-array/252562#252562) | | 9b | <code>z⟨kj₎t⟩ˢc</code> |
| [Charcoal](https://codegolf.stackexchange.com/questions/252442/repeat-values-in-array/252448#252448) | | 9b | <code>ＩΣＥθＥ§ηκι</code> |
| [Pip `-p`](https://codegolf.stackexchange.com/questions/252442/repeat-values-in-array/253564#253564) | | 16b | <code>{FA&#40;{aRLb}MZab&#41;}</code> |

## [are-all-the-items-the-same](https://codegolf.stackexchange.com/questions/224000/are-all-the-items-the-same)

| language | rank | bytes | code |
|----------|------|-------|------|
| [05AB1E (legacy)](https://codegolf.stackexchange.com/a/224001/31957) | | 1b | <code>Ë</code> |
| [Brachylog](https://codegolf.stackexchange.com/a/224001/31957) | | 1b | <code>=</code> |
| [Husk](https://codegolf.stackexchange.com/a/224001/31957) | | 1b | <code>E</code> |
| [Jelly](https://codegolf.stackexchange.com/a/224001/31957) | | 1b | <code>E</code> |
| Myby | | 1b | <code>e.</code> |
| [Vyxal](https://codegolf.stackexchange.com/a/224001/31957) | | 1b | <code>≈</code> |
| [Fig](https://codegolf.stackexchange.com/questions/224000/are-all-the-items-the-same/252543#252543) | | 1.646b | <code>LU</code> |
| [Arn](https://codegolf.stackexchange.com/questions/224000/are-all-the-items-the-same/224005#224005) | | 2b | <code>:@</code> |
| [Husk](https://codegolf.stackexchange.com/questions/224000/are-all-the-items-the-same/224348#224348) | | 2b | <code>hg</code> |
| [Jelly](https://codegolf.stackexchange.com/questions/224000/are-all-the-items-the-same/224011#224011) | | 2b | <code>IẸ</code> |
| [Pyth](https://codegolf.stackexchange.com/questions/224000/are-all-the-items-the-same/224012#224012) | | 2b | <code>l{</code> |
| [Japt](https://codegolf.stackexchange.com/questions/224000/are-all-the-items-the-same/224064#224064) | | 3b | <code>â l</code> |
| [K (ngn/k)](https://codegolf.stackexchange.com/questions/224000/are-all-the-items-the-same/252571#252571) | | 3b | <code>&#35;?:</code> |
| [Pip](https://codegolf.stackexchange.com/questions/224000/are-all-the-items-the-same/224022#224022) | | 3b | <code>$=g</code> |
| [GolfScript](https://codegolf.stackexchange.com/questions/224000/are-all-the-items-the-same/226305#226305) | | 4b | <code>&#126;.&amp;,</code> |
| [K (oK)](https://codegolf.stackexchange.com/questions/224000/are-all-the-items-the-same/224788#224788) | | 4b | <code>1=&#35;?</code> |
| [APL (Dyalog Unicode)](https://codegolf.stackexchange.com/questions/224000/are-all-the-items-the-same/224300#224300) | | 5b | <code>×/⊢=⊃</code> <br/> <code>×/ ⍝ product reduce</code> <br/> <code>  ⊢=⊃ ⍝ three train, each element equal to first element</code> |
| [Charcoal](https://codegolf.stackexchange.com/questions/224000/are-all-the-items-the-same/224068#224068) | | 5b | <code>⁼⌊θ⌈θ</code> |
| [J](https://codegolf.stackexchange.com/questions/224000/are-all-the-items-the-same/247055#247055) | | 6b | <code>1=&#35;&amp;&#126;.</code> |
| [J-uby](https://codegolf.stackexchange.com/questions/224000/are-all-the-items-the-same/252831#252831) | | 15b | <code>:uniq&#124;&#126;:&#91;&#93;&amp;1&#124;:!</code> |

## [modulus-summation](https://codegolf.stackexchange.com/questions/150563/modulus-summation)

| language | rank | bytes | code |
|----------|------|-------|------|
| [05AB1E](https://codegolf.stackexchange.com/questions/150563/modulus-summation/150584#150584) | | 3b | <code>L%O</code> |
| [Japt `-mx`](https://codegolf.stackexchange.com/questions/150563/modulus-summation/170935#170935) | | 3b | <code>N%U</code> |
| [Jelly](https://codegolf.stackexchange.com/questions/150563/modulus-summation/150564#150564) | | 3b | <code>%RS</code> |
| [Neim](https://codegolf.stackexchange.com/questions/150563/modulus-summation/150603#150603) | | 3b | <code>𝐈𝕄𝐬</code> |
| [Vyxal](https://codegolf.stackexchange.com/questions/150563/modulus-summation/230058#230058) | | 3b | <code>ɽ%∑</code> |
| Myby | | 3.5b | <code>+&#92; &#35; %" ^</code> |
| [MATL](https://codegolf.stackexchange.com/questions/150563/modulus-summation/150590#150590) | | 4b | <code>t:&#92;s</code> |
| [Ohm v2](https://codegolf.stackexchange.com/questions/150563/modulus-summation/150589#150589) | | 4b | <code>D@%Σ</code> |
| [APL (Dyalog)](https://codegolf.stackexchange.com/questions/150563/modulus-summation/150612#150612) | | 5b | <code>+/⍳&#124;⊢</code> |
| [Husk](https://codegolf.stackexchange.com/questions/150563/modulus-summation/150571#150571) | | 5b | <code>ΣṠM%ḣ</code> |
| [Japt](https://codegolf.stackexchange.com/questions/150563/modulus-summation/150572#150572) | | 5b | <code>Æ%XÃx</code> |
| [Pyth](https://codegolf.stackexchange.com/questions/150563/modulus-summation/150578#150578) | | 5b | <code>s%LQS</code> |
| [Pip](https://codegolf.stackexchange.com/questions/150563/modulus-summation/150598#150598) | | 7b | <code>$+a%&#92;,a</code> |
| [Gaia](https://codegolf.stackexchange.com/questions/150563/modulus-summation/150642#150642) | | 8b | <code>@:…&#41;¦%¦Σ</code> |
| [Brachylog](https://codegolf.stackexchange.com/questions/150563/modulus-summation/170973#170973) | | 9b | <code>⟨gz⟦₆⟩%ᵐ+</code> |
| [Charcoal](https://codegolf.stackexchange.com/questions/150563/modulus-summation/150586#150586) | | 9b | <code>ＩΣＥＮ﹪Ｉθ⊕ι</code> |
| [J](https://codegolf.stackexchange.com/questions/150563/modulus-summation/150593#150593) | | 9b | <code>&#45;&#126;1&#35;.i.&#124;&#93;</code> |
| [APL+WIN](https://codegolf.stackexchange.com/questions/150563/modulus-summation/150610#150610) | | 10b | <code>+/&#40;⍳n&#41;&#124;n←⎕</code> |
| [K (ngn/k)](https://codegolf.stackexchange.com/questions/150563/modulus-summation/252786#252786) | | 16b | <code>{+/{x!g}'1+!g&#45;1}</code> |
| [J-uby](https://codegolf.stackexchange.com/questions/150563/modulus-summation/252747#252747) | | 24b | <code>&#40;:&#45;&amp;&#40;:&amp; &amp;:%&#124;:+&amp;:sum&#41;&#41;%:+</code> |

## [implement-an-argwhere-function](https://codegolf.stackexchange.com/questions/241357/implement-an-argwhere-function)

| language | rank | bytes | code |
|----------|------|-------|------|
| [Fig](https://codegolf.stackexchange.com/questions/241357/implement-an-argwhere-function/252929#252929) | | 1.646b | <code>TM</code> |
| [Japt](https://codegolf.stackexchange.com/questions/241357/implement-an-argwhere-function/252928#252928) | | 2b | <code>ðV</code> |
| [Vyxal](https://codegolf.stackexchange.com/questions/241357/implement-an-argwhere-function/241359#241359) | | 2b | <code>MT</code> |
| [APL (Dyalog Unicode)](https://codegolf.stackexchange.com/questions/241357/implement-an-argwhere-function/241372#241372) | | 4b | <code>⍸⎕¨⎕</code> |
| [Husk](https://codegolf.stackexchange.com/questions/241357/implement-an-argwhere-function/241371#241371) | | 4b | <code>&#96;fNm</code> |
| Myby | | 4.5b | <code>R@+ &#35; F:"</code> |
| [05AB1E](https://codegolf.stackexchange.com/questions/241357/implement-an-argwhere-function/241362#241362) | | 6b | <code>δ.Vƶ0K</code> |
| [K (ngn/k)](https://codegolf.stackexchange.com/questions/241357/implement-an-argwhere-function/252828#252828) | | 6b | <code>{&amp;x'y}</code> |
| [Pip `-xp`](https://codegolf.stackexchange.com/questions/241357/implement-an-argwhere-function/241430#241430) | | 7b | <code>bMa@&#42;:1</code> |
| [J](https://codegolf.stackexchange.com/questions/241357/implement-an-argwhere-function/252935#252935) | | 11b | <code>1 :'I.u&quot;+y'</code> |
| [J-uby](https://codegolf.stackexchange.com/questions/241357/implement-an-argwhere-function/252681#252681) | | 31b | <code>&#45;&gt;a,f{:select+&#40;:&#91;&#93;&amp;a&#124;f&#41;^&#40;+a&#41;.&#42;}</code> |

## [remove-odd-indices-and-double-the-even-indices](https://codegolf.stackexchange.com/questions/241267/remove-odd-indices-and-double-the-even-indices)

| language | rank | bytes | code |
|----------|------|-------|------|
| [Vyxal](https://codegolf.stackexchange.com/questions/241267/remove-odd-indices-and-double-the-even-indices/241275#241275) | | 3b | <code>y2•</code> |
| [Fig](https://codegolf.stackexchange.com/questions/241267/remove-odd-indices-and-double-the-even-indices/253037#253037) | | 3.292b | <code>eh&#93;y</code> |
| [05AB1E](https://codegolf.stackexchange.com/questions/241267/remove-odd-indices-and-double-the-even-indices/241273#241273) | | 4b | <code>ιθºS</code> |
| [Jelly](https://codegolf.stackexchange.com/questions/241267/remove-odd-indices-and-double-the-even-indices/241268#241268) | | 4b | <code>Ḋm2Ḥ</code> |
| Myby | | 4b | <code>&#35; &#35; + &#35; 0 2</code> |
| [Husk](https://codegolf.stackexchange.com/questions/241267/remove-odd-indices-and-double-the-even-indices/241284#241284) | | 5b | <code>Ṙ2Ċ2t</code> |
| [Japt](https://codegolf.stackexchange.com/questions/241267/remove-odd-indices-and-double-the-even-indices/241304#241304) | | 5b | <code>Åë m²</code> |
| [MathGolf](https://codegolf.stackexchange.com/questions/241267/remove-odd-indices-and-double-the-even-indices/241277#241277) | | 5b | <code>{ï¥∞&#42;</code> |
| [Pyth](https://codegolf.stackexchange.com/questions/241267/remove-odd-indices-and-double-the-even-indices/253007#253007) | | 6b | <code>.i=%2t</code> |
| [Charcoal](https://codegolf.stackexchange.com/questions/241267/remove-odd-indices-and-double-the-even-indices/241291#241291) | | 8b | <code>⭆Ｓ×ι⊗﹪κ²</code> |
| [J](https://codegolf.stackexchange.com/questions/241267/remove-odd-indices-and-double-the-even-indices/241289#241289) | | 8b | <code>&#35;&#126;0 2$&#126;&#35;</code> |
| [ayr](https://codegolf.stackexchange.com/questions/241267/remove-odd-indices-and-double-the-even-indices/241283#241283) | | 8b | <code>&#93;&#35;0 2$&#96;&#35;</code> |
| [BQN](https://codegolf.stackexchange.com/questions/241267/remove-odd-indices-and-double-the-even-indices/241331#241331) | | 9b | <code>⊢/˜≠⥊0‿2˙</code> |
| [K (ngn/k)](https://codegolf.stackexchange.com/questions/241267/remove-odd-indices-and-double-the-even-indices/253018#253018) | | 10b | <code>&#40;2&#42;2!!&#35;:&#41;&#35;</code> |
| [APL (Dyalog Unicode)](https://codegolf.stackexchange.com/questions/241267/remove-odd-indices-and-double-the-even-indices/241294#241294) | | 12b | <code>{⍵/⍨0 2⍴⍨≢⍵}</code> |
| [APL+WIN](https://codegolf.stackexchange.com/questions/241267/remove-odd-indices-and-double-the-even-indices/241279#241279) | | 14b | <code>2/&#40;&#126;2&#124;⍳⍴m&#41;/m←⍞</code> |
| [J-uby](https://codegolf.stackexchange.com/questions/241267/remove-odd-indices-and-double-the-even-indices/252979#252979) | | 21b | <code>&#126;:gsub&amp;'&#92;1&#92;1'&amp;/.&#40;.&#41;?/</code> |

## [separate-a-list-into-even-indexed-and-odd-indexed-parts](https://codegolf.stackexchange.com/questions/64315/separate-a-list-into-even-indexed-and-odd-indexed-parts)

| language | rank | bytes | code |
|----------|------|-------|------|
| [Japt](https://codegolf.stackexchange.com/questions/64315/separate-a-list-into-even-indexed-and-odd-indexed-parts/180297#180297) | | 1b | <code>ó</code> |
| [Fig](https://codegolf.stackexchange.com/questions/64315/separate-a-list-into-even-indexed-and-odd-indexed-parts/253116#253116) | | 1.646b | <code>fy</code> |
| [05AB1E](https://codegolf.stackexchange.com/questions/64315/separate-a-list-into-even-indexed-and-odd-indexed-parts/220744#220744) | | 2b | <code>ι˜</code> |
| [Jelly](https://codegolf.stackexchange.com/questions/64315/separate-a-list-into-even-indexed-and-odd-indexed-parts/145396#145396) | | 3b | <code>ŒœF</code> |
| Myby | | 3.5b | <code>&#42;@^ /&2</code> |
| [Husk](https://codegolf.stackexchange.com/questions/64315/separate-a-list-into-even-indexed-and-odd-indexed-parts/216349#216349) | | 4b | <code>ΣTC2</code> |
| [Pyth](https://codegolf.stackexchange.com/questions/64315/separate-a-list-into-even-indexed-and-odd-indexed-parts/64324#64324) | | 5b | <code>o&#126;!ZQ</code> |
| [CJam](https://codegolf.stackexchange.com/questions/64315/separate-a-list-into-even-indexed-and-odd-indexed-parts/64317#64317) | | 7b | <code>{2/ze&#95;}</code> |
| [J](https://codegolf.stackexchange.com/questions/64315/separate-a-list-into-even-indexed-and-odd-indexed-parts/64331#64331) | | 8b | <code>/:0 1$&#126;&#35;</code> |
| [K](https://codegolf.stackexchange.com/questions/64315/separate-a-list-into-even-indexed-and-odd-indexed-parts/64402#64402) | | 10b | <code>{x@&lt;2!!&#35;x}</code> |
| [APL (Dyalog Unicode)](https://codegolf.stackexchange.com/questions/64315/separate-a-list-into-even-indexed-and-odd-indexed-parts/216780#216780) | | 11b | <code>{⍵&#91;⍒2&#124;⍳≢⍵&#93;}</code> |
| [K (ngn/k)](https://codegolf.stackexchange.com/questions/64315/separate-a-list-into-even-indexed-and-odd-indexed-parts/252991#252991) | | 21b | <code>{t,x^t:x@&amp;&#40;0=2!&#41;'!&#35;x}</code> |
| [𝔼𝕊𝕄𝕚𝕟](https://codegolf.stackexchange.com/questions/64315/separate-a-list-into-even-indexed-and-odd-indexed-parts/64366#64366) | | 22b | <code>Ѩťᶏש,Ѩą&#40;ï,2⸩</code> |

## [count-the-changes-in-an-array](https://codegolf.stackexchange.com/questions/146402/count-the-changes-in-an-array)

| language | rank | bytes | code |
|----------|------|-------|------|
| [Gaia](https://codegolf.stackexchange.com/questions/146402/count-the-changes-in-an-array/147132#147132) | | 2b | <code>ėl</code> |
| [Japt `-x`](https://codegolf.stackexchange.com/questions/146402/count-the-changes-in-an-array/252809#252809) | | 2b | <code>ä¦</code> |
| [MATL](https://codegolf.stackexchange.com/questions/146402/count-the-changes-in-an-array/146407#146407) | | 2b | <code>dz</code> |
| [05AB1E](https://codegolf.stackexchange.com/questions/146402/count-the-changes-in-an-array/146414#146414) | | 3b | <code>¥ĀO</code> |
| [Husk](https://codegolf.stackexchange.com/questions/146402/count-the-changes-in-an-array/146455#146455) | | 3b | <code>Ltg</code> |
| [Jelly](https://codegolf.stackexchange.com/questions/146402/count-the-changes-in-an-array/146403#146403) | | 3b | <code>ITL</code> |
| [Ohm v2](https://codegolf.stackexchange.com/questions/146402/count-the-changes-in-an-array/146430#146430) | | 3b | <code>ΔyΣ</code> |
| [Vyxal](https://codegolf.stackexchange.com/questions/146402/count-the-changes-in-an-array/253432#253432) | | 3b | <code>¯ꜝL</code> |
| [Pyke](https://codegolf.stackexchange.com/questions/146402/count-the-changes-in-an-array/146573#146573) | | 4b | <code>$0&#45;l</code> |
| [Pyth](https://codegolf.stackexchange.com/questions/146402/count-the-changes-in-an-array/146459#146459) | | 4b | <code>ltr8</code> |
| Myby | | 5b | <code>+&#92; 2 &#126;:&#92;&#92;. &#35;</code> |
| [Japt](https://codegolf.stackexchange.com/questions/146402/count-the-changes-in-an-array/146453#146453) | | 6b | <code>ä&#45; è¦0</code> |
| [APL (Dyalog)](https://codegolf.stackexchange.com/questions/146402/count-the-changes-in-an-array/146432#146432) | | 8b | <code>+/2≠/⊃,⊢</code> |
| [K (oK)](https://codegolf.stackexchange.com/questions/146402/count-the-changes-in-an-array/146410#146410) | | 8b | <code>+/1&#95;&#126;&#126;':</code> |
| [J](https://codegolf.stackexchange.com/questions/146402/count-the-changes-in-an-array/146457#146457) | | 10b | <code>&#91;:+/2&#126;:/&#92;&#93;</code> |
| [J-uby](https://codegolf.stackexchange.com/questions/146402/count-the-changes-in-an-array/252807#252807) | | 21b | <code>:chunk+I&#124;&#126;:drop&amp;1&#124;:+@</code> |

## [twisting-words](https://codegolf.stackexchange.com/questions/55051/twisting-words)

| language | rank | bytes | code |
|----------|------|-------|------|
| [Vyxal `jr`](https://codegolf.stackexchange.com/questions/55051/twisting-words/253150#253150) | | 5b | <code>ẇ↲⁽Ṙẇ</code> |
| [Jelly](https://codegolf.stackexchange.com/questions/55051/twisting-words/210474#210474) | | 8b | <code>sz⁶ZUÐeY</code> |
| [Japt `-R`](https://codegolf.stackexchange.com/questions/55051/twisting-words/210402#210402) | | 9b | <code>òV ËzEÑÃù</code> |
| Myby | | 10b | <code>'&#92;n' &#42; &#40;&#35;&#96;&#45;" &#40;P &#35;&#92;.&#126; &#45; H&#41;&#41;</code> |
| [J](https://codegolf.stackexchange.com/questions/55051/twisting-words/210403#210403) | | 13b | <code>&#93;&#96;&#124;.&quot;1@&#40;&#93;&#92;&#41;&#126;&#45;</code> |
| [Japt](https://codegolf.stackexchange.com/questions/55051/twisting-words/165021#165021) | | 14b | <code>óV y £Yv ?X:Xw</code> |
| [Pyth](https://codegolf.stackexchange.com/questions/55051/twisting-words/55055#55055) | | 15b | <code>VPc+z&#42;dQQ&#95;W&#126;!ZN</code> |
| [APL (Dyalog Unicode)](https://codegolf.stackexchange.com/questions/55051/twisting-words/164722#164722) | | 19b | <code>{↑⊢∘⌽&#92;↓↑⍵⊆⍨⌈⍺÷⍨⍳≢⍵}</code> |
| [CJam](https://codegolf.stackexchange.com/questions/55051/twisting-words/55056#55056) | | 19b | <code>q&#126;1$S&#42;+/W&lt;{&#40;N@Wf%}h</code> |
| [Brachylog](https://codegolf.stackexchange.com/questions/55051/twisting-words/210476#210476) | | 20b | <code>⟨{ġ&#124;,Ṣ↰}lᵛ⟩{i↔ⁱ⁾}ᶠ&#126;ṇ</code> |
{% raw %}| [05AB1E](https://codegolf.stackexchange.com/questions/55051/twisting-words/210457#210457) | | 22b | <code>ô0UεRDg²s&#45;úXÈiR}X&gt;U}}»</code> |{% endraw %}
| [Pip](https://codegolf.stackexchange.com/questions/55051/twisting-words/210419#210419) | | 34b | <code>Fla.sXb&#45;&#35;&#40;@RVa&lt;&gt;b&#41;&lt;&gt;b{Po?lRVlo!:o}</code> |
| [Stuck](https://codegolf.stackexchange.com/questions/55051/twisting-words/55065#55065) | | 38b | <code>tg;&#95;lu&#95;@%u;&#45;&#95;0G&lt;&#42;' &#42;+0GKE"&#93;;2%;Y&#95;Y?p":</code> |
| [Q](https://codegolf.stackexchange.com/questions/55051/twisting-words/55119#55119) | | 46b | <code>{&#45;1@neg&#91;y&#93;$@&#91;a;&#40;&amp;&#41;&#40;til&#40;&#35;&#41;a:y cut x&#41;mod 2;&#124;:&#93;;}</code> |
| [O](https://codegolf.stackexchange.com/questions/55051/twisting-words/55122#55122) | | 60b | <code>z&quot;&quot;/rlJ&#40;Q/{n:x;Q&#40;{+}dxe{&#96;}{}?p}drQJQ%&#45;{' }dJQ/e{r}{}?Q&#40;{o}dp</code> |

## [determine-the-color-of-a-chess-square](https://codegolf.stackexchange.com/questions/63772/determine-the-color-of-a-chess-square)

| language | rank | bytes | code |
|----------|------|-------|------|
| [Fig](https://codegolf.stackexchange.com/questions/63772/determine-the-color-of-a-chess-square/253073#253073) | | 9.054b | <code>iHD,&#91;jn&#40;&quot;OS</code> |
| [05AB1E](https://codegolf.stackexchange.com/questions/63772/determine-the-color-of-a-chess-square/205724#205724) | | 11b | <code>“–°‡Ž“&#35;IÇOè</code> |
| [Jelly](https://codegolf.stackexchange.com/questions/63772/determine-the-color-of-a-chess-square/148047#148047) | | 11b | <code>OḂEị“&#95;ß“ṗɠ»</code> |
| [Stax](https://codegolf.stackexchange.com/questions/63772/determine-the-color-of-a-chess-square/205726#205726) | | 11b | <code>ÄºÉ╨φr°mißâ</code> |
| [Vyxal](https://codegolf.stackexchange.com/questions/63772/determine-the-color-of-a-chess-square/243039#243039) | | 11b | <code>C∑₂&#96;⟇ǎ↔β&#96;½i</code> |
| [Keg](https://codegolf.stackexchange.com/questions/63772/determine-the-color-of-a-chess-square/205200#205200) | | 12b | <code>+2%&#91;‘15‘&#124;‘1⑻</code> |
| [05AB1E (legacy)](https://codegolf.stackexchange.com/questions/63772/determine-the-color-of-a-chess-square/177996#177996) | | 13b | <code>“–°‡Ž“&#35;I35öÈè</code> |
| [GS2](https://codegolf.stackexchange.com/questions/63772/determine-the-color-of-a-chess-square/63779#63779) | | 15b | <code>de♦dark•light♠5</code> |
| Myby | | 15.5b | <code>+&#92;@&#62; { 'dark' , 'light'</code> |
| [Japt](https://codegolf.stackexchange.com/questions/63772/determine-the-color-of-a-chess-square/165884#165884) | | 16b | <code>&#96;ä&&#35;149;&&#35;4;Krk&#96;qe g&#126;Uxc</code> |
| [K (oK)](https://codegolf.stackexchange.com/questions/63772/determine-the-color-of-a-chess-square/148016#148016) | | 16b | <code>&#96;dark&#96;light 2!+/</code> |
| [O](https://codegolf.stackexchange.com/questions/63772/determine-the-color-of-a-chess-square/63998#63998) | | 17b | <code>i&#35;2%"light'dark"?</code> |
| [CJam](https://codegolf.stackexchange.com/questions/63772/determine-the-color-of-a-chess-square/63773#63773) | | 18b | <code>r:&#45;&#41;"lightdark"5/=</code> |
| [Pyth](https://codegolf.stackexchange.com/questions/63772/determine-the-color-of-a-chess-square/63776#63776) | | 18b | <code>@c2"lightdark"iz35</code> |
| [Seriously](https://codegolf.stackexchange.com/questions/63772/determine-the-color-of-a-chess-square/63775#63775) | | 19b | <code>&quot;dark&quot;&quot;light&quot;2,O+%I</code> |
| [MATL](https://codegolf.stackexchange.com/questions/63772/determine-the-color-of-a-chess-square/67092#67092) | | 20b | <code>js2&#92;?'light'}'dark'&#93;</code> |
| [GolfScript](https://codegolf.stackexchange.com/questions/63772/determine-the-color-of-a-chess-square/63973#63973) | | 21b | <code>{^}&#42;&#126;1&amp;"lightdark"5/=</code> |
| [Gol&#62;&#60;&#62;](https://codegolf.stackexchange.com/questions/63772/determine-the-color-of-a-chess-square/63807#63807) | | 22b | <code>ii+2%Q"thgil"H&#124;"krad"H</code> |
| [TeaScript](https://codegolf.stackexchange.com/questions/63772/determine-the-color-of-a-chess-square/63789#63789) | | 23b | <code>®x,35&#41;%2?"dark":"light"</code> |
| [APL (Dyalog Unicode)](https://codegolf.stackexchange.com/questions/63772/determine-the-color-of-a-chess-square/177999#177999) | | 24b | <code>⊃'dark' 'light'⌽⍨+/⎕UCS⍞</code> |
| [K (ngn/k)](https://codegolf.stackexchange.com/questions/63772/determine-the-color-of-a-chess-square/253074#253074) | | 25b | <code>{$&#91;2!+/x;&quot;light&quot;;&quot;dark&quot;&#93;}</code> |
| [𝔼𝕊𝕄𝕚𝕟](https://codegolf.stackexchange.com/questions/63772/determine-the-color-of-a-chess-square/63805#63805) | | 34b | <code>ô&#40;שǀ&#40;ï,ḣ&#41;%2?&#96;dark&#96;:&#96;light”</code> |
| [J](https://codegolf.stackexchange.com/questions/63772/determine-the-color-of-a-chess-square/243032#243032) | | 37b | <code>&gt;@{&amp;&#40;'dark';'light'&#41;@{:@&#35;:@+/@&#40;a.&amp;i.&#41;</code> |

## [is-this-word-lexically-ordered](https://codegolf.stackexchange.com/questions/108675/is-this-word-lexically-ordered)

| language | rank | bytes | code |
|----------|------|-------|------|
| [Vyxal](https://codegolf.stackexchange.com/questions/108675/is-this-word-lexically-ordered/253240#253240) | | 2b | <code>ÞȮ</code> |
| [√ å ı ¥ ® Ï Ø ¿](https://codegolf.stackexchange.com/questions/108675/is-this-word-lexically-ordered/112720#112720) | | 3b | <code>Ißo</code> |
| [05AB1E](https://codegolf.stackexchange.com/questions/108675/is-this-word-lexically-ordered/108676#108676) | | 5b | <code>Â&#41;¤{å</code> |
| [Brachylog](https://codegolf.stackexchange.com/questions/108675/is-this-word-lexically-ordered/112473#112473) | | 5b | <code>:No₎?</code> |
| [Jelly](https://codegolf.stackexchange.com/questions/108675/is-this-word-lexically-ordered/108706#108706) | | 5b | <code>Ṣm0ẇ@</code> |
| [Pyke](https://codegolf.stackexchange.com/questions/108675/is-this-word-lexically-ordered/108703#108703) | | 5b | <code>SD&#95;&#93;{</code> |
| [Pyth](https://codegolf.stackexchange.com/questions/108675/is-this-word-lexically-ordered/108714#108714) | | 5b | <code>}SQ,&#95;</code> |
| Myby | | 5.5b | <code>%&./ e. &#35; , &#45;</code> |
| [MATL](https://codegolf.stackexchange.com/questions/108675/is-this-word-lexically-ordered/108704#108704) | | 7b | <code>dZSuz2&lt;</code> |
| [APL (Dyalog Unicode)](https://codegolf.stackexchange.com/questions/108675/is-this-word-lexically-ordered/157476#157476) | | 9b | <code>∨/⍬∘⍋⍷⍒,⍋</code> |
| [CJam](https://codegolf.stackexchange.com/questions/108675/is-this-word-lexically-ordered/108697#108697) | | 11b | <code>q&#95;$&#95;W%+&#92;&#35;&#41;g</code> |
| [APL (NARS)](https://codegolf.stackexchange.com/questions/108675/is-this-word-lexically-ordered/150956#150956) | | 19b | <code>{&#40;⊂⍵&#91;⍋⍵&#93;&#41;∊&#40;⊂⍵&#41;,⊂⌽⍵}</code> |
| [K (ngn/k)](https://codegolf.stackexchange.com/questions/108675/is-this-word-lexically-ordered/253260#253260) | | 19b | <code>{t:!&#35;x;&#40;t&#126;&lt;x&#41;&#124;t&#126;&gt;x}</code> |
| [Q](https://codegolf.stackexchange.com/questions/108675/is-this-word-lexically-ordered/151043#151043) | | 20b | <code>{x in&#40;asc;desc&#41;@&#92;:x}</code> |

## [triangle-a-number](https://codegolf.stackexchange.com/questions/137632/triangle-a-number)

| language | rank | bytes | code |
|----------|------|-------|------|
| [Fig](https://codegolf.stackexchange.com/questions/137632/triangle-a-number/253164#253164) | | 1.646b | <code>Sk</code> |
| [Husk](https://codegolf.stackexchange.com/questions/137632/triangle-a-number/137655#137655) | | 2b | <code>Σ∫</code> |
| [Vyxal](https://codegolf.stackexchange.com/questions/137632/triangle-a-number/253140#253140) | | 2b | <code>¦∑</code> |
| [05AB1E](https://codegolf.stackexchange.com/questions/137632/triangle-a-number/137638#137638) | | 3b | <code>ηSO</code> |
| [Gaia](https://codegolf.stackexchange.com/questions/137632/triangle-a-number/137641#137641) | | 3b | <code>…&#95;Σ</code> |
| [Jelly](https://codegolf.stackexchange.com/questions/137632/triangle-a-number/137650#137650) | | 3b | <code>+&#92;S</code> |
| [MATL](https://codegolf.stackexchange.com/questions/137632/triangle-a-number/137646#137646) | | 3b | <code>Yss</code> |
| Myby | | 3b | <code>+&#92; +&#92;&#92;.</code> |
| [Neim](https://codegolf.stackexchange.com/questions/137632/triangle-a-number/137722#137722) | | 3b | <code>𝐗𝐂𝐬</code> |
| [APL](https://codegolf.stackexchange.com/questions/137632/triangle-a-number/137678#137678) | | 4b | <code>+/+&#92;</code> |
| [Japt](https://codegolf.stackexchange.com/questions/137632/triangle-a-number/137633#137633) | | 4b | <code>å+ x</code> |
| [Pyth](https://codegolf.stackexchange.com/questions/137632/triangle-a-number/137647#137647) | | 4b | <code>ss.&#95;</code> |
| [J](https://codegolf.stackexchange.com/questions/137632/triangle-a-number/137668#137668) | | 6b | <code>1&#35;.+/&#92;</code> |
| [Pyt](https://codegolf.stackexchange.com/questions/137632/triangle-a-number/151755#151755) | | 6b | <code>ąĐŁř↔·</code> |
| [Gol&#62;&#60;&#62;](https://codegolf.stackexchange.com/questions/137632/triangle-a-number/161484#161484) | | 8b | <code>IEh@+:@+</code> |
| [K (ngn/k)](https://codegolf.stackexchange.com/questions/137632/triangle-a-number/253184#253184) | | 8b | <code>+/+&#92;.'$:</code> |

## [bl-lu-ur-rr-ry-yv-vi-is-si-io-on-blur-the-text](https://codegolf.stackexchange.com/questions/203893/bl-lu-ur-rr-ry-yv-vi-is-si-io-on-blur-the-text)

| language | rank | bytes | code |
|----------|------|-------|------|
| [Husk](https://codegolf.stackexchange.com/questions/203893/bl-lu-ur-rr-ry-yv-vi-is-si-io-on-blur-the-text/203917#203917) | | 5b | <code>wX2f□</code> |
| [Japt v2.0a0 `-S`](https://codegolf.stackexchange.com/questions/203893/bl-lu-ur-rr-ry-yv-vi-is-si-io-on-blur-the-text/203925#203925) | | 6b | <code>r&#92;W ä+</code> |
| [Jelly](https://codegolf.stackexchange.com/questions/203893/bl-lu-ur-rr-ry-yv-vi-is-si-io-on-blur-the-text/203911#203911) | | 6b | <code>fØB;ƝK</code> |
| Myby | | 6b | <code>' ' &#42; 2 &#35;&#92;. alnumk</code> |
| [Stax](https://codegolf.stackexchange.com/questions/203893/bl-lu-ur-rr-ry-yv-vi-is-si-io-on-blur-the-text/203957#203957) | | 6b | <code>£Q·H°·</code> |
| [Vyxal](https://codegolf.stackexchange.com/questions/203893/bl-lu-ur-rr-ry-yv-vi-is-si-io-on-blur-the-text/229021#229021) | | 6b | <code>kr↔2lṄ</code> |
| [05AB1E](https://codegolf.stackexchange.com/questions/203893/bl-lu-ur-rr-ry-yv-vi-is-si-io-on-blur-the-text/203906#203906) | | 8b | <code>žKÃüJðý?</code> |
| [Pyth](https://codegolf.stackexchange.com/questions/203893/bl-lu-ur-rr-ry-yv-vi-is-si-io-on-blur-the-text/203896#203896) | | 14b | <code>jd.::Q"&#92;W&#124;&#95;"k2</code> |
| [MATL](https://codegolf.stackexchange.com/questions/203893/bl-lu-ur-rr-ry-yv-vi-is-si-io-on-blur-the-text/203894#203894) | | 16b | <code>t8Y2m&#41;2YC!Z{0&amp;Zc</code> |
| [QuadR](https://codegolf.stackexchange.com/questions/203893/bl-lu-ur-rr-ry-yv-vi-is-si-io-on-blur-the-text/203955#203955) | | 18b | <code>1↓∊' ',¨2,/⍵</code> <br/> <code>&#92;W&#124;&#95;</code> |
| [K (ngn/k)](https://codegolf.stackexchange.com/questions/203893/bl-lu-ur-rr-ry-yv-vi-is-si-io-on-blur-the-text/203899#203899) | | 21b | <code>&quot; &quot;/2':&#40;2!&quot;/9@Z&#96;z&quot;'&#41;&#95;</code> |
| [APL (NARS)](https://codegolf.stackexchange.com/questions/203893/bl-lu-ur-rr-ry-yv-vi-is-si-io-on-blur-the-text/220091#220091) | | 24b | <code>{¯1↓1↓⍕2,/⍵/⍨⍵∊A←⎕a,⎕A,⎕D}</code> |
| [Charcoal](https://codegolf.stackexchange.com/questions/203893/bl-lu-ur-rr-ry-yv-vi-is-si-io-on-blur-the-text/203902#203902) | | 26b | <code>≔ΦＳ№⁺α⁺β⭆χλιθ⪫Ｅ⊖Ｌθ✂θι⁺²ι¹</code> |
| [APL (Dyalog Unicode)](https://codegolf.stackexchange.com/questions/203893/bl-lu-ur-rr-ry-yv-vi-is-si-io-on-blur-the-text/203933#203933) | | 32b | <code>{¯2↓2↓⊃,/{⍵' '⍵}¨⍵∩⎕A,819⌶⎕A,⎕D}</code> |
| [J](https://codegolf.stackexchange.com/questions/203893/bl-lu-ur-rr-ry-yv-vi-is-si-io-on-blur-the-text/204364#204364) | | 32b | <code>&#91;:}:&#91;:,/2,&amp;' '&#92;&#93;&#45;.&#45;.&amp;AlphaNum&#95;j&#95;</code> |
| [Q](https://codegolf.stackexchange.com/questions/203893/bl-lu-ur-rr-ry-yv-vi-is-si-io-on-blur-the-text/203929#203929) | | 38b | <code>{" "sv &#45;2&#95;2&#35;'next&#92;&#91;x inter .Q.an &#95;52&#93;}</code> |

## [new-password-idea-word-walker](https://codegolf.stackexchange.com/questions/165793/new-password-idea-word-walker)

| language | rank | bytes | code |
|----------|------|-------|------|
| [Stax](https://codegolf.stackexchange.com/questions/165793/new-password-idea-word-walker/165924#165924) | | 9b | <code>éñ&#126;╗D¡┤Gq</code> |
| [05AB1E](https://codegolf.stackexchange.com/questions/165793/new-password-idea-word-walker/165806#165806) | | 11b | <code>&#35;vyN©Fû}®è?</code> |
| [Husk](https://codegolf.stackexchange.com/questions/165793/new-password-idea-word-walker/213795#213795) | | 11b | <code>SzS!ö!…¢ŀŀw</code> |
| [Japt](https://codegolf.stackexchange.com/questions/165793/new-password-idea-word-walker/165794#165794) | | 11b | <code>¸Ëê ÅªD gEÉ</code> |
| [Vyxal](https://codegolf.stackexchange.com/questions/165793/new-password-idea-word-walker/253374#253374) | | 11b | <code>⌈₅&#40;ʁ&#41;:ẏ¨£i∑</code> |
| [Jelly](https://codegolf.stackexchange.com/questions/165793/new-password-idea-word-walker/165805#165805) | | 12b | <code>ḲJị"ŒBṖȯ$€$Ɗ</code> |
| Myby | | 12b | <code>&#62; {&#92;" ! +&#45;@innerH" /&' ' @.</code> |
| [Pyth](https://codegolf.stackexchange.com/questions/165793/new-password-idea-word-walker/165844#165844) | | 12b | <code>s.e@+b&#95;Ptbkc</code> |
| [Charcoal](https://codegolf.stackexchange.com/questions/165793/new-password-idea-word-walker/165803#165803) | | 16b | <code>⭆⪪Ｓ §⁺ι✂ι±²¦⁰±¹κ</code> |
| [CJam](https://codegolf.stackexchange.com/questions/165793/new-password-idea-word-walker/214311#214311) | | 22b | <code>qS/{&#95;&#41;;1&gt;W%+T&#95;&#41;:T@&#42;=}%</code> |
| [K](https://codegolf.stackexchange.com/questions/165793/new-password-idea-word-walker/166018#166018) | | 28b | <code>{x{&#42;&#124;y&#35;x,1&#95;&#124;1&#95;x}'1+!&#35;x}@" "&#92;</code> |
| [J](https://codegolf.stackexchange.com/questions/165793/new-password-idea-word-walker/166095#166095) | | 43b | <code>&#91;:&#40;&gt;{&#126;"&#95;1&#35;@&gt;&#124;i.@&#35;&#41;&#91;:&#40;,}.@}:&#41;&amp;.&gt;&#91;:&lt;;.&#95;1' '&amp;,</code> |

## [non-unique-duplicate-elements](https://codegolf.stackexchange.com/questions/60610/non-unique-duplicate-elements)

| language | rank | bytes | code |
|----------|------|-------|------|
| [Husk](https://codegolf.stackexchange.com/questions/60610/non-unique-duplicate-elements/216089#216089) | | 4b | <code>u&#45;u¹</code> |
| [Jelly](https://codegolf.stackexchange.com/questions/60610/non-unique-duplicate-elements/119591#119591) | | 4b | <code>œ&#45;QQ</code> |
| [Vyxal](https://codegolf.stackexchange.com/questions/60610/non-unique-duplicate-elements/253348#253348) | | 4b | <code>UÞ⊍U</code> |
| [05AB1E](https://codegolf.stackexchange.com/questions/60610/non-unique-duplicate-elements/166409#166409) | | 5b | <code>ʒ¢≠}Ù</code> |
| [K5](https://codegolf.stackexchange.com/questions/60610/non-unique-duplicate-elements/60648#60648) | | 5b | <code>?d^?d</code> |
| Myby | | 6.5b | <code>//&#35;&#40;&#60;:+&#92;&#41;"@=</code> |
| [Japt](https://codegolf.stackexchange.com/questions/60610/non-unique-duplicate-elements/166320#166320) | | 7b | <code>â £kX â</code> |
| [K (oK)](https://codegolf.stackexchange.com/questions/60610/non-unique-duplicate-elements/171379#171379) | | 7b | <code>&amp;1&lt;&#35;:'=</code> |
| [Pyth](https://codegolf.stackexchange.com/questions/60610/non-unique-duplicate-elements/60649#60649) | | 7b | <code>S{.&#45;Q{Q</code> |
| [APL (Dyalog Unicode)](https://codegolf.stackexchange.com/questions/60610/non-unique-duplicate-elements/60637#60637) | | 9b | <code>∊&#40;⊂1↓⊣¨&#41;⌸</code> |
| [CJam](https://codegolf.stackexchange.com/questions/60610/non-unique-duplicate-elements/60612#60612) | | 10b | <code>D{De=&#40;},&#95;&amp;</code> |
| [K (not K5)](https://codegolf.stackexchange.com/questions/60610/non-unique-duplicate-elements/60934#60934) | | 10b | <code>x@&amp;1&lt;&#35;:'=x</code> |
| [J](https://codegolf.stackexchange.com/questions/60610/non-unique-duplicate-elements/60764#60764) | | 13b | <code>&#126;.d&#35;&#126;1&lt;+/=/&#126;d</code> |

## [alphabet-checksum](https://codegolf.stackexchange.com/questions/253568/alphabet-checksum)

| language | rank | bytes | code |
|----------|------|-------|------|
| [05AB1E](https://codegolf.stackexchange.com/questions/253568/alphabet-checksum/253581#253581) | | 6b | <code>ADIkOè</code> |
| [Nibbles](https://codegolf.stackexchange.com/questions/253568/alphabet-checksum/253613#253613) | | 7b | <code>+%+.$&#45;$;'a'26</code> |
| [Charcoal](https://codegolf.stackexchange.com/questions/253568/alphabet-checksum/253601#253601) | | 8b | <code>§βΣＥＳ⌕βι</code> |
| [Japt](https://codegolf.stackexchange.com/questions/253568/alphabet-checksum/253584#253584) | | 8b | <code>;x!aC gC</code> |
| [Jelly](https://codegolf.stackexchange.com/questions/253568/alphabet-checksum/253586#253586) | | 8b | <code>O+7S‘ịØa</code> |
| [Fig](https://codegolf.stackexchange.com/questions/253568/alphabet-checksum/253582#253582) | | 8.231b | <code>ica%26S+7C</code> |
| Myby | | 9b | <code>+&#92; L&^" / @. { L</code> |
| [Vyxal](https://codegolf.stackexchange.com/questions/253568/alphabet-checksum/253573#253573) | | 9b | <code>øA‹∑₄%›øA</code> |
| [MATL](https://codegolf.stackexchange.com/questions/253568/alphabet-checksum/253577#253577) | | 10b | <code>2Y2j97&#45;sQ&#41;</code> |
| [Brachylog](https://codegolf.stackexchange.com/questions/253568/alphabet-checksum/253616#253616) | | 14b | <code>ạ+₇ᵐ+%₂₆+₉₇g&#126;ạ</code> |
| [K (ngn/k)](https://codegolf.stackexchange.com/questions/253568/alphabet-checksum/254173#254173) | | 14b | <code>&#96;c$97+26!+/97!</code> |
| [BQN](https://codegolf.stackexchange.com/questions/253568/alphabet-checksum/253619#253619) | | 15b | <code>'a'+26&#124;·+´&#45;⟜'a'</code> |
| [Gaia](https://codegolf.stackexchange.com/questions/253568/alphabet-checksum/254004#254004) | | 15b | <code>⟨c97%⟩¦Σ26%97+c</code> |
| [Pip](https://codegolf.stackexchange.com/questions/253568/alphabet-checksum/253713#253713) | | 16b | <code>zPK$+&#40;A&#42;a&#45;97&#41;%26</code> |
| [J](https://codegolf.stackexchange.com/questions/253568/alphabet-checksum/253759#253759) | | 19b | <code>&#40;26&#124;+/&#41;&amp;.&#40;&#95;97+3&amp;u:&#41;</code> |

## [8086-segment-address](https://codegolf.stackexchange.com/questions/255850/8086-segment-address)

| language | rank | bytes | code |
|----------|------|-------|------|
| [05AB1E](https://codegolf.stackexchange.com/questions/255850/8086-segment-address-to-linear/256099#256099) | | 7b | <code>':¡H16β</code> |
| [Nibbles](https://codegolf.stackexchange.com/questions/255850/8086-segment-address-to-linear/255901#255901) | | 7b | <code>&#96;@4.&#96;=$&#92;$Nhex</code> |
| [Vyxal](https://codegolf.stackexchange.com/questions/255850/8086-segment-address-to-linear/255873#255873) | | 7b | <code>&#92;:/H16β</code> |
| Myby | | 8b | <code>16 &#35;. 16 &#35;. /&':'</code> |
| [Jelly](https://codegolf.stackexchange.com/questions/255850/8086-segment-address-to-linear/255853#255853) | | 11b | <code>ØHiⱮ’ṣ&#45;ḅ⁴ḅ⁴</code> |
| [Japt `-x`](https://codegolf.stackexchange.com/questions/255850/8086-segment-address-to-linear/255866#255866) | | 13b | <code>q': ÔËnG &#42;GpE</code> |
| [Charcoal](https://codegolf.stackexchange.com/questions/255850/8086-segment-address-to-linear/255871#255871) | | 14b | <code>⍘↨Ｅ⪪Ｓ:⍘ι⊗⁸⊗⁸⊗⁸</code> |
| [Pip](https://codegolf.stackexchange.com/questions/255850/8086-segment-address-to-linear/255878#255878) | | 23b | <code>Uo{aFB16&#42;16E Do}MSa^&quot;:&quot;</code> |

## [simple-csv-dsv-importer](https://codegolf.stackexchange.com/questions/111707/simple-csv-dsv-importer)

| language | rank | bytes | code |
|----------|------|-------|------|
| Myby | | 1b | <code>/"</code> |
| [Jelly](https://codegolf.stackexchange.com/questions/111707/simple-csv-dsv-importer/111709#111709) | | 2b | <code>ṣ€</code> |
| [Japt](https://codegolf.stackexchange.com/questions/111707/simple-csv-dsv-importer/111717#111717) | | 3b | <code>mqV</code> |
| [APL (Dyalog)](https://codegolf.stackexchange.com/questions/111707/simple-csv-dsv-importer/120792#120792) | | 4b | <code>⎕ML←3</code> |
| [MATL](https://codegolf.stackexchange.com/questions/111707/simple-csv-dsv-importer/111724#111724) | | 4b | <code>H&amp;XX</code> |
| [05AB1E](https://codegolf.stackexchange.com/questions/111707/simple-csv-dsv-importer/111708#111708) | | 5b | <code>vy²¡ˆ</code> |
| [CJam](https://codegolf.stackexchange.com/questions/111707/simple-csv-dsv-importer/111781#111781) | | 5b | <code>l&#126;l./</code> |

## [replace-0s-in-a-string-with-their-consecutive-counts](https://codegolf.stackexchange.com/questions/255822/replace-0s-in-a-string-with-their-consecutive-counts)

| language | rank | bytes | code |
|----------|------|-------|------|
| [QuadR](https://codegolf.stackexchange.com/questions/255822/replace-0s-in-a-string-with-their-consecutive-counts/255827#255827) | | 5b | <code>0+</code> <br/> <code>⍵L</code> |
| [Nibbles](https://codegolf.stackexchange.com/questions/255822/replace-0s-in-a-string-with-their-consecutive-counts/255893#255893) | | 6b | <code>+.&#96;=$$?&#96;r$@,</code> |
| [05AB1E](https://codegolf.stackexchange.com/questions/255822/replace-0s-in-a-string-with-their-consecutive-counts/255836#255836) | | 7b | <code>0ÃηRāR:</code> |
| [Japt](https://codegolf.stackexchange.com/questions/255822/replace-0s-in-a-string-with-their-consecutive-counts/255829#255829) | | 7b | <code>r+iT Èl</code> |
| [Pip](https://codegolf.stackexchange.com/questions/255822/replace-0s-in-a-string-with-their-consecutive-counts/255826#255826) | | 7b | <code>aR+X0&#35;&#95;</code> |
| [Vyxal `s`](https://codegolf.stackexchange.com/questions/255822/replace-0s-in-a-string-with-their-consecutive-counts/255823#255823) | | 7b | <code>ĠṠƛ0cßL</code> |
| [Husk](https://codegolf.stackexchange.com/questions/255822/replace-0s-in-a-string-with-their-consecutive-counts/255862#255862) | | 8b | <code>ṁ?IosLig</code> |
| [Jelly](https://codegolf.stackexchange.com/questions/255822/replace-0s-in-a-string-with-their-consecutive-counts/255854#255854) | | 8b | <code>Œgċ”0ȯƊ€</code> |
| Myby | | 9b | <code>&#62; &#40;+ &#35; '0'&e. ?" &#35;C&#41;</code> |
| [Brachylog](https://codegolf.stackexchange.com/questions/255822/replace-0s-in-a-string-with-their-consecutive-counts/255934#255934) | | 11b | <code>ḅ{ị0&amp;lṫ&#124;}ᵐc</code> |
| [Pyth](https://codegolf.stackexchange.com/questions/255822/replace-0s-in-a-string-with-their-consecutive-counts/255937#255937) | | 11b | <code>sm&#96;&#124;vedhdr8</code> |
| [J](https://codegolf.stackexchange.com/questions/255822/replace-0s-in-a-string-with-their-consecutive-counts/255887#255887) | | 16b | <code>'0+'&quot;:@&#35;rxapply&#93;</code> |
| [Charcoal](https://codegolf.stackexchange.com/questions/255822/replace-0s-in-a-string-with-their-consecutive-counts/255841#255841) | | 20b | <code>⭆⪪⁻⪫⪪ＳＩ⁰&#95;0&#95;×&#95;²&#95;∨№ι0ι</code> |

## [maximum-average-ord](https://codegolf.stackexchange.com/questions/254224/maximum-average-ord)

| language | rank | bytes | code |
|----------|------|-------|------|
| [Vyxal `G`](https://codegolf.stackexchange.com/questions/254224/maximum-average-ord/254249#254249) | | 3b | <code>Cvṁ</code> |
| [05AB1E](https://codegolf.stackexchange.com/questions/254224/maximum-average-ord/254231#254231) | | 4b | <code>ÇÅAà</code> |
| [Jelly](https://codegolf.stackexchange.com/questions/254224/maximum-average-ord/254251#254251) | | 4b | <code>OÆmṀ</code> |
| [MathGolf](https://codegolf.stackexchange.com/questions/254224/maximum-average-ord/254294#254294) | | 4b | <code>$m▓╙</code> |
| [Fig](https://codegolf.stackexchange.com/questions/254224/maximum-average-ord/254250#254250) | | 4.939b | <code>&#93;KemMC</code> |
| [Husk](https://codegolf.stackexchange.com/questions/254224/maximum-average-ord/254227#254227) | | 6b | <code>▲moAmc</code> |
| Myby | | 6.5b | <code>&#62;. &#40;+&#92;@&#62; / +&#41;"</code> |
| [Pyth](https://codegolf.stackexchange.com/questions/254224/maximum-average-ord/254247#254247) | | 7b | <code>eSm.OCM</code> |
| [Nibbles](https://codegolf.stackexchange.com/questions/254224/maximum-average-ord/254234#254234) | | 8b | <code>&#96;/.$/&#42;+.$o$10,$&#93;</code> |
| [Japt `-h`](https://codegolf.stackexchange.com/questions/254224/maximum-average-ord/254244#254244) | | 9b | <code>®xc /ZlÃñ</code> |
| [K (ngn/k)](https://codegolf.stackexchange.com/questions/254224/maximum-average-ord/254233#254233) | | 11b | <code>&#124;/{+/x%&#35;x}'</code> |
| [BQN](https://codegolf.stackexchange.com/questions/254224/maximum-average-ord/254373#254373) | | 12b | <code>⌈´+´∘&#45;⟜@¨÷≠¨</code> |
| [Pip](https://codegolf.stackexchange.com/questions/254224/maximum-average-ord/254258#254258) | | 12b | <code>M:$+A&#42;&#95;/&#35;&#95;Mg</code> |
| [APL (Dyalog Unicode)](https://codegolf.stackexchange.com/questions/254224/maximum-average-ord/254368#254368) | | 13b | <code>⌈/+⌿∘⎕UCS¨÷≢¨</code> |
| [Charcoal](https://codegolf.stackexchange.com/questions/254224/maximum-average-ord/254228#254228) | | 15b | <code>ＷＳ⊞υ∕ΣＥι℅κＬιＩ⌈υ</code> |
| [J](https://codegolf.stackexchange.com/questions/254224/maximum-average-ord/254365#254365) | | 18b | <code>&#91;:&gt;./&#40;1&#35;.3&amp;u:%&#35;&#41;&amp;&gt;</code> |
| [J-uby](https://codegolf.stackexchange.com/questions/254224/maximum-average-ord/254582#254582) | | 30b | <code>:&#42;&amp;:/%&#91;:bytes&#124;:sum,:+@&#124;Q&#93;&#124;:max</code> |
| [Sequences](https://codegolf.stackexchange.com/questions/254224/maximum-average-ord/254226#254226) | | 96b | <code>&#91;$v$aH&#93;gM</code> |

## [generate-parity-bits](https://codegolf.stackexchange.com/questions/252491/generate-parity-bits)

| language | rank | bytes | code |
|----------|------|-------|------|
| [Nibbles](https://codegolf.stackexchange.com/questions/252491/generate-parity-bits/252528#252528) | | 7.5b | <code>:$&#92;&lt;@&#92;&#96;&#96;@+^2@+</code> |
| [Jelly](https://codegolf.stackexchange.com/questions/252491/generate-parity-bits/252526#252526) | | 10b | <code>SBŻ⁹¡ṫC}⁸;</code> |
| [MATL](https://codegolf.stackexchange.com/questions/252491/generate-parity-bits/252520#252520) | | 10b | <code>tsiW&#92;2M&amp;Bh</code> |
| [Vyxal](https://codegolf.stackexchange.com/questions/252491/generate-parity-bits/252492#252492) | | 10b | <code>⌊∑$E%Π⁰↳›J</code> |
| Myby | | 10.5b | <code>&#91; + &#93; P 2 &#35;: +&#92; % 2&^ O</code> |
| [05AB1E](https://codegolf.stackexchange.com/questions/252491/generate-parity-bits/252505#252505) | | 12b | <code>DSOIo%bI°+¦«</code> |
| [Japt `-P`](https://codegolf.stackexchange.com/questions/252491/generate-parity-bits/252527#252527) | | 13b | <code>pUx u2pV&#41;¤ù0V</code> |
| [K (ngn/k)](https://codegolf.stackexchange.com/questions/252491/generate-parity-bits/252620#252620) | | 13b | <code>{x,&#40;y&#35;2&#41;&#92;+/x}</code> |
| [Charcoal](https://codegolf.stackexchange.com/questions/252491/generate-parity-bits/252515#252515) | | 14b | <code>Ｎθη✂⍘⁺Ｘ²θΣη²±θ</code> |
| [Pyth](https://codegolf.stackexchange.com/questions/252491/generate-parity-bits/252530#252530) | | 18b | <code>pz.&#91;&#92;0KE.B%/z&#92;1^2K</code> |
| [J](https://codegolf.stackexchange.com/questions/252491/generate-parity-bits/252542#252542) | | 19b | <code>&#91;,&#40;&#93;&#35;2:&#41;&#35;:+/@&#91;&#124;&#126;2^&#93;</code> |
| [Pip](https://codegolf.stackexchange.com/questions/252491/generate-parity-bits/253611#253611) | | 28b | <code>a.&#40;J&#40;0&#42;,bALTB&#40;$+a&#41;%2Eb&#41;&#41;@&gt;&#45;b</code> |

## [biplex-an-important-useless-operator](https://codegolf.stackexchange.com/questions/62713/biplex-an-important-useless-operator)

| language | rank | bytes | code |
|----------|------|-------|------|
| Myby | | 14.5b | <code>&#35;. &#40;&#35; e.": &#62;. , 1 &#62;. &#60;.&#41; +"&#92; &#35;: @.</code> |
| [J](https://codegolf.stackexchange.com/questions/62713/biplex-an-important-useless-operator/62923#62923) | | 21b | <code>+/&#40;e.&gt;./,&lt;./@&#35;&#126;@&#41;&amp;.&#35;:</code> |
| [Pyth](https://codegolf.stackexchange.com/questions/62713/biplex-an-important-useless-operator/62717#62717) | | 25b | <code>JsM.T&#95;MjR2Qi&#95;}RhM&#95;BS&#45;J0J2</code> |
| [APL](https://codegolf.stackexchange.com/questions/62713/biplex-an-important-useless-operator/63389#63389) | | 27b | <code>{2⊥S∊&#40;⌈/,⌊/&#41;0&#126;⍨S←+/⍵⊤⍨32⍴2}</code> |
| [CJam](https://codegolf.stackexchange.com/questions/62713/biplex-an-important-useless-operator/62714#62714) | | 27b | <code>q&#126;2fbWf%:.+&#95;0&#45;$&#40;&#92;W&gt;&#124;fe=W%2b</code> |
{% raw %}| [GolfScript](https://codegolf.stackexchange.com/questions/62713/biplex-an-important-useless-operator/63680#63680) | | 46b | <code>&#126;{2base&#45;1%}%zip{{+}&#42;}%&#45;1%.$0&#45;&#41;&#92;1&lt;&#124;&#96;{&amp;,}+%2base</code> |{% endraw %}

## [sum-every-second-digit-in-a-number](https://codegolf.stackexchange.com/questions/255650/sum-every-second-digit-in-a-number)

| language | rank | bytes | code |
|----------|------|-------|------|
| [Vyxal](https://codegolf.stackexchange.com/questions/255650/sum-every-second-digit-in-a-number/255665#255665) | | 2b | <code>y∑</code> |
| [flax](https://codegolf.stackexchange.com/questions/255650/sum-every-second-digit-in-a-number/255703#255703) | | 2b | <code>ΣẎ</code> |
| [Fig](https://codegolf.stackexchange.com/questions/255650/sum-every-second-digit-in-a-number/255731#255731) | | 2.469b | <code>S&#93;y</code> |
| [Japt `-hx`](https://codegolf.stackexchange.com/questions/255650/sum-every-second-digit-in-a-number/255661#255661) | | 3b | <code>ì ó</code> |
| [05AB1E](https://codegolf.stackexchange.com/questions/255650/sum-every-second-digit-in-a-number/255707#255707) | | 5b | <code>2ι&#96;SO</code> |
| [Jelly](https://codegolf.stackexchange.com/questions/255650/sum-every-second-digit-in-a-number/255679#255679) | | 5b | <code>D0ÐoS</code> |
| [Brachylog](https://codegolf.stackexchange.com/questions/255650/sum-every-second-digit-in-a-number/255720#255720) | | 6b | <code>ġ₂z₁t+</code> |
| [Charcoal](https://codegolf.stackexchange.com/questions/255650/sum-every-second-digit-in-a-number/255669#255669) | | 7b | <code>ＩΣΦＳ﹪κ²</code> |
| Myby | | 7b | <code>+&#92;@} 2 % 10&&#35;:</code> |
| [Pip](https://codegolf.stackexchange.com/questions/255650/sum-every-second-digit-in-a-number/255684#255684) | | 7b | <code>$+@SUWa</code> |
| [Pyt](https://codegolf.stackexchange.com/questions/255650/sum-every-second-digit-in-a-number/256009#256009) | | 7b | <code>ąĐƩ⇹ƧƩ&#45;</code> |
| [Pyth](https://codegolf.stackexchange.com/questions/255650/sum-every-second-digit-in-a-number/255658#255658) | | 9b | <code>tssM%2+1z</code> |
| [K (ngn/k)](https://codegolf.stackexchange.com/questions/255650/sum-every-second-digit-in-a-number/255983#255983) | | 13b | <code>+/&#40;2!!&#35;:&#41;&#35;10&#92;</code> |
| [BQN](https://codegolf.stackexchange.com/questions/255650/sum-every-second-digit-in-a-number/255698#255698) | | 18b | <code>1⊑·+˝⌊‿2⥊'0'&#45;˜•Fmt</code> |
| [J](https://codegolf.stackexchange.com/questions/255650/sum-every-second-digit-in-a-number/255734#255734) | | 19b | <code>1&#40;&#35;.&#93;&#42;0 1$&#126;&#35;&#41;,.&amp;.&quot;:</code> |

## [generate-an-arbitrary-half-of-a-string](https://codegolf.stackexchange.com/questions/250213/generate-an-arbitrary-half-of-a-string)

| language | rank | bytes | code |
|----------|------|-------|------|
| [Brachylog](https://codegolf.stackexchange.com/questions/250213/generate-an-arbitrary-half-of-a-string/250236#250236) | | 3b | <code>p&#126;j</code> |
| [Jelly](https://codegolf.stackexchange.com/questions/250213/generate-an-arbitrary-half-of-a-string/250234#250234) | | 5b | <code>Ụm2Ṣị</code> |
| [Vyxal](https://codegolf.stackexchange.com/questions/250213/generate-an-arbitrary-half-of-a-string/250232#250232) | | 5b | <code>⇧y&#95;sİ</code> |
| [BQN](https://codegolf.stackexchange.com/questions/250213/generate-an-arbitrary-half-of-a-string/250230#250230) | | 6b | <code>⊢/˜2&#124;⊒</code> |
| [05AB1E](https://codegolf.stackexchange.com/questions/250213/generate-an-arbitrary-half-of-a-string/250294#250294) | | 7b | <code>ηε¤¢É}Ï</code> |
| [Pyth](https://codegolf.stackexchange.com/questions/250213/generate-an-arbitrary-half-of-a-string/250252#250252) | | 7b | <code>q&#35;.&#45;QTy</code> |
| Myby | | 7.5b | <code>&#40; %@} 2 % &#93; &#41; { &#35;</code> |
| [Charcoal](https://codegolf.stackexchange.com/questions/250213/generate-an-arbitrary-half-of-a-string/250218#250218) | | 9b | <code>Φθ﹪№…θκι²</code> |
| [J](https://codegolf.stackexchange.com/questions/250213/generate-an-arbitrary-half-of-a-string/250223#250223) | | 11b | <code>&#35;&#126;2&#124;1&#35;.&#93;=&#93;&#92;</code> |

## [list-of-possible-birth-years-of-living-humans](https://codegolf.stackexchange.com/questions/89494/list-of-possible-birth-years-of-living-humans)

| language | rank | bytes | code |
|----------|------|-------|------|
| [Japt](https://codegolf.stackexchange.com/questions/89494/list-of-possible-birth-years-of-living-humans/115258#115258) | | 6b | <code>&#35;yonKi</code> |
| Myby | | 6b | <code>yr &#45;" R@121</code> |
| [Pyke](https://codegolf.stackexchange.com/questions/89494/list-of-possible-birth-years-of-living-humans/89522#89522) | | 6b | <code>wC7m&#45;</code> |
| [05AB1E](https://codegolf.stackexchange.com/questions/89494/list-of-possible-birth-years-of-living-humans/89498#89498) | | 7b | <code>žg120Ý&#45;</code> |
| [Pyth](https://codegolf.stackexchange.com/questions/89494/list-of-possible-birth-years-of-living-humans/89500#89500) | | 8b | <code>&#45;L.d3C&#92;y</code> |
| [Vyxal](https://codegolf.stackexchange.com/questions/89494/list-of-possible-birth-years-of-living-humans/253155#253155) | | 9b | <code>kðt:122&#45;r</code> |
| [APL (Dyalog)](https://codegolf.stackexchange.com/questions/89494/list-of-possible-birth-years-of-living-humans/89496#89496) | | 10b | <code>120↑⌽⍳⊃⎕ts</code> |
| [MATL](https://codegolf.stackexchange.com/questions/89494/list-of-possible-birth-years-of-living-humans/89508#89508) | | 10b | <code>1&amp;Z'0:120&#45;</code> |
| [CJam](https://codegolf.stackexchange.com/questions/89494/list-of-possible-birth-years-of-living-humans/89517#89517) | | 11b | <code>et0=121,f&#45;p</code> |
| [K (ngn/k)](https://codegolf.stackexchange.com/questions/89494/list-of-possible-birth-years-of-living-humans/253161#253161) | | 12b | <code>{x,x&#45;1+!120}</code> |
| [K](https://codegolf.stackexchange.com/questions/89494/list-of-possible-birth-years-of-living-humans/89555#89555) | | 27b | <code>1@", "/:$&#40;&#96;year$.z.d&#41;&#45;!121;</code> |

## [triangular-polkadot-numbers](https://codegolf.stackexchange.com/questions/253309/triangular-polkadot-numbers)

| language | rank | bytes | code |
|----------|------|-------|------|
| [05AB1E](https://codegolf.stackexchange.com/questions/253309/triangular-polkadot-numbers/253385#253385) | | 8b | <code>·Dtò&lt;n+&lt;</code> |
| [Jelly](https://codegolf.stackexchange.com/questions/253309/triangular-polkadot-numbers/253342#253342) | | 8b | <code>Ḷ²’xRĖḄḣ</code> |
| [Vyxal](https://codegolf.stackexchange.com/questions/253309/triangular-polkadot-numbers/253420#253420) | | 8b | <code>d:√ṙ‹²+‹</code> |
| [Pyt](https://codegolf.stackexchange.com/questions/253309/triangular-polkadot-numbers/255605#255605) | | 10b | <code>2&#42;Đ√½&#45;Ɩ²+⁻</code> |
| Myby | | 11b | <code>R +" R +" R { ^ ! &#62;:@^&2"@R</code> |
| [Charcoal](https://codegolf.stackexchange.com/questions/253309/triangular-polkadot-numbers/253351#253351) | | 22b | <code>ＮθＦθＦ⊕ι⊞υ×ιιＩＥ…υθ⊕⁺ι⊗κ</code> |
| [Pip](https://codegolf.stackexchange.com/questions/253309/triangular-polkadot-numbers/253467#253467) | | 24b | <code>&#40;&#40;RTDBa&#45;0.5&#41;//1&#41;E2+DBa&#45;1</code> |

## [create-n-sublists-with-the-powers-of-two-1-2-4-8-16](https://codegolf.stackexchange.com/questions/255804/create-n-sublists-with-the-powers-of-two-1-2-4-8-16)

| language | rank | bytes | code |
|----------|------|-------|------|
| [MathGolf](https://codegolf.stackexchange.com/questions/255804/create-n-sublists-with-the-powers-of-two-1-2-4-8-16/256098#256098) | | 6b | <code>Æ∞1&#92;αç</code> |
| [Vyxal](https://codegolf.stackexchange.com/questions/255804/create-n-sublists-with-the-powers-of-two-1-2-4-8-16/255805#255805) | | 6b | <code>&#40;d1$&quot;ꜝ</code> |
| [05AB1E](https://codegolf.stackexchange.com/questions/255804/create-n-sublists-with-the-powers-of-two-1-2-4-8-16/255825#255825) | | 7b | <code>F·Xs‚ZK</code> |
| [Jelly](https://codegolf.stackexchange.com/questions/255804/create-n-sublists-with-the-powers-of-two-1-2-4-8-16/255809#255809) | | 7b | <code>Ḥ1,¹ƇƲ¡</code> |
| Myby | | 10.5b | <code>0 &#40;0 &#45; 1 , 2&&#42;V&#41;^:&#35;</code> |
| [Japt](https://codegolf.stackexchange.com/questions/255804/create-n-sublists-with-the-powers-of-two-1-2-4-8-16/255869#255869) | | 11b | <code>Æ&#91;2pX&#93;ÃÔr!p</code> |
| [MATL](https://codegolf.stackexchange.com/questions/255804/create-n-sublists-with-the-powers-of-two-1-2-4-8-16/255820#255820) | | 12b | <code>:qWP&quot;@XhP&#93;&amp;D</code> |
| [Pip `-p`](https://codegolf.stackexchange.com/questions/255804/create-n-sublists-with-the-powers-of-two-1-2-4-8-16/255929#255929) | | 12b | <code>LaYFI&#91;1y&#42;2&#93;y</code> |
| [CJam](https://codegolf.stackexchange.com/questions/255804/create-n-sublists-with-the-powers-of-two-1-2-4-8-16/255857#255857) | | 14b | <code>{,W%{2&#92;&#35;&#93;W%}%}</code> |
| [Charcoal](https://codegolf.stackexchange.com/questions/255804/create-n-sublists-with-the-powers-of-two-1-2-4-8-16/255814#255814) | | 14b | <code>ＦＮ≔Φ⟦¹⊗υ⟧κυ⭆¹υ</code> |
| [K (ngn/k)](https://codegolf.stackexchange.com/questions/255804/create-n-sublists-with-the-powers-of-two-1-2-4-8-16/256019#256019) | | 17b | <code>{&#40;x&#45;1&#41;&#40;1,,2&#42;&#41;/,1}</code> |
| [Pyth](https://codegolf.stackexchange.com/questions/255804/create-n-sublists-with-the-powers-of-two-1-2-4-8-16/255817#255817) | | 20b | <code>L+&#91;^2b&#41;?qtQbY&#91;yhb&#41;y0</code> |
| [Pip](https://codegolf.stackexchange.com/questions/255804/create-n-sublists-with-the-powers-of-two-1-2-4-8-16/255819#255819) | | 28b | <code>FiR,a{YlAEyPE EiUi=a?Y Hy0}y</code> |

## [write-some-random-english](https://codegolf.stackexchange.com/questions/199139/write-some-random-english)

| language | rank | bytes | code |
|----------|------|-------|------|
| [Jelly](https://codegolf.stackexchange.com/questions/199139/write-some-random-english/252402#252402) | | 8b | <code>ØḄØẹḂ?X&#41;</code> |
| [Vyxal `rṀs`](https://codegolf.stackexchange.com/a/256289/78850) | | 8b | <code>ƛkvk⁰"i℅</code> |
| Myby | | 9b | <code>&#62; &#40;?. con&#96;vow&#41;"@R</code> |
| [Vyxal `s`](https://codegolf.stackexchange.com/questions/199139/write-some-random-english/251506#251506) | | 9b | <code>⟑₂¨ikvk¹℅</code> |
| [Stax](https://codegolf.stackexchange.com/questions/199139/write-some-random-english/199448#199448) | | 10b | <code>ÇÅφ⌠↑Ñ°↕Yx</code> |
| [05AB1E](https://codegolf.stackexchange.com/questions/199139/write-some-random-english/199143#199143) | | 11b | <code>EžN¸žMšNèΩJ</code> |
| [Japt `-mP`](https://codegolf.stackexchange.com/questions/199139/write-some-random-english/255785#255785) | | 12b | <code>;Ck%+Ugciv¹ö</code> |
| [Pip](https://codegolf.stackexchange.com/questions/199139/write-some-random-english/251543#251543) | | 12b | <code>RC&#42;&#91;.CZVW&#93;Ha</code> |
| [Pyth](https://codegolf.stackexchange.com/questions/199139/write-some-random-english/252404#252404) | | 19b | <code>J&quot;aeiou&quot;smO?%d2J&#45;GJ</code> |
| [GolfScript](https://codegolf.stackexchange.com/questions/199139/write-some-random-english/199450#199450) | | 36b | <code>,{&#91;'aeiou'.123,97&gt;^&#93;&#92;2%=.,rand=}%''+</code> |

## [repeat-every-other-character-in-string-starting-with-second-character](https://codegolf.stackexchange.com/questions/198717/repeat-every-other-character-in-string-starting-with-second-character)

| language | rank | bytes | code |
|----------|------|-------|------|
| [Jelly](https://codegolf.stackexchange.com/questions/198717/repeat-every-other-character-in-string-starting-with-second-character/198718#198718) | | 3b | <code>ḤÐe</code> |
| [Vyxal](https://codegolf.stackexchange.com/questions/198717/repeat-every-other-character-in-string-starting-with-second-character/236924#236924) | | 3b | <code>3•y</code> |
| [Fig](https://codegolf.stackexchange.com/questions/198717/repeat-every-other-character-in-string-starting-with-second-character/256145#256145) | | 3.292b | <code>n2@h</code> |
| [05AB1E](https://codegolf.stackexchange.com/questions/198717/repeat-every-other-character-in-string-starting-with-second-character/198861#198861) | | 4b | <code>€Ðιθ</code> |
| [Japt `-m`](https://codegolf.stackexchange.com/questions/198717/repeat-every-other-character-in-string-starting-with-second-character/198725#198725) | | 4b | <code>+pVu</code> |
| [Keg `-ir` `-lp`](https://codegolf.stackexchange.com/questions/198717/repeat-every-other-character-in-string-starting-with-second-character/198740#198740) | | 4b | <code>&#40;,⑩,</code> |
| Myby | | 5b | <code>&#40; + &#35; 1 2 &#41; ! &#35;</code> |
| [Pyth](https://codegolf.stackexchange.com/questions/198717/repeat-every-other-character-in-string-starting-with-second-character/199787#199787) | | 7b | <code>%2ts&#42;L3</code> |
| [CJam](https://codegolf.stackexchange.com/questions/198717/repeat-every-other-character-in-string-starting-with-second-character/199600#199600) | | 8b | <code>q3e&#42;1&gt;2%</code> |
| [Charcoal](https://codegolf.stackexchange.com/questions/198717/repeat-every-other-character-in-string-starting-with-second-character/198760#198760) | | 8b | <code>⭆Ｓ×ι⊕﹪κ²</code> |
| [J](https://codegolf.stackexchange.com/questions/198717/repeat-every-other-character-in-string-starting-with-second-character/198719#198719) | | 8b | <code>&#35;&#126;1 2$&#126;&#35;</code> |
| [APL (dzaima/APL)](https://codegolf.stackexchange.com/questions/198717/repeat-every-other-character-in-string-starting-with-second-character/200057#200057) | | 9b | <code>⎕IO←0</code> |
| [GolfScript](https://codegolf.stackexchange.com/questions/198717/repeat-every-other-character-in-string-starting-with-second-character/199785#199785) | | 9b | <code>2/{1/&#126;.}%</code> |
| [Pip](https://codegolf.stackexchange.com/questions/198717/repeat-every-other-character-in-string-starting-with-second-character/237051#237051) | | 10b | <code>WV&#40;UWa!&#42;h&#41;</code> |
| [APL (Dyalog Unicode)](https://codegolf.stackexchange.com/questions/198717/repeat-every-other-character-in-string-starting-with-second-character/237047#237047) | | 11b | <code>⊢&#40;/⍨&#41;1 2⍴⍨⍴</code> <br/> <code></code> <br/> <code>           ⍴   monadic: shape of the right argument &#40;number of elements&#41;</code> <br/> <code></code> <br/> <code>      1 2⍴⍨    repeat numbers 1 and 2 as many times as the right argument</code> <br/> <code></code> <br/> <code>⊢              the right argument</code> <br/> <code></code> <br/> <code> &#40;/⍨&#41;          replicate each element of the left argument as many times as </code> <br/> <code>               specified by the corresponding elements of the right argument</code> |
| [APL (Dyalog)](https://codegolf.stackexchange.com/questions/198717/repeat-every-other-character-in-string-starting-with-second-character/198930#198930) | | 11b | <code>∊⊢⍴⍨¨1 2⍴⍨≢</code> |
| [Z80Golf](https://codegolf.stackexchange.com/questions/198717/repeat-every-other-character-in-string-starting-with-second-character/199601#199601) | | 12b | <code>00000000: d52e 76e5 2e07 e5cd 0380 38f6            ..v.......8.</code> |
| [APL+WIN](https://codegolf.stackexchange.com/questions/198717/repeat-every-other-character-in-string-starting-with-second-character/198773#198773) | | 13b | <code>&#40;&#40;⍴s&#41;⍴⍳2&#41;/s←⎕</code> |
| [K4](https://codegolf.stackexchange.com/questions/198717/repeat-every-other-character-in-string-starting-with-second-character/198757#198757) | | 17b | <code>{,/&#35;'&#91;&#40;&#35;x&#41;&#35;1 2&#93;x}</code> <br/> <code></code> <br/> <code>{               } /lambda with implicit arg x</code> <br/> <code>      &#40;&#35;x&#41;        /count x</code> <br/> <code>          &#35;1 2    /takes &#35;x items of 1 2</code> <br/> <code>   &#35;'&#91;        &#93;x  /take &#91;...&#93; items of x</code> <br/> <code> ,/               /flatten</code> |

## [is-it-true-ask-pip](https://codegolf.stackexchange.com/questions/256166/is-it-true-ask-pip)

| language | rank | bytes | code |
|----------|------|-------|------|
| [05AB1E](https://codegolf.stackexchange.com/questions/256166/is-it-true-ask-pip/256175#256175) | | 7b | <code>„+&#45;₂‡{Ā</code> |
| [Charcoal](https://codegolf.stackexchange.com/questions/256166/is-it-true-ask-pip/256174#256174) | | 9b | <code>∧№.⁻θ0⁻.θ</code> |
| Myby | | 9b | <code>'.' &#40; &#126;: &#42; &#41;.. &#45;&'0'H &#41;</code> |
| [Vyxal](https://codegolf.stackexchange.com/questions/256166/is-it-true-ask-pip/256178#256178) | | 11b | <code>&#96;+&#45; &#96;₈ĿṅsEḃ</code> |
| [Pip](https://codegolf.stackexchange.com/questions/256166/is-it-true-ask-pip/256248#256248) | | 16b | <code>aRM0N&quot;.&quot;&amp;!aQ&quot;.&quot;</code> |

## [whats-the-file-extension](https://codegolf.stackexchange.com/questions/120925/whats-the-file-extension)

| language | rank | bytes | code |
|----------|------|-------|------|
| [Japt](https://codegolf.stackexchange.com/questions/120925/whats-the-file-extension/120957#120957) | | 3b | <code>q.</code> |
| [V](https://codegolf.stackexchange.com/questions/120925/whats-the-file-extension/120939#120939) | | 3b | <code>00000000: cd81 ae                                  ...</code> |
| [05AB1E](https://codegolf.stackexchange.com/questions/120925/whats-the-file-extension/120930#120930) | | 4b | <code>'.¡¤</code> |
| [Charcoal](https://codegolf.stackexchange.com/questions/120925/whats-the-file-extension/121009#121009) | | 4b | <code>⊟⪪Ｓ.</code> |
| [Jelly](https://codegolf.stackexchange.com/questions/120925/whats-the-file-extension/120931#120931) | | 4b | <code>ṣ”.Ṫ</code> |
| [Keg](https://codegolf.stackexchange.com/questions/120925/whats-the-file-extension/210384#210384) | | 4b | <code>&#92;./÷</code> |
| Myby | | 4b | <code>} /&'.'</code> |
| [Stax](https://codegolf.stackexchange.com/questions/120925/whats-the-file-extension/157820#157820) | | 4b | <code>'./H</code> |
| [Vyxal](https://codegolf.stackexchange.com/questions/120925/whats-the-file-extension/229368#229368) | | 4b | <code>&#92;.€t</code> |
| [Ohm v2](https://codegolf.stackexchange.com/questions/120925/whats-the-file-extension/146627#146627) | | 5b | <code>I..ï⁾</code> |
| [Pyth](https://codegolf.stackexchange.com/questions/120925/whats-the-file-extension/121106#121106) | | 5b | <code>ecz&#92;.</code> |
| [Arn](https://codegolf.stackexchange.com/questions/120925/whats-the-file-extension/210212#210212) | | 6b | <code>Ê^!⁺╔d</code> |
| [CJam](https://codegolf.stackexchange.com/questions/120925/whats-the-file-extension/157758#157758) | | 6b | <code>q'./W=</code> |
| [K (oK)](https://codegolf.stackexchange.com/questions/120925/whats-the-file-extension/146626#146626) | | 6b | <code>&#42;&#124;"."&#92;</code> |
| [MATL](https://codegolf.stackexchange.com/questions/120925/whats-the-file-extension/121057#121057) | | 7b | <code>46&amp;YbO&#41;</code> |
| [Pip](https://codegolf.stackexchange.com/questions/120925/whats-the-file-extension/210383#210383) | | 8b | <code>@R:a^&quot;.&quot;</code> |
| [APL (Dyalog Unicode)](https://codegolf.stackexchange.com/questions/120925/whats-the-file-extension/210258#210258) | | 10b | <code>⊃∘⌽'.'∘≠⊆⊢</code> |

## [find-the-prime-signature](https://codegolf.stackexchange.com/questions/256147/find-the-prime-signature)

| language | rank | bytes | code |
|----------|------|-------|------|
| Myby | | 4b | <code>&#45;@% pfep</code> |
| [Vyxal](https://codegolf.stackexchange.com/questions/256147/find-the-prime-signature/256148#256148) | | 4b | <code>∆ǐsṘ</code> |
| [05AB1E](https://codegolf.stackexchange.com/questions/256147/find-the-prime-signature/256172#256172) | | 5b | <code>Ó0K{R</code> |
| [MATL](https://codegolf.stackexchange.com/questions/256147/find-the-prime-signature/256152#256152) | | 5b | <code>&#95;YFSP</code> |
| [APL (Dyalog Extended)](https://codegolf.stackexchange.com/questions/256147/find-the-prime-signature/256150#256150) | | 6b | <code>∨2⌷2⍭⊢</code> |
| [Husk](https://codegolf.stackexchange.com/questions/256147/find-the-prime-signature/256218#256218) | | 6b | <code>↔OmLgp</code> |
| [Jelly](https://codegolf.stackexchange.com/questions/256147/find-the-prime-signature/256149#256149) | | 6b | <code>ÆE¹ƇṢU</code> |
| [Japt](https://codegolf.stackexchange.com/questions/256147/find-the-prime-signature/256160#256160) | | 8b | <code>k ü mÊñn</code> |
| [Pyt](https://codegolf.stackexchange.com/questions/256147/find-the-prime-signature/256155#256155) | | 8b | <code>Đϼ1&#92;⇹ḋɔŞ</code> |
| [J](https://codegolf.stackexchange.com/questions/256147/find-the-prime-signature/256159#256159) | | 12b | <code>&#95;&#95;&#92;:&#126;@{:@q:&#93;</code> |
| [Charcoal](https://codegolf.stackexchange.com/questions/256147/find-the-prime-signature/256161#256161) | | 56b | <code>Ｎθ≔²ηＷ⊖θ¿﹪θη≦⊕η«≔⁰ζＷ¬﹪θη«≦⊕ζ≧÷ηθ»⊞υζ»≔⟦⟧ζＷ⁻υζＦ№υ⌈ι⊞ζ⌈ιＩζ</code> |

## [calculate-the-progressive-mean](https://codegolf.stackexchange.com/questions/198884/calculate-the-progressive-mean)

| language | rank | bytes | code |
|----------|------|-------|------|
| Myby | | 7.5b | <code>&#126;:@+&#92; &#40;, + &#45;&#41; +&#92; / +</code> |
| [Jelly](https://codegolf.stackexchange.com/questions/198884/calculate-the-progressive-mean/198891#198891) | | 9b | <code>Æm;+H¥/ṄI</code> |
| [05AB1E](https://codegolf.stackexchange.com/questions/198884/calculate-the-progressive-mean/198894#198894) | | 12b | <code>āÍoîÅΓ‚ÅAÂÆª</code> |
| [J](https://codegolf.stackexchange.com/questions/198884/calculate-the-progressive-mean/198890#198890) | | 17b | <code>&#45;:@+/@&#124;.&#40;,,&#45;&#41;+/%&#35;</code> |
| [APL (Dyalog Unicode)](https://codegolf.stackexchange.com/questions/198884/calculate-the-progressive-mean/198889#198889) | | 18b | <code>&#40;2÷⍨+&#41;⌿∘⌽&#40;,,&#45;&#41;+⌿÷≢</code> |
| [Charcoal](https://codegolf.stackexchange.com/questions/198884/calculate-the-progressive-mean/198896#198896) | | 27b | <code>≔∕ΣθＬθη≔§θ⁰ζＦθ≔⊘⁺ιζζＩ⟦ηζ⁻ζη</code> |

## [what-do-you-get-when-you-multiply-6-by-9-42](https://codegolf.stackexchange.com/questions/124242/what-do-you-get-when-you-multiply-6-by-9-42)

| language | rank | bytes | code |
|----------|------|-------|------|
| [Jelly](https://codegolf.stackexchange.com/questions/124242/what-do-you-get-when-you-multiply-6-by-9-42/124422#124422) | | 7b | <code>Vf96SạP</code> |
| [Brachylog](https://codegolf.stackexchange.com/questions/124242/what-do-you-get-when-you-multiply-6-by-9-42/180944#180944) | | 8b | <code>c69∧42&#124;×</code> |
| Myby | | 8b | <code>&#42; &#45; 12 &#42; 6 9 = ,</code> |
| [05AB1E](https://codegolf.stackexchange.com/questions/124242/what-do-you-get-when-you-multiply-6-by-9-42/124258#124258) | | 9b | <code>P¹69SQi42</code> |
| [Vyxal](https://codegolf.stackexchange.com/questions/124242/what-do-you-get-when-you-multiply-6-by-9-42/256247#256247) | | 9b | <code>69f⁼&#91;42&#124;Π</code> |
| [APL (Dyalog)](https://codegolf.stackexchange.com/questions/124242/what-do-you-get-when-you-multiply-6-by-9-42/124465#124465) | | 10b | <code>×&#45;12×6 9≡,</code> |
| [MathGolf](https://codegolf.stackexchange.com/questions/124242/what-do-you-get-when-you-multiply-6-by-9-42/180985#180985) | | 10b | <code>α96α=¿ÅJ∞&#42;</code> |
| [J](https://codegolf.stackexchange.com/questions/124242/what-do-you-get-when-you-multiply-6-by-9-42/124605#124605) | | 11b | <code>&#42;&#45;12&#42;6 9&#45;:,</code> |
| [MATL](https://codegolf.stackexchange.com/questions/124242/what-do-you-get-when-you-multiply-6-by-9-42/124267#124267) | | 11b | <code>&#91;BE&#93;=?42}Gp</code> |
| [Ohm](https://codegolf.stackexchange.com/questions/124242/what-do-you-get-when-you-multiply-6-by-9-42/124255#124255) | | 11b | <code>&#42;┼6E┘9E&amp;?42</code> |
| [Pyth](https://codegolf.stackexchange.com/questions/124242/what-do-you-get-when-you-multiply-6-by-9-42/124332#124332) | | 11b | <code>?qQ,6tT42&#42;F</code> |
| [Japt](https://codegolf.stackexchange.com/questions/124242/what-do-you-get-when-you-multiply-6-by-9-42/124262#124262) | | 12b | <code>¥6&amp;V¥9?42:N×</code> |
| [K (oK)](https://codegolf.stackexchange.com/questions/124242/what-do-you-get-when-you-multiply-6-by-9-42/142150#142150) | | 14b | <code>&#40;&#42;/x;42&#41;6 9&#126;x:</code> |
| [CJam](https://codegolf.stackexchange.com/questions/124242/what-do-you-get-when-you-multiply-6-by-9-42/160278#160278) | | 15b | <code>{:T69Ab=42T:&#42;?}</code> |
| [Q](https://codegolf.stackexchange.com/questions/124242/what-do-you-get-when-you-multiply-6-by-9-42/124915#124915) | | 17b | <code>{&#40;prd x;42&#41;x&#126;6 9}</code> |
| [GolfScript](https://codegolf.stackexchange.com/questions/124242/what-do-you-get-when-you-multiply-6-by-9-42/124338#124338) | | 18b | <code>."6 9"={;42}{&#126;&#42;}if</code> |
| [shortC](https://codegolf.stackexchange.com/questions/124242/what-do-you-get-when-you-multiply-6-by-9-42/124249#124249) | | 23b | <code>Df&#40;a,b&#41;a==6&amp;b==9?42:a&#42;b</code> |

## [find-the-largest-and-the-smallest-number-in-an-array](https://codegolf.stackexchange.com/questions/71172/find-the-largest-and-the-smallest-number-in-an-array)

| language | rank | bytes | code |
|----------|------|-------|------|
| Myby | | 5.5b | <code>minmax &#60;I.&#92;</code> |
| [Jelly](https://codegolf.stackexchange.com/questions/71172/find-the-largest-and-the-smallest-number-in-an-array/216925#216925) | | 6b | <code>OƑƇṢ.ị</code> |
| [Seriously](https://codegolf.stackexchange.com/questions/71172/find-the-largest-and-the-smallest-number-in-an-array/71200#71200) | | 6b | <code>,ì;M@m</code> |
| [Vyxal](https://codegolf.stackexchange.com/questions/71172/find-the-largest-and-the-smallest-number-in-an-array/231131#231131) | | 6b | <code>0+∩₍gG  &#35; main program</code> |
| [Brachylog](https://codegolf.stackexchange.com/questions/71172/find-the-largest-and-the-smallest-number-in-an-array/231133#231133) | | 7b | <code>ℕˢ⟨⌋≡⌉⟩</code> |
| [Pyth](https://codegolf.stackexchange.com/questions/71172/find-the-largest-and-the-smallest-number-in-an-array/71177#71177) | | 10b | <code>hM&#95;BS^I&#35;1Q</code> |
| [APL (Dyalog)](https://codegolf.stackexchange.com/questions/71172/find-the-largest-and-the-smallest-number-in-an-array/120673#120673) | | 13b | <code>&#40;⌊/,⌈/&#41;⎕AV&#126;⍨∊</code> |
| [CJam](https://codegolf.stackexchange.com/questions/71172/find-the-largest-and-the-smallest-number-in-an-array/71175#71175) | | 13b | <code>{&#95;:z&amp;$2&#42;&#95;,&#40;%}</code> |
| [K (ngn/k)](https://codegolf.stackexchange.com/questions/71172/find-the-largest-and-the-smallest-number-in-an-array/216975#216975) | | 19b | <code>&#40;&amp;/;&#124;/&#41;@&#92;:&#40;&#96;i=@:'&#41;&#35;</code> |
| [Jolf](https://codegolf.stackexchange.com/questions/71172/find-the-largest-and-the-smallest-number-in-an-array/71248#71248) | | 20b | <code>γ fxd='nF&#126;tH0ͺZkγZKγ</code> <br/> <code> &#95;fx                 filter the input</code> <br/> <code>    d='nF&#126;tH0        checking for number type</code> <br/> <code>γ                    call that "γ"</code> <br/> <code>             ͺ       pair</code> <br/> <code>              ZkγZKγ  the min and max of the array</code> |
| [𝔼𝕊𝕄𝕚𝕟](https://codegolf.stackexchange.com/questions/71172/find-the-largest-and-the-smallest-number-in-an-array/71258#71258) | | 20b | <code>&#91;МƲ&#40;ï⇔⒡≔=+$⸩,МƵï</code> |
| [Japt](https://codegolf.stackexchange.com/questions/71172/find-the-largest-and-the-smallest-number-in-an-array/71231#71231) | | 23b | <code>&#91;V=Uf&#95;bZÃn@X&#45;Y}&#41;g Vw g&#93;</code> |
| [MATL](https://codegolf.stackexchange.com/questions/71172/find-the-largest-and-the-smallest-number-in-an-array/71180#71180) | | 23b | <code>"@Y:tX%1&#41;2&#92;?x&#93;N$htX&lt;wX&gt;</code> |

