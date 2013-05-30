require 'test_helper'

class MappingTest < ActiveSupport::TestCase
  setup do
    @site = FactoryGirl.create(:site)
  end
  test 'is invalid without a site' do
    refute FactoryGirl.build(:mapping, site: nil).valid?
  end
  test 'is invalid without a path' do
    refute FactoryGirl.build(:mapping, path: nil).valid?
  end
  test 'is invalid if the path would bust the field length of the db' do
    mapping = FactoryGirl.build(:mapping, path: 'a'*1024)
    assert mapping.valid?
    mapping.path += 'a'
    refute mapping.valid?
  end
  test 'is invalid without a http status' do
    refute FactoryGirl.build(:mapping, http_status: nil).valid?
  end
  test 'is invalid if the http status would bust the field length of the db' do
    mapping = FactoryGirl.build(:mapping, http_status: '123')
    assert mapping.valid?
    mapping.http_status += '4'
    refute mapping.valid?
  end
  test 'is invalid if the set of data already exists (site, path)' do
    exists = FactoryGirl.create(:mapping)
    dupe = FactoryGirl.build(:mapping, site: exists.site,
                                       path: exists.path)
    refute dupe.valid?
  end
  test 'it can leave uniqueness checking up to the db' do
    exists = FactoryGirl.create(:mapping)
    Mapping.leave_uniqueness_check_to_db = true
    dupe = FactoryGirl.build(:mapping, site: exists.site,
                                       path: exists.path)
    begin
      assert dupe.valid?
      assert_raises(ActiveRecord::RecordNotUnique) { dupe.save }
    ensure
      Mapping.leave_uniqueness_check_to_db = false
    end
  end
  test 'is invalid if the new url would bust the field length of the db' do
    mapping = FactoryGirl.build(:mapping, new_url: 'a' * (64.kilobytes - 1))
    assert mapping.valid?
    mapping.new_url += 'a'
    refute mapping.valid?
  end
  test 'is invalid if the suggested url would bust the field length of the db' do
    mapping = FactoryGirl.build(:mapping, suggested_url: 'a' * (64.kilobytes - 1))
    assert mapping.valid?
    mapping.suggested_url += 'a'
    refute mapping.valid?
  end
  test 'is invalid if the archive url would bust the field length of the db' do
    mapping = FactoryGirl.build(:mapping, archive_url: 'a' * (64.kilobytes - 1))
    assert mapping.valid?
    mapping.archive_url += 'a'
    refute mapping.valid?
  end

  test 'sets a hash of the path (for unique index purposes) when validating' do
    mapping = FactoryGirl.build(:mapping)
    assert mapping.path_hash.nil?
    mapping.valid?
    refute mapping.path_hash.nil?
  end

  test '#with_status filters to include only the supplied status' do
    mapping1 = FactoryGirl.create(:mapping, path: '/woo', http_status: '200')
    mapping2 = FactoryGirl.create(:mapping, path: '/hoo', http_status: '301')
    mapping3 = FactoryGirl.create(:mapping, path: '/moo', http_status: '404')
    mapping4 = FactoryGirl.create(:mapping, path: '/boo', http_status: '200')

    assert_equal [mapping2], Mapping.with_status('301')
    assert_equal [mapping1, mapping4], Mapping.with_status('200')
  end

  test '#with_status filters fetches everything if the supplied status is "all"' do
    mapping1 = FactoryGirl.create(:mapping, path: '/woo', http_status: '200')
    mapping2 = FactoryGirl.create(:mapping, path: '/hoo', http_status: '301')
    mapping3 = FactoryGirl.create(:mapping, path: '/moo', http_status: '404')

    assert_equal [mapping1, mapping2, mapping3], Mapping.with_status('all')
  end

end
