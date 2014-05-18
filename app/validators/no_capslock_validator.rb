class NoCapslockValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    if value.present? && value == value.upcase
      object.errors.add(attribute, "can't be upper-case. Please, don't scream!")
    end
  end
end