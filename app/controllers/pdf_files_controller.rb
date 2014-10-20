class PdfFilesController < ApplicationController
  require 'pdf_documents/pdf'

  before_action :get_user_document, :only => [:generate]
  before_action :get_user_documents, :only => [:index, :welcome]

  def index
  end

  def welcome
  end

  def generate
    PdfDocument::Pdf.new.generate @document
    @document.update :is_generated => true
    redirect_to pdf_files_path, :notice => 'Document complete'
  end

  def download
    if current_user.documents.exists?
      send_file PdfDocument::Pdf.new.get_zip current_user
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
