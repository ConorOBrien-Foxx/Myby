# Quick reference

`MA` is short for "Marked Arity". See also the mnemonics table.

Folding over a verb over an integer implicitly folds over a range from `RS` to the integer, where `RS` is the range starter for the range (0 unless otherwise specified).

Trailing open parentheses are stripped and used as byte padding. Leading close parentheses can be used as pseudo flags within the program.

| Command | Hex | Marked | Speech | Arguments | Returns | Explanation |
|----|----|----|----|----|----|----|
| `\` | `2`    | | adjective | verb(1) | verb(1)(list), `MA`=1 | Filter from |
| `\` | `2`    | | adjective | verb(2) | verb(1)(list), `MA`=1 | Fold over |
| `"` | `3`    | | adjective | verb(1) | verb(1)(list) | Map over |
| `"` | `3`    | | adjective | verb(2) | verb(2)(list,list) | Zip with |
| `+` | `4`    | | verb(1) | int | int | Absolute value |
| `+` | `4`    | | verb(1) | list | int | Length |
| `+` | `4`    | ✔️ | verb(2) | int, int | int | Addition |
| `+` | `4`    | ✔️ | verb(2) | string, string | string | Concatenation |
| `-` | `5`    | | verb(1) | int | int | Negate argument |
| `-` | `5`    | | verb(1) | bool | bool | Boolean negation |
| `-` | `5`    | | verb(1) | list | list | Reverse argument |
| `-` | `5`    | ✔️ | verb(2) | int, int | int | Subtraction |
| `*` | `6`    | | verb(1) | int | int | Sign |
| `*` | `6`    | | verb(1) | list | list | Flatten |
| `*` | `6`    | ✔️ | verb(2) | list, string | Join |
| `*` | `6`    | ✔️ | verb(2) | int, int | int | Multiplication. `RS`=1. |
| `/` | `7`    | | verb(1) | string | list | List of character strings |
| `/` | `7`    | ✔️ | verb(2) | int, int | int | Division |
| `/` | `7`    | ✔️ | verb(2) | list, int | list(list) | Chunk list |
| `/` | `7`    | ✔️ | verb(2) | string, string | list(string) | Split strink on list |
| `^` | `8`    | | verb(1) | int | list | Range starting at 1 |
| `^` | `8`    | ✔️ | verb(2) | int, int | int | Exponentiation |
| `#` | `9`    | ✔️ | verb(1) | any | any | Identity |
| `#` | `9`    | | verb(2) | any, any | list | Reshape |
| `&` | `A`    | | conjunction | any, any | verb | Bond. `MA`=1 if either operand is niladic, 2 otherwise. |
| `(` | `B`    | | syntax | | | Open parentheses |
| `)` | `C`    | | syntax | | | Close parentheses |
| `@` | `D`    | | conjunction | any, any | verb | Compose. |
| `R` | `E`    | ✔️ | verb(1) | int | list | Range (0, exclusive) |
| `R` | `E`    | | verb(2) | int, int | list | Range [a,b] (inclusive) |
| `%` | `F0`   | ✔️ | verb(2) | int, int | int | Modulus |
| `$` | `F10`  | | verb(N) | any | any | First chain |
| `$1`| `F11`  | | verb(N) | any | any | Second chain |
| `$2`| `F12`  | | verb(N) | any | any | Third chain |
| `$3`| `F13`  | | verb(N) | any | any | Fourth chain |
| `$N`| `F14`  | | verb(N) | any | any | Nth chain |
| `>:`| `F15`  | ✔️ | verb(2) | any, any | bool | Less or equal to |
| `<:`| `F16`  | ✔️ | verb(2) | any, any | bool | Greater or equal to |
| `>.`| `F17`  | | verb(1) | list | any | Minimum |
| `>.`| `F17`  | ✔️ | verb(2) | any, any | bool | Lesser of |
| `<.`| `F18`  | | verb(1) | list | any | Maximum |
| `<.`| `F18`  | ✔️ | verb(2) | any, any | bool | Greater of |
| `echo`| `F1E`| ✔️ | verb(1) | any | any | Print |
| `@.`| `F1F`  | | multi-conjunction | verbs(\*) | verb(1) | Monad Chain, i.e. `f1@f2@f3@...@fN y` |
| `;` | `F2`   | | verb(1) | any | list | Wrap (singleton list) |
| `;` | `F2`   | ✔️ | verb(2) | any, any | list | Pair |
| `!` | `F3`   | | verb(1) | list | list(list) | Enumerate |
| `!` | `F3`   | ✔️ | verb(2) | int, int | int | Binomial |
| `=` | `F4`   | ✔️ | verb(2) | any, any | bool | Equality |
| `<` | `F5`   | ✔️ | verb(2) | any, any | bool | Less than |
| `>` | `F6`   | ✔️ | verb(2) | any, any | bool | Greater than |
| \`  | `F7`   | | adjective | verb(N) | verb(2-N) | Forces the non-marked arity |
| `{` | `F8`   | | verb(1) | list | any | First element |
| `{` | `F8`   | | verb(2) | list, int | any | Index element |
| `}` | `F9`   | | verb(1) | list | any | Last element |
| `[` | `FA`   | | adjective | verb(1) | verb(2) | Applies verb on left argument |
| `]` | `FB`   | | adjective | verb(1) | verb(2) | Applies verb on right argument |
| `O` | `FC`   | | multi-conjunction | verbs(1,2,1) | verb(2) | Split-Compose/directional fork, i.e. `(f x) g (h y)` |
| `~` | `FD`   | | adjective | verb(2) | verb(1) | Reflex, makes a verb take the same argument twice, i.e. `x f x` |
| `~` | `FD`   | | adjective | verb(2) | verb(2) | Commute, makes a verb take the arguments in reverse order, i.e. `y f x` |
| `exit` | `FE00` | ✔️ | verb(1) | int | n/a | Exits with specified code |
| `exit` | `FE00` | ✔️ | verb(1) | any | n/a |  Exits with code 0 |
| `exit` | `FE00` |    | verb(2) | any, any | n/a | Exits with code 0 |
| `primq` | `FE71` | ✔️ | verb(1) | int | bool | Test for prime |
| `primf` | `FE72` | ✔️ | verb(1) | int | list | Prime factors |
| `primo` | `FE73` | ✔️ | verb(1) | int | list | Number of prime factors (Omega) |

# Example programs

## 1 byte, "sum array" or "sum ints 1 to n"

```
+\
 \      fold
+       addition
```

## 1.5 bytes, "zero array"

```
0"

003B
  3     map
00      zero
   B    padding (open paren)
```

(trailing parens are pruned)

## 2 bytes, "average"
```
+\ / +

4274    
4       addition
 2      folded
  7     divided by
   4    the length
```

## 4 bytes, "swap every two elements in a list"

```
* (-" #/2)

6B539702
    9       the input array
     7      sliced into slices of
      02    2
   3        map
  5         reverse
 B          and then
6           flatten
```

## "fibonacci"

TODO

Direct:
```
!"&R
```

Recursive:
```
$:
-&1 +&$ -&2


5A 01 4A F0 5A 02
```

