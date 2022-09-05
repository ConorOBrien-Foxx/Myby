module myby.memo;

import std.traits;

// TODO: different memory methods
// TODO: integrating the resetAge into the lookup step should increase performance
struct FixedMemo(Hash, uint max = 100) {
    alias Key = KeyType!Hash;
    alias Value = ValueType!Hash;
    Hash memo;
    Key[] age;

    void resetAge(Key k) {
        import std.algorithm.searching : countUntil;
        import std.algorithm.mutation : swapAt;
        auto index = age.countUntil(k);
        if(index < 0) {
            if(age.length == max) {
                age[$-1] = k;
            }
            else {
                age ~= k;
            }
        }
        else {
            age.swapAt(index, 0);
        }
    }
    
    auto opBinaryRight(string op : "in")(Key k) {
        resetAge(k);
        return k in memo;
    }
    
    auto opIndex(Key k) {
        resetAge(k);
        return memo[k];
    }
    
    auto opIndexAssign(Value v, Key k) {
        resetAge(k);
        return memo[k] = v;
    }
}
