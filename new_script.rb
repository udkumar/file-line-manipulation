#!/usr/bin/env ruby

file_name = ARGV[0]

output_name = "#{File.basename(file_name, '.*')}.tab"
output = File.open(output_name, 'w:utf-8')

def split_line(line)
  line.chomp.split("\t")[0...-1].join("\t")
end

def book_from_line(line)
  line.split("\t")[1].to_s
end

def chapter_from_line(line)
  line.split("\t")[2].to_s
end

is_new_book = true
is_new_chapter = true

start = "GEN"
chapter = nil

File.open(file_name, "r:utf-8") do |li|
  li.each_with_index do |line, i|
    line_book = book_from_line(line)
    unless line_book == start
      start = line_book
      is_new_book = true
      is_new_chapter = true
    end

    line_chapter = chapter_from_line(line)
    unless line_chapter == chapter
      chapter = line_chapter
      is_new_chapter = true
    end

    output << split_line(line) +"\t"+ "000\n" if is_new_book
    output << split_line(line) +"\t"+ "00\n" if is_new_chapter
    output << line

    is_new_book = false
    is_new_chapter = false
  end
end
