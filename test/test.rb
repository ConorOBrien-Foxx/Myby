require 'open3'
$MYBY = Gem.win_platform? ? '.\myby.exe' : './myby'

tests = [
    {
        input: '-l example/first-n-primes.myby 30',
        output: "2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97 101 103 107 109 113\n",
        succeeds: true,
    },
    {
        input: '-l example/hello.myby',
        output: "Hello, World!\n",
        succeeds: true,
    },
    {
        input: '-c example/hello.myby',
        output: "\x1E(EcO\f\x007~LD\x81",
        error: "Converted bytes: 1E 28 45 63 4F 0C 00 37 7E 4C 44 81\n",
        succeeds: true,
    },
    {
        input: '-l example/table.myby 5',
        output: "1  2  3  4  5\n2  4  6  8 10\n3  6  9 12 15\n4  8 12 16 20\n5 10 15 20 25\n",
        succeeds: true,
    },
    {
        input: '-l -e "(#%2)\ ^" 9',
        output: "1 3 5 7 9\n",
        succeeds: true,
    },
    {
        input: '-c -e "3+4"',
        output: "\x03@K",
        succeeds: true,
    },
    {
        input: 'example/half-square-double.cmyby 10',
        output: "50\n",
        succeeds: true,
    },
    {
        input: '-l -e "6/2"',
        output: "3\n",
        succeeds: true,
    },
    {
        input: '-l -e "6/4"',
        output: "1.5\n",
        succeeds: true,
    },
    {
        input: '-l -e "1 ^V _2 _1 0 1 2"',
        output: "1 1 1 1 1\n",
        succeeds: true,
    },
    *[*1..10, 20, 30, 50, 70, 1000, 1112, 2000, 3000, 4000, 900000, 1000000000].map { |n| {
        input: "-l -e \"#{n}\"",
        output: "#{n}\n",
        succeeds: true,
    } },
    *%w(1.0 10.0 100.0 200.0 2.71828 3.5 3.14159265 0.0 _0.0 _1.0 _0.1 _0.00003 _2.0 _3.0).map { |n| {
        input: "-l -e \"#{n}\"",
        output: "#{n}\n",
        succeeds: true,
        comparison: :float,
    } },
]

def indent_all(str)
    return "" if str.nil?
    str.force_encoding "ASCII-8BIT"
    str.lines.map { |line| " │ #{line}" }.join
end

MAX_FLOAT_TOLERANCE = 1e-5

success_count = 0
tests.each.with_index(1) { |test, i|
    stdout, stderr, status = Open3.capture3("#$MYBY #{test[:input]}")
    
    failed = false
    fail_reason = ""
    if test[:succeeds] != status.success?
        failed = true
        expectation = test[:succeeds] ? "pass" : "fail"
        reality = status.success? ? "passed" : "failed"
        fail_reason = "Expected the test to #{expectation}, but it actually #{reality}:\n#{indent_all stderr}"
    
    elsif test[:output] != nil
        if test[:comparison] == :float
            out_float = stdout.tr("_", "-").to_f
            expect_float = test[:output].tr("_", "-").to_f
            diff = (out_float - expect_float).abs
            if diff >= MAX_FLOAT_TOLERANCE
                failed = true
            end
        elsif !(test[:output] === stdout)
            failed = true
        end
        if failed
            fail_reason = "Incongruent outputs.\nExpected:\n#{indent_all test[:output]}\nReceived:\n#{indent_all stdout}"
        end
    elsif test[:error] != nil && !(test[:error] === stderr)
        failed = true
        fail_reason = "Incongruent stderrs.\nExpected:\n#{indent_all test[:error]}\nReceived:\n#{indent_all stderr}"
    end
    
    if failed
        puts "Test #{i} failed: #{fail_reason}"
    else
        success_count += 1
    end
}
puts "#{success_count}/#{tests.size} tests passed."
if success_count == tests.size
    puts "All test cases passed!"
else
    puts "#{tests.size - success_count} tests failed."
end