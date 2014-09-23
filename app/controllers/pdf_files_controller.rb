class PdfFilesController < ApplicationController
  require 'pdf_documents/pdf'

  before_action :get_user_document, :only => [:generate]

  def index
    if user_signed_in?
      @documents = current_user.documents.where(:template => 1)
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
    if current_user.documents.where(:id => params[:filename].split('_').last.try(:to_i) || 0).exists?
      send_file "documents/pdf/#{ params[:filename] }.pdf", :type => "application/pdf", :x_sendfile => true
    else
      redirect_to pdf_files_path
    end
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
