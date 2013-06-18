# -*- coding: utf-8 -*-

require 'bundler'
Bundler.require

def open_epub(filename)
  uri_array = Array.new
  epub_book = EPUB::Parser.parse(filename)
  metadata = epub_book.metadata

  # xhtml ドキュメントがどの順番で出てくるか記録する
  epub_book.each_page_on_spine do |item|
    if item.media_type == "application/xhtml+xml"
      uri = item.href
      uri_array << uri.to_s
    end
  end

  Zip::Archive.open(filename) do |files|
    entry_name_array = Array.new(uri_array.size)
    files.num_files.times do |i|
      zip_entry_name = files.get_name(i)

      # uri_array 内のファイル名は basename になっているので、
      # 解答して出てきたファイル名と比較し、
      # 順番通りにファイル名を整列する
      base_zip_entry_name = File::basename(zip_entry_name)
      index = uri_array.index(base_zip_entry_name)
      if index
        entry_name_array[index] = zip_entry_name
      end
    end

    # 整列したファイルを順繰りに読み込み、パースする
    entry_name_array.each do |entry_name|
      files.fopen(entry_name) do |io|
        show_html_content(io)
      end
    end
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

