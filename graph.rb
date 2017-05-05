require_relative 'cyclic_graph'

class Graph
	def initialize(nodes)
		@nodes = Hash[nodes.group_by(&:first).map { |k, a| [k, a.map(&:last)] }]
		@order = []
	end

  def order
    acyclic? ? @order : []
  end

	def acyclic?
		@acyclic ||= begin
			tsort
			true
		rescue CyclicGraph
			false
		end
	end

private

  def tsort
    no_incoming_vertices = get_vertices_with_no_incoming_edges
    while no_incoming_vertices.any?
      current_vertex = no_incoming_vertices.pop
      @order << current_vertex
      nodes_from_current_vertices = @nodes[current_vertex]
      if nodes_from_current_vertices
        nodes_from_current_vertices.each do |vertex_from_current|
          @nodes[current_vertex].delete(vertex_from_current)
          if @nodes.values.none? { |vertices_array| vertices_array.include?(vertex_from_current) }
            no_incoming_vertices << vertex_from_current
          end
        end
      end
    end
    raise CyclicGraph if @nodes.values.any?(&:any?)
  end

	def get_vertices_with_no_incoming_edges
    flattened_values = @nodes.values.flatten.uniq
	  all_vertices = (@nodes.keys + flattened_values).uniq
    (all_vertices - flattened_values).uniq
	end
end