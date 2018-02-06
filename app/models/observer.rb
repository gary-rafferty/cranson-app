class Observer

  def initialize(authority)
    @authority = authority
  end

  def update(application)
    Plan.persist(application, @authority)
  end
end

