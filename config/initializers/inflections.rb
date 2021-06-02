# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format. Inflections
# are locale specific, and you may define rules for as many different
# locales as you wish. All of these examples are active by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

# These inflection rules are supported but not enabled by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.acronym 'RESTful'
# end

# Универсал



ActiveSupport::Inflector.inflections(:ru) do |inflect|
# REFACTOR
  inflect.irregular 'Седан', 'Седаны'
  inflect.irregular 'Внедорожник', 'Внедорожники'
  inflect.irregular 'Кроссовер', 'Кроссоверы'
  inflect.irregular 'Хэтчбек', 'Хэтчбеки'
  inflect.irregular 'Лифтбек', 'Лифтбеки'
  inflect.irregular 'Универсал', 'Универсалы'
  inflect.irregular 'Минивэн', 'Минивэны'
  inflect.irregular 'Пикап', 'Пикапы'
  inflect.irregular 'Фургон', 'Фургоны'
  inflect.uncountable %w( Купе )
end