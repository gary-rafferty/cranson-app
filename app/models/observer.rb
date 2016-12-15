class Observer
  def update(application)
    Plan.persist(application)
  end
end

