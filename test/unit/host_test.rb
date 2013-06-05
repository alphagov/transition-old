require 'test_helper'

class HostTest < ActiveSupport::TestCase

  test 'a host without a cname is not gds_managed' do
    refute Host.new(cname: nil).gds_managed?
  end

  test 'a host with a cname that ends with the gds cname is gds_managed' do
    assert Host.new(cname: "ministry-of-funk.www#{Host::GDS_CNAME}").gds_managed?
  end

  test 'a host with a cname that includes, but does not end with the gds cname is not gds_managed' do
    refute Host.new(cname: "ministry-of-funk.www#{Host::GDS_CNAME}.sneaky.mitm.attacker.org.").gds_managed?
  end
end
