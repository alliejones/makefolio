require_relative '../lib/makefolio'

describe Makefolio::Template do
  it "should return html" do
    template = Makefolio::Template.new('This is a test: <%= test %>',
                                       { :test => 'Test' },
                                       'Layout: <%= content %>')
    template.to_html.should == 'Layout: This is a test: Test'
  end
end