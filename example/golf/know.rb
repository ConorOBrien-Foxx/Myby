require 'pathname'
src = File.join Pathname.new(ARGV[0]).cleanpath, "*.myby"
files = Dir[src.gsub("\\", "/")]
pat = Regexp.new ARGV[1]
longest = files.map { |e| File.basename(e).size }.max

files.each { |path|
    dat = File.read path
    if pat === dat
        offset = 0
        res = dat.dup
        dat.to_enum(:scan, pat).map {
            first, last = Regexp.last_match.offset(0)
            first += offset
            last += offset
            updated = "\x1B[1;94m#{res[first...last]}\x1B[0m"
            offset += updated.size - res[first...last].size
            res[first...last] = updated
        }
        
        header = File.basename(path)
        lines = res.lines.map { |line|
            line.chomp!
            [line, line.size - line.scan(/\x1B.+?m/).sum(&:size)]
        }
        hsize = [header.size, *lines.map { |line, size| size }].max
        struts = "─" * hsize
        puts "┌─#{struts}─┐"
        puts "│ #{header.center hsize} │"
        puts "├─#{struts}─┤"
        puts lines.map { |line, size|
            line.chomp!
            # padto = hsize + line.scan(/\x1B.+?m/).sum(&:size)
            # p line.scan(/\x1B.+?m/), 
            padto = hsize + line.size - size
            "│ #{line.ljust padto} │"
        }
        puts "└─#{struts}─┘"
        # res = res.lines.map.with_index { |e, i|
            # i == 0 ? e : " " * (longest + 3) + e
        # }.join
        # puts "#{File.basename(path).ljust longest} : #{res}" if pat === dat 
    end
}