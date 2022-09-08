# Overview

*Looking for [Commands](#commands)?*

This page contains documentation for Myby's commands and their various implemented behaviors.

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
NB. A multiplication table using the two given arrays:
1 2 3 4 *\ 5 6 7
NB.=>  5  6  7
NB.=> 10 12 14
NB.=> 15 18 21
NB.=> 20 24 28
NB. Using monadic ^, One Range, a multiplication table along the given input:
*\~ ^
NB. E.g., input = 6:
NB.=> 1  2  3  4  5  6
NB.=> 2  4  6  8 10 12
NB.=> 3  6  9 12 15 18
NB.=> 4  8 12 16 20 24
NB.=> 5 10 15 20 25 30
NB.=> 6 12 18 24 30 36
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

### `[` - On Left

| Statistic | Value |
|----|----|
| Speech Part | Adjective |
| Hex Representation | `F19` |
| Nibble Cost | 3 |
| Symbolic Usage | `u[` |

| Signature | Explanation |
|----|----|
| verb(1) → verb(2) | Left application. (With arguments `x` and `y`, computes `u@x`.) |

### `]` - On Right

| Statistic | Value |
|----|----|
| Speech Part | Adjective |
| Hex Representation | `F1A` |
| Nibble Cost | 3 |
| Symbolic Usage | `u]` |

| Signature | Explanation |
|----|----|
| verb(1) → verb(2) | Left application. (With arguments `x` and `y`, computes `u@y`.) |

### `!.` - Inverse

**NOTE:** Limited implementation at this stage.

### `G` - Generate

### `~` - Reflex

### `` ` `` - Arity Force

### `benil`

| Statistic | Value |
|----|----|
| Speech Part | Adjective |
| Hex Representation | `FE80` |
| Nibble Cost | 4 |
| Symbolic Usage | `u benil` |

| Signature | Explanation |
|----|----|
| verb(0) → verb(1) | Nil defaulting. (Returns argument `a` if not `nil`. Otherwise, returns `u@a`, aka, niladic value of `u`.) |

## Conjunctions and Multi Conjunctions

### `&` - Bond

### `@` - Compose

### `&.` - Under

### `@.` - Monad Chain

### `^:` - Power

### `\.` - On Prefixes

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
| number → list(number) | Inclusive range starting at 1 |
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
| number → list(number) | Range \[0,a). (Reversed if a < 0.) |
| number, number → list(number) | Range [x,y] |
| list, list → list; string, string → string | Multi Range. (Treats `x` as the minimums and `y` as the maximums of a mixed base system, and generates all the entries from `x` to `y`. See the Examples below.) |

#### Examples

```myby
R5
NB.=> [0, 1, 2, 3, 4]
3 R 6
NB.=> [3, 4, 5, 6]
1 2 R 2 5
NB.=> 1 2
NB.=> 1 3
NB.=> 1 4
NB.=> 1 5
NB.=> 2 2
NB.=> 2 3
NB.=> 2 4
NB.=> 2 5
'aa' R 'cc'
NB.=> [aa, ab, ac, ba, bb, bc, ca, cb, cc]
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
;@5
NB.=> [5]
NB. @ is necessary here, since ;'s marked arity is 2, and (;5) redirects to ;&5
4 ; 'a'
NB.=> [4, a]
1 ; 2 ; 3 ; 4
NB.=> [1, 2, 3, 4]
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
!\~ R15 @.  NB. Binomial table over [0,14]
NB.=> 1 1 1 1 1  1  1  1  1   1   1   1   1    1    1
NB.=> 0 1 2 3 4  5  6  7  8   9  10  11  12   13   14
NB.=> 0 0 1 3 6 10 15 21 28  36  45  55  66   78   91
NB.=> 0 0 0 1 4 10 20 35 56  84 120 165 220  286  364
NB.=> 0 0 0 0 1  5 15 35 70 126 210 330 495  715 1001
NB.=> 0 0 0 0 0  1  6 21 56 126 252 462 792 1287 2002
NB.=> 0 0 0 0 0  0  1  7 28  84 210 462 924 1716 3003
NB.=> 0 0 0 0 0  0  0  1  8  36 120 330 792 1716 3432
NB.=> 0 0 0 0 0  0  0  0  1   9  45 165 495 1287 3003
NB.=> 0 0 0 0 0  0  0  0  0   1  10  55 220  715 2002
NB.=> 0 0 0 0 0  0  0  0  0   0   1  11  66  286 1001
NB.=> 0 0 0 0 0  0  0  0  0   0   0   1  12   78  364
NB.=> 0 0 0 0 0  0  0  0  0   0   0   0   1   13   91
NB.=> 0 0 0 0 0  0  0  0  0   0   0   0   0    1   14
NB.=> 0 0 0 0 0  0  0  0  0   0   0   0   0    0    1
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
| number, list → any; number, string → string | `x`th element of `y`. (Implements modular indexing, i.e., wraps around. E.g., `_1{y` ⇔ `(#-1){y`.) |

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
3 = '3'
NB.=> 0b
6 = 3 + 3
NB.=> 1b
= 1 2 3 2 4 1 @.
NB.=> 1 0 0 0 0 1
NB.=> 0 1 0 1 0 0
NB.=> 0 0 1 0 0 0
NB.=> 0 0 0 0 1 0
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
'[3, 4]' = <@(3;4)
NB.=> 1b
-&.< 1234
NB.=> 4321
(# + -&.<)@1234
NB.=> 5555
3.5
```

### `>` - Greater Than

| Statistic | Value |
|----|----|
| Speech Part | Verb |
| Hex Representation | `F6` |
| Nibble Cost | 2 |
| Symbolic Usage | `>a`; `x>y` |
| Marked Arity | 1 |

| Signature | Explanation |
|----|----|
| list → string | Join. (Joins `a` by the empty string, converting each element to a string.) |
| any, any → bool | Greater than. (Errors if incomparable.) |

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