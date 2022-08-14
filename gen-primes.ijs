writefile =: 1!:2

primes =. p: i. 1503
datlines =. _9 (' 'joinstring [: ,&','@":&.> ;/)\ primes
header =. 'enum BigInt[] FirstPrimes = ['
footer =. '];'
dat =. LF joinstring (<footer) ,~ header; '    '&,&.> ;/ datlines
outfile =. < 'primes.txt'
dat writefile outfile
exit 0
