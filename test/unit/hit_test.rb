require 'test_helper'

class HitTest < ActiveSupport::TestCase
  setup do
    @host = FactoryGirl.create(:host)
  end
  test 'is invalid without a host' do
    refute FactoryGirl.build(:hit, host: nil).valid?
  end
  test 'is invalid without a path' do
    refute FactoryGirl.build(:hit, path: nil).valid?
  end
  test 'is invalid if the path would bust the field length of the db' do
    h = FactoryGirl.build(:hit, path: 'a'*1024)
    assert h.valid?
    h.path += 'a'
    refute h.valid?
  end
  test 'is invalid without a http status' do
    refute FactoryGirl.build(:hit, http_status: nil).valid?
  end
  test 'is invalid if the http status would bust the field length of the db' do
    h = FactoryGirl.build(:hit, http_status: '123')
    assert h.valid?
    h.http_status += '4'
    refute h.valid?
  end
  test 'is invalid without a count' do
    refute FactoryGirl.build(:hit, count: nil).valid?
  end
  test 'is invalid if the count isn\'t a positive integer' do
    h = FactoryGirl.build(:hit, count: 'one')
    refute h.valid?
    h.count = -1
    refute h.valid?
    h.count = 1.3
    refute h.valid?
  end
  test 'is invalid without a hit on date' do
    refute FactoryGirl.build(:hit, hit_on: nil).valid?
  end
  test 'is invalid if the set of data already exists (host, path, status, hit on date) a http status' do
    exists = FactoryGirl.create(:hit)
    dupe = FactoryGirl.build(:hit, host: exists.host,
                                   http_status: exists.http_status,
                                   hit_on: exists.hit_on,
                                   path: exists.path)
    refute dupe.valid?
  end
  test 'sets a hash of the path (for unique index purposes) when validating' do
    hit = FactoryGirl.build(:hit)
    assert hit.path_hash.nil?
    hit.valid?
    refute hit.path_hash.nil?
  end
  test 'normalizes hit_on to the start of the day when validating (hits are date precise)' do
    hit = FactoryGirl.build(:hit, hit_on: (1.day.ago.beginning_of_day + 10.minutes))
    hit.valid?
    assert_equal 1.day.ago.beginning_of_day, hit.hit_on
  end

  test '#without_zero_status_hits rejects any statuses that are made completely of 0s' do
    h1 = FactoryGirl.create(:hit, http_status: '0')
    h2 = FactoryGirl.create(:hit, http_status: '00')
    h3 = FactoryGirl.create(:hit, http_status: '000')
    h4 = FactoryGirl.create(:hit, http_status: '01')
    h5 = FactoryGirl.create(:hit, http_status: '001')
    h6 = FactoryGirl.create(:hit, http_status: '100')

    without_zeroes = Hit.without_zero_status_hits
    refute without_zeroes.include? h1
    refute without_zeroes.include? h2
    refute without_zeroes.include? h3

    assert without_zeroes.include? h4
    assert without_zeroes.include? h5
    assert without_zeroes.include? h6
  end

  test '#in_count_order sorts by count (descending), then status, path (ascending) and date (descending)' do
    h1 = FactoryGirl.create(:hit, count: 10)
    h2 = FactoryGirl.create(:hit, count: 8, http_status: '300')
    h3 = FactoryGirl.create(:hit, count: 8, http_status: '500')
    h4 = FactoryGirl.create(:hit, count: 9, http_status: '200', path: 'z')
    h5 = FactoryGirl.create(:hit, count: 9, http_status: '200', path: 'a', hit_on: 5.days.ago)
    h6 = FactoryGirl.create(:hit, count: 9, http_status: '200', path: 'a', hit_on: 3.days.ago)

    in_order = Hit.in_count_order
    assert_equal [h1, h6, h5, h4, h2, h3], in_order
  end

  test '#aggregated compresses all hits for the same path, status and date and sums their counts, regardless of host' do
    host1 = FactoryGirl.create(:host, host: 'host1')
    host2 = FactoryGirl.create(:host, host: 'host2')
    h1 = FactoryGirl.create(:hit, count: 1, host: host1, path: '/', http_status: '301', hit_on: 1.day.ago)
    h2 = FactoryGirl.create(:hit, count: 11, host: host2, path: '/', http_status: '301', hit_on: 1.day.ago)
    h3 = FactoryGirl.create(:hit, count: 22, host: host1, path: '/', http_status: '302', hit_on: 1.day.ago)
    h4 = FactoryGirl.create(:hit, count: 33, host: host1, path: '/woo', http_status: '302', hit_on: 2.days.ago)
    h5 = FactoryGirl.create(:hit, count: 44, host: host1, path: '/', http_status: '302', hit_on: 2.days.ago)
    h6 = FactoryGirl.create(:hit, count: 55, host: host2, path: '/woo', http_status: '302', hit_on: 2.days.ago)

    aggregated = Hit.aggregated

    assert_equal 4, aggregated.length
    assert_equal 12, aggregated.detect { |h| h.path == '/' && h.http_status == '301' && h.hit_on == 1.day.ago.beginning_of_day.to_date}.count
    assert_equal 22, aggregated.detect { |h| h.path == '/' && h.http_status == '302' && h.hit_on == 1.day.ago.beginning_of_day.to_date}.count
    assert_equal 44, aggregated.detect { |h| h.path == '/' && h.http_status == '302' && h.hit_on == 2.days.ago.beginning_of_day.to_date}.count
    assert_equal 88, aggregated.detect { |h| h.path == '/woo' && h.http_status == '302' && h.hit_on == 2.days.ago.beginning_of_day.to_date}.count
  end

  test '#most_recent_hit_on_date detects the biggest date' do
    h1 = FactoryGirl.create(:hit, hit_on: 2.days.ago)
    h2 = FactoryGirl.create(:hit, hit_on: 5.days.ago)
    h3 = FactoryGirl.create(:hit, hit_on: 1.day.ago)

    assert_equal 1.day.ago.beginning_of_day.to_date, Hit.most_recent_hit_on_date
  end

  test '#most_recent_hit_on_date detects the biggest date from aggregated scopes correctly (when told the scope is aggregated)' do
    host1 = FactoryGirl.create(:host, host: 'host1')
    host2 = FactoryGirl.create(:host, host: 'host2')
    h1 = FactoryGirl.create(:hit, count: 1, host: host1, path: '/', http_status: '301', hit_on: 3.days.ago)
    h2 = FactoryGirl.create(:hit, count: 11, host: host2, path: '/', http_status: '301', hit_on: 3.days.ago)
    h3 = FactoryGirl.create(:hit, count: 22, host: host1, path: '/', http_status: '302', hit_on: 3.days.ago)
    h4 = FactoryGirl.create(:hit, count: 33, host: host1, path: '/woo', http_status: '302', hit_on: 2.days.ago)
    h5 = FactoryGirl.create(:hit, count: 44, host: host1, path: '/', http_status: '302', hit_on: 1.days.ago)
    h6 = FactoryGirl.create(:hit, count: 55, host: host2, path: '/woo', http_status: '302', hit_on: 2.days.ago)

    assert_equal 1.day.ago.beginning_of_day.to_date, Hit.aggregated.most_recent_hit_on_date(from_aggregate: true)
  end

  test '#most_recent_hits takes hits for the most_recent_hit_on_date if no date is supplied' do
    h1 = FactoryGirl.create(:hit, hit_on: 2.days.ago)
    h2 = FactoryGirl.create(:hit, hit_on: 5.days.ago)
    h3 = FactoryGirl.create(:hit, http_status: '301', hit_on: 1.day.ago)
    h4 = FactoryGirl.create(:hit, http_status: '302', hit_on: 1.day.ago)

    assert_equal [h3, h4], Hit.most_recent_hits
  end

  test '#most_recent_hits takes hits for the supplied date' do
    h1 = FactoryGirl.create(:hit, hit_on: 2.days.ago)
    h2 = FactoryGirl.create(:hit, hit_on: 5.days.ago)
    h3 = FactoryGirl.create(:hit, http_status: '301', hit_on: 1.day.ago)
    h4 = FactoryGirl.create(:hit, http_status: '302', hit_on: 1.day.ago)

    assert_equal [h2], Hit.most_recent_hits(5.days.ago.beginning_of_day.to_date)
  end
end
