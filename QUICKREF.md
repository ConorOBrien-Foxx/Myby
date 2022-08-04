# Quick reference

"MA" is short for "Marked Arity".

| Command | Hex | Marked | Speech | Arguments | Returns | Explanation |
|----|----|----|----|----|----|----|
| `\` | `2`  | | adjective | verb(1) | verb(1)(list), MA=1 | Filter from |
| `\` | `2`  | | adjective | verb(2) | verb(1)(list), MA=1 | Fold over |
| `"` | `3`  | | adjective | verb(1) | verb(1)(list) | Map over |
| `"` | `3`  | | adjective | verb(2) | verb(2)(list,list) | Zip with |
| `+` | `4`  | | verb(1) | int | int | Absolute value |
| `+` | `4`  | | verb(1) | list | int | Length |
| `+` | `4`  | ✔️ | verb(2) | int, int | int | Addition |
| `-` | `5`  | | verb(1) | int | int | Negate argument |
| `-` | `5`  | | verb(1) | list | list | Reverse argument |
| `-` | `5`  | ✔️ | verb(2) | int, int | int | Subtraction |
| `*` | `6`  | | verb(1) | int | Sign |
| `*` | `6`  | | verb(1) | list | Flatten |
| `*` | `6`  | ✔️ | verb(2) | int, int | Multiplication |
| `/` | `7`  | ✔️ | verb(2) | int, int | Division |
| `/` | `7`  | ✔️ | verb(2) | list, int | Chunk list |
| `^` | `8`  | ✔️ | verb(2) | int, int | Exponentiation |
| `#` | `9`  | ✔️ | verb(1) | any | any | Identity |
| `#` | `9`  | | verb(2) | any, any | Reshape |
| `&` | `A`  | | conjunction | any,any | verb | Bond. MA=1 if either operand is niladic, 2 otherwise. |
| `(` | `B`  | | syntax | | | Open parentheses |
| `)` | `C`  | | syntax | | | Close parentheses |
| `%` | `D`  | ✔️ | verb(2) | int, int | Modulus |
| `R` | `E`  | | verb(1) | int | list | Range (0, exclusive) |
| `$` | `F0` | | verb(N) | any | any | First chain |
| `;` | `F2` | | verb(1) | any | list | Wrap (singleton list) |
| `;` | `F2` | ✔️ | verb(2) | any, any | list | Pair |
| `!` | `F3` | | verb(1) | list | Enumerate |
| `!` | `F3` | | verb(2) | int, int | Binomial |
| `=` | `F4` | ✔️ | verb(2) | any, any | Equality |
| `<` | `F5` | ✔️ | verb(2) | any, any | Less than |
| `>` | `F6` | ✔️ | verb(2) | any, any | Greater than |
| \`  | `F7`  | | adjective | verb(N) | verb(2-N) | Forces the non-marked arity |
| `{` | `F8` | | verb(1) | list | First element |
| `{` | `F8` | | verb(2) | list, int | Index element |
| `}` | `F9` | | verb(1) | list | Last element |
| `[` | `FA` | | adjective | verb(1) | verb(2) | Applies verb on left argument |
| `]` | `FB` | | adjective | verb(1) | verb(2) | Applies verb on right argument |
| `O` | `FC` | | multi-conjunction | verbs(1,2,1) | verb(2) | Split-Compose/directional fork, i.e. `(f x) g (h y)` |
| `~` | `FD` | | adjective | verb(2) | verb(1) | Reflex, makes a verb take the same argument twice, i.e. `x f x` |
| `~` | `FD` | | adjective | verb(2) | verb(2) | Commute, makes a verb take the arguments in reverse order, i.e. `y f x` |

Trailing open parentheses are stripped and used as byte padding. Leading close parentheses can be used as pseudo flags within the program.

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

