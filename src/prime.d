module myby.prime;

import std.algorithm.searching;

// modified from https://en.wikipedia.org/wiki/Primality_test
enum PreCheckPrimes = [2, 3, 5, 7];
enum FirstCheckPrime = 11;
bool isPrime(T)(T n) {
    if (PreCheckPrimes.canFind(n)) {
        return true;
    }

    if (n <= 1) {
        return false;
    }
    
    static foreach(divisor; PreCheckPrimes) {
        if(n % divisor == 0) {
            return false;
        }
    }

    for(T i = FirstCheckPrime; i * i <= n; i += 6) {
        if (n % i == 0 || n % (i + 2) == 0) {
            return false;
        }
    }

    return true;
}

T[] primeFactors(T)(T n) {
    T[] factors;

    if(n <= 1) {
        return factors;
    }
    
    void addDivisibleFactors(S)(S divisor) {
        pragma(inline, true);
        while(n % divisor == 0) {
            n /= divisor;
            T append = divisor;
            factors ~= append;
        }
    }
    
    static foreach(divisor; PreCheckPrimes) {
        addDivisibleFactors(divisor);
    }
    
    for(T i = FirstCheckPrime; i * i <= n; i += 6) {
        addDivisibleFactors(i);
        addDivisibleFactors(i + 2);
    }
    
    if(n > 2) {
        factors ~= n;
    }
    
    return factors;
}