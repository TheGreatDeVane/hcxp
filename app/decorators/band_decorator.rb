class BandDecorator < Draper::Decorator
  delegate_all

  def thumb_url(size = :large_s)
    object.images[size.to_s] if object.images
  end
end