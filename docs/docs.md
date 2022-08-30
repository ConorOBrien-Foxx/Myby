# Overview

*Looking for [Commands](#commands)?*

This page contains documentation for Myby's commands and their various implemented behaviors.

Note: Mathematical operations result in a double if either `x` or `y` is a double, and is otherwise an integer. Also, for mathematical operations, bools are treated as `1` and `0` if `true` or `false` respectively.

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

To describe the behavior of commands, the format **A** → **B** is used to denote the _signature_ of a command with arguments **A** resulting in **B**. Furthermore, to describe a returned verb, the format **V** : **A** → **B** is used. Here are some examples:

- int → string - *input is an integer, returns a string*
- string → list(string) - *input is a string, returns a list of strings*
- int, int → int - *input is two integers, returns an integer**
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

#### Examples

```myby
+\          NB. sum.
            NB. +'s marked arity is 2, so \ deduces fold
(#<5)\      NB. filter for less than 5.
            NB. marked arity for a Fork with Niladic tine is 1, so \ deduces fold
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
| verb(2) → (verb(2) : list, list → list) | Zip with. (For elements `x` and `y` at corresponding indices from the lists, computes `x u y`. Truncates the resulting list to the length of the shorter input list.) |

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
| string → int; array → int | Length |
| number, number → number | Addition |
| string, string → string | String concatenation |
| array, array → array | Array concatenation |

### `-` - Subtract

| Statistic | Value |
|----|----|
| Speech Part | Verb |
| Hex Representation | `5` |
| Nibble Cost | 1 |
| Symbolic Usage | `-a`; `x-y` |
| Marked Arity | 2 |
| Identity | none |

| Signature | Explanation |
|----|----|
| number → number | Negation |
| bool → bool | Logical negation |
| string → string; array → array | Reverse |
| number, number → number | Subtraction |

### `*` - Multiplication

### `/` - Division

### `^` - Exponentiation

### `#` - Identity

### `R` - Range

### `%` - Modulus

### `;` - Pair

### `!` - Binomial

### `{` - First

### `}` - Last

### `=` - Equality

### `<` - Less Than

### `>` - Greater Than

### `<:` - Less Or Equal

### `>:` - Greater Or Equal

### `<.` - Minimum

### `>.` - Maximum

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