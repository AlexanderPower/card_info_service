class CardInformationService
  include Virtus.model
  attribute :card_number, String

  # дополнительные валидации делать не стал,
  # так как они уже есть на стороне grape
  def call
    exist, system_name = process
    {
        exist: exist,
        system_name: system_name
    }
  end

  private

  def process
    _exist = exist
    return [_exist, nil] unless _exist
    [_exist, system_name]
  end

  # Luhn algorithm честно украденный со SO
  def exist
    number = card_number.reverse # read from right to left

    sum, i = 0, 0

    number.each_char do |ch|
      n = ch.to_i

      # Step 1
      n *= 2 if i.odd?

      # Step 2
      n = 1 + (n - 10) if n >= 10

      sum += n
      i += 1
    end

    # Step 3
    (sum % 10).zero?
  end

  # https://en.wikipedia.org/wiki/Payment_card_number
  def system_name
    chars = card_number.chars
    return 'VISA' if chars.first == '4'
    return 'Maestro' if chars.first == '6'
    return 'MasterCard' if (2221..2720).include? chars[0..3].join.to_i

    case chars[0..1].join.to_i
      when 50, 56..58
        'Maestro'
      when 51..55
        'MasterCard'
      else
        'Unknown'
    end
  end

end