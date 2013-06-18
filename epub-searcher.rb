# -*- coding: utf-8 -*-

require 'bundler'
Bundler.require

def extract_xhtml_uris(epub_book)
  uris = Array.new

  epub_book.each_page_on_spine do |item|
    if item.media_type == "application/xhtml+xml"
      uri = item.href
      uris << uri.to_s
    end
  end

  return uris
end

def order_by_spine(files, uris)
  entry_name_array = Array.new(uris.size)
  files.num_files.times do |i|
    zip_entry_name = files.get_name(i)

    # uris 内のファイル名は basename になっているので、
    # 解答して出てきたファイル名と比較し、
    # 順番通りにファイル名を整列する
    base_zip_entry_name = File::basename(zip_entry_name)
    index = uris.index(base_zip_entry_name)
    if index
      entry_name_array[index] = zip_entry_name
    end
  end
  return entry_name_array
end

def show_html_contents(files, entry_name_array)
  # 整列したファイルを順繰りに読み込み、パースする
  entry_name_array.each do |entry_name|
    files.fopen(entry_name) do |io|
      show_html_content(io)
    end
  end
end

def open_epub(filename)
  epub_book = EPUB::Parser.parse(filename)
  metadata = epub_book.metadata

  uris = extract_xhtml_uris(epub_book)
  
  Zip::Archive.open(filename) do |files|
    entry_name_array = order_by_spine(files, uris)
    show_html_contents(files, entry_name_array)
  end
end

def show_html_content(io)
  content = Nokogiri::HTML(io)
  puts content.text
end

if ARGV.count < 1
  puts __FILE__ + " <epub_file>"
else
  filename = ARGV.shift
  open_epub(filename)
end

