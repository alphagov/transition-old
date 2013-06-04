require 'test_helper'
require 'organisation_manages_own_redirects_flagger'

class OrganisationManagesOwnRedirectsFlaggerTest < ActiveSupport::TestCase

  test 'an organisation in the supplied scope has its manages_own_redirects flag set to false if it has no hosts' do
    o = FactoryGirl.create(:organisation, manages_own_redirects: true)
    OrganisationManagesOwnRedirectsFlagger.new(Organisation.where(id: o.id)).flag!
    o.reload
    refute o.manages_own_redirects?
  end

  test 'an organisation in the supplied scope has its manages_own_redirects flag set to false if it has hosts and all of them are gds_managed?' do
    o = FactoryGirl.create(:organisation, manages_own_redirects: true)
    s = FactoryGirl.create(:site, organisation: o)
    h1 = FactoryGirl.create(:gds_managed_host, site: s)
    h2 = FactoryGirl.create(:gds_managed_host, site: s)
    OrganisationManagesOwnRedirectsFlagger.new(Organisation.where(id: o.id)).flag!
    o.reload
    refute o.manages_own_redirects?
  end

  test 'an organisation in the supplied scope has its manages_own_redirects flag set to false if it has hosts and any of them are not gds_managed?' do
    o = FactoryGirl.create(:organisation, manages_own_redirects: false)
    s = FactoryGirl.create(:site, organisation: o)
    h1 = FactoryGirl.create(:gds_managed_host, site: s)
    h2 = FactoryGirl.create(:host, site: s)
    h3 = FactoryGirl.create(:gds_managed_host, site: s)
    OrganisationManagesOwnRedirectsFlagger.new(Organisation.where(id: o.id)).flag!
    o.reload
    assert o.manages_own_redirects?
  end

  test 'an organisation not in the supplied scope does not have its manages_own_redirects flag manipulated' do
    o = FactoryGirl.create(:organisation, manages_own_redirects: true)
    OrganisationManagesOwnRedirectsFlagger.new(Organisation.where(id: o.id+1)).flag!
    o.reload
    assert o.manages_own_redirects?
  end

end
