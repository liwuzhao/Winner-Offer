class Admin::BaseController < ApplicationController
  before_action :require_is_admin
  layout "admin"

end
