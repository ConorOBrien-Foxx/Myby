require 'json'
require 'digest'
require 'open-uri'
require 'cgi'

problems = JSON::parse File.read("./../example/golf/problems.json")
existing = File.read("./comparison.md").scan(/## \[(.+?)\]/).map(&:first)

needed = problems.reject { |prob| existing.include? prob["name"] }
ids = needed.map { _1["id"] }

if ids.empty?
    puts "No updates needed, exiting"
    exit
end

# for stupid simple comparisons
def unique_id(ids)
    Digest::MD5.hexdigest ids.sort * ";"
end

file_id = unique_id(ids) + ".json"

def scrape(ids, page)
    api = "https://api.stackexchange.com/2.3/questions/" +
        ids * ";" +
        "/answers?page=#{page}&pagesize=100&" +
        "order=desc&sort=activity" +
        "&site=codegolf&" +
        "filter=!3uiiRrdzLXJgGFmRm"
    JSON::parse URI.open(api).read
end

unless File.exists? file_id
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
    "Dyalog APL Classic" => "APL (Dyalog Classic)",
    "Vitsy + *sh" => "Vitsy",
    "V (vim)" => "Vim",
    "q/kdb+" => "Q",
    "Q/KDB+" => "Q",
    "q" => "Q",
    "k4" => "K4",
    "k" => "K",
    "Cjam" => "CJam"
    "Golfscript" => "GolfScript",
    "Arn 1.0 `-s`" => "Arn",
    "05AB1E(or 5?) bytes" => "05AB1E",
    "APL NARS 52 char" => "APL (NARS)",
    "APL NARS" => "APL (NARS)",
    "APL(NARS)" => "APL (NARS)",
    "APL (NARS2000 dialect)" => "APL (NARS)",
    "NARS2000 APL" => "APL (NARS)",
}

byte_regexes = [
    /([.\d]+)[,\s]*bytes?/i,
    /([.\d]+)\s*(char(acter)?|key(stroke)?)s?/i,
    /\(\s*([.\d]+)\s*\)/,
    /(?:,|-)\s*([.\d]+)\s*/,
    /\s*([.\d]+)\s*/,
]
body_regexes = [
    /<pre><code>([\s\S]+?)<\/code><\/pre>/,
    /<code>([\s\S]+?)<\/code>/,
    /<pre>([\s\S]+?)<\/pre>/
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
    else
        STDERR.puts "Unhandled: #{header}"
        STDERR.puts link
    end
    
    # skip invalid
    next if name.nil?
    
    unless /^[.\d]+$/ =~ bytes
        STDERR.puts "Cannot find byte count:"
        STDERR.puts [name, bytes, link].inspet
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
    
    collect[qid].push [name, link, bytes.to_f, code.strip]
}

def escape_markdown(line)
    line.gsub(/-|[|\[\]\(\)*_~#\\<>`]/) { |c| "&##{c.ord};" }
end

needed.each { |prob|
    puts "## [#{prob["name"]}](https://codegolf.stackexchange.com/questions/#{prob["id"]}/#{prob["name"]})"
    puts
    puts "| language | rank | bytes | code |"
    puts "|----------|------|-------|------|"
    entries = collect[prob["id"]]
    names = []
    entries.sort_by! { |name, link, bytes, code| [bytes, name] }
    entries.map { |name, link, bytes, code|
        next if names.include? name
        names << name
        bytes = bytes.to_i if bytes == bytes.to_i
        md_name = name.gsub(/<|>|\\/) { |c| "&##{c.ord};" }
        out_line =  "| " + [
            link.empty? ? md_name : "[#{md_name}](#{link})",
            "",
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