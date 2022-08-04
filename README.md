# Myby
***A language inspired by J and Nibbles.***

See [the Quick Reference](./QUICKREF.md) for a description of the commands. May be slightly out of date. See also some [example programs](./example).

## Parse behavior
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

## Trains
 - 2-train is an Atop (as in APL)
 - 3-train is a Fork (as in J/APL)
 - A noun present in a Train is treated as a constant function returning itself, hence all nouns are really just niladic verbs

## Instruction Encoding
When specified, X/Y refers to the Unary/Binary behavior, respectively. X will indicate an unassigned behavior.

| Hex code | Meaning |
|----------|---------|
| `0x0` | Raw Noun (Integer) |
| `0x1` | Raw Noun (String) |
| `0x2` | Filter/Fold Adjective |
| `0x3` | Map/ZipWith Adjective |
| `0x4` | Absolute Value/Add |
| `0x5` | Negate/Subtract |
| `0x6` | X/Multiply |
| `0x7` | X/Divide |
| `0x8` | OneRange/Exponentiate |
| `0x9` | Identity/Pair |
| `0xA` | Bond Conjunction |
| `0xB` | Open paren |
| `0xC` | Close paren |
| `0xD` | Compose Conjunction |
| `0xE` | Range/Range |
| `0xFZ` | [Multinibble instructions, as follows] |
| `0xF0` | X/Modulus |
| `0xF1Z` | [More multinible instructions, as follows] |
| `0xF10` | 1st Chain |
| `0xF11` | 2nd Chain |
| `0xF12` | 3rd Chain |
| `0xF13` | 4th Chain |
| `0xF14` | Nth Chain after first |
| `0xF15` | X/Less than or equal |
| `0xF16` | X/Greater than or equal |
| `0xF17` |  |
| `0xF18` |  |
| `0xF19` |  |
| `0xF1A` |  |
| `0xF1B` |  |
| `0xF1C` |  |
| `0xF1D` |  |
| `0xF1E` |  |
| `0xF1F` |  |
| `0xF2` | Wrap/Pair |
| `0xF3` | Enumerate/Binomial |
| `0xF4` | X/Equality |
| `0xF5` | X/Less than |
| `0xF6` | X/Greater than |
| `0xF7` | Force opposite implicit Adjective |
| `0xF8` | First/Index |
| `0xF9` | Last/X |
| `0xFA` | OnLeft |
| `0xFB` | OnRight |
| `0xFC` | Split-Compose |
| `0xFD` | Reflex |
| `0xFEZZ` | Two-Byte extensions |
| `0xFF` | Section break |