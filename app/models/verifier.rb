class Verifier < ApplicationRecord

  belongs_to :service, inverse_of: :verifiers
  has_many :runner_params, autosave: true

  validates :name, :group, presence: true
  validates_inclusion_of  :runner_name, in: Proc.new { self.available_runners }

  accepts_nested_attributes_for :runner_params
  validates_associated :runner_params
  # validate :presence_of_required_runner_params

  @@runner_types = nil

  def run
    runner.run(self)
  end

  def self.available_runners
    self.runners
  end

  private

  def presence_of_required_runner_params
    if runner.respond_to? :required_parameters
      runner.required_parameters.each do |parameter_name|
        errors.add(:runner_params, "#{parameter_name} is missing for runner '#{runner_name}'") if runner_params.find_by(name: parameter_name).nil?
      end
    end
  end

  def runner
    self.class.runners[runner_name]
  end

  def self.runners
    @@runner_types ||= self.load_runner_types
  end

  def self.load_runner_types
    self.runner_classes.map { |runner_class| [self.runner_name_for(runner_class), "VerificationRunners::#{runner_class}".constantize]}.to_h
  end

  def self.runner_name_for(runner_class)
    runner_class.to_s.gsub('Runner', '').underscore
  end

  def self.runner_classes
    Dir.glob(File.join(Rails.root, "app", "models", "verification_runners", "*")).collect{|file_path| File.basename(file_path, '.rb')}.map{|n| n.camelize}
  end

end
