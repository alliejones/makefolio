require_relative '../lib/makefolio'

describe Makefolio::Helpers do
  describe "front matter parsing" do
    it "should return a hash when front matter exists" do
      text = "---\none: foo\ntwo: bar\n---\nMore text\n\nAnd even more"
      front_matter = Makefolio::Helpers.parse_front_matter(text)

      front_matter.should == { 'one' => 'foo', 'two' => 'bar' }
    end

    it "should return an empty hash if no front matter exists" do
      text = "This is text\n\nWith no front matter"
      front_matter = Makefolio::Helpers.parse_front_matter(text)

      front_matter.should == { }
    end
  end

  describe "front matter stripping" do
    it "should remove front matter if it exists" do
      text = "---\none: foo\ntwo: bar\n---\nMore text\n\nAnd even more"
      content = Makefolio::Helpers.strip_front_matter(text)

      content.should == "More text\n\nAnd even more"
    end

    it "should return the content unchanged if there is no front matter" do
      text = "This is text\n\nWith no front matter"
      content = Makefolio::Helpers.strip_front_matter(text)

      content.should == "This is text\n\nWith no front matter"
    end
  end

  it "should create correct large image filenames" do
    large_filename = Makefolio::Helpers.large_image_filename('test.jpg')
    large_filename.should == 'test-lg.jpg'
  end
end