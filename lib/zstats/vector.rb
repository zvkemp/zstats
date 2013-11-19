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

    def table
      @table ||= calculate_table
    end

    def proportion_table
      @proportion_table ||= calculate_proportion_table
    end

    def percentage_table(digits = 1)
      Hash[proportion_table.map {|k,v| [k, (v * 100).round(digits)] }]
    end

    def size
      @size ||= base_vector.size
    end
    alias_method :count, :size

    def normalize(options = {})
      lmin = options.fetch(:min){ min }
      lmax = options.fetch(:max){ max }

      to_a.map {|x| ((x.to_f - lmin) / (lmax - lmin)) }
    end

    def scale # z-score
      @scaled ||= to_a.map(&method(:z_score))
    end

    private
      def z_score(x)
        (x - mean) / standard_deviation
      end

      def calculate_table
        Hash[to_a.group_by {|x| x }.map {|k,v| [k, v.count] }]
      end

      def calculate_proportion_table
        Hash[table.map {|k,v| [k, v.to_f/size]}]
      end


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
