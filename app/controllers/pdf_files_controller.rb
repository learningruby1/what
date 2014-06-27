class PdfFilesController < ApplicationController
  require 'pdf_documents/pdf'

  skip_filter :authenticate_user!
  before_action :get_user_document, :only => [:generate, :download]

  def index
    if user_signed_in?
      @documents = current_user.documents
    else
      @documents = Document.where(:session_uniq_token => cookies[:session_uniq_token])
    end
  end

  def generate
    PdfDocument::Pdf.new.generate @document
    @document.update :is_generated => true
    redirect_to pdf_files_path, :notice => 'Document complete'
  end

  def download
    send_file "documents/pdf/document_#{ @document.id }.pdf", :type => "application/pdf", :x_sendfile => true
  end

  private

  def get_user_document

    if user_signed_in?
      @document = current_user.documents.find(params[:document_id])
    else
      @document =  Document.where(:id => params[:document_id], :session_uniq_token => cookies[:session_uniq_token]).first
    end
  end
end
