require_relative '../spec_helper'


describe ZStats::Vector do
  it 'exists' do
    ZStats::Vector.wont_be_nil
  end
  
  let(:vector){ ZStats::Vector.new(data) }
  
  describe "linear data" do
    let(:data){
      Vector[
        16105, 30596, 8309, 36394, 27304, 43234, 4478, 44348, 12088, 
        606, 29604, 4308, 27969, 49295, 20353, 16129, 41679, 35607, 
        30227, 18199, 32697, 45146, 18914, 11078, 7585, 21642, 32103, 
        37731, 6453, 14857, 265, 47220, 46708, 40567, 42123, 12357, 
        39873, 49649, 2586, 31402, 3336, 22564, 505, 19005, 41777, 
        17056, 24174, 13351, 38036, 37716, 31873, 25547, 44302, 
        12504, 6447, 16426, 23614, 1729, 16426, 37535, 34128, 40859, 
        31072, 2958, 22189, 19428, 30750, 29172, 5521, 28401, 4268, 
        33746, 44578, 23774, 16705, 48398, 41366, 42573, 40587, 37144, 
        11506, 18510, 33949, 31282, 45503, 20195, 29414, 39784, 3956, 
        32990, 717, 17098, 49795, 21014, 24875, 45429, 47937, 3723, 16892, 817
      ]
    }


    it "works" do
      vector.base_vector.must_equal data
    end

    it "returns a size" do
      vector.size.must_equal 100
      vector.count.must_equal 100
    end

    it "returns a mean value" do
      vector.mean.must_equal 25447.14
    end

    it "returns a median value" do
      vector.median.must_equal 26425.5
    end

    it "returns a standard deviation (population)" do
      vector.standard_deviation.must_be_within_delta 14726, 1
    end

    it "returns a standard deviation (sample)" do
      vector.standard_deviation(:sample).must_be_within_delta 14800, 1
    end

    it "returns a min" do
      vector.min.must_equal 265
    end

    it "returns a max" do
      vector.max.must_equal 49795
    end

    it "returns the population variance" do
      vector.variance.must_be_within_delta 216869368, 1
    end

    it "returns the sample variance" do
      vector.variance(:sample).must_be_within_delta 219059967, 1
    end

    it "returns a table" do
      vector.table.must_be_instance_of Hash
      vector.table.keys.uniq.sort.must_equal vector.send(:sorted_array).uniq
      vector.table.values.uniq.must_equal [1,2]
    end

    it "returns a proportion table" do
      vector.proportion_table.must_be_instance_of Hash
      vector.proportion_table.values.uniq.sort.must_equal [0.01, 0.02]
      vector.proportion_table.values.inject(:+).must_be_within_delta 1, 0.000001
    end

    describe "scaling" do
      let(:v_index)   {->(n){ vector.to_a.index(n) }}
      let(:max_index) { v_index.(vector.max) }
      let(:min_index) { v_index.(vector.min) }

      it "normalizes based on present min max values" do
        n = vector.normalize
        n[max_index].must_equal 1.0
        n[min_index].must_equal 0.0
      end

      it "normalizes based on user-specified minimum" do
        n = vector.normalize(min: 0)
        n[max_index].must_equal 1.0
        n[min_index].must_be_within_delta 0.0053, 0.0001
      end

      it "normalizes based on user-specified maximum" do
        n = vector.normalize(max: 100000)
        n[max_index].must_be_within_delta 0.497, 0.001
        n[min_index].must_equal 0.0
      end

      it "normalizes based on user-specified min max" do
        n = vector.normalize(min: 0, max: 100000)
        n[max_index].must_equal 0.49795
        n[min_index].must_equal 0.00265
      end

      it "computes the z-scores" do
        z = vector.scale
        z[max_index].must_be_within_delta 1.65, 0.01
        z[min_index].must_be_within_delta -1.70, 0.01
        z[max_index].must_equal z.max
        z[min_index].must_equal z.min
      end
    end
  end

  describe "categorical data" do
    let(:data){[
      4, 3, 3, 1, 5, 5, 2, 2, 3, 2, 5, 5, 3, 5, 1, 5, 5, 1, 1, 4,
      5, 2, 3, 1, 1, 5, 1, 2, 3, 2, 2, 4, 2, 4, 1, 3, 2, 5, 4, 5,
      3, 1, 5, 5, 1, 1, 3, 1, 1, 5, 4, 5, 2, 4, 2, 1, 5, 3, 1, 1,
      3, 2, 4, 2, 4, 5, 2, 1, 5, 1, 4, 1, 2, 3, 3, 5, 4, 5, 2, 1,
      1, 1, 5, 2, 2, 2, 5, 1, 2, 1, 1, 1, 3, 4, 3, 3, 2, 5, 5, 4,
      1, 1, 1, 4, 2, 3, 2, 3, 5, 5, 3, 4, 1, 4, 3, 1, 2, 1, 3, 4,
      5, 4, 1, 4, 2, 5, 4, 2, 1, 5, 1, 2, 5, 2, 5, 5, 5, 2, 4, 3,
      5, 3, 5, 5, 3, 2, 3, 5, 4, 5, 1, 5, 1, 5, 3, 4, 5, 2, 1, 1,
      1, 1, 5, 4, 3, 5, 3, 1, 2, 5, 5, 3, 2, 5, 2, 3, 2, 5, 4, 3,
      2, 3, 5, 3, 3, 1, 3, 1, 2, 3, 3, 1, 1, 5, 1, 3, 2, 4, 5, 5,
      5, 2, 3, 2, 5, 2, 4, 1, 4, 4, 5, 3, 1, 4, 4, 5, 1, 2, 2, 2,
      3, 5, 4, 3, 2, 4, 2, 1, 2, 2, 5, 3, 2, 4, 3, 5, 3, 3, 2, 4,
      4, 4, 2, 1, 3, 2, 3, 2, 3, 1, 5, 5, 4, 1, 1, 1, 1, 3, 5, 4,
      4, 1, 5, 1, 3, 4, 2, 2, 4, 3, 4, 4, 2, 5, 3, 4, 3, 5, 5, 3,
      1, 5, 3, 1, 3, 5, 2, 1, 2, 5, 1, 2, 3, 1, 1, 1, 1, 2, 1, 3,
      4, 5, 3, 3, 1, 5, 4, 1, 3, 4, 2, 4, 1, 4, 2, 1, 1, 4, 3, 3,
      2, 5, 5, 4, 3, 3, 1, 4, 4, 2, 1, 2, 4, 4, 4, 3, 2, 4, 3, 4,
      3, 2, 2, 4, 4, 2, 5, 4, 5, 3, 1, 2, 5, 5, 2, 1, 5, 3, 3, 3,
      1, 4, 5, 4, 5, 5, 1, 5, 4, 2, 1, 4, 3, 5, 4, 4, 2, 1, 3, 4,
      5, 4, 1, 1, 4, 1, 1, 3, 2, 2, 1, 5, 5, 3, 4, 1, 5, 5, 3, 2,
      1, 4, 3, 2, 3, 5, 1, 4, 5, 5, 5, 4, 2, 2, 2, 1, 4, 4, 5, 1,
      2, 2, 5, 5, 3, 3, 4, 2, 5, 1, 4, 4, 5, 2, 1, 5, 4, 3, 4, 3,
      4, 3, 3, 1, 1, 3, 4, 4, 3, 1, 4, 4, 2, 3, 2, 2, 3, 4, 5, 4,
      5, 4, 5, 5, 5, 5, 3, 5, 1, 1, 5, 3, 3, 3, 2, 1, 3, 1, 4, 4,
      4, 5, 1, 5, 4, 4, 3, 2, 1, 2, 5, 1, 1, 2, 2, 4, 3, 1, 5, 2,
      2, 2, 5, 2, 3, 1, 4, 5, 2, 1, 1, 1, 1, 2, 1, 2, 2, 2, 2, 2,
      4, 3, 1, 5, 2, 5, 3, 3, 3, 3, 1, 2, 2, 5, 2, 3, 1, 5, 1, 1,
      3, 2, 2, 2, 5, 3, 1, 5, 1, 3, 4, 2, 2, 1, 5, 1, 5, 2, 2, 5,
      1, 4, 4, 3, 5, 5, 1, 5, 5, 1, 1, 5, 5, 1, 5, 1, 1, 3, 1, 2,
      3, 2, 4, 3, 2, 5, 3, 4, 1, 3, 2, 4, 3, 2, 1, 5, 3, 2, 3, 1,
      4, 3, 5, 2, 2, 3, 3, 2, 5, 2, 2, 3, 1, 4, 4, 3, 5, 5, 1, 2,
      1, 3, 3, 2, 5, 2, 1, 2, 5, 3, 4, 4, 5, 1, 5, 1, 2, 5, 5, 1,
      5, 5, 1, 3, 3, 1, 4, 1, 2, 1, 4, 3, 4, 2, 1, 5, 1, 5, 2, 5,
      3, 3, 4, 2, 2, 3, 4, 3, 5, 3, 5, 1, 3, 2, 5, 4, 5, 3, 5, 2
    ]}

    it "works" do
      vector.base_vector.must_equal data
    end

    it "returns a size" do
      vector.size.must_equal 680
      vector.count.must_equal 680
    end

    it "returns a mean value" do
      vector.mean.must_be_within_delta 2.97, 0.01
    end

    it "returns a median value" do
      vector.median.must_equal 3.0
    end

    it "returns a min" do
      vector.min.must_equal 1
    end

    it "returns a max" do
      vector.max.must_equal 5
    end

    describe "standard deviation" do
      it "returns a standard deviation (population)" do
        vector.standard_deviation.must_be_within_delta 1.448, 0.001
      end

      it "returns a standard deviation (sample)" do
        vector.standard_deviation(:sample).must_be_within_delta 1.45, 0.001
      end

      it "returns the population variance" do
        vector.variance.must_be_within_delta 2.09, 0.01
      end

      it "returns the sample variance" do
        vector.variance(:sample).must_be_within_delta 2.10, 0.01
      end
    end

    describe "tables" do
      it "returns a table" do
        vector.table.must_be_instance_of Hash
        vector.table.keys.uniq.sort.must_equal [1,2,3,4,5]
        vector.table.values.uniq.sort.must_equal [115, 134, 137, 145, 149]
      end

      it "returns a proportion table" do
        vector.proportion_table.must_be_instance_of Hash
        # vector.proportion_table.values.uniq.sort.must_equal [0.01, 0.02]
        vector.proportion_table.values.inject(:+).must_be_within_delta 1, 0.000001
      end

      it "returns a percentage table" do
        vector.percentage_table.must_be_instance_of Hash
        vector.percentage_table.values.inject(:+).must_be_within_delta 100, 0.1
      end
    end
  end
end