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
    [a, b].each { |table|
        table.lines[4..-1].map { |line|
            _, language, rank, bytes, code = line.split("|").map(&:strip)
            rank = rank.to_i
            bytes = bytes[0...-1].to_i
            language_link = language
            
            if /\[(.+)\]/ === language_link
                language = $1
            end
            existing_order << language unless existing_order.include? language
            if answers[language]
                existing = answers[language]
                if existing[2] > bytes
                    answers[language] = [ language, language_link, rank, bytes, code ]
                end
            else
                answers[language] = [ language, language_link, rank, bytes, code ]
            end
        }
    }
    puts a.lines[0...4]
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
    scanner = /## (?:.+)\n(?:\n\|.+\|)+/
    as = source_a.scan(scanner)
    bs = source_b.scan(scanner)
    
    a_problems = as.map { |body| body.lines.first.strip }
    b_problems = bs.map { |body| body.lines.first.strip }
    
    # i don't care this is inefficient. this isn't space-grade.
    a_problems.map.with_index { |problem, a_idx|
        b_idx = b_problems.index problem
        if b_idx.nil?
            puts "Skipping #{problem}, no match in B"
            next
        end
        
        a = as[a_idx]
        b = bs[b_idx]
        
        reconcile a, b
    }
    
end

reconcile_multi File.read("comparison.md"), File.read("temp.md")
