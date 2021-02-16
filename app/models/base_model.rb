require 'ohm'
require 'ohm/contrib'

class BaseModel < Ohm::Model
  alias :save! :save # Used by FactoryBot
  def to_param
    id
  end
end
