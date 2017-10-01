class Verifier

  belongs_to :service
  has_many :runner_params

  validates :name, :parms, :group, :service, presence: true
  validates :runner, inclusion: { in: self.available_runners }


  def self.available_runners
    @@runner_types ||= load_runner_types
  end

  def run
    @@runner_types[runner].run(self)
  end

  private

  def load_runner_types
    @@runner_types = {}

    runner_classes.each do |runner_class|
      @@runner_types[runner_name_for(runner_class)] = runner_class
    end

    return @@runner_types
  end

  def runner_name_for(runner_class)
    runner_class.class.name.gsub('Runner', '').underscore
  end

  def runner_classes
    VerificationRunners.constants.select { |c| VerificationRunners.const_get(c).is_a? Class }
  end
end
