require 'fileutils'

module EPUBSearcher
  class Database
    def initialize
      @db_path = nil
    end

    def db_path
      @db_path || File.join(__dir__, '..', '..', 'db', 'epub-searcher.db')
    end

    def db_path=(path)
      @db_path = path
    end

    def load_records(epub_documents)
      piped_stdin, stdin = IO.pipe
      pid = spawn(open_db_command, :in => piped_stdin, :out => '/dev/null')
      stdin.write(groonga_load_records_command(epub_documents))
      stdin.flush
      stdin.close

      Process.waitpid pid
    end

    def setup_database
      FileUtils.mkdir_p(File.dirname(db_path))

      piped_stdin, stdin = IO.pipe
      pid = spawn(open_db_command, :in => piped_stdin, :out => '/dev/null')
      stdin.write(groonga_setup_db_command)
      stdin.flush
      stdin.close

      Process.waitpid pid
    end

    private
    def open_db_command
      command = 'groonga'
      if !File.exists?(db_path)
        command << ' -n'
      end
      command << ' ' + db_path
      return command
    end

    def groonga_load_records_command(epub_documents)
      command = "load --table Books\n"
      json = "["
      epub_documents.each do |epub_document|
        record = "{"
        record << %Q("author":"#{epub_document.extract_creators.join(' ')}")
        record << %Q("main_text":"#{epub_document.extract_main_text}")
        record << %Q("title":"#{epub_document.extract_title}")
        record << %Q("file_path":"#{epub_document.file_path}")
        record << "},"
        json << record
      end
      json << "]\n"
      command << json
      return command
    end

    def groonga_setup_db_command
      <<EOS
table_create Books TABLE_NO_KEY
column_create Books author COLUMN_SCALAR ShortText
column_create Books main_text COLUMN_SCALAR LongText
column_create Books title COLUMN_SCALAR ShortText
column_create Books file_path COLUMN_SCALAR ShortText
EOS
    end
  end
end

