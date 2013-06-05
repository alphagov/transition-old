require 'test_helper'

class TotalTest < ActiveSupport::TestCase
  setup do
    @host = FactoryGirl.create(:host)
  end

  test 'normalizes total_on to the start of the day when validating (totals are date precise)' do
    total = FactoryGirl.build(:total, total_on: (1.day.ago.beginning_of_day + 10.minutes))
    total.valid?
    assert_equal 1.day.ago.beginning_of_day, total.total_on
  end

  test 'can generate the week in the form <4-digit-year>-W<2-digit-week-number> based on total on date' do
    t1 = FactoryGirl.create(:total, total_on: 5.days.ago)

    assert_equal 5.days.ago.strftime('%Y-W%U'), t1.week
  end

  test '#without_zero_status_totals rejects any statuses that are made completely of 0s' do
    t1 = FactoryGirl.create(:total, http_status: '0')
    t2 = FactoryGirl.create(:total, http_status: '00')
    t3 = FactoryGirl.create(:total, http_status: '000')
    t4 = FactoryGirl.create(:total, http_status: '01')
    t5 = FactoryGirl.create(:total, http_status: '001')
    t6 = FactoryGirl.create(:total, http_status: '100')

    without_zeroes = Total.without_zero_status_totals
    refute without_zeroes.include? t1
    refute without_zeroes.include? t2
    refute without_zeroes.include? t3

    assert without_zeroes.include? t4
    assert without_zeroes.include? t5
    assert without_zeroes.include? t6
  end

  test '#in_data_order sorts by date (ascending)' do
    t1 = FactoryGirl.create(:total, count: 9, http_status: '200', total_on: 3.days.ago)
    t2 = FactoryGirl.create(:total, count: 9, http_status: '201', total_on: 5.days.ago)

    in_order = Total.in_date_order
    assert_equal [t2, t1], in_order
  end

  test '#aggregated compresses all totals for the same status and date and sums their counts, regardless of host' do
    host1 = FactoryGirl.create(:host, host: 'host1')
    host2 = FactoryGirl.create(:host, host: 'host2')
    t1 = FactoryGirl.create(:total, count: 1, host: host1, http_status: '301', total_on: 1.day.ago)
    t2 = FactoryGirl.create(:total, count: 11, host: host2, http_status: '301', total_on: 1.day.ago)
    t3 = FactoryGirl.create(:total, count: 22, host: host1, http_status: '302', total_on: 1.day.ago)
    t4 = FactoryGirl.create(:total, count: 33, host: host1, http_status: '302', total_on: 2.days.ago)
    t5 = FactoryGirl.create(:total, count: 44, host: host2, http_status: '302', total_on: 2.days.ago)

    aggregated = Total.aggregated

    assert_equal 3, aggregated.length
    assert_equal 12, aggregated.detect { |t| t.http_status == '301' && t.total_on == 1.day.ago.beginning_of_day.to_date }.count
    assert_equal 22, aggregated.detect { |t| t.http_status == '302' && t.total_on == 1.day.ago.beginning_of_day.to_date }.count
    assert_equal 77, aggregated.detect { |t| t.http_status == '302' && t.total_on == 2.days.ago.beginning_of_day.to_date }.count
  end

  test '#aggregated results are Total instances without a host' do
    host = FactoryGirl.create(:host, host: 'host1')
    FactoryGirl.create(:total, count: 1, host: host, http_status: '301', total_on: 1.day.ago)

    assert_nil Total.aggregated.first.host
  end

  test '#aggregated_by_week compresses all totals for the same host, status and week of the year date and sums their counts' do
    host1 = FactoryGirl.create(:host, host: 'host1')
    host2 = FactoryGirl.create(:host, host: 'host2')

    start_of_week = Date.today.beginning_of_week

    t1 = FactoryGirl.create(:total, count: 1, host: host1, http_status: '301', total_on: start_of_week)
    t2 = FactoryGirl.create(:total, count: 11, host: host2, http_status: '301', total_on: start_of_week + 1.day)
    t3 = FactoryGirl.create(:total, count: 22, host: host1, http_status: '302', total_on: start_of_week)
    t4 = FactoryGirl.create(:total, count: 33, host: host1, http_status: '302', total_on: start_of_week + 2.days)
    t5 = FactoryGirl.create(:total, count: 44, host: host2, http_status: '302', total_on: start_of_week + 8.days)

    aggregated = Total.aggregated_by_week

    assert_equal 4, aggregated.length
    assert_equal 1,  aggregated.detect { |t| t.host_id == host1.id && t.http_status == '301' && t.week == start_of_week.strftime('%Y-W%U') }.count
    assert_equal 11, aggregated.detect { |t| t.host_id == host2.id && t.http_status == '301' && t.week == start_of_week.strftime('%Y-W%U') }.count
    assert_equal 55, aggregated.detect { |t| t.host_id == host1.id && t.http_status == '302' && t.week == start_of_week.strftime('%Y-W%U') }.count
    assert_equal 44, aggregated.detect { |t| t.host_id == host2.id && t.http_status == '302' && t.week == (start_of_week + 8.days).strftime('%Y-W%U') }.count
  end

  test '#aggregated_by_week results are Total instances without total on dates, but they do have a week and host' do
    host = FactoryGirl.create(:host, host: 'host1')
    start_of_week = Date.today.beginning_of_week
    FactoryGirl.create(:total, count: 1, host: host, http_status: '301', total_on: start_of_week)

    first_aggregated = Total.aggregated_by_week.first
    assert_raises(ActiveModel::MissingAttributeError) { first_aggregated.total_on }

    assert_equal start_of_week.strftime('%Y-W%U'), first_aggregated.week
    assert_equal host, first_aggregated.host
  end

  test '#aggregated_by_week_and_site compresses all totals for the same status and week of the year date and sums their counts, regardless of host' do
    host1 = FactoryGirl.create(:host, host: 'host1')
    host2 = FactoryGirl.create(:host, host: 'host2')

    start_of_week = Date.today.beginning_of_week

    t1 = FactoryGirl.create(:total, count: 1, host: host1, http_status: '301', total_on: start_of_week)
    t2 = FactoryGirl.create(:total, count: 11, host: host2, http_status: '301', total_on: start_of_week + 1.day)
    t3 = FactoryGirl.create(:total, count: 22, host: host1, http_status: '302', total_on: start_of_week)
    t4 = FactoryGirl.create(:total, count: 33, host: host1, http_status: '302', total_on: start_of_week + 2.days)
    t5 = FactoryGirl.create(:total, count: 44, host: host2, http_status: '302', total_on: start_of_week + 8.days)

    aggregated = Total.aggregated_by_week_and_site

    assert_equal 3, aggregated.length
    assert_equal 12,  aggregated.detect { |t| t.http_status == '301' && t.week == start_of_week.strftime('%Y-W%U') }.count
    assert_equal 55, aggregated.detect { |t| t.http_status == '302' && t.week == start_of_week.strftime('%Y-W%U') }.count
    assert_equal 44, aggregated.detect { |t| t.http_status == '302' && t.week == (start_of_week + 8.days).strftime('%Y-W%U') }.count
  end

  test '#aggregated_by_week_and_site results are Total instances without total on dates or hosts, but they do have a week' do
    host = FactoryGirl.create(:host, host: 'host1')
    start_of_week = Date.today.beginning_of_week
    FactoryGirl.create(:total, count: 1, host: host, http_status: '301', total_on: start_of_week)

    first_aggregated = Total.aggregated_by_week_and_site.first
    assert_raises(ActiveModel::MissingAttributeError) { first_aggregated.total_on }
    assert_nil first_aggregated.host

    assert_equal start_of_week.strftime('%Y-W%U'), first_aggregated.week
  end

  test '#max_weekly_count extracts the highest weekly count from the aggregate regardless of status (it must be told if the aggregate is a site-wide one)' do
    host1 = FactoryGirl.create(:host, host: 'host1')
    host2 = FactoryGirl.create(:host, host: 'host2')

    start_of_week = Date.today.beginning_of_week

    t1 = FactoryGirl.create(:total, count: 1, host: host1, http_status: '301', total_on: start_of_week)
    t2 = FactoryGirl.create(:total, count: 11, host: host2, http_status: '301', total_on: start_of_week + 1.day)
    t3 = FactoryGirl.create(:total, count: 22, host: host1, http_status: '302', total_on: start_of_week)
    t4 = FactoryGirl.create(:total, count: 33, host: host1, http_status: '302', total_on: start_of_week + 2.days)
    t5 = FactoryGirl.create(:total, count: 44, host: host2, http_status: '302', total_on: start_of_week + 8.days)

    # still respects hosts
    assert_equal 56, Total.aggregated_by_week.max_weekly_count
    # compresses hosts
    assert_equal 67, Total.aggregated_by_week_and_site.max_weekly_count(from_site_aggregate: true)
  end

  test '#max_weekly_count returns 0 if no data is available' do
    assert_equal 0, Total.aggregated_by_week.max_weekly_count
    assert_equal 0, Total.aggregated_by_week_and_site.max_weekly_count(from_site_aggregate: true)
  end

  test '#most_recent_total_on_date detects the biggest date' do
    t1 = FactoryGirl.create(:total, total_on: 2.days.ago)
    t2 = FactoryGirl.create(:total, total_on: 5.days.ago)
    t3 = FactoryGirl.create(:total, total_on: 1.day.ago)

    assert_equal 1.day.ago.beginning_of_day.to_date, Total.most_recent_total_on_date
  end

  test '#most_recent_total_on_date returns today if no totals' do
    Total.destroy_all

    assert_equal Date.today, Total.most_recent_total_on_date
  end

  test '#most_recent_total_on_date returns supplied fallback date if no totals' do
    Total.destroy_all

    assert_equal 10.days.ago.to_date, Total.most_recent_total_on_date(fallback_date: 10.days.ago.to_date)
  end

  test '#most_recent_total_on_date detects the biggest date from aggregated scopes correctly (when told the scope is aggregated)' do
    host1 = FactoryGirl.create(:host, host: 'host1')
    host2 = FactoryGirl.create(:host, host: 'host2')
    t1 = FactoryGirl.create(:total, count: 1, host: host1, http_status: '301', total_on: 3.days.ago)
    t2 = FactoryGirl.create(:total, count: 11, host: host2, http_status: '301', total_on: 3.days.ago)
    t3 = FactoryGirl.create(:total, count: 22, host: host1, http_status: '302', total_on: 3.days.ago)
    t4 = FactoryGirl.create(:total, count: 33, host: host1, http_status: '302', total_on: 2.days.ago)
    t5 = FactoryGirl.create(:total, count: 44, host: host1, http_status: '302', total_on: 1.days.ago)
    t6 = FactoryGirl.create(:total, count: 55, host: host2, http_status: '302', total_on: 2.days.ago)

    assert_equal 1.day.ago.beginning_of_day.to_date, Total.aggregated.most_recent_total_on_date(from_aggregate: true)
  end

  test '#most_recent_total_on_date returns today if no totals even if the scope is aggregated' do
    Total.destroy_all

    assert_equal Date.today, Total.most_recent_total_on_date(from_aggregate: true)
  end

  test '#most_recent_total_on_date returns supplied fallback date if no totals even if the scope is aggregated' do
    Total.destroy_all

    assert_equal 10.days.ago.to_date, Total.most_recent_total_on_date(from_aggregate: true, fallback_date: 10.days.ago.to_date)
  end

  test '#most_recent_totals takes totals for the most_recent_total_on_date if no date is supplied' do
    t1 = FactoryGirl.create(:total, total_on: 2.days.ago)
    t2 = FactoryGirl.create(:total, total_on: 5.days.ago)
    t3 = FactoryGirl.create(:total, http_status: '301', total_on: 1.day.ago)
    t4 = FactoryGirl.create(:total, http_status: '302', total_on: 1.day.ago)

    assert_equal [t3, t4], Total.most_recent_totals
  end

  test '#most_recent_totals takes totals for the supplied date' do
    t1 = FactoryGirl.create(:total, total_on: 2.days.ago)
    t2 = FactoryGirl.create(:total, total_on: 5.days.ago)
    t3 = FactoryGirl.create(:total, http_status: '301', total_on: 1.day.ago)
    t4 = FactoryGirl.create(:total, http_status: '302', total_on: 1.day.ago)

    assert_equal [t2], Total.most_recent_totals(5.days.ago.beginning_of_day.to_date)
  end

end
