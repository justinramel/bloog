class Post
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  validates :title, presence: true

  attr_accessor :blog, :title, :body, :pubdate

  def initialize(attr={})
    attr.each do |k, v|
      send("#{k}=", v)
    end
  end

  def publish
    return false unless valid?
    self.pubdate = DateTime.now
    blog.add_entry(self)
  end

  def persisted?
    false
  end

end
