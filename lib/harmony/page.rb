require 'pathname'
require 'tempfile'
require 'forwardable'

require 'johnson/tracemonkey'
require 'envjs/runtime'

module Harmony
  class Page
    # DOM document's `window` object. Equivalent to the return value of
    # `page.execute_js('window')`
    #
    # @return [Object]
    #   window DOM object
    #
    attr_reader :window
    
    # Create page from remote document.
    #
    # @example
    #
    #     Page.fetch('http://montrealrb.org')
    #     Page.fetch('http://localhost:3000')
    #     Page.fetch('file:///home/mynyml/www/foo/index.html')
    #
    # @param [String] uri
    #   uri to fetch document from
    #
    # @return [Page]
    #   new page object preloaded with fetched document
    #
    def self.fetch(uri)
      page = new
      page.window.open(uri)
      page
    end

    # Create new page containing given document.
    #
    # @param [String] document
    #   HTML document. Defaults to an "about:blank" window, with the basic
    #   structure: `<html><head><title></title></head><body></body></html>`
    #
    def initialize(document=nil)
      @window = document ? Window.from_document(document) : Window.blank
    end

    # Load one or more javascript files in page's context
    #
    # @param [#to_s, #to_s, ...] paths
    #   paths to js file
    # @return [Page] self
    #
    def load(*paths)
      paths.flatten.each do |path|
        window.load(path.to_s)
      end
      self
    end

    # Evaluate Javascript code within this page's context.
    #
    # @param [String] code
    #   javascript code to execute
    #
    # @return [Object]
    #   last javascript statement's value, cast to a ruby object
    #
    def execute_js(code)
      window.evaluate(code)
    end
    alias :x :execute_js

    # Convenience method, equivalent to the return value of
    # `page.execute_js('window.document')`
    #
    # @return [Object]
    #   document DOM object
    #
    def document
      window.document
    end

    # Page as html document
    #
    # @return [String] html
    #
    def to_html
      document.innerHTML
    end
    
    # Window factory
    #
    # @private
    class Window 
      extend Forwardable
      
      attr_reader :browser
      def_delegators :@browser, :load, :evaluate, :document
      
      def initialize(uri='about:blank')
        open(uri)
      end
      
      def run_time
        unless @run_time 
          @run_time = Johnson::Runtime.new
          @run_time.extend Envjs::Runtime
        end
        @run_time
      end
      
      def open(uri)
        @browser = run_time.evaluate("window.open('#{uri}')")
      end
      
      def self.from_uri(uri)
        new(uri)
      end

      def self.from_document(document)
        Tempfile.open('harmony') {|f| f << document; @path = f.path }
        new("file://#{@path}")
      end

      def self.blank
        new
      end
    end
  end
end

