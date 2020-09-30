# frozen_string_literal: true

class User < ActiveRecord::Base
  include Sunrise::Models::User
  include PublicActivity::Model

  # Include default devise modules.
  devise :database_authenticatable, :confirmable, :lockable, :timeoutable,
         :recoverable, :rememberable, :trackable, :validatable

  fileuploads :avatar

  tracked owner: ->(controller, _model) { controller.try(:current_user) }
end
