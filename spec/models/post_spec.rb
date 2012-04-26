# module ActiveModel
#   module Naming; end
#   module Conversion; end
# end

require_relative '../spec_helper_lite'

# stub_module 'ActiveModel::Conversion'
# stub_module 'ActiveModel::Naming'
require 'date'
require 'active_model'
require 'timecop'
require_relative '../../app/models/post'

describe Post do
  before do
    @it = Post.new
  end

  it "supports setting attributes in the initializer" do
    it = Post.new(title: "mytitle", body: "mybody")
    it.title.must_equal "mytitle"
    it.body.must_equal "mybody"
  end

  it "starts with blank attributes" do
    @it.title.must_be_nil
    @it.body.must_be_nil
  end

  it "supports reading and writing a title" do
    @it.title = "foo"
    @it.title.must_equal "foo"
  end

  it "supports reading and writing a post body" do
    @it.body = "foo"
    @it.body.must_equal "foo"
  end

  it "supports reading and writing a blog reference" do
    blog      = stub
    @it.blog  = blog
    @it.blog.must_equal blog
  end


  describe "validation" do
    it "is not valid with a blank title" do [nil, "", " "].each do |bad_title|
      @it.title = bad_title
      refute @it.valid? end
    end
    it "is valid with a non-blank title" do @it.title = "x"
      assert @it.valid?
    end
  end

  describe "#publish" do
    before do
      @blog    = MiniTest::Mock.new
      @it.title = "again had to add title to make this work"
      @it.blog = @blog
    end

    after do
      @blog.verify
    end

    it "adds the post to the blog" do
      @blog.expect :add_entry, nil, [@it]
      @it.publish
    end

    describe "given an invalid post" do
      before do
        @it.title = nil
      end

      it "wont add the post to the blog" do
        dont_allow(@blog).add_entry
        @it.publish
      end

      it "returns false" do
        refute(@it.publish)
      end
    end
  end

  describe "#pubdate" do
    describe "before publishing" do
      it "is blank" do
        @it.pubdate.must_be_nil
      end
    end

    describe "after publishing" do
      before do
        @now = DateTime.parse("2011-09-11T02:56")
        Timecop.freeze(@now)

        @it.title = "had to add title to make this work"
        @it.blog = stub!
        @it.publish
      end

      it "is a datetime" do
        @it.pubdate.must_equal(@now)
      end

      after do
        Timecop.return
      end
    end
  end

end
