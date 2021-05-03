# -*- encoding : utf-8 -*-
require 'test_helper'

class Admin::WordsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => Word.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    Word.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Word.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to admin_word_url(assigns(:word))
  end

  def test_edit
    get :edit, :id => Word.first
    assert_template 'edit'
  end

  def test_update_invalid
    Word.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Word.first
    assert_template 'edit'
  end

  def test_update_valid
    Word.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Word.first
    assert_redirected_to admin_word_url(assigns(:word))
  end

  def test_destroy
    word = Word.first
    delete :destroy, :id => word
    assert_redirected_to admin_words_url
    assert !Word.exists?(word.id)
  end
end
