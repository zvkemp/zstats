require_relative '../spec_helper'


describe ZStats::Vector do
  it 'exists' do
    ZStats::Vector.wont_be_nil
  end

  let(:data){
    Vector[
      16105, 30596, 8309, 36394, 27304, 43234, 4478, 44348, 12088, 
      606, 29604, 4308, 27969, 49295, 20353, 16129, 41679, 35607, 
      30227, 18199, 32697, 45146, 18914, 11078, 7585, 21642, 32103, 
      37731, 6453, 14857, 265, 47220, 46708, 40567, 42123, 12357, 
      39873, 49649, 2586, 31402, 3336, 22564, 505, 19005, 41777, 
      17056, 24174, 13351, 38036, 37716, 31873, 25547, 44302, 
      12504, 6447, 16426, 23614, 1729, 16007, 37535, 34128, 40859, 
      31072, 2958, 22189, 19428, 30750, 29172, 5521, 28401, 4268, 
      33746, 44578, 23774, 16705, 48398, 41366, 42573, 40587, 37144, 
      11506, 18510, 33949, 31282, 45503, 20195, 29414, 39784, 3956, 
      32990, 717, 17098, 49795, 21014, 24875, 45429, 47937, 3723, 16892, 817
    ]
  }

  let(:vector){ ZStats::Vector.new(data) }

  it "works" do
    vector.base_vector.must_equal data
  end

  it "returns a size" do
    vector.size.must_equal 100
    vector.count.must_equal 100
  end

  it "returns a mean value" do
    vector.mean.must_equal 25442.95
  end

  it "returns a median value" do
    vector.median.must_equal 26425.5
  end

  it "returns a standard deviation (population)" do
    vector.standard_deviation.must_be_within_delta 14729, 1
  end

  it "returns a standard deviation (sample)" do
    vector.standard_deviation(:sample).must_be_within_delta 14803, 1
  end

  it "returns a min" do
    vector.min.must_equal 265
  end

  it "returns a max" do
    vector.max.must_equal 49795
  end

  it "returns the population variance" do
    vector.variance.must_be_within_delta 216946703, 1
  end

  it "returns the sample variance" do
    vector.variance(:sample).must_be_within_delta 219138084, 1
  end
end