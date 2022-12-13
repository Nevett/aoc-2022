require 'fileutils'
require 'faraday'

class AocHelper
  CACHE_DIRECTORY = File.expand_path("../.input_cache", __dir__)
  IMPLEMENTATION_DIRECTORY = File.expand_path("../days", __dir__)

  def run(day_number)
    ensure_implementations_loaded!
    day_padded = format('%02d', day_number)
    if day_class = ["Day#{day_padded}", "Day#{day_number}"].find { |klass| Object.const_defined?(klass) }
      day_inst = Object.const_get(day_class).new(input: AocHelper.new.input(day_number))
      puts "Day #{day_padded} part 1: #{day_inst.part_1}"
      puts "Day #{day_padded} part 2: #{day_inst.part_2}"
    else
      puts "Day #{day_padded} no implementation found."
    end
  rescue => e
    STDERR.puts "Day #{day_padded} errored."
    STDERR.puts e.full_message 
  end

  def input(day)
    cache_file = File.join(CACHE_DIRECTORY, "#{day}.txt")

    input = File.exist?(cache_file) && File.read(cache_file)
    unless input
      input = fetch_input(day)
      ensure_cache_directory!
      File.write(cache_file, input)
    end

    input
  end

  private def ensure_cache_directory!
    return true if @cache_ensured

    FileUtils.mkdir_p(CACHE_DIRECTORY)
    @cache_ensured = true
  end

  private def ensure_implementations_loaded!
    return true if @implementations_loaded

    Dir[File.join(IMPLEMENTATION_DIRECTORY, '*.rb')].each {|file| require file }
    @implementations_loaded = true
  end

  private def fetch_input(day)
    session = ENV['AOC_SESSION']
    raise StandardError, 'Set AOC_SESSION env var from cookie' unless session

    url = "https://adventofcode.com/2022/day/#{day}/input"

    response = Faraday.get(url) do |req|
      req.headers['Cookie'] = "session=#{session}"
    end

    raise StandardError, "Bad response status=#{response.status} body=#{response.body}" unless response.status == 200

    response.body
  end
end
