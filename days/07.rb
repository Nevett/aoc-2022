class Day07 < Day
  class Dir
    attr_reader :dirs
    attr_reader :files
    attr_reader :name
    attr_reader :parent
    def initialize(name:,parent:nil)
      @name = name
      @dirs = []
      @files = []
      @parent = parent
    end

    def size
      files.sum(&:size) + dirs.sum(&:size)
    end
  end

  class File
    attr_reader :name
    attr_reader :size
    def initialize(name:,size:)
      @name = name
      @size = size
    end
  end
  
  def part_1
    root = parse_cmds

    matching_dirs = []
    visit_dirs(root) do |dir|
      matching_dirs.push(dir) if dir.size < 100000
    end
    matching_dirs.sum(&:size)
  end
  
  def part_2
    root = parse_cmds

    max_size = 70000000 - 30000000
    min_to_free = root.size - max_size

    matching_dirs = []
    visit_dirs(root) do |dir|
      matching_dirs.push(dir) if dir.size > min_to_free
    end
    matching_dirs.sort_by(&:size).first.size
  end

  private def parse_cmds
    root = Dir.new(name: '/')
    current_dir = nil
    stripped_input_lines.each do |cmd|
      if match = cmd.match(/^\$ cd (.+)$/)
        dir = match[1]
        case dir
        when '/'
          current_dir = root
        when '..'
          current_dir = current_dir.parent
        else
          current_dir = current_dir.dirs.find { |d| d.name == dir }
        end
      elsif match = cmd.match(/^\$ ls/)
        # noop
      elsif match = cmd.match(/^dir (.+)$/)
        current_dir.dirs.push(Dir.new(
          name: match[1],
          parent: current_dir,
        ))
      elsif match = cmd.match(/^(\d+) (.+)$/)
        current_dir.files.push(File.new(
          name: match[2],
          size: match[1].to_i,
        ))
      else
        puts 'unknown command'
      end
    end
    root
  end

  private def visit_dirs(dir, &block)
    yield dir
    dir.dirs.each do |subdir| visit_dirs(subdir, &block) end
  end
end
