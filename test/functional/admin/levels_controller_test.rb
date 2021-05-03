# -*- encoding : utf-8 -*-
require 'test_helper'

class Admin::LevelsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => Level.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    Level.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Level.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to admin_level_url(assigns(:level))
  end

  def test_edit
    get :edit, :id => Level.first
    assert_template 'edit'
  end

  def test_update_invalid
    Level.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Level.first
    assert_template 'edit'
  end

  def test_update_valid
    Level.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Level.first
    assert_redirected_to admin_level_url(assigns(:level))
  end

  def test_destroy
    level = Level.first
    delete :destroy, :id => level
    assert_redirected_to admin_levels_url
    assert !Level.exists?(level.id)
  end
end
