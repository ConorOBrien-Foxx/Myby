# Introduction

TLDR, Current Verdict: Myby is decently competitive, sometimes even winning against popular golfing languages, but doesn't consistently beat them, more often losing than winning. There's room for improvement, but it is already well-situated to at least be generally competitive. As of 1/3/2023 (win-loss-tie / total | win%):

```
                     W -  L - T /  Σ |     W%
Myby vs. 05AB1E:    21 - 23 - 4 / 48 | 43.75%
Myby vs. MATL:      20 -  3 - 1 / 24 | 83.33%
Myby vs. Jelly:     13 - 27 - 7 / 47 | 27.66%
Myby vs. Vyxal:     11 - 20 - 6 / 37 | 29.73%
Myby vs. Husk:      11 - 10 - 1 / 22 | 50.00%
Myby vs. Fig:        4 - 13 - 0 / 17 | 23.53%
Myby vs. Nibbles:    3 -  6 - 0 /  9 | 33.33%
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
| [Jelly](https://codegolf.stackexchange.com/a/218229/31957) | | 6b | `Bæc/ḂḄ` |
| **Myby** | | **7b** | `~:\/.*\@.&.#:` |
| [05AB1E](https://codegolf.stackexchange.com/a/252208/31957) | | 8b | `Îbv·yI*^` |
| [Vyxal](https://codegolf.stackexchange.com/a/256279/31957) | | 9b | `₌0b(dn⁰*꘍` |
| [Pyth](https://codegolf.stackexchange.com/a/50245/31957) | | 12b | `uxyG*HQjvz2Z` |
| [CJam](https://codegolf.stackexchange.com/a/50248/31957) | | 13b | `q~2bf*{\2*^}*` |
| [J](https://codegolf.stackexchange.com/a/50243/31957) | | 14b | `*/(~://.@)&.#:` |


## [reconstruct-matrix-from-its-diagonals](https://codegolf.stackexchange.com/questions/252082/reconstruct-matrix-from-its-diagonals)

| language | rank | bytes | code |
|----------|------|-------|------|
| **Myby** | | **3.5b** | `#/:!.` |
| [Jelly](https://codegolf.stackexchange.com/a/252099/31957) | | 8b | `ṙLHĊƊṚŒḌ` |
| [Vyxal](https://codegolf.stackexchange.com/a/252087/31957) | | 12b | `Ṗ'L√ẇÞDf?⁼;h` |
| [05AB1E](https://codegolf.stackexchange.com/a/252085/31957) | | 18b | `g;ÝDδ-Z+èεNUεNX‚ßè` |
| [Charcoal](https://codegolf.stackexchange.com/a/252406/31957) | | 18b | `Ｉ⮌Ｅ⊘⊕ＬθＥ⊘⊕Ｌθ⊟§θ⁺ιλ` |
| [J](https://codegolf.stackexchange.com/a/252092/31957) | | 20b | `/:&;</.@i.@(,-)@%:@#` |
| [MathGolf](https://codegolf.stackexchange.com/a/252091/31957) | | 22b | `h½)r■_@mÅε-_╙+§\mÄ╓m§` |
| [Pip `-x`](https://codegolf.stackexchange.com/a/252114/31957) | | 22b | `Fi,YMX#*aFki+R,yPPOa@k` |


## [find-the-sum-of-the-divisors-of-n](https://codegolf.stackexchange.com/questions/142071/find-the-sum-of-the-divisors-of-n)

| language | rank | bytes | code |
|----------|------|-------|------|
| [Vyxal `s`](https://codegolf.stackexchange.com/a/238215/31957) | | 1b | `K` |
| [Japt `-x`](https://codegolf.stackexchange.com/a/142081/31957) | | 1b | `â` |
| [05AB1E](https://codegolf.stackexchange.com/a/142074/31957) | | 2b | `ÑO` |
| [Brachylog](https://codegolf.stackexchange.com/a/142111/31957) | | 2b | `f+` |
| [Vyxal](https://codegolf.stackexchange.com/a/238215/31957) | | 2b | `K∑` |
| [Husk](https://codegolf.stackexchange.com/a/240589/31957) | | 2b | `ΣḊ` |
| [Ohm v2](https://codegolf.stackexchange.com/a/142121/31957) | | 2b | `VΣ` |
| [Gaia](https://codegolf.stackexchange.com/a/142140/31957) | | 2b | `dΣ` |
| [Neim](https://codegolf.stackexchange.com/a/142147/31957) | | 2b | `𝐅𝐬` |
| [Jelly](https://codegolf.stackexchange.com/a/142076/31957) | | 2b | `Æs` |
| [RProgN 2](https://codegolf.stackexchange.com/a/142090/31957) | | 2b | `ƒ+` |
| [MathGolf](https://codegolf.stackexchange.com/a/252235/31957) | | 2b | `─Σ`|
| [Fig](https://codegolf.stackexchange.com/a/252241/31957) | | 2.469b | `+Sk` |
| **Myby** | | **2.5b** | `+\ D` |
| [Japt](https://codegolf.stackexchange.com/a/142081/31957) | | 3b | `â)x` |
| [Risky](https://codegolf.stackexchange.com/a/241963/31957) | | 3b | `+/?+??` |
| [MATL](https://codegolf.stackexchange.com/a/142149/31957) | | 3b | `Z\s` |
| [cQuents](https://codegolf.stackexchange.com/a/254530/31957) | | 3b | `Uz$` |
| [MY](https://codegolf.stackexchange.com/a/142355/31957) | | 4b | `ωḊΣ↵` |
| [Husk](https://codegolf.stackexchange.com/a/142122/31957) | | 5b | `ṁΠuṖp` |
| [Pyth](https://codegolf.stackexchange.com/a/142116/31957) | | 6b | `s*M{yP` |
| [APL](https://codegolf.stackexchange.com/a/142356/31957) | | 9b | `+/⍳×0=⍳|⊢` |
| [J](https://codegolf.stackexchange.com/q/142071/#comment348103_142109) | | 13b | `+1#.i.*0=i.|]` |
| [K (ngn/k)](https://codegolf.stackexchange.com/a/242041/31957) | | 14b | `{+/&~1!x%!1+x}` |
| [CJam](https://codegolf.stackexchange.com/a/142153/31957) | | 16b | `ri:X{)_X\%!*}%:+` |

## [fibonacci-function-or-sequence](https://codegolf.stackexchange.com/questions/85/fibonacci-function-or-sequence)

_Note: This is specifically for n-th term._

| language | rank | bytes | code |
|----------|------|-------|------|
| [MathGolf](https://codegolf.stackexchange.com/a/248434/31957) | | 1b | `f` |
| [Pyt](https://codegolf.stackexchange.com/a/151903/31957) | | 1b | `Ḟ` |
| [05AB1E](https://codegolf.stackexchange.com/a/170744/31957) | | 2b | `Åf` |
| [Stax](https://codegolf.stackexchange.com/a/158186/31957) | | 2b | `|5` |
| [Oasis](https://codegolf.stackexchange.com/a/191443/31957) | | 2b | `+T` |
| [Jelly](https://codegolf.stackexchange.com/a/66839/31957) | | 3b | `+¡1` |
| [flax](https://codegolf.stackexchange.com/a/243108/31957) | | 3b | `1+ⁿ` |
| [Japt](https://codegolf.stackexchange.com/a/154481/31957) | | 3b | `MgU` |
| [FAC](https://codegolf.stackexchange.com/a/15534/31957) | | 4b | `1+⌼1` |
| **Myby** | | **4.5b** | `+\ # !"&R -` |
| [Nibbles](https://codegolf.stackexchange.com/a/254601/31957) | | 5b | `=$.~~1+<2` |
| [Halfwit](https://codegolf.stackexchange.com/a/243112/31957) | | 5.5b | `n><?(:}+` |
| [𝔼𝕊𝕄𝕚𝕟](https://codegolf.stackexchange.com/a/69915/31957) | | 6b | `Мȫï` |
| [cQuents](https://codegolf.stackexchange.com/a/128238/31957) | | 6b | `=1:Z+Y` |
| [Gaia](https://github.com/Glan9/Gaia) | | 6b | `0₁@+₌ₓ` |
| [J-uby](https://github.com/cyoce/J-uby) | | 6b | `:++2.*` |
| [K](https://codegolf.stackexchange.com/a/253768/31957) | | 8b | `+/[;1;0]` |
| [J](https://codegolf.stackexchange.com/a/87107/31957) | | 9b | `+/@:!&i.-` |
| [GolfScript](https://codegolf.stackexchange.com/a/207/31957) | | 11b | `0 1@{.@+}*;` |
| [Brachylog](https://codegolf.stackexchange.com/a/190928/31957) | | 13b | `∧0;1⟨t≡+⟩ⁱ↖?t` | 
| [Pylons](https://codegolf.stackexchange.com/a/71126/31957) | | 13b | `11fA..+@{A,i}` |

Other approaches (often output first N or infinite sequence):
| language | rank | bytes | code |
|----------|------|-------|------|
| [Vyxal](https://codegolf.stackexchange.com/a/223094/31957) | | 2b | `ÞF` |
| [Fig](https://codegolf.stackexchange.com/a/248952/31957) | | 3.292b | `G:1'+` |
| [Chocolate](https://codegolf.stackexchange.com/a/249230/31957) | | 4b | `c1` |
| [J](https://codegolf.stackexchange.com/a/10844/31957) | | 10b | `(%-.-*:)t.` |
| [JAGL](https://codegolf.stackexchange.com/a/42452/31957) | | 13b | `1d{cdc+dcPd}u` |
| [APL (Dyalog Unicode)](https://codegolf.stackexchange.com/a/252115/31957) | | 16b | `F←{⊃⊃(+/,⊃)⍤⊢/⍵/1}` |

## [minimum-excluded-number](https://codegolf.stackexchange.com/questions/38325/minimum-excluded-number)

| language | rank | bytes | code |
|----------|------|-------|------|
| [Brachylog](https://codegolf.stackexchange.com/a/252022/31957) | | 3b | `≡ⁿℕ` |
| [Jelly](https://codegolf.stackexchange.com/a/252204/31957) | | 4b | `0ḟ1#` |
| [MathGolf](https://codegolf.stackexchange.com/a/173768/31957) | | 4b | `Jr,╓` |
| [Vyxal `r`](https://codegolf.stackexchange.com/a/252020/31957) | | 4b | `₇ʀFg` |
| [Fig](https://codegolf.stackexchange.com/a/252196/31957) | | 4.116b | `[FxmN` |
| **Myby** | | **4.5b** | `{ R@100&-` |
| [05AB1E](https://codegolf.stackexchange.com/a/252023/31957) | | 5b | `₂ÝIKн` |
| [Japt](https://codegolf.stackexchange.com/a/252024/31957) | | 5b | `@øX}f` |
| [Pyth](https://codegolf.stackexchange.com/a/38342/31957) | | 6b | `h-U21Q` |
| [Stax](https://codegolf.stackexchange.com/a/173759/31957) | | 6b | `wiix#` |
| [GolfScript](https://codegolf.stackexchange.com/a/38330/31957) | | 7b | `~21,^0=` |
| [K](https://codegolf.stackexchange.com/a/173828/31957) | | 7b | `*(!22)^` |
| [Pip](https://codegolf.stackexchange.com/a/252201/31957) | | 7b | `WiNgUii` |
| [CJam](https://codegolf.stackexchange.com/a/38326/31957) | | 8b | `K),l~^1<` |
| [J](https://codegolf.stackexchange.com/a/38344/31957) | | 10b | `0{i.@21&-.` |
| [APL (Dyalog Classic)](https://codegolf.stackexchange.com/a/118303/31957) | | 19b | `f←⊃⊢~⍨0,⍳∘⍴` |
| [APL (Dyalog)](https://codegolf.stackexchange.com/a/118303/31957) | | 19b | `(0⍳⍨⊢=⍳∘⍴)∘(⊂∘⍋⌷⊢)∪` |

## [compute-the-median](https://codegolf.stackexchange.com/questions/106149/compute-the-median)

| language | rank | bytes | code |
|----------|------|-------|------|
| [Actually](https://codegolf.stackexchange.com/a/106163/31957) | | 1b | `║` |
| [Jelly](https://codegolf.stackexchange.com/questions/106149/compute-the-median#comment355836_106217) | | 2b | `Æṁ` |
| [05AB1E](https://codegolf.stackexchange.com/a/173091/31957) | | 2b | `Åm` |
| [Arn](https://codegolf.stackexchange.com/a/224855/31957) | | 3b | `med` |
| [MATL](https://codegolf.stackexchange.com/a/106150/31957) | | 4b | `.5Xq` |
| [Vyxal](https://codegolf.stackexchange.com/a/252202/31957) | | 6b | `s∆ṁwfṁ` |
| **Myby** | | **8.5b** | `~:+{2!-@%+"%` |
| [Fig](https://codegolf.stackexchange.com/a/252194/31957) | | 9.054b | `KY` <br/> `HSt2s{HL` | 
| [Pyth](https://codegolf.stackexchange.com/a/106157/31957) | | 11b | `.O@R/lQ2_BS` |
| [J](https://codegolf.stackexchange.com/a/173140/31957) | | 14b | `2%~#{2#/:~+\:~` |
| [Pip](https://codegolf.stackexchange.com/a/253792/31957) | | 16b | `SN:g(CHg+Rgoi)/2` |
| [GolfScript](https://codegolf.stackexchange.com/a/173066/31957) | | 17b | `~..+$\,(>2<~+"/2"` |
| [BQN](https://codegolf.stackexchange.com/a/224462/31957) | | 20b | `{2÷˜(≠𝕩)⊑»+˝˘2↕2/∧𝕩}` |
| [CJam](https://codegolf.stackexchange.com/a/106280/31957) | | 21b | `q~]$__,2/=\_,(2/=+2d/` |
| [K](https://codegolf.stackexchange.com/a/139469/31957) | | 23b | `{avg x(<x)@_.5*-1 0+#x}` |

## [find-the-nth-mersenne-prime](https://codegolf.stackexchange.com/questions/251594/find-the-nth-mersenne-prime)

| language | rank | bytes | code |
|----------|------|-------|------|
| [Fig](https://codegolf.stackexchange.com/a/252306/31957) | | 6.585b | `F@p{^2mC` |
| [Vyxal `G`](https://codegolf.stackexchange.com/a/251598/31957) | | 7b | `Þ∞E‹~æẎ` |
| [Jelly](https://codegolf.stackexchange.com/a/251627/31957) | | 7b | `&‘<Ẓø#Ṫ` |
| [Husk](https://codegolf.stackexchange.com/a/251607/31957) | | 7b | `!fṗm←İ2` | 
| **Myby** | | **7b** | `(e.@#: * primq) G` |
| [05AB1E (legacy)](https://codegolf.stackexchange.com/a/251671/31957) | | 8b | `µNbSPNp*` |
| [Japt](https://codegolf.stackexchange.com/a/251684/31957) | | 14b | `Èõ!²mÉ øX*j}iU` |
| [Brachylog](https://codegolf.stackexchange.com/a/251623/31957) | | 14b | `;2{;X≜^-₁ṗ}ᶠ⁽t` |

## [product-of-divisors](https://codegolf.stackexchange.com/questions/130454/product-of-divisors)

| language | rank | bytes | code |
|----------|------|-------|------|
| [05AB1E](https://codegolf.stackexchange.com/a/130465/31957) | | 2b | `ÑP` |
| [Neim](https://codegolf.stackexchange.com/a/130479/31957) | | 2b | `𝐅𝐩` |
| [Vyxal](https://codegolf.stackexchange.com/a/252247/31957) | | 2b | `KΠ` |
| [RProgN 2](https://codegolf.stackexchange.com/a/143051/31957) | | 2b | `ƒ*` |
| [Husk](https://codegolf.stackexchange.com/a/215651/31957) | | 2b | `ΠḊ` |
| [Fig](https://codegolf.stackexchange.com/a/252242/31957) | | 2.469b | `*rk` |
| **Myby** | | **2.5b** | `*\ D` |
| [Japt](https://codegolf.stackexchange.com/a/130460/31957) | | 3b | `â ×` |
| [Jelly](https://codegolf.stackexchange.com/a/130455/31957) | | 3b | `ÆDP` |
| [MATL](https://codegolf.stackexchange.com/a/130459/31957) | | 3b | `Z\p` |
| [Arn](https://codegolf.stackexchange.com/a/215593/31957) | | 3b | `Þ┤â` |
| [MathGolf](https://codegolf.stackexchange.com/a/215601/31957) | | 3b | `─ε*` |
| [MY](https://codegolf.stackexchange.com/a/131632/31957) | | 4b | Bytes: `1A 3A 54 27` |
| [APL (Dyalog Unicode)](https://codegolf.stackexchange.com/a/216672/31957) | | 5b | `×/∘∪⊢∨⍳` |
| [Pyth](https://codegolf.stackexchange.com/a/130456/31957) | | 6b | `*Fs{yP` |
| [J](https://codegolf.stackexchange.com/a/130474/31957) | | 19b | `*/}.I.(=<.)(%i.@>:)` |

## [antisymmetry-of-a-matrix](https://codegolf.stackexchange.com/questions/208982/antisymmetry-of-a-matrix)

| language | rank | bytes | code |
|----------|------|-------|------|
| [APL (Dyalog Unicode)](https://codegolf.stackexchange.com/a/208985/31957) | | 3b | `-≡⍉` |
| [Jelly](https://codegolf.stackexchange.com/a/213919/31957) | | 3b | `N⁼Z` |
| **Myby** | | 3b | `-V = ^` |
| [05AB1E](https://codegolf.stackexchange.com/a/213921/31957) | | 3b | `ø(Q` |
| [Brachylog](https://codegolf.stackexchange.com/a/208997/31957) | | 5b | `\ṅᵐ²?` |
| [Pyth](https://codegolf.stackexchange.com/a/208995/31957) | | 5b | `qC_MM` |
| [MATL](https://codegolf.stackexchange.com/a/208992/31957) | | 5b | `!_GX=` |
| [Japt](https://codegolf.stackexchange.com/a/208988/31957) | | 5b | `eUy®n` |
| [Pip](https://codegolf.stackexchange.com/a/208996/31957) | | 5b | `Z_=-_` |
| [Husk](https://codegolf.stackexchange.com/a/213918/31957) | | 5b | `§=T†_` |
| [K](https://codegolf.stackexchange.com/a/254630/31957) | | 7b | `{x~-+x}` |
| [Charcoal](https://codegolf.stackexchange.com/a/209014/31957) | | 10b | `⁼θＥθＥθ±§λκ` |
| [J-uby](https://codegolf.stackexchange.com/a/254622/31957) | | 28b | `:=~&(:transpose|:*&(:*&:-@))` |

## [list-of-primes-under-a-million](https://codegolf.stackexchange.com/questions/5977/list-of-primes-under-a-million)
| language | rank | bytes | code |
|----------|------|-------|------|
| [Ohm](https://codegolf.stackexchange.com/a/111911/31957) | | 3b | `6°P` |
| **Myby** | | 3.5b | `primb 1000000` |
| [Vyxal](https://codegolf.stackexchange.com/a/239947/31957) | | 4b | `k4'æ` |
| [gs2](https://codegolf.stackexchange.com/a/55868/31957) | | 5b | `∟)◄lT` |
| [MATL](https://codegolf.stackexchange.com/a/96174/31957) | | 5b | `1e6Zq` |
| [MathGolf](https://codegolf.stackexchange.com/a/252152/31957) | | 5b | `►rg¶n` |
| [05AB1E](https://codegolf.stackexchange.com/a/164545/31957) | | 6b | `6°ÅPε,` |
| [Japt `-R`](https://codegolf.stackexchange.com/a/211901/31957) | | 6b | `L³õ fj` |
| [NARS2000 APL](https://codegolf.stackexchange.com/a/58785/31957) | | 7b | `⍸0π⍳1e6` |
| [Jelly](https://codegolf.stackexchange.com/a/128312/31957) | | 7b | `10*6ÆRY` |
| [Stax](https://codegolf.stackexchange.com/a/157056/31957) | | 7b | `ç►╪(Æ;Ç` |
| [Pyt](https://codegolf.stackexchange.com/a/157210/31957) | | 8b | `6ᴇřĐṗ*žÁ` |
| [J](https://codegolf.stackexchange.com/a/5979/31957) | | 9b | `p:i.78498` |
| [Pyth](https://codegolf.stackexchange.com/a/80739/31957) | | 9b | `V^T6IP_NN` |
| [CJam](https://codegolf.stackexchange.com/a/27068/31957) | | 11b | `1e6,{mp},N*` |
| [JAGL](https://codegolf.stackexchange.com/a/42978/31957) | | 14b | `1e6r{m}%{PZp}/` |
| [APL](https://codegolf.stackexchange.com/a/13030/31957) | | 15b | `p~,p∘.×p←1↓⍳1e6` |
| [GolfScript](https://codegolf.stackexchange.com/a/27066/31957) | | 19b | ``` n(6?,:|2>.{|%2>-}/` ``` |

## [mathematical-combination](https://codegolf.stackexchange.com/questions/1744/mathematical-combination)

| language | rank | bytes | code |
|----------|------|-------|------|
| [05AB1E](https://codegolf.stackexchange.com/questions/1744/mathematical-combination/206489#206489) | | 1b | `c` |
| [Jelly](https://codegolf.stackexchange.com/questions/1744/mathematical-combination/219534#219534) | | 1b | `c` |
| [Japt](https://codegolf.stackexchange.com/questions/1744/mathematical-combination/252296#252296) | | 2b | `àV` |
| [APL](https://codegolf.stackexchange.com/questions/1744/mathematical-combination/1746#1746) | | 3b | `⎕!⎕` |
| Myby | | 3.5b | `!~\,` |
| [J](https://codegolf.stackexchange.com/questions/1744/mathematical-combination/6288#6288) | | 11b | `!~/".1!:1[1` |
| [GolfScript](https://codegolf.stackexchange.com/questions/1744/mathematical-combination/1759#1759) | | 17b | `~>.,,]{1\{)*}/}//` |
| [CJam](https://codegolf.stackexchange.com/questions/1744/mathematical-combination/206509#206509) | | 19b | `l~\_m!@@\_m!@@-m!*/` |
| [Q](https://codegolf.stackexchange.com/questions/1744/mathematical-combination/5076#5076) | | 32b | `{f:{1*/1.+(!)x};f[x]%f[y]*f x-y}` |

## [pwas-eht-tirsf-dna-tasl-setterl-fo-hace-dorw](https://codegolf.stackexchange.com/questions/185674/pwas-eht-tirsf-dna-tasl-setterl-fo-hace-dorw)

| language | rank | bytes | code |
|----------|------|-------|------|
| [Nibbles](https://codegolf.stackexchange.com/questions/185674/pwas-eht-tirsf-dna-tasl-setterl-fo-hace-dorw/252370#252370) | | 5b | ``` :`(\@:`)\$ ``` |
| [Stax](https://codegolf.stackexchange.com/questions/185674/pwas-eht-tirsf-dna-tasl-setterl-fo-hace-dorw/248343#248343) | | 6b | `╡à⌂≤¬)` |
| [Japt `-S`](https://codegolf.stackexchange.com/questions/185674/pwas-eht-tirsf-dna-tasl-setterl-fo-hace-dorw/185743#185743) | | 7b | `¸®ÎiZÅé` |
| [Vyxal](https://codegolf.stackexchange.com/questions/185674/pwas-eht-tirsf-dna-tasl-setterl-fo-hace-dorw/247990#247990) | | 7b | `⌈ƛḣǔp;Ṅ` |
| [Vyxal `S`](https://codegolf.stackexchange.com/questions/185674/pwas-eht-tirsf-dna-tasl-setterl-fo-hace-dorw/236099#236099) | | 7b | `⌈ƛḣṫ∇p+` |
| [Jelly](https://codegolf.stackexchange.com/questions/185674/pwas-eht-tirsf-dna-tasl-setterl-fo-hace-dorw/185707#185707) | | 9b | `ḲṪ;ṙ1$Ɗ€K` |
| Myby | | 9.5b | `(}+1>.<:)"&.(/&' ')` |
| [05AB1E](https://codegolf.stackexchange.com/questions/185674/pwas-eht-tirsf-dna-tasl-setterl-fo-hace-dorw/185675#185675) | | 10b | `#vyRćsRćðJ` |
| [Husk](https://codegolf.stackexchange.com/questions/185674/pwas-eht-tirsf-dna-tasl-setterl-fo-hace-dorw/252369#252369) | | 10b | `wm§:→oṙ1hw` |
| [Pip](https://codegolf.stackexchange.com/questions/185674/pwas-eht-tirsf-dna-tasl-setterl-fo-hace-dorw/236088#236088) | | 15b | `aR+XW{@a::a@va}` |
| [J](https://codegolf.stackexchange.com/questions/185674/pwas-eht-tirsf-dna-tasl-setterl-fo-hace-dorw/185718#185718) | | 17b | `({:,1|.}:)&.>&.;:` |
| [QuadR](https://codegolf.stackexchange.com/questions/185674/pwas-eht-tirsf-dna-tasl-setterl-fo-hace-dorw/185681#185681) | | 20b | `(\w)(\w*)(\w)` <br/> `\3\2\1` |
| [Z80Golf](https://codegolf.stackexchange.com/questions/185674/pwas-eht-tirsf-dna-tasl-setterl-fo-hace-dorw/185773#185773) | | 43b | `00000000: 2100 c0cd 0380 3822 5745 cd03 8038 09fe  !.....8"WE...8..` <br/> `00000010: 2028 0570 4723 18f2 736b 707e 23a7 2803   (.pG#..skp~#.(.` <br/> `00000020: ff18 f87a ff3e 20ff 18d6 76              ...z.> ...v` |
| [APL+WIN](https://codegolf.stackexchange.com/questions/185674/pwas-eht-tirsf-dna-tasl-setterl-fo-hace-dorw/185713#185713) | | 50b | `(∊¯1↑¨s),¨1↓¨(¯1↓¨s),¨↑¨s←((+\s=' ')⊂s←' ',⎕)~¨' '` |

## [carryless-factors](https://codegolf.stackexchange.com/questions/252189/carryless-factors)

| language | rank | bytes | code |
|----------|------|-------|------|
| [Jelly](https://codegolf.stackexchange.com/questions/252189/carryless-factors/252200#252200) | | 11b | ``` B€æcþ`Ḃċ€BT ``` |
| Myby | | 14.5b | ``` ^ # # e." (~:\/. *\ @.&.#:)`:\~@^ ``` |
| [05AB1E](https://codegolf.stackexchange.com/questions/252189/carryless-factors/252209#252209) | | 18b | `LʒULε0sbv·yX*^}Q}à` |
| [Vyxal](https://codegolf.stackexchange.com/questions/252189/carryless-factors/252213#252213) | | 18b | `'£?ƛ0$b(dn¥*꘍)?=;a` |
| [Charcoal](https://codegolf.stackexchange.com/questions/252189/carryless-factors/252210#252210) | | 48b | `ＮθＦθ«≔θηＦ⮌×⊕ιＸ²…·⁰⁻Ｌ↨θ²Ｌ↨⊕ι²≔⌊⟦η⁻｜ηκ＆ηκ⟧η¿¬η⟦Ｉ⊕ι` |

## [scan-a-ragged-list](https://codegolf.stackexchange.com/questions/240612/scan-a-ragged-list)

| language | rank | bytes | code |
|----------|------|-------|------|
| Myby | | 3b | `+\..0` |
| [Japt](https://codegolf.stackexchange.com/questions/240612/scan-a-ragged-list/240693#240693) | | 25b | `W=Uv)?[W¶Ô?ßWÔ:V±W]cßUV:U` |
| [Pip `-xp`](https://codegolf.stackexchange.com/questions/240612/scan-a-ragged-list/240629#240629) | | 27b | `b|:0FdacPB:xNd?b+:d(fdb)c|l` |
| [05AB1E](https://codegolf.stackexchange.com/questions/240612/scan-a-ragged-list/240666#240666) | | 29b | `0U"εdiXćy+š¬ëXD¬šUy®.V}sU"©.V` |
| [BQN](https://codegolf.stackexchange.com/questions/240612/scan-a-ragged-list/240620#240620) | | 34b | `{×≠𝕩?(⊑𝕩)𝕤{=𝕨?𝕩∾˜⋈𝔽𝕨;𝕨+0∾𝕩}𝕊1↓𝕩;𝕩} # Function taking a nested list as 𝕩` <br/> ` ×≠𝕩?                          ;𝕩  # If the list is empty, return it` <br/> `                            1↓𝕩    # Tail of 𝕩` <br/> `                           𝕊       # Recursive call on the tail` <br/> `                                   # If that fails, return the tail (for the base case)` <br/> `      ⊑𝕩                           # The first element of the list` <br/> `        𝕤{      ...      }         # Call the inner function with parameters` <br/> `                                   #  - 𝕩: result of recursive call` <br/> `                                   #  - 𝕨: first element` <br/> `                                   #  - 𝔽: a reference to the outer function` <br/> `          =𝕨?<list>;<int>          #   Conditional, the rank of 𝕨 is 0 for ints and 1 for lists` <br/> `                 𝔽𝕨                #   If 𝕨 is a list, call 𝔽 on that ` <br/> `             𝕩∾˜⋈                  #   And insert the result in the front of 𝕩` <br/> `                      0∾𝕩          #   If 𝕨 is an integer, prepend 0 to the list 𝕩` <br/> `                    𝕨+             #   And add 𝕨 to each integer in the resulting nested list` |
| [Charcoal](https://codegolf.stackexchange.com/questions/240612/scan-a-ragged-list/240632#240632) | | 51b | `⊞υ⊞Ｏθ⁰Ｆυ«≔⊟ιηＦＬι«≔§ικζ¿⁼ζ⁺ζ⟦⟧⊞υ⊞Ｏζη«≧⁺ζη§≔ικη»»»⭆¹θ` |

## [find-the-first-duplicated-element](https://codegolf.stackexchange.com/questions/136713/find-the-first-duplicated-element)

| language | rank | bytes | code |
|----------|------|-------|------|
| Myby | | 3b | `{#}/` |
| [Husk](https://codegolf.stackexchange.com/questions/136713/find-the-first-duplicated-element/149578#149578) | | 4b | `←Ṡ-u` |
| [Jelly](https://codegolf.stackexchange.com/questions/136713/find-the-first-duplicated-element/149484#149484) | | 4b | `ŒQi0` |
| [Vyxal](https://codegolf.stackexchange.com/questions/136713/find-the-first-duplicated-element/252735#252735) | | 4b | `UÞ⊍h` |
| [Brachylog](https://codegolf.stackexchange.com/questions/136713/find-the-first-duplicated-element/149546#149546) | | 5b | `a⊇=bh` |
| [Japt `-æ`](https://codegolf.stackexchange.com/questions/136713/find-the-first-duplicated-element/235629#235629) | | 5b | `VaWbU` |
| [Pyth](https://codegolf.stackexchange.com/questions/136713/find-the-first-duplicated-element/136745#136745) | | 5b | `h.-Q{` |
| [Japt](https://codegolf.stackexchange.com/questions/136713/find-the-first-duplicated-element/136730#136730) | | 7b | `æ@bX ¦Y` |
| [MATL](https://codegolf.stackexchange.com/questions/136713/find-the-first-duplicated-element/136722#136722) | | 8b | `&=Rsqf1)` |
| [APL (Dyalog)](https://codegolf.stackexchange.com/questions/136713/find-the-first-duplicated-element/137497#137497) | | 11b | `⊢⊃⍨⍬⍴⍳∘≢~⍳⍨` |
| [J](https://codegolf.stackexchange.com/questions/136713/find-the-first-duplicated-element/136992#136992) | | 12b | `,&_1{~~:i.0:` |
| [K4](https://codegolf.stackexchange.com/questions/136713/find-the-first-duplicated-element/149564#149564) | | 12b | `*<0W^*:'1_'=` |
| [Pip](https://codegolf.stackexchange.com/questions/136713/find-the-first-duplicated-element/235631#235631) | | 13b | `Tg@iNgHiUig@i` |
| [APL](https://codegolf.stackexchange.com/questions/136713/find-the-first-duplicated-element/137189#137189) | | 15b | `{⊃⍵[(⍳⍴⍵)~⍵⍳⍵]}` |
| [05AB1E](https://codegolf.stackexchange.com/questions/136713/find-the-first-duplicated-element/137412#137412) | | 16b | `ε¹SsQƶ0K1è}W<¹sè` |
| [APL (Dyalog Classic)](https://codegolf.stackexchange.com/questions/136713/find-the-first-duplicated-element/137174#137174) | | 18b | `w[⊃(⍳∘≢~⍳⍨)w←¯1,⎕]` |
| [K (ngn/k)](https://codegolf.stackexchange.com/questions/136713/find-the-first-duplicated-element/252753#252753) | | 18b | `{x@({+/y=x}':x)?1}` |
| [APL NARS](https://codegolf.stackexchange.com/questions/136713/find-the-first-duplicated-element/149477#149477) | | 104b | `f←{1≠⍴⍴⍵:¯1⋄v←(⍵⍳⍵)-⍳⍴⍵⋄m←v⍳(v<0)/v⋄m≡⍬:¯1⋄(1⌷m)⌷⍵}` |

## [number-to-string-in-aaaaa-way](https://codegolf.stackexchange.com/questions/252758/number-to-string-in-aaaaa-way)

| language | rank | bytes | code |
|----------|------|-------|------|
| [Nibbles](https://codegolf.stackexchange.com/questions/252758/number-to-string-in-aaaaa-way/252776#252776) | | 5b | ``` &"A"5+'`' ``` |
| Myby | | 8b | `5&P {" ('A' + L)` |
| [Vyxal](https://codegolf.stackexchange.com/questions/252758/number-to-string-in-aaaaa-way/252763#252763) | | 8b | `øA∑\A5ø↳` |
| [Japt](https://codegolf.stackexchange.com/questions/252758/number-to-string-in-aaaaa-way/252760#252760) | | 9b | `c+48 ù'A5` |
| [Pyth](https://codegolf.stackexchange.com/questions/252758/number-to-string-in-aaaaa-way/252835#252835) | | 9b | `.[\A5m@Gt` |
| [05AB1E](https://codegolf.stackexchange.com/questions/252758/number-to-string-in-aaaaa-way/252771#252771) | | 11b | `₃+>çΔ'Aš5.£` |
| [Fig](https://codegolf.stackexchange.com/questions/252758/number-to-string-in-aaaaa-way/252880#252880) | | 11.524b | `$t5$J*/A5OC+96` |
| [MathGolf](https://codegolf.stackexchange.com/questions/252758/number-to-string-in-aaaaa-way/252775#252775) | | 12b | `(h5,'A*\É▄\§` |
| [APL (Dyalog Extended)](https://codegolf.stackexchange.com/questions/252758/number-to-string-in-aaaaa-way/252759#252759) | | 13b | `'A'@=¯5↑⎕⊇⌊⎕A` |
| [Charcoal](https://codegolf.stackexchange.com/questions/252758/number-to-string-in-aaaaa-way/252780#252780) | | 13b | `✂⁺×⁴A⭆Ｓ§β⊖ι±⁵` |
| [K (ngn/k)](https://codegolf.stackexchange.com/questions/252758/number-to-string-in-aaaaa-way/252844#252844) | | 13b | ``` "A"^-5$`c$96+ ``` |
| [BQN](https://codegolf.stackexchange.com/questions/252758/number-to-string-in-aaaaa-way/252792#252792) | | 15b | ``` ¯5↑"AAAA"∾+⟜'`' ``` |
| [Jelly](https://codegolf.stackexchange.com/questions/252758/number-to-string-in-aaaaa-way/252854#252854) | | 15b | `DịØa;@”Ax5¤Uḣ5U` |
| [K](https://codegolf.stackexchange.com/questions/252758/number-to-string-in-aaaaa-way/254596#254596) | | 18b | `"A"^-5$10h$96+10\:` |
| [J](https://codegolf.stackexchange.com/questions/252758/number-to-string-in-aaaaa-way/252876#252876) | | 29b | `'Aabcdefghi'{~],~[:0"0[:i.5-#` |
| [J-uby](https://codegolf.stackexchange.com/questions/252758/number-to-string-in-aaaaa-way/252798#252798) | | 34b | `:*&(:+&96|:chr)|:join|~:rjust&?A&5` |

## [appending-string-lengths](https://codegolf.stackexchange.com/questions/103377/appending-string-lengths)

| language | rank | bytes | code |
|----------|------|-------|------|
| [05AB1E](https://codegolf.stackexchange.com/questions/103377/appending-string-lengths/255215#255215) | | 4b | `3Fg«` |
| Myby | | 5.5b | `#+#+@+#+@++` |
| [Vyxal](https://codegolf.stackexchange.com/questions/103377/appending-string-lengths/252736#252736) | | 6b | `LJL+LJ` |
| [Pyth](https://codegolf.stackexchange.com/questions/103377/appending-string-lengths/103398#103398) | | 7b | `+Qfql+Q` |
| [Pip](https://codegolf.stackexchange.com/questions/103377/appending-string-lengths/252744#252744) | | 8b | `L3Ya.#yy` |
| [Pyke](https://codegolf.stackexchange.com/questions/103377/appending-string-lengths/103382#103382) | | 8b | `.f+liq)+` |
| [MATL](https://codegolf.stackexchange.com/questions/103377/appending-string-lengths/103379#103379) | | 11b | ``` `G@Vhtn@>]& ``` |
| [Jelly](https://codegolf.stackexchange.com/questions/103377/appending-string-lengths/104527#104527) | | 12b | `D;³L=` <br/> `LÇ1#;@` |
| [Brachylog](https://codegolf.stackexchange.com/questions/103377/appending-string-lengths/103444#103444) | | 13b | `l<L$@:?rc.lL,` |
| [K (ngn/k)](https://codegolf.stackexchange.com/questions/103377/appending-string-lengths/252756#252756) | | 31b | `{$[9>t:#x;x,$1+t;x,$#x,($1+t)]}` |

## [concatenating-n-with-n-1](https://codegolf.stackexchange.com/questions/167818/concatenating-n-with-n-1)

| language | rank | bytes | code |
|----------|------|-------|------|
| [Jelly](https://codegolf.stackexchange.com/questions/167818/concatenating-n-with-n-1/167946#167946) | | 3b | `ŻVƝ` |
| [MathGolf](https://codegolf.stackexchange.com/questions/167818/concatenating-n-with-n-1/172668#172668) | | 4b | `{└§p` |
| Myby | | 4b | `R +&.<" ^` |
| [Vyxal](https://codegolf.stackexchange.com/questions/167818/concatenating-n-with-n-1/252871#252871) | | 4b | `ƛ‹p⌊` |
| [Japt](https://codegolf.stackexchange.com/questions/167818/concatenating-n-with-n-1/167920#167920) | | 5b | `õÈsiY` |
| [Japt `-m`](https://codegolf.stackexchange.com/questions/167818/concatenating-n-with-n-1/167840#167840) | | 5b | `ó2 ¬n` |
| [05AB1E](https://codegolf.stackexchange.com/questions/167818/concatenating-n-with-n-1/167856#167856) | | 6b | `>GNJ,N` |
| [Brachylog](https://codegolf.stackexchange.com/questions/167818/concatenating-n-with-n-1/167859#167859) | | 6b | `⟦s₂ᶠcᵐ` |
| [Canvas](https://codegolf.stackexchange.com/questions/167818/concatenating-n-with-n-1/167821#167821) | | 6b | `ŗ²；＋┤］` |
| [Panacea](https://codegolf.stackexchange.com/questions/167818/concatenating-n-with-n-1/167919#167919) | | 6b | `re` <br/> `D>j` |
| [Pyth](https://codegolf.stackexchange.com/questions/167818/concatenating-n-with-n-1/168040#168040) | | 6b | ``` ms+`dh ``` |
| [Fig](https://codegolf.stackexchange.com/questions/167818/concatenating-n-with-n-1/252878#252878) | | 6.585b | `Mrx'_Jx}` |
| [APL (Dyalog Classic)](https://codegolf.stackexchange.com/questions/167818/concatenating-n-with-n-1/167860#167860) | | 9b | `1,2,/⍕¨∘⍳` |
| [Husk](https://codegolf.stackexchange.com/questions/167818/concatenating-n-with-n-1/167869#167869) | | 9b | `mSöd+d←dḣ` |
| [MATL](https://codegolf.stackexchange.com/questions/167818/concatenating-n-with-n-1/167907#167907) | | 9b | `:"@qV@VhU` |
| [CJam](https://codegolf.stackexchange.com/questions/167818/concatenating-n-with-n-1/167849#167849) | | 11b | `{{_)s+si}%}` |
| [Gol><>](https://codegolf.stackexchange.com/questions/167818/concatenating-n-with-n-1/173507#173507) | | 11b | `IFLL?nLPN|;` |
| [cQuents](https://codegolf.stackexchange.com/questions/167818/concatenating-n-with-n-1/167824#167824) | | 11b | `=1::($-1)~$` |
| [APL (Dyalog)](https://codegolf.stackexchange.com/questions/167818/concatenating-n-with-n-1/167825#167825) | | 12b | `(⍎⍕,∘⍕1∘+)¨⍳` |
| [K (oK)](https://codegolf.stackexchange.com/questions/167818/concatenating-n-with-n-1/168077#168077) | | 12b | `,/'$1,2':1+!` |
| [K (ngn/k)](https://codegolf.stackexchange.com/questions/167818/concatenating-n-with-n-1/167819#167819) | | 13b | `{.,/$x+!2}'!:` |
| [J](https://codegolf.stackexchange.com/questions/167818/concatenating-n-with-n-1/167959#167959) | | 14b | `(,&.":>:)"0@i.` |
| [J-uby](https://codegolf.stackexchange.com/questions/167818/concatenating-n-with-n-1/252873#252873) | | 25b | `:*|:*&(-[I,:+&1]|:join|Z)` |

## [repeat-values-in-array](https://codegolf.stackexchange.com/questions/252442/repeat-values-in-array)

| language | rank | bytes | code |
|----------|------|-------|------|
| Myby | | 0.5b | `#` |
| [APL (Dyalog Unicode)](https://codegolf.stackexchange.com/questions/252442/repeat-values-in-array/252446#252446) | | 1b | `/` |
| [BQN](https://codegolf.stackexchange.com/questions/252442/repeat-values-in-array/252489#252489) | | 1b | `/` |
| [Husk](https://codegolf.stackexchange.com/questions/252442/repeat-values-in-array/252485#252485) | | 1b | `Ṙ` |
| [I](https://codegolf.stackexchange.com/questions/252442/repeat-values-in-array/252632#252632) | | 1b | `\` |
| [J](https://codegolf.stackexchange.com/questions/252442/repeat-values-in-array/252466#252466) | | 1b | `#` |
| [Jelly](https://codegolf.stackexchange.com/questions/252442/repeat-values-in-array/252443#252443) | | 1b | `x` |
| [05AB1E](https://codegolf.stackexchange.com/questions/252442/repeat-values-in-array/252468#252468) | | 2b | `ÅΓ` |
| [MATL](https://codegolf.stackexchange.com/questions/252442/repeat-values-in-array/252449#252449) | | 2b | `Y"` |
| [Pyth](https://codegolf.stackexchange.com/questions/252442/repeat-values-in-array/252455#252455) | | 3b | `r9C` |
| [K (ngn/k)](https://codegolf.stackexchange.com/questions/252442/repeat-values-in-array/252469#252469) | | 4b | `,/#'` |
| [Vyxal](https://codegolf.stackexchange.com/questions/252442/repeat-values-in-array/252445#252445) | | 4b | `¨£ẋf` |
| [Nibbles](https://codegolf.stackexchange.com/questions/252442/repeat-values-in-array/252559#252559) | | 4.5b | `+!$_~.,$_` |
| [Q](https://codegolf.stackexchange.com/questions/252442/repeat-values-in-array/254775#254775) | | 5b | `where` |
| [Japt](https://codegolf.stackexchange.com/questions/252442/repeat-values-in-array/252453#252453) | | 6b | `cÈÇYgV` |
| [MathGolf](https://codegolf.stackexchange.com/questions/252442/repeat-values-in-array/252481#252481) | | 7b | `mÅaam*─` |
| [Brachylog](https://codegolf.stackexchange.com/questions/252442/repeat-values-in-array/252562#252562) | | 9b | `z⟨kj₎t⟩ˢc` |
| [Charcoal](https://codegolf.stackexchange.com/questions/252442/repeat-values-in-array/252448#252448) | | 9b | `ＩΣＥθＥ§ηκι` |
| [Pip `-p`](https://codegolf.stackexchange.com/questions/252442/repeat-values-in-array/253564#253564) | | 16b | `{FA({aRLb}MZab)}` |

## [are-all-the-items-the-same](https://codegolf.stackexchange.com/questions/224000/are-all-the-items-the-same)

| language | rank | bytes | code |
|----------|------|-------|------|
| Myby | | 1b | `e.` |
| [Fig](https://codegolf.stackexchange.com/questions/224000/are-all-the-items-the-same/252543#252543) | | 1.646b | `LU` |
| [Arn](https://codegolf.stackexchange.com/questions/224000/are-all-the-items-the-same/224005#224005) | | 2b | `:@` |
| [Husk](https://codegolf.stackexchange.com/questions/224000/are-all-the-items-the-same/224348#224348) | | 2b | `hg` |
| [Jelly](https://codegolf.stackexchange.com/questions/224000/are-all-the-items-the-same/224011#224011) | | 2b | `IẸ` |
| [Pyth](https://codegolf.stackexchange.com/questions/224000/are-all-the-items-the-same/224012#224012) | | 2b | `l{` |
| [Japt](https://codegolf.stackexchange.com/questions/224000/are-all-the-items-the-same/224064#224064) | | 3b | `â l` |
| [K (ngn/k)](https://codegolf.stackexchange.com/questions/224000/are-all-the-items-the-same/252571#252571) | | 3b | `#?:` |
| [Pip](https://codegolf.stackexchange.com/questions/224000/are-all-the-items-the-same/224022#224022) | | 3b | `$=g` |
| [GolfScript](https://codegolf.stackexchange.com/questions/224000/are-all-the-items-the-same/226305#226305) | | 4b | `~.&,` |
| [K (oK)](https://codegolf.stackexchange.com/questions/224000/are-all-the-items-the-same/224788#224788) | | 4b | `1=#?` |
| [APL (Dyalog Unicode)](https://codegolf.stackexchange.com/questions/224000/are-all-the-items-the-same/224300#224300) | | 5b | `×/⊢=⊃` <br/> `×/ ⍝ product reduce` <br/> `  ⊢=⊃ ⍝ three train, each element equal to first element` |
| [Charcoal](https://codegolf.stackexchange.com/questions/224000/are-all-the-items-the-same/224068#224068) | | 5b | `⁼⌊θ⌈θ` |
| [J](https://codegolf.stackexchange.com/questions/224000/are-all-the-items-the-same/247055#247055) | | 6b | `1=#&~.` |
| [J-uby](https://codegolf.stackexchange.com/questions/224000/are-all-the-items-the-same/252831#252831) | | 15b | `:uniq|~:[]&1|:!` |

## [modulus-summation](https://codegolf.stackexchange.com/questions/150563/modulus-summation)

| language | rank | bytes | code |
|----------|------|-------|------|
| [05AB1E](https://codegolf.stackexchange.com/questions/150563/modulus-summation/150584#150584) | | 3b | `L%O` |
| [Japt `-mx`](https://codegolf.stackexchange.com/questions/150563/modulus-summation/170935#170935) | | 3b | `N%U` |
| [Jelly](https://codegolf.stackexchange.com/questions/150563/modulus-summation/150564#150564) | | 3b | `%RS` |
| [Neim](https://codegolf.stackexchange.com/questions/150563/modulus-summation/150603#150603) | | 3b | `𝐈𝕄𝐬` |
| [Vyxal](https://codegolf.stackexchange.com/questions/150563/modulus-summation/230058#230058) | | 3b | `ɽ%∑` |
| Myby | | 3.5b | `+\ # %" ^` |
| [MATL](https://codegolf.stackexchange.com/questions/150563/modulus-summation/150590#150590) | | 4b | `t:\s` |
| [Ohm v2](https://codegolf.stackexchange.com/questions/150563/modulus-summation/150589#150589) | | 4b | `D@%Σ` |
| [APL (Dyalog)](https://codegolf.stackexchange.com/questions/150563/modulus-summation/150612#150612) | | 5b | `+/⍳|⊢` |
| [Husk](https://codegolf.stackexchange.com/questions/150563/modulus-summation/150571#150571) | | 5b | `ΣṠM%ḣ` |
| [Japt](https://codegolf.stackexchange.com/questions/150563/modulus-summation/150572#150572) | | 5b | `Æ%XÃx` |
| [Pyth](https://codegolf.stackexchange.com/questions/150563/modulus-summation/150578#150578) | | 5b | `s%LQS` |
| [Pip](https://codegolf.stackexchange.com/questions/150563/modulus-summation/150598#150598) | | 7b | `$+a%\,a` |
| [Gaia](https://codegolf.stackexchange.com/questions/150563/modulus-summation/150642#150642) | | 8b | `@:…)¦%¦Σ` |
| [Brachylog](https://codegolf.stackexchange.com/questions/150563/modulus-summation/170973#170973) | | 9b | `⟨gz⟦₆⟩%ᵐ+` |
| [Charcoal](https://codegolf.stackexchange.com/questions/150563/modulus-summation/150586#150586) | | 9b | `ＩΣＥＮ﹪Ｉθ⊕ι` |
| [J](https://codegolf.stackexchange.com/questions/150563/modulus-summation/150593#150593) | | 9b | `-~1#.i.|]` |
| [APL+WIN](https://codegolf.stackexchange.com/questions/150563/modulus-summation/150610#150610) | | 10b | `+/(⍳n)|n←⎕` |
| [K (ngn/k)](https://codegolf.stackexchange.com/questions/150563/modulus-summation/252786#252786) | | 16b | `{+/{x!g}'1+!g-1}` |
| [J-uby](https://codegolf.stackexchange.com/questions/150563/modulus-summation/252747#252747) | | 24b | `(:-&(:& &:%|:+&:sum))%:+` |

## [implement-an-argwhere-function](https://codegolf.stackexchange.com/questions/241357/implement-an-argwhere-function)

| language | rank | bytes | code |
|----------|------|-------|------|
| [Fig](https://codegolf.stackexchange.com/questions/241357/implement-an-argwhere-function/252929#252929) | | 1.646b | `TM` |
| [Japt](https://codegolf.stackexchange.com/questions/241357/implement-an-argwhere-function/252928#252928) | | 2b | `ðV` |
| [Vyxal](https://codegolf.stackexchange.com/questions/241357/implement-an-argwhere-function/241359#241359) | | 2b | `MT` |
| [APL (Dyalog Unicode)](https://codegolf.stackexchange.com/questions/241357/implement-an-argwhere-function/241372#241372) | | 4b | `⍸⎕¨⎕` |
| [Husk](https://codegolf.stackexchange.com/questions/241357/implement-an-argwhere-function/241371#241371) | | 4b | ``` `fNm ``` |
| Myby | | 4.5b | `R@+ # F:"` |
| [05AB1E](https://codegolf.stackexchange.com/questions/241357/implement-an-argwhere-function/241362#241362) | | 6b | `δ.Vƶ0K` |
| [K (ngn/k)](https://codegolf.stackexchange.com/questions/241357/implement-an-argwhere-function/252828#252828) | | 6b | `{&x'y}` |
| [Pip `-xp`](https://codegolf.stackexchange.com/questions/241357/implement-an-argwhere-function/241430#241430) | | 7b | `bMa@*:1` |
| [J](https://codegolf.stackexchange.com/questions/241357/implement-an-argwhere-function/252935#252935) | | 11b | `1 :'I.u"+y'` |
| [J-uby](https://codegolf.stackexchange.com/questions/241357/implement-an-argwhere-function/252681#252681) | | 31b | `->a,f{:select+(:[]&a|f)^(+a).*}` |

## [remove-odd-indices-and-double-the-even-indices](https://codegolf.stackexchange.com/questions/241267/remove-odd-indices-and-double-the-even-indices)

| language | rank | bytes | code |
|----------|------|-------|------|
| [Vyxal](https://codegolf.stackexchange.com/questions/241267/remove-odd-indices-and-double-the-even-indices/241275#241275) | | 3b | `y2•` |
| [Fig](https://codegolf.stackexchange.com/questions/241267/remove-odd-indices-and-double-the-even-indices/253037#253037) | | 3.292b | `eh]y` |
| [05AB1E](https://codegolf.stackexchange.com/questions/241267/remove-odd-indices-and-double-the-even-indices/241273#241273) | | 4b | `ιθºS` |
| [Jelly](https://codegolf.stackexchange.com/questions/241267/remove-odd-indices-and-double-the-even-indices/241268#241268) | | 4b | `Ḋm2Ḥ` |
| Myby | | 4b | `# # + # 0 2` |
| [Husk](https://codegolf.stackexchange.com/questions/241267/remove-odd-indices-and-double-the-even-indices/241284#241284) | | 5b | `Ṙ2Ċ2t` |
| [Japt](https://codegolf.stackexchange.com/questions/241267/remove-odd-indices-and-double-the-even-indices/241304#241304) | | 5b | `Åë m²` |
| [MathGolf](https://codegolf.stackexchange.com/questions/241267/remove-odd-indices-and-double-the-even-indices/241277#241277) | | 5b | `{ï¥∞*` |
| [Pyth](https://codegolf.stackexchange.com/questions/241267/remove-odd-indices-and-double-the-even-indices/253007#253007) | | 6b | `.i=%2t` |
| [Charcoal](https://codegolf.stackexchange.com/questions/241267/remove-odd-indices-and-double-the-even-indices/241291#241291) | | 8b | `⭆Ｓ×ι⊗﹪κ²` |
| [J](https://codegolf.stackexchange.com/questions/241267/remove-odd-indices-and-double-the-even-indices/241289#241289) | | 8b | `#~0 2$~#` |
| [ayr](https://codegolf.stackexchange.com/questions/241267/remove-odd-indices-and-double-the-even-indices/241283#241283) | | 8b | ``` ]#0 2$`# ``` |
| [BQN](https://codegolf.stackexchange.com/questions/241267/remove-odd-indices-and-double-the-even-indices/241331#241331) | | 9b | `⊢/˜≠⥊0‿2˙` |
| [K (ngn/k)](https://codegolf.stackexchange.com/questions/241267/remove-odd-indices-and-double-the-even-indices/253018#253018) | | 10b | `(2*2!!#:)#` |
| [APL (Dyalog Unicode)](https://codegolf.stackexchange.com/questions/241267/remove-odd-indices-and-double-the-even-indices/241294#241294) | | 12b | `{⍵/⍨0 2⍴⍨≢⍵}` |
| [APL+WIN](https://codegolf.stackexchange.com/questions/241267/remove-odd-indices-and-double-the-even-indices/241279#241279) | | 14b | `2/(~2|⍳⍴m)/m←⍞` |
| [J-uby](https://codegolf.stackexchange.com/questions/241267/remove-odd-indices-and-double-the-even-indices/252979#252979) | | 21b | `~:gsub&'\1\1'&/.(.)?/` |

## [separate-a-list-into-even-indexed-and-odd-indexed-parts](https://codegolf.stackexchange.com/questions/64315/separate-a-list-into-even-indexed-and-odd-indexed-parts)

| language | rank | bytes | code |
|----------|------|-------|------|
| [Japt](https://codegolf.stackexchange.com/questions/64315/separate-a-list-into-even-indexed-and-odd-indexed-parts/180297#180297) | | 1b | `ó` |
| [Fig](https://codegolf.stackexchange.com/questions/64315/separate-a-list-into-even-indexed-and-odd-indexed-parts/253116#253116) | | 1.646b | `fy` |
| [05AB1E](https://codegolf.stackexchange.com/questions/64315/separate-a-list-into-even-indexed-and-odd-indexed-parts/220744#220744) | | 2b | `ι˜` |
| [Jelly](https://codegolf.stackexchange.com/questions/64315/separate-a-list-into-even-indexed-and-odd-indexed-parts/145396#145396) | | 3b | `ŒœF` |
| Myby | | 3.5b | `*@^ /&2` |
| [Husk](https://codegolf.stackexchange.com/questions/64315/separate-a-list-into-even-indexed-and-odd-indexed-parts/216349#216349) | | 4b | `ΣTC2` |
| [Pyth](https://codegolf.stackexchange.com/questions/64315/separate-a-list-into-even-indexed-and-odd-indexed-parts/64324#64324) | | 5b | `o~!ZQ` |
| [CJam](https://codegolf.stackexchange.com/questions/64315/separate-a-list-into-even-indexed-and-odd-indexed-parts/64317#64317) | | 7b | `{2/ze_}` |
| [J](https://codegolf.stackexchange.com/questions/64315/separate-a-list-into-even-indexed-and-odd-indexed-parts/64331#64331) | | 8b | `/:0 1$~#` |
| [K](https://codegolf.stackexchange.com/questions/64315/separate-a-list-into-even-indexed-and-odd-indexed-parts/64402#64402) | | 10b | `{x@<2!!#x}` |
| [APL (Dyalog Unicode)](https://codegolf.stackexchange.com/questions/64315/separate-a-list-into-even-indexed-and-odd-indexed-parts/216780#216780) | | 11b | `{⍵[⍒2|⍳≢⍵]}` |
| [K (ngn/k)](https://codegolf.stackexchange.com/questions/64315/separate-a-list-into-even-indexed-and-odd-indexed-parts/252991#252991) | | 21b | `{t,x^t:x@&(0=2!)'!#x}` |
| [𝔼𝕊𝕄𝕚𝕟](https://codegolf.stackexchange.com/questions/64315/separate-a-list-into-even-indexed-and-odd-indexed-parts/64366#64366) | | 22b | `Ѩťᶏש,Ѩą(ï,2⸩` |

## [count-the-changes-in-an-array](https://codegolf.stackexchange.com/questions/146402/count-the-changes-in-an-array)

| language | rank | bytes | code |
|----------|------|-------|------|
| [Gaia](https://codegolf.stackexchange.com/questions/146402/count-the-changes-in-an-array/147132#147132) | | 2b | `ėl` |
| [Japt `-x`](https://codegolf.stackexchange.com/questions/146402/count-the-changes-in-an-array/252809#252809) | | 2b | `ä¦` |
| [MATL](https://codegolf.stackexchange.com/questions/146402/count-the-changes-in-an-array/146407#146407) | | 2b | `dz` |
| [05AB1E](https://codegolf.stackexchange.com/questions/146402/count-the-changes-in-an-array/146414#146414) | | 3b | `¥ĀO` |
| [Husk](https://codegolf.stackexchange.com/questions/146402/count-the-changes-in-an-array/146455#146455) | | 3b | `Ltg` |
| [Jelly](https://codegolf.stackexchange.com/questions/146402/count-the-changes-in-an-array/146403#146403) | | 3b | `ITL` |
| [Ohm v2](https://codegolf.stackexchange.com/questions/146402/count-the-changes-in-an-array/146430#146430) | | 3b | `ΔyΣ` |
| [Vyxal](https://codegolf.stackexchange.com/questions/146402/count-the-changes-in-an-array/253432#253432) | | 3b | `¯ꜝL` |
| [Pyke](https://codegolf.stackexchange.com/questions/146402/count-the-changes-in-an-array/146573#146573) | | 4b | `$0-l` |
| [Pyth](https://codegolf.stackexchange.com/questions/146402/count-the-changes-in-an-array/146459#146459) | | 4b | `ltr8` |
| Myby | | 5b | `+\ 2 ~:\\. #` |
| [Japt](https://codegolf.stackexchange.com/questions/146402/count-the-changes-in-an-array/146453#146453) | | 6b | `ä- è¦0` |
| [APL (Dyalog)](https://codegolf.stackexchange.com/questions/146402/count-the-changes-in-an-array/146432#146432) | | 8b | `+/2≠/⊃,⊢` |
| [K (oK)](https://codegolf.stackexchange.com/questions/146402/count-the-changes-in-an-array/146410#146410) | | 8b | `+/1_~~':` |
| [J](https://codegolf.stackexchange.com/questions/146402/count-the-changes-in-an-array/146457#146457) | | 10b | `[:+/2~:/\]` |
| [J-uby](https://codegolf.stackexchange.com/questions/146402/count-the-changes-in-an-array/252807#252807) | | 21b | `:chunk+I|~:drop&1|:+@` |

## [twisting-words](https://codegolf.stackexchange.com/questions/55051/twisting-words)

| language | rank | bytes | code |
|----------|------|-------|------|
| [Vyxal `jr`](https://codegolf.stackexchange.com/questions/55051/twisting-words/253150#253150) | | 5b | `ẇ↲⁽Ṙẇ` |
| [Jelly](https://codegolf.stackexchange.com/questions/55051/twisting-words/210474#210474) | | 8b | `sz⁶ZUÐeY` |
| [Japt `-R`](https://codegolf.stackexchange.com/questions/55051/twisting-words/210402#210402) | | 9b | `òV ËzEÑÃù` |
| Myby | | 10b | ``` '\n' * (#`-" (P #\.~ - H)) ``` |
| [J](https://codegolf.stackexchange.com/questions/55051/twisting-words/210403#210403) | | 13b | ``` ]`|."1@(]\)~- ``` |
| [Japt](https://codegolf.stackexchange.com/questions/55051/twisting-words/165021#165021) | | 14b | `óV y £Yv ?X:Xw` |
| [Pyth](https://codegolf.stackexchange.com/questions/55051/twisting-words/55055#55055) | | 15b | `VPc+z*dQQ_W~!ZN` |
| [APL (Dyalog Unicode)](https://codegolf.stackexchange.com/questions/55051/twisting-words/164722#164722) | | 19b | `{↑⊢∘⌽\↓↑⍵⊆⍨⌈⍺÷⍨⍳≢⍵}` |
| [CJam](https://codegolf.stackexchange.com/questions/55051/twisting-words/55056#55056) | | 19b | `q~1$S*+/W<{(N@Wf%}h` |
| [Brachylog](https://codegolf.stackexchange.com/questions/55051/twisting-words/210476#210476) | | 20b | `⟨{ġ|,Ṣ↰}lᵛ⟩{i↔ⁱ⁾}ᶠ~ṇ` |
| [05AB1E](https://codegolf.stackexchange.com/questions/55051/twisting-words/210457#210457) | | 22b | `ô0UεRDg²s-úXÈiR}X>U}}»` |
| [Pip](https://codegolf.stackexchange.com/questions/55051/twisting-words/210419#210419) | | 34b | `Fla.sXb-#(@RVa<>b)<>b{Po?lRVlo!:o}` |
| [Stuck](https://codegolf.stackexchange.com/questions/55051/twisting-words/55065#55065) | | 38b | `tg;_lu_@%u;-_0G<*' *+0GKE"];2%;Y_Y?p":` |
| [Q](https://codegolf.stackexchange.com/questions/55051/twisting-words/55119#55119) | | 46b | `{-1@neg[y]$@[a;(&)(til(#)a:y cut x)mod 2;|:];}` |
| [O](https://codegolf.stackexchange.com/questions/55051/twisting-words/55122#55122) | | 60b | ``` z""/rlJ(Q/{n:x;Q({+}dxe{`}{}?p}drQJQ%-{' }dJQ/e{r}{}?Q({o}dp ``` |

## [determine-the-color-of-a-chess-square](https://codegolf.stackexchange.com/questions/63772/determine-the-color-of-a-chess-square)

| language | rank | bytes | code |
|----------|------|-------|------|
| [Fig](https://codegolf.stackexchange.com/questions/63772/determine-the-color-of-a-chess-square/253073#253073) | | 9.054b | `iHD,[jn("OS` |
| [05AB1E](https://codegolf.stackexchange.com/questions/63772/determine-the-color-of-a-chess-square/205724#205724) | | 11b | `“–°‡Ž“#IÇOè` |
| [Jelly](https://codegolf.stackexchange.com/questions/63772/determine-the-color-of-a-chess-square/148047#148047) | | 11b | `OḂEị“_ß“ṗɠ»` |
| [Stax](https://codegolf.stackexchange.com/questions/63772/determine-the-color-of-a-chess-square/205726#205726) | | 11b | `ÄºÉ╨φr°mißâ` |
| [Vyxal](https://codegolf.stackexchange.com/questions/63772/determine-the-color-of-a-chess-square/243039#243039) | | 11b | ``` C∑₂`⟇ǎ↔β`½i ``` |
| [Keg](https://codegolf.stackexchange.com/questions/63772/determine-the-color-of-a-chess-square/205200#205200) | | 12b | `+2%[‘15‘|‘1⑻` |
| [05AB1E (legacy)](https://codegolf.stackexchange.com/questions/63772/determine-the-color-of-a-chess-square/177996#177996) | | 13b | `“–°‡Ž“#I35öÈè` |
| [GS2](https://codegolf.stackexchange.com/questions/63772/determine-the-color-of-a-chess-square/63779#63779) | | 15b | `de♦dark•light♠5` |
| Myby | | 15.5b | `+\@> { 'dark' , 'light'` |
| [Japt](https://codegolf.stackexchange.com/questions/63772/determine-the-color-of-a-chess-square/165884#165884) | | 16b | ``` `äKrk`qe g~Uxc ``` |
| [K (oK)](https://codegolf.stackexchange.com/questions/63772/determine-the-color-of-a-chess-square/148016#148016) | | 16b | ``` `dark`light 2!+/ ``` |
| [O](https://codegolf.stackexchange.com/questions/63772/determine-the-color-of-a-chess-square/63998#63998) | | 17b | `i#2%"light'dark"?` |
| [CJam](https://codegolf.stackexchange.com/questions/63772/determine-the-color-of-a-chess-square/63773#63773) | | 18b | `r:-)"lightdark"5/=` |
| [Pyth](https://codegolf.stackexchange.com/questions/63772/determine-the-color-of-a-chess-square/63776#63776) | | 18b | `@c2"lightdark"iz35` |
| [Seriously](https://codegolf.stackexchange.com/questions/63772/determine-the-color-of-a-chess-square/63775#63775) | | 19b | `"dark""light"2,O+%I` |
| [MATL](https://codegolf.stackexchange.com/questions/63772/determine-the-color-of-a-chess-square/67092#67092) | | 20b | `js2\?'light'}'dark']` |
| [GolfScript](https://codegolf.stackexchange.com/questions/63772/determine-the-color-of-a-chess-square/63973#63973) | | 21b | `{^}*~1&"lightdark"5/=` |
| [Gol><>](https://codegolf.stackexchange.com/questions/63772/determine-the-color-of-a-chess-square/63807#63807) | | 22b | `ii+2%Q"thgil"H|"krad"H` |
| [TeaScript](https://codegolf.stackexchange.com/questions/63772/determine-the-color-of-a-chess-square/63789#63789) | | 23b | `®x,35)%2?"dark":"light"` |
| [APL (Dyalog Unicode)](https://codegolf.stackexchange.com/questions/63772/determine-the-color-of-a-chess-square/177999#177999) | | 24b | `⊃'dark' 'light'⌽⍨+/⎕UCS⍞` |
| [K (ngn/k)](https://codegolf.stackexchange.com/questions/63772/determine-the-color-of-a-chess-square/253074#253074) | | 25b | `{$[2!+/x;"light";"dark"]}` |
| [𝔼𝕊𝕄𝕚𝕟](https://codegolf.stackexchange.com/questions/63772/determine-the-color-of-a-chess-square/63805#63805) | | 34b | ``` ô(שǀ(ï,ḣ)%2?`dark`:`light” ``` |
| [J](https://codegolf.stackexchange.com/questions/63772/determine-the-color-of-a-chess-square/243032#243032) | | 37b | `>@{&('dark';'light')@{:@#:@+/@(a.&i.)` |

## [is-this-word-lexically-ordered](https://codegolf.stackexchange.com/questions/108675/is-this-word-lexically-ordered)

| language | rank | bytes | code |
|----------|------|-------|------|
| [Vyxal](https://codegolf.stackexchange.com/questions/108675/is-this-word-lexically-ordered/253240#253240) | | 2b | `ÞȮ` |
| [√ å ı ¥ ® Ï Ø ¿](https://codegolf.stackexchange.com/questions/108675/is-this-word-lexically-ordered/112720#112720) | | 3b | `Ißo` |
| [05AB1E](https://codegolf.stackexchange.com/questions/108675/is-this-word-lexically-ordered/108676#108676) | | 5b | `Â)¤{å` |
| [Brachylog](https://codegolf.stackexchange.com/questions/108675/is-this-word-lexically-ordered/112473#112473) | | 5b | `:No₎?` |
| [Jelly](https://codegolf.stackexchange.com/questions/108675/is-this-word-lexically-ordered/108706#108706) | | 5b | `Ṣm0ẇ@` |
| [Pyke](https://codegolf.stackexchange.com/questions/108675/is-this-word-lexically-ordered/108703#108703) | | 5b | `SD_]{` |
| [Pyth](https://codegolf.stackexchange.com/questions/108675/is-this-word-lexically-ordered/108714#108714) | | 5b | `}SQ,_` |
| Myby | | 5.5b | `%&./ e. # , -` |
| [MATL](https://codegolf.stackexchange.com/questions/108675/is-this-word-lexically-ordered/108704#108704) | | 7b | `dZSuz2<` |
| [APL (Dyalog Unicode)](https://codegolf.stackexchange.com/questions/108675/is-this-word-lexically-ordered/157476#157476) | | 9b | `∨/⍬∘⍋⍷⍒,⍋` |
| [CJam](https://codegolf.stackexchange.com/questions/108675/is-this-word-lexically-ordered/108697#108697) | | 11b | `q_$_W%+\#)g` |
| [APL NARS](https://codegolf.stackexchange.com/questions/108675/is-this-word-lexically-ordered/150956#150956) | | 19b | `{(⊂⍵[⍋⍵])∊(⊂⍵),⊂⌽⍵}` |
| [K (ngn/k)](https://codegolf.stackexchange.com/questions/108675/is-this-word-lexically-ordered/253260#253260) | | 19b | `{t:!#x;(t~<x)|t~>x}` |
| [Q](https://codegolf.stackexchange.com/questions/108675/is-this-word-lexically-ordered/151043#151043) | | 20b | `{x in(asc;desc)@\:x}` |

## [triangle-a-number](https://codegolf.stackexchange.com/questions/137632/triangle-a-number)

| language | rank | bytes | code |
|----------|------|-------|------|
| [Fig](https://codegolf.stackexchange.com/questions/137632/triangle-a-number/253164#253164) | | 1.646b | `Sk` |
| [Husk](https://codegolf.stackexchange.com/questions/137632/triangle-a-number/137655#137655) | | 2b | `Σ∫` |
| [Vyxal](https://codegolf.stackexchange.com/questions/137632/triangle-a-number/253140#253140) | | 2b | `¦∑` |
| [05AB1E](https://codegolf.stackexchange.com/questions/137632/triangle-a-number/137638#137638) | | 3b | `ηSO` |
| [Gaia](https://codegolf.stackexchange.com/questions/137632/triangle-a-number/137641#137641) | | 3b | `…_Σ` |
| [Jelly](https://codegolf.stackexchange.com/questions/137632/triangle-a-number/137650#137650) | | 3b | `+\S` |
| [MATL](https://codegolf.stackexchange.com/questions/137632/triangle-a-number/137646#137646) | | 3b | `Yss` |
| Myby | | 3b | `+\ +\\.` |
| [Neim](https://codegolf.stackexchange.com/questions/137632/triangle-a-number/137722#137722) | | 3b | `𝐗𝐂𝐬` |
| [APL](https://codegolf.stackexchange.com/questions/137632/triangle-a-number/137678#137678) | | 4b | `+/+\` |
| [Japt](https://codegolf.stackexchange.com/questions/137632/triangle-a-number/137633#137633) | | 4b | `å+ x` |
| [Pyth](https://codegolf.stackexchange.com/questions/137632/triangle-a-number/137647#137647) | | 4b | `ss._` |
| [J](https://codegolf.stackexchange.com/questions/137632/triangle-a-number/137668#137668) | | 6b | `1#.+/\` |
| [Pyt](https://codegolf.stackexchange.com/questions/137632/triangle-a-number/151755#151755) | | 6b | `ąĐŁř↔·` |
| [Gol><>](https://codegolf.stackexchange.com/questions/137632/triangle-a-number/161484#161484) | | 8b | `IEh@+:@+` |
| [K (ngn/k)](https://codegolf.stackexchange.com/questions/137632/triangle-a-number/253184#253184) | | 8b | `+/+\.'$:` |

## [bl-lu-ur-rr-ry-yv-vi-is-si-io-on-blur-the-text](https://codegolf.stackexchange.com/questions/203893/bl-lu-ur-rr-ry-yv-vi-is-si-io-on-blur-the-text)

| language | rank | bytes | code |
|----------|------|-------|------|
| [Husk](https://codegolf.stackexchange.com/questions/203893/bl-lu-ur-rr-ry-yv-vi-is-si-io-on-blur-the-text/203917#203917) | | 5b | `wX2f□` |
| [Japt v2.0a0 `-S`](https://codegolf.stackexchange.com/questions/203893/bl-lu-ur-rr-ry-yv-vi-is-si-io-on-blur-the-text/203925#203925) | | 6b | `r\W ä+` |
| [Jelly](https://codegolf.stackexchange.com/questions/203893/bl-lu-ur-rr-ry-yv-vi-is-si-io-on-blur-the-text/203911#203911) | | 6b | `fØB;ƝK` |
| Myby | | 6b | `' ' * 2 #\. alnumk` |
| [Stax](https://codegolf.stackexchange.com/questions/203893/bl-lu-ur-rr-ry-yv-vi-is-si-io-on-blur-the-text/203957#203957) | | 6b | `£Q·H°·` |
| [Vyxal](https://codegolf.stackexchange.com/questions/203893/bl-lu-ur-rr-ry-yv-vi-is-si-io-on-blur-the-text/229021#229021) | | 6b | `kr↔2lṄ` |
| [05AB1E](https://codegolf.stackexchange.com/questions/203893/bl-lu-ur-rr-ry-yv-vi-is-si-io-on-blur-the-text/203906#203906) | | 8b | `žKÃüJðý?` |
| [Pyth](https://codegolf.stackexchange.com/questions/203893/bl-lu-ur-rr-ry-yv-vi-is-si-io-on-blur-the-text/203896#203896) | | 14b | `jd.::Q"\W|_"k2` |
| [MATL](https://codegolf.stackexchange.com/questions/203893/bl-lu-ur-rr-ry-yv-vi-is-si-io-on-blur-the-text/203894#203894) | | 16b | `t8Y2m)2YC!Z{0&Zc` |
| [QuadR](https://codegolf.stackexchange.com/questions/203893/bl-lu-ur-rr-ry-yv-vi-is-si-io-on-blur-the-text/203955#203955) | | 18b | `1↓∊' ',¨2,/⍵` <br/> `\W|_` |
| [K (ngn/k)](https://codegolf.stackexchange.com/questions/203893/bl-lu-ur-rr-ry-yv-vi-is-si-io-on-blur-the-text/203899#203899) | | 21b | ``` " "/2':(2!"/9@Z`z"')_ ``` |
| [APL (NARS2000 dialect)](https://codegolf.stackexchange.com/questions/203893/bl-lu-ur-rr-ry-yv-vi-is-si-io-on-blur-the-text/220091#220091) | | 24b | `{¯1↓1↓⍕2,/⍵/⍨⍵∊A←⎕a,⎕A,⎕D}` |
| [Charcoal](https://codegolf.stackexchange.com/questions/203893/bl-lu-ur-rr-ry-yv-vi-is-si-io-on-blur-the-text/203902#203902) | | 26b | `≔ΦＳ№⁺α⁺β⭆χλιθ⪫Ｅ⊖Ｌθ✂θι⁺²ι¹` |
| [APL (Dyalog Unicode)](https://codegolf.stackexchange.com/questions/203893/bl-lu-ur-rr-ry-yv-vi-is-si-io-on-blur-the-text/203933#203933) | | 32b | `{¯2↓2↓⊃,/{⍵' '⍵}¨⍵∩⎕A,819⌶⎕A,⎕D}` |
| [J](https://codegolf.stackexchange.com/questions/203893/bl-lu-ur-rr-ry-yv-vi-is-si-io-on-blur-the-text/204364#204364) | | 32b | `[:}:[:,/2,&' '\]-.-.&AlphaNum_j_` |
| [Q](https://codegolf.stackexchange.com/questions/203893/bl-lu-ur-rr-ry-yv-vi-is-si-io-on-blur-the-text/203929#203929) | | 38b | `{" "sv -2_2#'next\[x inter .Q.an _52]}` |

## [new-password-idea-word-walker](https://codegolf.stackexchange.com/questions/165793/new-password-idea-word-walker)

| language | rank | bytes | code |
|----------|------|-------|------|
| [Stax](https://codegolf.stackexchange.com/questions/165793/new-password-idea-word-walker/165924#165924) | | 9b | `éñ~╗D¡┤Gq` |
| [05AB1E](https://codegolf.stackexchange.com/questions/165793/new-password-idea-word-walker/165806#165806) | | 11b | `#vyN©Fû}®è?` |
| [Husk](https://codegolf.stackexchange.com/questions/165793/new-password-idea-word-walker/213795#213795) | | 11b | `SzS!ö!…¢ŀŀw` |
| [Japt](https://codegolf.stackexchange.com/questions/165793/new-password-idea-word-walker/165794#165794) | | 11b | `¸Ëê ÅªD gEÉ` |
| [Vyxal](https://codegolf.stackexchange.com/questions/165793/new-password-idea-word-walker/253374#253374) | | 11b | `⌈₅(ʁ):ẏ¨£i∑` |
| [Jelly](https://codegolf.stackexchange.com/questions/165793/new-password-idea-word-walker/165805#165805) | | 12b | `ḲJị"ŒBṖȯ$€$Ɗ` |
| Myby | | 12b | `> {\" ! +-@innerH" /&' ' @.` |
| [Pyth](https://codegolf.stackexchange.com/questions/165793/new-password-idea-word-walker/165844#165844) | | 12b | `s.e@+b_Ptbkc` |
| [Charcoal](https://codegolf.stackexchange.com/questions/165793/new-password-idea-word-walker/165803#165803) | | 16b | `⭆⪪Ｓ §⁺ι✂ι±²¦⁰±¹κ` |
| [CJam](https://codegolf.stackexchange.com/questions/165793/new-password-idea-word-walker/214311#214311) | | 22b | `qS/{_);1>W%+T_):T@*=}%` |
| [K](https://codegolf.stackexchange.com/questions/165793/new-password-idea-word-walker/166018#166018) | | 28b | `{x{*|y#x,1_|1_x}'1+!#x}@" "\` |
| [J](https://codegolf.stackexchange.com/questions/165793/new-password-idea-word-walker/166095#166095) | | 43b | `[:(>{~"_1#@>|i.@#)[:(,}.@}:)&.>[:<;._1' '&,` |

## [non-unique-duplicate-elements](https://codegolf.stackexchange.com/questions/60610/non-unique-duplicate-elements)

| language | rank | bytes | code |
|----------|------|-------|------|
| [Husk](https://codegolf.stackexchange.com/questions/60610/non-unique-duplicate-elements/216089#216089) | | 4b | `u-u¹` |
| [Jelly](https://codegolf.stackexchange.com/questions/60610/non-unique-duplicate-elements/119591#119591) | | 4b | `œ-QQ` |
| [Vyxal](https://codegolf.stackexchange.com/questions/60610/non-unique-duplicate-elements/253348#253348) | | 4b | `UÞ⊍U` |
| [05AB1E](https://codegolf.stackexchange.com/questions/60610/non-unique-duplicate-elements/166409#166409) | | 5b | `ʒ¢≠}Ù` |
| [K5](https://codegolf.stackexchange.com/questions/60610/non-unique-duplicate-elements/60648#60648) | | 5b | `?d^?d` |
| Myby | | 6.5b | `//#(<:+\)"@=` |
| [Japt](https://codegolf.stackexchange.com/questions/60610/non-unique-duplicate-elements/166320#166320) | | 7b | `â £kX â` |
| [K (oK)](https://codegolf.stackexchange.com/questions/60610/non-unique-duplicate-elements/171379#171379) | | 7b | `&1<#:'=` |
| [Pyth](https://codegolf.stackexchange.com/questions/60610/non-unique-duplicate-elements/60649#60649) | | 7b | `S{.-Q{Q` |
| [APL (Dyalog Unicode)](https://codegolf.stackexchange.com/questions/60610/non-unique-duplicate-elements/60637#60637) | | 9b | `∊(⊂1↓⊣¨)⌸` |
| [CJam](https://codegolf.stackexchange.com/questions/60610/non-unique-duplicate-elements/60612#60612) | | 10b | `D{De=(},_&` |
| [K (not K5)](https://codegolf.stackexchange.com/questions/60610/non-unique-duplicate-elements/60934#60934) | | 10b | `x@&1<#:'=x` |
| [J](https://codegolf.stackexchange.com/questions/60610/non-unique-duplicate-elements/60764#60764) | | 13b | `~.d#~1<+/=/~d` |

## [alphabet-checksum](https://codegolf.stackexchange.com/questions/253568/alphabet-checksum)

| language | rank | bytes | code |
|----------|------|-------|------|
| [05AB1E](https://codegolf.stackexchange.com/questions/253568/alphabet-checksum/253581#253581) | | 6b | `ADIkOè` |
| [Nibbles](https://codegolf.stackexchange.com/questions/253568/alphabet-checksum/253613#253613) | | 7b | `+%+.$-$;'a'26` |
| [Charcoal](https://codegolf.stackexchange.com/questions/253568/alphabet-checksum/253601#253601) | | 8b | `§βΣＥＳ⌕βι` |
| [Japt](https://codegolf.stackexchange.com/questions/253568/alphabet-checksum/253584#253584) | | 8b | `;x!aC gC` |
| [Jelly](https://codegolf.stackexchange.com/questions/253568/alphabet-checksum/253586#253586) | | 8b | `O+7S‘ịØa` |
| [Fig](https://codegolf.stackexchange.com/questions/253568/alphabet-checksum/253582#253582) | | 8.231b | `ica%26S+7C` |
| Myby | | 9b | `+\ L&^" / @. { L` |
| [Vyxal](https://codegolf.stackexchange.com/questions/253568/alphabet-checksum/253573#253573) | | 9b | `øA‹∑₄%›øA` |
| [MATL](https://codegolf.stackexchange.com/questions/253568/alphabet-checksum/253577#253577) | | 10b | `2Y2j97-sQ)` |
| [Brachylog](https://codegolf.stackexchange.com/questions/253568/alphabet-checksum/253616#253616) | | 14b | `ạ+₇ᵐ+%₂₆+₉₇g~ạ` |
| [K (ngn/k)](https://codegolf.stackexchange.com/questions/253568/alphabet-checksum/254173#254173) | | 14b | ``` `c$97+26!+/97! ``` |
| [BQN](https://codegolf.stackexchange.com/questions/253568/alphabet-checksum/253619#253619) | | 15b | `'a'+26|·+´-⟜'a'` |
| [Gaia](https://codegolf.stackexchange.com/questions/253568/alphabet-checksum/254004#254004) | | 15b | `⟨c97%⟩¦Σ26%97+c` |
| [Pip](https://codegolf.stackexchange.com/questions/253568/alphabet-checksum/253713#253713) | | 16b | `zPK$+(A*a-97)%26` |
| [J](https://codegolf.stackexchange.com/questions/253568/alphabet-checksum/253759#253759) | | 19b | `(26|+/)&.(_97+3&u:)` |

## [8086-segment-address](https://codegolf.stackexchange.com/questions/255850/8086-segment-address)

| language | rank | bytes | code |
|----------|------|-------|------|
| [05AB1E](https://codegolf.stackexchange.com/questions/255850/8086-segment-address-to-linear/256099#256099) | | 7b | `':¡H16β` |
| [Nibbles](https://codegolf.stackexchange.com/questions/255850/8086-segment-address-to-linear/255901#255901) | | 7b | ``` `@4.`=$\$Nhex ``` |
| [Vyxal](https://codegolf.stackexchange.com/questions/255850/8086-segment-address-to-linear/255873#255873) | | 7b | `\:/H16β` |
| Myby | | 8b | `16 #. 16 #. /&':'` |
| [Jelly](https://codegolf.stackexchange.com/questions/255850/8086-segment-address-to-linear/255853#255853) | | 11b | `ØHiⱮ’ṣ-ḅ⁴ḅ⁴` |
| [Japt `-x`](https://codegolf.stackexchange.com/questions/255850/8086-segment-address-to-linear/255866#255866) | | 13b | `q': ÔËnG *GpE` |
| [Charcoal](https://codegolf.stackexchange.com/questions/255850/8086-segment-address-to-linear/255871#255871) | | 14b | `⍘↨Ｅ⪪Ｓ:⍘ι⊗⁸⊗⁸⊗⁸` |
| [Pip](https://codegolf.stackexchange.com/questions/255850/8086-segment-address-to-linear/255878#255878) | | 23b | `Uo{aFB16*16E Do}MSa^":"` |

## [simple-csv-dsv-importer](https://codegolf.stackexchange.com/questions/111707/simple-csv-dsv-importer)

| language | rank | bytes | code |
|----------|------|-------|------|
| Myby | | 1b | `/"` |
| [Jelly](https://codegolf.stackexchange.com/questions/111707/simple-csv-dsv-importer/111709#111709) | | 2b | `ṣ€` |
| [Japt](https://codegolf.stackexchange.com/questions/111707/simple-csv-dsv-importer/111717#111717) | | 3b | `mqV` |
| [APL (Dyalog)](https://codegolf.stackexchange.com/questions/111707/simple-csv-dsv-importer/120792#120792) | | 4b | `⎕ML←3` |
| [MATL](https://codegolf.stackexchange.com/questions/111707/simple-csv-dsv-importer/111724#111724) | | 4b | `H&XX` |
| [05AB1E](https://codegolf.stackexchange.com/questions/111707/simple-csv-dsv-importer/111708#111708) | | 5b | `vy²¡ˆ` |
| [CJam](https://codegolf.stackexchange.com/questions/111707/simple-csv-dsv-importer/111781#111781) | | 5b | `l~l./` |

## [replace-0s-in-a-string-with-their-consecutive-counts](https://codegolf.stackexchange.com/questions/255822/replace-0s-in-a-string-with-their-consecutive-counts)

| language | rank | bytes | code |
|----------|------|-------|------|
| [QuadR](https://codegolf.stackexchange.com/questions/255822/replace-0s-in-a-string-with-their-consecutive-counts/255827#255827) | | 5b | `0+` <br/> `⍵L` |
| [Nibbles](https://codegolf.stackexchange.com/questions/255822/replace-0s-in-a-string-with-their-consecutive-counts/255893#255893) | | 6b | ``` +.`=$$?`r$@, ``` |
| [05AB1E](https://codegolf.stackexchange.com/questions/255822/replace-0s-in-a-string-with-their-consecutive-counts/255836#255836) | | 7b | `0ÃηRāR:` |
| [Japt](https://codegolf.stackexchange.com/questions/255822/replace-0s-in-a-string-with-their-consecutive-counts/255829#255829) | | 7b | `r+iT Èl` |
| [Pip](https://codegolf.stackexchange.com/questions/255822/replace-0s-in-a-string-with-their-consecutive-counts/255826#255826) | | 7b | `aR+X0#_` |
| [Vyxal `s`](https://codegolf.stackexchange.com/questions/255822/replace-0s-in-a-string-with-their-consecutive-counts/255823#255823) | | 7b | `ĠṠƛ0cßL` |
| [Husk](https://codegolf.stackexchange.com/questions/255822/replace-0s-in-a-string-with-their-consecutive-counts/255862#255862) | | 8b | `ṁ?IosLig` |
| [Jelly](https://codegolf.stackexchange.com/questions/255822/replace-0s-in-a-string-with-their-consecutive-counts/255854#255854) | | 8b | `Œgċ”0ȯƊ€` |
| Myby | | 9b | `> (+ # '0'&e. ?" #C)` |
| [Brachylog](https://codegolf.stackexchange.com/questions/255822/replace-0s-in-a-string-with-their-consecutive-counts/255934#255934) | | 11b | `ḅ{ị0&lṫ|}ᵐc` |
| [Pyth](https://codegolf.stackexchange.com/questions/255822/replace-0s-in-a-string-with-their-consecutive-counts/255937#255937) | | 11b | ``` sm`|vedhdr8 ``` |
| [J](https://codegolf.stackexchange.com/questions/255822/replace-0s-in-a-string-with-their-consecutive-counts/255887#255887) | | 16b | `'0+'":@#rxapply]` |
| [Charcoal](https://codegolf.stackexchange.com/questions/255822/replace-0s-in-a-string-with-their-consecutive-counts/255841#255841) | | 20b | `⭆⪪⁻⪫⪪ＳＩ⁰_0_×_²_∨№ι0ι` |

## [maximum-average-ord](https://codegolf.stackexchange.com/questions/254224/maximum-average-ord)

| language | rank | bytes | code |
|----------|------|-------|------|
| [Vyxal `G`](https://codegolf.stackexchange.com/questions/254224/maximum-average-ord/254249#254249) | | 3b | `Cvṁ` |
| [05AB1E](https://codegolf.stackexchange.com/questions/254224/maximum-average-ord/254231#254231) | | 4b | `ÇÅAà` |
| [Jelly](https://codegolf.stackexchange.com/questions/254224/maximum-average-ord/254251#254251) | | 4b | `OÆmṀ` |
| [MathGolf](https://codegolf.stackexchange.com/questions/254224/maximum-average-ord/254294#254294) | | 4b | `$m▓╙` |
| [Fig](https://codegolf.stackexchange.com/questions/254224/maximum-average-ord/254250#254250) | | 4.939b | `]KemMC` |
| [Husk](https://codegolf.stackexchange.com/questions/254224/maximum-average-ord/254227#254227) | | 6b | `▲moAmc` |
| Myby | | 6.5b | `>. (+\@> / +)"` |
| [Pyth](https://codegolf.stackexchange.com/questions/254224/maximum-average-ord/254247#254247) | | 7b | `eSm.OCM` |
| [Nibbles](https://codegolf.stackexchange.com/questions/254224/maximum-average-ord/254234#254234) | | 8b | ``` `/.$/*+.$o$10,$] ``` |
| [Japt `-h`](https://codegolf.stackexchange.com/questions/254224/maximum-average-ord/254244#254244) | | 9b | `®xc /ZlÃñ` |
| [K (ngn/k)](https://codegolf.stackexchange.com/questions/254224/maximum-average-ord/254233#254233) | | 11b | `|/{+/x%#x}'` |
| [BQN](https://codegolf.stackexchange.com/questions/254224/maximum-average-ord/254373#254373) | | 12b | `⌈´+´∘-⟜@¨÷≠¨` |
| [Pip](https://codegolf.stackexchange.com/questions/254224/maximum-average-ord/254258#254258) | | 12b | `M:$+A*_/#_Mg` |
| [APL (Dyalog Unicode)](https://codegolf.stackexchange.com/questions/254224/maximum-average-ord/254368#254368) | | 13b | `⌈/+⌿∘⎕UCS¨÷≢¨` |
| [Charcoal](https://codegolf.stackexchange.com/questions/254224/maximum-average-ord/254228#254228) | | 15b | `ＷＳ⊞υ∕ΣＥι℅κＬιＩ⌈υ` |
| [J](https://codegolf.stackexchange.com/questions/254224/maximum-average-ord/254365#254365) | | 18b | `[:>./(1#.3&u:%#)&>` |
| [J-uby](https://codegolf.stackexchange.com/questions/254224/maximum-average-ord/254582#254582) | | 30b | `:*&:/%[:bytes|:sum,:+@|Q]|:max` |
| [Sequences](https://codegolf.stackexchange.com/questions/254224/maximum-average-ord/254226#254226) | | 96b | `[$v$aH]gM` |

## [generate-parity-bits](https://codegolf.stackexchange.com/questions/252491/generate-parity-bits)

| language | rank | bytes | code |
|----------|------|-------|------|
| [Nibbles](https://codegolf.stackexchange.com/questions/252491/generate-parity-bits/252528#252528) | | 7.5b | ``` :$\<@\``@+^2@+ ``` |
| [Jelly](https://codegolf.stackexchange.com/questions/252491/generate-parity-bits/252526#252526) | | 10b | `SBŻ⁹¡ṫC}⁸;` |
| [MATL](https://codegolf.stackexchange.com/questions/252491/generate-parity-bits/252520#252520) | | 10b | `tsiW\2M&Bh` |
| [Vyxal](https://codegolf.stackexchange.com/questions/252491/generate-parity-bits/252492#252492) | | 10b | `⌊∑$E%Π⁰↳›J` |
| Myby | | 10.5b | `[ + ] P 2 #: +\ % 2&^ O` |
| [05AB1E](https://codegolf.stackexchange.com/questions/252491/generate-parity-bits/252505#252505) | | 12b | `DSOIo%bI°+¦«` |
| [Japt `-P`](https://codegolf.stackexchange.com/questions/252491/generate-parity-bits/252527#252527) | | 13b | `pUx u2pV)¤ù0V` |
| [K (ngn/k)](https://codegolf.stackexchange.com/questions/252491/generate-parity-bits/252620#252620) | | 13b | `{x,(y#2)\+/x}` |
| [Charcoal](https://codegolf.stackexchange.com/questions/252491/generate-parity-bits/252515#252515) | | 14b | `Ｎθη✂⍘⁺Ｘ²θΣη²±θ` |
| [Pyth](https://codegolf.stackexchange.com/questions/252491/generate-parity-bits/252530#252530) | | 18b | `pz.[\0KE.B%/z\1^2K` |
| [J](https://codegolf.stackexchange.com/questions/252491/generate-parity-bits/252542#252542) | | 19b | `[,(]#2:)#:+/@[|~2^]` |
| [Pip](https://codegolf.stackexchange.com/questions/252491/generate-parity-bits/253611#253611) | | 28b | `a.(J(0*,bALTB($+a)%2Eb))@>-b` |

## [biplex-an-important-useless-operator](https://codegolf.stackexchange.com/questions/62713/biplex-an-important-useless-operator)

| language | rank | bytes | code |
|----------|------|-------|------|
| Myby | | 14.5b | `#. (# e.": >. , 1 >. <.) +"\ #: @.` |
| [J](https://codegolf.stackexchange.com/questions/62713/biplex-an-important-useless-operator/62923#62923) | | 21b | `+/(e.>./,<./@#~@)&.#:` |
| [Pyth](https://codegolf.stackexchange.com/questions/62713/biplex-an-important-useless-operator/62717#62717) | | 25b | `JsM.T_MjR2Qi_}RhM_BS-J0J2` |
| [APL](https://codegolf.stackexchange.com/questions/62713/biplex-an-important-useless-operator/63389#63389) | | 27b | `{2⊥S∊(⌈/,⌊/)0~⍨S←+/⍵⊤⍨32⍴2}` |
| [CJam](https://codegolf.stackexchange.com/questions/62713/biplex-an-important-useless-operator/62714#62714) | | 27b | `q~2fbWf%:.+_0-$(\W>|fe=W%2b` |
| [GolfScript](https://codegolf.stackexchange.com/questions/62713/biplex-an-important-useless-operator/63680#63680) | | 46b | ``` ~{2base-1%}%zip{{+}*}%-1%.$0-)\1<|`{&,}+%2base ``` |

## [sum-every-second-digit-in-a-number](https://codegolf.stackexchange.com/questions/255650/sum-every-second-digit-in-a-number)

| language | rank | bytes | code |
|----------|------|-------|------|
| [Vyxal](https://codegolf.stackexchange.com/questions/255650/sum-every-second-digit-in-a-number/255665#255665) | | 2b | `y∑` |
| [flax](https://codegolf.stackexchange.com/questions/255650/sum-every-second-digit-in-a-number/255703#255703) | | 2b | `ΣẎ` |
| [Fig](https://codegolf.stackexchange.com/questions/255650/sum-every-second-digit-in-a-number/255731#255731) | | 2.469b | `S]y` |
| [Japt `-hx`](https://codegolf.stackexchange.com/questions/255650/sum-every-second-digit-in-a-number/255661#255661) | | 3b | `ì ó` |
| [05AB1E](https://codegolf.stackexchange.com/questions/255650/sum-every-second-digit-in-a-number/255707#255707) | | 5b | ``` 2ι`SO ``` |
| [Jelly](https://codegolf.stackexchange.com/questions/255650/sum-every-second-digit-in-a-number/255679#255679) | | 5b | `D0ÐoS` |
| [Brachylog](https://codegolf.stackexchange.com/questions/255650/sum-every-second-digit-in-a-number/255720#255720) | | 6b | `ġ₂z₁t+` |
| [Charcoal](https://codegolf.stackexchange.com/questions/255650/sum-every-second-digit-in-a-number/255669#255669) | | 7b | `ＩΣΦＳ﹪κ²` |
| Myby | | 7b | `+\@} 2 % 10&#:` |
| [Pip](https://codegolf.stackexchange.com/questions/255650/sum-every-second-digit-in-a-number/255684#255684) | | 7b | `$+@SUWa` |
| [Pyt](https://codegolf.stackexchange.com/questions/255650/sum-every-second-digit-in-a-number/256009#256009) | | 7b | `ąĐƩ⇹ƧƩ-` |
| [Pyth](https://codegolf.stackexchange.com/questions/255650/sum-every-second-digit-in-a-number/255658#255658) | | 9b | `tssM%2+1z` |
| [K (ngn/k)](https://codegolf.stackexchange.com/questions/255650/sum-every-second-digit-in-a-number/255983#255983) | | 13b | `+/(2!!#:)#10\` |
| [BQN](https://codegolf.stackexchange.com/questions/255650/sum-every-second-digit-in-a-number/255698#255698) | | 18b | `1⊑·+˝⌊‿2⥊'0'-˜•Fmt` |
| [J](https://codegolf.stackexchange.com/questions/255650/sum-every-second-digit-in-a-number/255734#255734) | | 19b | `1(#.]*0 1$~#),.&.":` |

## [generate-an-arbitrary-half-of-a-string](https://codegolf.stackexchange.com/questions/250213/generate-an-arbitrary-half-of-a-string)

| language | rank | bytes | code |
|----------|------|-------|------|
| [Brachylog](https://codegolf.stackexchange.com/questions/250213/generate-an-arbitrary-half-of-a-string/250236#250236) | | 3b | `p~j` |
| [Jelly](https://codegolf.stackexchange.com/questions/250213/generate-an-arbitrary-half-of-a-string/250234#250234) | | 5b | `Ụm2Ṣị` |
| [Vyxal](https://codegolf.stackexchange.com/questions/250213/generate-an-arbitrary-half-of-a-string/250232#250232) | | 5b | `⇧y_sİ` |
| [BQN](https://codegolf.stackexchange.com/questions/250213/generate-an-arbitrary-half-of-a-string/250230#250230) | | 6b | `⊢/˜2|⊒` |
| [05AB1E](https://codegolf.stackexchange.com/questions/250213/generate-an-arbitrary-half-of-a-string/250294#250294) | | 7b | `ηε¤¢É}Ï` |
| [Pyth](https://codegolf.stackexchange.com/questions/250213/generate-an-arbitrary-half-of-a-string/250252#250252) | | 7b | `q#.-QTy` |
| Myby | | 7.5b | `( %@} 2 % ] ) { #` |
| [Charcoal](https://codegolf.stackexchange.com/questions/250213/generate-an-arbitrary-half-of-a-string/250218#250218) | | 9b | `Φθ﹪№…θκι²` |
| [J](https://codegolf.stackexchange.com/questions/250213/generate-an-arbitrary-half-of-a-string/250223#250223) | | 11b | `#~2|1#.]=]\` |

## [list-of-possible-birth-years-of-living-humans](https://codegolf.stackexchange.com/questions/89494/list-of-possible-birth-years-of-living-humans)

| language | rank | bytes | code |
|----------|------|-------|------|
| [Japt](https://codegolf.stackexchange.com/questions/89494/list-of-possible-birth-years-of-living-humans/115258#115258) | | 6b | `#yonKi` |
| Myby | | 6b | `yr -" R@121` |
| [Pyke](https://codegolf.stackexchange.com/questions/89494/list-of-possible-birth-years-of-living-humans/89522#89522) | | 6b | `wC7m-` |
| [05AB1E](https://codegolf.stackexchange.com/questions/89494/list-of-possible-birth-years-of-living-humans/89498#89498) | | 7b | `žg120Ý-` |
| [Pyth](https://codegolf.stackexchange.com/questions/89494/list-of-possible-birth-years-of-living-humans/89500#89500) | | 8b | `-L.d3C\y` |
| [Vyxal](https://codegolf.stackexchange.com/questions/89494/list-of-possible-birth-years-of-living-humans/253155#253155) | | 9b | `kðt:122-r` |
| [APL (Dyalog)](https://codegolf.stackexchange.com/questions/89494/list-of-possible-birth-years-of-living-humans/89496#89496) | | 10b | `120↑⌽⍳⊃⎕ts` |
| [MATL](https://codegolf.stackexchange.com/questions/89494/list-of-possible-birth-years-of-living-humans/89508#89508) | | 10b | `1&Z'0:120-` |
| [CJam](https://codegolf.stackexchange.com/questions/89494/list-of-possible-birth-years-of-living-humans/89517#89517) | | 11b | `et0=121,f-p` |
| [K (ngn/k)](https://codegolf.stackexchange.com/questions/89494/list-of-possible-birth-years-of-living-humans/253161#253161) | | 12b | `{x,x-1+!120}` |
| [K](https://codegolf.stackexchange.com/questions/89494/list-of-possible-birth-years-of-living-humans/89555#89555) | | 27b | ``` 1@", "/:$(`year$.z.d)-!121; ``` |

## [triangular-polkadot-numbers](https://codegolf.stackexchange.com/questions/253309/triangular-polkadot-numbers)

| language | rank | bytes | code |
|----------|------|-------|------|
| [05AB1E](https://codegolf.stackexchange.com/questions/253309/triangular-polkadot-numbers/253385#253385) | | 8b | `·Dtò<n+<` |
| [Jelly](https://codegolf.stackexchange.com/questions/253309/triangular-polkadot-numbers/253342#253342) | | 8b | `Ḷ²’xRĖḄḣ` |
| [Vyxal](https://codegolf.stackexchange.com/questions/253309/triangular-polkadot-numbers/253420#253420) | | 8b | `d:√ṙ‹²+‹` |
| [Pyt](https://codegolf.stackexchange.com/questions/253309/triangular-polkadot-numbers/255605#255605) | | 10b | `2*Đ√½-Ɩ²+⁻` |
| Myby | | 11b | `R +" R +" R { ^ ! >:@^&2"@R` |
| [Charcoal](https://codegolf.stackexchange.com/questions/253309/triangular-polkadot-numbers/253351#253351) | | 22b | `ＮθＦθＦ⊕ι⊞υ×ιιＩＥ…υθ⊕⁺ι⊗κ` |
| [Pip](https://codegolf.stackexchange.com/questions/253309/triangular-polkadot-numbers/253467#253467) | | 24b | `((RTDBa-0.5)//1)E2+DBa-1` |

## [create-n-sublists-with-the-powers-of-two-1-2-4-8-16](https://codegolf.stackexchange.com/questions/255804/create-n-sublists-with-the-powers-of-two-1-2-4-8-16)

| language | rank | bytes | code |
|----------|------|-------|------|
| [MathGolf](https://codegolf.stackexchange.com/questions/255804/create-n-sublists-with-the-powers-of-two-1-2-4-8-16/256098#256098) | | 6b | `Æ∞1\αç` |
| [Vyxal](https://codegolf.stackexchange.com/questions/255804/create-n-sublists-with-the-powers-of-two-1-2-4-8-16/255805#255805) | | 6b | `(d1$"ꜝ` |
| [05AB1E](https://codegolf.stackexchange.com/questions/255804/create-n-sublists-with-the-powers-of-two-1-2-4-8-16/255825#255825) | | 7b | `F·Xs‚ZK` |
| [Jelly](https://codegolf.stackexchange.com/questions/255804/create-n-sublists-with-the-powers-of-two-1-2-4-8-16/255809#255809) | | 7b | `Ḥ1,¹ƇƲ¡` |
| Myby | | 10.5b | `0 (0 - 1 , 2&*V)^:#` |
| [Japt](https://codegolf.stackexchange.com/questions/255804/create-n-sublists-with-the-powers-of-two-1-2-4-8-16/255869#255869) | | 11b | `Æ[2pX]ÃÔr!p` |
| [MATL](https://codegolf.stackexchange.com/questions/255804/create-n-sublists-with-the-powers-of-two-1-2-4-8-16/255820#255820) | | 12b | `:qWP"@XhP]&D` |
| [Pip `-p`](https://codegolf.stackexchange.com/questions/255804/create-n-sublists-with-the-powers-of-two-1-2-4-8-16/255929#255929) | | 12b | `LaYFI[1y*2]y` |
| [CJam](https://codegolf.stackexchange.com/questions/255804/create-n-sublists-with-the-powers-of-two-1-2-4-8-16/255857#255857) | | 14b | `{,W%{2\#]W%}%}` |
| [Charcoal](https://codegolf.stackexchange.com/questions/255804/create-n-sublists-with-the-powers-of-two-1-2-4-8-16/255814#255814) | | 14b | `ＦＮ≔Φ⟦¹⊗υ⟧κυ⭆¹υ` |
| [K (ngn/k)](https://codegolf.stackexchange.com/questions/255804/create-n-sublists-with-the-powers-of-two-1-2-4-8-16/256019#256019) | | 17b | `{(x-1)(1,,2*)/,1}` |
| [Pyth](https://codegolf.stackexchange.com/questions/255804/create-n-sublists-with-the-powers-of-two-1-2-4-8-16/255817#255817) | | 20b | `L+[^2b)?qtQbY[yhb)y0` |
| [Pip](https://codegolf.stackexchange.com/questions/255804/create-n-sublists-with-the-powers-of-two-1-2-4-8-16/255819#255819) | | 28b | `FiR,a{YlAEyPE EiUi=a?Y Hy0}y` |

## [write-some-random-english](https://codegolf.stackexchange.com/questions/199139/write-some-random-english)

| language | rank | bytes | code |
|----------|------|-------|------|
| [Jelly](https://codegolf.stackexchange.com/questions/199139/write-some-random-english/252402#252402) | | 8b | `ØḄØẹḂ?X)` |
| Myby | | 9b | ``` > (?. con`vow)"@R ``` |
| [Vyxal `s`](https://codegolf.stackexchange.com/questions/199139/write-some-random-english/251506#251506) | | 9b | `⟑₂¨ikvk¹℅` |
| [Stax](https://codegolf.stackexchange.com/questions/199139/write-some-random-english/199448#199448) | | 10b | `ÇÅφ⌠↑Ñ°↕Yx` |
| [05AB1E](https://codegolf.stackexchange.com/questions/199139/write-some-random-english/199143#199143) | | 11b | `EžN¸žMšNèΩJ` |
| [Japt `-mP`](https://codegolf.stackexchange.com/questions/199139/write-some-random-english/255785#255785) | | 12b | `;Ck%+Ugciv¹ö` |
| [Pip](https://codegolf.stackexchange.com/questions/199139/write-some-random-english/251543#251543) | | 12b | `RC*[.CZVW]Ha` |
| [Pyth](https://codegolf.stackexchange.com/questions/199139/write-some-random-english/252404#252404) | | 19b | `J"aeiou"smO?%d2J-GJ` |
| [GolfScript](https://codegolf.stackexchange.com/questions/199139/write-some-random-english/199450#199450) | | 36b | `,{['aeiou'.123,97>^]\2%=.,rand=}%''+` |

## [repeat-every-other-character-in-string-starting-with-second-character](https://codegolf.stackexchange.com/questions/198717/repeat-every-other-character-in-string-starting-with-second-character)

| language | rank | bytes | code |
|----------|------|-------|------|
| [Jelly](https://codegolf.stackexchange.com/questions/198717/repeat-every-other-character-in-string-starting-with-second-character/198718#198718) | | 3b | `ḤÐe` |
| [Vyxal](https://codegolf.stackexchange.com/questions/198717/repeat-every-other-character-in-string-starting-with-second-character/236924#236924) | | 3b | `3•y` |
| [Fig](https://codegolf.stackexchange.com/questions/198717/repeat-every-other-character-in-string-starting-with-second-character/256145#256145) | | 3.292b | `n2@h` |
| [05AB1E](https://codegolf.stackexchange.com/questions/198717/repeat-every-other-character-in-string-starting-with-second-character/198861#198861) | | 4b | `€Ðιθ` |
| [Japt `-m`](https://codegolf.stackexchange.com/questions/198717/repeat-every-other-character-in-string-starting-with-second-character/198725#198725) | | 4b | `+pVu` |
| [Keg `-ir` `-lp`](https://codegolf.stackexchange.com/questions/198717/repeat-every-other-character-in-string-starting-with-second-character/198740#198740) | | 4b | `(,⑩,` |
| Myby | | 5b | `( + # 1 2 ) ! #` |
| [Pyth](https://codegolf.stackexchange.com/questions/198717/repeat-every-other-character-in-string-starting-with-second-character/199787#199787) | | 7b | `%2ts*L3` |
| [CJam](https://codegolf.stackexchange.com/questions/198717/repeat-every-other-character-in-string-starting-with-second-character/199600#199600) | | 8b | `q3e*1>2%` |
| [Charcoal](https://codegolf.stackexchange.com/questions/198717/repeat-every-other-character-in-string-starting-with-second-character/198760#198760) | | 8b | `⭆Ｓ×ι⊕﹪κ²` |
| [J](https://codegolf.stackexchange.com/questions/198717/repeat-every-other-character-in-string-starting-with-second-character/198719#198719) | | 8b | `#~1 2$~#` |
| [APL (dzaima/APL)](https://codegolf.stackexchange.com/questions/198717/repeat-every-other-character-in-string-starting-with-second-character/200057#200057) | | 9b | `⎕IO←0` |
| [GolfScript](https://codegolf.stackexchange.com/questions/198717/repeat-every-other-character-in-string-starting-with-second-character/199785#199785) | | 9b | `2/{1/~.}%` |
| [Pip](https://codegolf.stackexchange.com/questions/198717/repeat-every-other-character-in-string-starting-with-second-character/237051#237051) | | 10b | `WV(UWa!*h)` |
| [APL (Dyalog Unicode)](https://codegolf.stackexchange.com/questions/198717/repeat-every-other-character-in-string-starting-with-second-character/237047#237047) | | 11b | `⊢(/⍨)1 2⍴⍨⍴` <br/>  <br/> `           ⍴   monadic: shape of the right argument (number of elements)` <br/>  <br/> `      1 2⍴⍨    repeat numbers 1 and 2 as many times as the right argument` <br/>  <br/> `⊢              the right argument` <br/>  <br/> ` (/⍨)          replicate each element of the left argument as many times as ` <br/> `               specified by the corresponding elements of the right argument` |
| [APL (Dyalog)](https://codegolf.stackexchange.com/questions/198717/repeat-every-other-character-in-string-starting-with-second-character/198930#198930) | | 11b | `∊⊢⍴⍨¨1 2⍴⍨≢` |
| [Z80Golf](https://codegolf.stackexchange.com/questions/198717/repeat-every-other-character-in-string-starting-with-second-character/199601#199601) | | 12b | `00000000: d52e 76e5 2e07 e5cd 0380 38f6            ..v.......8.` |
| [APL+WIN](https://codegolf.stackexchange.com/questions/198717/repeat-every-other-character-in-string-starting-with-second-character/198773#198773) | | 13b | `((⍴s)⍴⍳2)/s←⎕` |
| [K4](https://codegolf.stackexchange.com/questions/198717/repeat-every-other-character-in-string-starting-with-second-character/198757#198757) | | 17b | `{,/#'[(#x)#1 2]x}` <br/>  <br/> `{               } /lambda with implicit arg x` <br/> `      (#x)        /count x` <br/> `          #1 2    /takes #x items of 1 2` <br/> `   #'[        ]x  /take [...] items of x` <br/> ` ,/               /flatten` |

## [is-it-true-ask-pip](https://codegolf.stackexchange.com/questions/256166/is-it-true-ask-pip)

| language | rank | bytes | code |
|----------|------|-------|------|
| [05AB1E](https://codegolf.stackexchange.com/questions/256166/is-it-true-ask-pip/256175#256175) | | 7b | `„+-₂‡{Ā` |
| [Charcoal](https://codegolf.stackexchange.com/questions/256166/is-it-true-ask-pip/256174#256174) | | 9b | `∧№.⁻θ0⁻.θ` |
| Myby | | 9b | `'.' ( ~: * ).. -&'0'H )` |
| [Vyxal](https://codegolf.stackexchange.com/questions/256166/is-it-true-ask-pip/256178#256178) | | 11b | ``` `+- `₈ĿṅsEḃ ``` |
| [Pip](https://codegolf.stackexchange.com/questions/256166/is-it-true-ask-pip/256248#256248) | | 16b | `aRM0N"."&!aQ"."` |

## [whats-the-file-extension](https://codegolf.stackexchange.com/questions/120925/whats-the-file-extension)

| language | rank | bytes | code |
|----------|------|-------|------|
| [Japt](https://codegolf.stackexchange.com/questions/120925/whats-the-file-extension/120957#120957) | | 3b | `q.` |
| [V](https://codegolf.stackexchange.com/questions/120925/whats-the-file-extension/120939#120939) | | 3b | `00000000: cd81 ae                                  ...` |
| [05AB1E](https://codegolf.stackexchange.com/questions/120925/whats-the-file-extension/120930#120930) | | 4b | `'.¡¤` |
| [Charcoal](https://codegolf.stackexchange.com/questions/120925/whats-the-file-extension/121009#121009) | | 4b | `⊟⪪Ｓ.` |
| [Jelly](https://codegolf.stackexchange.com/questions/120925/whats-the-file-extension/120931#120931) | | 4b | `ṣ”.Ṫ` |
| [Keg](https://codegolf.stackexchange.com/questions/120925/whats-the-file-extension/210384#210384) | | 4b | `\./÷` |
| Myby | | 4b | `} /&'.'` |
| [Stax](https://codegolf.stackexchange.com/questions/120925/whats-the-file-extension/157820#157820) | | 4b | `'./H` |
| [Vyxal](https://codegolf.stackexchange.com/questions/120925/whats-the-file-extension/229368#229368) | | 4b | `\.€t` |
| [Ohm v2](https://codegolf.stackexchange.com/questions/120925/whats-the-file-extension/146627#146627) | | 5b | `I..ï⁾` |
| [Pyth](https://codegolf.stackexchange.com/questions/120925/whats-the-file-extension/121106#121106) | | 5b | `ecz\.` |
| [Arn](https://codegolf.stackexchange.com/questions/120925/whats-the-file-extension/210212#210212) | | 6b | `Ê^!⁺╔d` |
| [CJam](https://codegolf.stackexchange.com/questions/120925/whats-the-file-extension/157758#157758) | | 6b | `q'./W=` |
| [K (oK)](https://codegolf.stackexchange.com/questions/120925/whats-the-file-extension/146626#146626) | | 6b | `*|"."\` |
| [MATL](https://codegolf.stackexchange.com/questions/120925/whats-the-file-extension/121057#121057) | | 7b | `46&YbO)` |
| [Pip](https://codegolf.stackexchange.com/questions/120925/whats-the-file-extension/210383#210383) | | 8b | `@R:a^"."` |
| [APL (Dyalog Unicode)](https://codegolf.stackexchange.com/questions/120925/whats-the-file-extension/210258#210258) | | 10b | `⊃∘⌽'.'∘≠⊆⊢` |

## [find-the-prime-signature](https://codegolf.stackexchange.com/questions/256147/find-the-prime-signature)

| language | rank | bytes | code |
|----------|------|-------|------|
| Myby | | 4b | `-@% pfep` |
| [Vyxal](https://codegolf.stackexchange.com/questions/256147/find-the-prime-signature/256148#256148) | | 4b | `∆ǐsṘ` |
| [05AB1E](https://codegolf.stackexchange.com/questions/256147/find-the-prime-signature/256172#256172) | | 5b | `Ó0K{R` |
| [MATL](https://codegolf.stackexchange.com/questions/256147/find-the-prime-signature/256152#256152) | | 5b | `_YFSP` |
| [APL (Dyalog Extended)](https://codegolf.stackexchange.com/questions/256147/find-the-prime-signature/256150#256150) | | 6b | `∨2⌷2⍭⊢` |
| [Husk](https://codegolf.stackexchange.com/questions/256147/find-the-prime-signature/256218#256218) | | 6b | `↔OmLgp` |
| [Jelly](https://codegolf.stackexchange.com/questions/256147/find-the-prime-signature/256149#256149) | | 6b | `ÆE¹ƇṢU` |
| [Japt](https://codegolf.stackexchange.com/questions/256147/find-the-prime-signature/256160#256160) | | 8b | `k ü mÊñn` |
| [Pyt](https://codegolf.stackexchange.com/questions/256147/find-the-prime-signature/256155#256155) | | 8b | `Đϼ1\⇹ḋɔŞ` |
| [J](https://codegolf.stackexchange.com/questions/256147/find-the-prime-signature/256159#256159) | | 12b | `__\:~@{:@q:]` |
| [Charcoal](https://codegolf.stackexchange.com/questions/256147/find-the-prime-signature/256161#256161) | | 56b | `Ｎθ≔²ηＷ⊖θ¿﹪θη≦⊕η«≔⁰ζＷ¬﹪θη«≦⊕ζ≧÷ηθ»⊞υζ»≔⟦⟧ζＷ⁻υζＦ№υ⌈ι⊞ζ⌈ιＩζ` |

## [calculate-the-progressive-mean](https://codegolf.stackexchange.com/questions/198884/calculate-the-progressive-mean)

| language | rank | bytes | code |
|----------|------|-------|------|
| Myby | | 7.5b | `~:@+\ (, + -) +\ / +` |
| [Jelly](https://codegolf.stackexchange.com/questions/198884/calculate-the-progressive-mean/198891#198891) | | 9b | `Æm;+H¥/ṄI` |
| [05AB1E](https://codegolf.stackexchange.com/questions/198884/calculate-the-progressive-mean/198894#198894) | | 12b | `āÍoîÅΓ‚ÅAÂÆª` |
| [J](https://codegolf.stackexchange.com/questions/198884/calculate-the-progressive-mean/198890#198890) | | 17b | `-:@+/@|.(,,-)+/%#` |
| [APL (Dyalog Unicode)](https://codegolf.stackexchange.com/questions/198884/calculate-the-progressive-mean/198889#198889) | | 18b | `(2÷⍨+)⌿∘⌽(,,-)+⌿÷≢` |
| [Charcoal](https://codegolf.stackexchange.com/questions/198884/calculate-the-progressive-mean/198896#198896) | | 27b | `≔∕ΣθＬθη≔§θ⁰ζＦθ≔⊘⁺ιζζＩ⟦ηζ⁻ζη` |

## [what-do-you-get-when-you-multiply-6-by-9-42](https://codegolf.stackexchange.com/questions/124242/what-do-you-get-when-you-multiply-6-by-9-42)

| language | rank | bytes | code |
|----------|------|-------|------|
| [Jelly](https://codegolf.stackexchange.com/questions/124242/what-do-you-get-when-you-multiply-6-by-9-42/124422#124422) | | 7b | `Vf96SạP` |
| [Brachylog](https://codegolf.stackexchange.com/questions/124242/what-do-you-get-when-you-multiply-6-by-9-42/180944#180944) | | 8b | `c69∧42|×` |
| Myby | | 8b | `* - 12 * 6 9 = ,` |
| [05AB1E](https://codegolf.stackexchange.com/questions/124242/what-do-you-get-when-you-multiply-6-by-9-42/124258#124258) | | 9b | `P¹69SQi42` |
| [Vyxal](https://codegolf.stackexchange.com/questions/124242/what-do-you-get-when-you-multiply-6-by-9-42/256247#256247) | | 9b | `69f⁼[42|Π` |
| [APL (Dyalog)](https://codegolf.stackexchange.com/questions/124242/what-do-you-get-when-you-multiply-6-by-9-42/124465#124465) | | 10b | `×-12×6 9≡,` |
| [MathGolf](https://codegolf.stackexchange.com/questions/124242/what-do-you-get-when-you-multiply-6-by-9-42/180985#180985) | | 10b | `α96α=¿ÅJ∞*` |
| [J](https://codegolf.stackexchange.com/questions/124242/what-do-you-get-when-you-multiply-6-by-9-42/124605#124605) | | 11b | `*-12*6 9-:,` |
| [MATL](https://codegolf.stackexchange.com/questions/124242/what-do-you-get-when-you-multiply-6-by-9-42/124267#124267) | | 11b | `[BE]=?42}Gp` |
| [Ohm](https://codegolf.stackexchange.com/questions/124242/what-do-you-get-when-you-multiply-6-by-9-42/124255#124255) | | 11b | `*┼6E┘9E&?42` |
| [Pyth](https://codegolf.stackexchange.com/questions/124242/what-do-you-get-when-you-multiply-6-by-9-42/124332#124332) | | 11b | `?qQ,6tT42*F` |
| [Japt](https://codegolf.stackexchange.com/questions/124242/what-do-you-get-when-you-multiply-6-by-9-42/124262#124262) | | 12b | `¥6&V¥9?42:N×` |
| [K (oK)](https://codegolf.stackexchange.com/questions/124242/what-do-you-get-when-you-multiply-6-by-9-42/142150#142150) | | 14b | `(*/x;42)6 9~x:` |
| [CJam](https://codegolf.stackexchange.com/questions/124242/what-do-you-get-when-you-multiply-6-by-9-42/160278#160278) | | 15b | `{:T69Ab=42T:*?}` |
| [Q](https://codegolf.stackexchange.com/questions/124242/what-do-you-get-when-you-multiply-6-by-9-42/124915#124915) | | 17b | `{(prd x;42)x~6 9}` |
| [GolfScript](https://codegolf.stackexchange.com/questions/124242/what-do-you-get-when-you-multiply-6-by-9-42/124338#124338) | | 18b | `."6 9"={;42}{~*}if` |
| [shortC](https://codegolf.stackexchange.com/questions/124242/what-do-you-get-when-you-multiply-6-by-9-42/124249#124249) | | 23b | `Df(a,b)a==6&b==9?42:a*b` |
| [Braingolf](https://codegolf.stackexchange.com/questions/124242/what-do-you-get-when-you-multiply-6-by-9-42/124661#124661) | | 30b | `VR.9e1M|*.69*e1M|vl2e76*_:R_|;` |

## [find-the-largest-and-the-smallest-number-in-an-array](https://codegolf.stackexchange.com/questions/71172/find-the-largest-and-the-smallest-number-in-an-array)

| language | rank | bytes | code |
|----------|------|-------|------|
| Myby | | 5.5b | `minmax <I.\` |
| [Jelly](https://codegolf.stackexchange.com/questions/71172/find-the-largest-and-the-smallest-number-in-an-array/216925#216925) | | 6b | `OƑƇṢ.ị` |
| [Seriously](https://codegolf.stackexchange.com/questions/71172/find-the-largest-and-the-smallest-number-in-an-array/71200#71200) | | 6b | `,ì;M@m` |
| [Vyxal](https://codegolf.stackexchange.com/questions/71172/find-the-largest-and-the-smallest-number-in-an-array/231131#231131) | | 6b | `0+∩₍gG  # main program` |
| [Brachylog](https://codegolf.stackexchange.com/questions/71172/find-the-largest-and-the-smallest-number-in-an-array/231133#231133) | | 7b | `ℕˢ⟨⌋≡⌉⟩` |
| [Pyth](https://codegolf.stackexchange.com/questions/71172/find-the-largest-and-the-smallest-number-in-an-array/71177#71177) | | 10b | `hM_BS^I#1Q` |
| [APL (Dyalog)](https://codegolf.stackexchange.com/questions/71172/find-the-largest-and-the-smallest-number-in-an-array/120673#120673) | | 13b | `(⌊/,⌈/)⎕AV~⍨∊` |
| [CJam](https://codegolf.stackexchange.com/questions/71172/find-the-largest-and-the-smallest-number-in-an-array/71175#71175) | | 13b | `{_:z&$2*_,(%}` |
| [K (ngn/k)](https://codegolf.stackexchange.com/questions/71172/find-the-largest-and-the-smallest-number-in-an-array/216975#216975) | | 19b | ``` (&/;|/)@\:(`i=@:')# ``` |
| [Jolf](https://codegolf.stackexchange.com/questions/71172/find-the-largest-and-the-smallest-number-in-an-array/71248#71248) | | 20b | `γ fxd='nF~tH0ͺZkγZKγ` <br/> ` _fx                 filter the input` <br/> `    d='nF~tH0        checking for number type` <br/> `γ                    call that "γ"` <br/> `             ͺ       pair` <br/> `              ZkγZKγ  the min and max of the array` |
| [𝔼𝕊𝕄𝕚𝕟](https://codegolf.stackexchange.com/questions/71172/find-the-largest-and-the-smallest-number-in-an-array/71258#71258) | | 20b | `[МƲ(ï⇔⒡≔=+$⸩,МƵï` |
| [Japt](https://codegolf.stackexchange.com/questions/71172/find-the-largest-and-the-smallest-number-in-an-array/71231#71231) | | 23b | `[V=Uf_bZÃn@X-Y})g Vw g]` |
| [MATL](https://codegolf.stackexchange.com/questions/71172/find-the-largest-and-the-smallest-number-in-an-array/71180#71180) | | 23b | `"@Y:tX%1)2\?x]N$htX<wX>` |

