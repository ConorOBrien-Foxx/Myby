require 'json'
require 'open3'
$MYBY = Gem.win_platform? ? '.\myby.exe' : './myby'

base = File.dirname $0
path = File.join base, "problems.json"

take = ARGV

problems = JSON::parse File.read path
problems.each.with_index { |problem, i|
    next unless take.nil? || take.index(i.to_s)
    id = problem["id"]
    name = problem["name"]
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
            "unjson'#{arg.to_json.gsub("'", "''")}'"
        }
        result = list["result"].to_json
        codepath = File.join base, "#{name}.myby"
        unless File.exist? codepath
            raise "Could not find file at #{codepath}"
        end
        # cmd = "#$MYBY -l #{codepath} #{args * " "}"
        cmd = [$MYBY, "-j", "-l", codepath, *args]
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
        if result != "null" && stdout != result
            STDERR.puts "Failed due to result mismatch:"
            STDERR.puts "Expected:"
            STDERR.puts result
            STDERR.puts "Received:"
            STDERR.puts stdout
            failed = true
        end
        if failed
            STDERR.puts cmd.inspect
            STDERR.puts stderr.gsub(/^/m, " " * 4).lines[0..5]
        else
            success += 1
        end
    }
    puts "#{success} / #{total} passed"
}