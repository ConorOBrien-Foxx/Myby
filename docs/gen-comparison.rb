require 'json'
require 'digest'
require 'open-uri'
require 'cgi'

Dir.chdir File.dirname __FILE__

problems = JSON::parse File.read("./../example/golf/problems.json")
existing = File.read("./comparison.md").scan(/## \[(.+?)\]/).map(&:first)

needed = problems
    .reject { |prob| existing.include? prob["name"] }
    .select { |prop| prob["id"]["csge"] }
ids = needed.map { _1["id"][/\d+/] }
    
if ids.empty?
    puts "No updates needed, exiting"
    exit
end

# for stupid simple comparisons
def unique_id(ids)
    Digest::MD5.hexdigest ids.sort * ";"
end

file_id = "./.cache/" + unique_id(ids) + ".json"

def scrape(ids, page)
    api = "https://api.stackexchange.com/2.3/questions/" +
        ids * ";" +
        "/answers?page=#{page}&pagesize=100&" +
        "order=desc&sort=activity" +
        "&site=codegolf&" +
        "filter=!3uiiRrdzLXJgGFmRm"
    content = URI.open(api).read
    File.write "./.cache/_lastscrape.json", content
    JSON::parse content
end

unless File.exist? file_id
    STDERR.puts "Cached file does not exist, making request"
    total = []
    page = 1
    loop {
        break if page > 25 # can't read that far yet
        STDERR.puts "page #{page}..."
        data = scrape ids, page
        total.concat data["items"]
        break unless data["has_more"]
        page += 1
    }
    STDERR.puts "done, writing"
    File.write file_id, total.to_json
else
    STDERR.puts "Cached file exists, reading"
    total = JSON::parse File.read file_id
end

# for making the tables
collect = {}

# initial population: Myby answers
STDERR.puts "Populating initial Myby answers"
needed.each { |prob|
    code_name = prob["name"]
    path = "./../example/golf/#{code_name}.myby"
    code = File.read path
    # todo: cross-platform
    bytes = `..\\myby.exe -lsx #{path}`.to_f
    # bytes = 0
    collect[prob["id"]] = [
        ["Myby", "", bytes, code.strip]
    ]
}

STDERR.puts "Reading scraped info"
exclude = File.read("exclude.txt").downcase.strip.lines.map(&:strip)
normalize = {
    "APL(Dyalog Unicode)" => "APL (Dyalog Unicode)",
    "Dyalog APL" => "APL (Dyalog)",
    "Dyalog APL v18" => "APL (Dyalog)",
    "Dyalog APL Classic" => "APL (Dyalog Classic)",
    "Vitsy + *sh" => "Vitsy",
    "V (vim)" => "Vim",
    "q/kdb+" => "Q",
    "Q/KDB+" => "Q",
    "q" => "Q",
    "k4" => "K4",
    "k" => "K",
    "Cjam" => "CJam",
    "Golfscript" => "GolfScript",
    "gs2" => "GS2",
    "Arn 1.0 `-s`" => "Arn",
    "Uiua <sup>SBCS</sup>" => "Uiua",
    "Uiua<sup>SBCS</sup>" => "Uiua",
    "05AB1E(or 5?) bytes" => "05AB1E",
    "APL NARS 52 char" => "APL (NARS)",
    "APL NARS" => "APL (NARS)",
    "APL(NARS)" => "APL (NARS)",
    "APL (NARS2000 dialect)" => "APL (NARS)",
    "NARS2000 APL" => "APL (NARS)",
}

# TODO: match "Trivial Built-in Answers"
byte_regexes = [
    /([.,\d]+)(?:[\\\/$<>span]*)[,\s]*bytes?/i,
    /([.,\d]+)\s*(char(acter)?|key(stroke)?)s?/i,
    /\(\s*([.\d][.,\d]*)\s*\)/,
    /(?:,|-)\s*([.\d][.,\d]*)\s*/,
    /\s*([.\d][.,\d]*)\s*/,
]
body_regexes = [
    /<pre.*?><code.*?>([\s\S]+?)<\/code><\/pre>/,
    /<code.*?>([\s\S]+?)<\/code>/,
    /<pre.*?>([\s\S]+?)<\/pre>/
]
total.each { |item|
    qid = item["question_id"]
    body = item["body"]
    link = item["link"]
    body.match(/<h(\d)>(.+)<\/h(\1)>/i)
    header = $2
    # you cannot make me care about answers without headings
    if header.nil?
        # STDERR.puts link
        next
    end
    # remove links
    header.gsub!(/<a.+?>|<\/a>|<(del|strike|s)>.+?<\/\1>/, "")
    bytes = nil
    # normalize :/
    if byte_regexes.any? { |r| r =~ header }
        bytes = $1
        name = header
            .sub($&, "")
            .split(",")
            .first
            .gsub(/(with )?<\/?code>/, "`")
            .gsub(/<\/?(?:strong|em|b)>|\s+-\s*$/, "")
            .gsub(/&gt;/, ">")
            .gsub(/&lt;/, "<")
            .gsub(/&amp;/, "&")
            .strip
        name = normalize[name] || name
        # skip over stuff we don't care about
        next if exclude.include? name.downcase
    elsif header[/\d/].nil?
        # there must be a number to grade it, else we do not care
        # but maybe we can:
        # name = header
        if byte_regexes[0...2].any? { |r| r =~ body }
            bytes = $1
            name = header
        end
    else
        STDERR.puts "Unhandled: #{header}"
        STDERR.puts link
    end
    
    # skip invalid
    next if name.nil?
    
    unless /^[.,\d]+$/ =~ bytes
        STDERR.puts "Cannot find byte count:"
        STDERR.puts [name, bytes, link].inspect
        next
    end
    
    # extract code
    body.gsub!(/<h(\d)>(.+?)<\/h(\1)>/, "")
    if body_regexes.any? { |r| r =~ body }
        code = $1
    else
        STDERR.puts "Cannot find code:"
        STDERR.puts [name, bytes, link].inspect
        next
    end
    
    collect[qid].push [name, link, bytes.gsub(/,/, "").to_f, code.strip]
}

def escape_markdown(line)
    line.gsub(/-|[|\[\]\(\)*_~\\<>`]/) { |c| "&##{c.ord};" }
end

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

needed.each { |prob|
    puts "## [#{prob["name"]}](https://codegolf.stackexchange.com/questions/#{prob["id"]}/#{prob["name"]})"
    puts
    puts "| language | rank | bytes | code |"
    puts "|----------|------|-------|------|"
    entries = collect[prob["id"]]
    names = []
    entries.sort_by! { |name, link, bytes, code| [bytes, name] }
    entries.reject! { |name, link, bytes, code|
        if names.include? name
            true
        else
            names << name
            false
        end
    }
    ranks = get_ranks entries.map { |name, link, bytes, code| bytes }
    entries.zip(ranks).map { |(name, link, bytes, code), rank|
        if bytes == bytes.to_i
            bytes = bytes.to_i
        else
            # force precision
            bytes = bytes.to_f.round 2
        end
        md_name = name.gsub(/<|>|\\/) { |c| "&##{c.ord};" }
        out_line =  "| " + [
            link.empty? ? md_name : "[#{md_name}](#{link})",
            rank,
            "#{bytes}b",
            code.split(/\r?\n/).map { |line|
                # line = escape_markdown CGI.unescapeHTML line
                line = escape_markdown line
                "<code>#{line}</code>"
            }.join(" <br/> ")
        ].join(" | ").gsub("|  |", "| |") + " |"
        # wrap for Jekyll Liquid
        if out_line["{{"] || out_line["}}"]
            out_line = "{% raw %}#{out_line}{% endraw %}"
        end
        puts out_line
    }
    puts
}
