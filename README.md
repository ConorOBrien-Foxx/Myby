# Myby
***A language inspired by J and Nibbles.***

[The most up-to-date quick reference](https://conorobrien-foxx.github.io/Myby/). May still be slightly out of date. See also some [example programs](./example).

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