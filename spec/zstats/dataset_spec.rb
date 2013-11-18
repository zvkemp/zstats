require_relative '../spec_helper'

describe ZStats::Dataset do
  it 'exists' do
    ZStats::Dataset.wont_be_nil
  end

  describe "rows and columns" do
    let(:data){[
      [1,2,3,4],
      [5,6,7,8],
      [9,10,11,12],
      [13,14,15,16]
    ]}

    let(:dataset){ ZStats::Dataset.new(data, header: false) }

    it "stores the data in a matrix" do
      dataset.data.must_be_instance_of Matrix
    end

    it "has accessible rows as vectors" do
      v = dataset.row(0)
      v.must_be_instance_of ZStats::Vector
      v.base_vector.must_equal Vector[1,2,3,4]
    end

    it "has accessible columns as vectors" do
      v = dataset.column(2)
      v.must_be_instance_of ZStats::Vector
      v.base_vector.must_equal Vector[3,7,11,15]
    end
  end

  describe "simple data" do
    let(:data){[
      %w[year price mileage color],
      [2001, 5000, 145000, 'green'],
      [2004, 5000, 145000, 'silver'],
      [2008, 5000, 145000, 'white'],
      [2003, 5000, 145000, 'black'],
      [2008, 5000, 145000, 'green'],
      [1999, 5000, 145000, 'silver'],
      [2007, 5000, 145000, 'black'],
      [1999, 5000, 145000, 'black'],
      [2000, 5000, 145000, 'white'],
      [2003, 5000, 145000, 'silver'],
      [2003, 5000, 145000, 'green'],
      [1999, 5000, 145000, 'black'],
    ]}

    let(:dataset){ ZStats::Dataset.new(data) }

    it 'strips the header row out' do
      dataset.row(0).to_a.must_equal [2001, 5000, 145000, 'green']
    end

    it 'makes the header accessible' do
      dataset.header.must_equal %w[year price mileage color]
    end

    it 'makes columns accessible by string reference' do
      dataset.column('year').to_a.must_equal(
        [2001, 2004, 2008, 2003, 2008, 1999, 2007, 1999, 2000, 2003, 2003, 1999])

      dataset.column('price').to_a.uniq.must_equal [5000]
      dataset.column('mileage').to_a.uniq.must_equal [145000]
    end
  end
end
