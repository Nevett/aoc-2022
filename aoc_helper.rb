require 'dotenv/load'
require 'fileutils'
require 'faraday'

class AocHelper
  CACHE_DIRECTORY = '.input_cache'

  def input(day)
    ensure_cache_directory!
    
    cache_file = File.join(CACHE_DIRECTORY, "#{day}.txt")

    input = File.exist?(cache_file) && File.read(cache_file)
    unless input
      input = fetch_input(day)
      File.write(cache_file, input)
    end

    input
  end

  private def ensure_cache_directory!
    FileUtils.mkdir_p(CACHE_DIRECTORY)
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