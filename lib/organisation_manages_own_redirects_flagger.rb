class OrganisationManagesOwnRedirectsFlagger
  def initialize(organisations_scope)
    @organisations_scope = organisations_scope
  end

  def flag!
    @organisations_scope.includes(:hosts).each do |organisation|
      organisation.manages_own_redirects = organisation.hosts.any? { |h| !h.gds_managed? }
      organisation.save
    end
  end
end
