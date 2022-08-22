# Myby
***A language inspired by J and Nibbles.***

See [the Quick Reference](./QUICKREF.md) for a description of the commands. May be slightly out of date. See also some [example programs](./example).

## Compiling and Running

Since this project is still in its early stages, right now, the only way to compile consistently (that is tested) is using the corresponding [Batchfile](./compile.bat). However, the following command should work and be equivalent for Bash:

```sh
dmd -g -w src/*.d -of=myby
```

To run a literate program from a file: `myby -l file-name "arg1" "arg2"`. Arguments are interpreted as literate Myby code.

To compile a literate program from a file: `myby -c file-name`. To save the resulting code to a file, `myby -c file-name -o out-file`.

## Language

### Parse behavior
A program consists of a series of:
 - Verbs (V), the actions of a program
 - Nouns (N), the data of a program
 - Adjectives (A), the unary modifiers of actions
 - Conjunctions (C), the binary modifiers of actions
 - Multi-Conjunction (M), the k-ary modifiers of actions (applied postfix)

Program sentences are then condensed according to these rules:
```
VA -> V, an Adjective modifying a Verb is a Verb
[NOT CURRENTLY IMPLEMENTED/USED:] NA -> A, an Adjective modifying a Noun is an Adjective
VCV -> V, a Conjunction modifying two Verbs is a Verb
V*M -> V, a Multi-Conjunction modifying k Verbs is a Verb
V* -> V, a train of Verbs is a Verb
```

Example: `VACVAA -> (VA)C((VA)A)`

### Trains
 - 2-train is an Atop (as in APL)
 - 3-train is a Fork (as in J/APL)
 - A noun present in a Train is treated as a constant function returning itself, hence all nouns are really just niladic verbs

### Instruction Encoding
When specified, X/Y refers to the Unary/Binary behavior, respectively. A variable will indicate an unassigned behavior.

| Hex code | Meaning |
|----------|---------|
| `0x0` | Raw Noun (Integer) |
| `0x1` | Raw Noun (String) |
| `0x2` | Filter/Fold Adjective |
| `0x3` | Map/ZipWith Adjective |
| `0x4` | Absolute Value/Add |
| `0x5` | Negate/Subtract |
| `0x6` | Flatten/Multiply |
| `0x7` | Unique/Divide |
| `0x8` | OneRange/Exponentiate |
| `0x9` | Identity/Pair |
| `0xA` | Bond Conjunction |
| `0xB` | Open paren |
| `0xC` | Close paren |
| `0xD` | Compose Conjunction |
| `0xE` | Range/Range |
| `0xFZ` | [Multinibble instructions, as follows] |
| `0xF0` | Sort/Modulus |
| `0xF1Z` | [More multinible instructions, as follows] |
| `0xF10` | 1st Chain |
| `0xF11` | 2nd Chain |
| `0xF12` | 3rd Chain |
| `0xF13` | 4th Chain |
| `0xF14` | Nth Chain after first |
| `0xF15` | X/Less than or equal |
| `0xF16` | X/Greater than or equal |
| `0xF17` | Minimum/Lesser of 2 |
| `0xF18` | Maximum/Greater of 2 |
| `0xF19` | OnLeft |
| `0xF1A` | OnRight |
| `0xF1B` |  |
| `0xF1C` |  |
| `0xF1D` | Power |
| `0xF1E` | Print |
| `0xF1F` | Monad Chain |
| `0xF2` | Wrap/Pair |
| `0xF3` | Enumerate/Binomial |
| `0xF4` | X/Equality |
| `0xF5` | X/Less than |
| `0xF6` | X/Greater than |
| `0xF7` | Force opposite implicit Adjective |
| `0xF8` | First/Index |
| `0xF9` | Last/X |
| `0xFA` | OnPrefixes |
| `0xFC` | Split-Compose |
| `0xFD` | Reflex |
| `0xFEZZ` | [Two-Byte extensions] |
| `0xFE00` | Exit/Exit |
| `0xFE70` | N-th prime/Y |
| `0xFE71` | Prime/Coprime test |
| `0xFE72` | Prime factors/Y |
| `0xFE73` | Number of prime factors/Y |
| `0xFE74` | Distinct prime factors/Y |
| `0xFE75` | Number of distinct prime factors/Y |
| `0xFE76` | Prime before/Y |
| `0xFE77` | Prime after/Y |
| `0xFE78` | First N Primes/Y |
| `0xFF` | Section break |