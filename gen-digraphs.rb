ngraphs = %w(
    cc ee ff ll oo pp rr ss tt
    th he in er an re nd at on nt ha es st en ed
    to it ou ea hi is or ti
).uniq

tree = {}
ctr = {}
counter = 0x60
ngraphs.each { |seq|
    if counter >= 0x80
        STDERR.puts "Not enough room for ngraph #{seq.inspect}"
    end
    rec = tree
    seq.chars[0...-1].each { |c|
        rec[c] ||= {}
        rec = rec[c]
    }
    disp_ctr = counter.to_s(16).upcase
    rec[seq[-1]] = disp_ctr
    ctr[disp_ctr] = seq
    counter += 1
}

def print_rec(tree, depth=4)
    tab = " " * depth
    tree.sort_by { |key, val| key }.each { |key, val|
        print "#{tab}'#{key}': EncodingTreeNode("
        if Hash === val
            puts "["
            print_rec val, depth + 4
            puts "#{tab}]),"
        else
            print "0x", val
            puts "),"
        end
    }
end

puts "enum NGraphTree = EncodingTreeNode(["
print_rec tree
puts "]);"
puts "enum NGraphLookup = ["
ctr.each.with_index(1) { |(key, val), i|
    print "    0x#{key}: #{val.inspect},"
    if i % 4 == 0 || i == ctr.size
        puts
    else
        print " "
    end
}
puts "];";
