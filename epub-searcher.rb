# -*- coding: utf-8 -*-

require 'bundler'
Bundler.require

def extract_spine(epub_book)
  spine = Array.new

  epub_book.each_page_on_spine do |item|
    if item.media_type == "application/xhtml+xml"
      basename = item.href
      spine << basename.to_s
    end
  end

  return spine
end

def find_item_index(spine, zip_entry_name)
  base_zip_entry_name = File::basename(zip_entry_name)
  index = spine.index(base_zip_entry_name)
  return index
end

def order_by_spine(files, spine)
  entry_name_array = Array.new(spine.size)
  files.num_files.times do |i|
    zip_entry_name = files.get_name(i)

    index = find_item_index(spine, zip_entry_name)
    if index
      entry_name_array[index] = zip_entry_name
    end
  end
  return entry_name_array
end

def show_html_contents(files, entry_name_array)
  entry_name_array.each do |entry_name|
    files.fopen(entry_name) do |io|
      show_html_content(io)
    end
  end
end

def show_html_content(io)
  content = Nokogiri::HTML(io)
  puts content.text
end

def show_main_text(epub_filename, spine)
  Zip::Archive.open(epub_filename) do |files|
    entry_names = order_by_spine(files, spine)
    show_html_contents(files, entry_names)
  end
end

def open_epub(filename)
  epub_book = EPUB::Parser.parse(filename)
  metadata = epub_book.metadata

  spine = extract_spine(epub_book)
  show_main_text(filename, spine)
end

if ARGV.count < 1
  puts __FILE__ + " <epub_file>"
else
  filename = ARGV.shift
  open_epub(filename)
end

