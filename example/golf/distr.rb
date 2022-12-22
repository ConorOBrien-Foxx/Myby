require 'open3'
$MYBY = Gem.win_platform? ? '.\myby.exe' : './myby'

require 'pathname'
src = File.join Pathname.new(ARGV[0]).cleanpath, "*.myby"
files = Dir[src.gsub("\\", "/")]

distr = {}
graphs = [1, 2, 3]
graphs.each { |n|
    distr[n] = Hash.new(0)
}
largest = Hash.new(0)
files.each { |path|
    stdout, stderr, status = Open3.capture3 $MYBY, "-lax", path
    lines = stdout.lines.each_slice(5).map { |e|
        e[3].split("│").map(&:strip) - [""]
    }
    
    lines.each { |atoms|
        graphs.each { |stride|
            atoms.each_cons(stride) { |gp|
                largest[stride] = [largest[stride], distr[stride][gp.join " "] += 1].max
            }
        }
    }
}

out_name = "digest-10-2022.txt"
$output = ""
def out(*args)
    puts args
    $output += args.join("\n") + "\n"
end
graphs.each { |stride|
    out "stride #{stride}:"
    h = distr[stride].to_a.sort_by(&:last).reverse.select { |k, v| v > 1 }
    maxpad = 2 + h.flatten.map { |e| e.to_s.size }.max
    width = [20, largest[stride]].min
    h.map { |e|
        bar = "#" * (width * e[1] / largest[stride])
        out e.map { |e| e.to_s.ljust maxpad }.join("") + bar
    }
}
File.write out_name, $output
