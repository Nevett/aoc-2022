class Day02 < Day
  class Hand
    attr_accessor :aliases
    attr_accessor :score
    attr_accessor :name

    def initialize(name:, aliases:, score:)
      @name = name
      @aliases = aliases
      @score = score
    end

    def beats(other)
      @beats = other
    end

    def score_against(other)
      return 3 if other == self
      return 6 if other == @beats
      0
    end
  end

  ROCK = Hand.new(name: 'rock', aliases: %w(A X), score: 1)
  PAPER = Hand.new(name: 'paper', aliases: %w(B Y), score: 2)
  SCISSORS = Hand.new(name: 'scissors', aliases: %w(C Z), score: 3)

  ROCK.beats(SCISSORS)
  PAPER.beats(ROCK)
  SCISSORS.beats(PAPER)

  HANDS = [ROCK, PAPER, SCISSORS]

  def part_1
    score = 0
    stripped_input_lines.each do |line|
      opponent, mine = line.split.map do |hand_alias|
        HANDS.find { |h| h.aliases.include? hand_alias }
      end

      turn_score = mine.score + mine.score_against(opponent)
      score += turn_score
    end
    score
  end

  def part_2
    score = 0
    stripped_input_lines.each do |line|
      opponent, desired_outcome = line.split
      opponent = HANDS.find { |hand| hand.aliases.include? opponent }
      desired_score = case desired_outcome
                      when 'X'
                        0
                      when 'Y'
                        3
                      when 'Z'
                        6
                      end

      mine = HANDS.find { |hand| hand.score_against(opponent) == desired_score }

      turn_score = mine.score + mine.score_against(opponent)
      score += turn_score
    end
    score
  end
end
