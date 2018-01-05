class Administrator < ApplicationRecord
  Config = YAML.load(ERB.new(File.read("#{Rails.root}/config/admin.yml")).result)[Rails.env]

  include MobileVerificationCode

  attr_accessor :current_password

  as_enum :role, admin: 0, operator: 1, super_admin: 2

  validates_presence_of :nickname

  def admin?
    role_cd==0||super_admin?
  end

  def inactive!
    update_attribute(:active, false)
  end

  def active!
    update_attribute(:active, true)
  end


end
