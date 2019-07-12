module OpenscapParser
  module TestResult
    def self.included(base)
      base.class_eval do
        private

        def test_result_node
          @test_result_node ||= @report_xml.at_css('TestResult')
        end
      end
    end
  end
end
