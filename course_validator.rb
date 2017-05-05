require_relative 'graph'

class CourseValidator
  def initialize(file_path)
    @nodes = []
    File.readlines(file_path)[1..-1].each do |line|
      @nodes << line.split(' ')
    end
  end

  def course_valid?
    graph.acyclic?
  end

  def get_order
    graph.order
  end

private
  
  def graph
    @graph ||= Graph.new(@nodes)
  end
end