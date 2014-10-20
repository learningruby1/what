class PdfFilesController < ApplicationController
  require 'pdf_documents/pdf'
  require 'zip'

  before_action :get_user_document, :only => [:generate]
  before_action :get_user_documents, :only => [:index, :welcome]

  def index
  end

  def welcome
  end

  def generate
    PdfDocument::Pdf.new.generate @document, current_user
    @document.update :is_generated => true
    redirect_to pdf_files_path, :notice => 'Document complete'
  end

  def download
    if current_user.documents.exists?
      folder = "#{ Rails.root }/documents/pdf/#{ current_user.id }"
      zipfile_name = "#{ Rails.root }/documents/pdf/files#{ current_user.id }.zip"
      File.delete(zipfile_name) if File.exists? zipfile_name
      Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
        Dir.foreach(folder) do |item|
          item_path = "#{ folder }/#{ item }"
          zipfile.add(item, item_path) if File.file? item_path
        end
      end
      send_file zipfile_name
    else
      redirect_to pdf_files_path
    end
  end

  private
  def get_user_document
    @document = current_user.documents.find(params[:document_id])
  end

  def get_user_documents
    @documents = current_user.documents.where(:template => 1)
  end
end
