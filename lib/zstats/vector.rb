module ZStats
  class Vector
    attr_reader :base_vector
    def initialize(base_vector)
      @base_vector = base_vector.freeze
    end

    def to_a
      @to_a ||= base_vector.to_a
    end

    def mean
      @mean ||= sum / count.to_f
    end

    def median
      @median ||= calculate_median
    end

    def min
      sorted_array.first
    end

    def max
      sorted_array.last
    end

    def variance(variance_method = :population)
      send("#{variance_method}_variance")
    end

    def standard_deviation(variance_method = :population)
      Math.sqrt(variance(variance_method))
    end

    def size
      @size ||= base_vector.size
    end
    alias_method :count, :size

    private
      def calculate_median
        (sorted_array[(size - 1)/2] + sorted_array[size/2])/2.0
      end

      def population_variance
        @population_variance ||= calculate_population_variance
      end
      def calculate_population_variance
        ZStats::Vector.new(to_a.map {|x| (x - mean) ** 2 }).mean
      end

      def sample_variance
        @sample_variance ||= calculate_sample_variance
      end
      def calculate_sample_variance
        ZStats::Vector.new(to_a.map {|x| (x - mean) ** 2 }).send(:sample_variance_mean)
      end
      def sample_variance_mean
        sum / (count.to_f - 1)
      end

      def sum
        @sum ||= to_a.inject(:+)
      end

      def sorted_array
        @sorted_array ||= to_a.sort
      end

  end
end