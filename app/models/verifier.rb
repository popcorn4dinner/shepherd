class Verifier

  belongs_to :service

  validates :name, :url, presence: true
  validates :type, inclusion: { in: self.allowed_types }
  validates :runner, inclusion: { in: self.available_runners }

  @@runner_types = []
  
  def self.allowed_types
    [:smoke_test, :functional_test]
  end

  def self.available_runners
    @@runner_types || load_runner_types
  end

  private

  def load_runner_types
    VerificationRunners.constants.select {|c| VerificationRunners.const_get(c).is_a? Class}
  end

end
