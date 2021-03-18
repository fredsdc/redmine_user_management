# Redmine User Managerment - A Redmine Plugin
# Copyright (C) 2021  Frederico Camara
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

class UserManagementsController < ApplicationController
  before_action :user_manager?
  before_action :get_permissions

  helper :users

  def index
  end

  def new
    @user=User.new
    get_required_permissions
  end

  def create
    @user=User.new
    get_required_permissions
    @user.assign_attributes what_to_update

    if @user.save
      flash[:notice] = l(:notice_successful_create)
      redirect_to edit_user_management_path @user
    else
      get_required_permissions
      render :action => 'new'
    end
  end

  def edit
    @user=User.find(params[:id])
    block_user_admin
  end

  def update
    @user=User.find(params[:id])
    if block_user_admin
      if @user.update what_to_update
        flash[:notice] = l(:notice_successful_update)
        redirect_to edit_user_management_path @user
      else
        render :action => 'edit'
      end
    end
  end

  def autocomplete
    if params[:term].present?
      scope = Principal.where(type: "User", admin: false).preload(:email_address).like(params[:term])
    else
      scope = []
    end
    render :json => scope.collect{|p| {'id' => p.id, 'label' => p.name, 'value' => p.name}}
  end

  private

  def block_user_admin
    if @user.admin?
      render_403
      return false
    end
    true
  end

  def user_manager?
    if User.current.admin? || UserManager.all.map{|u| u.principals.map{ |p| p.type=="User" ? p.id : p.users.ids}}.flatten.include?(User.current.id)
      return true
    end
    render_403
    false
  end

  def get_permissions
    if User.current.admin?
      @perms={
        'login' => true, 'password' => true, 'name' => true, 'mail' => true, 'status' => true,
        'ucfs' => UserCustomField.all.collect(&:id),
        'groups' => Group.select{|g| ! g.builtin?}.collect(&:id)
      }
    else
      @perms={
        'login' => false, 'password' => false, 'name' => false, 'mail' => false, 'status' => false,
        'ucfs' => [],
        'groups' => []
      }
      UserManager.all.each do |um|
        if um.principals.map { |p| p.type=="User" ? p.id : p.users.ids}.flatten.include?(User.current.id)
          @perms['login']     = true if um.manage_login
          @perms['password']  = true if um.manage_password
          @perms['name']      = true if um.manage_name
          @perms['mail']      = true if um.manage_mail
          @perms['status']    = true if um.manage_status
          @perms['ucfs']     += um.user_custom_field_ids
          @perms['groups']   += um.group_ids
        end
      end
    end
  end

  def get_required_permissions
    @perms['login']  = true
    @perms['name']   = true
    @perms['mail']   = true
    @perms['ucfs']  += UserCustomField.select(&:is_required?).collect(&:id)
  end

  def what_to_update
    to_update={}
    to_update[:login]               = params[:user][:login]                 if @perms['login'] || @user.new_record?
    to_update[:generate_password]   = params[:user][:generate_password]     if @user.auth_source_id.nil? && @perms['password']
    to_update[:generate_password]   = true                                  if @user.new_record?
    to_update[:must_change_passwd]  = params[:user][:must_change_passwd]    if @user.auth_source_id.nil? && @perms['password']
    to_update[:firstname]           = params[:user][:firstname]             if @perms['name'] || @user.new_record?
    to_update[:lastname]            = params[:user][:lastname]              if @perms['name'] || @user.new_record?
    to_update[:mail]                = params[:user][:mail]                  if @perms['mail'] || @user.new_record?
    to_update[:status]              = params[:user][:status]
    to_update[:group_ids]           = @user.group_ids.map(&:to_s) - @perms['groups'].map(&:to_s) + (@perms['groups'].map(&:to_s) & params[:user][:group_ids])
    to_update[:custom_field_values] = @perms['ucfs'].map(&:to_s).select{|i| params[:user][:custom_field_values][i]}.map{|i| [i, params[:user][:custom_field_values][i]]}.to_h
    to_update
  end
end
