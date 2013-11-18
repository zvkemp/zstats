module ZStats
  class Dataset
    require 'forwardable'
    require 'matrix'

    attr_reader :data, :options, :metadata
    def initialize(data, options = {})
      if options.fetch(:header){ true }
        @data     = Matrix[*Array(data)[1..-1]]
        @metadata = ZStats::Metadata.new(data[0])
      else
        @data = Matrix[*Array(data)]
      end
    end

    def header
      metadata.ary
    end

    def column(reference)
      ZStats::Vector.new(data_column(reference))
    end

    def row(reference)
      ZStats::Vector.new(data_row(reference))
    end

    private
      def data_column(reference)
        return data.column(reference) if reference.is_a? Fixnum
        data.column(metadata.ary.index(reference))
      end

      def data_row(reference)
        data.row(reference)
      end
  end
end