require 'helper'

class TestStorage < Test::Unit::TestCase

  def test_initialize
    storage = Helper.new_storage

    assert_not_nil storage
    assert_not_nil storage.scratch_directory
    assert_equal Helper.scratch_directory, storage.scratch_directory
  end

  def test_path
    storage = Helper.new_storage

    assert_equal "#{Helper.scratch_directory}/blah", storage.path("blah")
  end

  def test_ensure_directory_exists
    storage = Helper.new_storage
    dir = storage.send(:ensure_directory_exists)

    assert_not_nil dir
    assert_equal storage.scratch_directory + "/", dir
    assert File.exists?(storage.scratch_directory)
    assert File.directory?(storage.scratch_directory)

    storage.cleanup
  end

  def test_write_file
    storage = Helper.new_storage
    asset = storage.assets.first
    path = storage.path(asset.filename)
    storage.send(:ensure_directory_exists)
    storage.send(:write_file, asset)

    assert File.exists?(path)
    assert_equal File.size(path), asset.content.size

    storage.cleanup
  end

  def test_store
    storage = Helper.new_storage
    storage.store

    assert File.exists?(storage.scratch_directory)
    assert File.directory?(storage.scratch_directory)
    Helper.new_image_files.each do |asset|
      path = storage.path(asset.filename)
      assert File.exists?(path)
      assert_equal File.size(path), asset.content.size
    end

    storage.cleanup
  end

  def test_remove_temp_files
    storage = Helper.new_storage
    storage.store

    assert File.exists?(storage.scratch_directory)
    assert File.directory?(storage.scratch_directory)

    paths = Helper.new_image_files.map do |asset|
      path = storage.path(asset.filename)
      assert File.exists?(path)
      assert_equal File.size(path), asset.content.size
      path
    end.compact
    
    storage.send(:remove_temp_files)

    paths.each { |path| assert !File.exists?(path) }

    storage.cleanup
  end

  def test_remove_directory
    storage = Helper.new_storage
    storage.store

    assert File.exists?(storage.scratch_directory)
    assert File.directory?(storage.scratch_directory)

    paths = Helper.new_image_files.map do |asset|
      path = storage.path(asset.filename)
      assert File.exists?(path)
      assert_equal File.size(path), asset.content.size
      path
    end.compact
    
    storage.send(:remove_temp_files)

    paths.each { |path| assert !File.exists?(path) }

    storage.send(:remove_directory)

    assert !File.exists?(storage.scratch_directory)

    storage.cleanup
  end

  def test_cleanup
    storage = Helper.new_storage
    storage.store

    assert File.exists?(storage.scratch_directory)
    assert File.directory?(storage.scratch_directory)

    paths = Helper.new_image_files.map do |asset|
      path = storage.path(asset.filename)
      assert File.exists?(path)
      assert_equal File.size(path), asset.content.size
      path
    end.compact
    
    storage.cleanup

    paths.each { |path| assert !File.exists?(path) }

    assert !File.exists?(storage.scratch_directory)

    storage.cleanup
  end

  def test_zip
    storage = Helper.new_storage
    path = Helper.zip_path
    storage.store
    storage.zip(path)

    assert File.exists?(path)
    assert File.size(path) > 0

    storage.send(:remove_zip, path)
    storage.send(:remove_directory, "test/zip")
    storage.cleanup
  end

  def test_remove_zip
    storage = Helper.new_storage
    path = Helper.zip_path
    storage.store
    storage.zip(path)

    assert File.exists?(path)
  
    storage.send(:remove_zip, path)

    assert !File.exists?(path)

    storage.cleanup
  end

end
