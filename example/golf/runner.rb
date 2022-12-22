require 'json'
require 'open3'
$MYBY = Gem.win_platform? ? '.\myby.exe' : './myby'

base = File.dirname $0
path = File.join base, "problems.json"

problems = JSON::parse File.read path

take = ARGV.map { |e|
    /^-?\d+$/ === e ? e.to_i % problems.size : e
}

problems.each.with_index { |problem, i|
    name = problem["name"]
    next unless take.empty? || take.index(i) || take.index(name)
    float_precision = problem["float_precision"]
    id = problem["id"]
    tests = problem["tests"]
    puts "== PROBLEM #{i}: #{name} (##{id}) =="
    success = 0
    total = tests.size
    score = nil
    tests << {} if tests.empty?
    tests.each { |list|
        args = [ list["x"] ] rescue []
        args << list["y"] unless list["y"].nil?
        args.map! { |arg|
            escaped = arg.to_json.gsub(/\\|'/, '\0\0')
            "unjson'#{escaped}'"
        }
        result = list["result"].to_json
        codepath = File.join base, "#{name}.myby"
        unless File.exist? codepath
            raise "Could not find file at #{codepath}"
        end
        # cmd = "#$MYBY -l #{codepath} #{args * " "}"
        cmd = [$MYBY, "-j", "-l", codepath, *args]
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
        mismatch = stdout != result
        if mismatch && !float_precision.nil?
            stdout = stdout.to_f.round float_precision
            result = result.to_f.round float_precision
            mismatch = stdout != result
            stdout = "≈#{stdout}"
            result = "≈#{result}"
        end
        
        if result != "null" && mismatch
            STDERR.puts "Failed due to result mismatch:"
            STDERR.puts "Expected:"
            STDERR.puts result
            STDERR.puts "Received:"
            STDERR.puts stdout
            failed = true
        end
        if failed
            # cmd.each.with_index(1) { |c, i|
                # puts "Arg #{i}: #{c}"
            # }
            STDERR.puts cmd.inspect
            STDERR.puts stderr.gsub(/^/m, " " * 4).lines[0..5]
        else
            success += 1
        end
    }
    puts "#{success} / #{total} passed"
}