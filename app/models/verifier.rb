class Verifier < ApplicationRecord

  belongs_to :service
  has_many :runner_params

  validates :name, :group, :service, presence: true
  validates_inclusion_of  :runner_name, in: -> { self.available_runners }

  validates_associated :runner_params
  validate :presence_of_required_runner_params

  def run
    runner.run(self)
  end

  def self.available_runners
    self.runners.keys
  end

  private

  def presence_of_required_runner_params
    runner.required_parameters.each do |parameter_name|
       errors.add(:runner_params, "#{parameter_name} is missing for runner '#{runner_name}'")
    end
  end

  def runner
    self.class.runners[runner_name]
  end

  def self.runners
    @@runner_types ||= self.load_runner_types
  end

  def self.load_runner_types
    @@runner_types = {}

    self.runner_classes.each do |runner_class|

      as
      @@runner_types[self.runner_name_for(runner_class)] = runner_class
    end

    return @@runner_types
  end

  def self.runner_name_for(runner_class)
    self.runner_class.class.name.gsub('Runner', '').underscore
  end

  def self.runner_classes
    VerificationRunners.constants.select { |c| VerificationRunners.const_get(c).is_a? Class }
  end



end
