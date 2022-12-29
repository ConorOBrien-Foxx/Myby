require 'open3'
# TODO: make relative to path?
$MYBY = Gem.win_platform? ? '.\myby.exe' : './myby'

require 'pathname'

if ARGV.size < 1
    STDERR.puts "Error: Expected at least 1 argument, got 0"
    STDERR.puts "Usage: distr.rb source_path [path_2 path_3 ...]"
    exit 1
end

files = ARGV.map { |arg|
    File.join(Pathname.new(arg).cleanpath, "*.myby")
        .gsub "\\", "/"
}.flat_map { |src| Dir[src] }

distr = {}
graphs = [1, 2, 3]
graphs.each { |n|
    distr[n] = Hash.new(0)
}
consts = Hash.new(0)
const_aliases = {
    "lf" => "'\\n'"
}
largest = Hash.new(0)
files.each { |path|
    stdout, stderr, status = Open3.capture3 $MYBY, "-lax", path
    lines = stdout.lines.each_slice(5).map { |e|
        e[3].split("│").map(&:strip) - [""]
    }
    
    lines.each { |atoms|
        atoms.select { |atom| /^(\d+|'.+'|[EAL]|vow|con)$/ === atom }.each { |catom|
            catom = const_aliases[catom] || catom
            consts[catom] += 1
        }
        graphs.each { |stride|
            atoms.each_cons(stride) { |gp|
                largest[stride] = [
                    largest[stride],
                    distr[stride][gp.join " "] += 1
                ].max
            }
        }
    }
}

# silly hashing algorithm that distinguishes different input paths
id = ARGV.sort.map { |arg| arg.scan(/\w+/).map { |s| s[0] }.join }.join "-"
out_name = Time.now.strftime "digest-#{id}-%m-%d-%Y.txt"
out_path = File.join "stats", out_name
$output = ""
def out(*args)
    puts args
    $output += args.join("\n") + "\n"
end
def out_bar(distr, largest, hide_small: true)
    h = distr
        # key value pairs
        .to_a
        # sort numbers before non-numbers, and use numeric sort for numbers
        .group_by { |key, value| /^\d/ === key ? 0 : key[0] == "'" ? 1 : 2 }
        .to_a
        .sort_by { |clave, pairs| clave }
        .flat_map { |clave, pairs|
            if clave.zero?
                pairs.sort_by { |key, value| key.to_i }
            else
                pairs.sort_by { |key, value| key }
            end
        }
        # then sort (stably) by bar value
        .sort_by.with_index { |(key, value), idx| [-value, idx] }
    h.select! { |k, v| v > 1 } if hide_small
    maxpad = 2 + h.flatten.map { |e| e.to_s.size }.max
    width = [20, largest].min
    h.map { |e|
        bar = "#" * (width * e[1] / largest)
        out e.map { |e| e.to_s.ljust maxpad }.join + bar
    }
end
graphs.each { |stride|
    out "stride #{stride}:"
    out_bar distr[stride], largest[stride]
}
out "constants:"
out_bar consts, consts.map(&:size).max, hide_small: false

File.write out_path, $output
puts "Output saved to #{out_path}"
