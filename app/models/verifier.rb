# frozen_string_literal: true

class Verifier < ApplicationRecord
  belongs_to :service, inverse_of: :verifiers
  has_many :runner_params, autosave: true

  validates :name, :group, presence: true
  validates_inclusion_of :runner_name, in: proc { available_runners }

  accepts_nested_attributes_for :runner_params
  validates_associated :runner_params
  # validate :presence_of_required_runner_params

  @@runner_types = nil

  def run
    runner.run(self)
  end

  def self.available_runners
    runners
  end

  private

  def presence_of_required_runner_params
    return true unless runner.respond_to? :required_parameters

    runner.required_parameters.each do |parameter|
      unless runner_param_for? parameter
        errors.add :runner_params, "#{parameter} is missing for runner '#{runner_name}'"
      end
    end
  end

  def runner_param_for?(parameter)
    runner_params.find_by(name: parameter).nil?
  end

  def runner
    self.class.runners[runner_name]
  end

  def self.runners
    @@runner_types ||= load_runner_types
  end

  def self.load_runner_types
    runner_classes.map { |runner_class| [runner_name_for(runner_class), "VerificationRunners::#{runner_class}".constantize] }.to_h
  end

  def self.runner_name_for(runner_class)
    runner_class.to_s.gsub('Runner', '').underscore
  end

  def self.runner_classes
    Dir.glob(File.join(Rails.root, 'app', 'business', 'verification_runners', '*')).collect { |file_path| File.basename(file_path, '.rb') }.map(&:camelize)
  end
end
