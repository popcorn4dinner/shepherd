class Verifier

  belongs_to :service
  has_many :runner_params

  validates :name, :parms, :group, :service, presence: true
  validates :runner_name, inclusion: { in: self.available_runners.keys }

  validates_associated :runner_params
  validate :presence_of_required_runner_params


  def self.runner_types
    @@runner_types ||= load_runner_types
  end

  def run
    runner.run(self)
  end

  private

  def runner
    @@runner_types[runner_name]
  end

  def presence_of_required_runner_params
    runner.required_parameters.each do |parameter_name|
       errors.add(:runner_params, "#{parameter_name} is missing for runner '#{runner_name}'")
    end
  end

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
