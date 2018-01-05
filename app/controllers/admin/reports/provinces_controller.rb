class Admin::Reports::ProvincesController < Admin::ApplicationController
 before_action :redirect_user,:redirect_super_admin
end