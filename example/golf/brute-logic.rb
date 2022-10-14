require 'open3'
$MYBY = Gem.win_platform? ? '.\myby.exe' : './myby'

def incr!(arr)
    i = arr.size - 1
    while i >= 0
        arr[i] += 1
        if arr[i] >= 16
            arr[i] = 0
            i -= 1
        else
            break
        end
    end
    if i < 0
        arr.unshift 0
        puts "new size: #{arr.size}"
    end
    arr
end

code = [0]
domain = [
    ["0","0"],
    ["0","1"],
    ["1","0"],
    ["1","1"],
]

outs = {}
sizes = {}

test_code = %w(FF F6 B0 1C B0 0C 9F 16 34 2F 10 BA 2B D0 A0 1D D).join.chars.map { |e| e.to_i 16 }
until outs.size == 16
    print "#{code} \r"
    copy = code
    copy += test_code
    collated = copy.each_slice(2).map { |a, b=0xB| a * 16 + b }
    temp = File.open("temp", "wb")
    temp.write collated.pack("c*")
    temp.close
    cmd = [$MYBY, "temp"]
    stdout, stderr, status = Open3.capture3 *cmd
    if status.exitstatus.zero? && /^[01]{4}\n$/ === stdout 
        result = stdout.chomp!
        # prefix = outs[result].nil? ? "[!] " : "[-] "
        readable = `#$MYBY -u temp`.lines[0].chomp
        if outs[result].nil?
            outs[result] = [readable]
            sizes[result] = code.size
            # puts "#{prefix}#{code.map{|e|e.to_s 16}.join.upcase.ljust 8}#{result}"
            puts "[!] #{readable.ljust 7} #{result}"
        elsif code.size <= sizes[result]
            outs[result] << readable
        end
    end
    incr! code
end

%w(0000
0001
0010
0011
0100
0101
0110
0111
1000
1001
1010
1011
1100
1101
1110
1111).each { |k|
    puts "#{k} =>"
    puts outs[k].map { |e| "  #{e}"}
}

File.delete("temp")