# Overview

*Looking for [Commands](#commands)?*

This page contains documentation for Myby's commands and their various implemented behaviors.

## [How does Myby compare to other languages?](./compare)

Check out the link above! Current verdict: Myby is decently competitive, sometimes even winning against popular golfing languages, but doesn't consistently beat them, more often losing than winning. There's room for improvement, but it is already well-situated to at least be generally competitive. As of 1/3/2023 (win-loss-tie / total | win%):

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

## How to Read

Note: Mathematical operations result in a double if either `x` or `y` is a double, and is otherwise an integer. Also, for mathematical operations, bools are treated as `1` and `0` if `true` or `false` respectively.

| Statistic | Meaning |
|----|----|
| Speech Part | Either Verb, Adjective, Conjunction, or Multi Conjunction |
| Hex Representation | The underlying representation |
| Nibble Cost | How many nibbles the underlying representation is |
| Symbolic Usage | The command used in context(s) |
| Marked Arity | For verbs, what is the "more common" arity, which certain Adjectives and Conjunctions use to make a judgment call for behavior |
| Identity | What folds are seeded with. None if unspecified. If unspecified, such verbs will error when given the empty list. |
| Range Start | Where folds start when given an integer. 0 if unspecified. |

## Types

The various properties of manipulatable parts of speech.

- **any**: Represents any noun/atom/piece of data
  - **int**: Represents the integer type (unbounded)
  - **real**: Represents the floating point type (maximally precise)
  - **bool**: Represents the boolean type (`true`/`1b` or `false`/`0b`)
  - **list**: Represents any list (mixed type allowed)
    - **list(type)**: Represents a list exclusively containing **type**
  - **string**: Represents a string
  - **nil**: Represents the nil type
  - **number**: Meta-type referring to either an int or a real
- **verb**: Represents any verb
  - **verb(N)**: Represents a verb whose Marked Arity is N
  - **verb/N**: Represents a verb when it is called with N arguments
  
## Signatures

To describe the behavior of commands, the format **A** → **B** is used to denote the _signature_ of a command with arguments **A** resulting in **B**. Furthermore, to describe a returned verb, the format **V** : **A** → **B** is used. Arguments separated by a comma indicate strict order; arguments separated by an ampersand indicate any order is acceptable and equivlanet. Here are some examples:

- int → string - *input is an integer, returns a string*
- string → list(string) - *input is a string, returns a list of strings*
- int, int → int - *input is two integers, returns an integer**
- string, int → string - *input is a string and an int in that order, returns a string*
- string & int → string - *input is a string and an int in either order, returns a string*
- verb → verb - *input is a verb, returns a verb*
- verb(2) → verb(1) - *input is a verb whose marked arity is 2, returns a verb whose marked arity is 1*
- verb(N) → verb(3-N) - *input is a verb whose marked arity is N, returns a verb whose marked arity is 3-N*
- verb → (verb(1) : list → list) - *input is a verb, returns a verb whose marked arity is 1, which itself takes as input a list and returns a list*
- verb → (verb(2)/1 : any → any) - *input is a verb, returns a verb whose marked arity is 2, but nonetheless when called with 1 argument, takes any argument and returns some argument*

# Commands

{TOC}

## Adjectives

### `\` - Filter/Fold

| Statistic | Value |
|----|----|
| Speech Part | Adjective |
| Hex Representation | `2` |
| Nibble Cost | 1 |
| Symbolic Usage | `u\` |

| Signature | Explanation |
|----|----|
| verb(1) → (verb(1) : list → list) | Filter from. (Retains only elements `x` from the list for which `u@x` is truthy.) |
| verb(2) → (verb(1) : list → any) | Fold over. (Condenses the list by repeatedly applying `u` to an accumulator value and each member of the list. This accumulator value is often defined by `u`, but is otherwise taken to be the first element of the given list.) |
| verb(2) → (verb(1) : number → any) | Fold over implicit range. (Same as above, but over the list from the verb's Range Start to `a`.) |
| verb(2) → (verb(1) : list, list → list(list)) | Table over. (Using the left list `x` and the right list `y` as "anchors" for a corresponding function table, computed as `a u b` for every possible pair `(a,b)`, with `a` in `x` and `b` in `y`, organized in a table.) |

#### Examples

```myby
+\          NB. sum.
            NB. +'s marked arity is 2, so \ deduces fold
(#<5)\      NB. filter for less than 5.
            NB. marked arity for a Fork with Niladic tine is 1, so \ deduces fold
```

```myby
::: 1 2 3 4 *\ 5 6 7
 5  6  7
10 12 14
15 18 21
20 24 28
::: *\~ ^
... input(1/2): 6
... input(2/2):
NB. skipping input(2/2)
1  2  3  4  5  6
2  4  6  8 10 12
3  6  9 12 15 18
4  8 12 16 20 24
5 10 15 20 25 30
6 12 18 24 30 36
```


### `"` - Map/Zip

| Statistic | Value |
|----|----|
| Speech Part | Adjective |
| Hex Representation | `2` |
| Nibble Cost | 1 |
| Symbolic Usage | `u"` |

| Signature | Explanation |
|----|----|
| verb(1) → (verb(1) : list → list) | Map over. (Applies `u` to each element of the list.) |
| verb(1) → (verb(1) : string → string) | Map over. (Implicit join.) |
| verb(2) → (verb(2) : list, list → list) | Zip with. (For elements `x` and `y` at corresponding indices from the lists, computes `x u y`. Truncates the resulting list to the length of the shorter input list.) |
| verb(2) → (verb(2) : string, string → string) | Zip with. (Implicit join.) |

#### Examples

```myby
3&+"        NB. add 3 to each
            NB. marked arity for bond with a Nilad is 1, so " deduces map
<"          NB. element-wise compare
            NB. <'s marked arity is 2, so " deduces zip
```

### `":` - Left Map

| Statistic | Value |
|----|----|
| Speech Part | Adjective |
| Hex Representation | `19` |
| Nibble Cost | 2 |
| Symbolic Usage | `u":` |

| Signature | Explanation |
|----|----|
| verb(1) → (verb(1) : list → list) | Map over. (Applies `u` to each element of the list.) |
| verb(2) → (verb(2) : list, any → list) | Left map over. (For each element `xi` of `x`, computes `xi u y`.) |
| verb(2) → (verb(2) : not list, list → list) | Right map over. (For each element `yi` of `y`, computes `x u yi`.) |

#### Examples

```myby
::: 1 2 3 4 ;": 5 6 7 8
1 5 6 7 8
2 5 6 7 8
3 5 6 7 8
4 5 6 7 8
::: 1 2 3 4 (# ; '\u2502'&; O)": 5 6 7 8
1 │ 5 6 7 8
2 │ 5 6 7 8
3 │ 5 6 7 8
4 │ 5 6 7 8
NB. compare to regular zip:
::: 1 2 3 4 (# ; '\u2502'&; O)"  5 6 7 8
1 │ 5
2 │ 6
3 │ 7
4 │ 8
NB. emulate right map (u~":~):
::: 1 2 3 4 (# + '\u2502'&; O)~":~ 5 6 7 8
1 2 3 4 │ 5
1 2 3 4 │ 6
1 2 3 4 │ 7
1 2 3 4 │ 8
```

### `V` - Vectorize

| Statistic | Value |
|----|----|
| Speech Part | Adjective |
| Hex Representation | `BC` |
| Nibble Cost | 2 |
| Symbolic Usage | `uV` |

| Signature | Explanation |
|----|----|
| verb(N) → (verb(N)/1 : any → any) | Vectorize. (Applies `u` to every non-list element contained within `a`, or to `a` if it is a non-array.) |
| verb(N) → (verb(N)/2 : any, any → any) | Dual vectorize. (Applies `xi u yi` to matching non-list elements contained within `x` and `y`, or `xi u y` or `x u yi` as appropriate.) |

#### Examples

```myby
::: 1 2 3 4 + 5 6 7 8
1 2 3 4 5 6 7 8
::: 1 2 3 4 +V 5 6 7 8
6 8 10 12
NB. vectorization is fully deep
::: 1 2  3 4  5 6 / 2
1 2
3 4
5 6
::: 9 3  2 _2  4 9 / 2
9  3
2 _2
4  9
::: (1 2  3 4  5 6 / 2) +V (9 3  2 _2  4 9 / 2)
10  5
 5  2
 9 15
```

### `\.` - On Prefixes

| Statistic | Value |
|----|----|
| Speech Part | Adjective |
| Hex Representation | `AA` |
| Nibble Cost | 2 |
| Symbolic Usage | `u\.` |

| Signature | Explanation |
|----|----|
| verb(1) → (verb(1) : list → list) | Apply to prefixes. (For each non-empty prefix list `h` of `a`, from smallest to largest, compute `u@h`.) |
| verb(1) → (verb(1)/2 : int, list → list) | Apply to slices. (If `x` is positive, applies `u` to each moving window `w` of size `x` of `y`. If negative, applies `u` to each consecutive chunk `w` of size no greater than `x` of `y`.) |

### `\:` - On Prefixes

| Statistic | Value |
|----|----|
| Speech Part | Adjective |
| Hex Representation | `AC` |
| Nibble Cost | 2 |
| Symbolic Usage | `u\:` |

| Signature | Explanation |
|----|----|
| verb(1) → (verb(1) : list → list) | Apply to suffixes. (For each non-empty suffix list `h` of `a`, from largest to smallest, compute `u@h`.) |

### `~` - Reflex

| Statistic | Value |
|----|----|
| Speech Part | Adjective |
| Hex Representation | `FD` |
| Nibble Cost | 2 |
| Symbolic Usage | `u~` |

| Signature | Explanation |
|----|----|
| verb → verb(2)/1 | Reflex. (Computes `a u a`.) |
| verb → verb(2) | Commute. (Computes `y u x`.) |

#### Examples

```myby
::: +\~@1 2 5 9         NB.<=> (1 2 5 9) +\ (1 2 5 9)
 2  3  6 10
 3  4  7 11
 6  7 10 14
10 11 14 18
::: 3 -~ 5
2
```

### `` `: `` - Arity Force

| Statistic | Value |
|----|----|
| Speech Part | Adjective |
| Hex Representation | `BA` |
| Nibble Cost | 2 |
| Symbolic Usage | ``u`:`` |

| Signature | Explanation |
|----|----|
| verb(N) → verb(3-N) | Invert marked arity. (If `u` has marked arity `N`, then returns a verb that is identical to `u`, but with marked arity `3-N`; that is, dyadic if marked monadic, and monadic if marked dyadic.) |

```myby
::: +" @ ('hello my world' / ' ')
5 2 5
NB. ma(+) = 2, so ma(+") = 2, and hence (+" ...) would treated as +"&(...)
::: +`:" 'hello my world' / ' '
5 2 5
NB. ma(+`:) = 1, so ma(+`:") = 1, thus (+" ...) is treated as +"@(...)
```

### `C` - Chunk By

| Statistic | Value |
|----|----|
| Speech Part | Adjective |
| Hex Representation | `D1C` (same as `@[`) |
| Nibble Cost | 3 |
| Symbolic Usage | `u[.` |

| Signature | Explanation |
|----|----|
| verb(1) → (verb(1) : list → list(list)) | Chunk by. (Applies `u` to consecutive members of `a`, and groups its elements together in sublists by belonging to the same class as evaluated by `u@xi`. That is, every sublist in the result is uniform under `u`.) |

#### Examples

```myby
NB. chunk by even-ness
::: %&2C  4 7 6 8 1 3 9 5 2 8 6 3
4
7
6 8
1 3 9 5
2 8 6
3
::: json $_
[[4],[7],[6,8],[1,3,9,5],[2,8,6],[3]]
NB. chunk by equality
::: #C 'hello!'
h e ll o !
::: json $_
["h","e","ll","o","!"]
```

### `[.` - On Left

| Statistic | Value |
|----|----|
| Speech Part | Adjective |
| Hex Representation | `D1C` (same as `@[`) |
| Nibble Cost | 3 |
| Symbolic Usage | `u[.` |

| Signature | Explanation |
|----|----|
| verb(1) → verb(2) | Left application. (With arguments `x` and `y`, computes `u@x`.) |

### `].` - On Right

| Statistic | Value |
|----|----|
| Speech Part | Adjective |
| Hex Representation | `D1D` (same as `@]`) |
| Nibble Cost | 3 |
| Symbolic Usage | `u].` |

| Signature | Explanation |
|----|----|
| verb(1) → verb(2) | Right application. (With arguments `x` and `y`, computes `u@y`.) |

### `!.` - Inverse

**NOTE:** Limited implementation at this stage.

| Statistic | Value |
|----|----|
| Speech Part | Adjective |
| Hex Representation | `F1C` |
| Nibble Cost | 3 |
| Symbolic Usage | `u!.` |

| Signature | Explanation |
|----|----|
| verb(N) → verb(1) | Transforms to the pre-defined inverse of `u` if it has one. |

### `G` - Generate

**NOTE:** The behavior of this command is subject to change to be more useful in the future.

| Statistic | Value |
|----|----|
| Speech Part | Adjective |
| Hex Representation | `F1B` |
| Nibble Cost | 3 |
| Symbolic Usage | `uG` |

| Signature | Explanation |
|----|----|
| verb(2) → verb(1) | Generate integer matching. (Given an integer `a`, starting with an integer `i=0`, increment `i` until `i u a` is false.) |
| verb(2) → verb(1)/2 | Generate integer matching. (Same as above, but starting with `i=y`.) |

#### Examples

```myby
::: nextprime: (> * primq[.) G
::: nextprime" 1 2 3 4 5 6 7
2 3 5 5 7 7 11
```

### `benil` - Nil replacement

| Statistic | Value |
|----|----|
| Speech Part | Adjective |
| Hex Representation | `FE80` |
| Nibble Cost | 4 |
| Symbolic Usage | `u benil` |

| Signature | Explanation |
|----|----|
| verb(0) → verb(1) | Nil defaulting. (Returns argument `a` if not `nil`. Otherwise, returns `u@a`, aka, niladic value of `u`.) |

### `M.` - Memoize

| Statistic | Value |
|----|----|
| Speech Part | Adjective |
| Hex Representation | `FE81` |
| Nibble Cost | 4 |
| Symbolic Usage | `uM.` |

| Signature | Explanation |
|----|----|
| verb(1) → verb(1) | Memoize. (Caches the input/output pairs to save computation.) |

### `T.` - Time

| Statistic | Value |
|----|----|
| Speech Part | Adjective |
| Hex Representation | `FE86` |
| Nibble Cost | 4 |
| Symbolic Usage | `uT.` |

| Signature | Explanation |
|----|----|
| verb(N) → verb(N) | Time operation |

#### Examples

```myby
::: 1 >:[. while < T." (10 ^" ^@6)
                 31 μs and 2 hnsecs      10
                216 μs and 4 hnsecs     100
         1 ms, 787 μs, and 7 hnsecs    1000
        13 ms, 405 μs, and 6 hnsecs   10000
        130 ms, 64 μs, and 6 hnsecs  100000
1 sec, 294 ms, 954 μs, and 9 hnsecs 1000000
::: 1 ^;#O\@(>:[. while < T.)" (10 ^" ^@6)
 3.07e-05      10
 0.000266     100
0.0025488    1000
0.0129008   10000
   0.1247  100000
  1.30357 1000000
```

## Conjunctions and Multi Conjunctions

### `&` - Bond

### `@` - Compose

### `&.` - Under

### `@.` - Monad Chain

### `^:` - Power

### `O` - Split Compose

## Verbs

### `+` - Add

| Statistic | Value |
|----|----|
| Speech Part | Verb |
| Hex Representation | `4` |
| Nibble Cost | 1 |
| Symbolic Usage | `+a`; `x+y` |
| Marked Arity | 2 |
| Identity | 0 |

| Signature | Explanation |
|----|----|
| int → int; real → real | Absolute value |
| bool → int | `1` if `a`, `0` otherwise |
| string → int; list → int | Length |
| number, number → number | Addition |
| string, string → string | String concatenation |
| list, list → list | list concatenation |

### `-` - Subtract

| Statistic | Value |
|----|----|
| Speech Part | Verb |
| Hex Representation | `5` |
| Nibble Cost | 1 |
| Symbolic Usage | `-a`; `x-y` |
| Marked Arity | 2 |

| Signature | Explanation |
|----|----|
| number → number | Negation |
| bool → bool | Logical negation |
| string → string; list → list | Reverse |
| number, number → number | Subtraction |

### `*` - Multiplication

| Statistic | Value |
|----|----|
| Speech Part | Verb |
| Hex Representation | `6` |
| Nibble Cost | 1 |
| Symbolic Usage | `*a`; `x*y` |
| Marked Arity | 2 |
| Identity | 1 |
| Range Start | 1 |

| Signature | Explanation |
|----|----|
| number → number | Sign. (1 if positive, -1 if negative, 0 if zero.) |
| list → list | Flatten |
| number, number → number | Multiplication |
| string, number → string; number, string → string | Repeat |
| list, string → string | Join by |

### `/` - Division

| Statistic | Value |
|----|----|
| Speech Part | Verb |
| Hex Representation | `7` |
| Nibble Cost | 1 |
| Symbolic Usage | `/a`; `x/y` |
| Marked Arity | 2 |
| Identity | 1 |
| Range Start | 1 |

| Signature | Explanation |
|----|----|
| string → list(string) | Characters |
| list → list | Unique |
| number → real | Reciprocal |
| number, number → number | Division |
| list, number; string, number | Chunk. (Splits `x` into parts of no longer than `y`.) |
| string, string → list(string) | Split. (Splits `x` on occurrences of `y`.) |

### `^` - Exponentiation

| Statistic | Value |
|----|----|
| Speech Part | Verb |
| Hex Representation | `8` |
| Nibble Cost | 1 |
| Symbolic Usage | `^a`; `x^y` |
| Marked Arity | 2 |
| Identity | 1 |
| Range Start | 2 |

| Signature | Explanation |
|----|----|
| string → string | Uppercase |
| number → list(number) | Inclusive range starting at 1 |
| duration → real | Number of seconds |
| number, number → number | Exponentiation |

### `#` - Identity

| Statistic | Value |
|----|----|
| Speech Part | Verb |
| Hex Representation | `9` |
| Nibble Cost | 1 |
| Symbolic Usage | `#a`; `x#y` |
| Marked Arity | 2 |

| Signature | Explanation |
|----|----|
| any → any | Identity |
| string & number → string; list & number → list | Reshape |
| list, list | Filter. (Returns elements in `x` where the corresponding element in `y` is truthy, aka, `{" }\ ;" @.`.) |

### `R` - Range

| Statistic | Value |
|----|----|
| Speech Part | Verb |
| Hex Representation | `E` |
| Nibble Cost | 1 |
| Symbolic Usage | `Ra`; `xRy` |
| Marked Arity | 1 |

| Signature | Explanation |
|----|----|
| string → string | Lowercase |
| number → list(number) | Range \[0,a). (Reversed if a < 0.) |
| number, number → list(number) | Range [x,y] |
| list, any → number; string, any → number | One-index. (First index of y in x, starting with the first index being 1; 0 if not found.) |

#### Examples

```myby
::: R5
0 1 2 3 4
::: R_3
2 1 0
::: 3R6
3 4 5 6
::: 15 39 22 R 0
0
::: 15 39 22 R 22
3
::: 'hello' R 'h'
1
::: 'hello' R 'e'
2
```

### `%` - Modulus

| Statistic | Value |
|----|----|
| Speech Part | Verb |
| Hex Representation | `F0` |
| Nibble Cost | 2 |
| Symbolic Usage | `%a`; `x%y` |
| Marked Arity | 2 |

| Signature | Explanation |
|----|----|
| list → list | Sorted |
| number, number → number | Modulus |

### `;` - Pair

| Statistic | Value |
|----|----|
| Speech Part | Verb |
| Hex Representation | `F2` |
| Nibble Cost | 2 |
| Symbolic Usage | `;a`; `x;y` |
| Marked Arity | 2 |

| Signature | Explanation |
|----|----|
| any → list(any) | Wrap. (Creates a list consisting of only `a`.) |
| any, any → list | Link. (Pairs `x` and `y`. Flattens `y` if a list.) |

#### Examples

```myby
::: json ;@5
[5]
NB. @ is necessary here, since ;'s marked arity is 2, and (;5) redirects to ;&5
::: 4 ; 'a'
4 a
::: 1 ; 2 ; 3 ; 4
1 2 3 4
```

### `!` - Binomial

| Statistic | Value |
|----|----|
| Speech Part | Verb |
| Hex Representation | `F3` |
| Nibble Cost | 2 |
| Symbolic Usage | `!a`; `x!y` |
| Marked Arity | 2 |

| Signature | Explanation |
|----|----|
| number → number | Square |
| list → list(list) | Enumerate. (Equivalent to `R@+ ;" #`.) |
| number, number → number | Combinations. ([The number of ways `x` things can be chosen out of `y`.](https://www.jsoftware.com/help/dictionary/d410.htm)) |

#### Examples

```myby
::: !\~ R15 @.    NB. Binomial table over [0,14]
1 1 1 1 1  1  1  1  1   1   1   1   1    1    1
0 1 2 3 4  5  6  7  8   9  10  11  12   13   14
0 0 1 3 6 10 15 21 28  36  45  55  66   78   91
0 0 0 1 4 10 20 35 56  84 120 165 220  286  364
0 0 0 0 1  5 15 35 70 126 210 330 495  715 1001
0 0 0 0 0  1  6 21 56 126 252 462 792 1287 2002
0 0 0 0 0  0  1  7 28  84 210 462 924 1716 3003
0 0 0 0 0  0  0  1  8  36 120 330 792 1716 3432
0 0 0 0 0  0  0  0  1   9  45 165 495 1287 3003
0 0 0 0 0  0  0  0  0   1  10  55 220  715 2002
0 0 0 0 0  0  0  0  0   0   1  11  66  286 1001
0 0 0 0 0  0  0  0  0   0   0   1  12   78  364
0 0 0 0 0  0  0  0  0   0   0   0   1   13   91
0 0 0 0 0  0  0  0  0   0   0   0   0    1   14
0 0 0 0 0  0  0  0  0   0   0   0   0    0    1
```

### `{` - First

| Statistic | Value |
|----|----|
| Speech Part | Verb |
| Hex Representation | `F8` |
| Nibble Cost | 2 |
| Symbolic Usage | `{a`; `x{y` |
| Marked Arity | 2 |

| Signature | Explanation |
|----|----|
| list → any; string → string | First element of |
| number, list → any; number, string → string | `x`th element of `y`. (Implements modular indexing, i.e., wraps around. E.g., `_1{y` ⇔ `(+-1){y`.) |

### `}` - Last

| Statistic | Value |
|----|----|
| Speech Part | Verb |
| Hex Representation | `F9` |
| Nibble Cost | 2 |
| Symbolic Usage | `}a`; `x}y` |
| Marked Arity | 1 |

| Signature | Explanation |
|----|----|
| list → any; string → string | Last element of |

### `=` - Equality

| Statistic | Value |
|----|----|
| Speech Part | Verb |
| Hex Representation | `F4` |
| Nibble Cost | 2 |
| Symbolic Usage | `=a`; `x=y` |
| Marked Arity | 1 |

| Signature | Explanation |
|----|----|
| number → list(list(number)) | Identity matrix |
| list → list(list(number)) | [Self-classify](https://www.jsoftware.com/help/dictionary/d000.htm). (Table equality between the unique elements of `a` and `a` itself. Equivalent to `/ =\ #`.) |
| any, any → bool | Equality |

#### Examples

```myby
::: 3 = '3'
0b
::: 6 = 3 + 3
1b
::: = 1 2 3 2 4 1 @.
1 0 0 0 0 1
0 1 0 1 0 0
0 0 1 0 0 0
0 0 0 0 1 0
```

### `<` - Less Than

| Statistic | Value |
|----|----|
| Speech Part | Verb |
| Hex Representation | `F5` |
| Nibble Cost | 2 |
| Symbolic Usage | `<a`; `x<y` |
| Marked Arity | 1 |

| Signature | Explanation |
|----|----|
| any → string | To String |
| any, any → bool | Less than. (Errors if incomparable.) |

#### `<!.` - Evaluate

| Signature | Explanation|
|----|----|
| string → any | Evaluate |

#### Examples

```myby
::: '[3, 4]' = <@(3;4)
1b
::: -&.< 1234
4321
::: (# + -&.<)@1234
5555
```

### `>` - Greater Than

| Statistic | Value |
|----|----|
| Speech Part | Verb |
| Hex Representation | `F6` |
| Nibble Cost | 2 |
| Symbolic Usage | `>a`; `x>y` |
| Marked Arity | 2 |

| Signature | Explanation |
|----|----|
| list → string | Join. (Joins `a` by the empty string, converting each element to a string.) |
| string → list | Ords. (Produces a list of the Unicode ordinate values of the characters of `a`.) |
| any, any → bool | Greater than. (Errors if incomparable.) |

#### Examples
```myby
::: > 'asdf' @.
97 115 100 102
```

### `<:` - Less Or Equal

### `>:` - Greater Or Equal

### `<.` - Minimum

### `>.` - Maximum

### `$^` - Last Chain

| Statistic | Value |
|----|----|
| Speech Part | Verb |
| Hex Representation | `F10` |
| Nibble Cost | 3 |
| Symbolic Usage | `$^a`; `x$^y` |
| Marked Arity | 1 (Subject to change) |

| Signature | Explanation |
|----|----|
| any → any; any, any → any | Last Chain. (Calls the previous line of the program with the given arguments.) |

#### Examples

```myby
NB. full program
# + 5       NB. add 5
$^ ^ 2      NB. square first line
NB. equivalent to
NB.=> (#+5)^2
```

### `$_` - Last Chain as Nilad

| Statistic | Value |
|----|----|
| Speech Part | Verb |
| Hex Representation | `FE12` |
| Nibble Cost | 3 |
| Symbolic Usage | `$_a`; `x$_y` |
| Marked Arity | 1 (Subject to change) |
| Niladic | true |

| Signature | Explanation |
|----|----|
| any → any; any, any → any | Last Chain as Nilad. (Calls the previous line of the program, disregarding any arguments given to it.) |

### `$:` - This Chain
| Statistic | Value |
|----|----|
| Speech Part | Verb |
| Hex Representation | `F11` |
| Nibble Cost | 4 |
| Symbolic Usage | `$:a`; `x$:y` |
| Marked Arity | 1 (Subject to change) |

| Signature | Explanation |
|----|----|
| any → any; any, any → any | This Chain. (Recursion; calls the same line of the program with the given arguments.) |

### `$v` - Next Chain
| Statistic | Value |
|----|----|
| Speech Part | Verb |
| Hex Representation | `FE10` |
| Nibble Cost | 4 |
| Symbolic Usage | `$va`; `x$vy` |
| Marked Arity | 1 (Subject to change) |

| Signature | Explanation |
|----|----|
| any → any; any, any → any | Next Chain. (Calls the *next* line of the program with the given arguments.) |

### `echo`

### `exit`

### `primn`

### `primq`

### `primf`

### `primo`

### `primfd`

### `primod`

### `prims`

### `prevp`

### `nextp`
