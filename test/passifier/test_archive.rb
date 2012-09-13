require 'helper'

class TestArchive < Test::Unit::TestCase

  def test_initialize
    archive = Helper.new_archive

    assert_not_nil archive
  end

  def test_data
    archive = Helper.new_archive
    assets = Helper.new_image_files
    archive.save(:scratch_directory => Helper.scratch_directory)

    assert File.exists?(Helper.zip_path)
    assert_equal File.size(Helper.zip_path), archive.data.size

    archive.destroy
  end

  def test_save
    archive = Helper.new_archive
    assets = Helper.new_image_files
    archive.save(:scratch_directory => Helper.scratch_directory)

    assert File.exists?(Helper.zip_path)
    assert File.size(Helper.zip_path) > 0

    archive.destroy
  end

  def test_destroy
    archive = Helper.new_archive
    assets = Helper.new_image_files
    archive.save(:scratch_directory => Helper.scratch_directory)

    assert File.exists?(Helper.zip_path)
    assert File.size(Helper.zip_path) > 0

    archive.destroy

    assert !File.exists?(Helper.zip_path)
  end

end

