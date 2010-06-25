require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

Page = Harmony::Page unless defined?( Page )

describe Harmony::Page do
  before do
    @blank = Page.new
  end
  
  describe 'api' do
    CLASS_METHODS = [:fetch, :new]
    INSTANCE_METHODS = [:window, :document, :execute_js, :x]
    
    CLASS_METHODS.each do |page_method|
      it "Page should respond to #{page_method}" do
        Page.should respond_to(page_method)
      end
    end
    
    INSTANCE_METHODS.each do |page_method|
      it "Page instance should respond to #{page_method}" do
        @blank.should respond_to(page_method)
      end
    end
    
    it 'Page.document should be a shortcut for Page.window.document' do
      window = mock('Window')
      @blank.should_receive(:window).and_return(window)
      window.should_receive(:document)
      @blank.document
    end
  end
  
  describe 'execution' do
    it 'performs basic js' do
      @blank.x('5+2').should == 7
    end
    
    it 'executes DOM-accessing js' do
      page = Page.new(<<-HTML)
        <html>
          <head>
            <title>Harmony</title>
          </head>
          <body>
            <div></div>
            <div></div>
          </body>
        </html>
      HTML
      page.document.title.should == 'Harmony'
      
      (page.x(<<-JS)
        document.getElementsByTagName('div').length
      JS
      ).should == 2
    end
  end
  
  describe 'basic characteristics' do
    it "Page fetches documents from remote locations" do
      path = tempfile(<<-HTML)
        <html><head><title>foo</title></head><body></body></html>
      HTML
      page = Page.fetch("file://#{path}")
      page.document.title.should == 'foo'
    end

    describe 'default empty page' do
      it "has no title" do
        @blank.document.title.should be_empty
      end
      
      it '#to_html should produce an empty document' do
        @blank.to_html.should == "<html><head><title></title></head><body></body></html>"
      end
    end
  end
  
  describe 'loading js files' do
    it "works with one one path" do
      path = tempfile(<<-JS)
        function foo() { return 'bar' };
      JS
      
      page = Page.new.load(path)
      page.x('foo()').should == 'bar' 
    end

    it "takes an array of paths" do
      paths = []
      paths << tempfile(<<-JS)
        function foo() { return 'bar' };
      JS
      
      paths << tempfile(<<-JS)
        function moo() { return 'boo' };
      JS

      page = Page.new.load(paths)
      page.x('foo()').should == 'bar'
      page.x('moo()').should == 'boo'
    end

    it "can load multiple files with splat" do
      paths = []
      paths << tempfile(<<-JS)
        function foo() { return 'bar' };
      JS
      
      paths << tempfile(<<-JS)
        function moo() { return 'boo' };
      JS

      page = Page.new.load(*paths)
      page.x('foo()').should == 'bar'
      page.x('moo()').should == 'boo'
    end
  end
  
  describe 'document context' do
    before do
      pending 
    end
    
    it 'should keep a window/browser run time within the same page' do
      @blank.window.run_time.should == @blank.window.run_time
    end
    
    it 'should use a different window for each page' do
      @blank.window.should_not === Page.new.window
    end
    
    it 'should use a different runtime for each page' do
      @blank.window.run_time.should_not === Page.new.window.run_time
    end
  end 
  
  def tempfile(content)
    Tempfile.open('abc') do |f| 
      f << content
      @__path = f.path 
    end
    @__path
  end
end