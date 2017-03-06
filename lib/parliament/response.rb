require 'forwardable'

module Parliament
  class Response
    include Enumerable
    extend Forwardable
    attr_reader :nodes
    def_delegators :@nodes, :size, :each, :select, :map, :select!, :map!, :count, :length, :[], :empty?, :last

    def initialize(nodes)
      @nodes = nodes
    end

    def filter(*types)
      filtered_objects = Array.new(types.size) { [] }

      unless types.empty?
        @nodes.each do |node|
          type_index = types.index(node.type)
          filtered_objects[type_index] << node unless type_index.nil?
        end
      end

      result = build_responses(filtered_objects)

      types.size == 1 ? result.first : result
    end

    def build_responses(filtered_objects)
      result = []

      filtered_objects.each do |objects|
        result << Parliament::Response.new(objects)
      end
      result
    end

    def sort_by(*parameters)
      rejected = []
      grom_nodes = @nodes.dup
      grom_nodes.delete_if { |node| rejected << node unless parameters.all? { |param| node.respond_to?(param) } }
      grom_nodes.sort_by! do |node|
        parameters.map do |param|
          node.send(param).is_a?(String) ? I18n.transliterate(node.send(param)).downcase : node.send(param)
        end
      end

      rejected.concat(grom_nodes)
    end
  end
end
