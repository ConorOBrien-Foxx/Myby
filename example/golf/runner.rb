require 'json'
require 'open3'
$MYBY = Gem.win_platform? ? '.\myby.exe' : './myby'

base = File.dirname $0
path = File.join base, "problems.json"

problems = JSON::parse File.read path

take = ARGV.map { |e|
    /^-?\d+$/ === e ? e.to_i % problems.size : e
}

verbose = false
take.reject! { |e|
    if /^-?([v])$/ === e
        case $1
        when "v"
            verbose = true
        end
        true
    end
}

def round_all(str, to)
    str.gsub(/-?[\d.]+/) { |f| f.to_f.round to }
end

total_score = 0
problems.each.with_index { |problem, i|
    name = problem["name"]
    next unless take.empty? || take.index(i) || take.any? { |t| String === t && name.index(t) }
    float_precision = problem["float_precision"]
    id = problem["id"]
    tests = problem["tests"]
    flags = ["-j", "-l"]
    if problem["decision"]
        flags << "-y"
    end
    puts "== PROBLEM #{i}: #{name} (##{id}) =="
    success = 0
    total = tests.size
    score = nil
    tests << {} if tests.empty?
    tests.each.with_index(1) { |list, tdx|
        args = [ list["x"] ] rescue []
        args << list["y"] unless list["y"].nil?
        args_repr = args.dup
        args.map! { |arg|
            escaped = arg.to_json.gsub(/\\|'/, '\0\0')
            "unjson'#{escaped}'"
        }
        result = list["result"].to_json
        if problem["decision"] && problem["inverted"]
            result = result == "false" ? "true" : "false"
        end
        codepath = File.join base, "#{name}.myby"
        unless File.exist? codepath
            raise "Could not find file at #{codepath}"
        end
        # cmd = "#$MYBY -l #{codepath} #{args * " "}"
        cmd = [$MYBY, *flags, codepath, *args]
        if list["f"]
            cmd << "-f"
            cmd << list["f"]
        end
        stdout, stderr, status = Open3.capture3 *cmd
        stdout.chomp!
        failed = false
        if status.exitstatus.zero?
            if score.nil?
                score = stderr.scan(/(\d+(?:.\d+)?) byte/)[0][0]
                puts "Score: #{score}b"
            end
        else
            STDERR.puts "Failed due to error:"
            STDERR.puts stderr
            failed = true
        end
        mismatch = if problem["option"]
            # TODO: this compares by strings, rather than
            # by interpreted JSON values. fix that
            result.index(stdout).nil?
        elsif problem["unordered"]
            # p stdout, result
            stdout = JSON::parse(stdout).sort.to_json
            result = JSON::parse(result).sort.to_json
        else
            stdout != result
        end
        if mismatch && !float_precision.nil?
            stdout = round_all stdout, float_precision
            result = round_all result, float_precision
            mismatch = stdout != result
        end
        
        if result != "null" && mismatch
            if verbose
                STDERR.puts "Failed due to result mismatch:"
                STDERR.puts "Expected:"
                STDERR.puts result
                STDERR.puts "Received:"
                STDERR.puts stdout
            end
            failed = true
        end
        if failed
            # cmd.each.with_index(1) { |c, i|
                # puts "Arg #{i}: #{c}"
            # }
            if verbose
                STDERR.puts cmd.inspect
                STDERR.puts stderr.gsub(/^/m, " " * 4).lines[0..5]
            else
                STDERR.puts "Failed ##{tdx}: #{args_repr.map(&:inspect).join ", "}\t❌#{stdout.lines.first}\t✔️#{result.lines.first}"
            end
        else
            success += 1
        end
    }
    total_score += score.to_f
    puts "#{success} / #{total} passed"
}
puts "Total score: #{total_score}b"
