class Post
  attr_accessor :blog, :title, :body

  def initialize(attr={})
    attr.each do |k, v|
      send("#{k}=", v)
    end
  end

  def publish
    blog.add_entry(self)
  end
end