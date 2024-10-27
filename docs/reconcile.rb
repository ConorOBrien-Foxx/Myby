Dir.chdir File.dirname __FILE__

# used for reconciling two different markdown tables
def get_ranks(byte_counts)
    rank = 0
    drift = 1
    final_ranks = ([nil] + byte_counts).each_cons(2).map { |a,b|
        if a == b
            drift += 1
        else
            rank += drift
            drift = 1
        end
        rank
    }
    final_ranks
end

def reconcile(a, b)
    existing_order = []
    answers = {}
    start_indices = [a, b].map { |table|
        table_lines = table.lines
        start_idx = 1 + table_lines.find_index { |line| line["|----"] }
        table_lines[start_idx..-1].map { |line|
            _, language, rank, bytes, code = line.split("|").map(&:strip)
            rank = rank.to_i
            bytes = bytes[0...-1].to_i
            language_link = language
            
            if /\[(.+)\]/ === language_link
                language = $1
            end
            existing_order << language unless existing_order.include? language
            if answers[language]
                _, _, _, existing_bytes, _ = answers[language]
                if existing_bytes > bytes
                    answers[language] = [ language, language_link, rank, bytes, code ]
                end
            else
                answers[language] = [ language, language_link, rank, bytes, code ]
            end
        }
        start_idx
    }
    puts a.lines[0...start_indices[0]]
    existing_order.sort_by! { |language| [ answers[language][3], language ] }
    byte_counts = existing_order.map { |language| answers[language][3] }
    ranks = get_ranks byte_counts
    puts existing_order.map.with_index { |language, idx|
        language, language_link, rank, bytes, code = answers[language]
        rank = ranks[idx]
        "| #{language_link} | #{rank} | #{bytes}b | #{code} |"
    }
end

def reconcile_multi(source_a, source_b)
    scanner = /## (?:.+)\n[\s\S]+?(?:\n\|.+\|)+/
    as = source_a.scan(scanner)
    bs = source_b.scan(scanner)
    
    a_problems = as.map { |body| body.lines.first.strip }
    b_problems = bs.map { |body| body.lines.first.strip }
    
    # i don't care this is inefficient. this isn't space-grade.
    a_problems.map.with_index { |problem, a_idx|
        a = as[a_idx]
        
        b_idx = b_problems.index problem
        b = if b_idx.nil?
            STDERR.puts "WARNING: #{problem}, no match in B, reconciling with self"
            a
        else
            bs[b_idx]
        end
        
        reconcile a, b
        puts
    }
    
end

reconcile_multi File.read("comparison.md"), File.read("temp.md")
